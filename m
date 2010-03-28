Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0C1BBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 21:01:45 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:47795 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab0C1BBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 21:01:43 -0400
Date: Sun, 28 Mar 2010 03:01:13 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -v3] x86: Make sure free_init_pages() free pages in boundary
Message-ID: <20100328010113.GB10304@cmpxchg.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-3-git-send-email-yinghai@kernel.org> <20100326230615.GB29222@cmpxchg.org> <4BAD4734.8020503@kernel.org> <20100327000723.GF29222@cmpxchg.org> <4BAD5D25.5060909@kernel.org> <20100328000306.GA10304@cmpxchg.org> <4BAEA7BE.1030707@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAEA7BE.1030707@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 05:50:06PM -0700, Yinghai Lu wrote:
> > diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> > index e71c5cb..018e793 100644
> > --- a/arch/x86/mm/init.c
> > +++ b/arch/x86/mm/init.c
> > @@ -336,6 +336,11 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
> >  	if (addr >= end)
> >  		return;
> >  
> > +	if (WARN_ON(addr & ~PAGE_MASK || end & ~PAGE_MASK)) {
> > +		addr = PAGE_ALIGN(addr);
> > +		end &= PAGE_MASK;
> > +	}
> > +
> >  	/*
> >  	 * If debugging page accesses then do not free this memory but
> >  	 * mark them not present - any buggy init-section access will
> > @@ -355,11 +360,10 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
> >  
> >  	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
> >  
> > -	for (; addr < end; addr += PAGE_SIZE) {
> > +	for (; addr != end; addr += PAGE_SIZE) {
> >  		ClearPageReserved(virt_to_page(addr));
> >  		init_page_count(virt_to_page(addr));
> > -		memset((void *)(addr & ~(PAGE_SIZE-1)),
> > -			POISON_FREE_INITMEM, PAGE_SIZE);
> > +		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
> >  		free_page(addr);
> >  		totalram_pages++;
> >  	}
> something wrong here, if someone pass (0x10, 0x20), the will be aligned to [0x1000, 0]
> you will get dead loop

You are right!  It should be enough to move the alignment fixup above the addr >= end
check and in that case?  So we would get the warning and then simply return.

> will update that.

Thanks!

> YH

	Hannes
