Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab1L0Vo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:44:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60958 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1L0Vo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:44:26 -0500
Date: Tue, 27 Dec 2011 13:44:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111227214421.GG17712@google.com>
References: <20111222224117.GL17084@google.com>
 <20111222145426.5844df96.akpm@linux-foundation.org>
 <20111222230047.GN17084@google.com>
 <20111222151649.de57746f.akpm@linux-foundation.org>
 <20111222232433.GQ17084@google.com>
 <20111222154138.d6c583e3.akpm@linux-foundation.org>
 <20111222235455.GT17084@google.com>
 <20111222171432.e429c041.akpm@linux-foundation.org>
 <20111227183402.GF17712@google.com>
 <20111227132056.44ee9281.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227132056.44ee9281.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Tue, Dec 27, 2011 at 01:20:56PM -0800, Andrew Morton wrote:
> >  That's the *whole* reason why allocation
> > buffering is used there.  It's filled from GFP_KERNEL context and
> > consumed from GFO_NOIO and as pointed out multiple times the allocaion
> > there is infrequent and can be opportunistic.  Sans the use of small
> > buffering items, this isn't any different from deferring allocation to
> > different context.  There's no guarantee when that allocation would
> > happen but in practice both will be reliable enough for the given use
> > case.
> 
> "reliable enough" is not the standard to which we aspire.
> 
> Look, the core problem here is that this block code is trying to
> allocate from an inappropriate context.  Rather than hacking around
> adding stuff to make this work most-of-the-time, how about fixing the
> block code to perform the allocation from the correct context?

Yeah, sure, that would be nice.  I'm just not convinced that would be
possible in a way which would be in the end better than buffering
memory allocations some way.  For better or for worse, the whole blkcg
/ ioc / request_queue association mechanism is based on essentially
opportunistic allocation on the expectation that the number of used
combinations would be low and allocation frequency would be low too.

> > I don't necessarily insist on using mempool here but all the given
> > objections seem bogus to me.  The amount of code added is minimal and
> > straight-forward.  It doesn't change what mempool is or what it does
> > at all and the usage fits the problem to be solved.  I can't really
> > understand what the objection is about.
> 
> It's adding complexity to core kernel.  It's adding a weak and
> dangerous interface which will encourage poor code in callers.
>
> And why are we doing all of this?  So we can continue to use what is
> now poor code at one particular site in the block layer!  If the block
> code wants to run alloc_percpu() (which requires GFP_KERNEL context)
> then it should be reworked to do so from GFP_KERNEL context.  For that
> is the *best* solution, no?

Ummm... I'm not arguing this is the best solution in the world.

I'm not convinced trying to put this into GFP_KERNEL context would
work.  Short of that, the next best thing would be making percpu
allocator useable from memory reclaim path, right?  But that would
involved a lot more churn and complexity without much added benefit,
given that this type of use cases aren't expected to be common - and
I'm fairly sure it isn't given track record of past few years.

IMHO, core code is there to help its users.  In this case, if we
choose to buffer allocation somehow, we sure can add that to block
layer, but that would be pretty silly thing to do.  It's not keeping
anything simple.  It's just hiding things.

Anyways, let's stop this abstract discussion.  I think the crux of
disagreement is about whether this can be moved into GFP_KERNEL
context or not.  Let's continue with Vivek's subthread.

Thanks.

-- 
tejun
