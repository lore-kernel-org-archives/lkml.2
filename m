Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2JVMPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:15:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43051 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab2JVMPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:15:35 -0400
Date: Mon, 22 Oct 2012 15:07:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Alexander Schulz <alex@shark-linux.de>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Stephen Warren <swarren@wwwdotorg.org>, Andrew Lunn <andrew@lunn.ch>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH] arm: sched: stop sched_clock() during suspend
Message-ID: <20121022120722.GV14033@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350906877-19410-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="185D1s7FREAUfc0L"
Content-Disposition: inline
In-Reply-To: <1350906877-19410-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--185D1s7FREAUfc0L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 22, 2012 at 02:54:37PM +0300, Felipe Balbi wrote:
> The scheduler imposes a requirement to sched_clock()
> which is to stop the clock during suspend, if we don't
> do that IRQ threads will be rescheduled in the future
> which might cause transfers to timeout depending on
> how driver is written.
>=20
> This became an issue on OMAP when we converted omap-i2c.c
> to use threaded IRQs, it turned out that depending on how
> much time we spent on suspend, the I2C IRQ thread would
> end up being rescheduled so far in the future that I2C
> transfers would timeout and, because omap_hsmmc depends
> on an I2C-connected device to detect if an MMC card is
> inserted in the slot, our rootfs would just vanish.
>=20
> arch/arm/kernel/sched_clock.c already had an optional
> implementation (sched_clock_needs_suspend()) which would
> handle scheduler's requirement properly, what this patch
> does is simply to make that implementation non-optional.
>=20
> This has been tested with beagleboard XM (OMAP3630) and
> pandaboard rev A3 (OMAP4430). Suspend to RAM is now working
> after this patch.
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>

just adding more guys to Cc. Please add more if I have missed someone.

> ---
>  arch/arm/include/asm/sched_clock.h |  2 --
>  arch/arm/kernel/sched_clock.c      | 18 ++++--------------
>  2 files changed, 4 insertions(+), 16 deletions(-)
>=20
> diff --git a/arch/arm/include/asm/sched_clock.h b/arch/arm/include/asm/sc=
hed_clock.h
> index 05b8e82..e3f7572 100644
> --- a/arch/arm/include/asm/sched_clock.h
> +++ b/arch/arm/include/asm/sched_clock.h
> @@ -10,7 +10,5 @@
> =20
>  extern void sched_clock_postinit(void);
>  extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long=
 rate);
> -extern void setup_sched_clock_needs_suspend(u32 (*read)(void), int bits,
> -		unsigned long rate);
> =20
>  #endif
> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
> index e21bac2..fc6692e 100644
> --- a/arch/arm/kernel/sched_clock.c
> +++ b/arch/arm/kernel/sched_clock.c
> @@ -107,13 +107,6 @@ static void sched_clock_poll(unsigned long wrap_tick=
s)
>  	update_sched_clock();
>  }
> =20
> -void __init setup_sched_clock_needs_suspend(u32 (*read)(void), int bits,
> -		unsigned long rate)
> -{
> -	setup_sched_clock(read, bits, rate);
> -	cd.needs_suspend =3D true;
> -}
> -
>  void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long=
 rate)
>  {
>  	unsigned long r, w;
> @@ -189,18 +182,15 @@ void __init sched_clock_postinit(void)
>  static int sched_clock_suspend(void)
>  {
>  	sched_clock_poll(sched_clock_timer.data);
> -	if (cd.needs_suspend)
> -		cd.suspended =3D true;
> +	cd.suspended =3D true;
>  	return 0;
>  }
> =20
>  static void sched_clock_resume(void)
>  {
> -	if (cd.needs_suspend) {
> -		cd.epoch_cyc =3D read_sched_clock();
> -		cd.epoch_cyc_copy =3D cd.epoch_cyc;
> -		cd.suspended =3D false;
> -	}
> +	cd.epoch_cyc =3D read_sched_clock();
> +	cd.epoch_cyc_copy =3D cd.epoch_cyc;
> +	cd.suspended =3D false;
>  }
> =20
>  static struct syscore_ops sched_clock_ops =3D {
> --=20
> 1.8.0.rc0
>=20

--=20
balbi

--185D1s7FREAUfc0L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhTb6AAoJEIaOsuA1yqREj8gQAIfa9ZGrJTnFNYJs/ED6IMIr
/oT0wsvGqyXe34Q+ZwTLf3args0IgPK0rgVm/VdFAAi0bOX0r33nKLxtbkwuXWyS
G/vROlpYxI5Px25T98LbtnNKcjJwQmaDQJmf4/gg6cU9rspfV/417H0Fa7oq7IxC
/zAjzirPwhw9PzNk9lRItIwP5Vj2WFQI0SX/utkRi8X1HvmwUSQxmOkPLMEezB7g
fD4UA87XaG+4J8sf1TUWCvV85kmVKZ16B/N8mILQL2QUkfIXm8W8GcyHeF25ciiE
hHIQjLAvE56cL45ng3MU56G+Vu0Ta5qK67IiVc5VYweqCm2wTpRAB2WlWaA2dANF
Vvk9g+QHmwMxSVLf9LQ4dmxQFJpdp+HYb4vL+l3g7tgvJBMmYLyeyklV0JEGKo5d
1M7A56s1RVnbRtH/i+Jlyy7/lN4VUHcJ3ldwQizPsz9tCopCuKtxU2F+vnCTMR5y
cLW+d/5Rd4wdjMNYMmTKTnuVA9yoLQc29EijKH6YhAN854x8l+e30loz2LS/DxqU
o7VN10QHGL5Ym2Gs3MBeM6fmS98ld8fXbHANI0XvYNgt78KCkuH5x09CyurNEYbY
iZQxLUs7hmW3/3a0why7wUq9C4VrMImApZm4n1k6INeB0wUSTnrOnJfBvMirRi1E
3musyxE3PTpAMBQPM1j9
=+Nrt
-----END PGP SIGNATURE-----

--185D1s7FREAUfc0L--
