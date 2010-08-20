Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0HTQR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:17:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40451 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab0HTQRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:17:17 -0400
Message-ID: <4C6EAA48.7070902@zytor.com>
Date: Fri, 20 Aug 2010 09:16:08 -0700
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
References: <20100818183024.GZ3043@sgi.com> <4C6DB62C.9040105@zytor.com> <20100820135822.GA3220@sgi.com> <20100820150319.GB3220@sgi.com>
In-Reply-To: <20100820150319.GB3220@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 08:03 AM, Robin Holt wrote:
> 
> In short, without the cpu information, I think we are heading back to
> as much of a kludge as I had originally submitted.  We could assume
> the number of sets will always be less than some large value like 16MB,
> but that runs the risk of wasting a large amount of memory.
> 
> Alternatively, we could base the color value upon something very concrete.
> For this particular allocation, we have an array of structures whose
> elements are 1792 bytes long (28 cache lines).  If I specify an offset
> of 29, it merely means the first element of my newly allocated array
> is now going to collide with the first allocation's second element.
> I really see no advantage to further allocating space.  The advantage
> to this method is it entirely removes the processor configuration from
> the question.  It allows me to keep the offset calculation from polluting
> the e820 allocator as well.  Basically, the change remains localized.
> 

That's pretty much the idea, really.  However, I don't think you can
localize the change without making invalid assumptions of the behavior
of lower primitives, which given that changes are in progress will cause
serious problems.

The issue here is that the e820 allocator (which is about to be axed,
but its successor will need to support similar operations) has a few
parameters that it takes in: (start, end, size, alignment).  It will
return a block at address (addr) fulfilling the requirements:

	start <= addr
	addr+size <= end
	(addr % alignment) == 0

However, for coloring (which is what you're doing here, coloring doesn't
have to be precise) what you really want is for the last constraint to
read like:

	start <= addr
	addr+size <= end
	(addr % alignment) == offset

You can leave your alignment some arbitrarily large value (in the case
of your 1792-byte structure, you can make the observation that
1792*4096 < 8 MiB) and the alignment is simply 1792*(node number).  This
will over-color massively, of course, *but you're not allocating memory
you don't need* and so it doesn't really matter.

However, this does mean that there is a need to be able to pass the
offset parameter down to the allocator.  Not doing that will either mean
wasting huge amount of memory or relying on internal behavior of the
allocator which is already scheduled to change.

Does this make sense?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

