Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab0DMFPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:15:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:51826 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0DMFPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:15:09 -0400
Subject: Re: [PATCH 26/39] nobootmem: use lmb.default_alloc_limit in
 alloc_bootmem path
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BC3F82A.20400@oracle.com>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-27-git-send-email-yinghai@kernel.org>
	 <1271132589.13059.67.camel@pasglop>  <4BC3F82A.20400@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 15:13:42 +1000
Message-ID: <1271135622.13059.75.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 21:50 -0700, Yinghai wrote:
> On 04/12/2010 09:23 PM, Benjamin Herrenschmidt wrote:
> > On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
> >> Generic version __lmb_find_area() is going from high to low, and for 32bit
> >> active_region for 32bit does include high pages
> >>
> >> need to replace the limit with lmb.default_alloc_limit, aka get_max_mapped()
> >>
> >> with this patch, x86 32bit could use generic version of __lmb_find_area()
> > 
> > So you unconditionally add access to some lmb specific data structure to
> > generic code ? That isn't going to work very well on archs that don't
> > use lmb.
> 
> the whole function
> 
> #ifdef CONFIG_HAVE_LMB
> u64 __init find_memory_core_early(int nid, u64 size, u64 align,
>                                         u64 goal, u64 limit)
> {
>         int i;
> 
>         /* Need to go over early_node_map to find out good range for node */
>         for_each_active_range_index_in_nid(i, nid) {
>                 u64 addr;
>                 u64 ei_start, ei_last;
> 
>                 ei_last = early_node_map[i].end_pfn;
>                 ei_last <<= PAGE_SHIFT;
>                 ei_start = early_node_map[i].start_pfn;
>                 ei_start <<= PAGE_SHIFT;
>                 addr = __lmb_find_area(ei_start, ei_last,
>                                          goal, limit, size, align);
> 
>                 if (addr == -1ULL)
>                         continue;
> 
>                 return addr;
>         }
> 
>         return -1ULL;
> }
> #endif
> 
> need to access early_node_map[], so leave the function here.

Hrm... find_memory_core_early() is a broken API anyways. Did you add
that ? Again, you insist on pushing all over the place that crakpot
find/reserve API instead of doing a proper allocation, and it's now
leaking with ifdef's & all into the generic code.

This is just all a pile of shit.

I'm tempted to NACK the whole thing and wait for somebody who can code
to come up with something half decent.

Ben.


> > 
> > Also, those things should be local to lmb_* anyways.
> 
> if you insist, could move it to lmb.c and use work_with_active_regions() around it.
> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


