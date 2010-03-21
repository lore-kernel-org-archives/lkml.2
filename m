Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0CULId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 07:08:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38560 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0CULIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 07:08:31 -0400
Date: Sun, 21 Mar 2010 12:08:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
In-Reply-To: <m1eije71et.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.64.1003211206380.7805@ask.diku.dk>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
 <1267697339-5491-7-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org>
 <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk> <m1eije71et.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another detail is that the type of irq is not always unsigned int.  
Coccinelle will match unsigned int to just unsigned, but there are also 
occurrences of uint32_t and u_int.  I don't know if it is desirable to 
preserve these names, or if it would be just as well to put unsigned int 
everywhere?

julia



On Sat, 20 Mar 2010, Eric W. Biederman wrote:

> 
> I haven't heard anything more on this, but I had reason to play with
> coccinelle http://coccinelle.lip6.fr/ which I think is think think is
> the semantic patcher you referred to.
> 
> In any case I was playing with it and I believe I have managed to whip
> up a fairly robust semantic patch.  The last two hunks are to cleanup
> earlier transforms, by removing unnecessary irq_to_desc chatter, and
> removing unused variables.  I am a big grumpy that I couldn't figure
> out how to add comments to my patch to explain the tricky bits,
> but otherwise I am happy.
> 
> The patch appears to have the limitation that methods that are not in
> the file where struct irq_chip is defined, which is an issue for the
> msi irq_chip helper routines.  Other than that I don't know of any
> issues.
> 
> I would suggest changing as much of the x86 non irq_chip helpers to
> use irq_desc before applying this so it this the conversion can have
> the chance to remove any irq variables.
> 
> Eric
> 
> 
> @ DECL @
> struct irq_chip CHIP;
> identifier METHOD;
> identifier METHOD_NAME;
> @@
>  CHIP.METHOD_NAME = METHOD;
> 
> @ @
> identifier DECL.METHOD;
> identifier IRQ;
> @@
>  METHOD(
> -		unsigned int IRQ
> +		struct irq_desc *unused
>  , ...) {
>  }
> 
> @ @
> identifier DECL.METHOD;
> identifier IRQ;
> identifier DESC;
> @@
>  METHOD(
> -		unsigned int IRQ
> +		struct irq_desc *DESC
>  , ...) {
> +	unsigned int IRQ = DESC->irq;
>  	...
> -	struct irq_desc *DESC = irq_to_desc(IRQ);
> 	...
>  }
> 
> @ @
> identifier DECL.METHOD;
> identifier IRQ;
> identifier DESC;
> @@
>  METHOD(
> -		unsigned int IRQ
> +		struct irq_desc *DESC
>  , ...) {
> +	unsigned int IRQ = DESC->irq;
>  	...
> -	struct irq_desc *DESC;
> 	...
> -	DESC = irq_to_desc(IRQ);
> 	...
>  }
> 
> @ @
> identifier DECL.METHOD;
> identifier IRQ;
> @@
>  METHOD(
> -		unsigned int IRQ
> +		struct irq_desc *desc
>  , ...) {
> +	unsigned int IRQ = desc->irq;
>  ...
>  }
> 
> @ @
> identifier DECL.METHOD;
> identifier FUNC;
> identifier IRQ;
> @@
>  FUNC(...) {
>  <...
> 	METHOD(
> -		IRQ
> +		irq_to_desc(IRQ)
>  		, ... )
>  ...>
>  }
> 
> @ @
> identifier FUNC;
> identifier DESC;
> identifier IRQ;
> @@
>  FUNC(..., struct irq_desc *DESC, ...) {
>  ...
>  	unsigned int IRQ = DESC->irq;
>  <...
> -	irq_to_desc(IRQ)
> +	DESC
>  ...>
>  }
> 
> @ @
> identifier FUNC;
> identifier DESC;
> identifier IRQ;
> @@
>  FUNC(..., struct irq_desc *DESC, ...) {
>  ...
> -	unsigned int IRQ = DESC->irq;
>  ... when != IRQ
>  }
> 
