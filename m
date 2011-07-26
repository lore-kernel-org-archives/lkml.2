Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1GZLnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:43:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49731
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284Ab1GZLng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:43:36 -0400
Date: Tue, 26 Jul 2011 07:43:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: Preempt & smp_processor_id in __make_request
Message-ID: <20110726114330.GA12704@infradead.org>
References: <1311672726.2700.5.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311672726.2700.5.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 10:32:06AM +0100, Steven Whitehouse wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index f8cb099..f925581 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1283,7 +1283,7 @@ get_rq:
>  
>  	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
>  	    bio_flagged(bio, BIO_CPU_AFFINE))
> -		req->cpu = smp_processor_id();
> +		req->cpu = raw_smp_processor_id();
>  
>  	plug = current->plug;
>  	if (plug) {
> 
> However this fixes the symptoms, rather than the cause, so I'm not at
> all sure that this is the correct solution,

It doesn't fix the symptoms - the warning is one of those 98% percent
right types of warnings.  In this case get_cpu/put_cpu doesn't buy you
anthing - we want to stash away the cpu id that we submitted the I/O
from, to compare it when we later process the I/O completion from
a different context.  With some PREEMPT options we might actually get
rescheduled to a different CPU during the rest of this function, but
as we submit the plugged requests at this point we'll still be correct.

Even if wasn't we would already thrash the cache badly enough for this
optimization not to matter in that case.
