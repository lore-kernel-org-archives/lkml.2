Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab1I3Imo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:42:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41369 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707Ab1I3Iml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:42:41 -0400
Date: Fri, 30 Sep 2011 09:37:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li.lee@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
Message-ID: <20110930083706.GB22300@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
 <20110929192818.GB10425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929192818.GB10425@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thu, Sep 29, 2011 at 08:28:18PM +0100, Tejun Heo wrote:
> On Thu, Sep 29, 2011 at 12:02:28PM +0100, Catalin Marinas wrote:
> > This patch adds kmemleak callbacks from the percpu allocator, reducing a
> > number of false positives caused by kmemleak not scanning such memory
> > blocks. The percpu chunks are never reported as leaks because of current
> > kmemleak limitations with the __percpu pointer not pointing directly to
> > the actual chunks.
> ...
> > @@ -801,7 +804,16 @@ area_found:
> >  	mutex_unlock(&pcpu_alloc_mutex);
> >  
> >  	/* return address relative to base address */
> > -	return __addr_to_pcpu_ptr(chunk->base_addr + off);
> > +	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
> > +
> > +	/*
> > +	 * Percpu allocations are currently reported as leaks (kmemleak false
> > +	 * positives). To avoid this, just set min_count to 0.
> > +	 */
> > +	for_each_possible_cpu(cpu)
> > +		kmemleak_alloc(per_cpu_ptr(ptr, cpu), size, 0, GFP_KERNEL);
> > +
> > +	return ptr;
> 
> I'm pretty ignorant about kmemleak but it scans memories looking for
> references to allocated objects, right?  There currently is no way for
> such scanner to tell a percpu pointer in memory from a regular pointer
> making it impossible to track percpu objects properly from kmemleak.
> If my understanding is correct, I don't see much point in tracking
> each percpu alloc/free.  Why not just mark all pages taken by percpu
> allocator as untrackable?

That's pretty much the current behaviour (apart from embedded chunk).
The problem is that percpu blocks may contain references to other memory
blocks and if they are not found it leads to false positives. So rather
than marking each individual false positive as such, we could add
tracking support to percpu allocations.

> If we want to track percpu memory leak properly, I think we'll need
> more invasive changes.  If kmemleak is enabled, we can offset percpu
> pointer so that the scanner can tell percpu pointers and then kmemleak
> should properly account for all percpu areas pointed to by the percpu
> pointer.

Or we could just extend the kmemleak API to tell it's a percpu pointer
(e.g. kmemleak_alloc_percpu).

> Hmmm... or, alternatively, we can make kmemleak only track
> allocations for the first possible cpu and ignore all the rest and
> modify percpu such that percpu pointer points to the actual address of
> the first cpu if kmemleak is enabled.

This would solve the kmemleak issues with overlapping memory blocks.
I'll try to come up with a patch and see how feasible it is.

Thanks.

-- 
Catalin
