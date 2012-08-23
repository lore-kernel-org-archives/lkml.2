Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2HWWrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 18:47:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2HWWrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 18:47:05 -0400
Date: Thu, 23 Aug 2012 15:46:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jeff Moyer <jmoyer@redhat.com>
cc: "Richard W.M. Jones" <rjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page
 fix
In-Reply-To: <x49obm1fil0.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LSU.2.00.1208231527150.5852@eggly.anvils>
References: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils> <20120822115243.GU1448@rhmail.home.annexia.org> <alpine.LSU.2.00.1208222143440.1917@eggly.anvils> <x49obm1fil0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012, Jeff Moyer wrote:
> Hugh Dickins <hughd@google.com> writes:
> 
> > [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
> >
> > Commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow")
> > is not good: a successful call to grow_buffers() cannot guarantee
> > that the page won't be reclaimed before the immediate next call to
> > __find_get_block(), which is why there was always a loop there.
> [snip]
> > Revert 91f68c89d8f3, restoring __getblk_slow() to how it was (plus
> > a checkpatch nitfix).  Simplify the interface between grow_buffers()
> > and grow_dev_page(), and avoid the infinite loop beyond end of device
> > by instead checking init_page_buffers()'s end_block there (I presume
> > that's more efficient than a repeated call to blkdev_max_block()),
> > returning -ENXIO to __getblk_slow() in that case.
> >
> > And remove akpm's ten-year-old "__getblk() cannot fail ... weird"
> > comment, but that is worrying: are all users of __getblk() really
> > now prepared for a NULL bh beyond end of device, or will some oops??
> 
> Hi, Hugh,
> 
> Thanks for digging into this.  I had wondered whether that loop was
> required for other purposes, and you've verified that it was.  I mostly
> like your fix.  Returning end_block from init_page_buffers is a little
> strange,

It is a little strange, I agree.  I wrestled a lot with the way block
and end_block were known at opposite ends of the callstack, and needed
to be brought together for the check.

If you think it would be better to move the blkdev_max_block()
lookup up a level into grow_dev_page(), then pass end_block down to
init_page_buffers(), that could work as well; though we'd then still
need to report "failure" from init_page_buffers().

I was inclined to leave it precisely where you had sited it, with that
comment on passing it back up; but could change it around if preferred.

> but I understand not wanting to redo the call to blkdev_max_block.
> 
> I went ahead to re-tested with the reproducer that I had, and your patch
> works fine.  Thanks again for tracking this down, and sorry I wasn't
> more diligent to begin with.
> 
> Reviewed-and-Tested-by: Jeff Moyer <jmoyer@redhat.com>

Great, thanks a lot.  It (but equally its incorrect earlier version)
have been running fine at home under my swapping load.  I'm confident
that it fixes the issues I had been seeing, although, strictly speaking,
it'll take another two or three days to reach bisection confidence level.

Hugh
