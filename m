Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab1LPTwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:52:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843Ab1LPTu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:59 2011
Message-Id: <20111216194559.540097947@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Langsdorf <mark.langsdorf@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [34/53] x86, hpet: Immediately disable HPET timer 1 if rtc irq is masked
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Langsdorf <mark.langsdorf@amd.com>

commit 2ded6e6a94c98ea453a156748cb7fabaf39a76b9 upstream.

When HPET is operating in RTC mode, the TN_ENABLE bit on timer1
controls whether the HPET or the RTC delivers interrupts to irq8. When
the system goes into suspend, the RTC driver sends a signal to the
HPET driver so that the HPET releases control of irq8, allowing the
RTC to wake the system from suspend. The switchover is accomplished by
a write to the HPET configuration registers which currently only
occurs while servicing the HPET interrupt.

On some systems, I have seen the system suspend before an HPET
interrupt occurs, preventing the write to the HPET configuration
register and leaving the HPET in control of the irq8. As the HPET is
not active during suspend, it does not generate a wake signal and RTC
alarms do not work.

This patch forces the HPET driver to immediately transfer control of
the irq8 channel to the RTC instead of waiting until the next
interrupt event.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Link: http://lkml.kernel.org/r/20111118153306.GB16319@alberich.amd.com
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

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
@@ -1059,6 +1067,9 @@ int hpet_mask_rtc_irq_bit(unsigned long
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


