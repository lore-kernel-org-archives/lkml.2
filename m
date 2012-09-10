Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2IJG7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:59:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2IJG7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:59:09 -0400
Date: Mon, 10 Sep 2012 16:58:56 +1000
From: NeilBrown <neilb@suse.de>
To: balbi@ti.com
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit <b-cousson@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
Message-ID: <20120910165856.715f0702@notabene.brown>
In-Reply-To: <20120906132604.GM29202@arwen.pp.htv.fi>
References: <20120825214459.7333a376@notabene.brown>
	<CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
	<20120827085312.75957354@notabene.brown>
	<CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
	<CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com>
	<20120906130510.32b0b877@notabene.brown>
	<CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
	<20120906170245.10e97bdd@notabene.brown>
	<20120906132604.GM29202@arwen.pp.htv.fi>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/48VzFzV8hHOr7Go/jLpJG6q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/48VzFzV8hHOr7Go/jLpJG6q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Sep 2012 16:26:06 +0300 Felipe Balbi <balbi@ti.com> wrote:

> Hi,
>=20
> On Thu, Sep 06, 2012 at 05:02:45PM +1000, NeilBrown wrote:
> > On Thu, 6 Sep 2012 11:18:09 +0530 "Shilimkar, Santosh"
> > <santosh.shilimkar@ti.com> wrote:
> >=20
> > > On Thu, Sep 6, 2012 at 8:35 AM, NeilBrown <neilb@suse.de> wrote:
> > > > On Mon, 3 Sep 2012 22:59:06 -0700 "Shilimkar, Santosh"
> > > > <santosh.shilimkar@ti.com> wrote:
> >=20
> > > >> After thinking bit more on this, the problem seems to be coming
> > > >> mainly because the gpio device is runtime suspended bit early than
> > > >> it should be. Similar issue seen with i2c driver as well. The i2c =
issue
> > > >> was discussed with Rafael at LPC last week. The idea is to move
> > > >> the pm_runtime_enable/disable() calls entirely up to the
> > > >> _late/_early stage of device suspend/resume.
> > > >> Will update this thread once I have further update.
> > > >
> > > > This won't be late enough.  IRQCHIP_MASK_ON_SUSPEND takes effect af=
ter all
> > > > the _late callbacks have been called.
> > > > I, too, spoke to Rafael about this in San Diego.  He seemed to agre=
e with me
> > > > that the interrupt needs to be masked in the ->suspend callback.  a=
ny later
> > > > is too late.
> > > >
> > > Thanks for information about your discussion. Will wait for the patch=
 then.
> > >=20
> > > Regards
> > > santosh
> >=20
> > I already sent a patch - that is what started this thread :-)
> >=20
> > I include it below.
> > You said "The patch doesn't seems to be correct" but didn't expand on w=
hy.
> > Do you still think it is not correct?  I wouldn't be surprised if there=
 is
