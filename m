Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2GaMff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:35:35 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:51040 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab2GaMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:35:34 -0400
Date: Tue, 31 Jul 2012 15:32:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: balbi@ti.com, "Poddar, Sourav" <sourav.poddar@ti.com>,
        Kevin Hilman <khilman@ti.com>,
        "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>,
        lo <linux-omap@vger.kernel.org>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GPIO] Crashed when not using
Message-ID: <20120731123209.GA8024@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <CAKdam54gXixs4F-a07ajj9GNMth46d4NTdoUL3GokzvjuWaGyg@mail.gmail.com>
 <CAC83ZvKnOw+UBOWYtt294k-5Xk8S6Gy1pChSF7aXGmGjLGSeCA@mail.gmail.com>
 <CAKdam56QEXY55SYC7YND4BP=tQmiyAa=avVCADTj3Ym6X9cCvg@mail.gmail.com>
 <87fw89gf4w.fsf@ti.com>
 <CAKdam57xtXnKAgvneqATSTr0ng978T5HbkTB0T3sYp96N=Qfww@mail.gmail.com>
 <20120731065224.GE6004@arwen.pp.htv.fi>
 <CAMQu2gxXX+4gtKVnAMMK4qr9ihJuP-OwjOYgr=6VrGZ2DWSf2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <CAMQu2gxXX+4gtKVnAMMK4qr9ihJuP-OwjOYgr=6VrGZ2DWSf2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 31, 2012 at 02:32:43PM +0200, Shilimkar, Santosh wrote:
> On Tue, Jul 31, 2012 at 8:52 AM, Felipe Balbi <balbi@ti.com> wrote:
> >
> > Hi,
> >
> > On Tue, Jul 31, 2012 at 10:23:16AM +0530, Poddar, Sourav wrote:
> > > >>>> The device tree data for acquiring the above GPIO interrupt line
> > > >>>> looks
> > > >>>> like this.
> > > >>>>
> > > >>>> +++ linux-omap-storage/arch/arm/boot/dts/omap5-evm.dts  2012-07-=
30
> > > >>>> 14:11:08.931694001 +0530
> > > >>>> @@ -42,7 +42,8 @@
> > > >>>>         tsl2771@39 {
> > > >>>>                 compatible =3D "taos,tsl2771";
> > > >>>>                 reg =3D <0x39>;
> > > >>>> +                interrupt-parent =3D <&gpio5>;
> > > >>>> +                interrupts =3D <21>; /* gpio line 149 */
> > > >>>>         };
> > > >>>>  };
> > > >>>>
> > > >>>> Note: using "gpio_request_one" in the driver solves the issue.
> > > >>>> Is using this api in the driver required?
> > > >>>> Any pointer on the above crash?
> > > >>>
> > > >> Hi Tarun,
> > > >>> Any user/client driver of GPIO is supposed to go through
> > > >>> gpio_request() API so that module clock
> > > >>> is enabled correctly. Overriding of APIs would put the power
> > > >>> management state machine in jeopardy.
> > > >>> --
> > > >> I tried putting "pm_runtime_get_sync" in gpio_irq_type api where t=
he
> > > >> kernel
> > > >> is crashing and the crash is no longer observed. So indeed, its ab=
out
> > > >> enabling clocks.
> > > >>
> > > >> One doubt: Can't we put runtime apis in "gpio_irq_type" and elimin=
ate
> > > >> the use of
> > > >> "gpio_request_one"??
> > > >
> > > > No.
> > > >
> > > > You must use the GPIO requiest/free APIs to tell the GPIO core that
> > > > the GPIO line is in use.
> > > >
> > > Thanks for this confirmation.
> > > > Why do you want to avoid using gpio_request/gpio_free?
> > > >
> > > I was assuming that DT based gpio IRQ registration will automatically
> > > take care of
> > > the above APIs. But since that is not the case(as mentioned by
> > > santosh),  we need to use the
> > > gpio_request/free apis.
> >
> > Hang on for a while, let's try to get to the bottom of this debate first
> > ;-)
> >
> > We have a canonical way of passing IRQ numbers to drivers through DT and
> > that is the "interrupts" attribute. It shouldn't matter if that IRQ pin
> > is connected to a real IRQ line or through a GPIO controller. In both
> > cases we should use the "interrupts" attribute.
> >
> > If DT core doesn't allocate the GPIO for us then how does this work:
> >
> > (omap4-sdp.dts)
> >
> > 127 &mcspi1 {
> > 128         eth@0 {
> > 129                 compatible =3D "ks8851";
> > 130                 spi-max-frequency =3D <24000000>;
> > 131                 reg =3D <0>;
> > 132                 interrupt-parent =3D <&gpio2>;
> > 133                 interrupts =3D <2>; /* gpio line 34 */
> > 134                 vdd-supply =3D <&vdd_eth>;
> > 135         };
> > 136 };
> >
> >
> > There's no gpio request on the driver:
> >
> > $ git grep -e gpio_request drivers/net/ethernet/micrel/ks8851.c
> > $
> >
> > Since Benoit was the one who added that to the dts file (commit
> > e7c64db9), I assume he tested his patch before posting, so again I ask -
> > How does that work and why doesn't this work for Sourav's tsl2771
> > controller ?
> >
> > This is either a regression on drivers/of, or commit e7c64db9 is also
> > broken...
> >
> > Benoit, do you know how should this work ?
> >
> I had a discussion with Benoit on this. In fact there is a way to actually
> trigger the GPIO request.
>=20
> > 132                 interrupt-parent =3D <&gpio2>;
> > 133                 interrupts =3D <2>; /* gpio line 34 */
>=20
> As above you can see, GPIO2 bank and 2nd line.
> And then it will make use of gpio_irq chip properties
> to probe the GPIO line.
>=20
> Saurabh can try this out for his use case.

