Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2AKIJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:09:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab2AKIJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:09:04 -0500
Date: Wed, 11 Jan 2012 19:08:50 +1100
From: NeilBrown <neilb@suse.de>
To: <b29237@freescale.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>
Subject: Re: [PATCH][RFC]      RAID5/DMA/memcpy: zero copy the bio page when
 possible
Message-ID: <20120111190850.06b28e32@notabene.brown>
In-Reply-To: <1326268054-26996-1-git-send-email-b29237@freescale.com>
References: <1326268054-26996-1-git-send-email-b29237@freescale.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WrX7srjyL7zzvXMqaha_SI9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WrX7srjyL7zzvXMqaha_SI9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jan 2012 15:47:34 +0800 <b29237@freescale.com> wrote:

> From: Forrest shi <b29237@freescale.com>
>=20
>      each disk holds one page in the stripe header, the page works as a
>      buffer cache for raid computing and it is copied to and from bio page
>      which requested by upper level read/write call.
>=20
>      if the write access would overwrite the whole page, the copy from
>      bio page to stripe header page could be avoid. We can do xor directly
>      on the bio page.
>=20
>      this patch implements this strategy and improves raid5 write perform=
ance.

I was hoping for a free more words...

The "PageConstant" thing seems to be an important part of the strategy -
explaining that wouldn't hurt.

I don't think the code is right (but I might have misunderstood due to lack
of documentation....)

The page that you xor into the parity block must remain constant until the
write completes else you have an inconsistent stripe.

Your 'PageConstant' doesn't seem to keep the page constant, but just checks
afterwards if it has changed.

And then it does SetPageUptodate which looks like a serious layering
violation.

i.e. I think this patch is wrong at a fairly deep level.  If you still think
it is right, you need to put more effort into explaining why.

NeilBrown