> > some case that it doesn't handle quite right, but it seems right to me.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > From: NeilBrown <neilb@suse.de>
> > Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
> >=20
> > Current kernel will wake from suspend on an event on any active
> > GPIO even if enable_irq_wake() wasn't called.
> >=20
> > There are two reasons that the hardware wake-enable bit should be set:
> >=20
> > 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
> >   in which the wake-enable bit is needed for an interrupt to be
> >   recognised.
> > 2/ while suspended the GPIO interrupt should wake from suspend if and
> >    only if irq_wake as been enabled.
> >=20
> > The code currently doesn't keep these two reasons separate so they get
> > confused and sometimes the wakeup flags is set incorrectly.
> >=20
> > This patch reverts:
> >  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
> >     gpio/omap: remove suspend/resume callbacks
> > and
> >  commit 0aa2727399c0b78225021413022c164cb99fbc5e
> >     gpio/omap: remove suspend_wakeup field from struct gpio_bank
> >=20
> > and makes some minor changes so that we have separate flags for "GPIO
> > should wake from deep idle" and "GPIO should wake from suspend".
> >=20
> > With this patch, the GPIO from my touch screen doesn't wake my device
> > any more, which is what I want.
> >=20
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Cc: Cousson Benoit <b-cousson@ti.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Govindraj.R <govindraj.raja@ti.com>
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> > index 4fbc208..fdbad70 100644
> > --- a/drivers/gpio/gpio-omap.c
> > +++ b/drivers/gpio/gpio-omap.c
> > @@ -57,6 +57,7 @@ struct gpio_bank {
> >  	u16 irq;
> >  	int irq_base;
> >  	struct irq_domain *domain;
> > +	u32 suspend_wakeup;
> >  	u32 non_wakeup_gpios;
> >  	u32 enabled_non_wakeup_gpios;
> >  	struct gpio_regs context;
> > @@ -522,11 +523,12 @@ static int _set_gpio_wakeup(struct gpio_bank *ban=
k, int gpio, int enable)
> > =20
> >  	spin_lock_irqsave(&bank->lock, flags);
> >  	if (enable)
> > -		bank->context.wake_en |=3D gpio_bit;
> > +		bank->suspend_wakeup |=3D gpio_bit;
> >  	else
> > -		bank->context.wake_en &=3D ~gpio_bit;
> > +		bank->suspend_wakeup &=3D ~gpio_bit;
> > =20
> > -	__raw_writel(bank->context.wake_en, bank->base + bank->regs->wkup_en);
> > +	if (!bank->loses_context)
> > +		__raw_writel(bank->suspend_wakeup, bank->base + bank->regs->wkup_en);
> >  	spin_unlock_irqrestore(&bank->lock, flags);
> > =20
> >  	return 0;
> > @@ -1157,6 +1159,51 @@ static int __devinit omap_gpio_probe(struct plat=
form_device *pdev)
> >  #ifdef CONFIG_ARCH_OMAP2PLUS
> > =20
> >  #if defined(CONFIG_PM_RUNTIME)
> > +
> > +#if defined(CONFIG_PM_SLEEP)
> > +static int omap_gpio_suspend(struct device *dev)
> > +{
> > +	struct platform_device *pdev =3D to_platform_device(dev);
> > +	struct gpio_bank *bank =3D platform_get_drvdata(pdev);
> > +	void __iomem *base =3D bank->base;
> > +	unsigned long flags;
> > +
> > +	if (!bank->mod_usage || !bank->loses_context)
> > +		return 0;
> > +
> > +	if (!bank->regs->wkup_en || !bank->context.wake_en)
> > +		return 0;
> > +
> > +	spin_lock_irqsave(&bank->lock, flags);
>=20
> shouldn't you be using _noirq methods instead ? Then this would become a
> normal spin_lock()/spin_unlock().
>=20

I don't think it is appropriate to move functionality between the different
suspend call-backs just because it seems to make the code easier.  Each
callback has a purpose and we should stick to that purpose.
The 'suspend' callback should transition the device to  a quiescent state,
and I think that includes ensuring that unwanted interrupts won't fire.
'suspend_late' should almost always be the same as runtime_suspend - it
should power-off the device.
'suspend_noirq' ... doesn't seem to have a clear role any more since the
introduction of suspend_late.  Hopefully everything will transition over and
suspend_noirq can disappear.

More pragmatically:  By the time we get to suspend_noirq, I think the  iclk
will have been turned off and so it is too late to try to clear the wkup
flags.

Thanks,
NeilBrown


--Sig_/48VzFzV8hHOr7Go/jLpJG6q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE2PsDnsnt1WYoG5AQL5ug/+Nx+dcWWiEROX+aY3ipYLlHSUSyZ+sYej
ZOHWVxNi50Ar2/WeL/LLzVDwQXL7xbVCzSZE/zO+oKpZJHvHNwAJMqoyQSbHrQ+b
eb7/FYyjoF+TK5aWsGnJjeGxozw1kp4dg6/47tKQ546EcyKGCVbo+d7NGpWP+rTs
RsTjIuf0fAWSiQouLD4+JlE2EEeZECeYfoHOmJOff1r4U22cIdlwRfiXvB3Sm4N3
Iq7JxKKiMrvLOCc8UVb4kqgDrd9+FjTTAuuaZr8ZXfv/ktQFZaLPZEvcMfoV0bNu
/iU71jE3Odp13czUYhCmHUoJeXzIyP95j2aUf3y5KUfHWDaTk/dxEt9xTWXkJLUV
EQ9Ry1BBbw9Z4fKjGGua986r3GzNXTXZfATh6BZIy7JP9m1rqIOY/8ouPpqTvSS2
RyQjoB9mdqkoT07+bLfnfSdlFbDG+vM/J4hIZZM45oiglsUuUUAAqnVVecVZdv97
u5AZd672jXLl6dtt1SXSq29KCT/X7uHQX5kPfo4Ixxd9CqJJesSakLwR3es/hzYs
nXjxxE7NoAWOMcTUn3k1X09ErPo5s+HltxGO/sKYn5kcF+/L/SMFpTte4E/EyWPT
xddsaQMLyaidmXMZ3IMq1ukOcJ6vy4gh+NzMM+NR4XehT3ZGjRhVj/eZJsRAwLFi
C+1VYt7hIQU=
=V/p4
-----END PGP SIGNATURE-----

--Sig_/48VzFzV8hHOr7Go/jLpJG6q--
