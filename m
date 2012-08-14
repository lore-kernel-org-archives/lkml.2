Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab2HNB41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:56:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44822 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700Ab2HNB40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:56:26 -0400
Message-ID: <1344909371.824.166.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH V2 02/18] Drivers: hv: Add KVP definitions for IP
 address injection
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Date: Tue, 14 Aug 2012 02:56:11 +0100
In-Reply-To: <20120814013815.GA29829@kroah.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
	 <1344877627-21779-1-git-send-email-kys@microsoft.com>
	 <1344877627-21779-2-git-send-email-kys@microsoft.com>
	 <20120814013815.GA29829@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nOqLldpvPLPKqwo4X5kf"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nOqLldpvPLPKqwo4X5kf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 18:38 -0700, Greg KH wrote:
> On Mon, Aug 13, 2012 at 10:06:51AM -0700, K. Y. Srinivasan wrote:
> > Add the necessary definitions for supporting the IP injection functiona=
lity.
[...]
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -122,12 +122,53 @@
> >  #define REG_U32 4
> >  #define REG_U64 8
> > =20
> > +/*
> > + * As we look at expanding the KVP functionality to include
> > + * IP injection functionality, we need to maintain binary
> > + * compatibility with older daemons.
> > + *
> > + * The KVP opcodes are defined by the host and it was unfortunate
> > + * that I chose to treat the registration operation as part of the
> > + * KVP operations defined by the host.
> > + * Here is the level of compatibility
> > + * (between the user level daemon and the kernel KVP driver) that we
> > + * will implement:
> > + *
> > + * An older daemon will always be supported on a newer driver.
> > + * A given user level daemon will require a minimal version of the
> > + * kernel driver.
> > + * If we cannot handle the version differences, we will fail gracefull=
y
> > + * (this can happen when we have a user level daemon that is more
> > + * advanced than the KVP driver.
> > + *
> > + * We will use values used in this handshake for determining if we hav=
e
> > + * workable user level daemon and the kernel driver. We begin by takin=
g the
> > + * registration opcode out of the KVP opcode namespace. We will howeve=
r,
> > + * maintain compatibility with the existing user-level daemon code.
> > + */
> > +
> > +/*
> > + * Daemon code not supporting IP injection (legacy daemon).
> > + */
> > +
> > +#define KVP_OP_REGISTER	4
>=20
> Huh?
>=20
> > +/*
> > + * Daemon code supporting IP injection.
> > + * The KVP opcode field is used to communicate the
> > + * registration information; so define a namespace that
> > + * will be distinct from the host defined KVP opcode.
> > + */
> > +
> > +#define KVP_OP_REGISTER1 100
> > +
> >  enum hv_kvp_exchg_op {
> >  	KVP_OP_GET =3D 0,
> >  	KVP_OP_SET,
> >  	KVP_OP_DELETE,
> >  	KVP_OP_ENUMERATE,
> > -	KVP_OP_REGISTER,
> > +	KVP_OP_GET_IP_INFO,
> > +	KVP_OP_SET_IP_INFO,
>=20
> So you overloaded the command and somehow think that is ok?  How is that
> supposed to work?  Why not just always keep it there, but fail if it is
> called as you know you have a mismatch?
>=20
> Otherwise, again, you just broke older tools on a newer kernel.
>=20
> Or am I missing something here?

You are.  The above enumeration is for the hypervisor-to-guest protocol,
whereas KVP_OP_REGISTER and KVP_OP_REGISTER1 are only used between
daemon and driver.  The registration operation code should have been
defined as a sufficiently high value to avoid collision.

However, since the daemon will always send one of the registration
operations at start of day (and then never again), it seems that the
driver can avoid confusing registration with a reply to
KVP_OP_GET_IP_INFO.  Instead, the two registration operation codes
distinguish the capabilities of the daemon and actually aid backward
compatibility.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-nOqLldpvPLPKqwo4X5kf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCmwO+e/yOyVhhEJAQouuQ/+IGne71bK2i5HiUaRwzJ8/UT2mztGuB43
mJoU877xohjYygx4ruP+rg8d5bk7ZcZfSj9IllsjVkd7MJqHYWd1gVqnLO4vNCvQ
h1UbpZRWYikLaKGRaId5qD1YmcKkdWQUYRiES8dJXZpjOh39nxLHNK97/LfUncgk
1RfeC3YkEXiCKzr+9y8YDS2KjSZtPpXayyYnolPBjwZ3kOHtjV3ZousRxiWlzk8z
ejf84kd/hYgkig5QgDrtIoLLp+dVMUejpIL6D+go2bqdCEJzoNGifWHE1siOb37f
cHC7FQ9ZsidNbaFMX7FytyXziYbelEzoDqY/wlF08PXmc+UXYFntS8kmFCNvLFw1
lAkK5DL4/lHW5t78ofWBTvIpdtTw+18x4tJ0C2RV1LyZck0Dq+AeqUb9pTuIVhJp
kkH3At5uWuBpsLNhIkGkxnAczKyyLHb+xiOm0ntm/lJDtudNCx5QmUq/tcr/H4/j
rEECn0GK1Xke/47j9Mhr/yA9BxeAVOTZW6nHOp18nNCixqbt5iwVyhGnpYKNBGJF
xbs2Lin6Wi7gX2IXDzAmi7rPLLTjKyExFi+XBKMCMHTGzuv9Lk5nc5jLVeElSPsn
5HpQLOY04V1me5vjyw/zaCP5pEKyZYb5pKf84PuTrKWUSAnfSi3K/JYKiy9fqyGU
Q76gWGL86wE=
=xqnS
-----END PGP SIGNATURE-----

--=-nOqLldpvPLPKqwo4X5kf--
