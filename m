Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1AGPhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:37:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:40875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1AGPhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:37:32 -0500
Date: Fri, 7 Jan 2011 15:34:59 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ying.huang@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ying.huang@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1294348732-15030-6-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-6-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
Message-ID: <tip-ab846f13f69fa64f8ed69ce0c3e239e075910d23@git.kernel.org>
Git-Commit-ID: ab846f13f69fa64f8ed69ce0c3e239e075910d23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:34:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab846f13f69fa64f8ed69ce0c3e239e075910d23
Gitweb:     http://git.kernel.org/tip/ab846f13f69fa64f8ed69ce0c3e239e075910d23
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 6 Jan 2011 16:18:51 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:08:53 +0100

x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU

In original NMI handler, NMI reason io port (0x61) is only processed
on BSP.  This makes it impossible to hot-remove BSP.  To solve the
issue, a raw spinlock is used to allow the port to be processed on any
CPU.

Originally-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294348732-15030-6-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/traps.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 23f6ac0..613b3d2 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -84,6 +84,11 @@ EXPORT_SYMBOL_GPL(used_vectors);
 static int ignore_nmis;
 
 int unknown_nmi_panic;
+/*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
 
 static inline void conditional_sti(struct pt_regs *regs)
 {
@@ -392,7 +397,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
-	int cpu;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
@@ -402,13 +406,12 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
-	cpu = smp_processor_id();
-
-	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
-		reason = get_nmi_reason();
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	raw_spin_lock(&nmi_reason_lock);
+	reason = get_nmi_reason();
 
 	if (!(reason & NMI_REASON_MASK)) {
+		raw_spin_unlock(&nmi_reason_lock);
 		unknown_nmi_error(reason, regs);
 
 		return;
@@ -426,6 +429,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 */
 	reassert_nmi();
 #endif
+	raw_spin_unlock(&nmi_reason_lock);
 }
 
 dotraplinkage notrace __kprobes void
