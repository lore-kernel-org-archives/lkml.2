Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2LOTks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 14:40:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47450 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338Ab2LOTkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 14:40:47 -0500
Message-ID: <1355600433.18807.22.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 139/241] block: Don't access request after it might be
 freed
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Roland Dreier <roland@purestorage.com>
Date: Sat, 15 Dec 2012 19:40:33 +0000
In-Reply-To: <1355407206-17100-140-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-140-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PexkVFTUU/PcbG4C9/FE"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PexkVFTUU/PcbG4C9/FE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Roland Dreier <roland@purestorage.com>
>=20
> commit 893d290f1d7496db97c9471bc352ad4a11dc8a25 upstream.
>=20
> After we've done __elv_add_request() and __blk_run_queue() in
> blk_execute_rq_nowait(), the request might finish and be freed
> immediately.  Therefore checking if the type is REQ_TYPE_PM_RESUME
> isn't safe afterwards, because if it isn't, rq might be gone.
> Instead, check beforehand and stash the result in a temporary.
>=20
> This fixes crashes in blk_execute_rq_nowait() I get occasionally when
> running with lots of memory debugging options enabled -- I think this
> race is usually harmless because the window for rq to be reallocated
> is so small.
>=20
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [ herton: adjust context ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>

This is missing from 3.{0,4} but I did apply it to 3.2, again with the
need to adjust context.

Perhaps the intermediate fixes to blk_execute_rq_nowait() that resulted
in the changed context should also be applied to stable updates.  The
fixes in question are:

8ba61435d73f block: add missing blk_queue_dead() checks
- applied in 3.3; missing from 3.{0,2}.y
e81ca6fe85b7 [SCSI] block: Fix blk_execute_rq_nowait() dead queue handling
- applied in 3.6; missing from 3.{0,2,4,5}.y
893d290f1d74 block: Don't access request after it might be freed
- applied in 3.7, then to 3.{2,6}.y; missing from 3.{0,4}.y

Jens?

Ben.
> ---
>  block/blk-exec.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index fb2cbd5..9925fbe 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -49,8 +49,16 @@ void blk_execute_rq_nowait(struct request_queue *q, st=
ruct gendisk *bd_disk,
>  			   rq_end_io_fn *done)
>  {
>  	int where =3D at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
> +	bool is_pm_resume;
> =20
>  	WARN_ON(irqs_disabled());
> +
> +	/*
> +	 * need to check this before __blk_run_queue(), because rq can
> +	 * be freed before that returns.
> +	 */
> +	is_pm_resume =3D rq->cmd_type =3D=3D REQ_TYPE_PM_RESUME;
> +
>  	spin_lock_irq(q->queue_lock);
> =20
>  	if (unlikely(blk_queue_dead(q))) {
> @@ -66,7 +74,7 @@ void blk_execute_rq_nowait(struct request_queue *q, str=
uct gendisk *bd_disk,
>  	__elv_add_request(q, rq, where);
>  	__blk_run_queue(q);
>  	/* the queue is stopped so it won't be run */
> -	if (rq->cmd_type =3D=3D REQ_TYPE_PM_RESUME)
> +	if (is_pm_resume)
>  		q->request_fn(q);
>  	spin_unlock_irq(q->queue_lock);
>  }

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-PexkVFTUU/PcbG4C9/FE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMzSMee/yOyVhhEJAQrLThAAzdFQwkXymYhvA/L9EJdeABl5zn20ghM+
62BKPcIx7iu5vLiFg7fUg+fglg/NUeumh3NW7PgxE/FBtd0f+YprI4+DeMW/p4DG
NSm2jtY5oAAW++Bo/Oc+vMzn/0AglB7ZErrHnv2Qk8pPUev1kp/8BsJiOXjzQTkZ
OfqU/J4IzPx4hFon0AG7paICb+3Hw4ebGcoV+9ITxj/CwL49LgVqA6tw+NgLqQNO
7R/cO3xmcnT5WXgCTDE1MbGyeeulUvrYBIjyl3emS6L4D7wfdgrt3l+ootn/+T/P
jOs5qwRAtofqCCEPEchBLeVyLnE1lxO/RI5a/ASSINjGpppLU0lwvlOCS11/p5r4
YuagBDz9KrgcJ9ckaaQ4JS8rPQNcthrnNjM8Qn6l4KyOMHtTbWk7gxV/krZjBTcz
Qh0fABacRyBOvII+OnEG/CAvwpMzbQUDC3r9Igw6AUzQ72dnVmqQvKo4k2lV3fpZ
gzASZIBakslpbO+cWvE91mU5LadDt8U+bnAre9vryqoGnXp3vH0vf+i1P9l/5qiB
X3Z1325rKYo+CAJZrpow+j6V4xjOT7bnoj7TOvguaxxEuPMPT4CxXKbREasRE/bF
hCmTIuLyyFwj/tWj7DQv6PoJIKv/u4YP69X9FctEyBvv22eWszXmNQZDhMoCYUem
ikzJk7+dy88=
=Rdt9
-----END PGP SIGNATURE-----

--=-PexkVFTUU/PcbG4C9/FE--
