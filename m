Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2LMCiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:38:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab2LMCim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:38:42 -0500
Date: Thu, 13 Dec 2012 13:38:28 +1100
From: NeilBrown <neilb@suse.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Grant Erickson <marathon96@gmail.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20121213133828.55e50220@notabene.brown>
In-Reply-To: <20121212113145.GA23598@avionic-0098.adnet.avionic-design.de>
References: <20121212192430.50cea126@notabene.brown>
	<20121212113145.GA23598@avionic-0098.adnet.avionic-design.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q_Wj2VK8cvdETqTAdz5QGuj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Q_Wj2VK8cvdETqTAdz5QGuj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Dec 2012 12:31:45 +0100 Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> On Wed, Dec 12, 2012 at 07:24:30PM +1100, NeilBrown wrote:
> >=20
> >=20
> > This patch is based on an earlier patch by Grant Erickson
> > which provided pwm devices using the 'legacy' interface.
> >=20
> > This driver instead uses the new framework interface.
>=20
> I'd prefer some kind of description about the driver here.

I'm not really sure what more there is to say.  There was a bit of text in a
comment at the top of the file which I've copied to the commit comment.


>                                                            Also the
> subject should be something like:
>=20
> 	pwm: Add OMAP support using dual-mode timers
>=20
> or
>=20
> 	pwm: omap: Add PWM support using dual-mode timers

Done - I chose the second.

>=20
> I take this description to mean that OMAP doesn't have dedicated PWM
> hardware? Otherwise it might be bad to call this pwm-omap.

Correct.  The timers can be used for a number of things which explicitly
includes PWM.

>=20
> Also please use all-caps when referring to PWM devices in prose. A few
> other comments inline below.

OK.

>=20
> > Cc: Grant Erickson <marathon96@gmail.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index ed81720..7df573a 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -85,6 +85,15 @@ config PWM_MXS
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called pwm-mxs.
> > =20
> > +config PWM_OMAP
> > +	tristate "OMAP pwm support"
>=20
> "OMAP PWM support"

Fixed.

>=20
> > diff --git a/drivers/pwm/pwm-omap.c b/drivers/pwm/pwm-omap.c
> [...]
> > + *    The 'id' number for the device encodes the number of the dm timer
> > + *    to use, and the polarity of the output.
> > + *    lsb is '1' of active-high, and '0' for active low
> > + *    remaining bit a timer number and need to be shifted down before =
use.
>=20
> I don't know if this is such a good idea. Usually you number platform
> devices sequentially, while this would leave gaps in the numbering. I
> know that adding platform data may sound a bit like overkill, but I
> really think the added clarity and consistency is worth it.

I guess so.  No other PWM driver seems to use platform data, and I needed so
little...
I'll see what I can do.


>=20
> > +#define pr_fmt(fmt) "pwm-omap: " fmt
>=20
> You don't seem to be using any of the pr_*() logging functions, so this
> isn't needed.

Gone now, thanks.


>=20
> > +#include <linux/export.h>
> > +#include <linux/kernel.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/slab.h>
> > +#include <linux/err.h>
> > +#include <linux/clk.h>
> > +#include <linux/io.h>
> > +#include <linux/pwm.h>
> > +#include <linux/module.h>
> > +
> > +#include <plat/dmtimer.h>
> > +
> > +#define DM_TIMER_LOAD_MIN		0xFFFFFFFE
> > +
> > +struct omap_chip {
> > +	struct platform_device	*pdev;
>
> I don't see this field being used anywhere.

No.  Gone.

>=20
> > +	struct omap_dm_timer	*dm_timer;
> > +	unsigned int		polarity;
>=20
> The PWM subsystem already has enum pwm_polarity for this.
>=20

I'll use that then .... and as there  is a pwm_set_polarity() interface, th=
at
probably means that I don't need to configure the polarity via the platform
data?  That would be a lot cleaner.


> > +	const char		*label;
>=20
> This isn't used anywhere either.

Gone.

>=20
> > +
> > +	unsigned int		duty_ns, period_ns;
> > +	struct pwm_chip		chip;
> > +};
> > +
> > +#define to_omap_chip(chip)	container_of(chip, struct omap_chip, chip)
> > +
> > +#define	pwm_dbg(_pwm, msg...) dev_dbg(&(_pwm)->pdev->dev, msg)
>=20
> This is never used.

