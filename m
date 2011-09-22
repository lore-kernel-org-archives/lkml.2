Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1IVR1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:27:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47681 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab1IVR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:27:24 -0400
Date: Thu, 22 Sep 2011 18:26:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: mhban <mhban@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DavidHowells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] ARM: futex: fix clobbering oldval
Message-ID: <20110922172653.GH13572@e102144-lin.cambridge.arm.com>
References: <1316660015.6872.1.camel@puffmine-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316660015.6872.1.camel@puffmine-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 22, 2011 at 03:53:35AM +0100, mhban wrote:
> This patch fixes clobbering oldval bug. oldval should be preserved for next
> compare operation.
> 
> Change-Id: I2a63bc1bdb8de330eb9e1ac02d7da1f77e6e8c3c
> Signed-off-by: Minho Ban <mhban@samsung.com>

It would have been nice to have been CC'd on this...

I ran LTP tests on this, so I'm surprised that this was broken (the tests
passed). Well spotted anyway!

> ---
>  arch/arm/include/asm/futex.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
> index d2d733c..b0f2e8e 100644
> --- a/arch/arm/include/asm/futex.h
> +++ b/arch/arm/include/asm/futex.h
> @@ -30,14 +30,14 @@
>  	__asm__ __volatile__(					\
>  	"1:	ldrex	%1, [%2]\n"				\
>  	"	" insn "\n"					\
> -	"2:	strex	%1, %0, [%2]\n"				\
> -	"	teq	%1, #0\n"				\
> +	"2:	strex	r5, %0, [%2]\n"				\
> +	"	teq	r5, #0\n"				\
>  	"	bne	1b\n"					\
>  	"	mov	%0, #0\n"				\
>  	__futex_atomic_ex_table("%4")				\
>  	: "=&r" (ret), "=&r" (oldval)				\
>  	: "r" (uaddr), "r" (oparg), "Ir" (-EFAULT)		\
> -	: "cc", "memory")
> +	: "r5", "cc", "memory")

You shouldn't reference r5 directly here, but due to the way the futex code
is laid out, you can't add an extra output operand without converting the
code to use named arguments.

I'll post a patch to do that.

Will
