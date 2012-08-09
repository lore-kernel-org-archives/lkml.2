Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2HIDHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 23:07:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2HIDHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 23:07:12 -0400
Date: Wed, 8 Aug 2012 20:06:38 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 12/12] block: Only clone bio vecs that are in use
Message-ID: <20120809030638.GL7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-13-git-send-email-koverstreet@google.com>
 <20120808233007.GM6983@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808233007.GM6983@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:30:07PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 06, 2012 at 03:08:41PM -0700, Kent Overstreet wrote:
> > @@ -459,10 +460,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
> >  	bio->bi_sector = bio_src->bi_sector;
> >  	bio->bi_bdev = bio_src->bi_bdev;
> >  	bio->bi_flags |= 1 << BIO_CLONED;
> > +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> 
> This isn't obvious at all.  Why no explanation anywhere?  Also it
> would be nice to update comments of the updated functions so that it's
> clear that only partial cloning happens.

Because it's not obvious to me, either - I had to grep around through a
fair amount of code to figure out the semantics of BIO_SEG_VALID and I
doubt I have it 100%. I'm also pretty sure it's not used consistently in
the existing code...

If it means what I think it means, it should be obvious - nr_segs isn't
valid because the number of pages in the iovec changed (though we didn't
bother to copy it over anyways. So it's not necessary if nr_segs = 0
means nr_segs isn't valid, but bleh).

Anyways. yeah. BIO_SEG_VALID should be documented, and if it was I think
this code would be fine.

I will update the comment for the partial cloning thing:

/**
 * 	__bio_clone	-	clone a bio
 * 	@bio: destination bio
 * 	@bio_src: bio to clone
 *
 *	Clone a &bio. Caller will own the returned bio, but not
 *	the actual data it points to. Reference count of returned
 * 	bio will be one.
 *
 *	We don't clone the entire bvec, just the part from bi_idx to b_vcnt
 *	(i.e. what the bio currently points to, so the new bio is still
 *	equivalent to the old bio).
 */
void __bio_clone(struct bio *bio, struct bio *bio_src)
{
	memcpy(bio->bi_io_vec,
	       bio_iovec(bio_src),
	       bio_segments(bio_src) * sizeof(struct bio_vec));

