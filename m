Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2LOAQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:16:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab2LOAQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:16:26 -0500
Date: Sat, 15 Dec 2012 11:16:01 +1100
From: NeilBrown <neilb@suse.de>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>, <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20121215111601.7124ed3f@notabene.brown>
In-Reply-To: <50CA137A.5010304@ti.com>
References: <20121212192430.50cea126@notabene.brown>
	<50C8ABFC.3080309@ti.com>
	<20121213140635.4eda5858@notabene.brown>
	<20121213153302.05120a6d@notabene.brown>
	<50CA137A.5010304@ti.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WVvdBqerL=h_4fYdoNcodl8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WVvdBqerL=h_4fYdoNcodl8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Dec 2012 11:42:18 -0600 Jon Hunter <jon-hunter@ti.com> wrote:

>=20
> On 12/12/2012 10:33 PM, NeilBrown wrote:
> > On Thu, 13 Dec 2012 14:06:35 +1100 NeilBrown <neilb@suse.de> wrote:
> >=20
> >>>> +	omap_dm_timer_enable(omap->dm_timer);
> >>>
> >>> Do you need to call omap_dm_timer_enable here? _set_load and _set_mat=
ch
> >>> will enable the timer. So this should not be necessary.
> >>
> >> True.  That is what you get for copying someone else's code and not
> >> understanding it fully.
> >=20
> > However .... omap_dm_timer_write_counter *doesn't* enable the timer, and
> > explicitly checks that it is already runtime-enabled.
> >=20
> > Does that mean I don't need to call omap_dm_timer_write_counter here?  =
Or
> > does it mean that I do need the enable/disable pair?
>=20
> Typically, omap_dm_timer_write_counter() is used to update the counter
> value while the counter is running and hence is enabled.
>=20
> Looking at the code, some more I now see what they are trying to do. It
> seems that they are trying to force an overflow to occur as soon as they
> enable the timer. This will cause the timer to load the count value from
> the timer load register into the timer counter register. So that does
> make sense to me. However, this should not be necessary as
> omap_dm_timer_set_load should do this for you. Therefore, I think that
> you could accomplish the same thing by doing ...
>=20
> omap_pwm_config
> 	--> omap_dm_timer_set_load()
> 	--> omap_dm_timer_set_match()
> 	--> omap_dm_timer_set_pwm()
>=20
> omap_pwm_enable
> 	--> omap_dm_timer_start()
>=20
> If we call _set_load in config then we don't need to call _load_start in
> the enable, we can just call _start.
>=20
> Can you try this and see if this is working ok?

Seems to work, and is much neater.  Thanks.

Below is my current patch.
Unresolved issues are:
 - it uses
    omap_dm_timer_request_specific()
   which apparently isn't ideal.
 - It still zeros things in the suspend routine.  I haven't explored this at
   all yet

Thanks,
NeilBrown

=46rom 69ed735d1bc377e8e65345792997f809e60b5fbf Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Sun, 2 Dec 2012 14:53:20 +1100
Subject: [PATCH] pwm: omap: Add PWM support using dual-mode timers

This patch is based on an earlier patch by Grant Erickson
which provided PWM devices using the 'legacy' interface.

This driver instead uses the new framework interface.

Platform data must be provided to identify which dmtimer to use.

Lots of cleanup and inprovements thanks to Thierry Reding
and Jon Hunter.

