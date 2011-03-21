Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1CUXjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:39:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab1CUXi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:38:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/6] timekeeping: Use syscore_ops instead of sysdev class and sysdev
Date: Tue, 22 Mar 2011 00:35:21 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        cpufreq@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103220031.22729.rjw@sisk.pl>
In-Reply-To: <201103220031.22729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103220035.22026.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The timekeeping subsystem uses a sysdev class and a sysdev for
executing timekeeping_suspend() after interrupts have been turned off
on the boot CPU (during system suspend) and for executing
timekeeping_resume() before turning on interrupts on the boot CPU
(during system resume).  However, since both of these functions
ignore their arguments, the entire mechanism may be replaced with a
struct syscore_ops object which is simpler.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
@@ -597,13 +597,12 @@ static struct timespec timekeeping_suspe
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
- * @dev:	unused
  *
  * This is for the generic clocksource timekeeping.
  * xtime/wall_to_monotonic/jiffies/etc are
  * still managed by arch specific suspend/resume code.
  */
-static int timekeeping_resume(struct sys_device *dev)
+static void timekeeping_resume(void)
 {
 	unsigned long flags;
 	struct timespec ts;
@@ -632,11 +631,9 @@ static int timekeeping_resume(struct sys
 
 	/* Resume hrtimers */
 	hres_timers_resume();
-
-	return 0;
 }
 
-static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
+static int timekeeping_suspend(void)
 {
 	unsigned long flags;
 
@@ -654,26 +651,18 @@ static int timekeeping_suspend(struct sy
 }
 
 /* sysfs resume/suspend bits for timekeeping */
-static struct sysdev_class timekeeping_sysclass = {
-	.name		= "timekeeping",
+static struct syscore_ops timekeeping_syscore_ops = {
 	.resume		= timekeeping_resume,
 	.suspend	= timekeeping_suspend,
 };
 
-static struct sys_device device_timer = {
-	.id		= 0,
-	.cls		= &timekeeping_sysclass,
-};
-
-static int __init timekeeping_init_device(void)
+static int __init timekeeping_init_ops(void)
 {
-	int error = sysdev_class_register(&timekeeping_sysclass);
-	if (!error)
-		error = sysdev_register(&device_timer);
-	return error;
+	register_syscore_ops(&timekeeping_syscore_ops);
+	return 0;
 }
 
-device_initcall(timekeeping_init_device);
+device_initcall(timekeeping_init_ops);
 
 /*
  * If the error is already larger, we look ahead even further

