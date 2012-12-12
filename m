Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2LLLbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 06:31:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab2LLLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 06:31:50 -0500
Date: Wed, 12 Dec 2012 12:31:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: NeilBrown <neilb@suse.de>
Cc: Grant Erickson <marathon96@gmail.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20121212113145.GA23598@avionic-0098.adnet.avionic-design.de>
References: <20121212192430.50cea126@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20121212192430.50cea126@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:PxA3wqWGQQNZLaklmUkCj6tfyssa8ATirTaCWsTp6ee
 r/g/ZbCbOc/b+i31MJfjY+hxEwi08vRf3DRMusc9wnbma/5u77
 4bQWI19GMIlPWdTNFqhr6OMzkvSCiAUr9C5mcgf9NZhr/SZLiI
 iQe7VFOJlOkckKtfgB6zHSC7SdqDxkZJSCyJvgf257LpEMPaNK
 VzuxtOU1G2UBmjWsh57lQTfJh0Sq19Ln3Wi5hxEUwohRB5VKND
 Cijxkoi4SFo0OShGQvoyvhdfuQWDwR3dBebh8HwS/l1u4g/cTP
 DXLjKRaSCFHTHxtJ2z0obFFKHZizp7xzCluaFvyk307uNLIA47
 2nwwcOccYhrlo5PpPkXu8+d/oGOKt4LM/MFb3B+1NsboosKCJK
 h+B7uKhCHlz2Tw+8cYNjmqOXTxMDc0w7os=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2012 at 07:24:30PM +1100, NeilBrown wrote:
>=20
>=20
> This patch is based on an earlier patch by Grant Erickson
> which provided pwm devices using the 'legacy' interface.
>=20
> This driver instead uses the new framework interface.

I'd prefer some kind of description about the driver here. Also the
subject should be something like:

	pwm: Add OMAP support using dual-mode timers

or

	pwm: omap: Add PWM support using dual-mode timers

I take this description to mean that OMAP doesn't have dedicated PWM
hardware? Otherwise it might be bad to call this pwm-omap.

Also please use all-caps when referring to PWM devices in prose. A few
other comments inline below.

> Cc: Grant Erickson <marathon96@gmail.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index ed81720..7df573a 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -85,6 +85,15 @@ config PWM_MXS
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-mxs.
> =20
> +config PWM_OMAP
> +	tristate "OMAP pwm support"

"OMAP PWM support"

> diff --git a/drivers/pwm/pwm-omap.c b/drivers/pwm/pwm-omap.c
[...]
> + *    The 'id' number for the device encodes the number of the dm timer
> + *    to use, and the polarity of the output.
> + *    lsb is '1' of active-high, and '0' for active low
> + *    remaining bit a timer number and need to be shifted down before us=
e.

I don't know if this is such a good idea. Usually you number platform
devices sequentially, while this would leave gaps in the numbering. I
know that adding platform data may sound a bit like overkill, but I
really think the added clarity and consistency is worth it.

> +#define pr_fmt(fmt) "pwm-omap: " fmt

You don't seem to be using any of the pr_*() logging functions, so this
isn't needed.

> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/pwm.h>
> +#include <linux/module.h>
> +
> +#include <plat/dmtimer.h>
> +
> +#define DM_TIMER_LOAD_MIN		0xFFFFFFFE
> +
> +struct omap_chip {
> +	struct platform_device	*pdev;

I don't see this field being used anywhere.

> +	struct omap_dm_timer	*dm_timer;
> +	unsigned int		polarity;

The PWM subsystem already has enum pwm_polarity for this.

> +	const char		*label;

This isn't used anywhere either.

> +
> +	unsigned int		duty_ns, period_ns;
> +	struct pwm_chip		chip;
> +};
> +
> +#define to_omap_chip(chip)	container_of(chip, struct omap_chip, chip)
> +
> +#define	pwm_dbg(_pwm, msg...) dev_dbg(&(_pwm)->pdev->dev, msg)

This is never used.

