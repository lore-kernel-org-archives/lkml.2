Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1LHUxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:53:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1LHUxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:53:01 -0500
Date: Thu, 8 Dec 2011 12:52:34 -0800
From: tip-bot for Mark Langsdorf <mark.langsdorf@amd.com>
Message-ID: <tip-2ded6e6a94c98ea453a156748cb7fabaf39a76b9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, mark.langsdorf@amd.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, mark.langsdorf@amd.com, tglx@linutronix.de
In-Reply-To: <20111118153306.GB16319@alberich.amd.com>
References: <20111118153306.GB16319@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hpet: Immediately disable HPET timer 1 if rtc irq is masked
Git-Commit-ID: 2ded6e6a94c98ea453a156748cb7fabaf39a76b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Dec 2011 12:52:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ded6e6a94c98ea453a156748cb7fabaf39a76b9
Gitweb:     http://git.kernel.org/tip/2ded6e6a94c98ea453a156748cb7fabaf39a76b9
Author:     Mark Langsdorf <mark.langsdorf@amd.com>
AuthorDate: Fri, 18 Nov 2011 16:33:06 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 8 Dec 2011 21:47:22 +0100

x86, hpet: Immediately disable HPET timer 1 if rtc irq is masked

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
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/hpet.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

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
