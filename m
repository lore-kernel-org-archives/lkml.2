Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0F2Eog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 00:44:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42843 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0F2Eof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 00:44:35 -0400
Date: Tue, 29 Jun 2010 07:44:23 +0300 (EEST)
Message-Id: <20100629.074423.71111160.Hiroshi.DOYU@nokia.com>
To: catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <1277736372.25271.102.camel@e102109-lin.cambridge.arm.com>
References: <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
	<1277736372.25271.102.camel@e102109-lin.cambridge.arm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2010 04:44:25.0627 (UTC) FILETIME=[C04746B0:01CB1745]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ext Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
Date: Mon, 28 Jun 2010 16:46:12 +0200

> Hi,
> 
> (and sorry for the delay)
> 
> On Fri, 2010-06-18 at 07:04 +0100, Hiroshi DOYU wrote:
>> This is another version of "kmemleak: Fix false positive", which
>> introduces another alias tree to keep track of all alias address of
>> each objects, based on the discussion(*1)
>> 
>> You can also find the previous one(*2), which uses special scan area
>> for alias addresses with a conversion function.
>> 
>> Compared with both methods, it seems that the current one takes a bit
>> longer to scan as below, tested with 512 elementes of (*3).
>> 
>> "kmemleak: Fix false positive with alias":
>> # time echo scan > /mnt/kmemleak
>> real    0m 8.40s
>> user    0m 0.00s
>> sys     0m 8.40s
>> 
>> "kmemleak: Fix false positive with special scan":
>> # time echo scan > /mnt/kmemleak
>> real    0m 3.96s
>> user    0m 0.00s
>> sys     0m 3.96s
> 
> Have you tried without your patches (just the test module but without
> aliasing the pointers)? I'm curious what's the impact of your first set
> of patches.

IIRC, not much difference against the one with the first patches. I'll
measure it again later.

>> For our case(*4) to reduce false positives for the 2nd level IOMMU
>> pagetable allocation, the previous special scan  seems to be enough
>> lightweight, although there might be possiblity to improve alias
>> one and also I might misunderstand the original proposal of aliasing.
> 
> The performance impact is indeed pretty high, though some parts of the
> code look over-engineered to me (the __scan_block function with a loop
> going through an array of two function pointers - I think the compiler
> cannot figure out what to inline). You could just extend the
> find_and_get_object() to search both trees under a single spinlock
> region (as locking also takes time).

Ok, a good point.

> Anyway, you still get to search two trees for any pointer so there would
> always be some performance impact. I just hoped they weren't be as bad.
> In a normal system (not test module), how many elements would the alias
> tree have?

Just in our case, it's 512 at most.

> Another approach - if we assume that there is a single alias per object
> and such aliases don't overlap, we could just move (delete + re-insert)
> the corresponding kmemleak_object in the tree to the alias position.
> This way we only keep a single tree and a single object for an allocated
> block. But in your use-case, the physical address of an object may
> actually match the virtual address of a different object, so
> lookup_object() needs to be iterative. You need two new kmemleak API
> functions, e.g. kmemleak_alias() and kmemleak_unalias(), to be called
> after allocation and before freeing a memory block.
>
> If we can't make the performance hit acceptable, we could go for the
> first approach and maybe just extend kmemleak_scan_area with a function
> pointer structure rather than adding a new one. But as I said
> previously, my main issue with your original approach is that I would
> prefer to call the kmemleak API at the point where the false positive is
> allocated rather than where the parent object was.

I'll try both and measure their impact again. Thank you for your comment.
