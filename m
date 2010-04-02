Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0DBREK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0DBRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:03:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/4] [BUGFIX] perf probe: Correct error message for
	non-structure type
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 02 Apr 2010 12:50:53 -0400
Message-ID: <20100402165052.23551.75866.stgit@localhost6.localdomain6>
In-Reply-To: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
References: <20100402165031.23551.14034.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf probe outputs incorrect error message when it called with
non-exist field on a non-data structure local variable.

<Before>
 # perf probe vfs_read 'count.hoge'
  Fatal: Structure on a register is not supported yet.
 # perf probe vfs_read 'count->hoge'
  Fatal: Semantic error: hoge must be referred by '.'

This corrects the messsage.

<After>
 # perf probe vfs_read 'count.hoge'
  Fatal: count is not a data structure.
 # perf probe vfs_read 'count->hoge'
  Fatal: count is not a data structure.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/util/probe-finder.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index b44132e..59b0115 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -429,12 +429,20 @@ static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 		if (die_get_real_type(&type, &type) == NULL)
 			die("Failed to get a type information of %s.", varname);
 
+		/* Verify it is a data structure  */
+		if (dwarf_tag(&type) != DW_TAG_structure_type)
+			die("%s is not a data structure.", varname);
+
 		ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
 		if (*ref_ptr)
 			(*ref_ptr)->next = ref;
 		else
 			*ref_ptr = ref;
 	} else {
+		/* Verify it is a data structure  */
+		if (dwarf_tag(&type) != DW_TAG_structure_type)
+			die("%s is not a data structure.", varname);
+
 		if (field->ref)
 			die("Semantic error: %s must be referred by '.'",
 			    field->name);
@@ -442,10 +450,6 @@ static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			die("Structure on a register is not supported yet.");
 	}
 
-	/* Verify it is a data structure  */
-	if (dwarf_tag(&type) != DW_TAG_structure_type)
-		die("%s is not a data structure.", varname);
-
 	if (die_find_member(&type, field->name, &member) == NULL)
 		die("%s(tyep:%s) has no member %s.", varname,
 		    dwarf_diename(&type), field->name);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
