Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1CNTyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:54:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59465 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1CNTyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:54:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: [Update] Re: [PATCH 10/10] ARM: Use struct syscore_ops instead of sysdevs for PM in timer and leds
Date: Mon, 14 Mar 2011 20:54:57 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl> <201103131404.33311.rjw@sisk.pl> <4D7DDA9C.9020700@codeaurora.org>
In-Reply-To: <4D7DDA9C.9020700@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103142054.57999.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 14, 2011, Stephen Boyd wrote:
> On 3/13/2011 6:04 AM, Rafael J. Wysocki wrote:
> >   #if defined(CONFIG_PM)&&  !defined(CONFIG_GENERIC_CLOCKEVENTS)
> > -static int timer_suspend(struct sys_device *dev, pm_message_t state)
> > +static int timer_suspend(void)
> >   {
> > -	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
> > -
> > -	if (timer->suspend != NULL)
> > +	if (system_timer->suspend)
> >   		timer->suspend();
> >
> 
> Shouldn't this be system_timer->suspend() ?

Indeed, thanks a lot!

I must have forgotten to test it with CONFIG_GENERIC_CLOCKEVENTS unset.

Updated patch follows.

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ARM: Use struct syscore_ops instead of sysdevs for PM in timer and leds

Convert arch/arm/kernel/time.c and arch/arm/kernel/leds.c to using
struct syscore_ops for power management instead of sysdev classes
and sysdevs.

This simplifies the code in arch/arm/kernel/time.c quite a bit and is
necessary for removing sysdevs from the kernel entirely in future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/include/asm/mach/time.h |    1 -
 arch/arm/kernel/leds.c           |   28 ++++++++++++++++------------
 arch/arm/kernel/time.c           |   35 ++++++++++++-----------------------
 3 files changed, 28 insertions(+), 36 deletions(-)

Index: linux-2.6/arch/arm/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/time.c
+++ linux-2.6/arch/arm/kernel/time.c
@@ -21,7 +21,7 @@
 #include <linux/timex.h>
 #include <linux/errno.h>
 #include <linux/profile.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/timer.h>
 #include <linux/irq.h>
 
@@ -117,48 +117,37 @@ void timer_tick(void)
 #endif
 
 #if defined(CONFIG_PM) && !defined(CONFIG_GENERIC_CLOCKEVENTS)
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
+static int timer_suspend(void)
 {
-	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
-
-	if (timer->suspend != NULL)
-		timer->suspend();
+	if (system_timer->suspend)
+		system_timer->suspend();
 
 	return 0;
 }
 
-static int timer_resume(struct sys_device *dev)
+static void timer_resume(void)
 {
-	struct sys_timer *timer = container_of(dev, struct sys_timer, dev);
-
-	if (timer->resume != NULL)
-		timer->resume();
-
-	return 0;
+	if (system_timer->resume)
+		system_timer->resume();
 }
 #else
 #define timer_suspend NULL
 #define timer_resume NULL
 #endif
 
-static struct sysdev_class timer_sysclass = {
-	.name		= "timer",
+static struct syscore_ops timer_syscore_ops = {
 	.suspend	= timer_suspend,
 	.resume		= timer_resume,
 };
 
-static int __init timer_init_sysfs(void)
+static int __init timer_init_syscore_ops(void)
 {
-	int ret = sysdev_class_register(&timer_sysclass);
-	if (ret == 0) {
-		system_timer->dev.cls = &timer_sysclass;
-		ret = sysdev_register(&system_timer->dev);
-	}
+	register_syscore_ops(&timer_syscore_ops);
 
-	return ret;
+	return 0;
 }
 
-device_initcall(timer_init_sysfs);
+device_initcall(timer_init_syscore_ops);
 
 void __init time_init(void)
 {
Index: linux-2.6/arch/arm/include/asm/mach/time.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/mach/time.h
+++ linux-2.6/arch/arm/include/asm/mach/time.h
@@ -34,7 +34,6 @@
  *   timer interrupt which may be pending.
  */
 struct sys_timer {
-	struct sys_device	dev;
 	void			(*init)(void);
 	void			(*suspend)(void);
 	void			(*resume)(void);
Index: linux-2.6/arch/arm/kernel/leds.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/leds.c
+++ linux-2.6/arch/arm/kernel/leds.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/leds.h>
 
@@ -69,36 +70,37 @@ static ssize_t leds_store(struct sys_dev
 
 static SYSDEV_ATTR(event, 0200, NULL, leds_store);
 
-static int leds_suspend(struct sys_device *dev, pm_message_t state)
+static struct sysdev_class leds_sysclass = {
+	.name		= "leds",
+};
+
+static struct sys_device leds_device = {
+	.id		= 0,
+	.cls		= &leds_sysclass,
+};
+
+static int leds_suspend(void)
 {
 	leds_event(led_stop);
 	return 0;
 }
 
-static int leds_resume(struct sys_device *dev)
+static void leds_resume(void)
 {
 	leds_event(led_start);
-	return 0;
 }
 
-static int leds_shutdown(struct sys_device *dev)
+static void leds_shutdown(void)
 {
 	leds_event(led_halted);
-	return 0;
 }
 
-static struct sysdev_class leds_sysclass = {
-	.name		= "leds",
+static struct syscore_ops leds_syscore_ops = {
 	.shutdown	= leds_shutdown,
 	.suspend	= leds_suspend,
 	.resume		= leds_resume,
 };
 
-static struct sys_device leds_device = {
-	.id		= 0,
-	.cls		= &leds_sysclass,
-};
-
 static int __init leds_init(void)
 {
 	int ret;
@@ -107,6 +109,8 @@ static int __init leds_init(void)
 		ret = sysdev_register(&leds_device);
 	if (ret == 0)
 		ret = sysdev_create_file(&leds_device, &attr_event);
+	if (ret == 0)
+		register_syscore_ops(&leds_syscore_ops);
 	return ret;
 }
 