Cc: Grant Erickson <marathon96@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index ed81720..32c1253 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -85,6 +85,15 @@ config PWM_MXS
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-mxs.
=20
+config PWM_OMAP
+	tristate "OMAP PWM support"
+	depends on ARCH_OMAP && OMAP_DM_TIMER
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
index 0000000..344072c
--- /dev/null
+++ b/drivers/pwm/pwm-omap.c
@@ -0,0 +1,271 @@
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
+ *      This file is the core OMAP support for the generic, Linux
+ *      PWM driver / controller, using the OMAP's dual-mode timers.
+ *
+ */
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
+#include <linux/platform_data/omap-pwm.h>
+
+#include <plat/dmtimer.h>
+
+#define DM_TIMER_LOAD_MIN		0xFFFFFFFE
+
+struct omap_chip {
+	struct omap_dm_timer	*dm_timer;
+	enum pwm_polarity	polarity;
+	unsigned int		duty_ns, period_ns;
+	struct pwm_chip		chip;
+};
+
+#define to_omap_chip(chip)	container_of(chip, struct omap_chip, chip)
+
+/**
+ * pwm_calc_value - Determine the counter value for a clock rate and perio=
d.
+ * @clk_rate: The clock rate, in Hz, of the PWM's clock source to compute =
the
+ *            counter value for.
+ * @ns: The period, in nanoseconds, to compute the counter value for.
+ *
+ * Returns the PWM counter value for the specified clock rate and period.
+ */
+static inline int pwm_calc_value(unsigned long clk_rate, int ns)
+{
+	u64 c;
+
+	c =3D (u64)clk_rate * ns;
+	do_div(c, NSEC_PER_SEC);
+
+	return DM_TIMER_LOAD_MIN - c;
+}
+
+static int omap_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct omap_chip *omap =3D to_omap_chip(chip);
+
+	omap_dm_timer_start(omap->dm_timer);
+
+	return 0;
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
+	int load_value, match_value;
+	unsigned long clk_rate;
+
+	dev_dbg(chip->dev, "duty cycle: %d, period %d\n", duty_ns, period_ns);
+
+	if (omap->duty_ns =3D=3D duty_ns &&
+	    omap->period_ns =3D=3D period_ns)
+		/* No change - don't cause any transients. */
+		return 0;
+
+	clk_rate =3D clk_get_rate(omap_dm_timer_get_fclk(omap->dm_timer));
+
+	/*
+	 * Calculate the appropriate load and match values based on the
+	 * specified period and duty cycle. The load value determines the
+	 * cycle time and the match value determines the duty cycle.
+	 */
+
+	load_value =3D pwm_calc_value(clk_rate, period_ns);
+	match_value =3D pwm_calc_value(clk_rate, period_ns - duty_ns);
+
+	/*
+	 * We MUST enable yet stop the associated dual-mode timer before
+	 * attempting to write its registers.  Hopefully it is already
+	 * disabled, but call the (idempotent) pwm_disable just in case.
+	 */
+
+	pwm_disable(pwm);
+
+	omap_dm_timer_set_load(omap->dm_timer, true, load_value);
+	omap_dm_timer_set_match(omap->dm_timer, true, match_value);
+
+	dev_dbg(chip->dev, "load value: %#08x (%d), match value: %#08x (%d)\n",
+		load_value, load_value,	match_value, match_value);
+
+	omap_dm_timer_set_pwm(omap->dm_timer,
+			      omap->polarity =3D=3D PWM_POLARITY_INVERSED,
+			      true,
+			      OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE);
+
+	omap->duty_ns =3D duty_ns;
+	omap->period_ns =3D period_ns;
+
+	return 0;
+}
+
+static int omap_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device =
*pwm,
+				 enum pwm_polarity polarity)
+{
+	struct omap_chip *omap =3D to_omap_chip(chip);
+
+	if (omap->polarity =3D=3D polarity)
+		return 0;
+
+	omap->polarity =3D polarity;
+
+	omap_dm_timer_set_pwm(omap->dm_timer,
+			      omap->polarity =3D=3D PWM_POLARITY_INVERSED,
+			      true,
+			      OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE);
+	return 0;
+}
+
+static struct pwm_ops omap_pwm_ops =3D {
+	.enable		=3D omap_pwm_enable,
+	.disable	=3D omap_pwm_disable,
+	.config		=3D omap_pwm_config,
+	.set_polarity	=3D omap_pwm_set_polarity,
+	.owner		=3D THIS_MODULE,
+};
+
+static int omap_pwm_probe(struct platform_device *pdev)
+{
+	struct device *dev =3D &pdev->dev;
+	struct omap_chip *omap;
+	int status =3D 0;
+	struct omap_pwm_pdata *pdata =3D dev->platform_data;
+
+	if (!pdata) {
+		dev_err(dev, "No platform data provided\n");
+		return -ENODEV;
+	}
+
+	omap =3D kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (omap =3D=3D NULL) {
+		dev_err(dev, "Could not allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Request the OMAP dual-mode timer that will be bound to and
+	 * associated with this generic PWM.
+	 */
+
+	omap->dm_timer =3D omap_dm_timer_request_specific(pdata->timer_id);
+	if (omap->dm_timer =3D=3D NULL) {
+		status =3D -EPROBE_DEFER;
+		goto err_free;
+	}
+
+	/*
+	 * Configure the source for the dual-mode timer backing this
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
+	/*
+	 * Cache away other miscellaneous driver-private data and state
+	 * information and add the driver-private data to the platform
+	 * device.
+	 */
+
+	omap->chip.dev =3D dev;
+	omap->chip.ops =3D &omap_pwm_ops;
+	omap->chip.base =3D -1;
+	omap->chip.npwm =3D 1;
+	omap->polarity =3D PWM_POLARITY_NORMAL;
+
+	status =3D pwmchip_add(&omap->chip);
+	if (status < 0) {
+		dev_err(dev, "failed to register PWM\n");
+		omap_dm_timer_free(omap->dm_timer);
+		goto err_free;
+	}
+
+	platform_set_drvdata(pdev, omap);
+
+	return 0;
+
+ err_free:
+	kfree(omap);
+	return status;
+}
+
+static int omap_pwm_remove(struct platform_device *pdev)
+{
+	struct omap_chip *omap =3D platform_get_drvdata(pdev);
+	int status;
+
+	omap_dm_timer_stop(omap->dm_timer);
+	status =3D pwmchip_remove(&omap->chip);
+	if (status < 0)
+		return status;
+
+	omap_dm_timer_free(omap->dm_timer);
+	kfree(omap);
+
+	return 0;
+}
+
+#if CONFIG_PM
+static int omap_pwm_suspend(struct device *dev)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct omap_chip *omap =3D platform_get_drvdata(pdev);
+	/*
+	 * No one preserve these values during suspend so reset them,
+	 * otherwise driver leaves PWM unconfigured if same values
+	 * passed to pwm_config.
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
+static SIMPLE_DEV_PM_OPS(omap_pwm_pm, omap_pwm_suspend, NULL);
+static struct platform_driver omap_pwm_driver =3D {
+	.driver =3D {
+		.name	=3D "omap-pwm",
+		.owner	=3D THIS_MODULE,
+		.pm	=3D &omap_pwm_pm,
+	},
+	.probe		=3D omap_pwm_probe,
+	.remove		=3D omap_pwm_remove,
+};
+module_platform_driver(omap_pwm_driver);
+
+MODULE_AUTHOR("Grant Erickson <marathon96@gmail.com>");
+MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("2012-12-01");
+MODULE_DESCRIPTION("OMAP PWM Driver using Dual-mode Timers");
diff --git a/include/linux/platform_data/omap-pwm.h b/include/linux/platfor=
m_data/omap-pwm.h
new file mode 100644
index 0000000..169fc3c
--- /dev/null
+++ b/include/linux/platform_data/omap-pwm.h
@@ -0,0 +1,20 @@
+/*
+ * omap-pwm.h
+ *
+ *    Copyright (c) 2012 NeilBrown <neilb@suse.de>
+ *
+ *    This program is free software; you can redistribute it and/or
+ *    modify it under the terms of the GNU General Public License
+ *    version 2 as published by the Free Software Foundation.
+ *
+ * Set the timer id to use for a PWM
+ */
+
+#ifndef _OMAP_PWM_H_
+#define _OMAP_PWM_H_
+
+struct omap_pwm_pdata {
+	int	timer_id;
+};
+
+#endif /* _OMAP_PWM_H_ */


--Sig_/WVvdBqerL=h_4fYdoNcodl8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMvBQTnsnt1WYoG5AQKPkQ//fN4x3tURyR792qgfcvCgFdrT/oGjZU3H
YbFWuI2bHO7FQyn5ktIF/PJl2+pIhgJ71XOweExrcixj4HuJKI5t+GgMiBLCGjXa
m2i+Q2ICkE87ZyLEn54xhneXBJ41EgJs5WkaM3/gOzqUygDBROfq2jWB2PEEXvve
fiPe/7uErzBkNgJ9HFxULYjbJdzvlMESTRlw37tXS1R6L5yjHEP7nDFJeAG7nmzA
AKDwnf3sGN05smZKaAoTxhOLfTFUavjKGpSBWV3fA7T4eq9bhf8ozMPSIMP2HTn0
M9xKrrXd1WUKx15G8tldqKJ0eLTlaShWlNLl638x3vtBGdUq5bbetjQgiCo19xzA
e9JBAi4RBf76rqoZEhGXhn+WudIgR6zgY0u+HcXBEK4Kzkhk4H4aAmLSs+XQ3nJW
b4fKYx9hDta+F5gQJOYi9Ijsy/f8pOTG0rsW6s9T2kAJqREjfOg3BlSP1fEMObYS
5QU0I0tO/lUPj9aq+kHxkofNPjst6MTVb+KuL6Qecy9QpDxYTxIbSWJZx6hwhUm/
zIExCJBtFHAUvDEse8Y3XHGym53W4XkzoI/AyaYYFAJiVwbi7ifupkeV0fRyKwdk
ZuXjgdQUsn/aavXtbbJ8UTeRimwpal13cXinmAmbPhtsgNQyfOmypyUMCXBh8rrJ
IR1Sciplr28=
=H28b
-----END PGP SIGNATURE-----

--Sig_/WVvdBqerL=h_4fYdoNcodl8--