> +
> +/**
> + * pwm_calc_value - determines the counter value for a clock rate and pe=
riod.

Nit: You should either start the sentence with a capital or not
terminate it with a full stop.

> + * @clk_rate: The clock rate, in Hz, of the PWM's clock source to comput=
e the
> + *            counter value for.
> + * @ns: The period, in nanoseconds, to computer the counter value for.

"compute"

> + *
> + * Returns the PWM counter value for the specified clock rate and period.
> + */
> +static inline int pwm_calc_value(unsigned long clk_rate, int ns)
> +{
> +	const unsigned long nanoseconds_per_second =3D 1000000000;

Maybe use NSEC_PER_SEC instead?

> +	int cycles;
> +	__u64 c;

I think for in-kernel use, the custom is to stick with simply u64.

> +
> +	c =3D (__u64)clk_rate * ns;
> +	do_div(c, nanoseconds_per_second);
> +	cycles =3D c;
> +
> +	return DM_TIMER_LOAD_MIN - cycles;

Can't you just do "DM_TIMER_LOAD_MIN - c" and get rid of the cycles
variable altogether?

> +static int omap_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct omap_chip *omap =3D to_omap_chip(chip);
> +	int status =3D 0;
> +
> +	/* Enable the counter--always--before attempting to write its
> +	 * registers and then set the timer to its minimum load value to
> +	 * ensure we get an overflow event right away once we start it.
> +	 */

Block comments should be in the following format:

	/*
	 * foo...
	 * bar...
	 */

> +
> +	omap_dm_timer_enable(omap->dm_timer);
> +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
> +	omap_dm_timer_start(omap->dm_timer);
> +	omap_dm_timer_disable(omap->dm_timer);

So omap_dm_timer_disable() doesn't actually stop the timer? It just
disables the access to the registers?

> +	return status;

"return 0;" and drop the status variable.

> +static int omap_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			   int duty_ns, int period_ns)
> +{
> +	struct omap_chip *omap =3D to_omap_chip(chip);
> +	int status =3D 0;

This one can be dropped as well.

> +	const bool enable =3D true;
> +	const bool autoreload =3D true;
> +	const bool toggle =3D true;
> +	const int trigger =3D OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE;

I understand that these extra variables are supposed to "document" the
parameters of the functions below. I'm not a huge fan of this approach
because instead the API would better be designed to make it obvious what
the parameters are. Or people can just look at the prototypes to find
out the meaning. But if you really prefer this way I won't object.

> +	int load_value, match_value;
> +	unsigned long clk_rate;
> +
> +	dev_dbg(chip->dev,
> +		"duty cycle: %d, period %d\n",
> +		duty_ns, period_ns);

This all fits on a single line, so no need to break it up.

> +
> +	if (omap->duty_ns =3D=3D duty_ns &&
> +	    omap->period_ns =3D=3D period_ns)
> +		/* No change - don't cause any transients */
> +		return 0;

Note to self: this might be a candidate to put in the core.

> +	clk_rate =3D clk_get_rate(omap_dm_timer_get_fclk(omap->dm_timer));
> +
> +	/* Calculate the appropriate load and match values based on the
> +	 * specified period and duty cycle. The load value determines the
> +	 * cycle time and the match value determines the duty cycle.
> +	 */

Again wrong block comment style.

> +
> +	load_value =3D pwm_calc_value(clk_rate, period_ns);
> +	match_value =3D pwm_calc_value(clk_rate, period_ns - duty_ns);
> +
> +	/* We MUST enable yet stop the associated dual-mode timer before
> +	 * attempting to write its registers.  Hopefully it is already
> +	 * disabled, but call the (idempotent) pwm_disable just in case
> +	 */

And here as well. While at it you might want to terminate the last
sentence with a full stop.

> +	pwm_disable(pwm);
> +
> +	omap_dm_timer_enable(omap->dm_timer);
> +
> +	omap_dm_timer_set_load(omap->dm_timer, autoreload, load_value);
> +	omap_dm_timer_set_match(omap->dm_timer, enable, match_value);
> +
> +	dev_dbg(chip->dev,
> +			"load value: %#08x (%d), "
> +			"match value: %#08x (%d)\n",
> +			load_value, load_value,
> +			match_value, match_value);

Again this doesn't need so much wrapping.

> +
> +	omap_dm_timer_set_pwm(omap->dm_timer,
> +			      !omap->polarity,
> +			      toggle,
> +			      trigger);

This doesn't either. Also you should be explicit about the polarity
parameter, since enum pwm_polarity is an enum and therefore negating it
isn't very nice (it should work though).

You could solve this by doing something like:

	if (omap->polarity =3D=3D PWM_POLARITY_NORMAL)
		polarity =3D 1;
	else
		polarity =3D 0;

> +	/* Set the counter to generate an overflow event immediately. */
> +
> +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
> +
> +	/* Now that we're done configuring the dual-mode timer, disable it
> +	 * again. We'll enable and start it later, when requested.
> +	 */

Also wrong style.

> +	omap_dm_timer_disable(omap->dm_timer);
> +	omap->duty_ns =3D duty_ns;
> +	omap->period_ns =3D period_ns;
> +
> +	return status;

"return 0;"

> +}
> +
> +

