Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab0GUXUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:20:01 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:50937 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754907Ab0GUXT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:19:58 -0400
Date: Thu, 22 Jul 2010 09:19:28 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: OOPS at boot time
Message-ID: <20100721231928.GY32635@dastard>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
 <20100720033656.0ce6356f.akpm@linux-foundation.org>
 <20100720224525.GO32635@dastard>
 <20100720174424.12a4bf64.akpm@linux-foundation.org>
 <20100721052007.GT32635@dastard>
 <20100721002907.639802cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721002907.639802cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:29:07AM -0700, Andrew Morton wrote:
> On Wed, 21 Jul 2010 15:20:07 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > > and they were dirtied within dquot_free_space().
> > 
> > AFAICT dquot_free_space() is called deep in the guts of
> > ext3_truncate() via dquot_free_block(), which is called directly
> > before end_writeback(). That should overwrite any state changes made
> > inside ext3_truncate. I wonder if iput_final() is racing with
> > something else here?
> > 
> 
> This isn't a race.  I type `make' and the warnings spew out at hundreds
> per second - every unlink, I'd say.
> 
> Did you try my .config?

Yes, I did - it was the second thing I tried after using my usual
.config (*).

I'm not an ext3 expert, so I might be missing something, but I
cannot see (from code inspection) where those flags are being set
after end_writeback is called.  My experience with inode flag
corruptions on XFS that can only be reprodued by a small number of
machines is that it is usually the result of a race condition.
It looks and smells similar to me.

Anyway, I'm not sure I can help much more at this point - until I
can reproduce it I'm just making SWAGs...

Cheers,

Dave.

(*) I eventually worked out that the ext3 corruption I was chasing
on that one filesystem was a result of using a kernel built with
your config because it didn't have CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
set and I did the equivalent of yanking the power cord to the VM
(I do that all the time) while that kernel was running...

-- 
Dave Chinner
david@fromorbit.com
