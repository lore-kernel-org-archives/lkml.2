Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab0FHU7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:59:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:39622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab0FHU7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:59:33 -0400
Date: Tue, 8 Jun 2010 20:59:15 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004ay-IH@eag09.americas.sgi.com>
References: <E1OJvNy-0004ay-IH@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Modularize BAU send and wait
Message-ID: <tip-f6d8a56693426b1f29ff5cafda8be0d65e4e1870@git.kernel.org>
Git-Commit-ID: f6d8a56693426b1f29ff5cafda8be0d65e4e1870
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:59:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6d8a56693426b1f29ff5cafda8be0d65e4e1870
Gitweb:     http://git.kernel.org/tip/f6d8a56693426b1f29ff5cafda8be0d65e4e1870
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:48 +0200

x86, UV: Modularize BAU send and wait

Streamline the large uv_flush_send_and_wait() function by use of
a couple of helper functions.

And remove some excess comments.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004ay-IH@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 -
 arch/x86/kernel/tlb_uv.c         |   82 ++++++++++++++++++++-----------------
 2 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 7f6ea61..42d412f 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -75,7 +75,6 @@
 #define DESC_STATUS_DESTINATION_TIMEOUT	2
 #define DESC_STATUS_SOURCE_TIMEOUT	3
 
-#define TIMEOUT_DELAY			10
 /*
  * delay for 'plugged' timeout retries, in microseconds
  */
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index a161505..abf3c31 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -485,6 +485,47 @@ static inline int atomic_inc_unless_ge(spinlock_t *lock, atomic_t *v, int u)
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
@@ -518,7 +559,7 @@ disable_for_congestion(struct bau_control *bcp, struct ptc_stats *stat)
  *
  * Send a broadcast and wait for it to complete.
  *
- * The flush_mask contains the cpus the broadcast is to be sent to, plus
+ * The flush_mask contains the cpus the broadcast is to be sent to including
  * cpus that are on the local uvhub.
  *
  * Returns 0 if all flushing represented in the mask was done.
@@ -553,7 +594,6 @@ int uv_flush_send_and_wait(struct bau_desc *bau_desc,
 			&hmaster->active_descriptor_count,
 			hmaster->max_bau_concurrent));
 	}
-
 	while (hmaster->uvhub_quiesce)
 		cpu_relax();
 
@@ -584,40 +624,9 @@ int uv_flush_send_and_wait(struct bau_desc *bau_desc,
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
@@ -628,10 +637,8 @@ int uv_flush_send_and_wait(struct bau_desc *bau_desc,
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
@@ -740,7 +747,6 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 
 	bau_desc = bcp->descriptor_base;
 	bau_desc += UV_ITEMS_PER_DESCRIPTOR * bcp->uvhub_cpu;
-
 	bau_uvhubs_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
 	/* cpu statistics */