Gratuitous newline.

> +static struct pwm_ops omap_pwm_ops =3D {

Should be "static const".

> +	.enable	=3D omap_pwm_enable,
> +	.disable=3D omap_pwm_disable,

There should be a space between .disable and =3D.

> +	.config	=3D omap_pwm_config,
> +	.owner	=3D THIS_MODULE,
> +};
> +
> +/**
> + * omap_pwm_probe - check for the PWM and bind it to the driver.
> + * @pdev: A pointer to the platform device node associated with the
> + *        PWM instance to be probed for driver binding.
> + *
> + * Returns 0 if the PWM instance was successfully bound to the driver;
> + * otherwise, < 0 on error.
> + */

I'm not sure how useful this kerneldoc comment really is. It isn't about
an exported function and developers usually know what the .probe() does.

> +static int __devinit omap_pwm_probe(struct platform_device *pdev)

No more __devinit, please.

> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct omap_chip *omap;
> +	int status =3D 0;
> +	unsigned int id =3D pdev->id;
> +	unsigned int timer =3D id >> 1; /* lsb is polarity */

I've said this before, I don't think it's a good idea.

> +
> +	omap =3D kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
> +

Gratuituous newline.

> +	if (omap =3D=3D NULL) {
> +		dev_err(dev, "Could not allocate memory.\n");
> +		status =3D -ENOMEM;
> +		goto done;
> +	}
> +
> +	/* Request the OMAP dual-mode timer that will be bound to and
> +	 * associated with this generic PWM.
> +	 */

Block comment style again.

> +
> +	omap->dm_timer =3D omap_dm_timer_request_specific(timer);
> +

Gratuitous newline.

> +	if (omap->dm_timer =3D=3D NULL) {
> +		status =3D -EPROBE_DEFER;
> +		goto err_free;
> +	}
> +
> +	/* Configure the source for the dual-mode timer backing this
> +	 * generic PWM device. The clock source will ultimately determine
> +	 * how small or large the PWM frequency can be.
> +	 *
> +	 * At some point, it's probably worth revisiting moving this to
> +	 * the configure method and choosing either the slow- or
> +	 * system-clock source as appropriate for the desired PWM period.
> +	 */

And again.

> +
> +	omap_dm_timer_set_source(omap->dm_timer, OMAP_TIMER_SRC_SYS_CLK);
> +
> +	/* Cache away other miscellaneous driver-private data and state
> +	 * information and add the driver-private data to the platform
> +	 * device.
> +	 */

And again. =3D)

> +
> +	omap->chip.dev =3D dev;
> +	omap->chip.ops =3D &omap_pwm_ops;
> +	omap->chip.base =3D -1;
> +	omap->chip.npwm =3D 1;
> +	omap->polarity =3D id & 1;
> +
> +	status =3D pwmchip_add(&omap->chip);
> +	if (status < 0) {
> +		dev_err(dev, "failed to register pwm\n");
> +		omap_dm_timer_free(omap->dm_timer);
> +		goto err_free;
> +	}
> +
> +	platform_set_drvdata(pdev, omap);
> +
> +	status =3D 0;
> +	goto done;

This can just be "return 0;".

> +
> + err_free:
> +	kfree(omap);
> + done:
> +	return status;
> +}
> +
> +/**
> + * omap_pwm_remove - unbind the specified PWM platform device from the d=
river.
> + * @pdev: A pointer to the platform device node associated with the
> + *        PWM instance to be unbound/removed.
> + *
> + * Returns 0 if the PWM was successfully removed as a platform device;
> + * otherwise, < 0 on error.
> + */
> +static int __devexit omap_pwm_remove(struct platform_device *pdev)

No __devexit, please.

