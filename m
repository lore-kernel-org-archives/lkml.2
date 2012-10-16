Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2JPEp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:45:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab2JPEp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:45:56 -0400
Date: Tue, 16 Oct 2012 15:45:59 +1100
From: NeilBrown <neilb@suse.de>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Cc: =?UTF-8?Q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 07/16] f2fs: add segment operations
Message-ID: <20121016154559.7d2a7eca@notabene.brown>
In-Reply-To: <1350054773.2299.54.camel@kjgkr>
References: <000e01cda2f1$13515dd0$39f41970$%kim@samsung.com>
	<20121011093707.2b95e4de@notabene.brown>
	<1350054773.2299.54.camel@kjgkr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pznYD/L740_Wq0TsvQkOL2E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pznYD/L740_Wq0TsvQkOL2E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Oct 2012 00:12:53 +0900 Jaegeuk Kim <jaegeuk.kim@gmail.com> wrot=
e:

> 2012-10-11 (=EB=AA=A9), 09:37 +1100, NeilBrown:
> > On Fri, 05 Oct 2012 21:00:55 +0900 =EA=B9=80=EC=9E=AC=EA=B7=B9 <jaegeuk=
.kim@samsung.com> wrote:
> >=20
> > > +/**
> > > + * Find a new segment from the free segments bitmap to right order
> > > + * This function should be returned with success, otherwise BUG
> > > + */
> > > +static void get_new_segment(struct f2fs_sb_info *sbi,
> > > +			unsigned int *newseg, bool new_sec, int dir)
> > > +{
> > > +	struct free_segmap_info *free_i =3D FREE_I(sbi);
> > > +	unsigned int total_secs =3D sbi->total_sections;
> > > +	unsigned int segno, secno, zoneno;
> > > +	unsigned int total_zones =3D sbi->total_sections / sbi->secs_per_zo=
ne;
> > > +	unsigned int hint =3D *newseg >> sbi->log_segs_per_sec;
> > > +	unsigned int old_zoneno =3D GET_ZONENO_FROM_SEGNO(sbi, *newseg);
> > > +	unsigned int left_start =3D hint;
> > > +	bool init =3D true;
> > > +	int go_left =3D 0;
> > > +	int i;
> > > +
> > > +	write_lock(&free_i->segmap_lock);
> > > +
> > > +	if (!new_sec && ((*newseg + 1) % sbi->segs_per_sec)) {
> > > +		segno =3D find_next_zero_bit(free_i->free_segmap,
> > > +					TOTAL_SEGS(sbi), *newseg + 1);
> > > +		if (segno < TOTAL_SEGS(sbi))
> > > +			goto got_it;
> > > +	}
> > > +find_other_zone:
> > > +	secno =3D find_next_zero_bit(free_i->free_secmap, total_secs, hint);
> > > +	if (secno >=3D total_secs) {
> > > +		if (dir =3D=3D ALLOC_RIGHT) {
> > > +			secno =3D find_next_zero_bit(free_i->free_secmap,
> > > +						total_secs, 0);
> > > +			BUG_ON(secno >=3D total_secs);
> > > +		} else {
> > > +			go_left =3D 1;
> > > +			left_start =3D hint - 1;
> > > +		}
> > > +	}
> > > +	if (go_left =3D=3D 0)
> > > +		goto skip_left;
> > > +
> > > +	while (test_bit(left_start, free_i->free_secmap)) {
> > > +		if (left_start > 0) {
> > > +			left_start--;
> > > +			continue;
> > > +		}
> > > +		left_start =3D find_next_zero_bit(free_i->free_secmap,
> > > +						total_secs, 0);
> > > +		BUG_ON(left_start >=3D total_secs);
> > > +		break;
> > > +	}
> > > +	secno =3D left_start;
> > > +skip_left:
> > > +	hint =3D secno;
> > > +	segno =3D secno << sbi->log_segs_per_sec;
> > > +	zoneno =3D secno / sbi->secs_per_zone;
> > > +
> > > +	if (sbi->secs_per_zone =3D=3D 1)
> > > +		goto got_it;
> > > +	if (zoneno =3D=3D old_zoneno)
> > > +		goto got_it;
> > > +	if (dir =3D=3D ALLOC_LEFT) {
> > > +		if (!go_left && zoneno + 1 >=3D total_zones)
> > > +			goto got_it;
> > > +		if (go_left && zoneno =3D=3D 0)
> > > +			goto got_it;
> > > +	}
> > > +
> > > +	for (i =3D 0; i < DEFAULT_CURSEGS; i++) {
> > > +		struct curseg_info *curseg =3D CURSEG_I(sbi, i);
> > > +
> > > +		if (curseg->zone !=3D zoneno)
> > > +			continue;
> > > +		if (!init)
> > > +			continue;
> > > +
> > > +		if (go_left)
> > > +			hint =3D zoneno * sbi->secs_per_zone - 1;
> > > +		else if (zoneno + 1 >=3D total_zones)
> > > +			hint =3D 0;
> > > +		else
> > > +			hint =3D (zoneno + 1) * sbi->secs_per_zone;
> > > +		init =3D false;
> > > +		goto find_other_zone;
> > > +	}
> >=20
> > I think this code is correct, but I found it very confusing to read.
> > The  point of the loop is simply to find out if any current segment usi=
ng the
> > given zone.  But that isn't obvious, it seem to do more.
> > I would re-write it as:
> >=20
> >   for (i =3D 0; i < DEFAULT_CURSEGS ; i++) {
> >        struct curseg_info *curseg =3D CURSEG_I(sbi, i);
> >        if (curseg->zone =3D=3D zoneno)
> >            break;
> >   }
> >   if (i < DEFAULT_CURSEGS && init) {
> >         /* Zone is in use,try another */
> >         if (go_left)
> >             hint =3D ....
> >         else if (....)
> >             hint =3D 0;
> >         else
> >             hint =3D ......;
> >         init =3D false;
> >         goto find_other_zone;
> >   }
> >=20
> > To me, that makes it much clearer what is happening.
> >=20
>=20
> Ok.=20
> I think it had better change like this to avoid unecessary loop.
>=20
> /* give up on finding another zone */
> if (!init)
> 	goto got_it;
>=20
> for (i =3D 0; i < DEFAULT_CURSEGS; i++) {
> 	if (CURSEG_I(sbi, i)->zone =3D=3D zoneno)
> 		break;
> }
>=20
> if (i < DEFAULT_CURSEGS) {
> 	/* zone is in use, try another */
>         if (go_left)
> 		hint =3D ....
> 	else if (....)
> 		hint =3D 0;
> 	else
> 		hint =3D ......;
> 	init =3D false;
> 	goto find_other_zone;
> }

Yes, that looks good.  Thanks.


>=20
> > > +static void f2fs_end_io_write(struct bio *bio, int err)
> > > +{
> > > +	const int uptodate =3D test_bit(BIO_UPTODATE, &bio->bi_flags);
> > > +	struct bio_vec *bvec =3D bio->bi_io_vec + bio->bi_vcnt - 1;
> > > +	struct bio_private *p =3D bio->bi_private;
> > > +
> > > +	do {
> > > +		struct page *page =3D bvec->bv_page;
> > > +
> > > +		if (--bvec >=3D bio->bi_io_vec)
> > > +			prefetchw(&bvec->bv_page->flags);
> > > +		if (!uptodate) {
> > > +			SetPageError(page);
> > > +			if (page->mapping)
> > > +				set_bit(AS_EIO, &page->mapping->flags);
> > > +			p->sbi->ckpt->ckpt_flags |=3D CP_ERROR_FLAG;
> > > +			set_page_dirty(page);
> > > +		}
> > > +		end_page_writeback(page);
> > > +		dec_page_count(p->sbi, F2FS_WRITEBACK);
> > > +	} while (bvec >=3D bio->bi_io_vec);
> > > +
> > > +	if (p->is_sync)
> > > +		complete(p->wait);
> > > +	kfree(p);
> > > +	bio_put(bio);
> > > +}
> >=20
> > This comment doesn't neatly attach to just one piece of code, but it is
> > closely related to f2fs_end_io_write, so I'll put it here.
> >=20
> > When you are writing a checkpoint you write out a number of blocks with=
out
> > setting ->is_sync, and then write one block with is_sync set.
> > The expectation seems to be that when that last block is written and so=
 calls=20
> >    complete(p->wait);
> > then all the blocks have been written.
> > I don't think that is a valid assumption in general.  Various things can
> > re-order blocks.  Back when we had BIO_BARRIER, a barrier request would=
 force
> > that semantic, but that was found to be too problematic.
> > You use WRITE_FLUSH_FUA for the ->is_sync write, but that is not necess=
arily
> > enough to keep everything in order.  You really should wait for all the
> > blocks to report that they are complete.  Probably have an atomic count=
er of
> > pending blocks and each one does
> >   if (atomic_dec_and_test(&counter))
> >        complete(->wait);
> >=20
>=20
> Yes, WRITE_FLUSH_FUA does not guarantee the write order.
> So, f2fs does checkpoint with the following procedure.
> 1. inc_page_count(sbi, F2FS_WRITEBACK) whenever submitting bios.
>   (ref. submit_write_page())
> 2. wait until the number of writeback pages is equal to 0.
>   (ref. dec_page_count(sbi, F2FS_WRITEBACK) in end_io)
> 3. the last bio for checkpoint blocks is submitted with
> ->is_sync.

and you have=20
	/* wait for previous submitted node/meta pages writeback */
	while (get_pages(sbi, F2FS_WRITEBACK))
		congestion_wait(BLK_RW_ASYNC, HZ / 50);
in do_checkpoint().  That was the piece I was missing.

Thanks,
NeilBrown


>=20
> Thank you for valuable comments.
>=20
> >=20
> > Regards,
> > NeilBrown
>=20


--Sig_/pznYD/L740_Wq0TsvQkOL2E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHzmhznsnt1WYoG5AQJGWRAAnmhqj1k5XnOkeONfD45gFG+zw2KVVhf8
IM55t4ktSkekAA9Ugy9v5f4aTvRWzEDVVSbX33CCw/6CM0nJRbNrTdvdcsXM48Yu
TdLHSnhYo/9FqT2jfcj+8BRwtb2T9DXhwvw94CXXXFNanb+V+mRr+y4pw2+VvtG4
6x+xlXc8e4HyKu1YZy3Vfrg9DrsXncuumuBE7fPnGocZQi1mfqS0LwwdS+WWgQmP
FDvjcfZ9s+FbkWW5pwN4MLBDUvqk7MHuvB5wa17XbW56Ax8KiaMyMZTbYD6QZHv4
TNWwIIjzofp6xVGZLDjngH8EqSt9uKiGVDkb8ZWnPORgILqFG2PhObCC6D8aqzc6
nmt6FyqlgQ0HlLgrDn0NQRz2SNxFVG7YYHfZm51u+wrASu+/Tpdeky3TuTDha1t+
oxy997PGPcpRHk+8d6io9y9Izk1k4pMEs2yxgsOcv7wDBUHSp3DlJFNofHZn9NuL
2FfbKR/bSZoW/f6K6vDLwYfY3Obf7LJ3IaoqtOxObnV8JQWqi2KvdvwADyWtD38/
d5VoM20C/ZH6iCx63g2UTus8fCR5Q94MG7MlZmh+II9zAe2P2fhzQT7+ZzC2o89N
lS7zKnGmDJY93VsXjJ+5IJkf1UDScB/ZPdnWlSPJtlSIM97OlnpiK8n3diJYHfdO
OPu7dGFLBio=
=XDAi
-----END PGP SIGNATURE-----

--Sig_/pznYD/L740_Wq0TsvQkOL2E--
