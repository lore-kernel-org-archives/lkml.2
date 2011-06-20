Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1FTWRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:17:41 -0400
Received: from claw.goop.org ([74.207.240.146]:53637 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab1FTWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/15] xen/multicalls: remove debugfs stats
Date: Mon, 20 Jun 2011 15:14:58 -0700
Message-Id: <37b484431cc82d18d908bdd15188c54aca687fbc.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Remove debugfs stats to make way for tracing.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/multicalls.c |  109 +--------------------------------------------
 arch/x86/xen/multicalls.h |    3 +
 2 files changed, 4 insertions(+), 108 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 8bff7e7..d4be3fd 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -52,76 +52,6 @@ struct mc_buffer {
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
 DEFINE_PER_CPU(unsigned long, xen_mc_irq_flags);
 
-/* flush reasons 0- slots, 1- args, 2- callbacks */
-enum flush_reasons
-{
-	FL_SLOTS,
-	FL_ARGS,
-	FL_CALLBACKS,
-
-	FL_N_REASONS
-};
-
-#ifdef CONFIG_XEN_DEBUG_FS
-#define NHYPERCALLS	40		/* not really */
-
-static struct {
-	unsigned histo[MC_BATCH+1];
-
-	unsigned issued;
-	unsigned arg_total;
-	unsigned hypercalls;
-	unsigned histo_hypercalls[NHYPERCALLS];
-
-	unsigned flush[FL_N_REASONS];
-} mc_stats;
-
-static u8 zero_stats;
-
-static inline void check_zero(void)
-{
-	if (unlikely(zero_stats)) {
-		memset(&mc_stats, 0, sizeof(mc_stats));
-		zero_stats = 0;
-	}
-}
-
-static void mc_add_stats(const struct mc_buffer *mc)
-{
-	int i;
-
-	check_zero();
-
-	mc_stats.issued++;
-	mc_stats.hypercalls += mc->mcidx;
-	mc_stats.arg_total += mc->argidx;
-
-	mc_stats.histo[mc->mcidx]++;
-	for(i = 0; i < mc->mcidx; i++) {
-		unsigned op = mc->entries[i].op;
-		if (op < NHYPERCALLS)
-			mc_stats.histo_hypercalls[op]++;
-	}
-}
-
-static void mc_stats_flush(enum flush_reasons idx)
-{
-	check_zero();
-
-	mc_stats.flush[idx]++;
-}
-
-#else  /* !CONFIG_XEN_DEBUG_FS */
-
-static inline void mc_add_stats(const struct mc_buffer *mc)
-{
-}
-
-static inline void mc_stats_flush(enum flush_reasons idx)
-{
-}
-#endif	/* CONFIG_XEN_DEBUG_FS */
-
 void xen_mc_flush(void)
 {
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
@@ -135,8 +65,6 @@ void xen_mc_flush(void)
 	   something in the middle */
 	local_irq_save(flags);
 
-	mc_add_stats(b);
-
 	if (b->mcidx) {
 #if MC_DEBUG
 		memcpy(b->debug, b->entries,
@@ -193,7 +121,6 @@ struct multicall_space __xen_mc_entry(size_t args)
 
 	if (b->mcidx == MC_BATCH ||
 	    (argidx + args) > MC_ARGS) {
-		mc_stats_flush(b->mcidx == MC_BATCH ? FL_SLOTS : FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
 	}
@@ -240,44 +167,10 @@ void xen_mc_callback(void (*fn)(void *), void *data)
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	struct callback *cb;
 
-	if (b->cbidx == MC_BATCH) {
-		mc_stats_flush(FL_CALLBACKS);
+	if (b->cbidx == MC_BATCH)
 		xen_mc_flush();
-	}
 
 	cb = &b->callbacks[b->cbidx++];
 	cb->fn = fn;
 	cb->data = data;
 }
-
-#ifdef CONFIG_XEN_DEBUG_FS
-
-static struct dentry *d_mc_debug;
-
-static int __init xen_mc_debugfs(void)
-{
-	struct dentry *d_xen = xen_init_debugfs();
-
-	if (d_xen == NULL)
-		return -ENOMEM;
-
-	d_mc_debug = debugfs_create_dir("multicalls", d_xen);
-
-	debugfs_create_u8("zero_stats", 0644, d_mc_debug, &zero_stats);
-
-	debugfs_create_u32("batches", 0444, d_mc_debug, &mc_stats.issued);
-	debugfs_create_u32("hypercalls", 0444, d_mc_debug, &mc_stats.hypercalls);
-	debugfs_create_u32("arg_total", 0444, d_mc_debug, &mc_stats.arg_total);
-
-	xen_debugfs_create_u32_array("batch_histo", 0444, d_mc_debug,
-				     mc_stats.histo, MC_BATCH);
-	xen_debugfs_create_u32_array("hypercall_histo", 0444, d_mc_debug,
-				     mc_stats.histo_hypercalls, NHYPERCALLS);
-	xen_debugfs_create_u32_array("flush_reasons", 0444, d_mc_debug,
-				     mc_stats.flush, FL_N_REASONS);
-
-	return 0;
-}
-fs_initcall(xen_mc_debugfs);
-
-#endif	/* CONFIG_XEN_DEBUG_FS */
diff --git a/arch/x86/xen/multicalls.h b/arch/x86/xen/multicalls.h
index 4ec8035..fa7b8af 100644
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -1,6 +1,8 @@
 #ifndef _XEN_MULTICALLS_H
 #define _XEN_MULTICALLS_H
 
+#include <trace/events/xen.h>
+
 #include "xen-ops.h"
 
 /* Multicalls */
@@ -20,6 +22,7 @@ DECLARE_PER_CPU(unsigned long, xen_mc_irq_flags);
 static inline void xen_mc_batch(void)
 {
 	unsigned long flags;
+
 	/* need to disable interrupts until this entry is complete */
 	local_irq_save(flags);
 	__this_cpu_write(xen_mc_irq_flags, flags);
-- 
1.7.5.4

