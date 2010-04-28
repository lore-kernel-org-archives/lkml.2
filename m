Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab0D1HMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:12:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46518 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab0D1HMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:12:15 -0400
Date: Wed, 28 Apr 2010 17:12:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] lockdep: Fix redundant_hardirqs_on incremented with
 irqs enabled
Message-Id: <20100428171206.5529a549.sfr@canb.auug.org.au>
In-Reply-To: <1271338670-4537-1-git-send-regression-fweisbec@gmail.com>
References: <20100415200414.1ef705c8.sfr@canb.auug.org.au>
	<1271338670-4537-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Apr_2010_17_12_06_+1000_Wb0Bl8Gb7XK0q2mm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Apr_2010_17_12_06_+1000_Wb0Bl8Gb7XK0q2mm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Thu, 15 Apr 2010 15:37:50 +0200 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> When a path restore the flags while irqs are already enabled, we
> update the per cpu var redundant_hardirqs_on in a racy fashion
> and debug_atomic_inc() warns about this situation.
>=20
> In this particular case, we need to explictly disable the irqs before
> updating this stat var in order to update it safely.
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  kernel/lockdep.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 78325f8..65d4336 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2298,7 +2298,11 @@ void trace_hardirqs_on_caller(unsigned long ip)
>  		return;
> =20
>  	if (unlikely(curr->hardirqs_enabled)) {
> +		unsigned long flags;
> +
> +		raw_local_irq_save(flags);
>  		debug_atomic_inc(redundant_hardirqs_on);
> +		raw_local_irq_restore(flags);
>  		return;
>  	}
>  	/* we'll do an OFF -> ON transition: */

I applied this patch to linux-next today and it fixes my PowerPC boot
problems, so I will keep it in linux-next until it gets applied to the
tip tree or something better comes along.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Apr_2010_17_12_06_+1000_Wb0Bl8Gb7XK0q2mm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvX38YACgkQjjKRsyhoI8wIWgCdGXuyt9HC0OC89P2Lkv/W4cue
pOUAnjFPV9o6uhpbe3wQjxNuk/UqqmeB
=VOnM
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Apr_2010_17_12_06_+1000_Wb0Bl8Gb7XK0q2mm--
