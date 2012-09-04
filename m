Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2IDNyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:54:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083Ab2IDNyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:54:37 -0400
Date: Tue, 4 Sep 2012 09:54:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <koverstreet@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904135422.GC13768@redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120903004927.GM15292@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903004927.GM15292@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 10:49:27AM +1000, Dave Chinner wrote:
> On Thu, Aug 30, 2012 at 06:07:45PM -0400, Vivek Goyal wrote:
> > On Wed, Aug 29, 2012 at 10:13:45AM -0700, Kent Overstreet wrote:
> > 
> > [..]
> > > > Performance aside, punting submission to per device worker in case of deep
> > > > stack usage sounds cleaner solution to me.
> > > 
> > > Agreed, but performance tends to matter in the real world. And either
> > > way the tricky bits are going to be confined to a few functions, so I
> > > don't think it matters that much.
> > > 
> > > If someone wants to code up the workqueue version and test it, they're
> > > more than welcome...
> > 
> > Here is one quick and dirty proof of concept patch. It checks for stack
> > depth and if remaining space is less than 20% of stack size, then it
> > defers the bio submission to per queue worker.
> 
> Given that we are working around stack depth issues in the
> filesystems already in several places, and now it seems like there's
> a reason to work around it in the block layers as well, shouldn't we
> simply increase the default stack size rather than introduce
> complexity and performance regressions to try and work around not
> having enough stack?

Dave,

In this particular instance, we really don't have any bug reports of
stack overflowing. Just discussing what will happen if we make 
generic_make_request() recursive again.

> 
> I mean, we can deal with it like the ia32 4k stack issue was dealt
> with (i.e. ignore those stupid XFS people, that's an XFS bug), or
> we can face the reality that storage stacks have become so complex
> that 8k is no longer a big enough stack for a modern system....

So first question will be, what's the right stack size? If we make
generic_make_request() recursive, then at some storage stack depth we will
overflow stack anyway (if we have created too deep a stack). Hence
keeping current logic kind of makes sense as in theory we can support
arbitrary depth of storage stack.

Yes, if higher layers are consuming more stack, then it does raise the
question whether to offload work to worker and take performance hit or
increase stack depth. I don't know what's the answer to that question.
I have only tried going through the archive where some people seem to have
pushed for even smaller stack size (4K).

Thanks
Vivek
