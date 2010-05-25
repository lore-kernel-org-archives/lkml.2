Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab0EYKH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:07:57 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab0EYKHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:07:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=AGk7Nl+gAMJTzxhUViuKPLDqJercgWnRWH7ukpF939jobc1t/DM7yVKhDnESK7YlG
	2nlfIDsDWqELfMshsLgqw==
Date: Tue, 25 May 2010 03:07:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
In-Reply-To: <20100525081634.GE5087@laptop>
Message-ID: <alpine.DEB.2.00.1005250303040.8045@chino.kir.corp.google.com>
References: <20100521211452.659982351@quilx.com> <20100524070309.GU2516@laptop> <alpine.DEB.2.00.1005240852580.5045@router.home> <20100525020629.GA5087@laptop> <AANLkTik2O-_Fbh-dq0sSLFJyLU7PZi4DHm85lCo4sugS@mail.gmail.com> <20100525070734.GC5087@laptop>
 <AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com> <20100525081634.GE5087@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Nick Piggin wrote:

> I don't think SLUB ever proved itself very well. The selling points
> were some untestable handwaving about how queueing is bad and jitter
> is bad, ignoring the fact that queues could be shortened and periodic
> reaping disabled at runtime with SLAB style of allocator. It also
> has relied heavily on higher order allocations which put great strain
> on hugepage allocations and page reclaim (witness the big slowdown
> in low memory conditions when tmpfs was using higher order allocations
> via SLUB).
> 

I agree that the higher order allocations is a major problem and slub 
relies heavily on them for being able to utilize both the allocation and 
freeing fastpaths for a number of caches.  For systems with a very large 
amount of memory that isn't fully utilized and fragmentation isn't an 
issue, this works fine, but for users who use all their memory and do some 
amount of reclaim it comes at a significant cost.  The cpu slab thrashing 
problem that I identified with the netperf TCP_RR benchmark can be heavily 
reduced by tuning certain kmalloc caches to allocate higher order slabs, 
but that makes it very difficult to run with hugepages and the allocation 
slowpath even slower.  There are commandline workarounds to prevent slub 
from using these higher order allocations, but the performance of the 
allocator then suffers as a result.

> SLUB has not been able to displace SLAB for a long timedue to
> performance and higher order allocation problems.
> 

Completely agreed.
