Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0HWVms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:42:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57750 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab0HWVmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:42:46 -0400
Message-ID: <4C72EB41.9000002@zytor.com>
Date: Mon, 23 Aug 2010 14:42:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Jack Steiner <steiner@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes for_each_populated_zone
 extremely expensive -V2.
References: <20100818183024.GZ3043@sgi.com> <4C6DB62C.9040105@zytor.com> <20100820135822.GA3220@sgi.com> <20100820150319.GB3220@sgi.com> <4C6EAA48.7070902@zytor.com> <20100821130757.GC3220@sgi.com>
In-Reply-To: <20100821130757.GC3220@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2010 06:07 AM, Robin Holt wrote:
> 
> It does make sense.
> 
> I am not sure how to proceed.  You are saying the e820 allocator is
> being replaced.  Yet, this is the allocator used for this section of code.
> I feel sort of foolish to tweak the e820 allocator to allow for handling
> color only to have it replaced in the near future.
> 
> Add to that this simple fix is enough to break up the most egregious
> problem which is the scanning of all zones in the system and checking
> that zone's pages_present.  If this is adequate, would you accept
> this simple patch for now and place expectations on adjusting the e820
> replacement allocator later to support color with a simple patch to fix
> up the node_data allocations later?
> 

No, this isn't really the right way to go about it.

The whole point is to avoid reliance on undocumented side effects of the
specific implementations of an interface.  That means creating a new
interface with the desired semantics, instead of creating a "local"
patch which happens to work for the current implementation -- and which
will break silently when the new implementation of the interface is
created, and which means the new implementation will be seen as causing
a performance regression.

So yes, this means adding an interface to the e820 allocator, even
though it's scheduled to be replaced.  Because the new implementation
will see the new interface and know they have to implement it, and the
interface will make it clear just what exactly is expected of the
implementation.

So therefore I will not accept your "simple" patch, exactly because it
really isn't simple at all.

	-hpa
