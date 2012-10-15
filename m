Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2JOXWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:22:12 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:38575 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab2JOXWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:22:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQmAPmZfFB5LH33/2dsb2JhbABFuh+EbQKBBIEJgiABAQUnExwjEAgDDgYELhQlAyETiAOrYZBPFItFgWeEVgOVa5AxgwE
Date: Tue, 16 Oct 2012 10:21:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>
Subject: Re: xfs: fix buffer lookup race on allocation failure
Message-ID: <20121015232147.GG2739@dastard>
References: <CAJ75kXZsBfhydOSF1Tjpp_OOndWs=jbC_YvrZ9Fw22+Q4rp1yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXZsBfhydOSF1Tjpp_OOndWs=jbC_YvrZ9Fw22+Q4rp1yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 11:27:58AM +0200, William Dauchy wrote:
> Hello,
> 
> I believe, the commit fe2429b fixes the attached kernel trace.
> I tested it both on top of 3.2 and 3.4 stable tree.
> Could we consider adding this patch in stable tree at least for 3.2 and 3.4?
> 
> commit fe2429b0966a7ec42b5fe3bf96f0f10de0a3b536
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Mon Apr 23 15:58:45 2012 +1000
> 
>     xfs: fix buffer lookup race on allocation failure
> 
>     When memory allocation fails to add the page array or tht epages to
>     a buffer during xfs_buf_get(), the buffer is left in the cache in a
>     partially initialised state. There is enough state left for the next
>     lookup on that buffer to find the buffer, and for the buffer to then
>     be used without finishing the initialisation.  As a result, when an
>     attempt to do IO on the buffer occurs, it fails with EIO because
>     there are no pages attached to the buffer.
> 
>     We cannot remove the buffer from the cache immediately and free it,
>     because there may already be a racing lookup that is blocked on the
>     buffer lock. Hence the moment we unlock the buffer to then free it,
>     the other user is woken and we have a use-after-free situation.
> 
>     To avoid this race condition altogether, allocate the pages for the
>     buffer before we insert it into the cache.  This then means that we
>     don't have an allocation  failure case to deal after the buffer is
>     already present in the cache, and hence avoid the problem
>     altogether.  In most cases we won't have racing inserts for the same
>     buffer, and so won't increase the memory pressure allocation before
>     insertion may entail.
> 
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>     Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>     Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> 
> XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
> fs/xfs/xfs_buf.c, line: 598

You're running a CONFIG_XFS_DEBUG kernel. If you can reproduce the
problem with CONFIG_XFS_DEBUG, then it probably should be
backported.

If you are using CONFIG_XFS_DEBUG on production systems, then you
shouldn't be because it does nasty things to allocation patterns,
not to mention a 25-30% CPU overhead and will panic in places where
errors are recoverable but as a developer we want to try to find out
what went wrong.

In this case, you'll get a transient EIO error when the I/O is
issued on the malformed buffer, but other than that the system can
continue alon just fine and the next read ofthe buffer will work
prefectly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
