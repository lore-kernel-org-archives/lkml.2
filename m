Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1LSRf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:35:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42132 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1LSRfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:35:24 -0500
Date: Mon, 19 Dec 2011 09:35:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nate Custer <nate@cpanel.net>, Jens Axboe <axboe@kernel.dk>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH] blkio: alloc per cpu data from worker thread
 context( Re: kvm deadlock)
Message-ID: <20111219173519.GL24519@google.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111215194712.GA11194@redhat.com>
 <E73DB38E-AFC5-445D-9E76-DE599B36A814@cpanel.net>
 <20111216202907.GH7586@redhat.com>
 <C1FB7932-7722-4160-8206-765B08EA5911@cpanel.net>
 <20111219172717.GB7175@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219172717.GB7175@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 12:27:17PM -0500, Vivek Goyal wrote:
> On Sun, Dec 18, 2011 at 03:25:48PM -0600, Nate Custer wrote:
> > 
> > On Dec 16, 2011, at 2:29 PM, Vivek Goyal wrote:
> > > Thanks for testing it Nate. I did some debugging and found out that patch
> > > is doing double free on per cpu pointer hence the crash you are running
> > > into. I could reproduce this problem on my box. It is just a matter of
> > > doing rmdir on the blkio cgroup.
> > > 
> > > I understood the cmpxchg() semantics wrong. I have fixed it now and
> > > no crashes on directory removal. Can you please give this version a
> > > try.
> > > 
> > > Thanks
> > > Vivek
> > 
> > After 24 hours of stress testing the machine remains up and working without issue. I will continue to test it, but am reasonably confident that this patch resolves my issue.
> > 
> 
> Hi Nate,
> 
> I have come up with final version of the patch. This time I have used non
> rentrant work queue to queue the stat alloc work. This also gets rid of
> cmpxchg code as there is only one writer at a time. There are couple of
> other small cleanups.
> 
> Can you please give patch also a try to make sure I have not broken
> something while doing changes.
> 
> This version is based on 3.2-rc6. Once you confirm the results, I will
> rebase it on top of "linux-block for-3.3/core" and post it to Jens for
> inclusion.
> 
> Thanks
> Vivek
> 
> Block cgroup currently allocates percpu data for some stats. This allocation
> is happening in IO submission path which can recurse in IO stack.
> 
> Percpu allocation API does not take any allocation flags as input, hence
> to avoid the deadlock problem under memory pressure, alloc per cpu data
> from a worker thread context.
> 
> Only side affect of delayed allocation is that we will lose the blkio cgroup
> stats for that group a small duration.
> 
> In case per cpu memory allocation fails, worker thread re-arms the work
> with a delay of 1 second.
> 
> This patch is generated on top of 3.2-rc6
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reported-by: Nate Custer <nate@cpanel.net>
> Tested-by: Nate Custer <nate@cpanel.net>

Hmmm... I really don't like this approach.  It's so unnecessarily
complex with extra refcounting and all when about the same thing can
be achieved by implementing simple mempool which is filled
asynchronously.  Also, the fix seems way too invasive even for -rc6,
let alone -stable.  If reverting isn't gonna be invasive, maybe that's
a better approach for now?

I've been thinking about it and I think the use case is legit and
maybe making percpu allocator support that isn't such a bad idea.  I'm
not completely sure yet tho.  I'll give it a try later today.

Thank you.

-- 
tejun