:-)  There is a theme here.


>=20
> > +
> > +/**
> > + * pwm_calc_value - determines the counter value for a clock rate and =
period.
>=20
> Nit: You should either start the sentence with a capital or not
> terminate it with a full stop.

In this case the sentence really includes the function name which is
case-sensitive so cannot be capitalised ;-)
I'll rephrase a bit and find something to capitalise.

>=20
> > + * @clk_rate: The clock rate, in Hz, of the PWM's clock source to comp=
ute the
> > + *            counter value for.
> > + * @ns: The period, in nanoseconds, to computer the counter value for.
>=20
> "compute"

Yep.

>=20
> > + *
> > + * Returns the PWM counter value for the specified clock rate and peri=
od.
> > + */
> > +static inline int pwm_calc_value(unsigned long clk_rate, int ns)
> > +{
> > +	const unsigned long nanoseconds_per_second =3D 1000000000;
>=20
> Maybe use NSEC_PER_SEC instead?

Good idea, thanks.

>=20
> > +	int cycles;
> > +	__u64 c;
>=20
> I think for in-kernel use, the custom is to stick with simply u64.

It is, yes.


>=20
> > +
> > +	c =3D (__u64)clk_rate * ns;
> > +	do_div(c, nanoseconds_per_second);
> > +	cycles =3D c;
> > +
> > +	return DM_TIMER_LOAD_MIN - cycles;
>=20
> Can't you just do "DM_TIMER_LOAD_MIN - c" and get rid of the cycles
> variable altogether?

Yep.

>=20
> > +static int omap_pwm_enable(struct pwm_chip *chip, struct pwm_device *p=
wm)
> > +{
> > +	struct omap_chip *omap =3D to_omap_chip(chip);
> > +	int status =3D 0;
> > +
> > +	/* Enable the counter--always--before attempting to write its
> > +	 * registers and then set the timer to its minimum load value to
> > +	 * ensure we get an overflow event right away once we start it.
> > +	 */
>=20
> Block comments should be in the following format:
>=20
> 	/*
> 	 * foo...
> 	 * bar...
> 	 */

OK, I fixed all of those.

>=20
> > +
> > +	omap_dm_timer_enable(omap->dm_timer);
> > +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
> > +	omap_dm_timer_start(omap->dm_timer);
> > +	omap_dm_timer_disable(omap->dm_timer);
>=20
> So omap_dm_timer_disable() doesn't actually stop the timer? It just
> disables the access to the registers?
>=20
> > +	return status;
>=20
> "return 0;" and drop the status variable.
>=20

Done.

> > +static int omap_pwm_config(struct pwm_chip *chip, struct pwm_device *p=
wm,
> > +			   int duty_ns, int period_ns)
> > +{
> > +	struct omap_chip *omap =3D to_omap_chip(chip);
> > +	int status =3D 0;
>=20
> This one can be dropped as well.
>=20
> > +	const bool enable =3D true;
> > +	const bool autoreload =3D true;
> > +	const bool toggle =3D true;
> > +	const int trigger =3D OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE;
>=20
> I understand that these extra variables are supposed to "document" the
> parameters of the functions below. I'm not a huge fan of this approach
> because instead the API would better be designed to make it obvious what
> the parameters are. Or people can just look at the prototypes to find
> out the meaning. But if you really prefer this way I won't object.

I've removed the 'trigger' const as the name is self-descriptive.
I might leave the others.

>=20
> > +	int load_value, match_value;
> > +	unsigned long clk_rate;
> > +
> > +	dev_dbg(chip->dev,
> > +		"duty cycle: %d, period %d\n",
> > +		duty_ns, period_ns);
>=20
> This all fits on a single line, so no need to break it up.

Indeed.

>=20
> > +
> > +	if (omap->duty_ns =3D=3D duty_ns &&
> > +	    omap->period_ns =3D=3D period_ns)
> > +		/* No change - don't cause any transients */
> > +		return 0;
>=20
> Note to self: this might be a candidate to put in the core.

might be useful, though the core doesn't currently "know" the current value=
s.

>=20
> > +	clk_rate =3D clk_get_rate(omap_dm_timer_get_fclk(omap->dm_timer));
> > +
> > +	/* Calculate the appropriate load and match values based on the
> > +	 * specified period and duty cycle. The load value determines the
> > +	 * cycle time and the match value determines the duty cycle.
> > +	 */
>=20
> Again wrong block comment style.
>=20
> > +
> > +	load_value =3D pwm_calc_value(clk_rate, period_ns);
> > +	match_value =3D pwm_calc_value(clk_rate, period_ns - duty_ns);
> > +
> > +	/* We MUST enable yet stop the associated dual-mode timer before
> > +	 * attempting to write its registers.  Hopefully it is already
> > +	 * disabled, but call the (idempotent) pwm_disable just in case
> > +	 */
>=20
> And here as well. While at it you might want to terminate the last
> sentence with a full stop.
>=20

I check the sentences in other comments too.

> > +	pwm_disable(pwm);
> > +
> > +	omap_dm_timer_enable(omap->dm_timer);
> > +
> > +	omap_dm_timer_set_load(omap->dm_timer, autoreload, load_value);
> > +	omap_dm_timer_set_match(omap->dm_timer, enable, match_value);
> > +
> > +	dev_dbg(chip->dev,
> > +			"load value: %#08x (%d), "
> > +			"match value: %#08x (%d)\n",
> > +			load_value, load_value,
> > +			match_value, match_value);
>=20
> Again this doesn't need so much wrapping.
>=20

Nope.

> > +
> > +	omap_dm_timer_set_pwm(omap->dm_timer,
> > +			      !omap->polarity,
> > +			      toggle,
> > +			      trigger);
>=20
> This doesn't either. Also you should be explicit about the polarity
> parameter, since enum pwm_polarity is an enum and therefore negating it
> isn't very nice (it should work though).
>=20
> You could solve this by doing something like:
>=20
> 	if (omap->polarity =3D=3D PWM_POLARITY_NORMAL)
> 		polarity =3D 1;
> 	else
> 		polarity =3D 0;

(omap->polarity =3D=3D PWM_POLARITY_NORMAL)

would have the same effect.

>=20
> > +	/* Set the counter to generate an overflow event immediately. */
> > +
> > +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
> > +
> > +	/* Now that we're done configuring the dual-mode timer, disable it
> > +	 * again. We'll enable and start it later, when requested.
> > +	 */
>=20
> Also wrong style.
>=20
> > +	omap_dm_timer_disable(omap->dm_timer);
> > +	omap->duty_ns =3D duty_ns;
> > +	omap->period_ns =3D period_ns;
> > +
> > +	return status;
>=20
> "return 0;"
>=20
> > +}
> > +
> > +
>=20
> Gratuitous newline.
>=20
> > +static struct pwm_ops omap_pwm_ops =3D {
>=20
> Should be "static const".
>=20
> > +	.enable	=3D omap_pwm_enable,
> > +	.disable=3D omap_pwm_disable,
>=20
> There should be a space between .disable and =3D.

OK.

>=20
> > +	.config	=3D omap_pwm_config,
> > +	.owner	=3D THIS_MODULE,
> > +};
> > +
> > +/**
> > + * omap_pwm_probe - check for the PWM and bind it to the driver.
> > + * @pdev: A pointer to the platform device node associated with the
> > + *        PWM instance to be probed for driver binding.
> > + *
> > + * Returns 0 if the PWM instance was successfully bound to the driver;
> > + * otherwise, < 0 on error.
> > + */
>=20
> I'm not sure how useful this kerneldoc comment really is. It isn't about
> an exported function and developers usually know what the .probe() does.

True.  Gone.

>=20
> > +static int __devinit omap_pwm_probe(struct platform_device *pdev)
>=20
> No more __devinit, please.

If you say so (having no idea what it did :-)


>=20
> > +{
> > +	struct device *dev =3D &pdev->dev;
> > +	struct omap_chip *omap;
> > +	int status =3D 0;
> > +	unsigned int id =3D pdev->id;
> > +	unsigned int timer =3D id >> 1; /* lsb is polarity */
>=20
> I've said this before, I don't think it's a good idea.
>=20
> > +
> > +	omap =3D kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
> > +
>=20
> Gratuituous newline.
>=20
> > +	if (omap =3D=3D NULL) {
> > +		dev_err(dev, "Could not allocate memory.\n");
> > +		status =3D -ENOMEM;
> > +		goto done;
> > +	}
> > +
> > +	/* Request the OMAP dual-mode timer that will be bound to and
> > +	 * associated with this generic PWM.
> > +	 */
>=20
> Block comment style again.
>=20
> > +
> > +	omap->dm_timer =3D omap_dm_timer_request_specific(timer);
> > +
>=20
> Gratuitous newline.

Gone.

>=20
> > +	if (omap->dm_timer =3D=3D NULL) {
> > +		status =3D -EPROBE_DEFER;
> > +		goto err_free;
> > +	}
> > +
> > +	/* Configure the source for the dual-mode timer backing this
> > +	 * generic PWM device. The clock source will ultimately determine
> > +	 * how small or large the PWM frequency can be.
> > +	 *
> > +	 * At some point, it's probably worth revisiting moving this to
> > +	 * the configure method and choosing either the slow- or
> > +	 * system-clock source as appropriate for the desired PWM period.
> > +	 */
>=20
> And again.
>=20
> > +
> > +	omap_dm_timer_set_source(omap->dm_timer, OMAP_TIMER_SRC_SYS_CLK);
> > +
> > +	/* Cache away other miscellaneous driver-private data and state
> > +	 * information and add the driver-private data to the platform
> > +	 * device.
> > +	 */
>=20
> And again. =3D)
>=20
> > +
> > +	omap->chip.dev =3D dev;
> > +	omap->chip.ops =3D &omap_pwm_ops;
> > +	omap->chip.base =3D -1;
> > +	omap->chip.npwm =3D 1;
> > +	omap->polarity =3D id & 1;
> > +
> > +	status =3D pwmchip_add(&omap->chip);
> > +	if (status < 0) {
> > +		dev_err(dev, "failed to register pwm\n");
> > +		omap_dm_timer_free(omap->dm_timer);
> > +		goto err_free;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, omap);
> > +
> > +	status =3D 0;
> > +	goto done;
>=20
> This can just be "return 0;".

Yep.

>=20
> > +
> > + err_free:
> > +	kfree(omap);
> > + done:
> > +	return status;
> > +}
> > +
> > +/**
> > + * omap_pwm_remove - unbind the specified PWM platform device from the=
 driver.
> > + * @pdev: A pointer to the platform device node associated with the
> > + *        PWM instance to be unbound/removed.
> > + *
> > + * Returns 0 if the PWM was successfully removed as a platform device;
> > + * otherwise, < 0 on error.


> > + */
> > +static int __devexit omap_pwm_remove(struct platform_device *pdev)
>=20
> No __devexit, please.
>=20
> > +{
> > +	struct omap_chip *omap =3D platform_get_drvdata(pdev);
> > +	int status =3D 0;
>=20
> Just drop this.
>=20
> > +
> > +	status =3D pwmchip_remove(&omap->chip);
> > +	if (status < 0)
> > +		goto done;
>=20
> "return status;"

Fixed.

>=20
> > +
> > +	omap_dm_timer_free(omap->dm_timer);
> > +
> > +	kfree(omap);
> > +
> > + done:
> > +	return status;
>=20
> Just "return 0;". No label required.
>=20
> > +}
> > +
> > +#if CONFIG_PM
> > +static int omap_pwm_suspend(struct platform_device *pdev, pm_message_t=
 state)
> > +{
> > +	struct omap_chip *omap =3D platform_get_drvdata(pdev);
> > +	/* No one preserve these values during suspend so reset them
> > +	 * Otherwise driver leaves PWM unconfigured if same values
> > +	 * passed to pwm_config
> > +	 */
> > +	omap->period_ns =3D 0;
> > +	omap->duty_ns =3D 0;
> > +
> > +	return 0;
> > +}
> > +#else
> > +#define omap_pwm_suspend	NULL
> > +#endif
>=20
> This doesn't look right. You should implement .resume() if you really
> care, in which case the resume callback would have to reconfigure with
> the cached values. In that case maybe you should switch to dev_pm_ops
> and SIMPLE_DEV_PM_OPS() as well.
>=20
> If you don't, just resetting these values will not make the PWM work
> properly after resume either since it will have to be explicitly
> reconfigured.

I just copied that from pwm-samsung.c

I think the point is to avoid the "no transients" short-circuit in
omap_pwm_config if the config is unchanged.

The assumption is that pwm_disable() will be called before suspend and
pwm_config()/pwm_enable() after resume.  So there is no point actually
configuring anything in .resume() - it makes sense to wait until pwm_config=
()
is called (if ever).  But we want to make sure that pwm_config actually does
something.

But yes, I should change to dev_pm_ops.

>=20
> > +static struct platform_driver omap_pwm_driver =3D {
> > +	.driver.name	=3D "omap-pwm",
> > +	.driver.owner	=3D THIS_MODULE,
>=20
> The more idiomatic way of writing this is:
>=20
> 	.driver =3D {
> 		.name =3D "omap-pwm",
> 		.owner =3D THIS_MODULE,
> 	},
>=20

I guess... though I think my way is a lot neater.  But conformity is good.

> > +	.probe		=3D omap_pwm_probe,
> > +	.remove		=3D __devexit_p(omap_pwm_remove),
>=20
> No __devexit_p anymore.
>=20

OK.

> > +	.suspend	=3D omap_pwm_suspend,
> > +	.resume		=3D NULL,
> > +};
> > +
> > +static int __init omap_pwm_init(void)
> > +{
> > +	return platform_driver_register(&omap_pwm_driver);
> > +}
> > +
> > +static void __exit omap_pwm_exit(void)
> > +{
> > +	platform_driver_unregister(&omap_pwm_driver);
> > +}
> > +
> > +arch_initcall(omap_pwm_init);
>=20
> This should probably be module_init() instead. You already return
> -EPROBE_DEFER if the dual-mode timer isn't ready yet so you should bite
> the bullet and get all the dependencies to behave properly as well. New
> code shouldn't be using this kind of dependency handling.
>=20
> In that case you could also just run module_platform_driver().
>=20
> Thierry
>=20
> > +module_exit(omap_pwm_exit);
> > +
> > +MODULE_AUTHOR("Grant Erickson <marathon96@gmail.com>");
> > +MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
>=20
> Shouldn't this be "Neil Brown"? I noticed you use the concatenated form
> in the email address as well, so maybe that's on purpose?

Yes, it is on purpose.  With a surname like "Brown", one likes finding ways
to be distinctive :-)

