Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab1LOXu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:50:26 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:48767 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759835Ab1LOXuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:50:25 -0500
Date: Fri, 16 Dec 2011 01:50:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org,
        Hema Kalliguddi <hemahk@ti.com>
Subject: Re: [PATCH] usb: musb: fix pm_runtime mismatch
Message-ID: <20111215235017.GA2242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
 <20111215230143.GA2090@legolas.emea.dhcp.ti.com>
 <CAMP44s1JMwF95nOgZLvdL7ke6fYz-ar5SDv=Lu-5QJ==0bkH=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <CAMP44s1JMwF95nOgZLvdL7ke6fYz-ar5SDv=Lu-5QJ==0bkH=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 16, 2011 at 01:31:02AM +0200, Felipe Contreras wrote:
> On Fri, Dec 16, 2011 at 1:01 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Dec 16, 2011 at 12:42:14AM +0200, Felipe Contreras wrote:
> >> In musb_init_controller() there's a pm_runtime_put(), but there's no
> >> pm_runtime_get(), which creates a mismatch that causes the driver to
> >> sleep when it shouldn't.
> >>
> >> This was introduced in 7acc619, but it wasn't triggered until 18a2689
> >> was merged to Linus' branch at point 6899608.
> >
> > you need to add the commit description (whatever was the mail's subject)
> > here too. And you should put in Cc the author or those commits too,
> > otherwise we can't poke into their brains to understand what they were
> > thinking when they originally wrote those patches.
>=20
> True, but code is code, and even if you don't know what he was
> thinking, it's clear there's something wrong.
>=20
> >> However, it seems most of the time this is used in a way that keeps the
> >> counter above 0, so nobody noticed. Also, it seems to depend on the
> >> configuration used.
> >>
> >> I found the problem by loading isp1704_charger before any usb gadgets:
> >> http://article.gmane.org/gmane.linux.kernel/1226122
> >>
> >> All versions after 2.6.39 are affected.
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >> ---
> >> =A0drivers/usb/musb/musb_core.c | =A0 =A02 --
> >> =A01 files changed, 0 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core=
=2Ec
> >> index b63ab15..920f04e 100644
> >> --- a/drivers/usb/musb/musb_core.c
> >> +++ b/drivers/usb/musb/musb_core.c
> >> @@ -2012,8 +2012,6 @@ musb_init_controller(struct device *dev, int nIr=
q, void __iomem *ctrl)
> >> =A0 =A0 =A0 if (status < 0)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail3;
> >>
> >> - =A0 =A0 pm_runtime_put(musb->controller);
> >
> > To me the real fix would be add the missing pm_runtime_get_sync(). On
> > probe() we're actually accessing MUSB's address space which needs it's
> > clocks turned on. I guess it's only working now by chance, probably
> > because glue layer calls pm_runtime_get_sync() to access it's own
> > address space and that uses the same clocks.
>=20
> Are you sure it's "musb-hdrc", and not "musb-omap2430" the one
> accessing the relevant address-space? From the runtime_pm
> documentation it looks like only the probe function should deal with
> this.
>=20
> If "musb-hdrc" was truly accessing these registers, then I would get
> the same failure because the clocks are turned off, but I don't...

see musb_core_init(); You don't see any problems when accessing those
addresses because musb_platform_init() will fall into
omap2430_musb_init() which calls pm_runtime_get_sync(), and the same
clock actually enables both address spaces (musb-omap2430 and
musb-hdrc).

(now, this was all from memory, so it could be wrong ;-)

--=20
balbi

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6oe5AAoJEIaOsuA1yqREz6kP/1YeW1iMmk3rW52Yagvqko3P
Ku1dZ01sH6lj4Kx87Kx2yoazl5kUPN6ahYKa+yEJDOjgkCRG+SHBPMBwJ3A/gcb+
t57J3E+nndvyD6tSMGkJkjv7Ic8f+1EZvkuZwJg1IYXdHM7IiE2af2t412ceMpDC
D0PbAdXljRdHi4sRILTfbeqtHv0FVbXTr/7u8EtFzQZIVFrA0qdHSyKiUZYONqsc
vhbFRzFVvqSagVu3kg3o+EeRyeGvQmHi8ZiYCLkdSWGWLO9KL5SQwfvuZ8UQYGDM
wudSbCbrlSWvlLyw9bAVsCi89e2baaRAD/8L3UwMSVDzxBR+xg/SuYe9IMnnBDeq
sex92QDo7Joijycq+WUsVnR8MZdBS1AhUBcFEOMD4Elq+FHtzfwAFEcHdh3xFmp5
LMo8SyeGwpgXXtzV+HRLIOCpiNT56vqCpVfGriZlnL4paUc40ATyA40/Em4D6THb
dD3nYGovyERNLyIUbBY46yG98Lb2DTY2EO1+IPBZ5crSNxSVGvsfO4LF2TLOMQXB
ZLKjgyGXeP/HCuGW4u2coUUWqPSSJGzH8uKuTH0aU1J7w9k3mTNf/+yfhnGrx3Jm
DNF2S5pvmxTbaiarHHI7tq5hpOIM/7N3wrRFoXCDN7tKFRCUSaQkkL4VUB4drnfZ
q2P92WZWdkq699HRjLFc
=1BNu
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
