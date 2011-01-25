Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1AYRWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:22:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:47067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1AYRWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Franck Bui-Huu <fbuihuu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/29] perf probe: Enable to put probe inline function call site
Date: Tue, 25 Jan 2011 15:21:46 -0200
Message-Id: <1295976112-2796-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Enable to put probe inline function call site. This will increase line-based
probe-ability.

<Without this patch>
$ ./perf probe -L schedule:48
<schedule:48>
                pre_schedule(rq, prev);

     50         if (unlikely(!rq->nr_running))
                        idle_balance(cpu, rq);

                put_prev_task(rq, prev);
                next = pick_next_task(rq);

     56         if (likely(prev != next)) {
                        sched_info_switch(prev, next);
                        trace_sched_switch_out(prev, next);
                        perf_event_task_sched_out(prev, next);

<With this patch>
$ ./perf probe -L schedule:48
<schedule:48>
     48         pre_schedule(rq, prev);

     50         if (unlikely(!rq->nr_running))
     51                 idle_balance(cpu, rq);

     53         put_prev_task(rq, prev);
     54         next = pick_next_task(rq);

     56         if (likely(prev != next)) {
     57                 sched_info_switch(prev, next);
     58                 trace_sched_switch_out(prev, next);
     59                 perf_event_task_sched_out(prev, next);

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110113124604.22426.48873.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   56 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 508c017..69215bf 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -280,6 +280,19 @@ static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 	return name ? (strcmp(tname, name) == 0) : false;
 }
 
+/* Get callsite line number of inline-function instance */
+static int die_get_call_lineno(Dwarf_Die *in_die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Word ret;
+
+	if (!dwarf_attr(in_die, DW_AT_call_line, &attr))
+		return -ENOENT;
+
+	dwarf_formudata(&attr, &ret);
+	return (int)ret;
+}
+
 /* Get type die */
 static Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
 {
@@ -463,27 +476,54 @@ typedef int (* line_walk_handler_t) (const char *fname, int lineno,
 				     Dwarf_Addr addr, void *data);
 
 struct __line_walk_param {
+	const char *fname;
 	line_walk_handler_t handler;
 	void *data;
 	int retval;
 };
 
-/* Walk on decl lines in given DIE */
+static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
+{
+	struct __line_walk_param *lw = data;
+	Dwarf_Addr addr;
+	int lineno;
+
+	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
+		lineno = die_get_call_lineno(in_die);
+		if (lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
+			lw->retval = lw->handler(lw->fname, lineno, addr,
+						 lw->data);
+			if (lw->retval != 0)
+				return DIE_FIND_CB_FOUND;
+		}
+	}
+	return DIE_FIND_CB_SIBLING;
+}
+
+/* Walk on lines of blocks included in given DIE */
 static int __die_walk_funclines(Dwarf_Die *sp_die,
 				line_walk_handler_t handler, void *data)
 {
-	const char *fname;
+	struct __line_walk_param lw = {
+		.handler = handler,
+		.data = data,
+		.retval = 0,
+	};
+	Dwarf_Die die_mem;
 	Dwarf_Addr addr;
-	int lineno, ret = 0;
+	int lineno;
 
 	/* Handle function declaration line */
-	fname = dwarf_decl_file(sp_die);
-	if (fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
+	lw.fname = dwarf_decl_file(sp_die);
+	if (lw.fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
 	    dwarf_entrypc(sp_die, &addr) == 0) {
-		ret = handler(fname, lineno, addr, data);
+		lw.retval = handler(lw.fname, lineno, addr, data);
+		if (lw.retval != 0)
+			goto done;
 	}
-
-	return ret;
+	die_find_child(sp_die, __die_walk_funclines_cb, &lw, &die_mem);
+done:
+	return lw.retval;
 }
 
 static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
-- 
1.6.2.5

