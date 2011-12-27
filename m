Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1L0WII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 17:08:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55619 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab1L0WH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 17:07:58 -0500
Date: Tue, 27 Dec 2011 14:07:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111227220753.GH17712@google.com>
References: <20111222230047.GN17084@google.com>
 <20111222151649.de57746f.akpm@linux-foundation.org>
 <20111222232433.GQ17084@google.com>
 <20111222154138.d6c583e3.akpm@linux-foundation.org>
 <20111223012112.GB12738@redhat.com>
 <20111222173820.3461be5d.akpm@linux-foundation.org>
 <20111223025411.GD12738@redhat.com>
 <20111222191144.78aec23a.akpm@linux-foundation.org>
 <20111223145856.GB16818@redhat.com>
 <20111227132501.ad7f895f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227132501.ad7f895f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 27, 2011 at 01:25:01PM -0800, Andrew Morton wrote:
> umm, we've already declared that it is OK to completely waste this
> memory for the users (probably a majority) who will not be using
> these stats.

We're talking about combinatorial combinations where only small subset
is usually expected to be used and, in addition to the absolute usage,
there's big advantage in showing behavior which users would expect.
If 1000 cgroups are doing IOs to 1000 devices, it's expected to
consume some amount of resource.

The whole io_context / blk_cgroup - request_queue association
mechanism is based on opportunistic allocation.  It might not be the
prettiest thing in the world but given the circumstances IMHO the
approach fits the constraints defined by the problem.

Given the restricted nature of percpu allocation, it would be nice to
punt it to GFP_KERNEL context *somewhere* and for block layer that
somewhere probably can only be userland access.  I just don't see that
fitting better here.  The suggested alternative seems much nastier
with userland visible side effects and possibility for combinatorial
increase in memory usage for something as benign as single cat of stat
files.

Also, such erratic userland visible behavior is deviation from the
current one and at the same time we would be bound to the
idiosyncracies later when we can improve the implementation.

I can't see how that can be a better tradeoff.  It shifts the problem
to even more cumbersome corner.

> Also, has this stuff been tested at that scale?  I fear to think what
> 10000 allocations will do to fragmetnation of the vmalloc() arena.

Percpu allocator doesn't use vmalloc directly.  It maps address ranges
(which is at least 32k and usually much larger) from vmalloc space and
allocate it using simplistic extent allocator.

Thanks.

-- 
tejun
