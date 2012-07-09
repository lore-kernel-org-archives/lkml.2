Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2GIXrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:47:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42229 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570Ab2GIXrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:47:16 -0400
Message-ID: <1341877626.25597.300.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 35/48] dummy: fix rcu_sched self-detected stalls
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 10 Jul 2012 00:47:06 +0100
In-Reply-To: <20120709233901.GB3237@herton-Z68MA-D2H-B3>
References: <20120709143116.348975190@decadent.org.uk>
	 <20120709143121.743971024@decadent.org.uk>
	 <20120709233901.GB3237@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DYUGd0K2pdmldM01GYL7"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DYUGd0K2pdmldM01GYL7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-09 at 20:39 -0300, Herton Ronaldo Krzesinski wrote:
> On Mon, Jul 09, 2012 at 03:31:51PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Eric Dumazet <edumazet@google.com>
> >=20
> > [ Upstream commit 16b0dc29c1af9df341428f4c49ada4f626258082 ]
> >=20
> > Trying to "modprobe dummy numdummies=3D30000" triggers :
> >=20
> > INFO: rcu_sched self-detected stall on CPU { 8} (t=3D60000 jiffies)
> >=20
> > After this splat, RTNL is locked and reboot is needed.
> >=20
> > We must call cond_resched() to avoid this, even holding RTNL.
> >=20
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/net/dummy.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
> > index eeac9ca..87e4632 100644
> > --- a/drivers/net/dummy.c
> > +++ b/drivers/net/dummy.c
> > @@ -186,8 +186,10 @@ static int __init dummy_init_module(void)
> >  	rtnl_lock();
> >  	err =3D __rtnl_link_register(&dummy_link_ops);
> > =20
> > -	for (i =3D 0; i < numdummies && !err; i++)
> > +	for (i =3D 0; i < numdummies && !err; i++) {
> >  		err =3D dummy_init_one();
> > +		cond_resched();
> > +	}
>=20
> Hi, I got the following build error with this applied to 3.2, on i386
> and arm builds:
>=20
> linux-stable/drivers/net/dummy.c: In function 'dummy_init_module':
> linux-stable/drivers/net/dummy.c:191:3: error: implicit declaration of fu=
nction 'cond_resched' [-Werror=3Dimplicit-function-declaration]
>=20
> This doesn't happen on mainline so far. Looking here on mainline, sched.h=
 is
> implicitly included through <linux/netdevice.h> ->
> <net/netprio_cgroup.h> -> <linux/cgroup.h> -> <linux/sched.h>
>=20
> But on 3.2 this doesn't happen, and build fails on i386 and arm. On
> x86_64 it works though since sched.h is pulled from netdevice.h ->
> ethtool.h -> compat.h if CONFIG_COMPAT is enabled.

I built on x86_64...

> May be the best solution is for the patch backported to 3.2, to include
> <linux/sched.h> also.
[...]

Not sure.  Really, it ought to be directly included from this file in
mainline as well rather than depending on that long chain of includes.
But it's not an important bug in mainline (yet) so perhaps we can treat
it as only required in stable.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-DYUGd0K2pdmldM01GYL7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/tteue/yOyVhhEJAQrVXBAAjYSGBym12ekS7pioc7TjgHb68ESAy2jk
xMbjMQ8CeiBA74+PkH8sXPKEsjFBcbhzPPBBaUfPIRk/bmbB/OjHOXlQithC0GoR
zXUlxneoT5UAIE5enQrFlJGcL9tIGtdF3pRJlO8uQmcZJs3vSCZXoLj0+hURsl36
L+0EYb2xqwQuQhA3L8kmxqqtl8ubgwP/v42oCpdpgbFaaqgOePOGie3RfDrrgXnG
Kitj9PL5dXTfIo6spfrkVOWP/4URvgB66LH5ZhOt9gtGpI74JCDw3rVk+Ja3J+om
9FNCoAHNjElsYtDWkPBNM06XFGVfpKzKuK2AggZS/dP7Gx1GZ65kITfO2kEhPxT+
wUyS6DMj2wPlw4H56/QzPIjjNJpZRAsZ0pHq3YooN38LACka2coz2+1Zx3rT5i6t
nc0PZT0UjIPSaDoYOBcOoXislFzY5rvg+6ztiXh2ECpC3IUf4PLisfRQcw2LKMDA
Cc4o9dolLLzdsPwHhwXulmoqBfB7EeeTJ5wqGJgDHV1vo3U91HCLDZeMAbEAwdOn
dJ7JZIKK7T9xUoWb7cyqLdmpNDtpSpzoI5ytK4OdE6JzUVntl5h2Bwdk6mHGsWiE
jrVNgUqK/fAaCgP1jwAu8PCDrTM7KgrYON5THAgAH5imic6fwPOOCTrFOHBkc/LE
TiFq9LRCUpM=
=nHIl
-----END PGP SIGNATURE-----

--=-DYUGd0K2pdmldM01GYL7--
