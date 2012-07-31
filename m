Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2GaGzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:55:52 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:35709 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab2GaGzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:55:49 -0400
Date: Tue, 31 Jul 2012 09:52:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>,
        "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>,
        lo <linux-omap@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [GPIO] Crashed when not using
Message-ID: <20120731065224.GE6004@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <CAKdam54gXixs4F-a07ajj9GNMth46d4NTdoUL3GokzvjuWaGyg@mail.gmail.com>
 <CAC83ZvKnOw+UBOWYtt294k-5Xk8S6Gy1pChSF7aXGmGjLGSeCA@mail.gmail.com>
 <CAKdam56QEXY55SYC7YND4BP=tQmiyAa=avVCADTj3Ym6X9cCvg@mail.gmail.com>
 <87fw89gf4w.fsf@ti.com>
 <CAKdam57xtXnKAgvneqATSTr0ng978T5HbkTB0T3sYp96N=Qfww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Content-Disposition: inline
In-Reply-To: <CAKdam57xtXnKAgvneqATSTr0ng978T5HbkTB0T3sYp96N=Qfww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 31, 2012 at 10:23:16AM +0530, Poddar, Sourav wrote:
> >>>> The device tree data for acquiring the above GPIO interrupt line loo=
ks
> >>>> like this.
> >>>>
> >>>> +++ linux-omap-storage/arch/arm/boot/dts/omap5-evm.dts  2012-07-30
> >>>> 14:11:08.931694001 +0530
> >>>> @@ -42,7 +42,8 @@
> >>>>         tsl2771@39 {
> >>>>                 compatible =3D "taos,tsl2771";
> >>>>                 reg =3D <0x39>;
> >>>> +                interrupt-parent =3D <&gpio5>;
> >>>> +                interrupts =3D <21>; /* gpio line 149 */
> >>>>         };
> >>>>  };
> >>>>
> >>>> Note: using "gpio_request_one" in the driver solves the issue.
> >>>> Is using this api in the driver required?
> >>>> Any pointer on the above crash?
> >>>
> >> Hi Tarun,
> >>> Any user/client driver of GPIO is supposed to go through
> >>> gpio_request() API so that module clock
> >>> is enabled correctly. Overriding of APIs would put the power
> >>> management state machine in jeopardy.
> >>> --
> >> I tried putting "pm_runtime_get_sync" in gpio_irq_type api where the k=
ernel
> >> is crashing and the crash is no longer observed. So indeed, its about
> >> enabling clocks.
> >>
> >> One doubt: Can't we put runtime apis in "gpio_irq_type" and eliminate
> >> the use of
> >> "gpio_request_one"??
> >
> > No.
> >
> > You must use the GPIO requiest/free APIs to tell the GPIO core that
> > the GPIO line is in use.
> >
> Thanks for this confirmation.
> > Why do you want to avoid using gpio_request/gpio_free?
> >
> I was assuming that DT based gpio IRQ registration will automatically
> take care of
> the above APIs. But since that is not the case(as mentioned by
> santosh),  we need to use the
> gpio_request/free apis.

Hang on for a while, let's try to get to the bottom of this debate first
;-)

We have a canonical way of passing IRQ numbers to drivers through DT and
that is the "interrupts" attribute. It shouldn't matter if that IRQ pin
is connected to a real IRQ line or through a GPIO controller. In both
cases we should use the "interrupts" attribute.

If DT core doesn't allocate the GPIO for us then how does this work:

(omap4-sdp.dts)

127 &mcspi1 {
128         eth@0 {
129                 compatible =3D "ks8851";
130                 spi-max-frequency =3D <24000000>;
131                 reg =3D <0>;
132                 interrupt-parent =3D <&gpio2>;
133                 interrupts =3D <2>; /* gpio line 34 */
134                 vdd-supply =3D <&vdd_eth>;
135         };
136 };


There's no gpio request on the driver:

$ git grep -e gpio_request drivers/net/ethernet/micrel/ks8851.c
$

Since Benoit was the one who added that to the dts file (commit
e7c64db9), I assume he tested his patch before posting, so again I ask -
How does that work and why doesn't this work for Sourav's tsl2771
controller ?

This is either a regression on drivers/of, or commit e7c64db9 is also
broken...

Benoit, do you know how should this work ?

--=20
balbi

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQF4CoAAoJEIaOsuA1yqRE1XsP/ifm46Exy1QL2lpopNR7YRkz
gN5tElKpODablne0m+sZ/GREDvgr7VpK856ZfwhLv2p9EaaQxWjeeXU7WHM+TsBz
0MU1m9vymXIO2NN/Yz0plKrWP2y4u/8491yGgZL2eOe12h5ga3bGG0Vxsy7T3KfO
itoqhhXlr+Uj1qIBQnJByBB+HG3ZlMJy2Ze2UHBOtTX1HkrFKZamwaa0j9wHY+B+
BsnQ93Xi7cTnaJCXQf2Ei9+NRbJLQhC/c8EiiL+qaA1wmaNbv0CJsksC031v0MKM
9erfxFiHxyhOIiXYQwmUfgdxGLPL5j3wCpAXokubEdnqNdsqVG47QAKTx7bIjQkn
JF4FCGCyoZz3wIc0IPVOUoQKid6Gt9ia2GdtwJD/WJMIVW+Xzs9RVHepYbYscP39
YKzZWQ3pKZm3A7jEOEoo1D/zyIUG1yabbk0b2a5yuRyguZY6iJztYBVLJP3gxbYl
CQmN97ubAE8cogXzBcPwjxTjI1PJANUYvBgmBIaUsc9sgg3zpEyAXzmzDbZDpci+
LEWKbDyf1sE0j2ZpNjABAp18bDLqJWJ8dFYx3FGbCys0xax1D27gNxNcoxeOcPCv
SM9mXETTihjON/vHiXxlFzSFOU0UAij2DK6s8fGi3jMLevAp40ZUEUX2XanK82eG
wi+uZRXOs27jBD8mRGLO
=kZv5
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