>=20
> > +MODULE_LICENSE("GPLv2");
>=20
> This should be "GPL v2". Maybe MODULE_DESCRIPTION() would be nice too.

Fixed.

>=20
> Thierry

Thanks for your very thorough review!  I'll send an updated version once I'=
ve
resolved other comments and tested again.

NeilBrown

--Sig_/Q_Wj2VK8cvdETqTAdz5QGuj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMk/pDnsnt1WYoG5AQKJyQ//WaS1C68c23W2VhiqagMBAc6b7kxa2dWc
VFxarXvytz4QzS4ChWbyOaJVfaehYlIEgBX0KR9oH0xyIbpp53gX4HZEMbgLzC83
KWYBGu6wWNykYtpbmrai3RowaMSIFRma//zQdgT1FtLcLGxdKskY+2hR34e16/13
EI2tSkAzhVWccrxnNaYc1+1sW+htuipeXLEyQmUHJ76Gl24Nzbu1OMv5bKXeTUFV
013Ddv33T/aXwUsziZWWYXSQ6p2ZPTLiLhuZT2CcB6JnX19GLzqjy4k21u30NkX2
kE+26J3avWoCtpRjg76FgFUPqkJ1EJuvjvzpXyI3pub/dRlaJsBakEsYrt/KPyoc
8G0piRnD/G+L6RT3sI88mJf9duUMfcmFFvmTLqpzhX3AV6S7RylV20M/MXfKeIOZ
tPuwkWfmHH/7XaaV5T6/ViuHcUSWOMBd3Emhzz2menLF/AA2zIpp4uTMoicE3WWp
VD+/zVtN4ITPAFaJxfVBt3hHIzPG9aiwBhhYvslp8IVLa3zNBfnqhQxHvA4IkwEu
MCLQwx1v4dvU4m1YRO/uZLW+8YB4qMchhcJ+ptuA4BW6Gq3WSJ+OaZO+C1mKnzBB
pBPtQlRHLg5C3iQ9yRBexXkmoeROt8nmfoUTkfUKVdtRd6SlasBzLAjRXA2myN43
FIpngW5H2x4=
=PW8H
-----END PGP SIGNATURE-----

--Sig_/Q_Wj2VK8cvdETqTAdz5QGuj--
