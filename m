Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1I2T2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:28:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64464 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1I2T2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:28:23 -0400
Date: Thu, 29 Sep 2011 12:28:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
Message-ID: <20110929192818.GB10425@mtj.dyndns.org>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 29, 2011 at 12:02:28PM +0100, Catalin Marinas wrote:
> This patch adds kmemleak callbacks from the percpu allocator, reducing a
> number of false positives caused by kmemleak not scanning such memory
> blocks. The percpu chunks are never reported as leaks because of current
> kmemleak limitations with the __percpu pointer not pointing directly to
> the actual chunks.
...
> @@ -801,7 +804,16 @@ area_found:
>  	mutex_unlock(&pcpu_alloc_mutex);
>  
>  	/* return address relative to base address */
> -	return __addr_to_pcpu_ptr(chunk->base_addr + off);
> +	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
> +
> +	/*
> +	 * Percpu allocations are currently reported as leaks (kmemleak false
> +	 * positives). To avoid this, just set min_count to 0.
> +	 */
> +	for_each_possible_cpu(cpu)
> +		kmemleak_alloc(per_cpu_ptr(ptr, cpu), size, 0, GFP_KERNEL);
> +
> +	return ptr;

I'm pretty ignorant about kmemleak but it scans memories looking for
references to allocated objects, right?  There currently is no way for
such scanner to tell a percpu pointer in memory from a regular pointer
making it impossible to track percpu objects properly from kmemleak.
If my understanding is correct, I don't see much point in tracking
each percpu alloc/free.  Why not just mark all pages taken by percpu
allocator as untrackable?

If we want to track percpu memory leak properly, I think we'll need
more invasive changes.  If kmemleak is enabled, we can offset percpu
pointer so that the scanner can tell percpu pointers and then kmemleak
should properly account for all percpu areas pointed to by the percpu
pointer.  Hmmm... or, alternatively, we can make kmemleak only track
allocations for the first possible cpu and ignore all the rest and
modify percpu such that percpu pointer points to the actual address of
the first cpu if kmemleak is enabled.

Thank you.

-- 
tejun
