Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1IWASu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:18:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26154 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab1IWASt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:18:49 -0400
X-AuditID: cbfee61b-b7b7fae000005864-a8-4e7bd067a1ba
Date: Fri, 23 Sep 2011 09:18:49 +0900
From: mhban <mhban@samsung.com>
Subject: Re: [PATCH] ARM: futex: fix clobbering oldval
In-reply-to: <20110922172653.GH13572@e102144-lin.cambridge.arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DavidHowells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>
Reply-to: mhban@samsung.com
Message-id: <1316737129.6872.17.camel@puffmine-laptop>
Organization: SAMSUNG
MIME-version: 1.0
X-Mailer: Evolution 2.28.3
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <1316660015.6872.1.camel@puffmine-laptop>
 <20110922172653.GH13572@e102144-lin.cambridge.arm.com>
X-OriginalArrivalTime: 23 Sep 2011 00:19:42.0543 (UTC)
 FILETIME=[7D863DF0:01CC7986]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 18:26 +0100, Will Deacon wrote:
> Hi,
> 
> On Thu, Sep 22, 2011 at 03:53:35AM +0100, mhban wrote:
> > This patch fixes clobbering oldval bug. oldval should be preserved for next
> > compare operation.
> > 
> > Change-Id: I2a63bc1bdb8de330eb9e1ac02d7da1f77e6e8c3c
> > Signed-off-by: Minho Ban <mhban@samsung.com>
> 
> It would have been nice to have been CC'd on this...

Will not miss next time. Thanks.

> 
> I ran LTP tests on this, so I'm surprised that this was broken (the tests
> passed). Well spotted anyway!
> 
> > ---
> >  arch/arm/include/asm/futex.h |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
> > index d2d733c..b0f2e8e 100644
> > --- a/arch/arm/include/asm/futex.h
> > +++ b/arch/arm/include/asm/futex.h
> > @@ -30,14 +30,14 @@
> >  	__asm__ __volatile__(					\
> >  	"1:	ldrex	%1, [%2]\n"				\
> >  	"	" insn "\n"					\
> > -	"2:	strex	%1, %0, [%2]\n"				\
> > -	"	teq	%1, #0\n"				\
> > +	"2:	strex	r5, %0, [%2]\n"				\
> > +	"	teq	r5, #0\n"				\
> >  	"	bne	1b\n"					\
> >  	"	mov	%0, #0\n"				\
> >  	__futex_atomic_ex_table("%4")				\
> >  	: "=&r" (ret), "=&r" (oldval)				\
> >  	: "r" (uaddr), "r" (oparg), "Ir" (-EFAULT)		\
> > -	: "cc", "memory")
> > +	: "r5", "cc", "memory")
> 
> You shouldn't reference r5 directly here, but due to the way the futex code
> is laid out, you can't add an extra output operand without converting the
> code to use named arguments.
> 
> I'll post a patch to do that.
> 
> Will

I'm not familiar with gcc inline, thanks for pointing it out.

BTW, my last name is Ban not Ben.


Minho


