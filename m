Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2H1WRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:17:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2H1WRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:17:49 -0400
Date: Tue, 28 Aug 2012 15:17:15 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 3/9] block: Add bio_reset()
Message-ID: <20120828221715.GD1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-4-git-send-email-koverstreet@google.com>
 <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 01:31:48PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Aug 28, 2012 at 10:37:30AM -0700, Kent Overstreet wrote:
> > Reusing bios is something that's been highly frowned upon in the past,
> > but driver code keeps doing it anyways. If it's going to happen anyways,
> > we should provide a generic method.
> > 
> > This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> > was open coding it, by doing a bio_init() and resetting bi_destructor.
> 
> Better to explain why some bio fields are re-ordered and why that
> shouldn't make things worse cacheline-wise?

Well it may (struct bio is what, 3 or 4 cachelines now?) but even on
ridiculous million iop devices struct bio just isn't hot enough for this
kind of stuff to show up in the profiles... and I've done enough
profiling to be pretty confident of that.

So um, if there was anything to say performance wise I would, but to me
it seems more that there isn't.

(pruning struct bio would have more of an effect performance wise, which
you know is something I'd like to do.)

> 
> > +void bio_reset(struct bio *bio)
> > +{
> 
> Function comment explaining what it does and why it does what it does
> with integrity / bi_css / whatnot?

Yeah, good idea.

> 
> > +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> > +
> > +	if (bio_integrity(bio))
> > +		bio_integrity_free(bio, bio->bi_pool);
> > +
> > +	bio_disassociate_task(bio);
> 
> Is this desirable?  Why?

*twitch* I should've thought more when I made that change.

It occurs to me now that we specifically talked about that and decided
to do it the other way - when I changed that I was just looking at
bio_free() and decided they needed to be symmetrical.

I still think they should be symmetrical, but if that's true bi_ioc and
bi_css need to be moved, and also bio_disassociate_task() should be
getting called from bio_free(), not bio_put().

Were you the one that added that call? I know you've been working on
that area of the code recently. Sticking it in bio_put() instead of
bio_free() seems odd to be, and they're completely equivalent now that
bio_free() is only called from bio_put() (save one instance I should
probably fix).
