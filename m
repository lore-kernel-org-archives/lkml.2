Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2C1Isc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:48:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46201 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2C1Isb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:48:31 -0400
Date: Wed, 28 Mar 2012 10:48:24 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 11/13] Add a discussion on why spin_is_locked() is bad
 to spinlocks.txt
Message-ID: <20120328084824.GA2522@pengutronix.de>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
 <1332895637-32572-12-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1332895637-32572-12-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 27, 2012 at 05:47:15PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/spinlocks.txt |   43 +++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
>=20
> diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
> index 9dbe885..1787229 100644
> --- a/Documentation/spinlocks.txt
> +++ b/Documentation/spinlocks.txt
> @@ -146,6 +146,49 @@ indeed), while write-locks need to protect themselve=
s against interrupts.
> =20
>  ----
> =20
> +spin_is_locked is a bad idea
> +
> +spin_is_locked checks if a lock is currently hold.  On uniprocessor kern=
els
> +it always returns 0. In general this function should be avoided because =
most=20
> +uses of it are either redundant or broken.
> +
> +People often use spin_is_locked() to check if a particular lock is hold =
when a function
> +is called to enforce a locking discipline, like
> +
> +	WARN_ON(!spin_is_locked(!my_lock))
> +
> +or=20
> +
> +	BUG_ON(!spin_is_locked(!my_lock))

'&my_lock' instead of '!my_lock' probably.

> +
> +or some variant of those.
> +
> +This does not work on uniprocessor kernels because they will always fail.
> +While there are ways around that they are ugly and not recommended.
> +Better use lockdep_assert_held(). This also only checks on a lock debugg=
ing
> +kernel (which you should occasionally run on your code anyways because
> +it catches many more problems).=20
> +
> +In generally this would be better done with static annotation anyways=20
> +(there's some support for it in sparse)
> +
> +	BUG_ON(spin_is_locked(obj->lock));
> +	kfree(obj);
> +
> +Another usage is checking whether a lock is not hold when freeing an obj=
ect.

I'd suggest to move this sentence above the code example. On first read,
I was confused what the code should tell me regarding annotations :)

> +However this is redundant because lock debugging supports this anyways
> +without explicit code. Just delete the BUG_ON.
> +
> +A third usage is to check in a console function if a lock is hold, to get
> +a panic crash dump out even when some other thread died in it.
> +This is better implemented with spin_try_lock() et.al. and a timeout.
> +
> +Other usages are usually simply races.
> +
> +In summary just don't use it.

At this point, I was wondering when it actually can be used? Otherwise
it probably would have been removed from the kernel or marked
deprecated, I'd think?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9y0FgACgkQD27XaX1/VRupkwCghNrXH0RCHftjPOyIvm85fDl5
ZBwAn1fpTD17/kC/AMaZuo4bgKTKWT8h
=ot1W
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
