Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1LVSGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:06:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60034 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1LVSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:06:52 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Eimn/Vr0IypZKNWjYFRoR
Date: Thu, 22 Dec 2011 10:06:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: serio: ams-delta: toggle keyboard power over
 GPIO
Message-ID: <20111222180629.GK24444@atomide.com>
References: <378bcda9c6cb6a1ddeeb54817078bc7ec68c5987.1324331816.git.jkrzyszt@tis.icnet.pl>
 <1324419034-31024-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <20111221190945.GD24444@atomide.com>
 <201112212055.10343.jkrzyszt@tis.icnet.pl>
 <20111222174537.GB21103@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222174537.GB21103@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov <dmitry.torokhov@gmail.com> [111222 09:13]:
> On Wed, Dec 21, 2011 at 08:55:09PM +0100, Janusz Krzysztofik wrote:
> > On Wednesday 21 of December 2011 at 20:09:45, Tony Lindgren wrote:
> > > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111220 13:39]:
> > > > Don't use Amstrad Delta custom I/O functions once GPIO interface is
> > > > available for the underlying hardware.
> > > > 
> > > > While requesting and initializing GPIO pins used, also take care of one
> > > > extra pin KEYBRD_DATAOUT which, even if not used by the driver, belongs
> > > > to the device and affects its functioning.
> > > > 
> > > > Once done, move the driver initialization back to the device_initcall
> > > > level, reverting the temporary chane introduced with patch 1/7 "ARM:
> > > > OMAP1: ams-delta: register latch dependent devices later".  That change
> > > > is no longer required once the driver takes care of registering used
> > > > GPIO pins, and it's better to initialize the device before others using
> > > > the latch2 based GPIO pins, otherwise a garbage is reported on boot,
> > > > perhaps due to random data already captured by the FIQ handler while the
> > > > keyboard related latch bits are written with random values during
> > > > initialization of those other latch2 dependent devices.
> > > > 
> > > > Depends on patch 2/7 "ARM: OMAP1: ams-delta: convert latches to
> > > > basic_mmio_gpio"
> > > > 
> > > > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > > 
> > > I'm assuming Dmitry's ack for an earlier version of this patch also
> > > covers this one when applying.
> > 
> > Hi Dmitry,
> > Can we assume your ack still valid for this version?
> > 
> 
> Yes, please merge with your other changes.

OK thanks.
 
> BTW, if you could rename :static struct gpio _gpios" to "ams_delta_gpios"
> that would be even better.

Done, pushing into omap1-part2 branch with the updated patch below.

Regards,

Tony


From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Date: Tue, 20 Dec 2011 23:10:34 +0100
Subject: [PATCH] input: serio: ams-delta: toggle keyboard power over GPIO

Don't use Amstrad Delta custom I/O functions once GPIO interface is
available for the underlying hardware.

While requesting and initializing GPIO pins used, also take care of one
extra pin KEYBRD_DATAOUT which, even if not used by the driver, belongs
to the device and affects its functioning.

Once done, move the driver initialization back to the device_initcall
level, reverting the temporary chane introduced with patch 1/7 "ARM:
OMAP1: ams-delta: register latch dependent devices later".  That change
is no longer required once the driver takes care of registering used
GPIO pins, and it's better to initialize the device before others using
the latch2 based GPIO pins, otherwise a garbage is reported on boot,
perhaps due to random data already captured by the FIQ handler while the
keyboard related latch bits are written with random values during
initialization of those other latch2 dependent devices.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
[tony@atomide.com: renamed _gpios to ams_delta_gpios]
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 3aba8f9..673cf21 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -227,16 +227,6 @@ static struct gpio latch_gpios[] __initconst = {
 		.label	= "dockit2",
 	},
 	{
-		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "keybrd_pwr",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATAOUT,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "keybrd_dataout",
-	},
-	{
 		.gpio	= AMS_DELTA_GPIO_PIN_SCARD_RSTIN,
 		.flags	= GPIOF_OUT_INIT_LOW,
 		.label	= "scard_rstin",
diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index e9ad673..027e79e 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -28,8 +28,6 @@
 
 #if defined (CONFIG_MACH_AMS_DELTA)
 
-#define AMD_DELTA_LATCH2_KEYBRD_PWR	0x0100
-#define AMD_DELTA_LATCH2_KEYBRD_DATA	0x0200
 #define AMD_DELTA_LATCH2_SCARD_RSTIN	0x0400
 #define AMD_DELTA_LATCH2_SCARD_CMDVCC	0x0800
 #define AMS_DELTA_LATCH2_MODEM_NRESET	0x1000
diff --git a/drivers/input/serio/ams_delta_serio.c b/drivers/input/serio/ams_delta_serio.c
index 835d37a..0571e2e 100644
--- a/drivers/input/serio/ams_delta_serio.c
+++ b/drivers/input/serio/ams_delta_serio.c
@@ -92,8 +92,7 @@ static irqreturn_t ams_delta_serio_interrupt(int irq, void *dev_id)
 static int ams_delta_serio_open(struct serio *serio)
 {
 	/* enable keyboard */
-	ams_delta_latch2_write(AMD_DELTA_LATCH2_KEYBRD_PWR,
-			AMD_DELTA_LATCH2_KEYBRD_PWR);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_KEYBRD_PWR, 1);
 
 	return 0;
 }
