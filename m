Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1AMMxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:53:21 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47544 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1AMMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:51:34 -0500
X-AuditID: b753bd60-a0d62ba000000f65-c4-4d2ef552677d
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 2/6] perf probe: Enable to put probe inline
	function call site
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 21:46:05 +0900
Message-ID: <20110113124604.22426.48873.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable to put probe inline function call site. This will
increase line-based probe-ability.

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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/util/probe-finder.c |   56 ++++++++++++++++++++++++++++++++++------
 1 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5926d25..10c18c4 100644
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

