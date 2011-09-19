Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1ISLN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:13:29 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:9813 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab1ISLN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:13:28 -0400
From: Daniel Drake <dsd@laptop.org>
To: linux-kernel@vger.kernel.org
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: rjw@sisk.pl
Subject: [RFC] wait for VX855 RTC to become ready during resume
Message-Id: <20110919103637.E116D9D401D@zog.reactivated.net>
Date: Mon, 19 Sep 2011 11:36:37 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=jwUoSOChzJQA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=0wjSPlKjOhvm3-eco4YA:9 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As diagnosed at http://dev.laptop.org/ticket/10757 we are finding that
the RTC on the VIA VX855 frequently is not 'ready' during system resume.

Reading from it produces zero. This causes the resume code to fail to
increment the system clock for the amount of time that was spent sleeping,
so the time is then wrong.

We have found that if we wait for the RTC_REF_CLCK_32KHZ signal, the RTC
does soon start returning 'good' values.

The patch below demonstrates the solution we have found, but will probably
make x86 maintainers cry. What would be a good approach to get this
appropriately quirked and worked around? Detect VX855 southbridge on PCI bus
and apply the quirk in this case? Do it from OLPC platform code?

Thanks,
Daniel


---
 arch/x86/kernel/rtc.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 88ee70d..3ad2e47 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -100,6 +100,21 @@ unsigned long mach_get_cmos_time(void)
 	unsigned int status, year, mon, day, hour, min, sec, century = 0;
 
 	/*
+	 * dev.laptop.org #10757, sometimes the RTC returns zero data
+	 * immediately after a resume, so this code will give it some
+	 * more time by waiting for the 32KHz clock bit to be set, in the
+	 * hope that this means it is ready to be used.
+	 */
+	if (!(CMOS_READ(RTC_FREQ_SELECT) & RTC_REF_CLCK_32KHZ)) {
+		int n = 0;
+		printk(KERN_INFO "rtc is insane, waiting for it\n");
+		while (!(CMOS_READ(RTC_FREQ_SELECT) & RTC_REF_CLCK_32KHZ)) {
+			cpu_relax();
+			n++;
+		}
+		printk(KERN_INFO "rtc was insane for %d counts\n", n);
+	}
+	/*
 	 * If UIP is clear, then we have >= 244 microseconds before
 	 * RTC registers will be updated.  Spec sheet says that this
 	 * is the reliable way to read RTC - registers. If UIP is set
-- 
1.7.6.2

