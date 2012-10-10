Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2JJWhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:37:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab2JJWhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:37:04 -0400
Date: Thu, 11 Oct 2012 09:37:07 +1100
From: NeilBrown <neilb@suse.de>
To: =?utf-8?Q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 07/16] f2fs: add segment operations
Message-ID: <20121011093707.2b95e4de@notabene.brown>
In-Reply-To: <000e01cda2f1$13515dd0$39f41970$%kim@samsung.com>
References: <000e01cda2f1$13515dd0$39f41970$%kim@samsung.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0Dhmt/HOpLVC7XjFWcEzw=X"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0Dhmt/HOpLVC7XjFWcEzw=X
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Oct 2012 21:00:55 +0900 =EA=B9=80=EC=9E=AC=EA=B7=B9 <jaegeuk.kim=
@samsung.com> wrote:

> +/**
> + * Find a new segment from the free segments bitmap to right order
> + * This function should be returned with success, otherwise BUG
> + */
> +static void get_new_segment(struct f2fs_sb_info *sbi,
> +			unsigned int *newseg, bool new_sec, int dir)
> +{
> +	struct free_segmap_info *free_i =3D FREE_I(sbi);
> +	unsigned int total_secs =3D sbi->total_sections;
> +	unsigned int segno, secno, zoneno;
> +	unsigned int total_zones =3D sbi->total_sections / sbi->secs_per_zone;
> +	unsigned int hint =3D *newseg >> sbi->log_segs_per_sec;
> +	unsigned int old_zoneno =3D GET_ZONENO_FROM_SEGNO(sbi, *newseg);
> +	unsigned int left_start =3D hint;
> +	bool init =3D true;
> +	int go_left =3D 0;
> +	int i;
> +
> +	write_lock(&free_i->segmap_lock);
> +
> +	if (!new_sec && ((*newseg + 1) % sbi->segs_per_sec)) {
> +		segno =3D find_next_zero_bit(free_i->free_segmap,
> +					TOTAL_SEGS(sbi), *newseg + 1);
> +		if (segno < TOTAL_SEGS(sbi))
> +			goto got_it;
> +	}
> +find_other_zone:
> +	secno =3D find_next_zero_bit(free_i->free_secmap, total_secs, hint);
> +	if (secno >=3D total_secs) {
> +		if (dir =3D=3D ALLOC_RIGHT) {
> +			secno =3D find_next_zero_bit(free_i->free_secmap,
> +						total_secs, 0);
> +			BUG_ON(secno >=3D total_secs);
> +		} else {
> +			go_left =3D 1;
> +			left_start =3D hint - 1;
> +		}
> +	}
> +	if (go_left =3D=3D 0)
> +		goto skip_left;
> +
> +	while (test_bit(left_start, free_i->free_secmap)) {
> +		if (left_start > 0) {
> +			left_start--;
> +			continue;
> +		}
> +		left_start =3D find_next_zero_bit(free_i->free_secmap,
> +						total_secs, 0);
> +		BUG_ON(left_start >=3D total_secs);
> +		break;
> +	}
> +	secno =3D left_start;
> +skip_left:
> +	hint =3D secno;
> +	segno =3D secno << sbi->log_segs_per_sec;
> +	zoneno =3D secno / sbi->secs_per_zone;
> +
> +	if (sbi->secs_per_zone =3D=3D 1)
> +		goto got_it;
> +	if (zoneno =3D=3D old_zoneno)
> +		goto got_it;
> +	if (dir =3D=3D ALLOC_LEFT) {
> +		if (!go_left && zoneno + 1 >=3D total_zones)
> +			goto got_it;
> +		if (go_left && zoneno =3D=3D 0)
> +			goto got_it;
> +	}
> +
> +	for (i =3D 0; i < DEFAULT_CURSEGS; i++) {
> +		struct curseg_info *curseg =3D CURSEG_I(sbi, i);
> +
> +		if (curseg->zone !=3D zoneno)
> +			continue;
> +		if (!init)
> +			continue;
> +
> +		if (go_left)
> +			hint =3D zoneno * sbi->secs_per_zone - 1;
> +		else if (zoneno + 1 >=3D total_zones)
> +			hint =3D 0;
> +		else
> +			hint =3D (zoneno + 1) * sbi->secs_per_zone;
> +		init =3D false;
> +		goto find_other_zone;
> +	}

I think this code is correct, but I found it very confusing to read.
The  point of the loop is simply to find out if any current segment using t=
he
given zone.  But that isn't obvious, it seem to do more.
I would re-write it as:

  for (i =3D 0; i < DEFAULT_CURSEGS ; i++) {
       struct curseg_info *curseg =3D CURSEG_I(sbi, i);
       if (curseg->zone =3D=3D zoneno)
           break;
  }
  if (i < DEFAULT_CURSEGS && init) {
        /* Zone is in use,try another */
        if (go_left)
            hint =3D ....
        else if (....)
            hint =3D 0;
        else
            hint =3D ......;
        init =3D false;
        goto find_other_zone;
  }

To me, that makes it much clearer what is happening.


> +static void f2fs_end_io_write(struct bio *bio, int err)
> +{
> +	const int uptodate =3D test_bit(BIO_UPTODATE, &bio->bi_flags);
> +	struct bio_vec *bvec =3D bio->bi_io_vec + bio->bi_vcnt - 1;
> +	struct bio_private *p =3D bio->bi_private;
> +
> +	do {
> +		struct page *page =3D bvec->bv_page;
> +
> +		if (--bvec >=3D bio->bi_io_vec)
> +			prefetchw(&bvec->bv_page->flags);
> +		if (!uptodate) {
> +			SetPageError(page);
> +			if (page->mapping)
> +				set_bit(AS_EIO, &page->mapping->flags);
> +			p->sbi->ckpt->ckpt_flags |=3D CP_ERROR_FLAG;
> +			set_page_dirty(page);
> +		}
> +		end_page_writeback(page);
> +		dec_page_count(p->sbi, F2FS_WRITEBACK);
> +	} while (bvec >=3D bio->bi_io_vec);
> +
> +	if (p->is_sync)
> +		complete(p->wait);
> +	kfree(p);
> +	bio_put(bio);
> +}

This comment doesn't neatly attach to just one piece of code, but it is
closely related to f2fs_end_io_write, so I'll put it here.

When you are writing a checkpoint you write out a number of blocks without
setting ->is_sync, and then write one block with is_sync set.
The expectation seems to be that when that last block is written and so cal=
ls=20
   complete(p->wait);
then all the blocks have been written.
I don't think that is a valid assumption in general.  Various things can
re-order blocks.  Back when we had BIO_BARRIER, a barrier request would for=
ce
that semantic, but that was found to be too problematic.
You use WRITE_FLUSH_FUA for the ->is_sync write, but that is not necessarily
enough to keep everything in order.  You really should wait for all the
blocks to report that they are complete.  Probably have an atomic counter of
pending blocks and each one does
  if (atomic_dec_and_test(&counter))
       complete(->wait);


Regards,
NeilBrown

--Sig_/0Dhmt/HOpLVC7XjFWcEzw=X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHX4kznsnt1WYoG5AQJLUg/9FL7deM7qakw8Gt6m0K0ro/QsNa2v7auI
tzFNSNHSNn5msjClAhg0zPG02higfQHnyradQm4cmQrNX2tpw4B1qnX9T8Jcb+5j
ytKLQ8HR9yn4JkPn+tkqZBJDhipqwXVRzWrj9C8df4E6T668zGivBvOrJk8VsiQi
mJDxfkTuXeoWIGce5nZpPKSZeIIPOkexMTnCpAbkmLHK15xTOJsvf1yZkX44pQ0D
erwu1Kig15PreU5M7LJ9gW/Pg5/RWeXdre1cGOLjYUj3T/uaaBZvxDHRTVzxs9t3
VVuC0hlUT5DfW7m3AlTsytFON0hhexKl967lr5Wl3Ftg5Qq46t556TSPK7XVuw/2
p/PG9DYp8fpGEQmenYS776Ys0mRWwOmIFk+bpvSFYrcfcr3XPHohzad+xIw/2tAk
6XggK1wLe7KmLxWWAT8/zeuA8U7/DJCSX2EqXllDcm2mcuRX+f2GlLWSg3CaTtDN
nLIsOOnI6hRQ5UgiuYG84LvlQAjxWhr3RAesNVI0+3RGHxCUoQpc7/4lTxrG/Z9F
A9b8DchyRxfWrur8M67f3yAxMOAc0juaS09u6KS/Pk6OqZvy8HH3M/YRHHRUPP14
J8yWhH1yDrHUJjxdAcx6onpJDLccGjzkliiz+uSkcvOpTKdlI24bXl69HnNJ/hrd
S+S2DpOmsUo=
=/+zW
-----END PGP SIGNATURE-----

--Sig_/0Dhmt/HOpLVC7XjFWcEzw=X--
