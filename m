Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1JMTPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab1JMTPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:15:13 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com,
        Don Zickus <dzickus@redhat.com>
Subject: [v2 PATCH 3/3] x86, NMI: knob to disable using NMI IPIs to stop cpus
Date: Thu, 13 Oct 2011 15:14:27 -0400
Message-Id: <1318533267-18880-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1318533267-18880-1-git-send-email-dzickus@redhat.com>
References: <1318533267-18880-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines may exhibit problems using the NMI to stop other cpus.
This knob just allows one to revert back to the original behaviour to help
diagnose the problem.

V2:
  make function static

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/smp.c               |   13 +++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6ca1f5c..dab6439 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1761,6 +1761,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	nonmi_ipi	[X86] Disable using NMI IPIs during panic/reboot to
+			shutdown the other cpus.  Instead use the REBOOT_VECTOR
+			irq.
+
 	nopat		[X86] Disable PAT (page attribute table extension of
 			pagetables) support.
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 991d184..f96d32d 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -248,6 +248,11 @@ static void native_irq_stop_other_cpus(int wait)
 	local_irq_restore(flags);
 }
 
+static void native_smp_disable_nmi_ipi(void)
+{
+	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
+}
+
 /*
  * Reschedule call back.
  */
@@ -279,6 +284,14 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+static int __init nonmi_ipi_setup(char *str)
+{
+        native_smp_disable_nmi_ipi();
+        return 1;
+}
+
+__setup("nonmi_ipi", nonmi_ipi_setup);
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
-- 
1.7.6.4

