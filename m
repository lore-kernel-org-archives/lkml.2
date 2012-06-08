Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab2FHCaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:30:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab2FHCaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:30:11 -0400
Date: Fri, 8 Jun 2012 12:29:54 +1000
From: NeilBrown <neilb@suse.de>
To: Tao Guo <glorioustao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tao Guo <Tao.Guo@emc.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH V2] umem: fix up unplugging
Message-ID: <20120608122954.2fabc5e0@notabene.brown>
In-Reply-To: <1339088835-2614-1-git-send-email-glorioustao@gmail.com>
References: <1339088835-2614-1-git-send-email-glorioustao@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vU6kfyviDxB0yAO7x9I+UyD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vU6kfyviDxB0yAO7x9I+UyD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  7 Jun 2012 13:07:15 -0400 Tao Guo <glorioustao@gmail.com> wrote:

> Fix a regression introduced by 7eaceaccab5f40 ("block: remove per-queue
> plugging").  In that patch, Jens removed the whole mm_unplug_device()
> function, which used to be the trigger to make umem start to work.
>=20
> We need to implement unplugging to make umem start to work, or I/O will
> never be triggered.
>=20
> Signed-off-by: Tao Guo <Tao.Guo@emc.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: <stable@vger.kernel.org>

This is certainly a simpler patch that the first 2 and that it important if
it is heading for 3.4.y.
It looks like it will do what it should so assuming you have tested it (whi=
ch
I'm sure you have)

  Acked-by: NeilBrown <neilb@suse.de>

Longer term I think it does make sense to move some of this plugging code
into block/blk-XXX so that it can be shared by umem and md, and improved to
serve them both better.

In particular I think that the _check_plugged function should return the=20
struct xx_plug_cb structure (rather than 'true' or 'false') and the
make_request function should then link any new requests into that structure.
The unplug function can then activate that list of requests in whatever way
suits the particular device.
This will ensure that if separate threads are submitting requests at the sa=
me
time, they won't compete with each other, and an unplug on one thread won't
release the requests that are plugged by the other.

NeilBrown

> ---
>  drivers/block/umem.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/block/umem.c b/drivers/block/umem.c
> index aa27120..9a72277 100644
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -513,6 +513,44 @@ static void process_page(unsigned long data)
>  	}
>  }
> =20
> +struct mm_plug_cb {
> +	struct blk_plug_cb cb;
> +	struct cardinfo *card;
> +};
> +
> +static void mm_unplug(struct blk_plug_cb *cb)
> +{
> +	struct mm_plug_cb *mmcb =3D container_of(cb, struct mm_plug_cb, cb);
> +
> +	spin_lock_irq(&mmcb->card->lock);
> +	activate(mmcb->card);
> +	spin_unlock_irq(&mmcb->card->lock);
> +	kfree(mmcb);
> +}
> +
> +static int mm_check_plugged(struct cardinfo *card)
> +{
> +	struct blk_plug *plug =3D current->plug;
> +	struct mm_plug_cb *mmcb;
> +
> +	if (!plug)
> +		return 0;
> +
> +	list_for_each_entry(mmcb, &plug->cb_list, cb.list) {
> +		if (mmcb->cb.callback =3D=3D mm_unplug && mmcb->card =3D=3D card)
> +			return 1;
> +	}
> +	/* Not currently on the callback list */
> +	mmcb =3D kmalloc(sizeof(*mmcb), GFP_ATOMIC);
> +	if (!mmcb)
> +		return 0;
> +
> +	mmcb->card =3D card;
> +	mmcb->cb.callback =3D mm_unplug;
> +	list_add(&mmcb->cb.list, &plug->cb_list);
> +	return 1;
> +}
> +
>  static void mm_make_request(struct request_queue *q, struct bio *bio)
>  {
>  	struct cardinfo *card =3D q->queuedata;
> @@ -523,6 +561,8 @@ static void mm_make_request(struct request_queue *q, =
struct bio *bio)
>  	*card->biotail =3D bio;
>  	bio->bi_next =3D NULL;
>  	card->biotail =3D &bio->bi_next;
> +	if (bio->bi_rw & REQ_SYNC || !mm_check_plugged(card))
> +		activate(card);
>  	spin_unlock_irq(&card->lock);
> =20
>  	return;


--Sig_/vU6kfyviDxB0yAO7x9I+UyD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9Fjojnsnt1WYoG5AQJurxAAjF2U9HPKX4/ll8CpQBellyJs20R/f7dt
GFzxKQNDXtvJ4ED6BuhLQXlYzMtkmvUbkuyNs/JrMJj6WC0y3wFyhk6TFeIYoYiu
xzb8XVWp52nsYxFU1btCkWvuAwhTFaN4+JOCvVWPRFoAhCcvjgyBgAs0v/CnkIbn
dmX7QV5H1nf+d4FqPBaTBkYT0aXzw1snOkvHvI04Miem4RAwVYtpMNvL/T67cyp1
+n2hK1qf5nvSOZBlQAnfF9t3msuZBtGR0NXw8+xTHcg9u3F8v0oFjeMyzMCaVjK+
WaDKb45cp+jj5IP9eNUMuHPA5YB/KkvbyANWLr8gWDdGxY2udZvvl3MQJQ5o8DXU
35IU8y5wQUpFxOBwsyJ2yMFQ2XcI9y9YCLfDToBjB4+Vtk94xhXewfHIy3dZMPv+
3VHSMIf4olwAx7GS+5R4gt4K5eXgzKyfvFeEoWcS82GperneCZnVh6z1eupKcUyV
MpLGBtNiPA/NlyAcHnqzLCX16mrKWzp8h2oMkrvPiVPEdIojomq3qPk9ewOG/krH
31M1w4laQa3uZOo8ocLLIiqYuYhVxw5t6bTFhJae/yMAA1PrMMBTLhgX77FG1AVg
7SiSnlDT4ONNYMgT/bpdxWgUoDHpLuGVc9QB9FCRmbNG18ND7M5hF3FTRtoOZZGk
Y1zygnlcQsg=
=j9vM
-----END PGP SIGNATURE-----

--Sig_/vU6kfyviDxB0yAO7x9I+UyD--
