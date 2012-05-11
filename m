Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab2EKSle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:41:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759136Ab2EKSl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:41:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] x86, reboot:  Update nonmi_ipi parameter
Date: Fri, 11 May 2012 14:41:15 -0400
Message-Id: <1336761675-24296-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1336761675-24296-1-git-send-email-dzickus@redhat.com>
References: <1336761675-24296-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the nonmi_ipi parameter to reflect the simple change instead
of the previous complicated one.  There should be less of a need to
use it but there may still be corner cases on older hardware that
stumble into NMI issues.

Signed-off-by: Don Zickus <dzickus@redhat.com>
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
-- 
1.7.7.6

