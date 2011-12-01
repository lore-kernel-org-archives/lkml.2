Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1LALpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1LALpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:45:45 -0500
From: Petr Holasek <pholasek@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Arapov <anton@redhat.com>, Petr Holasek <pholasek@redhat.com>
Subject: [PATCH RESEND] NUMA x86: add constraints check for nid parameters
Date: Thu,  1 Dec 2011 12:45:07 +0100
Message-Id: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds constraints checks into __node_distance() and
numa_set_distance() functions. If from or to parameters are
lower than zero, it results into oops now.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 arch/x86/mm/numa.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..9e0ff2b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -430,8 +430,9 @@ static int __init numa_alloc_distance(void)
  * calls are ignored until the distance table is reset with
  * numa_reset_distance().
  *
- * If @from or @to is higher than the highest known node at the time of
- * table creation or @distance doesn't make sense, the call is ignored.
+ * If @from or @to is higher than the highest known node or lower than zero
+ * at the time of table creation or @distance doesn't make sense, the call
+ * is ignored.
  * This is to allow simplification of specific NUMA config implementations.
  */
 void __init numa_set_distance(int from, int to, int distance)
@@ -439,7 +440,8 @@ void __init numa_set_distance(int from, int to, int distance)
 	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
 
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
+			from < 0 || to < 0) {
 		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
 			    from, to, distance);
 		return;
@@ -457,7 +459,8 @@ void __init numa_set_distance(int from, int to, int distance)
 
 int __node_distance(int from, int to)
 {
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+	if (from < 0 || to < 0 ||
+			from >= numa_distance_cnt || to >= numa_distance_cnt)
 		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
 	return numa_distance[from * numa_distance_cnt + to];
 }
-- 
1.7.6.4