@@ -101,9 +100,32 @@ static int ams_delta_serio_open(struct serio *serio)
 static void ams_delta_serio_close(struct serio *serio)
 {
 	/* disable keyboard */
-	ams_delta_latch2_write(AMD_DELTA_LATCH2_KEYBRD_PWR, 0);
+	gpio_set_value(AMS_DELTA_GPIO_PIN_KEYBRD_PWR, 0);
 }
 
+static struct gpio ams_delta_gpios[] __initconst_or_module = {
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATA,
+		.flags	= GPIOF_DIR_IN,
+		.label	= "serio-data",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_CLK,
+		.flags	= GPIOF_DIR_IN,
+		.label	= "serio-clock",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_PWR,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "serio-power",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_KEYBRD_DATAOUT,
+		.flags	= GPIOF_OUT_INIT_LOW,
+		.label	= "serio-dataout",
+	},
+};
+
 static int __init ams_delta_serio_init(void)
 {
 	int err;
@@ -123,19 +145,12 @@ static int __init ams_delta_serio_init(void)
 	strlcpy(ams_delta_serio->phys, "GPIO/serio0",
 			sizeof(ams_delta_serio->phys));
 
-	err = gpio_request(AMS_DELTA_GPIO_PIN_KEYBRD_DATA, "serio-data");
+	err = gpio_request_array(ams_delta_gpios,
+				ARRAY_SIZE(ams_delta_gpios));
 	if (err) {
-		pr_err("ams_delta_serio: Couldn't request gpio pin for data\n");
+		pr_err("ams_delta_serio: Couldn't request gpio pins\n");
 		goto serio;
 	}
-	gpio_direction_input(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
-
-	err = gpio_request(AMS_DELTA_GPIO_PIN_KEYBRD_CLK, "serio-clock");
-	if (err) {
-		pr_err("ams_delta_serio: couldn't request gpio pin for clock\n");
-		goto gpio_data;
-	}
-	gpio_direction_input(AMS_DELTA_GPIO_PIN_KEYBRD_CLK);
 
 	err = request_irq(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK),
 			ams_delta_serio_interrupt, IRQ_TYPE_EDGE_RISING,
@@ -143,7 +158,7 @@ static int __init ams_delta_serio_init(void)
 	if (err < 0) {
 		pr_err("ams_delta_serio: couldn't request gpio interrupt %d\n",
 				gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
-		goto gpio_clk;
+		goto gpio;
 	}
 	/*
 	 * Since GPIO register handling for keyboard clock pin is performed
@@ -157,21 +172,20 @@ static int __init ams_delta_serio_init(void)
 	dev_info(&ams_delta_serio->dev, "%s\n", ams_delta_serio->name);
 
 	return 0;
-gpio_clk:
-	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_CLK);
-gpio_data:
-	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
+gpio:
+	gpio_free_array(ams_delta_gpios,
+			ARRAY_SIZE(ams_delta_gpios));
 serio:
 	kfree(ams_delta_serio);
 	return err;
 }
-late_initcall(ams_delta_serio_init);
+module_init(ams_delta_serio_init);
 
 static void __exit ams_delta_serio_exit(void)
 {
 	serio_unregister_port(ams_delta_serio);
 	free_irq(OMAP_GPIO_IRQ(AMS_DELTA_GPIO_PIN_KEYBRD_CLK), 0);
-	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_CLK);
-	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
+	gpio_free_array(ams_delta_gpios,
+			ARRAY_SIZE(ams_delta_gpios));
 }
 module_exit(ams_delta_serio_exit);
