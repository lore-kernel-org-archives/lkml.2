Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2ENNGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:06:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2ENNGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:06:44 -0400
Date: Mon, 14 May 2012 06:06:30 -0700
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-3aac27aba79b7c52e709ef6de0f7d8139caedc01@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1336761675-24296-4-git-send-email-dzickus@redhat.com>
References: <1336761675-24296-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86/reboot: Update nonmi_ipi parameter
Git-Commit-ID: 3aac27aba79b7c52e709ef6de0f7d8139caedc01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:06:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aac27aba79b7c52e709ef6de0f7d8139caedc01
Gitweb:     http://git.kernel.org/tip/3aac27aba79b7c52e709ef6de0f7d8139caedc01
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 11 May 2012 14:41:15 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 11:49:38 +0200

x86/reboot: Update nonmi_ipi parameter

Update the nonmi_ipi parameter to reflect the simple change
instead of the previous complicated one.  There should be less
of a need to use it but there may still be corner cases on older
hardware that stumble into NMI issues.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1336761675-24296-4-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smp.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 228e740..48d2b7d 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -110,6 +110,7 @@
  */
 
 static atomic_t stopping_cpu = ATOMIC_INIT(-1);
+static bool smp_no_nmi_ipi = false;
 
 /*
  * this function sends a 'reschedule' IPI to another CPU.
@@ -216,7 +217,7 @@ static void native_stop_other_cpus(int wait)
 	}
 	
 	/* if the REBOOT_VECTOR didn't work, try with the NMI */
-	if ((num_online_cpus() > 1))  {
+	if ((num_online_cpus() > 1) && (!smp_no_nmi_ipi))  {
 		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
 					 NMI_FLAG_FIRST, "smp_stop"))
 			/* Note: we ignore failures here */
@@ -245,11 +246,6 @@ finish:
 	local_irq_restore(flags);
 }
 
-static void native_smp_disable_nmi_ipi(void)
-{
-	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
-}
-
 /*
  * Reschedule call back.
  */
@@ -283,8 +279,8 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 
 static int __init nonmi_ipi_setup(char *str)
 {
-        native_smp_disable_nmi_ipi();
-        return 1;
+	smp_no_nmi_ipi = true;
+	return 1;
 }
 
 __setup("nonmi_ipi", nonmi_ipi_setup);
