Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab0FBVVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:21:53 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45293 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932984Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] x86, UV: modularize BAU send and wait
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004ay-IH@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Streamline the large uv_flush_send_and_wait() function by use of a couple
of helper functions.

And remove some excess comments.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 
 arch/x86/kernel/tlb_uv.c         |   82 ++++++++++++++++++++-------------------
 2 files changed, 44 insertions(+), 39 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -485,6 +485,47 @@ static inline int atomic_inc_unless_ge(s
 }
 
 /*
+ * Our retries are blocked by all destination swack resources being
+ * in use, and a timeout is pending. In that case hardware immediately
+ * returns the ERROR that looks like a destination timeout.
+ */
+static void
+destination_plugged(struct bau_desc *bau_desc, struct bau_control *bcp,
+			struct bau_control *hmaster, struct ptc_stats *stat)
+{
+	udelay(bcp->plugged_delay);
+	bcp->plugged_tries++;
+	if (bcp->plugged_tries >= bcp->plugsb4reset) {
+		bcp->plugged_tries = 0;
+		quiesce_local_uvhub(hmaster);
+		spin_lock(&hmaster->queue_lock);
+		uv_reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		spin_unlock(&hmaster->queue_lock);
+		end_uvhub_quiesce(hmaster);
+		bcp->ipi_attempts++;
+		stat->s_resets_plug++;
+	}
+}
+
+static void
+destination_timeout(struct bau_desc *bau_desc, struct bau_control *bcp,
+			struct bau_control *hmaster, struct ptc_stats *stat)
+{
+	hmaster->max_bau_concurrent = 1;
+	bcp->timeout_tries++;
+	if (bcp->timeout_tries >= bcp->timeoutsb4reset) {
+		bcp->timeout_tries = 0;
+		quiesce_local_uvhub(hmaster);
+		spin_lock(&hmaster->queue_lock);
+		uv_reset_with_ipi(&bau_desc->distribution, bcp->cpu);
+		spin_unlock(&hmaster->queue_lock);
+		end_uvhub_quiesce(hmaster);
+		bcp->ipi_attempts++;
+		stat->s_resets_timeout++;
+	}
+}
+
+/*
  * Completions are taking a very long time due to a congested numalink
  * network.
  */
@@ -518,7 +559,7 @@ disable_for_congestion(struct bau_contro
  *
  * Send a broadcast and wait for it to complete.
  *
- * The flush_mask contains the cpus the broadcast is to be sent to, plus
+ * The flush_mask contains the cpus the broadcast is to be sent to including
  * cpus that are on the local uvhub.
  *
  * Returns 0 if all flushing represented in the mask was done.
@@ -553,7 +594,6 @@ int uv_flush_send_and_wait(struct bau_de
 			&hmaster->active_descriptor_count,
 			hmaster->max_bau_concurrent));
 	}
-
 	while (hmaster->uvhub_quiesce)
 		cpu_relax();
 
@@ -584,40 +624,9 @@ int uv_flush_send_and_wait(struct bau_de
 			right_shift, this_cpu, bcp, smaster, try);
 
 		if (completion_status == FLUSH_RETRY_PLUGGED) {
-			/*
-			 * Our retries may be blocked by all destination swack
-			 * resources being consumed, and a timeout pending. In
-			 * that case hardware immediately returns the ERROR
-			 * that looks like a destination timeout.
-			 */
-			udelay(bcp->plugged_delay);
-			bcp->plugged_tries++;
-			if (bcp->plugged_tries >= bcp->plugsb4reset) {
-				bcp->plugged_tries = 0;
-				quiesce_local_uvhub(hmaster);
-				spin_lock(&hmaster->queue_lock);
-				uv_reset_with_ipi(&bau_desc->distribution,
-							this_cpu);
-				spin_unlock(&hmaster->queue_lock);
-				end_uvhub_quiesce(hmaster);
-				bcp->ipi_attempts++;
-				stat->s_resets_plug++;
-			}
+			destination_plugged(bau_desc, bcp, hmaster, stat);
 		} else if (completion_status == FLUSH_RETRY_TIMEOUT) {
-			hmaster->max_bau_concurrent = 1;
-			bcp->timeout_tries++;
-			udelay(TIMEOUT_DELAY);
-			if (bcp->timeout_tries >= bcp->timeoutsb4reset) {
-				bcp->timeout_tries = 0;
-				quiesce_local_uvhub(hmaster);
-				spin_lock(&hmaster->queue_lock);
-				uv_reset_with_ipi(&bau_desc->distribution,
-								this_cpu);
-				spin_unlock(&hmaster->queue_lock);
-				end_uvhub_quiesce(hmaster);
-				bcp->ipi_attempts++;
-				stat->s_resets_timeout++;
-			}
+			destination_timeout(bau_desc, bcp, hmaster, stat);
 		}
 		if (bcp->ipi_attempts >= bcp->ipi_reset_limit) {
 			bcp->ipi_attempts = 0;
@@ -628,10 +637,8 @@ int uv_flush_send_and_wait(struct bau_de
 	} while ((completion_status == FLUSH_RETRY_PLUGGED) ||
 		 (completion_status == FLUSH_RETRY_TIMEOUT));
 	time2 = get_cycles();
-
 	bcp->plugged_tries = 0;
 	bcp->timeout_tries = 0;
-
 	if ((completion_status == FLUSH_COMPLETE) &&
 	    (bcp->conseccompletes > bcp->complete_threshold) &&
 	    (hmaster->max_bau_concurrent <
@@ -740,7 +747,6 @@ const struct cpumask *uv_flush_tlb_other
 
 	bau_desc = bcp->descriptor_base;
 	bau_desc += UV_ITEMS_PER_DESCRIPTOR * bcp->uvhub_cpu;
-
 	bau_uvhubs_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
 	/* cpu statistics */
Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -75,7 +75,6 @@
 #define DESC_STATUS_DESTINATION_TIMEOUT	2
 #define DESC_STATUS_SOURCE_TIMEOUT	3
 
-#define TIMEOUT_DELAY			10
 /*
  * delay for 'plugged' timeout retries, in microseconds
  */