>=20
>      Signed-off-by: Forrest Shi<b29237@freescale.com>
> ---
>  drivers/dma/Kconfig        |    8 +++
>  drivers/md/raid5.c         |  125 ++++++++++++++++++++++++++++++++++++++=
-----
>  drivers/md/raid5.h         |    6 ++
>  include/linux/page-flags.h |   11 ++++
>  mm/filemap.c               |   21 +++++++
>  5 files changed, 156 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index dd8e959..28f960b 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -280,6 +280,14 @@ config ASYNC_TX_DMA
> =20
>  	  If unsure, say N.
> =20
> +config RAID_ZERO_COPY=20
> +        bool "Optimized DMA/XOR offload: reduce raid5 memcpy which offlo=
aded for dma"
> +        depends on ASYNC_TX_DMA
> +        help
> +          This allows the async_tx api try to reduce raid5 memcpy operat=
ions for
> +          dma. If you have dma device to support memcpy offloading, you =
can set
> +          it as Y, else N.
> +
>  config DMATEST
>  	tristate "DMA Test client"
>  	depends on DMA_ENGINE
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cbb50d3..33afeeb 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3,7 +3,8 @@
>   *	   Copyright (C) 1996, 1997 Ingo Molnar, Miguel de Icaza, Gadi Oxman
>   *	   Copyright (C) 1999, 2000 Ingo Molnar
>   *	   Copyright (C) 2002, 2003 H. Peter Anvin
> - *
> + *	   Copyright (C) 2010, Freescale Semiconductor, Inc. All rights
> + *		reserved.
>   * RAID-4/5/6 management functions.
>   * Thanks to Penguin Computing for making the RAID-6 development possible
>   * by donating a test server!
> @@ -558,6 +559,14 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>  				set_bit(STRIPE_DEGRADED, &sh->state);
>  			pr_debug("skip op %ld on disc %d for sector %llu\n",
>  				bi->bi_rw, i, (unsigned long long)sh->sector);
> +#ifdef CONFIG_RAID_ZERO_COPY
> +			if (test_bit(R5_DirectAccess, &sh->dev[i].flags)) {
> +				struct page *pg =3D sh->dev[i].page;
> +				BUG_ON(sh->dev[i].req.bi_io_vec[0].bv_page =3D=3D
> +					pg);
> +				sh->dev[i].req.bi_io_vec[0].bv_page =3D pg;
> +			}
> +#endif
>  			clear_bit(R5_LOCKED, &sh->dev[i].flags);
>  			set_bit(STRIPE_HANDLE, &sh->state);
>  		}
> @@ -685,6 +694,7 @@ static void ops_run_biofill(struct stripe_head *sh)
>  			dev->read =3D rbi =3D dev->toread;
>  			dev->toread =3D NULL;
>  			spin_unlock_irq(&conf->device_lock);
> +
>  			while (rbi && rbi->bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
>  				tx =3D async_copy_data(0, rbi, dev->page,
> @@ -754,10 +764,17 @@ ops_run_compute5(struct stripe_head *sh, struct rai=
d5_percpu *percpu)
>  		__func__, (unsigned long long)sh->sector, target);
>  	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
> =20
> -	for (i =3D disks; i--; )
> -		if (i !=3D target)
> -			xor_srcs[count++] =3D sh->dev[i].page;
> -
> +	for (i =3D disks; i--; ) {
> +		struct r5dev *dev =3D &sh->dev[i];
> +		struct page *pg =3D dev->page;
> +		if (i !=3D target) {
> +#ifdef CONFIG_RAID_ZERO_COPY
> +			if (test_bit(R5_DirectAccess, &dev->flags))
> +				pg =3D dev->req.bi_io_vec[0].bv_page;
> +#endif
> +			xor_srcs[count++] =3D pg;
> +		}
> +	}
>  	atomic_inc(&sh->count);
> =20
>  	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
> @@ -993,8 +1010,14 @@ ops_run_prexor(struct stripe_head *sh, struct raid5=
_percpu *percpu,
>  	for (i =3D disks; i--; ) {
>  		struct r5dev *dev =3D &sh->dev[i];
>  		/* Only process blocks that are known to be uptodate */
> -		if (test_bit(R5_Wantdrain, &dev->flags))
> -			xor_srcs[count++] =3D dev->page;
> +		if (test_bit(R5_Wantdrain, &dev->flags)) {
> +			struct page *pg =3D dev->page;
> +#ifdef CONFIG_RAID_ZERO_COPY
> +			if (test_bit(R5_DirectAccess, &dev->flags))
> +				pg =3D dev->req.bi_io_vec[0].bv_page;
> +#endif
> +			xor_srcs[count++] =3D pg;
> +		}
>  	}
> =20
>  	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
> @@ -1004,6 +1027,32 @@ ops_run_prexor(struct stripe_head *sh, struct raid=
5_percpu *percpu,
>  	return tx;
>  }
> =20
> +#ifdef CONFIG_RAID_ZERO_COPY
> +static struct page *raid5_zero_copy(struct bio *bio, sector_t sector)
> +{
> +	sector_t bi_sector =3D bio->bi_sector;
> +	struct page *page =3D NULL;
> +	struct bio_vec *bv;
> +	int i;
> +
> +	bio_for_each_segment(bv, bio, i) {
> +		if (sector =3D=3D bi_sector)
> +			page =3D bio_iovec_idx(bio, i)->bv_page;
> +
> +		bi_sector +=3D bio_iovec_idx(bio, i)->bv_len >> 9;
> +		if (bi_sector >=3D sector + STRIPE_SECTORS) {
> +			/* check if the stripe is covered by one page */
> +			if (page =3D=3D bio_iovec_idx(bio, i)->bv_page) {
> +				SetPageConstant(page);
> +				return page;
> +			}
> +			return NULL;
> +		}
> +	}
> +	return NULL;
> +}
> +#endif
> +
>  static struct dma_async_tx_descriptor *
>  ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor =
*tx)
>  {
> @@ -1025,8 +1074,28 @@ ops_run_biodrain(struct stripe_head *sh, struct dm=
a_async_tx_descriptor *tx)
>  			dev->towrite =3D NULL;
>  			BUG_ON(dev->written);
>  			wbi =3D dev->written =3D chosen;
> +#ifdef CONFIG_RAID_ZERO_COPY
> +			set_bit(R5_LOCKED, &dev->flags);
> +			BUG_ON(test_bit(R5_DirectAccess, &dev->flags));
>  			spin_unlock(&sh->lock);
> =20
> +			if (!wbi->bi_next && test_bit(R5_OVERWRITE, &dev->flags)
> +					&& test_bit(R5_Insync, &dev->flags)) {
> +				struct page *pg =3D raid5_zero_copy(wbi,
> +								dev->sector);
> +				if (pg) {
> +					dev->req.bi_io_vec[0].bv_page =3D pg;
> +					set_bit(R5_DirectAccess, &dev->flags);
> +					clear_bit(R5_UPTODATE, &dev->flags);
> +					clear_bit(R5_OVERWRITE, &dev->flags);
> +					continue;
> +				}
> +			}
> +			clear_bit(R5_OVERWRITE, &dev->flags);
> +			set_bit(R5_UPTODATE, &dev->flags);
> +#else
> +			spin_unlock(&sh->lock);
> +#endif
>  			while (wbi && wbi->bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
>  				if (wbi->bi_rw & REQ_FUA)
> @@ -1102,15 +1171,29 @@ ops_run_reconstruct5(struct stripe_head *sh, stru=
ct raid5_percpu *percpu,
>  		xor_dest =3D xor_srcs[count++] =3D sh->dev[pd_idx].page;
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
> -			if (dev->written)
> -				xor_srcs[count++] =3D dev->page;
> +			struct page *pg =3D dev->page;
> +
> +			if (dev->written) {
> +#ifdef CONFIG_RAID_ZERO_COPY
> +				if (test_bit(R5_DirectAccess, &dev->flags))
> +					pg =3D dev->req.bi_io_vec[0].bv_page;
> +#endif
> +				xor_srcs[count++] =3D pg;
> +			}
>  		}
>  	} else {
>  		xor_dest =3D sh->dev[pd_idx].page;
>  		for (i =3D disks; i--; ) {
>  			struct r5dev *dev =3D &sh->dev[i];
> -			if (i !=3D pd_idx)
> -				xor_srcs[count++] =3D dev->page;
> +			struct page *pg =3D dev->page;
> +
> +			if (i !=3D pd_idx) {
> +#ifdef CONFIG_RAID_ZERO_COPY
> +				if (test_bit(R5_DirectAccess, &dev->flags))
> +					pg =3D dev->req.bi_io_vec[0].bv_page;
> +#endif
> +				xor_srcs[count++] =3D pg;
> +			}
>  		}
>  	}
> =20
> @@ -1637,6 +1720,7 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  			md_error(conf->mddev, rdev);
>  		}
>  	}
> +
>  	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
>  	clear_bit(R5_LOCKED, &sh->dev[i].flags);
>  	set_bit(STRIPE_HANDLE, &sh->state);
> @@ -1666,15 +1750,19 @@ static void raid5_end_write_request(struct bio *b=
i, int error)
>  		md_error(conf->mddev, conf->disks[i].rdev);
> =20
>  	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
> -=09
> +#ifdef CONFIG_RAID_ZERO_COPY
> +	if (test_bit(R5_DirectAccess, &sh->dev[i].flags)) {
> +		BUG_ON(sh->dev[i].req.bi_io_vec[0].bv_page =3D=3D sh->dev[i].page);
> +		sh->dev[i].req.bi_io_vec[0].bv_page =3D sh->dev[i].page;
> +	}
> +#endif
>  	clear_bit(R5_LOCKED, &sh->dev[i].flags);
>  	set_bit(STRIPE_HANDLE, &sh->state);
>  	release_stripe(sh);
>  }
> =20
> -
>  static sector_t compute_blocknr(struct stripe_head *sh, int i, int previ=
ous);
> -=09
> +
>  static void raid5_build_block(struct stripe_head *sh, int i, int previou=
s)
>  {
>  	struct r5dev *dev =3D &sh->dev[i];
> @@ -2505,7 +2593,11 @@ static void handle_stripe_clean_event(raid5_conf_t=
 *conf,
>  		if (sh->dev[i].written) {
>  			dev =3D &sh->dev[i];
>  			if (!test_bit(R5_LOCKED, &dev->flags) &&
> -				test_bit(R5_UPTODATE, &dev->flags)) {
> +				(test_bit(R5_UPTODATE, &dev->flags)
> +#ifdef CONFIG_RAID_ZERO_COPY
> +				|| test_bit(R5_DirectAccess, &dev->flags)
> +#endif
> +			)) {
>  				/* We can return any write requests */
>  				struct bio *wbi, *wbi2;
>  				int bitmap_end =3D 0;
> @@ -2513,6 +2605,9 @@ static void handle_stripe_clean_event(raid5_conf_t =
*conf,
>  				spin_lock_irq(&conf->device_lock);
>  				wbi =3D dev->written;
>  				dev->written =3D NULL;
> +#ifdef CONFIG_RAID_ZERO_COPY
> +				clear_bit(R5_DirectAccess, &dev->flags);
> +#endif
>  				while (wbi && wbi->bi_sector <
>  					dev->sector + STRIPE_SECTORS) {
>  					wbi2 =3D r5_next_bio(wbi, dev->sector);
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 3ca77a2..b1db89f 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -276,6 +276,12 @@ struct r6_state {
>  				    */
>  #define R5_Wantdrain	13 /* dev->towrite needs to be drained */
>  #define R5_WantFUA	14	/* Write should be FUA */
> +
> +#ifdef CONFIG_RAID_ZERO_COPY
> +#define R5_DirectAccess 15 /* access cached pages directly instead of
> +                                       * sh pages */
> +#endif
> +
>  /*
>   * Write method
>   */
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 6081493..fc74541 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -104,6 +104,9 @@ enum pageflags {
>  #ifdef CONFIG_MEMORY_FAILURE
>  	PG_hwpoison,		/* hardware poisoned page. Don't touch */
>  #endif
> +#ifdef CONFIG_RAID_ZERO_COPY
> +        PG_constant,            /* const page not modified during raid5 =
io */
> +#endif
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	PG_compound_lock,
>  #endif
> @@ -196,6 +199,14 @@ static inline int __TestClearPage##uname(struct page=
 *page) { return 0; }
> =20
>  struct page;	/* forward declaration */
> =20
> +#ifdef CONFIG_RAID_ZERO_COPY
> +#define PageConstant(page) test_bit(PG_constant, &(page)->flags)
> +#define SetPageConstant(page) set_bit(PG_constant, &(page)->flags)
> +#define ClearPageConstant(page) clear_bit(PG_constant, &(page->flags))
> +#define TestSetPageConstant(page) test_and_set_bit(PG_constant, &(page)-=
>flags)
> +extern void clear_page_constant(struct page *page);
> +#endif
> +
>  TESTPAGEFLAG(Locked, locked)
>  PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
>  PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a8251a8..5052b72 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -28,6 +28,11 @@
>  #include <linux/backing-dev.h>
>  #include <linux/pagevec.h>
>  #include <linux/blkdev.h>
> +
> +#ifdef CONFIG_RAID_ZERO_COPY
> +#include <linux/rmap.h>
> +#endif
> +
>  #include <linux/security.h>
>  #include <linux/syscalls.h>
>  #include <linux/cpuset.h>
> @@ -636,10 +641,26 @@ void end_page_writeback(struct page *page)
>  		BUG();
> =20
>  	smp_mb__after_clear_bit();
> +
> +#ifdef CONFIG_RAID_ZERO_COPY
> +	clear_page_constant(page);
> +#endif
> +
>  	wake_up_page(page, PG_writeback);
>  }
>  EXPORT_SYMBOL(end_page_writeback);
> =20
> +#ifdef CONFIG_RAID_ZERO_COPY
> +void clear_page_constant(struct page *page)
> +{
> +	if (PageConstant(page)) {
> +		ClearPageConstant(page);
> +		SetPageUptodate(page);
> +	}
> +}
> +EXPORT_SYMBOL(clear_page_constant);
> +#endif
> +
>  /**
>   * __lock_page - get a lock on the page, assuming we need to sleep to ge=
t it
>   * @page: the page to lock


--Sig_/WrX7srjyL7zzvXMqaha_SI9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTw1Dkjnsnt1WYoG5AQLhLhAAn+qejgLAjyhd1htzdKYOAMHLaseD6Gx6
vAAkAbT0j1mxwQfa3PiTO1OnUygVikWvV1FAnPUNmNzXG2iv5AJsuAGhyFXCbbR3
AbehVMpSoF03Gv53NBvoEGeE3KXld3K2vEDsxB2dxeUyn2gkaGbLQqmrsXSIxEDb
/jEyOI0HO9BEsgMk/bnBeYYtiNzt77smfXEGfmgYDKu5HaE9rBq5tvcQ/eQeijIR
95JM/RDy1YT/ckzOBzUMWRjGAAIsE27wzna0fip98NenpJo7m8/4OFjXomOppu1x
Qw+H9xJcTGRlhg70u7g7R7d02kfkJrYZGqUDPgFxQ2MlIcA2Dyr9zD4Kcwbb51xb
+RorVzt1D7Dw2Wji7Si0inlpnO4A9rEgR2ukvDeqLYaYqTbs75SrL9FE931hpxjX
XodlWyUUGdXfal5kIaIUdxd5iCMsxtTEFMP9JVGN3jiiXBNARUPbpAQYt2xO8Ma4
jSyZCLGx+j0QjYXJJEXrJW7Do0o1ium/k8AzUlXTr10p/6NF2Sf4YAxVOBMLQyCh
tBMOfW3oKSWqYGmZs1yu1CgagTfogeChm74w5IhCH3vaKucPeMua4Qlqt9Tzniyj
bWFaJUPnXlGnBfa4R6Vsxg4sx+7aRo12si+NJUX6QirdHLHL6g4cHCS7X4LSRbcT
5lMa/dMDbeA=
=rC0H
-----END PGP SIGNATURE-----

--Sig_/WrX7srjyL7zzvXMqaha_SI9--
