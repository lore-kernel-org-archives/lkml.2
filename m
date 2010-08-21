Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0HUNIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:08:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48094 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032Ab0HUNID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:08:03 -0400
Date: Sat, 21 Aug 2010 08:07:57 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive -V2.
Message-ID: <20100821130757.GC3220@sgi.com>
References: <20100818183024.GZ3043@sgi.com>
 <4C6DB62C.9040105@zytor.com>
 <20100820135822.GA3220@sgi.com>
 <20100820150319.GB3220@sgi.com>
 <4C6EAA48.7070902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6EAA48.7070902@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The issue here is that the e820 allocator (which is about to be axed,
> but its successor will need to support similar operations) has a few
> parameters that it takes in: (start, end, size, alignment).  It will
> return a block at address (addr) fulfilling the requirements:
> 
> 	start <= addr
> 	addr+size <= end
> 	(addr % alignment) == 0
> 
> However, for coloring (which is what you're doing here, coloring doesn't
> have to be precise) what you really want is for the last constraint to
> read like:
> 
> 	start <= addr
> 	addr+size <= end
> 	(addr % alignment) == offset
> 
> You can leave your alignment some arbitrarily large value (in the case
> of your 1792-byte structure, you can make the observation that
> 1792*4096 < 8 MiB) and the alignment is simply 1792*(node number).  This
> will over-color massively, of course, *but you're not allocating memory
> you don't need* and so it doesn't really matter.
> 
> However, this does mean that there is a need to be able to pass the
> offset parameter down to the allocator.  Not doing that will either mean
> wasting huge amount of memory or relying on internal behavior of the
> allocator which is already scheduled to change.
> 
> Does this make sense?

It does make sense.

I am not sure how to proceed.  You are saying the e820 allocator is
being replaced.  Yet, this is the allocator used for this section of code.
I feel sort of foolish to tweak the e820 allocator to allow for handling
color only to have it replaced in the near future.

Add to that this simple fix is enough to break up the most egregious
problem which is the scanning of all zones in the system and checking
that zone's pages_present.  If this is adequate, would you accept
this simple patch for now and place expectations on adjusting the e820
replacement allocator later to support color with a simple patch to fix
up the node_data allocations later?

Thanks,
Robin
