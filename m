Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0C2UcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:32:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0C2UcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:32:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 7/7] perf probe: Support DW_OP_call_frame_cfa in debuginfo
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 29 Mar 2010 16:38:54 -0400
Message-ID: <20100329203854.2577.20037.stgit@localhost6.localdomain6>
In-Reply-To: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building kernel without CONFIG_FRAME_POINTER, gcc uses
CFA (canonical frame address) for frame base. With this patch,
perf probe just gets CFI (call frame information) from debuginfo
and search corresponding CFA from the CFI. IOW, this allows
perf probe works correctly on the kernel without CONFIG_FRAME_POINTER.

<Before>
 ./perf probe -fn sched_slice:12 lw.weight
  Fatal: DW_OP 156 is not supported.
              (^^^ DW_OP_call_frame_cfa)

<After>
./perf probe -fn sched_slice:12 lw.weight
Add new event:
  probe:sched_slice    (on sched_slice:12 with weight=lw.weight)

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/util/probe-finder.c |   14 +++++++++++---
 tools/perf/util/probe-finder.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 11d6592..26f02b9 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -396,7 +396,6 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 	const char *regs;
 	struct kprobe_trace_arg *tvar = pf->tvar;
 
-	/* TODO: support CFA */
 	/* If this is based on frame buffer, set the offset */
 	if (op->atom == DW_OP_fbreg) {
 		if (pf->fb_ops == NULL)
@@ -623,11 +622,17 @@ static void convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	/* Get the frame base attribute/ops */
 	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
 	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
-	if (ret <= 0 || nops == 0)
+	if (ret <= 0 || nops == 0) {
 		pf->fb_ops = NULL;
+	} else if (nops == 1 && pf->fb_ops[0].atom == DW_OP_call_frame_cfa &&
+		   pf->cfi != NULL) {
+		Dwarf_Frame *frame;
+		ret = dwarf_cfi_addrframe(pf->cfi, pf->addr, &frame);
+		DIE_IF(ret != 0);
+		dwarf_frame_cfa(frame, &pf->fb_ops, &nops);
+	}
 
 	/* Find each argument */
-	/* TODO: use dwarf_cfi_addrframe */
 	tev->nargs = pf->pev->nargs;
 	tev->args = xzalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
 	for (i = 0; i < pf->pev->nargs; i++) {
@@ -836,6 +841,9 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	if (!dbg)
 		return -ENOENT;
 
+	/* Get the call frame information from this dwarf */
+	pf.cfi = dwarf_getcfi(dbg);
+
 	off = 0;
 	line_list__init(&pf.lcache);
 	/* Loop on CUs (Compilation Unit) */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 3564f22..ddaa2a7 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -42,6 +42,7 @@ struct probe_finder {
 	struct list_head	lcache;		/* Line cache for lazy match */
 
 	/* For variable searching */
+	Dwarf_CFI		*cfi;		/* Call Frame Information */
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
 	struct perf_probe_arg	*pvar;		/* Current target variable */
 	struct kprobe_trace_arg	*tvar;		/* Current result variable */


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