> +{
> +	struct omap_chip *omap =3D platform_get_drvdata(pdev);
> +	int status =3D 0;

Just drop this.

> +
> +	status =3D pwmchip_remove(&omap->chip);
> +	if (status < 0)
> +		goto done;

"return status;"

> +
> +	omap_dm_timer_free(omap->dm_timer);
> +
> +	kfree(omap);
> +
> + done:
> +	return status;

Just "return 0;". No label required.

> +}
> +
> +#if CONFIG_PM
> +static int omap_pwm_suspend(struct platform_device *pdev, pm_message_t s=
tate)
> +{
> +	struct omap_chip *omap =3D platform_get_drvdata(pdev);
> +	/* No one preserve these values during suspend so reset them
> +	 * Otherwise driver leaves PWM unconfigured if same values
> +	 * passed to pwm_config
> +	 */
> +	omap->period_ns =3D 0;
> +	omap->duty_ns =3D 0;
> +
> +	return 0;
> +}
> +#else
> +#define omap_pwm_suspend	NULL
> +#endif

This doesn't look right. You should implement .resume() if you really
care, in which case the resume callback would have to reconfigure with
the cached values. In that case maybe you should switch to dev_pm_ops
and SIMPLE_DEV_PM_OPS() as well.

If you don't, just resetting these values will not make the PWM work
properly after resume either since it will have to be explicitly
reconfigured.

> +static struct platform_driver omap_pwm_driver =3D {
> +	.driver.name	=3D "omap-pwm",
> +	.driver.owner	=3D THIS_MODULE,

The more idiomatic way of writing this is:

	.driver =3D {
		.name =3D "omap-pwm",
		.owner =3D THIS_MODULE,
	},

> +	.probe		=3D omap_pwm_probe,
> +	.remove		=3D __devexit_p(omap_pwm_remove),

No __devexit_p anymore.

> +	.suspend	=3D omap_pwm_suspend,
> +	.resume		=3D NULL,
> +};
> +
> +static int __init omap_pwm_init(void)
> +{
> +	return platform_driver_register(&omap_pwm_driver);
> +}
> +
> +static void __exit omap_pwm_exit(void)
> +{
> +	platform_driver_unregister(&omap_pwm_driver);
> +}
> +
> +arch_initcall(omap_pwm_init);

This should probably be module_init() instead. You already return
-EPROBE_DEFER if the dual-mode timer isn't ready yet so you should bite
the bullet and get all the dependencies to behave properly as well. New
code shouldn't be using this kind of dependency handling.

In that case you could also just run module_platform_driver().

Thierry

> +module_exit(omap_pwm_exit);
> +
> +MODULE_AUTHOR("Grant Erickson <marathon96@gmail.com>");
> +MODULE_AUTHOR("NeilBrown <neilb@suse.de>");

Shouldn't this be "Neil Brown"? I noticed you use the concatenated form
in the email address as well, so maybe that's on purpose?

> +MODULE_LICENSE("GPLv2");

This should be "GPL v2". Maybe MODULE_DESCRIPTION() would be nice too.

Thierry

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQyGshAAoJEN0jrNd/PrOhTmgP/i5F5igXq08vG9PHyUhkI3WX
/kvWY/tV9UdcaLnjLJl7Do9ZMjk0vaHYldL8YD1MiT7HJpm3G3IijN+UghZnR03D
468k10ad+OAUez2E9J/XGwk1chc2gXOEiGevAilvlikakuRhbcG7Wlrmc9lxosw7
reGq9wdwZEIC6IP+f3e+3nbub0MCJ3THin/BExfayhDieTo1uzwWEHfDgAqxpw1F
iQ9j4Sl06qkBlAhgN9M3bgXG8rQsGEQkNRUu8RuT9Y/9uglRGldAWFHNBveY84GI
NaZ7TPE9PwgT08Ee4el8kOFSxLRs9HU9wPsts71KYpIqWj1GcT8EYWb/nosRPN1W
jA3epyu0A/zRll0PsJ4KN8vGkt4YYyMgNfdfw6ryhqqSd0Cl33E6IuAih2gh8X1Z
91TmPO6O/TUAZJuFglVBCZzEA6gUNntvSDrlw3P299LGcsvkGXS7Lkpp2/rX334+
4YZQ+cb2JeOp5jDJm75e8o2hCbeMU6cpYKmt1+D003engCD/F3QXIdqo61sP3MVs
vSf6V5AKObAO/pP9ltFHa4d85gVkf+0Kk4xJxWP2qoBKy44UvnvjJ3gQJkxV6vIe
yF8AV0w/8OAQEz+gWEDrXQjd5NoFjiidXLYI0F2cO74Talk5VAKGcdokZr576ZH8
Tf0X3sTM0RSJoIwackTD
=Oc4m
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
