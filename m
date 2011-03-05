Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1CEH5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 02:57:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:55295 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab1CEH5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 02:57:06 -0500
Subject: Re: [RFC] memblock; Properly handle overlaps
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <4D71CE24.1090302@kernel.org>
References: <1299297946.8833.931.camel@pasglop>
	 <4D71CE24.1090302@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 18:56:28 +1100
Message-ID: <1299311788.8833.937.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 21:46 -0800, Yinghai Lu wrote:
> On 03/04/2011 08:05 PM, Benjamin Herrenschmidt wrote:
> > Hi folks !
> > 
> > This is not fully tested yet (I'm toying with a little userspace
> > test bench, it seems to work well so far but I haven't yet tested
> > the cases with no-coalesce boundaries which at least ARM needs).
> > 
> > But it's good enough to get comments...
> > 
> > So currently, things like memblock_reserve() or memblock_free()
> > don't deal well -at-all- with overlaps of all kinds. Some specific
> > cases are handled but the code is clumsy and things will fall over
> > in many cases.
> > 
> > This is annoying because typically memblock_reserve() is used to
> > mark regions passed by the firmware as reserved and we all know
> > how much we can trust our firmwares right ?
> > 
> > I have also a case I need to deal with on powerpc where the flat
> > device-tree is fully enclosed within some other FW blob that has
> > its own reserve map entry, so when I end up trying to reserve
> > both, the current memblock code pukes.
> 
> did you try remove and add tricks?

Yes, and it's a band-wait on top of a wooden leg... (didn't even work
properly for some real cases I hit with bad FW data, ended up with two
regions once reserving a portion of the previous one). It doesn't take
long starting at the implementation of remove() to understand why :-)

Also, if something like that happens, you expose yourself to rampant
corruption and other very hard to debug problems, because nothing will
tell you that the array is corrupted (no longer a monotonic progression)
and you might get overlapping allocations, allocations spanning reserved
regions etc... all silently.

I think the whole thing was long overdue for an overhaul. Hopefully, my
new code is -much- more robust under all circumstances of full overlap,
partial overlap, freeing entire regions with multiple blocks in them or
reserving regions with multiple holes, etc...

Note that my patch really only rewrite those two low level functions
(add and remove of a region to a list), so it's reasonably contained and
should be easy to audit.

I want to spend a bit more time next week throwing at my userspace
version some nasty test cases involving non-coalesce boundaries, and
once that's done, and unless I have some massive bug I haven't seen, I
think we should just merge the patch.

Cheers,
Ben.

> diff --git a/mm/memblock.c b/mm/memblock.c
> index 4618fda..ba4ffdc 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -453,6 +453,9 @@ long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
>  
>         BUG_ON(0 == size);
>  
> +       while (__memblock_remove(_rgn, base, size) >= 0)
> +               ;
> +
>         return memblock_add_region(_rgn, base, size);
>  }
>  
> 
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


