Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2LLIYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:24:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab2LLIYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:24:46 -0500
Date: Wed, 12 Dec 2012 19:24:30 +1100
From: NeilBrown <neilb@suse.de>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>
Cc: linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20121212192430.50cea126@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JV1FnqCm4WSVBA7=6.QlDhQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JV1FnqCm4WSVBA7=6.QlDhQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



This patch is based on an earlier patch by Grant Erickson
which provided pwm devices using the 'legacy' interface.

This driver instead uses the new framework interface.

Cc: Grant Erickson <marathon96@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index ed81720..7df573a 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -85,6 +85,15 @@ config PWM_MXS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-mxs.
=20
+config PWM_OMAP
+	tristate "OMAP pwm support"
+	depends on ARCH_OMAP
+	help
+	  Generic PWM framework driver for OMAP
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-omap
+
 config PWM_PUV3
 	tristate "PKUnity NetBook-0916 PWM support"
 	depends on ARCH_PUV3
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index acfe482..f5d200d 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PWM_IMX)		+=3D pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+=3D pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+=3D pwm-lpc32xx.o
 obj-$(CONFIG_PWM_MXS)		+=3D pwm-mxs.o
+obj-$(CONFIG_PWM_OMAP)		+=3D pwm-omap.o
 obj-$(CONFIG_PWM_PUV3)		+=3D pwm-puv3.o
 obj-$(CONFIG_PWM_PXA)		+=3D pwm-pxa.o
 obj-$(CONFIG_PWM_SAMSUNG)	+=3D pwm-samsung.o
