Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab2EXXfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:35:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50901 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2EXXfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:35:36 -0400
Date: Thu, 24 May 2012 16:35:33 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 03/14] block: Add bio_clone_bioset()
Message-ID: <20120524233532.GE22664@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-4-git-send-email-koverstreet@google.com>
 <20120524184507.GD27550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524184507.GD27550@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:45:07PM -0400, Vivek Goyal wrote:
> On Wed, May 23, 2012 at 05:02:40PM -0700, Kent Overstreet wrote:
> 
> [..]
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1062,26 +1062,19 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
> >   * Creates a bio that consists of range of complete bvecs.
> >   */
> >  static struct bio *clone_bio(struct bio *bio, sector_t sector,
> > -			     unsigned short idx, unsigned short bv_count,
> > +			     unsigned short bv_count,
> >  			     unsigned int len, struct bio_set *bs)
> >  {
> >  	struct bio *clone;
> >  
> > -	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
> > -	__bio_clone(clone, bio);
> > +	clone = bio_clone_bioset(bio, GFP_NOIO, bs);
> >  	clone->bi_sector = sector;
> > -	clone->bi_idx = idx;
> > -	clone->bi_vcnt = idx + bv_count;
> > +	clone->bi_vcnt = bv_count;
> 
> In last posting you said that you are going to backout this idx change
> because you were not sure if it is correct. 

Yeah, I distinctly remember doing that but clearly something got lost.
Sorry.

Anyways, that change shouldn't have been part of that patch, but
something has to change there for the "Only clone bio vecs that are in
use" patch.

Gonna take a stab at reworking that code, it really ought to be possible
to just replace it with my bio splitting code but the way dm is doing
the splitting is... confusing.
