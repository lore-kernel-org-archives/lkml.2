Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab1I2RVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:21:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45301 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183Ab1I2RVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:21:12 -0400
Date: Thu, 29 Sep 2011 18:17:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li.lee@gmail.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
Message-ID: <20110929171713.GK32023@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
 <1317297373.2855.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317297373.2855.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:56:13PM +0100, Eric Dumazet wrote:
> Le jeudi 29 septembre 2011 à 12:02 +0100, Catalin Marinas a écrit :
> > This patch adds kmemleak callbacks from the percpu allocator, reducing a
> > number of false positives caused by kmemleak not scanning such memory
> > blocks. The percpu chunks are never reported as leaks because of current
> > kmemleak limitations with the __percpu pointer not pointing directly to
> > the actual chunks.
> > 
> > Reported-by: Huajun Li <huajun.li.lee@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>,
> > Cc: Christoph Lameter <cl@linux-foundation.org>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> 
> I wonder if you tried it on a 16 or 64 cpus machine ?

I only tried on a 4-CPU system and the early log allocations went form
under 400 to nearly 800.

> I guess we should increase CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE default
> 
> Or you could add new kmemleak_percpu_alloc() / kmemleak_percpu_free()
> primitives to not waste entries in early_log[]

If we don't track them in early_log[] before kmemleak is initialised,
they aren't tracked at all so we end up pretty much in the same
situations.

A better approach would be to tell kmemleak about the __percpu pointer
via some additional API (or some other way to detect that it's a
__percpu pointer) and kmemleak would do the for_each_possible_cpu()
conversion when scanning.

The question - can we guarantee that the __percpu pointer returned by
alloc_percpu() does not overlap with some memory block allocated
elsewhere? At least for the first chunk it seems to overlap with the
percpu data section, which is fine as that's not added in kmemleak as an
allocated block.

Allowing overlapping blocks in kmemleak may be a solution but it's not
implemented yet.

-- 
Catalin
