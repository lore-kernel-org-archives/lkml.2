Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0EGRrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:47:22 -0400
Received: from mga10.intel.com ([192.55.52.92]:58103 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756703Ab0EGRrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418396"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 3/8] x86/apic: allow use of lapic timer early calibration result
Date: Fri,  7 May 2010 10:41:43 -0700
Message-Id: <1273254108-3234-4-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@intel.com>

lapic timer calibration can be combined with tsc in platform specific
calibration functions. if such calibration result is obtained early,
we can skip the redundent calibration loops.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e5a4a1e..8ef56ac 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -175,7 +175,7 @@ static struct resource lapic_resource = {
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
-static unsigned int calibration_result;
+unsigned int calibration_result;
 
 static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt);
@@ -597,6 +597,25 @@ static int __init calibrate_APIC_clock(void)
 	long delta, deltatsc;
 	int pm_referenced = 0;
 
+	/**
+	 * check if lapic timer has already been calibrated by platform
+	 * specific routine, such as tsc calibration code. if so, we just fill
+	 * in the clockevent structure and return.
+	 */
+
+	if (calibration_result) {
+		apic_printk(APIC_VERBOSE, "lapic timer already calibrated %d\n",
+				calibration_result);
+		lapic_clockevent.mult = div_sc(calibration_result/APIC_DIVISOR,
+					TICK_NSEC, lapic_clockevent.shift);
+		lapic_clockevent.max_delta_ns =
+			clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+		lapic_clockevent.min_delta_ns =
+			clockevent_delta2ns(0xF, &lapic_clockevent);
+		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+		return 0;
+	}
+
 	local_irq_disable();
 
 	/* Replace the global interrupt handler */
-- 
1.6.3.3

