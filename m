Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1JSR3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:29:52 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:27678
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab1JSR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:29:51 -0400
X-SpamScore: 8
X-BigFish: VPS8(z5c5ozzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LTBPWK-01-DLU-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: <venki@google.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: force HPET to immediately enable RTC wake
Date: Wed, 19 Oct 2011 12:26:48 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201110191226.49627.mark.langsdorf@amd.com>
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/kernel/hpet.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4aecc54..10b09d7 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1048,6 +1048,14 @@ int hpet_rtc_timer_init(void)
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
@@ -1059,6 +1067,9 @@ int hpet_mask_rtc_irq_bit(unsigned long bit_mask)
 		return 0;
 
 	hpet_rtc_flags &= ~bit_mask;
+	if (unlikely(!hpet_rtc_flags))
+		hpet_disable_rtc_channel();
+
 	return 1;
 }
 EXPORT_SYMBOL_GPL(hpet_mask_rtc_irq_bit);
@@ -1124,15 +1135,11 @@ EXPORT_SYMBOL_GPL(hpet_rtc_dropped_irq);
 
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

