Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2IFNac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:30:32 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:60497 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804Ab2IFNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:30:30 -0400
Date: Thu, 6 Sep 2012 16:26:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit <b-cousson@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
Message-ID: <20120906132604.GM29202@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120825214459.7333a376@notabene.brown>
 <CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
 <20120827085312.75957354@notabene.brown>
 <CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
 <CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com>
 <20120906130510.32b0b877@notabene.brown>
 <CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
 <20120906170245.10e97bdd@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UUMz/kfoogzZ9WLZ"
Content-Disposition: inline
In-Reply-To: <20120906170245.10e97bdd@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UUMz/kfoogzZ9WLZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 06, 2012 at 05:02:45PM +1000, NeilBrown wrote:
> On Thu, 6 Sep 2012 11:18:09 +0530 "Shilimkar, Santosh"
> <santosh.shilimkar@ti.com> wrote:
>=20
> > On Thu, Sep 6, 2012 at 8:35 AM, NeilBrown <neilb@suse.de> wrote:
> > > On Mon, 3 Sep 2012 22:59:06 -0700 "Shilimkar, Santosh"
> > > <santosh.shilimkar@ti.com> wrote:
>=20
> > >> After thinking bit more on this, the problem seems to be coming
> > >> mainly because the gpio device is runtime suspended bit early than
> > >> it should be. Similar issue seen with i2c driver as well. The i2c is=
sue
> > >> was discussed with Rafael at LPC last week. The idea is to move
> > >> the pm_runtime_enable/disable() calls entirely up to the
> > >> _late/_early stage of device suspend/resume.
> > >> Will update this thread once I have further update.
> > >
> > > This won't be late enough.  IRQCHIP_MASK_ON_SUSPEND takes effect afte=
r all
> > > the _late callbacks have been called.
> > > I, too, spoke to Rafael about this in San Diego.  He seemed to agree =
with me
> > > that the interrupt needs to be masked in the ->suspend callback.  any=
 later
> > > is too late.
> > >
> > Thanks for information about your discussion. Will wait for the patch t=
hen.
> >=20
> > Regards
> > santosh
>=20
> I already sent a patch - that is what started this thread :-)
>=20
> I include it below.
> You said "The patch doesn't seems to be correct" but didn't expand on why.
> Do you still think it is not correct?  I wouldn't be surprised if there is
> some case that it doesn't handle quite right, but it seems right to me.
>=20
> Thanks,
> NeilBrown
>=20
>=20
> From: NeilBrown <neilb@suse.de>
> Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
>=20
> Current kernel will wake from suspend on an event on any active
> GPIO even if enable_irq_wake() wasn't called.
>=20
> There are two reasons that the hardware wake-enable bit should be set:
>=20
> 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
>   in which the wake-enable bit is needed for an interrupt to be
>   recognised.
> 2/ while suspended the GPIO interrupt should wake from suspend if and
>    only if irq_wake as been enabled.
>=20
> The code currently doesn't keep these two reasons separate so they get
> confused and sometimes the wakeup flags is set incorrectly.
>=20
> This patch reverts:
>  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
>     gpio/omap: remove suspend/resume callbacks
> and
>  commit 0aa2727399c0b78225021413022c164cb99fbc5e
>     gpio/omap: remove suspend_wakeup field from struct gpio_bank
>=20
> and makes some minor changes so that we have separate flags for "GPIO
> should wake from deep idle" and "GPIO should wake from suspend".
>=20
> With this patch, the GPIO from my touch screen doesn't wake my device
> any more, which is what I want.
>=20
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Cousson Benoit <b-cousson@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Govindraj.R <govindraj.raja@ti.com>
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 4fbc208..fdbad70 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -57,6 +57,7 @@ struct gpio_bank {
>  	u16 irq;
>  	int irq_base;
>  	struct irq_domain *domain;
> +	u32 suspend_wakeup;
>  	u32 non_wakeup_gpios;
>  	u32 enabled_non_wakeup_gpios;
>  	struct gpio_regs context;
> @@ -522,11 +523,12 @@ static int _set_gpio_wakeup(struct gpio_bank *bank,=
 int gpio, int enable)
> =20
>  	spin_lock_irqsave(&bank->lock, flags);
>  	if (enable)
> -		bank->context.wake_en |=3D gpio_bit;
> +		bank->suspend_wakeup |=3D gpio_bit;
>  	else
> -		bank->context.wake_en &=3D ~gpio_bit;
> +		bank->suspend_wakeup &=3D ~gpio_bit;
> =20
> -	__raw_writel(bank->context.wake_en, bank->base + bank->regs->wkup_en);
> +	if (!bank->loses_context)
> +		__raw_writel(bank->suspend_wakeup, bank->base + bank->regs->wkup_en);
>  	spin_unlock_irqrestore(&bank->lock, flags);
> =20
>  	return 0;
> @@ -1157,6 +1159,51 @@ static int __devinit omap_gpio_probe(struct platfo=
rm_device *pdev)
>  #ifdef CONFIG_ARCH_OMAP2PLUS
> =20
>  #if defined(CONFIG_PM_RUNTIME)
> +
> +#if defined(CONFIG_PM_SLEEP)
> +static int omap_gpio_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct gpio_bank *bank =3D platform_get_drvdata(pdev);
> +	void __iomem *base =3D bank->base;
> +	unsigned long flags;
> +
> +	if (!bank->mod_usage || !bank->loses_context)
> +		return 0;
> +
> +	if (!bank->regs->wkup_en || !bank->context.wake_en)
> +		return 0;
> +
> +	spin_lock_irqsave(&bank->lock, flags);

shouldn't you be using _noirq methods instead ? Then this would become a
normal spin_lock()/spin_unlock().

--=20
balbi

--UUMz/kfoogzZ9WLZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSKRsAAoJEIaOsuA1yqREJMMQAIxCAQsqKkH7iLk9rrZ14e6B
KXrC6KrA0/2HW833t8nud4cRQZmoBYJkjitlpn7467t7zVhY6WZfpGH9AXH10yHa
vm9lX3QFDECGaY2S85+Ycsp8G17boIR6xMK8O2lfyHxSfIG5gS0nvAwmjLLZnsAn
nG7YsABqKbSyucpeRswVcN2Va7OPX5mJi3BYXk39k4xJ8bGJ1YSplXwtuu6/avVZ
VJCN10Kvtdxa5J7Hi08oaOz1qb3E+4OsUp4toseuHxHr+tlNiugy6GHa8vbg77qR
JldiuoENqIoddO2Nd5mL8AcvE/qlntBh9fWpHGfs/UFnfsYnvRNFPzyp9iiRC6gt
DX/pxZwz7kuCFyX9WP8vBjB9OV+OmV0Zq+xeDgUY0+1nhxLT+ke7gbQkr1uzzGxi
U3Pr96/QqgzEv+ee5S1fQwLrsv1SrW++sHYT5vbNgaOd0KayHJAFmMLubhd65vf5
veaKLOE/VpT3hiyltQ+l1PebutHCrJTQkQjq9z1D2kFpgu5cyQUmF2kQOBg3JAf1
jDMEvNWLC9SVt9weYnYW8IvrtDwTtx0NPUDFVPluygcL6/6LhkvM2dp2HU2EuvZ4
mqDRk1Llp+rub6CYusNHmz78n5vYeGDAYsWH8jWQx/B3l+c9HjeNLexfsmeRsp51
Pp5L9/kRyeia4CykbKjD
=34Jd
-----END PGP SIGNATURE-----

--UUMz/kfoogzZ9WLZ--
