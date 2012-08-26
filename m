Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2HZWxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 18:53:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab2HZWxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 18:53:34 -0400
Date: Mon, 27 Aug 2012 08:53:12 +1000
From: NeilBrown <neilb@suse.de>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Cousson@suse.de,
        Benoit <b-cousson@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
Message-ID: <20120827085312.75957354@notabene.brown>
In-Reply-To: <CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
References: <20120825214459.7333a376@notabene.brown>
	<CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UqaDBvHKQhsd/hQ9EN9La9Q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UqaDBvHKQhsd/hQ9EN9La9Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Aug 2012 09:47:50 +0530 "Shilimkar, Santosh"
<santosh.shilimkar@ti.com> wrote:

> + Jon,
>=20
> On Sat, Aug 25, 2012 at 5:14 PM, NeilBrown <neilb@suse.de> wrote:
> >
> >
> >
> > Current kernel will wake from suspend on an event on any active
> > GPIO even if enable_irq_wake() wasn't called.
> >
> > There are two reasons that the hardware wake-enable bit should be set:
> >
> > 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
> >   in which the wake-enable bit is needed for an interrupt to be
> >   recognised.
> > 2/ while suspended the GPIO interrupt should wake from suspend if and
> >    only if irq_wake as been enabled.
> >
> > The code currently doesn't keep these two reasons separate so they get
> > confused and sometimes the wakeup flags is set incorrectly.
> >
> > This patch reverts:
> >  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
> >     gpio/omap: remove suspend/resume callbacks
> > and
> >  commit 0aa2727399c0b78225021413022c164cb99fbc5e
> >     gpio/omap: remove suspend_wakeup field from struct gpio_bank
> >
> > and makes some minor changes so that we have separate flags for "GPIO
> > should wake from deep idle" and "GPIO should wake from suspend".
> >
> > With this patch, the GPIO from my touch screen doesn't wake my device
> > any more, which is what I want.
> >
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Cc: Cousson, Benoit <b-cousson@ti.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Govindraj.R <govindraj.raja@ti.com>
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >
> The patch doesn't seems to be correct. At least the 2/ gets
> fixed with a proper IRQCHIP flag. Can you try the patch at
> end of the email and see if it helps ? Am attaching it in case
> mailer damages it.
>=20
> Regards
> Santosh
>=20
> >From b8a38fc75e046f6462610e26c47c620cad850c24 Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Sun, 26 Aug 2012 09:39:51 +0530
> Subject: [PATCH] gpio: omap: Set IRQCHIP_MASK_ON_SUSPEND to mask all
>  non-wakeup gpio wakeups.
>=20
> Set the irq chip flag IRQCHIP_MASK_ON_SUSPEND to cause the irq pm code
> to mask all non-wake gpios in suspend, which will ensure the wakeup enable
> bit is not set on non-wake gpios.
>=20
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/gpio/gpio-omap.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index e6efd77..50b4c18 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -779,6 +779,7 @@ static struct irq_chip gpio_irq_chip =3D {
>  	.irq_unmask	=3D gpio_unmask_irq,
>  	.irq_set_type	=3D gpio_irq_type,
>  	.irq_set_wake	=3D gpio_wake_enable,
> +	.flags		=3D IRQCHIP_MASK_ON_SUSPEND;
>  };
>=20
>  /*---------------------------------------------------------------------*/


No obvious damage, unless the mailer is responsible or the ';' at the end of
the line, rather than ',' :-)

The approach makes sense, but does actually work.  Should be fixable though.

When I try this I get:



[  158.114440] Checking wakeup interrupts
[  158.118408] Unhandled fault: external abort on non-linefetch (0x1028) at=
 0xfb054040
[  158.126403] Internal error: : 1028 [#1] PREEMPT ARM
[  158.131500] Modules linked in: ipv6 g_ether hso libertas_sdio libertas c=
fg80211
[  158.139190] CPU: 0    Not tainted  (3.5.0-gta04-debug+ #2)
[  158.144927] PC is at _set_gpio_triggering+0x38/0x258
[  158.150115] LR is at gpio_mask_irq+0xac/0xc0
[  158.154602] pc : [<c01d24a0>]    lr : [<c01d2f68>]    psr: 60000193
[  158.154602] sp : db521e90  ip : 00000011  fp : beeecc2c
[  158.166595] r10: c05c8ebc  r9 : daa5a858  r8 : 00000003
[  158.172027] r7 : a0000193  r6 : 00000000  r5 : fb054000  r4 : ded44e18
[  158.178863] r3 : 00000001  r2 : 00000000  r1 : ded30340  r0 : 00000040
[  158.185668] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segmen=
t use

so it looks like runtime PM has turned off the iclk to the GPIO module so t=
hat
when we try to tell it to change settings, it is no longer listening to us.
The "Checking wakeup interrupts" function happens very late in the suspend
cycle, after all the suspend_late and suspend_noirq functions have run.
Maybe it needs to be moved earlier...

Thanks,
NeilBrown

--Sig_/UqaDBvHKQhsd/hQ9EN9La9Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDqo3znsnt1WYoG5AQI+QQ/9EfLTtFcWrF9D9RvMvaN31ZrXIdtZLKF7
bf8eWNIH63TihMcODqMcS+URqOvRgGxkStXVxUakGTU2PhNwhKIudoBMxrHQtp3J
p/EfZ3rhOKyyWd99kRfYzibktMkf+aVxEvwBGNgv20DyVc4qx/MUdPwjWK9XtleS
3ExT54Dzf8BrxIi+B/BwF7XGeluceLGM/yNwU07kW2FcPIDdTiEGyYI7SELpNfP1
0B5bGr9ALeiOCYaOxb/nFnWtjCEBlw0u+g9ay+sWHbawVU3+LgpCO79qs1paDkbF
dKJitpCcTm5ZGdhOVxBuMnwF4Zm6Hbsm2drMVzV9iMk1iFGq/C+8Q1EAXu/mXz5b
8pPBTfTTx2FrZt+SGE+pfzmkUA0mvb1K21Nd7XPKtgYqktycIRP3Qd/esQfodQh7
du4tX83+8aGK50dEpCT8ulZWxBJwq70zndTOtKdi5moXObM62qsM+manFOFcfZnN
GXsyuceo0H6Lr6nCGq5GdtuhP6G81hEJOgN/MfPA5hOaWIEdyV7/EJkKyMhbsWwJ
eCs/11g7Rz2EUNaaf8Fk9/F+/LRZ9A/EmUwcnj3BB4PTJc2QM/QKJVQO3IXYcPYG
/qFfLBYMl4e1XSpBNV1OzluPhKm3X1kkPejbGnDryOjRKArB5lUMRHK77zmLQGxx
PV6lkzQMIXM=
=R6BH
-----END PGP SIGNATURE-----

--Sig_/UqaDBvHKQhsd/hQ9EN9La9Q--
