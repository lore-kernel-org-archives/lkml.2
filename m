Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2IACXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 22:23:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2IACXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 22:23:05 -0400
Date: Fri, 31 Aug 2012 19:23:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 3/9] block: Add bio_reset()
Message-ID: <20120901022305.GE19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-4-git-send-email-koverstreet@google.com>
 <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828221715.GD1048@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828221715.GD1048@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 28, 2012 at 03:17:15PM -0700, Kent Overstreet wrote:
> > Better to explain why some bio fields are re-ordered and why that
> > shouldn't make things worse cacheline-wise?
> 
> Well it may (struct bio is what, 3 or 4 cachelines now?) but even on
> ridiculous million iop devices struct bio just isn't hot enough for this
> kind of stuff to show up in the profiles... and I've done enough
> profiling to be pretty confident of that.
> 
> So um, if there was anything to say performance wise I would, but to me
> it seems more that there isn't.
> 
> (pruning struct bio would have more of an effect performance wise, which
> you know is something I'd like to do.)

Yeah, please put something like the above in the patch description.

> > > +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> > > +
> > > +	if (bio_integrity(bio))
> > > +		bio_integrity_free(bio, bio->bi_pool);
> > > +
> > > +	bio_disassociate_task(bio);
> > 
> > Is this desirable?  Why?
> 
> *twitch* I should've thought more when I made that change.
> 
> It occurs to me now that we specifically talked about that and decided
> to do it the other way - when I changed that I was just looking at
> bio_free() and decided they needed to be symmetrical.
> 
> I still think they should be symmetrical, but if that's true bi_ioc and
> bi_css need to be moved, and also bio_disassociate_task() should be
> getting called from bio_free(), not bio_put().
> 
> Were you the one that added that call? I know you've been working on
> that area of the code recently. Sticking it in bio_put() instead of
> bio_free() seems odd to be, and they're completely equivalent now that
> bio_free() is only called from bio_put() (save one instance I should
> probably fix).

Maybe I botched symmetry but anyways I *suspect* it probably would be
better to keep css association across bio_reset() give the current
usages of both mechanisms.  css association indicates the ownership of
the bio which isn't likely to change while recycling the bio.

Thanks.

-- 
tejun
