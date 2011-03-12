Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1CLVWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:22:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53651 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1CLVWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:22:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] timekeeping: Use syscore_ops instead of sysdev class and sysdev
Date: Sat, 12 Mar 2011 22:17:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl>
In-Reply-To: <201103122212.40828.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103122217.34004.rjw@sisk.pl>
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
@@ -561,13 +561,12 @@ static struct timespec timekeeping_suspe
 
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
@@ -596,11 +595,9 @@ static int timekeeping_resume(struct sys
 
 	/* Resume hrtimers */
 	hres_timers_resume();
-
-	return 0;
 }
 
-static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
+static int timekeeping_suspend(void)
 {
 	unsigned long flags;
 
@@ -618,26 +615,18 @@ static int timekeeping_suspend(struct sy
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

