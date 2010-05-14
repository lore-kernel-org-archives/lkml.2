Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0ENItt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:49:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:53975 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0ENItr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:49:47 -0400
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BECF158.5070200@oracle.com>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>
	 <1273804337.21352.396.camel@pasglop>  <4BECF158.5070200@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 18:30:07 +1000
Message-ID: <1273825807.21352.601.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 23:44 -0700, Yinghai wrote:
> On 05/13/2010 07:32 PM, Benjamin Herrenschmidt wrote:
> > On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> >> Some areas from firmware could be reserved several times from different callers.
> >>
> >> If these area are overlapped, We may have overlapped entries in lmb.reserved.
> >>
> >> Try to free the area at first, before rerserve them again.
> > 
> > I have already told you to make this a property of lmb_reserve() instead
> > of adding that function with a terrible name.
> 
> make every lmb_reserve() call lmb_free at first?

Either that, or make it check for collisions first, and if there's
one, call free and try again. A little bit more work but I plan toq
make it smarter at some stage, ie, directly adjust surrounding ranges
instead which is not -that- hard to do.

Ben.

> > 
> > Cheers,
> > Ben.
> > 
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> ---
> >>  arch/x86/include/asm/lmb.h |    1 +
> >>  arch/x86/mm/lmb.c          |   18 ++++++++++++++++++
> >>  2 files changed, 19 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
> >> index dd42ac1..9329e09 100644
> >> --- a/arch/x86/include/asm/lmb.h
> >> +++ b/arch/x86/include/asm/lmb.h
> >> @@ -7,6 +7,7 @@ u64 lmb_find_area_size(u64 start, u64 *sizep, u64 align);
> >>  void lmb_to_bootmem(u64 start, u64 end);
> >>  
> >>  void lmb_reserve_area(u64 start, u64 end, char *name);
> >> +void lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name);
> >>  void lmb_free_area(u64 start, u64 end);
> >>  void lmb_add_memory(u64 start, u64 end);
> >>  struct range;
> >> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> >> index 19a5f49..1100c18 100644
> >> --- a/arch/x86/mm/lmb.c
> >> +++ b/arch/x86/mm/lmb.c
> >> @@ -309,6 +309,24 @@ void __init lmb_reserve_area(u64 start, u64 end, char *name)
> >>  	lmb_add_region(&lmb.reserved, start, end - start);
> >>  }
> >>  
> >> +/*
> >> + * Could be used to avoid having overlap entries in lmb.reserved.region.
> >> + *  Don't need to use it with area that is from lmb_find_area()
> >> + *  Only use it for the area that fw hidden area.
> >> + */
> >> +void __init lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name)
> >> +{
> >> +	if (start == end)
> >> +		return;
> >> +
> >> +	if (WARN_ONCE(start > end, "lmb_reserve_area_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
> >> +		return;
> >> +
> >> +	/* Free that region at first */
> >> +	lmb_free(start, end - start);
> >> +	lmb_add_region(&lmb.reserved, start, end - start);
> >> +}
> >> +
> >>  void __init lmb_free_area(u64 start, u64 end)
> >>  {
> >>  	if (start == end)
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


