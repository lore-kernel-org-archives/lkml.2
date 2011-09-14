Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1INI5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:57:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:40509 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1INI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:57:22 -0400
Date: Wed, 14 Sep 2011 10:57:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Alarmtimers items for 3.2
In-Reply-To: <alpine.LFD.2.02.1109141029070.2723@ionos>
Message-ID: <alpine.LFD.2.02.1109141056330.2723@ionos>
References: <1315969056.18406.89.camel@work-vm> <alpine.LFD.2.02.1109141029070.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Thomas Gleixner wrote:

> On Tue, 13 Sep 2011, john stultz wrote:
> 
> > Hey Thomas, 
> > 	Just wanted to get the alarmtimer rework to better match the hrtimer
> > code as well as some alarmtimer cleanups queued into -tip for 3.2.
> > 
> > Let me know if you have any thoughts or issues with these patches.
> 
> They are in tip/timers/core and next already :)

FYI, I fixed up the error handling code with the following commit:

commit 4523f6ada86853750565c68e17126af2e3df9b8a
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Sep 14 10:54:29 2011 +0200

    alarmtimers: Fix error handling
    
    commit 8bc0daf (alarmtimers: Rework RTC device selection using class
    interface) did not implement required error checks. Add them.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 154d556..c436e79 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -100,19 +100,25 @@ static struct class_interface alarmtimer_rtc_interface = {
 	.add_dev = &alarmtimer_rtc_add_device,
 };
 
-static void alarmtimer_rtc_interface_setup(void)
+static int alarmtimer_rtc_interface_setup(void)
 {
 	alarmtimer_rtc_interface.class = rtc_class;
-	class_interface_register(&alarmtimer_rtc_interface);
+	return class_interface_register(&alarmtimer_rtc_interface);
+}
+static void alarmtimer_rtc_interface_remove(void)
+{
+	class_interface_unregister(&alarmtimer_rtc_interface);
 }
 #else
-#define alarmtimer_get_rtcdev() (0)
-#define rtcdev (0)
-#define alarmtimer_rtc_interface_setup()
+static inline struct rtc_device *alarmtimer_get_rtcdev(void)
+{
+	return NULL;
+}
+#define rtcdev (NULL)
+static inline int alarmtimer_rtc_interface_setup(void) { return 0; }
+static inline void alarmtimer_rtc_interface_remove(void) { }
 #endif
 
-
-
 /**
  * alarmtimer_enqueue - Adds an alarm timer to an alarm_base timerqueue
  * @base: pointer to the base where the timer is being run
@@ -764,6 +770,7 @@ static struct platform_driver alarmtimer_driver = {
  */
 static int __init alarmtimer_init(void)
 {
+	struct platform_device *pdev;
 	int error = 0;
 	int i;
 	struct k_clock alarm_clock = {
@@ -793,11 +800,25 @@ static int __init alarmtimer_init(void)
 		alarm_bases[i].timer.function = alarmtimer_fired;
 	}
 
-	alarmtimer_rtc_interface_setup();
+	error = alarmtimer_rtc_interface_setup();
+	if (error)
+		return error;
+
 	error = platform_driver_register(&alarmtimer_driver);
-	platform_device_register_simple("alarmtimer", -1, NULL, 0);
+	if (error)
+		goto out_if;
 
+	pdev = platform_device_register_simple("alarmtimer", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		error = PTR_ERR(pdev);
+		goto out_drv;
+	}
+	return 0;
+
+out_drv:
+	platform_driver_unregister(&alarmtimer_driver);
+out_if:
+	alarmtimer_rtc_interface_remove();
 	return error;
 }
 device_initcall(alarmtimer_init);
-
