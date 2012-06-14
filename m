Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2FNLrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:47:55 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:43916 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab2FNLrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:47:53 -0400
Date: Thu, 14 Jun 2012 14:45:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 04/17] i2c: omap: simplify omap_i2c_ack_stat()
Message-ID: <20120614114546.GP13602@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
 <1339669250-9183-5-git-send-email-balbi@ti.com>
 <20120614111333.GA31187@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qd/SZIFVu+MYwfCR"
Content-Disposition: inline
In-Reply-To: <20120614111333.GA31187@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qd/SZIFVu+MYwfCR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 14, 2012 at 12:13:33PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 14, 2012 at 01:20:37PM +0300, Felipe Balbi wrote:
> > stat & BIT(1) is the same as BIT(1), so let's
> > simplify things a bit by removing "stat &" from
> > all omap_i2c_ack_stat() calls.
>=20
> This doesn't feel right, and the explanation is definitely wrong.
>=20
> "stat & BIT(1)" is not the same as "BIT(1)" _unless_ you're saying that
> stat always has BIT(1) already set.  Can you guarantee that in this code?
> If so, how?
>=20
> What happens if you read the status register, and it has bit 1 clear.
> immediately after the read, the status register bit 1 becomes set, and
> then you write bit 1 set (because you've dropped the stat & BIT(1) from
> the code.)
>=20
> Is it not going to acknowledge that bit-1-set but because you haven't
> read it, you're going to miss that event?
>=20
> This feels like a buggy change to me.

I fail to see that situation would happen with this driver. See what it
does (extremely simplified):

if (stat & NACK) {
	...
	omap_i2c_ack_stat(dev, stat & NACK);
}

if (stat & RDR) {
	...
	omap_i2c_ack_stat(dev, stat & RDR);
}

and so on. The tricky place is only WRT errata handling, for example:

if (*stat & (NACK | AL)) {
	omap_i2c_ack_stat(dev, *stat & (XRDY | XDR));
	...
}

but in this case, the errata says we must clear XRDY and XDR if that
errata triggers, so if they just got enabled or not, it doesn't matter.

Another tricky place is RDR | RRDY (likewise for XDR | XRDY):

if (stat & (RDR | RRDY)) {
	...
	omap_i2c_ack_stat(dev, stat & (RDR | RRDY));
}

again here there will be no issues because those IRQs never fire
simultaneously and one will only after after we have handled the
previous, that's because the same FIFO is used anyway and we won't shift
data into FIFO until we tell the IP "hey, I'm done with the FIFO, you
can shift more data". Right ?

--=20
balbi

--qd/SZIFVu+MYwfCR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2c7qAAoJEIaOsuA1yqRE+hEQAKHB1QxoORbpdUAna54oWtKo
ynsOCQB5n5u9EAzUncuBJEjacgS6rsZ4LNogmBclXtp+uqHLoiT6yJi+oyKm7POk
+kLe4aUFKaUnYr4bBzBoIxIqqsGylYgDhv/+QGgtXs5l1WN6gLBrM+X1a5LfGn+q
jssJg52nLQi2HTLykxdJP73FVnGxcpat1dVTbic9O4O0JQCRaofjhPCU8vDDsAOl
H1kyFgcQSpU8h+L4rayn7SKmoafee09gzMQe1BtG5YV22vwMNMk+M3CcpgyIhMzm
HzSQwRAr2OXQnA7MwQVi0brNCkGim6GntsiUgC2UrXaMVByTTjEeJpM082H/Y9f8
a3EymJm6B3g0QWmRPFDFdpFtH4MrzhyhLYJigfsQq8XoqnSyfE3gjAnp2ypvJV3H
Ium4pug3xdq4DA5R+Qv9GGxEsSTwyjQ03INCdJOLdomXJWk6dth79Xu4iR1j5CTO
Pp9wJhjIDiBwNaTTg/BpnjTghXdqYC8YFSt/aqOrTi8SdWy+gZEqtdWJdL/BFFPH
kq2JDrSEcj9xxdLlAAy0T0aapqnvTk9o6Ef5nnua/CXwZgJEWMMWzjLq9bFvll5i
fGC23OAN2IDkqufrnn4O39sU92pV7sJMeYVVVbec7wXpH/LiXO/PJPK40mADtZCz
nnQhw8yxwm8xjmLzTB0b
=TeSf
-----END PGP SIGNATURE-----

--qd/SZIFVu+MYwfCR--
