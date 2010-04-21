Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0DUTu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:50:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab0DUTux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:50:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/4] perf probe: Fix to exit callback soon after finding
	too many probe points
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Wed, 21 Apr 2010 15:56:32 -0400
Message-ID: <20100421195632.24664.42598.stgit@localhost6.localdomain6>
In-Reply-To: <20100421195616.24664.89980.stgit@localhost6.localdomain6>
References: <20100421195616.24664.89980.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to exit callback soon after finding too many probe points.
Don't try to continue searching because it already failed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 tools/perf/util/probe-finder.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3e79775..57b51ca 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -922,6 +922,8 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 			 (uintmax_t)pf->addr);
 
 		param->retval = convert_probe_point(in_die, pf);
+		if (param->retval < 0)
+			return DWARF_CB_ABORT;
 	}
 
 	return DWARF_CB_OK;
@@ -1157,6 +1159,8 @@ static int line_range_funcdecl_cb(Dwarf_Die *sp_die, void *data)
 		return DWARF_CB_OK;
 
 	param->retval = line_range_add_line(src, lineno, lf->lr);
+	if (param->retval < 0)
+		return DWARF_CB_ABORT;
 	return DWARF_CB_OK;
 }
 


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
