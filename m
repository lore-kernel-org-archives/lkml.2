Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0CXHvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:51:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:59151 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab0CXHvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:51:19 -0400
Subject: Re: [RFC PATCH -v3 1/2] lmb: seperate region array from lmb_region
 struct
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <4BA9A71F.7080801@kernel.org>
References: <1269333587-1866-1-git-send-email-yinghai@kernel.org>
	 <1269333587-1866-5-git-send-email-yinghai@kernel.org>
	 <4BA899C2.8020208@kernel.org>  <20100323104241.GA1189@elte.hu>
	 <1269405955.8599.156.camel@pasglop>  <4BA9A71F.7080801@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 18:41:47 +1100
Message-ID: <1269416507.8599.182.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 22:46 -0700, Yinghai Lu wrote:
> I dislike those arrays anyways. See my other message about turning
> them into lists, which would get rid of capacity constraints
> completely. What do you think ?
> > 
> 2/2 introduce one new function that could double the array size

It's still bloody arrays with fixed sizes, arbitrary limits and
arbitrary waste of BSS space ;-) To be honest, I much prefer my idea of
linked lists... But I'll let others speak.

I think your double array size looks more like a band-aid than a proper
fix. If we are going to use LMB in the long run for bootmem, we need to
properly address its capacity constraints, not just paper over the
problem.

Cheers,
Ben.

> please check the v4.
> 
> the function rely on find_lmb_area().
> 
> it will check if there is enough space left, otherwise try to get new
> big array, and
> copy old array to new array.
> 
> final function like:
> 
> static void __init __check_and_double_region_array(struct lmb_region
> *type,
>                          struct lmb_property *static_region,
>                          u64 ex_start, u64 ex_end)
> {
>         u64 start, end, size, mem;
>         struct lmb_property *new, *old;
>         unsigned long rgnsz = type->nr_regions;
> 
>         /* do we have enough slots left ? */
>         if ((rgnsz - type->cnt) > max_t(unsigned long, rgnsz/8, 2))
>                 return;
> 
>         old = type->region;
>         /* double it */
>         mem = -1ULL;
>         size = sizeof(struct lmb_property) * rgnsz * 2;
>         if (old == static_region)
>                 start = 0;
>         else
>                 start = __pa(old) + sizeof(struct lmb_property) *
> rgnsz;
>         end = ex_start;
>         if (start + size < end)
>                 mem = find_lmb_area(start, end, size,
>                                          sizeof(struct lmb_property));
>         if (mem == -1ULL) {
>                 start = ex_end;
>                 end = get_max_mapped();
>                 if (start + size < end)
>                         mem = find_lmb_area(start, end, size,
> sizeof(struct lmb_property));
>         }
>         if (mem == -1ULL)
>                 panic("can not find more space for lmb.reserved.region
> array");
> 
>         new = __va(mem);
>         /* copy old to new */
>         memcpy(&new[0], &old[0], sizeof(struct lmb_property) * rgnsz);
>         memset(&new[rgnsz], 0, sizeof(struct lmb_property) * rgnsz);
> 
>         memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
>         type->region = new;
>         type->nr_regions = rgnsz * 2;
>         printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld
> at [%llx - %llx]\n",
>                 type->nr_regions, mem, mem + size - 1);
> 
>         /* reserve new array and free old one */
>         lmb_reserve(mem, sizeof(struct lmb_property) * rgnsz * 2);
>         if (old != static_region)
>                 lmb_free(__pa(old), sizeof(struct lmb_property) *
> rgnsz);
> }
> 
> void __init add_lmb_memory(u64 start, u64 end)
> {
>         __check_and_double_region_array(&lmb.memory,
> &lmb_memory_region[0], start, end);
>         lmb_add(start, end - start);
> }
> 
> void __init reserve_early(u64 start, u64 end, char *name)
> {
>         if (start == end)
>                 return;
> 
>         if (WARN_ONCE(start > end, "reserve_early: wrong range [%#llx,
> %#llx]\n", start, end))
>                 return;
> 
>         __check_and_double_region_array(&lmb.reserved,
> &lmb_reserved_region[0], start, end);
>         lmb_reserve(start, end - start);
> }
> 
> void __init free_early(u64 start, u64 end)
> {
>         if (start == end)
>                 return;
> 
>         if (WARN_ONCE(start > end, "free_early: wrong range [%#llx, %
> #llx]\n", start, end))
>                 return;
> 
>         /* keep punching hole, could run out of slots too */
>         __check_and_double_region_array(&lmb.reserved,
> &lmb_reserved_region[0], start, end);
>         lmb_free(start, end - start);
> }
> 
> with those function, we can replace the bootmem in x86.
> 
> 
> Thanks
> 
> Yinghai
> 
> 