diff --git a/drivers/pwm/pwm-omap.c b/drivers/pwm/pwm-omap.c
new file mode 100644
index 0000000..e3dbce3
--- /dev/null
+++ b/drivers/pwm/pwm-omap.c
@@ -0,0 +1,318 @@
+/*
+ *    Copyright (c) 2012 NeilBrown <neilb@suse.de>
+ *    Heavily based on earlier code which is:
+ *    Copyright (c) 2010 Grant Erickson <marathon96@gmail.com>
+ *
+ *    Also based on pwm-samsung.c
+ *
+ *    This program is free software; you can redistribute it and/or
+ *    modify it under the terms of the GNU General Public License
+ *    version 2 as published by the Free Software Foundation.
+ *
+ *    Description:
+ *      This file is the core OMAP2/3 support for the generic, Linux
+ *      PWM driver / controller, using the OMAP's dual-mode timers.
+ *
+ *    The 'id' number for the device encodes the number of the dm timer
+ *    to use, and the polarity of the output.
+ *    lsb is '1' of active-high, and '0' for active low
+ *    remaining bit a timer number and need to be shifted down before use.
+ */
+
+#define pr_fmt(fmt) "pwm-omap: " fmt
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/pwm.h>
+#include <linux/module.h>
+
+#include <plat/dmtimer.h>
+
+#define DM_TIMER_LOAD_MIN		0xFFFFFFFE
+
+struct omap_chip {
+	struct platform_device	*pdev;
+
+	struct omap_dm_timer	*dm_timer;
+	unsigned int		polarity;
+	const char		*label;
+
+	unsigned int		duty_ns, period_ns;
+	struct pwm_chip		chip;
+};
+
+#define to_omap_chip(chip)	container_of(chip, struct omap_chip, chip)
+
+#define	pwm_dbg(_pwm, msg...) dev_dbg(&(_pwm)->pdev->dev, msg)
+
+/**
+ * pwm_calc_value - determines the counter value for a clock rate and peri=
od.
+ * @clk_rate: The clock rate, in Hz, of the PWM's clock source to compute =
the
+ *            counter value for.
+ * @ns: The period, in nanoseconds, to computer the counter value for.
+ *
+ * Returns the PWM counter value for the specified clock rate and period.
+ */
+static inline int pwm_calc_value(unsigned long clk_rate, int ns)
+{
+	const unsigned long nanoseconds_per_second =3D 1000000000;
+	int cycles;
+	__u64 c;
+
+	c =3D (__u64)clk_rate * ns;
+	do_div(c, nanoseconds_per_second);
+	cycles =3D c;
+
+	return DM_TIMER_LOAD_MIN - cycles;
+}
+
+static int omap_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct omap_chip *omap =3D to_omap_chip(chip);
+	int status =3D 0;
+
+	/* Enable the counter--always--before attempting to write its
+	 * registers and then set the timer to its minimum load value to
+	 * ensure we get an overflow event right away once we start it.
+	 */
+
+	omap_dm_timer_enable(omap->dm_timer);
+	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
+	omap_dm_timer_start(omap->dm_timer);
+	omap_dm_timer_disable(omap->dm_timer);
+
+	return status;
+}
+
+static void omap_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct omap_chip *omap =3D to_omap_chip(chip);
+
+	omap_dm_timer_stop(omap->dm_timer);
+}
+
+static int omap_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			   int duty_ns, int period_ns)
+{
+	struct omap_chip *omap =3D to_omap_chip(chip);
+	int status =3D 0;
+	const bool enable =3D true;
+	const bool autoreload =3D true;
+	const bool toggle =3D true;
+	const int trigger =3D OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE;
+	int load_value, match_value;
+	unsigned long clk_rate;
+
+	dev_dbg(chip->dev,
+		"duty cycle: %d, period %d\n",
+		duty_ns, period_ns);
+
+	if (omap->duty_ns =3D=3D duty_ns &&
+	    omap->period_ns =3D=3D period_ns)
+		/* No change - don't cause any transients */
+		return 0;
+
+	clk_rate =3D clk_get_rate(omap_dm_timer_get_fclk(omap->dm_timer));
+
+	/* Calculate the appropriate load and match values based on the
+	 * specified period and duty cycle. The load value determines the
+	 * cycle time and the match value determines the duty cycle.
+	 */
+
+	load_value =3D pwm_calc_value(clk_rate, period_ns);
+	match_value =3D pwm_calc_value(clk_rate, period_ns - duty_ns);
+
+	/* We MUST enable yet stop the associated dual-mode timer before
+	 * attempting to write its registers.  Hopefully it is already
+	 * disabled, but call the (idempotent) pwm_disable just in case
+	 */
+
+	pwm_disable(pwm);
+
+	omap_dm_timer_enable(omap->dm_timer);
+
+	omap_dm_timer_set_load(omap->dm_timer, autoreload, load_value);
+	omap_dm_timer_set_match(omap->dm_timer, enable, match_value);
+
+	dev_dbg(chip->dev,
+			"load value: %#08x (%d), "
+			"match value: %#08x (%d)\n",
+			load_value, load_value,
+			match_value, match_value);
+
+	omap_dm_timer_set_pwm(omap->dm_timer,
+			      !omap->polarity,
+			      toggle,
+			      trigger);
+
+	/* Set the counter to generate an overflow event immediately. */
+
+	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
+
+	/* Now that we're done configuring the dual-mode timer, disable it
+	 * again. We'll enable and start it later, when requested.
+	 */
+
+	omap_dm_timer_disable(omap->dm_timer);
+	omap->duty_ns =3D duty_ns;
+	omap->period_ns =3D period_ns;
+
+	return status;
+}
+
+
+static struct pwm_ops omap_pwm_ops =3D {
+	.enable	=3D omap_pwm_enable,
+	.disable=3D omap_pwm_disable,
+	.config	=3D omap_pwm_config,
+	.owner	=3D THIS_MODULE,
+};
+
+/**
+ * omap_pwm_probe - check for the PWM and bind it to the driver.
+ * @pdev: A pointer to the platform device node associated with the
+ *        PWM instance to be probed for driver binding.
+ *
+ * Returns 0 if the PWM instance was successfully bound to the driver;
+ * otherwise, < 0 on error.
+ */
+static int __devinit omap_pwm_probe(struct platform_device *pdev)
+{
+	struct device *dev =3D &pdev->dev;
+	struct omap_chip *omap;
+	int status =3D 0;
+	unsigned int id =3D pdev->id;
+	unsigned int timer =3D id >> 1; /* lsb is polarity */
+
+	omap =3D kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+
+	if (omap =3D=3D NULL) {
+		dev_err(dev, "Could not allocate memory.\n");
+		status =3D -ENOMEM;
+		goto done;
+	}
+
+	/* Request the OMAP dual-mode timer that will be bound to and
+	 * associated with this generic PWM.
+	 */
+
+	omap->dm_timer =3D omap_dm_timer_request_specific(timer);
+
+	if (omap->dm_timer =3D=3D NULL) {
+		status =3D -EPROBE_DEFER;
+		goto err_free;
+	}
+
+	/* Configure the source for the dual-mode timer backing this
+	 * generic PWM device. The clock source will ultimately determine
+	 * how small or large the PWM frequency can be.
+	 *
+	 * At some point, it's probably worth revisiting moving this to
+	 * the configure method and choosing either the slow- or
+	 * system-clock source as appropriate for the desired PWM period.
+	 */
+
+	omap_dm_timer_set_source(omap->dm_timer, OMAP_TIMER_SRC_SYS_CLK);
+
+	/* Cache away other miscellaneous driver-private data and state
+	 * information and add the driver-private data to the platform
+	 * device.
+	 */
+
+	omap->chip.dev =3D dev;
+	omap->chip.ops =3D &omap_pwm_ops;
+	omap->chip.base =3D -1;
+	omap->chip.npwm =3D 1;
+	omap->polarity =3D id & 1;
+
+	status =3D pwmchip_add(&omap->chip);
+	if (status < 0) {
+		dev_err(dev, "failed to register pwm\n");
+		omap_dm_timer_free(omap->dm_timer);
+		goto err_free;
+	}
+
+	platform_set_drvdata(pdev, omap);
+
+	status =3D 0;
+	goto done;
+
+ err_free:
+	kfree(omap);
+ done:
+	return status;
+}
+
+/**
+ * omap_pwm_remove - unbind the specified PWM platform device from the dri=
ver.
+ * @pdev: A pointer to the platform device node associated with the
+ *        PWM instance to be unbound/removed.
+ *
+ * Returns 0 if the PWM was successfully removed as a platform device;
+ * otherwise, < 0 on error.
+ */
+static int __devexit omap_pwm_remove(struct platform_device *pdev)
+{
+	struct omap_chip *omap =3D platform_get_drvdata(pdev);
+	int status =3D 0;
+
+	status =3D pwmchip_remove(&omap->chip);
+	if (status < 0)
+		goto done;
+
+	omap_dm_timer_free(omap->dm_timer);
+
+	kfree(omap);
+
+ done:
+	return status;
+}
+
+#if CONFIG_PM
+static int omap_pwm_suspend(struct platform_device *pdev, pm_message_t sta=
te)
+{
+	struct omap_chip *omap =3D platform_get_drvdata(pdev);
+	/* No one preserve these values during suspend so reset them
+	 * Otherwise driver leaves PWM unconfigured if same values
+	 * passed to pwm_config
+	 */
+	omap->period_ns =3D 0;
+	omap->duty_ns =3D 0;
+
+	return 0;
+}
+#else
+#define omap_pwm_suspend	NULL
+#endif
+
+static struct platform_driver omap_pwm_driver =3D {
+	.driver.name	=3D "omap-pwm",
+	.driver.owner	=3D THIS_MODULE,
+	.probe		=3D omap_pwm_probe,
+	.remove		=3D __devexit_p(omap_pwm_remove),
+	.suspend	=3D omap_pwm_suspend,
+	.resume		=3D NULL,
+};
+
+static int __init omap_pwm_init(void)
+{
+	return platform_driver_register(&omap_pwm_driver);
+}
+
+static void __exit omap_pwm_exit(void)
+{
+	platform_driver_unregister(&omap_pwm_driver);
+}
+
+arch_initcall(omap_pwm_init);
+module_exit(omap_pwm_exit);
+
+MODULE_AUTHOR("Grant Erickson <marathon96@gmail.com>");
+MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
+MODULE_LICENSE("GPLv2");
+MODULE_VERSION("2012-12-01");

