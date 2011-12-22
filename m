Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1LVWya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:54:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1LVWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:54:27 -0500
Date: Thu, 22 Dec 2011 14:54:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222145426.5844df96.akpm@linux-foundation.org>
In-Reply-To: <20111222224117.GL17084@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111222224117.GL17084@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 14:41:17 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Thu, Dec 22, 2011 at 02:20:58PM -0800, Andrew Morton wrote:
> > Don't just consider my suggestions - please try to come up with your own
> > alternatives too!  If all else fails then this patch is a last resort.
> 
> Umm... this is my alternative.

We're beyond the point where aany additional kernel complexity should
be considered a regression.

> > > but apparently those percpu stats reduced
> > > CPU overhead significantly.
> > 
> > Deleting them would save even more CPU.
> > 
> > Or make them runtime or compile-time configurable, so only the
> > developers see the impact.
> > 
> > Some specifics on which counters are causing the problems would help here.
> 
> These stats are userland visible and quite useful ones if blkcg is in
> use.  I don't really see how these can be removed.

What stats?

And why are we doing percpu *allocation* so deep in the code?  You mean
we're *creating* stats counters on an IO path?  Sounds odd.  Where is
this code?

> > > > Or how about we fix the percpu memory allocation code so that it
> > > > propagates the gfp flags, then delete this patchset?
> > > 
> > > Oh, no, this is gonna make things *way* more complex.  I tried.
> > 
> > But there's a difference between fixing a problem and working around it.
> 
> Yeah, that was my first direction too.  The reason why percpu can't do
> NOIO is the same one why vmalloc can't do it.  It reaches pretty deep
> into page table code and I don't think doing all that churning is
> worthwhile or even desirable.  An altnernative approach would be
> implementing transparent front buffer to percpu allocator, which I
> *might* do if there really are more of these users, but I think
> keeping percpu allocator painful to use from reclaim context isn't
> such a bad idea.
> 
> There have been multiple requests for atomic allocation and they all
> have been successfully pushed back, but IMHO this is a valid one and I
> don't see a better way around the problem, so while I agree using
> mempool for this is a workaround, I think it is a right choice, for
> now, anyway.

For starters, doing pagetable allocation on the I/O path sounds nutty.

Secondly, GFP_NOIO is a *weaker* allocation mode than GFP_KERNEL.  By
permitting it with this patchset, we have a kernel which is more likely
to get oom failures.  Fixing the kernel to not perform GFP_NOIO
allocations for these counters will result in a more robust kernel. 
This is a good thing, which improves the kernel while avoiding adding
more compexity elsewhere.

This patchset is the worst option and we should try much harder to avoid
applying it!

> > > If we're gonna have many more NOIO percpu users, which I don't
> > > think we would or should, that might make sense but, for fringe
> > > cases, extending mempool to cover percpu is a much better sized
> > > solution.
> > 
> > I've long felt that we goofed with the gfp_flags thing and that it
> > should be a field in the task_struct.  Now *that* would be a large
> > patch!
> 
> Yeah, some of PF_* flags already carry related role information.  I'm
> not too sure how much pushing the whole thing into task_struct would
> change tho.  We would need push/popping.  It could be simpler in some
> cases but in essence wouldn't we have just relocated the position of
> parameter?

The code would get considerably simpler.  The big benefit comes when
you have deep call stacks - we're presently passing a gfp_t down five
layers of function call while none of the intermediate functions even
use the thing - they just pass it on to the next guy.  Pass it via the
task_struct and all that goes away.  It would make maintenance a lot
easier - at present if you want to add a new kmalloc() to a leaf
function you need to edit all five layers of caller functions.
