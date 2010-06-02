Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab0FBVWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:22:20 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/11] x86, UV: BAU structure rearranging
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004aI-54@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move some structure definitions from the C code to the BAU header file,
and change the organization of that header file a little.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |   90 ++++++++++++++++++++++-----------------
 arch/x86/kernel/tlb_uv.c         |   12 -----
 2 files changed, 51 insertions(+), 51 deletions(-)

Index: 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 100531.linux-tip.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 100531.linux-tip/arch/x86/include/asm/uv/uv_bau.h
@@ -322,6 +322,57 @@ struct bau_payload_queue_entry {
 	/* bytes 24-31 */
 };
 
+struct msg_desc {
+	struct bau_payload_queue_entry *msg;
+	int msg_slot;
+	int sw_ack_slot;
+	struct bau_payload_queue_entry *va_queue_first;
+	struct bau_payload_queue_entry *va_queue_last;
+};
+
+struct reset_args {
+	int sender;
+};
+
+/*
+ * This structure is allocated per_cpu for UV TLB shootdown statistics.
+ */
+struct ptc_stats {
+	/* sender statistics */
+	unsigned long s_giveup; /* number of fall backs to IPI-style flushes */
+	unsigned long s_requestor; /* number of shootdown requests */
+	unsigned long s_stimeout; /* source side timeouts */
+	unsigned long s_dtimeout; /* destination side timeouts */
+	unsigned long s_time; /* time spent in sending side */
+	unsigned long s_retriesok; /* successful retries */
+	unsigned long s_ntargcpu; /* total number of cpu's targeted */
+	unsigned long s_ntarguvhub; /* total number of uvhubs targeted */
+	unsigned long s_ntarguvhub16; /* number of times target hubs >= 16*/
+	unsigned long s_ntarguvhub8; /* number of times target hubs >= 8 */
+	unsigned long s_ntarguvhub4; /* number of times target hubs >= 4 */
+	unsigned long s_ntarguvhub2; /* number of times target hubs >= 2 */
+	unsigned long s_ntarguvhub1; /* number of times target hubs == 1 */
+	unsigned long s_resets_plug; /* ipi-style resets from plug state */
+	unsigned long s_resets_timeout; /* ipi-style resets from timeouts */
+	unsigned long s_busy; /* status stayed busy past s/w timer */
+	unsigned long s_throttles; /* waits in throttle */
+	unsigned long s_retry_messages; /* retry broadcasts */
+	unsigned long s_bau_reenabled; /* for bau enable/disable */
+	unsigned long s_bau_disabled; /* for bau enable/disable */
+	/* destination statistics */
+	unsigned long d_alltlb; /* times all tlb's on this cpu were flushed */
+	unsigned long d_onetlb; /* times just one tlb on this cpu was flushed */
+	unsigned long d_multmsg; /* interrupts with multiple messages */
+	unsigned long d_nomsg; /* interrupts with no message */
+	unsigned long d_time; /* time spent on destination side */
+	unsigned long d_requestee; /* number of messages processed */
+	unsigned long d_retries; /* number of retry messages processed */
+	unsigned long d_canceled; /* number of messages canceled by retries */
+	unsigned long d_nocanceled; /* retries that found nothing to cancel */
+	unsigned long d_resets; /* number of ipi-style requests processed */
+	unsigned long d_rcanceled; /* number of messages canceled by resets */
+};
+
 /*
  * one per-cpu; to locate the software tables
  */
@@ -369,45 +420,6 @@ struct bau_control {
 	long period_requests;
 };
 
-/*
- * This structure is allocated per_cpu for UV TLB shootdown statistics.
- */
-struct ptc_stats {
-	/* sender statistics */
-	unsigned long s_giveup; /* number of fall backs to IPI-style flushes */
-	unsigned long s_requestor; /* number of shootdown requests */
-	unsigned long s_stimeout; /* source side timeouts */
-	unsigned long s_dtimeout; /* destination side timeouts */
-	unsigned long s_time; /* time spent in sending side */
-	unsigned long s_retriesok; /* successful retries */
-	unsigned long s_ntargcpu; /* number of cpus targeted */
-	unsigned long s_ntarguvhub; /* number of uvhubs targeted */
-	unsigned long s_ntarguvhub16; /* number of times >= 16 target hubs */
-	unsigned long s_ntarguvhub8; /* number of times >= 8 target hubs */
-	unsigned long s_ntarguvhub4; /* number of times >= 4 target hubs */
-	unsigned long s_ntarguvhub2; /* number of times >= 2 target hubs */
-	unsigned long s_ntarguvhub1; /* number of times == 1 target hub */
-	unsigned long s_resets_plug; /* ipi-style resets from plug state */
-	unsigned long s_resets_timeout; /* ipi-style resets from timeouts */
-	unsigned long s_busy; /* status stayed busy past s/w timer */
-	unsigned long s_throttles; /* waits in throttle */
-	unsigned long s_retry_messages; /* retry broadcasts */
-	unsigned long s_bau_reenabled; /* for bau enable/disable */
-	unsigned long s_bau_disabled; /* for bau enable/disable */
-	/* destination statistics */
-	unsigned long d_alltlb; /* times all tlb's on this cpu were flushed */
-	unsigned long d_onetlb; /* times just one tlb on this cpu was flushed */
-	unsigned long d_multmsg; /* interrupts with multiple messages */
-	unsigned long d_nomsg; /* interrupts with no message */
-	unsigned long d_time; /* time spent on destination side */
-	unsigned long d_requestee; /* number of messages processed */
-	unsigned long d_retries; /* number of retry messages processed */
-	unsigned long d_canceled; /* number of messages canceled by retries */
-	unsigned long d_nocanceled; /* retries that found nothing to cancel */
-	unsigned long d_resets; /* number of ipi-style requests processed */
-	unsigned long d_rcanceled; /* number of messages canceled by resets */
-};
-
 static inline int bau_uvhub_isset(int uvhub, struct bau_target_uvhubmask *dstp)
 {
 	return constant_test_bit(uvhub, &dstp->bits[0]);
Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -23,14 +23,6 @@
 #include <asm/irq_vectors.h>
 #include <asm/timer.h>
 
-struct msg_desc {
-	struct bau_payload_queue_entry *msg;
-	int msg_slot;
-	int sw_ack_slot;
-	struct bau_payload_queue_entry *va_queue_first;
-	struct bau_payload_queue_entry *va_queue_last;
-};
-
 /* timeouts in nanoseconds (indexed by UVH_AGING_PRESCALE_SEL urgency7 30:28) */
 static int timeout_base_ns[] = {
 		20,
@@ -79,10 +71,6 @@ static DEFINE_PER_CPU(struct ptc_stats, 
 static DEFINE_PER_CPU(struct bau_control, bau_control);
 static DEFINE_PER_CPU(cpumask_var_t, uv_flush_tlb_mask);
 
-struct reset_args {
-	int sender;
-};
-
 /*
  * Determine the first node on a uvhub. 'Nodes' are used for kernel
  * memory allocation.
