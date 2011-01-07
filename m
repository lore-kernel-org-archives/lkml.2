Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1AFM7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:59:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:9275 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1AFM7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:59:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,283,1291622400"; 
   d="scan'208";a="875010431"
Date: Thu, 6 Jan 2011 21:04:02 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
        trenn@suse.de, kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] apic: Fix error interrupt report at all APs
Message-ID: <20110107020402.GA14593@linux-youquan.bj.intel.com>
References: <1294284532-24285-1-git-send-email-youquan.song@intel.com> <1294284532-24285-2-git-send-email-youquan.song@intel.com> <20110106092753.GA32343@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106092753.GA32343@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the thermal interrupt vector of all CPUs is 0 and you are seeing
> LAPIC error interrupts, the correct way to fix it is to disable digital
> thermal sensors from generating interrupts.
Thanks for your feedback Yong!

No. Write LVT with vector(0~15) will always generate error interrupt if error
interrupt is set. it has nothing with digital thermal device.
Since you find some platform will cause issue because BIOS possible take
over the thermal interrupt.

So my prefered patch is like following, move the APIC_LVTTHMR restore to
vecotor check domain, which following your origin logic.

Can I consider BIOS under control thermal interrupt will not be illegal vector?


diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 4b68326..a2cb9bd 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -405,30 +405,28 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	 */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 
-	/*
-	 * The initial value of thermal LVT entries on all APs always reads
-	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
-	 * sequence to them and LVT registers are reset to 0s except for
-	 * the mask bits which are set to 1s when APs receive INIT IPI.
-	 * Always restore the value that BIOS has programmed on AP based on
-	 * BSP's info we saved since BIOS is always setting the same value
-	 * for all threads/cores
-	 */
-	apic_write(APIC_LVTTHMR, lvtthmr_init);
-
 	h = lvtthmr_init;
-
-	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
-		return;
-	}
-
 	/* Check whether a vector already exists */
 	if (h & APIC_VECTOR_MASK) {
 		printk(KERN_DEBUG
 		       "CPU%d: Thermal LVT vector (%#x) already installed\n",
 		       cpu, (h & APIC_VECTOR_MASK));
+		/*
+	 	 * The initial value of thermal LVT entries on all APs always reads
+	 	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
+	 	 * sequence to them and LVT registers are reset to 0s except for
+	 	 * the mask bits which are set to 1s when APs receive INIT IPI.
+	 	 * Always restore the value that BIOS has programmed on AP based on
+	 	 * BSP's info we saved since BIOS is always setting the same value
+	 	 * for all threads/cores
+	 	*/
+		apic_write(APIC_LVTTHMR, h);
+		return;
+	}
+
+	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
+		printk(KERN_DEBUG
+		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
 		return;
 	}
 

