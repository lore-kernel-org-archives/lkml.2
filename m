Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1LSS13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:27:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab1LSS10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:27:26 -0500
Date: Mon, 19 Dec 2011 13:27:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Nate Custer <nate@cpanel.net>, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread
 context( Re: kvm deadlock)
Message-ID: <20111219182717.GC7175@redhat.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111215194712.GA11194@redhat.com>
 <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net>
 <20111216202907.GH7586@redhat.com>
 <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
 <20111219172717.GB7175@redhat.com>
 <20111219173519.GL24519@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219173519.GL24519@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 09:35:19AM -0800, Tejun Heo wrote:
> On Mon, Dec 19, 2011 at 12:27:17PM -0500, Vivek Goyal wrote:
> > On Sun, Dec 18, 2011 at 03:25:48PM -0600, Nate Custer wrote:
> > > 
> > > On Dec 16, 2011, at 2:29 PM, Vivek Goyal wrote:
> > > > Thanks for testing it Nate. I did some debugging and found out that patch
> > > > is doing double free on per cpu pointer hence the crash you are running
> > > > into. I could reproduce this problem on my box. It is just a matter of
> > > > doing rmdir on the blkio cgroup.
> > > > 
> > > > I understood the cmpxchg() semantics wrong. I have fixed it now and
> > > > no crashes on directory removal. Can you please give this version a
> > > > try.
> > > > 
> > > > Thanks
> > > > Vivek
> > > 
> > > After 24 hours of stress testing the machine remains up and working without issue. I will continue to test it, but am reasonably confident that this patch resolves my issue.
> > > 
> > 
> > Hi Nate,
> > 
> > I have come up with final version of the patch. This time I have used non
> > rentrant work queue to queue the stat alloc work. This also gets rid of
> > cmpxchg code as there is only one writer at a time. There are couple of
> > other small cleanups.
> > 
> > Can you please give patch also a try to make sure I have not broken
> > something while doing changes.
> > 
> > This version is based on 3.2-rc6. Once you confirm the results, I will
> > rebase it on top of "linux-block for-3.3/core" and post it to Jens for
> > inclusion.
> > 
> > Thanks
> > Vivek
> > 
> > Block cgroup currently allocates percpu data for some stats. This allocation
> > is happening in IO submission path which can recurse in IO stack.
> > 
> > Percpu allocation API does not take any allocation flags as input, hence
> > to avoid the deadlock problem under memory pressure, alloc per cpu data
> > from a worker thread context.
> > 
> > Only side affect of delayed allocation is that we will lose the blkio cgroup
> > stats for that group a small duration.
> > 
> > In case per cpu memory allocation fails, worker thread re-arms the work
> > with a delay of 1 second.
> > 
> > This patch is generated on top of 3.2-rc6
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Reported-by: Nate Custer <nate@cpanel.net>
> > Tested-by: Nate Custer <nate@cpanel.net>
> 
> Hmmm... I really don't like this approach.  It's so unnecessarily
> complex with extra refcounting and all when about the same thing can
> be achieved by implementing simple mempool which is filled
> asynchronously.  Also, the fix seems way too invasive even for -rc6,
> let alone -stable.  If reverting isn't gonna be invasive, maybe that's
> a better approach for now?

I think reverting the previous series is not going to be simple either. It
had 13 patches.

https://lkml.org/lkml/2011/5/19/560

By making stats per cpu, I was able to reduce contention on request
queue lock. Now we shall have to bring the lock back. 

So to me, neither of the solution is very clean/simple. May be we can take
this patch in as temporary stop gap measure for 3.2, while you cook a
patch for per cpu allocator for 3.3 onwards.

This patch looks big, but is not very complex. Now allocation of group
happens without dropping queue lock and it gets rid of all the trickery
of dropping lock, reacquiring it and checking for queue dead etc.

Some code is related to making group refering atomic again. (Which was
atomic in the past. So we just resotore that functionality).

The only core piece is taking a reference on the group and asking
a worker thread to do the allocation. May be if I break the patch
into small pieces, it will be more clear.

So if I had to choose between reverting the series vs taking this patch
as stop gap measure, I will prefer taking this patch. It can get some
soak time in Jens's tree and if everything looks good then push it for
3.2. If things look good there, then it can be pulled into -stable. So
it will be a while before these changes are pulled into -stable.

> 
> I've been thinking about it and I think the use case is legit and
> maybe making percpu allocator support that isn't such a bad idea.  I'm
> not completely sure yet tho.  I'll give it a try later today.

Ok, that's good to know. If per cpu allocator can support this use case,
it will be good for 3.3 onwards. This seems to be right way to go to fix
the problem.

Thanks
Vivek
