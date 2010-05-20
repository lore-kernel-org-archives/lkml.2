Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0ETBcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:32:10 -0400
Received: from ozlabs.org ([203.10.76.45]:44107 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab0ETBcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:32:08 -0400
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, Brian King <brking@linux.vnet.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
       niv@linux.vnet.ibm.com, Doug Maxey <doug.maxey@us.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Milton Miller <miltonm@bga.com>
In-Reply-To: <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
References: <4BF30793.5070300@us.ibm.com>
	 <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>
	 <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com>
	 <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-slUSco2BpuCPtMwBKMTC"
Date: Thu, 20 May 2010 11:32:05 +1000
Message-ID: <1274319125.22892.38.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-slUSco2BpuCPtMwBKMTC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-05-19 at 16:38 +0200, Thomas Gleixner wrote:
> On Wed, 19 May 2010, Darren Hart wrote:
>=20
> > On 05/18/2010 06:25 PM, Michael Ellerman wrote:
> > > On Tue, 2010-05-18 at 15:22 -0700, Darren Hart wrote:
> > > > On 05/18/2010 02:52 PM, Brian King wrote:
> > > > > Is IRQF_NODELAY something specific to the RT kernel? I don't see =
it in
> > > > > mainline...
> > > >=20
> > > > Yes, it basically says "don't make this handler threaded".
> > >=20
> > > That is a good fix for EHEA, but the threaded handling is still broke=
n
> > > for anything else that is edge triggered isn't it?
> >=20
> > No, I don't believe so. Edge triggered interrupts that are reported as =
edge
> > triggered interrupts will use the edge handler (which was the approach
> > Sebastien took to make this work back in 2008). Since XICS presents all
> > interrupts as Level Triggered, they use the fasteoi path.
>=20
> I wonder whether the XICS interrupts which are edge type can be
> identified from the irq_desc->flags. Then we could avoid the masking
> for those in the fasteoi_handler in general.

I'm not sure they can be. I know on other similar HW we can detect LSI
vs MSI, but that's without the HV in the equation.

> > > The result of the discussion about two years ago on this was that we
> > > needed a custom flow handler for XICS on RT.
> >=20
> > I'm still not clear on why the ultimate solution wasn't to have XICS re=
port
> > edge triggered as edge triggered. Probably some complexity of the entir=
e power
> > stack that I am ignorant of.
> >=20
> > > Apart from the issue of loosing interrupts there is also the fact tha=
t
> > > masking on the XICS requires an RTAS call which takes a global lock.
>=20
> Right, I'd love to avoid that but with real level interrupts we'd run
> into an interrupt storm. Though another solution would be to issue the
> EOI after the threaded handler finished, that'd work as well, but
> needs testing.

Yeah I think that was the idea for the custom flow handler. We'd reset
the processor priority so we can take other interrupts (which the EOI
usually does for you), then do the actual EOI after the handler
finished.

cheers

--=-slUSco2BpuCPtMwBKMTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkv0kRUACgkQdSjSd0sB4dIB8QCgiaybf0jdeIpZ9IYaeiAWREZV
2fUAn2sBE0D4V7qx5GJ25UIDoJS0kH+L
=zKlQ
-----END PGP SIGNATURE-----

--=-slUSco2BpuCPtMwBKMTC--