--Sig_/JV1FnqCm4WSVBA7=6.QlDhQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMg/Pjnsnt1WYoG5AQJGIw//YnhkVl8kJHJWTQcIHSVhRrRmgW2L2EJX
mJo77V5oioC3fXbG1CVIfOB0rRlI7RoSA2QngSM4WWCzVzDSrxzBd2pFE1/aRLZw
X0gAKGEIGcdEwXsLILu+4OVjZP0ErM8+o1bMEgZZyLCBVL74J45f7mNyk+RkMax1
Mpu+VT/73RyorVZ/b6OE/pRTKAAyfYj4mZftbAxBm8B/n6XIYuvIMTaT7Z+su5gx
DG5ZvqfoRhWYFv4LGa7/R7odrzVapoib+VfoZMvoGuoYya6zDhystQjstmlyAlHa
jv+RAsNK+Z4e704/fV5emqpBpswTLuAP3rwDC2xnkZEd/I0lvu0q9HYAv//Np3Wr
j340GE/j+tCiX6YOSIiVD56HS4V8lqSe6lT63uWJnHtE5Z59xQQA6I7OSZfHH/p/
5vyQwj7GgvgBrcAsKOY3JDVpm2Xe/AiyDQzNXK9kZX+4gygLOB6ZjIlEdXTUIl7Z
9tT24YkzJE9CGebZ3wkzQlkNHEJY2EaH1yMTc3qrUrtzv56Vu3WWdNjmJPkvenWG
lfC8fggtc8+hNYxQkLEhpYpEWIwKwLR7/ng/d64GK0dpdgpl/qf5R4FJuJAqtpcz
28Cts3tJpb3DnXMOfiPNfDczUElJefyGE1WXeW6P7/JLDd+RfK2ZgdRXasThr7zu
C+nBMxxfqC0=
=M2R4
-----END PGP SIGNATURE-----

--Sig_/JV1FnqCm4WSVBA7=6.QlDhQ--
