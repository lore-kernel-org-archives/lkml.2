Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2GDQNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:13:34 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:48868
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab2GDQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:13:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z37d4lzzz1202hzz8275dhz2dh87h2a8h668h839hd24he5bhe96hf0ah)
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] alarmtimer: add .remove_dev hook to put device
Date: Thu, 5 Jul 2012 00:13:07 +0800
Message-ID: <1341418387-10038-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a test sequence that installs a rtc module, remove it
and installs it again.

$ insmod rtc-snvs.ko
snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered 20cc034.snvs-rtc-lp as rtc0
$ hwclock
Thu Jul  5 08:53:35 2012  0.000000 seconds
$ rmmod rtc-snvs.ko
$ insmod rtc-snvs.ko
snvs_rtc 20cc034.snvs-rtc-lp: rtc core: registered 20cc034.snvs-rtc-lp as rtc1
$ hwclock
hwclock: can't open '/dev/misc/rtc': No such file or directory
$

The device is registered as rtc0 for the first time insmod, while it
becomes rtc1 with the later insmod.

It's root caused by alarmtimer which never puts the device even when
the rtc is removed.  The patch adds a .remove_dev hook to have device
properly put, so that above insmod/rmmod sequence can the rtc device
registered in a consistent behavior.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 kernel/time/alarmtimer.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index aa27d39..39e8773 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -96,6 +96,17 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 	return 0;
 }
 
+static void alarmtimer_rtc_remove_device(struct device *dev,
+				struct class_interface *class_intf)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtcdev_lock, flags);
+	rtcdev = NULL;
+	put_device(dev);
+	spin_unlock_irqrestore(&rtcdev_lock, flags);
+}
+
 static inline void alarmtimer_rtc_timer_init(void)
 {
 	rtc_timer_init(&rtctimer, NULL, NULL);
@@ -103,6 +114,7 @@ static inline void alarmtimer_rtc_timer_init(void)
 
 static struct class_interface alarmtimer_rtc_interface = {
 	.add_dev = &alarmtimer_rtc_add_device,
+	.remove_dev = &alarmtimer_rtc_remove_device,
 };
 
 static int alarmtimer_rtc_interface_setup(void)
-- 
1.7.5.4


