Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab2EIQKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:10:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47196 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346Ab2EIQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:10:46 -0400
Date: Wed, 9 May 2012 16:55:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sami Liedes <sami.liedes@iki.fi>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: kmemleak: Cannot insert 0xffff880007fedd28 into the object
 search tree (already existing)
Message-ID: <20120509155519.GL11099@arm.com>
References: <20120506160828.GE13332@sli.dy.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506160828.GE13332@sli.dy.fi>
Thread-Topic: kmemleak: Cannot insert 0xffff880007fedd28 into the object
 search tree (already existing)
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 05:08:28PM +0100, Sami Liedes wrote:
> While trying to use kmemleak in KVM/x86-64 on mainline 3.3.4, I'm
> running into this error (whole preceding dmesg below):
> 
> [    2.251741] kmemleak: Cannot insert 0xffff880007fedd28 into the object search tree (already existing)
> ...
> [    2.252016] kmemleak: Kernel memory leak detector disabled

It looks like its caused by the percpu memory allocations. The set up
areas must be freed but I only did it for SMP systems, forgot about UP.
Please find a patch below.

> I tested this on some older kernels too; at least v2.6.37 behaves the
> same, i.e. I get the same kmemleak error, though not the lockdep
> warnings.

This happens on the kmemleak disable path which is called with the
kmemleak_lock acquired. I'll have a look and move the clean-up thread
scheduling around.

Thanks.

----------------8<---------------------------------------------

commit 631d16e6284ddecd9d261f929582244f6757b678
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Wed May 9 16:45:46 2012 +0100

    kmemleak: Fix the kmemleak tracking of the percpu areas with !SMP
    
    Kmemleak tracks the percpu allocations via a specific API and the
    originally allocated areas must be removed from kmemleak (via
    kmemleak_free). The code was already doing this for SMP systems.
    
    Reported-by: Sami Liedes <sami.liedes@iki.fi>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Christoph Lameter <cl@linux-foundation.org>
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/mm/percpu.c b/mm/percpu.c
index f47af91..2daf6d5 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1885,6 +1885,8 @@ void __init setup_per_cpu_areas(void)
 	fc = __alloc_bootmem(unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
+	/* kmemleak tracks the percpu allocations separately */
+	kmemleak_free(fc);
 
 	ai->dyn_size = unit_size;
 	ai->unit_size = unit_size;

-- 
Catalin
