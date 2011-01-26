Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1AZHXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:23:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:53366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1AZHXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:23:13 -0500
Date: Wed, 26 Jan 2011 07:22:38 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110113124604.22426.48873.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110113124604.22426.48873.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Enable to put probe inline function call site
Message-ID: <tip-5069ed86be3c2f28bcdf7fae1374ec0c325aafba@git.kernel.org>
Git-Commit-ID: 5069ed86be3c2f28bcdf7fae1374ec0c325aafba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:22:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5069ed86be3c2f28bcdf7fae1374ec0c325aafba
Gitweb:     http://git.kernel.org/tip/5069ed86be3c2f28bcdf7fae1374ec0c325aafba
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 13 Jan 2011 21:46:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Jan 2011 10:57:03 -0200

perf probe: Enable to put probe inline function call site

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
