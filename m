Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab1EBXJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:40 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab1EBXJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:29 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsQcn030354@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 15:22:18 -0400
Subject: [PATCH] arch/tile: disable SD_WAKE_AFFINE flag on CPU/NODE scheduling domain
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:26.0221 (UTC) FILETIME=[E2E335D0:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows processes to spread more effectively to multiple cores
(particularly important on 64-core chips!).

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/topology.h |   75 +++++++++++++++++++++++++++++---------
 1 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index 343172d..6fdd0c8 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -44,25 +44,64 @@ static inline const struct cpumask *cpumask_of_node(int node)
 /* For now, use numa node -1 for global allocation. */
 #define pcibus_to_node(bus)		((void)(bus), -1)
 
+/*
+ * TILE architecture has many cores integrated in one processor, so we need
+ * setup bigger balance_interval for both CPU/NODE scheduling domains to
+ * reduce process scheduling costs.
+ */
+
+/* sched_domains SD_CPU_INIT for TILE architecture */
+#define SD_CPU_INIT (struct sched_domain) {				\
+	.min_interval		= 4,					\
+	.max_interval		= 128,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 2,					\
+	.idle_idx		= 1,					\
+	.newidle_idx		= 0,					\
+	.wake_idx		= 0,					\
+	.forkexec_idx		= 0,					\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_BALANCE_WAKE			\
+				| 0*SD_WAKE_AFFINE			\
+				| 0*SD_PREFER_LOCAL			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 32,					\
+}
+
 /* sched_domains SD_NODE_INIT for TILE architecture */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 1,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 1,			\
-	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_NODE_INIT (struct sched_domain) {				\
+	.min_interval		= 16,					\
+	.max_interval		= 512,					\
+	.busy_factor		= 32,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 3,					\
+	.idle_idx		= 1,					\
+	.newidle_idx		= 2,					\
+	.wake_idx		= 1,					\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_BALANCE_WAKE			\
+				| 0*SD_WAKE_AFFINE			\
+				| 0*SD_PREFER_LOCAL			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SERIALIZE			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 128,					\
 }
 
 /* By definition, we create nodes based on online memory. */
-- 
1.6.5.2