Isn't this exactly what Sourav has ?

> > > >>>> +++ linux-omap-storage/arch/arm/boot/dts/omap5-evm.dts  2012-07-=
30
> > > >>>> 14:11:08.931694001 +0530
> > > >>>> @@ -42,7 +42,8 @@
> > > >>>>         tsl2771@39 {
> > > >>>>                 compatible =3D "taos,tsl2771";
> > > >>>>                 reg =3D <0x39>;
> > > >>>> +                interrupt-parent =3D <&gpio5>;
> > > >>>> +                interrupts =3D <21>; /* gpio line 149 */
> > > >>>>         };
> > > >>>>  };

???

--=20
balbi

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQF9BJAAoJEIaOsuA1yqREK/sQAKOha9ZO7pejZiY7LAFAdSx7
Qkm5cRLs6ZQMFaLI0XD+LjOHCksKJLwA7kAfbgvQqQFEu4os1jZG83G3UfZclKRb
/kH22YRSeSmqwmTT5E8N1C1aUswKOaH1MJXgWv3S64FZdyI5lL+9fCXEZ2BZAaNG
t/jdzXhtjKSMLnsKo/alyxuiH92PEgtYNgURFEUAusg9ihwZyFe5jlP94icT5ugJ
3+xuf69sSZRwLFuDd6uDXlGp7AHe1Pi1GIhL0pJ6Puh430UlbP7DPh1eQIS2oBa0
4VaFmBcE6zQHmQuOs2AKp5V9PjZhIdDrmsCLFmBZ4K2Kx4EtKwsUnf9uIgyBNg2n
9zohXtbgEikK+N/J9cj4P1DwGjbfhhDGQlpn32D9UJzfpZfFOTscuOwW3zJv9nw0
FLViBkSAfRLb5fLGPL9dWSCmFdZhdsaldLyY+nkBZc9TkXFrj+HIBj196uLDKC9g
ThhCiOOuFjNwdbSFIPi2Y3z1B6sq/WEkuovx7qcaH3qAQ/+03ThTN9U418fVFre0
468Pja3qWddpV4xB2EmayN8KSKAwiD0Z+n4IFRBMCMwZvPFcalJa3PbbUPOdWRUI
SG98S0okwKU6gJ+5od066x3NnGEq0Fk+h2FoXtgBZTefUFIINa5sYhzUTkTZA21v
WFS19gzf68iJfcRUyGWF
=BCSA
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
