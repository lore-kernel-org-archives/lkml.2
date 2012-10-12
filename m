Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2JLWOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:14:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58619 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab2JLWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:14:43 -0400
Message-ID: <1350080068.4832.35.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 097/120] rcu: Fix day-one dyntick-idle stall-warning bug
From: Ben Hutchings <ben@decadent.org.uk>
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Becky Bruce <bgillbruce@gmail.com>,
        Subodh Nijsure <snijsure@grid-net.com>, Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 12 Oct 2012 23:14:28 +0100
In-Reply-To: <20121011005844.760264316@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
	 <20121011005844.760264316@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KjyrcXT/CXmc5Ovu85WI"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KjyrcXT/CXmc5Ovu85WI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-11 at 10:00 +0900, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
>=20
> commit a10d206ef1a83121ab7430cb196e0376a7145b22 upstream.
[...]
> This commit therefore makes CPUs check more carefully before starting a
> new grace period.  This new check relies on an array of tail pointers
> into each CPU's list of callbacks.  If the CPU is up to date on which
> grace periods have completed, it checks to see if any callbacks follow
> the RCU_DONE_TAIL segment, otherwise it checks to see if any callbacks
> follow the RCU_WAIT_TAIL segment.  The reason that this works is that
> the RCU_WAIT_TAIL segment will be promoted to the RCU_DONE_TAIL segment
> as soon as the CPU is officially notified that the old grace period
> has ended.
[...]
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -295,7 +295,9 @@ cpu_has_callbacks_ready_to_invoke(struct
>  static int
>  cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
>  {
> -	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
> +	return *rdp->nxttail[RCU_DONE_TAIL +
> +			     ACCESS_ONCE(rsp->completed) !=3D rdp->completed] &&

This is a very obscurely written expression.  The array index is parsed
as:
	(RCU_DONE_TAIL + ACCESS_ONCE(rsp->completed)) !=3D rdp->completed

Since RCU_DONE_TAIL =3D=3D 0 and RCU_WAIT_TAIL =3D=3D 1, this is then equiv=
alent
to:
	ACCESS_ONCE(rsp->completed) !=3D rdp->completed
or:
	(ACCESS_ONCE(rsp->completed) !=3D rdp->completed) ? RCU_WAIT_TAIL : RCU_DO=
NE_TAIL

But whyever didn't you write that explicitly?

Ben.

> +	       !rcu_gp_in_progress(rsp);
>  }
> =20
>  /*

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-KjyrcXT/CXmc5Ovu85WI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHiWROe/yOyVhhEJAQqr9BAAlgDrdQNkYhGdtEZInBd9m+j+UFYHtMez
pS2kgRRi17l1yADTiHd0JIewmmDYy8+iiPWpQJdnbTBF1dWFRGYU6Z1oRei6So6Y
An+pulD5P/9/EZ0WbfU6Rzgmf0W0qYej6z5EUGaUVRZKSFxJ3I+K9Yqnsn9zhVLv
wmX+doEbGoXZTgQGdojxlhlqbMvuKK+LzZd9mRdBeOV+VelZbpCwpSqnAr7VMlg6
ucBw55qgf8wbYMimZHrfkkT8eL6l+J3uo1RJIqzbHM4Lrs08Io9LuRgLVpph4DIV
Ne5N+vLB6nxn3o1iUmVE1+TuFvT79k0oyNxVHTj30nALxVdhTvF0+nb+l+3ZfUgB
/aIrEAzgaybvUT8eJYNfvoiinzk5CWy1qW02wsL2P4VYr9oj9sgta2R7pi7DaKUO
mWOizA5X+pFx71hyI0R68epaEH5CXNy7mYQSUFZXhh7gXqZ2zGZ/VUG5FztZzOhp
KnxI3KB/ykMCn44vqT2zcxHRBc4Pd7CQ4HB0FfeCP6Yi896KB/IpZH3Vqyx2WSXY
rkTD2O5DPkAKfWeCUR7xDCzCPv04Q4O2Zkzg/VhUQ+J/9XTQhdb8mbHlabeLjF8Q
inBC4pP+BUOrMkcTWltjq/4taMc4eH+3IigUTJ+GRJvoczZ7YkYpkBRij9wfSDjQ
vEzLOamY4Vc=
=IcR6
-----END PGP SIGNATURE-----

--=-KjyrcXT/CXmc5Ovu85WI--
