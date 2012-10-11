Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2JKCvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:51:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49083 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2JKCvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:51:36 -0400
Date: Wed, 10 Oct 2012 19:51:02 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121011025102.GE24174@moria.home.lan>
References: <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
 <20121009231059.GV26187@lenny.home.zabbo.net>
 <20121010000600.GB26835@google.com>
 <20121010002634.GX26187@lenny.home.zabbo.net>
 <20121010004746.GF26835@google.com>
 <20121010214315.GE6371@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010214315.GE6371@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 02:43:15PM -0700, Zach Brown wrote:
> > True. But that could be solved with a separate interface that either
> > doesn't use a context to submit a call synchronously, or uses an
> > implicit per thread context.
> 
> Sure, but why bother if we can make the one submission interface fast
> enough to satisfy quick callers?  Less is more, and all that.

Very true, if it's possible. I'm just still skeptical.

> > I don't have a _strong_ opinion there, but my intuition is that we
> > shouldn't be creating new types of handles without a good reason. I
> > don't think the annoyances are for the most part particular to file
> > descriptors, I think the tend to be applicable to handles in general and
> > at least with file descriptors they're known and solved.
> 
> I strongly disagree.  That descriptors are an expensive limited
> resources is a perfectly good reason to not make them required to access
> the ring.

What's so special about aio vs. epoll, and now signalfd/eventfd/timerfd
etc.? 

> > That would be awesome, though for it to be worthwhile there couldn't be
> > any kernel notion of a context at all and I'm not sure if that's
> > practical. But the idea hadn't occured to me before and I'm sure you've
> > thought about it more than I have... hrm.
> > 
> > Oh hey, that's what acall does :P
> 
> :)
> 
> > For completions though you really want the ringbuffer pinned... what do
> > you do about that?
> 
> I don't think the kernel has to mandate that, no.  The code has to deal
> with completions faulting, but they probably won't.  In acall it
> happened that completions always came from threads that could block so
> its coping mechanism was to just use put_user() :).

Yeah, but that means the completion has to be delivered from process
context. That's not what aio does today, and it'd be a real performance
regression.

I don't know of a way around that myself.

> If userspace wants them rings locked, they can mlock() the memory.
> 
> Think about it from another angle: the current mechanism of creating an
> aio ring is a way to allocate pinned memory outside of the usual mlock
> accounting.  This could be abused, so aio grew an additional tunable to
> limit the number of total entries in rings in the system.
> 
> By putting the ring in normal user memory we avoid that problem
> entirely.

No different from any other place the kernel allocates memory on behalf
of userspace... it needs a general solution, not a bunch of special case
solutions (though since the general solution is memcg you might argue
the cure is worse than the disease... :P)
