Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0F1OqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:46:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65422 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab0F1OqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:46:21 -0400
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org
In-Reply-To: <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
References: <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 28 Jun 2010 15:46:12 +0100
Message-ID: <1277736372.25271.102.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2010 14:46:12.0508 (UTC) FILETIME=[A73E55C0:01CB16D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(and sorry for the delay)

On Fri, 2010-06-18 at 07:04 +0100, Hiroshi DOYU wrote:
> This is another version of "kmemleak: Fix false positive", which
> introduces another alias tree to keep track of all alias address of
> each objects, based on the discussion(*1)
> 
> You can also find the previous one(*2), which uses special scan area
> for alias addresses with a conversion function.
> 
> Compared with both methods, it seems that the current one takes a bit
> longer to scan as below, tested with 512 elementes of (*3).
> 
> "kmemleak: Fix false positive with alias":
> # time echo scan > /mnt/kmemleak
> real    0m 8.40s
> user    0m 0.00s
> sys     0m 8.40s
> 
> "kmemleak: Fix false positive with special scan":
> # time echo scan > /mnt/kmemleak
> real    0m 3.96s
> user    0m 0.00s
> sys     0m 3.96s

Have you tried without your patches (just the test module but without
aliasing the pointers)? I'm curious what's the impact of your first set
of patches.

> For our case(*4) to reduce false positives for the 2nd level IOMMU
> pagetable allocation, the previous special scan  seems to be enough
> lightweight, although there might be possiblity to improve alias
> one and also I might misunderstand the original proposal of aliasing.

The performance impact is indeed pretty high, though some parts of the
code look over-engineered to me (the __scan_block function with a loop
going through an array of two function pointers - I think the compiler
cannot figure out what to inline). You could just extend the
find_and_get_object() to search both trees under a single spinlock
region (as locking also takes time).

Anyway, you still get to search two trees for any pointer so there would
always be some performance impact. I just hoped they weren't be as bad.
In a normal system (not test module), how many elements would the alias
tree have?

Another approach - if we assume that there is a single alias per object
and such aliases don't overlap, we could just move (delete + re-insert)
the corresponding kmemleak_object in the tree to the alias position.
This way we only keep a single tree and a single object for an allocated
block. But in your use-case, the physical address of an object may
actually match the virtual address of a different object, so
lookup_object() needs to be iterative. You need two new kmemleak API
functions, e.g. kmemleak_alias() and kmemleak_unalias(), to be called
after allocation and before freeing a memory block.

If we can't make the performance hit acceptable, we could go for the
first approach and maybe just extend kmemleak_scan_area with a function
pointer structure rather than adding a new one. But as I said
previously, my main issue with your original approach is that I would
prefer to call the kmemleak API at the point where the false positive is
allocated rather than where the parent object was.

Thanks for working on this. Regards.

-- 
Catalin

