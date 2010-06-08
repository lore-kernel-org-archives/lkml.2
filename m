Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0FHU5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:57:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:39506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab0FHU5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:57:48 -0400
Date: Tue, 8 Jun 2010 20:57:25 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004aI-54@eag09.americas.sgi.com>
References: <E1OJvNy-0004aI-54@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: BAU structure rearranging
Message-ID: <tip-4faca1550838708d71f6eea14cdacb0876c3a5a4@git.kernel.org>
Git-Commit-ID: 4faca1550838708d71f6eea14cdacb0876c3a5a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:57:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4faca1550838708d71f6eea14cdacb0876c3a5a4
Gitweb:     http://git.kernel.org/tip/4faca1550838708d71f6eea14cdacb0876c3a5a4
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:45 +0200

x86, UV: BAU structure rearranging

Move some structure definitions from the C code to the BAU
header file, and change the organization of that header file a
little.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004aI-54@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |   90 +++++++++++++++++++++----------------
 arch/x86/kernel/tlb_uv.c         |   12 -----
 2 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 6a42d42..1c8f1e9 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
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
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 261b965..d759290 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
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
@@ -79,10 +71,6 @@ static DEFINE_PER_CPU(struct ptc_stats, ptcstats);
 static DEFINE_PER_CPU(struct bau_control, bau_control);
 static DEFINE_PER_CPU(cpumask_var_t, uv_flush_tlb_mask);
 
-struct reset_args {
-	int sender;
-};
-
 /*
  * Determine the first node on a uvhub. 'Nodes' are used for kernel
  * memory allocation.
