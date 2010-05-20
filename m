Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0ETB2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:28:39 -0400
Received: from ozlabs.org ([203.10.76.45]:42405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab0ETB2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:28:38 -0400
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded
 (IRQF_NODELAY)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
       niv@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       Doug Maxey <doug.maxey@us.ibm.com>, linuxppc-dev@lists.ozlabs.org,
       Milton Miller <miltonm@bga.com>
In-Reply-To: <4BF3F2DB.7030701@us.ibm.com>
References: <4BF30793.5070300@us.ibm.com>
	 <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>
	 <1274232324.29980.9.camel@concordia>  <4BF3F2DB.7030701@us.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rZP5bf+tIaO2xBY2bClr"
Date: Thu, 20 May 2010 11:28:36 +1000
Message-ID: <1274318916.22892.35.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rZP5bf+tIaO2xBY2bClr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-05-19 at 07:16 -0700, Darren Hart wrote:
> On 05/18/2010 06:25 PM, Michael Ellerman wrote:
> > On Tue, 2010-05-18 at 15:22 -0700, Darren Hart wrote:
> >> On 05/18/2010 02:52 PM, Brian King wrote:
> >>> Is IRQF_NODELAY something specific to the RT kernel? I don't see it i=
n mainline...
> >>
> >> Yes, it basically says "don't make this handler threaded".
> >
> > That is a good fix for EHEA, but the threaded handling is still broken
> > for anything else that is edge triggered isn't it?
>=20
> No, I don't believe so. Edge triggered interrupts that are reported as=20
> edge triggered interrupts will use the edge handler (which was the=20
> approach Sebastien took to make this work back in 2008). Since XICS=20
> presents all interrupts as Level Triggered, they use the fasteoi path.

But that's the point, no interrupts on XICS are reported as edge, even
if they are actually edge somewhere deep in the hardware. I don't think
we have any reliable way to determine what is what.

> > The result of the discussion about two years ago on this was that we
> > needed a custom flow handler for XICS on RT.
>=20
> I'm still not clear on why the ultimate solution wasn't to have XICS=20
> report edge triggered as edge triggered. Probably some complexity of the=20
> entire power stack that I am ignorant of.

I'm not really sure either, but I think it's a case of a leaky
abstraction on the part of the hypervisor. Edge interrupts behave as
level as long as you handle the irq before EOI, but if you mask they
don't. But Milton's the expert on that.

> > Apart from the issue of loosing interrupts there is also the fact that
> > masking on the XICS requires an RTAS call which takes a global lock.
>=20
> Right, one of may reasons why we felt this was the right fix. The other=20
> is that there is no real additional overhead in running this as=20
> non-threaded since the receive handler is so short (just napi_schedule())=
.

True. It's not a fix in general though. I'm worried that we're going to
see the exact same bug for MSI(-X) interrupts.

cheers



--=-rZP5bf+tIaO2xBY2bClr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkv0kEAACgkQdSjSd0sB4dIF2QCcCAoeORbwsKzwzxOVUBfaIIT6
figAn0n5mFqrMbAliS0Y3RsBEPRhSReQ
=neam
-----END PGP SIGNATURE-----

--=-rZP5bf+tIaO2xBY2bClr--

