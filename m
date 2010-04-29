Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab0D3SDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:03:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41849 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759028Ab0D3SC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:02:29 -0400
Date: Thu, 29 Apr 2010 15:08:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
Message-ID: <20100429130852.GC1661@ucw.cz>
References: <20100106071026.GD1382@ucw.cz>
 <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
 <20100107065230.GA1303@ucw.cz>
 <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
 <20100305092338.GA32433@atrey.karlin.mff.cuni.cz>
 <f17812d71003072135wcc7165m31a302b7da75c36e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d71003072135wcc7165m31a302b7da75c36e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Okay, maybe this is better fix for the regression?

Simplify irq wakeup code, and fix ugly warning during resume on spitz
as a result.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- ./drivers/input/keyboard/pxa27x_keypad.c	2010-04-15 07:50:34.000000000 +0200
+++ ./drivers/input/keyboard/pxa27x_keypad.c	2010-04-27 15:38:02.000000000 +0200
@@ -33,6 +33,8 @@
 
 #include <mach/hardware.h>
 #include <mach/pxa27x_keypad.h>
+#include <mach/mfp-pxa2xx.h>
+
 /*
  * Keypad Controller registers
  */
@@ -412,7 +416,7 @@
 	clk_disable(keypad->clk);
 
 	if (device_may_wakeup(&pdev->dev))
-		enable_irq_wake(keypad->irq);
+		keypad_set_wake(1);
 
 	return 0;
 }
@@ -424,7 +428,7 @@
 	struct input_dev *input_dev = keypad->input_dev;
 
 	if (device_may_wakeup(&pdev->dev))
-		disable_irq_wake(keypad->irq);
+		keypad_set_wake(0);
 
 	mutex_lock(&input_dev->mutex);
 
--- ./arch/arm/mach-pxa/mfp-pxa2xx.c	2009-09-10 00:13:59.000000000 +0200
+++ ./arch/arm/mach-pxa/mfp-pxa2xx.c	2010-04-27 15:22:42.000000000 +0200
@@ -34,7 +34,6 @@
 struct gpio_desc {
 	unsigned	valid		: 1;
 	unsigned	can_wakeup	: 1;
-	unsigned	keypad_gpio	: 1;
 	unsigned	dir_inverted	: 1;
 	unsigned int	mask; /* bit mask in PWER or PKWR */
 	unsigned int	mux_mask; /* bit mask of muxed gpio bits, 0 if no mux */
@@ -178,9 +177,6 @@
 	if (!d->valid)
 		return -EINVAL;
 
-	if (d->keypad_gpio)
-		return -EINVAL;
-
 	mux_taken = (PWER & d->mux_mask) & (~d->mask);
 	if (on && mux_taken)
 		return -EBUSY;
@@ -291,7 +288,6 @@
 	for (i = 0; i < ARRAY_SIZE(pxa27x_pkwr_gpio); i++) {
 		gpio = pxa27x_pkwr_gpio[i];
 		gpio_desc[gpio].can_wakeup = 1;
-		gpio_desc[gpio].keypad_gpio = 1;
 		gpio_desc[gpio].mask = 1 << i;
 	}
 
--- ./arch/arm/mach-pxa/pxa27x.c	2010-03-21 22:09:12.000000000 +0100
+++ ./arch/arm/mach-pxa/pxa27x.c	2010-04-27 07:43:30.000000000 +0200
@@ -342,9 +342,6 @@
 	if (gpio >= 0 && gpio < 128)
 		return gpio_set_wake(gpio, on);
 
-	if (irq == IRQ_KEYPAD)
-		return keypad_set_wake(on);
-
 	switch (irq) {
 	case IRQ_RTCAlrm:
 		mask = PWER_RTC;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
