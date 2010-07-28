Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0G1GXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:23:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59015 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab0G1GXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:23:37 -0400
Message-ID: <4C4FCCB6.3030003@zytor.com>
Date: Tue, 27 Jul 2010 23:22:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org> <1280295415.1970.245.camel@pasglop>
In-Reply-To: <1280295415.1970.245.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 10:36 PM, Benjamin Herrenschmidt wrote:
> 
> It's very gross to have this weak and not memblock_find_base()... IE. 
> 
> You create a new function defined as a wrapper on an existing one to
> provide an easier set of arguments ... but also make it weak so the
> arch can completely change its semantics without actually changing
> the semantics of the function it wraps.
> 
> This is going to cause confusion and bugs. I'm adding the patch without
> the weak bit to my branch for now, we need to discuss what is the best
> approach for x86 here. Might be to use a different function. I don't
> understand yet -why- x86 needs to override it, maybe the right way is
> to reserve things more intelligently on x86 ?
> 
> In any case, you can always use your own wrapper there if needed
> 

I'm really confused by this as well.  First of all this only looks like
a prototype which swizzles the argument order, which is a good start for
making problems.

The second thing is that the proposed x86 code seems to do something I
would consider to be a core service, which is find an allocation outside
any reserved region, but it does so by looking at two different data
structures.  Instead the logical thing would be to knock a reserved
block out of the available set, so that there is always a data structure
which contains the currently free and available memory.  I think the
best thing would be if the same data structure could also handle
reserved memory types (by carrying an attribute), but if that is not
possible, there can be a reserved memblock structure and an available
memblock structure, alternatively (and equivalently) an "all memory"
memblock structure and an available memblock structure, but unavailable
memory should not be in the available structure.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

