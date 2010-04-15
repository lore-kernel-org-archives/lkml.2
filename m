Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab0DOHcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:32:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:38088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427Ab0DOH3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:45 -0400
Date: Thu, 15 Apr 2010 07:29:18 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100412171728.3790.98217.stgit@localhost6.localdomain6>
References: <20100412171728.3790.98217.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Support DW_OP_call_frame_cfa in debuginfo
Message-ID: <tip-a34a985499895a46a4dacff727d0fbc63cdc75e8@git.kernel.org>
Git-Commit-ID: a34a985499895a46a4dacff727d0fbc63cdc75e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:29:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a34a985499895a46a4dacff727d0fbc63cdc75e8
Gitweb:     http://git.kernel.org/tip/a34a985499895a46a4dacff727d0fbc63cdc75e8
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 12 Apr 2010 13:17:29 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:28:20 -0300

perf probe: Support DW_OP_call_frame_cfa in debuginfo

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

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100412171728.3790.98217.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   14 +++++++++++---
 tools/perf/util/probe-finder.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ab47673..1f45285 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -398,7 +398,6 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 	const char *regs;
 	struct kprobe_trace_arg *tvar = pf->tvar;
 
-	/* TODO: support CFA */
 	/* If this is based on frame buffer, set the offset */
 	if (op->atom == DW_OP_fbreg) {
 		if (pf->fb_ops == NULL)
@@ -629,11 +628,17 @@ static void convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
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
@@ -842,6 +847,9 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	if (!dbg)
 		return -ENOENT;
 
+	/* Get the call frame information from this dwarf */
+	pf.cfi = dwarf_getcfi(dbg);
+
 	off = 0;
 	line_list__init(&pf.lcache);
 	/* Loop on CUs (Compilation Unit) */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 2a27132..310ce89 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -42,6 +42,7 @@ struct probe_finder {
 	struct list_head	lcache;		/* Line cache for lazy match */
 
 	/* For variable searching */
+	Dwarf_CFI		*cfi;		/* Call Frame Information */
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
 	struct perf_probe_arg	*pvar;		/* Current target variable */
 	struct kprobe_trace_arg	*tvar;		/* Current result variable */
