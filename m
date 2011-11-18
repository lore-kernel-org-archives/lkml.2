Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab1KRPdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:33:15 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:41008
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab1KRPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:33:14 -0500
X-SpamScore: 3
X-BigFish: VPS3(z5c5oz4015Lzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUV4J7-01-7X5-02
X-M-MSG: 
Date: Fri, 18 Nov 2011 16:33:06 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, hpet: Immediately disable HPET timer 1 if rtc irq is
 masked
Message-ID: <20111118153306.GB16319@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Langsdorf <mark.langsdorf@amd.com>

When HPET is operating in RTC mode, the TN_ENABLE bit
on timer1 controls whether the HPET or the RTC delivers
interrupts to irq8. When the system goes into suspend,
the RTC driver sends a signal to the HPET driver so
that the HPET releases control of irq8, allowing the
RTC to wake the system from suspend. The switchover
is accomplished by a write to the HPET configuration
registers which currently only occurs while servicing
the HPET interrupt.

On some systems, I have seen the system suspend before
an HPET interrupt occurs, preventing the write to the
HPET configuration register and leaving the HPET in
control of the irq8. As the HPET is not active during
suspend, it does not generate a wake signal and RTC
alarms do not work.

This patch forces the HPET driver to immediately transfer
control of the irq8 channel to the RTC instead of waiting
until the next interrupt event.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/hpet.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

Hi,

Resending Mark's patch. Seems that it was lost in space a couple of
weeks ago.

Please apply.

(Patch was built against Linus' git tree as of v3.2-rc2-101-g15bd1cf.)


Thanks,

Andreas


diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index b946a9e..1bb0bf4 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1049,6 +1049,14 @@ int hpet_rtc_timer_init(void)
 }
 EXPORT_SYMBOL_GPL(hpet_rtc_timer_init);
 
+static void hpet_disable_rtc_channel(void)
+{
+	unsigned long cfg;
+	cfg = hpet_readl(HPET_T1_CFG);
+	cfg &= ~HPET_TN_ENABLE;
+	hpet_writel(cfg, HPET_T1_CFG);
+}
+
 /*
  * The functions below are called from rtc driver.
  * Return 0 if HPET is not being used.
@@ -1060,6 +1068,9 @@ int hpet_mask_rtc_irq_bit(unsigned long bit_mask)
 		return 0;
 
 	hpet_rtc_flags &= ~bit_mask;
+	if (unlikely(!hpet_rtc_flags))
+		hpet_disable_rtc_channel();
+
 	return 1;
 }
 EXPORT_SYMBOL_GPL(hpet_mask_rtc_irq_bit);
@@ -1125,15 +1136,11 @@ EXPORT_SYMBOL_GPL(hpet_rtc_dropped_irq);
 
 static void hpet_rtc_timer_reinit(void)
 {
-	unsigned int cfg, delta;
+	unsigned int delta;
 	int lost_ints = -1;
 
-	if (unlikely(!hpet_rtc_flags)) {
-		cfg = hpet_readl(HPET_T1_CFG);
-		cfg &= ~HPET_TN_ENABLE;
-		hpet_writel(cfg, HPET_T1_CFG);
-		return;
-	}
+	if (unlikely(!hpet_rtc_flags))
+		hpet_disable_rtc_channel();
 
 	if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
 		delta = hpet_default_delta;
-- 
1.7.7



