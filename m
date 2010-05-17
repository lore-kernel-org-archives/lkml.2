Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab0EQAsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:48:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:41075 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0EQAsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:48:02 -0400
Subject: Re: lmb type features.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <4BEDE1EA.8030103@oracle.com>
References: <1273804238.21352.389.camel@pasglop>
	 <4BECF00D.6080800@oracle.com>	<1273825187.21352.590.camel@pasglop>
	 <20100514.013012.13730149.davem@davemloft.net>
	 <4BED7DFE.2090108@oracle.com> <1273876488.21352.643.camel@pasglop>
	 <4BEDE1EA.8030103@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 10:46:36 +1000
Message-ID: <1274057196.21352.707.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 16:51 -0700, Yinghai wrote:

 .../...

> #define LMB_ADD_MERGE (1<<0) 
> #define LMB_ARRAY_DOUBLE (1<<1)
> 
> so before call double_lmb_array(), should check the features to bit is set or not.
> otherwise should emit PANIC with clear message.
> 
> Usage:
> 
> for range replacement,
> 
> 1. early stage before lmb.reserved, lmb.memory is there.
> so can not use lmb_find_base yet.

Let me make sure I understand: You mean when doing all the memory
lmb_add() early during boot, we haven't done the various lmb_reserve()
for all potentially reserved areas and thus cannot rely on
double_lmb_array() doing the right thing ?

I think this is a good point. However, a better way to do that would
be to set the default alloc limit to 0 instead of LMB_ALLOC_ANYWHERE.

I haven't done that yet though I certainly intend to, but I'll need
to ensure all the archs using LMB set a decent limit at some stage. You
can in the meantime do it explicitely in x86.

Additionally, it should be possible in most cases to do all the critical
lmb_reserve() early, before lmb_add()'s, and thus remove the problem,
though that is indeed not the case today.

It would be nice to be able to extend the array for memory addition
since that would allow us to have much smaller static arrays in the
first place.

> 2. for bootmem replacement, when do range set subtraction for final free range list,
> don't want to change lmb.reserved in the middle.  callee should make sure to have big
> enough temperately lmb_regions in lmb_type. 

Sorry, I'm not sure I grasped your explanation above. You mean when
transitioning from LMB to the page allocator, the page freeing needs to
be done after substracting the reserved array from the memory, and that
substraction might cause the arrays to increase in size, thus affecting
the reserved array ?

That could be solved by not doing the substraction and doing things a
bit differently. You could have a single function that walks both arrays
at the same time, and calls a callback for all memory ranges it finds
that aren't reserved. Not -that- tricky to code.

Cheers,
Ben.

> Thanks
> 
> Yinghai
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


