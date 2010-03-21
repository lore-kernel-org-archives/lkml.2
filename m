Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0CULDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 07:03:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38464 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0CULDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 07:03:49 -0400
Date: Sun, 21 Mar 2010 12:03:45 +0100 (CET)
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
Message-ID: <Pine.LNX.4.64.1003211153470.7805@ask.diku.dk>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
 <1267697339-5491-7-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org>
 <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk> <m1eije71et.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also worked on this, but only sent it to Thomas and Yinghai.  Onthe 
other hand, I mostly like your solution better, because it has the 
unintended side-effect of getting rid of some blank spaces after {s.

My rule was also more complicated in that it also searches for conditions 
in which it is not sure to be doing the right thing.  I will send those in 
another message.

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

I didn't think of making a special rule for this.  It could consider any 
case where the body is ... when != IRQ

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

I don't think FUNC(...) { <... and ...> } are needed here.  The goal is to 
make the change everywhere the call appears.

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

This rule can be extended as follows:

@ @
identifier FUNC;
identifier DESC;
identifier IRQ;
identifier FLD;
@@
 FUNC(..., struct irq_desc *DESC, ...) {
 ...
        unsigned int IRQ = DESC->irq;
 <...
(
-       irq_to_desc(IRQ)
+       DESC
|
-       irq_desc[IRQ].FLD
+       DESC->FLD
)
 ...>
 }

Doing so gets rid of more references to IRQ.

Another case that can be treated is method calls via a pointer:

@@
expression arg;
struct irq_desc *desc;
struct irq_chip *ic;
identifier fun;
@@

(
  desc->chip->fun(
-   arg
+   desc
    ,...)
|
  ic->fun(
-   arg
+   irq_to_desc(arg)
    ,...)
)

julia

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
