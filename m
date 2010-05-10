Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0EJOdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:33:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64390 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab0EJOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:33:09 -0400
Subject: Re: [RFC PATCH] Update the cachetlb.txt file WRT
 flush_dcache_pageand update_mmu_cache
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       benh@kernel.crashing.org, rmk@arm.linux.org.uk
In-Reply-To: <20100510.070326.146087861.davem@davemloft.net>
References: <20100510.070326.146087861.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 10 May 2010 15:32:55 +0100
Message-ID: <1273501975.10282.57.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2010 14:32:56.0119 (UTC) FILETIME=[AE514470:01CAF04D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Mon, 10 May 2010 15:00:10 +0100
> 
> > 3rd point above would help with the D-cache aliasing. Does the I/D cache
> > coherency need to be handled differently? On PIPT Harvard architectures,
> > we don't actually have D-cache aliasing but we may end up flushing too
> > much in kunmap() just in case such page would be mapped in user space
> > with executable permission.
> 
> You can handle this by having an "I-cache clean" bit in the page.
> When you kmap/kunmap, simply force this bit clear.
> 
> In update_mmu_cache() or set_pte_at() you'll see when a page gets
> into userspace with execute permission, and if the I-cache bit
> is clear you can do the flush then and set the "I-cache clean"
> bit.

If calling kmap on a new page cache page that hasn't been mapped in user
space, such bit is already cleared anyway. But would the kernel ever
kmap a page already mapped in user space without calling
flush_dcache_page? Ideally we shouldn't have to implement the kmap API
for architectures with highmem disabled.

What I'm trying to achieve is to get an agreement between architectures
and use the the cachetlb.txt document as a central recommendation point
for how cache flushing should be handled (we've had such issues on ARM
for quite some time).

The main problems with the arch/arm/ implementation and how we probably
understood cachetlb.txt:

     1. flush_dcache_page() isn't always called on page cache pages that
        were written to (and which are subsequently mapped in user
        space)
     2. kmap/kunmap isn't always used in PIO drivers (sometimes just
        normal pages)
     3. deferring the cache flushing to update_mmu_cache() doesn't work
        on SMP systems with hardware TLB implementation (a different CPU
        could see the PTE before the cache flushing occurred). The
        set_pte_at() would be a better place for this

Thanks.

-- 
Catalin

