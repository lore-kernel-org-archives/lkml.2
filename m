Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab2JLPNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:13:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2JLPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:13:06 -0400
Message-ID: <1350054773.2299.54.camel@kjgkr>
Subject: Re: [PATCH 07/16] f2fs: add segment operations
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sat, 13 Oct 2012 00:12:53 +0900
In-Reply-To: <20121011093707.2b95e4de@notabene.brown>
References: <000e01cda2f1$13515dd0$39f41970$%kim@samsung.com>
	 <20121011093707.2b95e4de@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-11 (목), 09:37 +1100, NeilBrown:
> On Fri, 05 Oct 2012 21:00:55 +0900 김재극 <jaegeuk.kim@samsung.com> wrote:
> 
> > +/**
> > + * Find a new segment from the free segments bitmap to right order
> > + * This function should be returned with success, otherwise BUG
> > + */
> > +static void get_new_segment(struct f2fs_sb_info *sbi,
> > +			unsigned int *newseg, bool new_sec, int dir)
> > +{
> > +	struct free_segmap_info *free_i = FREE_I(sbi);
> > +	unsigned int total_secs = sbi->total_sections;
> > +	unsigned int segno, secno, zoneno;
> > +	unsigned int total_zones = sbi->total_sections / sbi->secs_per_zone;
> > +	unsigned int hint = *newseg >> sbi->log_segs_per_sec;
> > +	unsigned int old_zoneno = GET_ZONENO_FROM_SEGNO(sbi, *newseg);
> > +	unsigned int left_start = hint;
> > +	bool init = true;
> > +	int go_left = 0;
> > +	int i;
> > +
> > +	write_lock(&free_i->segmap_lock);
> > +
> > +	if (!new_sec && ((*newseg + 1) % sbi->segs_per_sec)) {
> > +		segno = find_next_zero_bit(free_i->free_segmap,
> > +					TOTAL_SEGS(sbi), *newseg + 1);
> > +		if (segno < TOTAL_SEGS(sbi))
> > +			goto got_it;
> > +	}
> > +find_other_zone:
> > +	secno = find_next_zero_bit(free_i->free_secmap, total_secs, hint);
> > +	if (secno >= total_secs) {
> > +		if (dir == ALLOC_RIGHT) {
> > +			secno = find_next_zero_bit(free_i->free_secmap,
> > +						total_secs, 0);
> > +			BUG_ON(secno >= total_secs);
> > +		} else {
> > +			go_left = 1;
> > +			left_start = hint - 1;
> > +		}
> > +	}
> > +	if (go_left == 0)
> > +		goto skip_left;
> > +
> > +	while (test_bit(left_start, free_i->free_secmap)) {
> > +		if (left_start > 0) {
> > +			left_start--;
> > +			continue;
> > +		}
> > +		left_start = find_next_zero_bit(free_i->free_secmap,
> > +						total_secs, 0);
> > +		BUG_ON(left_start >= total_secs);
> > +		break;
> > +	}
> > +	secno = left_start;
> > +skip_left:
> > +	hint = secno;
> > +	segno = secno << sbi->log_segs_per_sec;
> > +	zoneno = secno / sbi->secs_per_zone;
> > +
> > +	if (sbi->secs_per_zone == 1)
> > +		goto got_it;
> > +	if (zoneno == old_zoneno)
> > +		goto got_it;
> > +	if (dir == ALLOC_LEFT) {
> > +		if (!go_left && zoneno + 1 >= total_zones)
> > +			goto got_it;
> > +		if (go_left && zoneno == 0)
> > +			goto got_it;
> > +	}
> > +
> > +	for (i = 0; i < DEFAULT_CURSEGS; i++) {
> > +		struct curseg_info *curseg = CURSEG_I(sbi, i);
> > +
> > +		if (curseg->zone != zoneno)
> > +			continue;
> > +		if (!init)
> > +			continue;
> > +
> > +		if (go_left)
> > +			hint = zoneno * sbi->secs_per_zone - 1;
> > +		else if (zoneno + 1 >= total_zones)
> > +			hint = 0;
> > +		else
> > +			hint = (zoneno + 1) * sbi->secs_per_zone;
> > +		init = false;
> > +		goto find_other_zone;
> > +	}
> 
> I think this code is correct, but I found it very confusing to read.
> The  point of the loop is simply to find out if any current segment using the
> given zone.  But that isn't obvious, it seem to do more.
> I would re-write it as:
> 
>   for (i = 0; i < DEFAULT_CURSEGS ; i++) {
>        struct curseg_info *curseg = CURSEG_I(sbi, i);
>        if (curseg->zone == zoneno)
>            break;
>   }
>   if (i < DEFAULT_CURSEGS && init) {
>         /* Zone is in use,try another */
>         if (go_left)
>             hint = ....
>         else if (....)
>             hint = 0;
>         else
>             hint = ......;
>         init = false;
>         goto find_other_zone;
>   }
> 
> To me, that makes it much clearer what is happening.
> 

Ok. 
I think it had better change like this to avoid unecessary loop.

/* give up on finding another zone */
if (!init)
	goto got_it;

for (i = 0; i < DEFAULT_CURSEGS; i++) {
	if (CURSEG_I(sbi, i)->zone == zoneno)
		break;
}

if (i < DEFAULT_CURSEGS) {
	/* zone is in use, try another */
        if (go_left)
		hint = ....
	else if (....)
		hint = 0;
	else
		hint = ......;
	init = false;
	goto find_other_zone;
}

> > +static void f2fs_end_io_write(struct bio *bio, int err)
> > +{
> > +	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> > +	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> > +	struct bio_private *p = bio->bi_private;
> > +
> > +	do {
> > +		struct page *page = bvec->bv_page;
> > +
> > +		if (--bvec >= bio->bi_io_vec)
> > +			prefetchw(&bvec->bv_page->flags);
> > +		if (!uptodate) {
> > +			SetPageError(page);
> > +			if (page->mapping)
> > +				set_bit(AS_EIO, &page->mapping->flags);
> > +			p->sbi->ckpt->ckpt_flags |= CP_ERROR_FLAG;
> > +			set_page_dirty(page);
> > +		}
> > +		end_page_writeback(page);
> > +		dec_page_count(p->sbi, F2FS_WRITEBACK);
> > +	} while (bvec >= bio->bi_io_vec);
> > +
> > +	if (p->is_sync)
> > +		complete(p->wait);
> > +	kfree(p);
> > +	bio_put(bio);
> > +}
> 
> This comment doesn't neatly attach to just one piece of code, but it is
> closely related to f2fs_end_io_write, so I'll put it here.
> 
> When you are writing a checkpoint you write out a number of blocks without
> setting ->is_sync, and then write one block with is_sync set.
> The expectation seems to be that when that last block is written and so calls 
>    complete(p->wait);
> then all the blocks have been written.
> I don't think that is a valid assumption in general.  Various things can
> re-order blocks.  Back when we had BIO_BARRIER, a barrier request would force
> that semantic, but that was found to be too problematic.
> You use WRITE_FLUSH_FUA for the ->is_sync write, but that is not necessarily
> enough to keep everything in order.  You really should wait for all the
> blocks to report that they are complete.  Probably have an atomic counter of
> pending blocks and each one does
>   if (atomic_dec_and_test(&counter))
>        complete(->wait);
> 

Yes, WRITE_FLUSH_FUA does not guarantee the write order.
So, f2fs does checkpoint with the following procedure.
1. inc_page_count(sbi, F2FS_WRITEBACK) whenever submitting bios.
  (ref. submit_write_page())
2. wait until the number of writeback pages is equal to 0.
  (ref. dec_page_count(sbi, F2FS_WRITEBACK) in end_io)
3. the last bio for checkpoint blocks is submitted with
->is_sync.

Thank you for valuable comments.

> 
> Regards,
> NeilBrown

-- 
Jaegeuk Kim
Samsung

