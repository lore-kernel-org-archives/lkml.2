Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1L0WWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 17:22:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44920 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1L0WW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 17:22:28 -0500
Date: Tue, 27 Dec 2011 14:22:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111227222223.GI17712@google.com>
References: <20111222230047.GN17084@google.com>
 <20111222151649.de57746f.akpm@linux-foundation.org>
 <20111222232433.GQ17084@google.com>
 <20111222154138.d6c583e3.akpm@linux-foundation.org>
 <20111222235455.GT17084@google.com>
 <20111222171432.e429c041.akpm@linux-foundation.org>
 <20111227183402.GF17712@google.com>
 <20111227132056.44ee9281.akpm@linux-foundation.org>
 <20111227214421.GG17712@google.com>
 <20111227135836.7102f41b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227135836.7102f41b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Tue, Dec 27, 2011 at 01:58:36PM -0800, Andrew Morton wrote:
> >  But that would
> > involved a lot more churn and complexity without much added benefit,
> > given that this type of use cases aren't expected to be common - and
> > I'm fairly sure it isn't given track record of past few years.
> 
> I don't think it would be too hard to add an alloc_percpu_gfp().  Add
> the gfp_t to a small number of functions (two or three?) then change
> pcpu_mem_zalloc() to always use kzalloc() if (flags & GFP_KERNEL !=
> GFP_KERNEL).  And that's it?

Hmmm... What do you mean "always use kzalloc()"?  Percpu memory can't
be served by kzalloc().  They need to be congruent.

Currently, percpu allocation happens in two stages.  The first stage
is locating congruent address areas in vmalloc space (so that static
percpu offsets among different CPUs can be maintained for dynamic
percpu areas).  The second stage is actually allocating pages and
populating those areas.  Because percpu memory is expensive, the
allocator keeps both steps on demand.  When it runs out of address
space, it gets some and the addresses are filled only when the memory
areas are actually handed out.

Unfortunately, both steps involve vmalloc machinery and GFP_KERNEL
assumption reaches into arch specific code for page table allocation.
So, making all those steps reclaim path friendly would be quite a
churn.

*If* we're gonna solve this at the allocator level, we'll probably end
up with front buffer in percpu allocator, which buffers populated
percpu areas to give out for reclaim path allocations, which is
doable, would involve a lot more complexity and would probably need to
keep more percpu memory reserved to stay generic.

> But the question is: is this a *good* thing to do?  It would be nice if
> kernel developers understood that GFP_KERNEL is strongly preferred and
> that they should put in effort to use it.  But there's a strong
> tendency for people to get themselves into a sticky corner then take
> the easy way out, resulting in less robust code.  Maybe calling the
> function alloc_percpu_i_really_suck() would convey the hint.

I fully agree and have been pushing back pretty hard against people
trying to allocate percpu memory from !GFP_KERNEL context and I want
to keep it that way.  But, to me, this one seems like a valid use
case.  If we want to track dynamic associations in IO path, short of
allocating for all combinatorial combinations, we can't avoid
performing NOIO allocations.  Of course, the code path should be
careful so that it's not too demanding on the allocator and must be
able to degrade operation gracefully on allocation failures.  It's a
special case but a valid one at that.

Thanks.

-- 
tejun
