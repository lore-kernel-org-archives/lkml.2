Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab2JNXyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 19:54:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50653 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048Ab2JNXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 19:54:37 -0400
Message-ID: <1350258853.26833.31.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 097/120] rcu: Fix day-one dyntick-idle stall-warning bug
From: Ben Hutchings <ben@decadent.org.uk>
To: paulmck@linux.vnet.ibm.com
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Becky Bruce <bgillbruce@gmail.com>,
        Subodh Nijsure <snijsure@grid-net.com>, Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 15 Oct 2012 00:54:13 +0100
In-Reply-To: <20121014233249.GB3288@linux.vnet.ibm.com>
References: <20121011005825.364610894@linuxfoundation.org>
	 <20121011005844.760264316@linuxfoundation.org>
	 <1350080068.4832.35.camel@deadeye.wl.decadent.org.uk>
	 <20121014233249.GB3288@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NexKV/+CLU0n6WRlXxZ1"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NexKV/+CLU0n6WRlXxZ1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-10-14 at 16:32 -0700, Paul E. McKenney wrote:
> On Fri, Oct 12, 2012 at 11:14:28PM +0100, Ben Hutchings wrote:
> > On Thu, 2012-10-11 at 10:00 +0900, Greg Kroah-Hartman wrote:
> > > 3.4-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > >=20
> > > commit a10d206ef1a83121ab7430cb196e0376a7145b22 upstream.
> > [...]
> > > This commit therefore makes CPUs check more carefully before starting=
 a
> > > new grace period.  This new check relies on an array of tail pointers
> > > into each CPU's list of callbacks.  If the CPU is up to date on which
> > > grace periods have completed, it checks to see if any callbacks follo=
w
> > > the RCU_DONE_TAIL segment, otherwise it checks to see if any callback=
s
> > > follow the RCU_WAIT_TAIL segment.  The reason that this works is that
> > > the RCU_WAIT_TAIL segment will be promoted to the RCU_DONE_TAIL segme=
nt
> > > as soon as the CPU is officially notified that the old grace period
> > > has ended.
> > [...]
> > > --- a/kernel/rcutree.c
> > > +++ b/kernel/rcutree.c
> > > @@ -295,7 +295,9 @@ cpu_has_callbacks_ready_to_invoke(struct
> > >  static int
> > >  cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
> > >  {
> > > -	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
> > > +	return *rdp->nxttail[RCU_DONE_TAIL +
> > > +			     ACCESS_ONCE(rsp->completed) !=3D rdp->completed] &&
> >=20
> > This is a very obscurely written expression.  The array index is parsed
> > as:
> > 	(RCU_DONE_TAIL + ACCESS_ONCE(rsp->completed)) !=3D rdp->completed
> >=20
> > Since RCU_DONE_TAIL =3D=3D 0 and RCU_WAIT_TAIL =3D=3D 1, this is then e=
quivalent
> > to:
> > 	ACCESS_ONCE(rsp->completed) !=3D rdp->completed
> > or:
> > 	(ACCESS_ONCE(rsp->completed) !=3D rdp->completed) ? RCU_WAIT_TAIL : RC=
U_DONE_TAIL
> >=20
> > But whyever didn't you write that explicitly?
>=20
> Because the way I think of it is the way that I wrote it -- you should
> look at the value of the first pointer unless this CPU isn't up to date
> with the latest grace period, in which case you need to go one step
> farther up the array of tail pointers.

That is not the way you wrote it, since + has higher precedence than !=3D.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-NexKV/+CLU0n6WRlXxZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHtQpee/yOyVhhEJAQqwDw//RZvLn/GmTodBnogrdYnNmRWmgX+kDsi1
5wborK5ANWeXM/MBttVTmh7RZj8heY69PBFrgsT1TJWaxceSbI4nP4GiXm67GFtR
XdSiHbs6lvfpx+/lgtD2V74GIhYSF16A1PZLmW+OrZ8SEOODNUFRBID/nYrGrBIS
W/dYspCwnkUT32qefuLfshGUYleNExd7bFIm+HaTRllCXn+ZA6p6vNtQBTYlG9Dr
lmpLEqzDoNcYQ1YNdJ7cD4Fwsr0UwemyrPcA38NAZxga0QLJKzlApnFLIsM70sKt
fUsZnlzMX3W0DFTUujYbPGMFFZx5Sgg7lKJNwh/HIj+EsnF5SxTW7k/JYXe4DH/y
k68qSHpaAQ9FLI6EEQ5xGiBzyNvhllliWlBJViW5zPfhJaBzKfl+4/K6x9fV09je
CXfpppjH+cg2e75EB0VO3eE1oIVRis1yBcUwy6H4PycqhF8/O2ah/Xumtqq9lSi9
c1721u9NDWKSL3EVkMxOFzyFjRwTdABiEX0S9vpL3eVk4BmtuNdyBr6VF36nWIBl
2K/xaRrPnInPJ++wox1caZzkejAH5ZTxzPnw+1NUoTF6VbCCe0aR3cm9JsbauXmD
NxPwF1u0TDHbgOKlY6ofqq5pegvOaokz3kz1IxM6R6MzdeJwWmnGkWPH8Dt+QD8Y
MgkWZXTMJpo=
=QtoJ
-----END PGP SIGNATURE-----

--=-NexKV/+CLU0n6WRlXxZ1--
