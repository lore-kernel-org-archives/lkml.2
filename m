Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab2HXUmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:42:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52167 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab2HXUmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:42:21 -0400
Date: Fri, 24 Aug 2012 13:42:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH v6 13/13] block: Only clone bio vecs that are in use
Message-ID: <20120824204216.GH21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-14-git-send-email-koverstreet@google.com>
 <20120822211045.GN19212@google.com>
 <20120824070508.GE11977@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824070508.GE11977@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Fri, Aug 24, 2012 at 12:05:08AM -0700, Kent Overstreet wrote:
> > I'm pretty sure I sound like a broken record by now, but
> > 
> > * How was this tested?
> > 
> > * What are the implications and possible dangers?
> 
> I've said all that on list, but I gather what you really wanted was to
> have it all in the patch description. Will do.

Yeap.

> > > @@ -463,10 +468,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
> > >  	bio->bi_sector = bio_src->bi_sector;
> > >  	bio->bi_bdev = bio_src->bi_bdev;
> > >  	bio->bi_flags |= 1 << BIO_CLONED;
> > > +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> > 
> > For the n'th time, explain please.
> 
> Argh, I could've sworn I dropped that part.

Can we drop it tho?  If we're changing bvecs, we probably should be
clearing SEG_VALID on both bios.

> commit 0edda563aef9432b45f0c6a50f52590b92594560
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Thu Aug 23 23:26:38 2012 -0700
> 
>     block: Only clone bio vecs that are in use
>     
>     bcache creates large bios internally, and then splits them according to
>     the device requirements before it sends them down. If a lower level
>     device tries to clone the bio, and the original bio had more than
>     BIO_MAX_PAGES, the clone will fail unecessarily.
>     
>     We can fix this by only cloning the bio vecs that are actually in use -
>     as for as the block layer is concerned the new bio is still equivalent
>     to the old bio.
>     
>     This code should in general be safe as long as all the block layer code
>     uses bi_idx, bi_vcnt consistently; since bios are cloned by code that
>     doesn't own the original bio there's little room for issues caused by
>     code playing games with the original bio's bi_io_vec. One perhaps
>     imagine code depending the clone and original bio's io vecs lining up a
>     certain way, but auditing and testing haven't turned up anything.
>     
>     Testing: This code has been in the bcache tree for quite awhile, and has
>     been tested with various md layers and dm targets (including strange
>     things like multipath).

Yeap, looks much better to me.

Thanks.

-- 
tejun
