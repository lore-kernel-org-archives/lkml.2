Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0DBTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:09:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:38586 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab0DBTJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:09:20 -0400
Date: Fri, 2 Apr 2010 19:08:36 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100402165052.23551.75866.stgit@localhost6.localdomain6>
References: <20100402165052.23551.75866.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Correct error message for non-structure type
Message-ID: <tip-12e5a7ae475ccb2733d740ffb95d9ca0a18392da@git.kernel.org>
Git-Commit-ID: 12e5a7ae475ccb2733d740ffb95d9ca0a18392da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:08:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12e5a7ae475ccb2733d740ffb95d9ca0a18392da
Gitweb:     http://git.kernel.org/tip/12e5a7ae475ccb2733d740ffb95d9ca0a18392da
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 2 Apr 2010 12:50:53 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:35:43 +0200

perf probe: Correct error message for non-structure type

perf probe outputs incorrect error message when it is called with
non-existent field on a non-data structure local variable.

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
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100402165052.23551.75866.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
