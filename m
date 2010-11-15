Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab0KOUGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:06:31 -0500
Received: from relais.videotron.ca ([24.201.245.36]:54138 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0KOUGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:06:31 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 15 Nov 2010 15:06:29 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Colin Cross <ccross@google.com>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] clocksource: document some basic concepts
In-reply-to: <1289818094.2109.487.camel@laptop>
Message-id: <alpine.LFD.2.00.1011151453370.6448@xanadu.home>
References: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
 <1289818094.2109.487.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Peter Zijlstra wrote:

> On Mon, 2010-11-15 at 11:33 +0100, Linus Walleij wrote:
> > +The sched_clock() function may wrap only on unsigned long long boundaries,
> > +i.e. after 64 bits. Since this is a nanosecond value this will mean it wraps
> > +after circa 585 years. (For most practical systems this means "never".)

This is not necessarily the case.  Some implementations require a 
scaling factor too, making the number of remaining bits smaller than 64.  
See arch/arm/mach-pxa/time.c:sched_clock() for example, which has a 
maximum range of 208 days.  Of course, in practice we don't really care 
if sched_clock() wraps each 208 days, unlike for clock-source.

> Currently true, John Stultz was going to look into ammending this by
> teaching the kernel/sched_clock.c bits about early wraps (and a way for
> architectures to specify this)
> 
> #define SCHED_CLOCK_WRAP_BITS 48
> 
> ...
> 
> #ifdef SCHED_CLOCK_WRAP_BITS
>   /* handle short wraps */
> #endif

Is this worth supporting?  I'd simply use the low 32 bits and extend it 
to 63 bits using cnt32_to_63(). If the low 32 bits are wrapping too 
fast, then just shifting them down a few positions first should do the 
trick.  That certainly would have a much faster result.


Nicolas
