Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0CUOUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 10:20:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60468 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0CUOUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 10:20:01 -0400
Date: Sun, 21 Mar 2010 15:19:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
In-Reply-To: <m1iq8p23af.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.64.1003211515310.12371@ask.diku.dk>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
 <1267697339-5491-7-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org>
 <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk> <m1eije71et.fsf@fess.ebiederm.org>
 <Pine.LNX.4.64.1003211153470.7805@ask.diku.dk> <m1iq8p23af.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Eric W. Biederman wrote:

> Julia Lawall <julia@diku.dk> writes:
> 
> > I also worked on this, but only sent it to Thomas and Yinghai.  Onthe 
> > other hand, I mostly like your solution better, because it has the 
> > unintended side-effect of getting rid of some blank spaces after {s.
> 
> Wow I hadn't noticed that {s removal. That is an old coding style
> violation on alpha.  There was an intentional effect of not breaking
> up { }'s.  But I hadn't realized I was also fixing whitespace.

I think it is because you added a local declaration of irq and then 
removed it when it was not necessary.  So then coccinelle was motivated to 
remove the space after the {.

> > My rule was also more complicated in that it also searches for conditions 
> > in which it is not sure to be doing the right thing.  I will send those in 
> > another message.
> >
> >> @ DECL @
> >> struct irq_chip CHIP;
> >> identifier METHOD;
> >> identifier METHOD_NAME;
> >> @@
> >>  CHIP.METHOD_NAME = METHOD;
> >> 
> >> @ @
> >> identifier DECL.METHOD;
> >> identifier IRQ;
> >> @@
> >>  METHOD(
> >> -		unsigned int IRQ
> >> +		struct irq_desc *unused
> >>  , ...) {
> >>  }
> >
> > I didn't think of making a special rule for this.  It could consider any 
> > case where the body is ... when != IRQ
> 
> Nice addition.
> 
> >> @ @
> >> identifier DECL.METHOD;
> >> identifier IRQ;
> >> identifier DESC;
> >> @@
> >>  METHOD(
> >> -		unsigned int IRQ
> >> +		struct irq_desc *DESC
> >>  , ...) {
> >> +	unsigned int IRQ = DESC->irq;
> >>  	...
> >> -	struct irq_desc *DESC = irq_to_desc(IRQ);
> >> 	...
> >>  }
> >> 
> >> @ @
> >> identifier DECL.METHOD;
> >> identifier IRQ;
> >> identifier DESC;
> >> @@
> >>  METHOD(
> >> -		unsigned int IRQ
> >> +		struct irq_desc *DESC
> >>  , ...) {
> >> +	unsigned int IRQ = DESC->irq;
> >>  	...
> >> -	struct irq_desc *DESC;
> >> 	...
> >> -	DESC = irq_to_desc(IRQ);
> >> 	...
> >>  }
> >> 
> >> @ @
> >> identifier DECL.METHOD;
> >> identifier IRQ;
> >> @@
> >>  METHOD(
> >> -		unsigned int IRQ
> >> +		struct irq_desc *desc
> >>  , ...) {
> >> +	unsigned int IRQ = desc->irq;
> >>  ...
> >>  }
> >> 
> >> @ @
> >> identifier DECL.METHOD;
> >> identifier FUNC;
> >> identifier IRQ;
> >> @@
> >>  FUNC(...) {
> >>  <...
> >> 	METHOD(
> >> -		IRQ
> >> +		irq_to_desc(IRQ)
> >>  		, ... )
> >>  ...>
> >>  }
> >
> > I don't think FUNC(...) { <... and ...> } are needed here.  The goal is to 
> > make the change everywhere the call appears.
> 
> That is a reasonable simplification.
> 
> >> @ @
> >> identifier FUNC;
> >> identifier DESC;
> >> identifier IRQ;
> >> @@
> >>  FUNC(..., struct irq_desc *DESC, ...) {
> >>  ...
> >>  	unsigned int IRQ = DESC->irq;
> >>  <...
> >> -	irq_to_desc(IRQ)
> >> +	DESC
> >>  ...>
> >>  }
> >
> > This rule can be extended as follows:
> 
> Nice.  I had not picked up on the or operator.
> 
> > @ @
> > identifier FUNC;
> > identifier DESC;
> > identifier IRQ;
> > identifier FLD;
> > @@
> >  FUNC(..., struct irq_desc *DESC, ...) {
> >  ...
> >         unsigned int IRQ = DESC->irq;
> >  <...
> > (
> > -       irq_to_desc(IRQ)
> > +       DESC
> > |
> > -       irq_desc[IRQ].FLD
> > +       DESC->FLD
> > )
> >  ...>
> >  }
> >
> > Doing so gets rid of more references to IRQ.
> 
> Very reasonable, especially on arches like alpha where none of the
> sparse irq work has hit.
> 
> 
> > Another case that can be treated is method calls via a pointer:
> 
> I didn't actually find any cases where that rule hit on arch/x86
> so I did not include it, but it makes sense.
> 
> > @@
> > expression arg;
> > struct irq_desc *desc;
> > struct irq_chip *ic;
> > identifier fun;
> > @@
> >
> > (
> >   desc->chip->fun(
> > -   arg
> > +   desc
> >     ,...)
> > |
> >   ic->fun(
> > -   arg
> > +   irq_to_desc(arg)
> >     ,...)
> > )
> 
> 
> My paranoid sense says this rule should be:
> @ @
> expresion IRQ_EXPR;
> struct irq_desc *DESC;
> struct irq_chip *CHIP;
> identifier METHOD;
> @@
> (
>  	DESC->chip->METHOD(
> -			   IRQ_EXPR
> +			   irq_to_desc(IRQ_EXPR)
> 			   , ... )
> |
> 	CHIP->METHOD(
> -		     IRQ_EXPR
> +		     irq_to_desc(IRQ_EXPR)
> 		     , ... )

Agreed.  But then it would be nice to check whether DESC is already 
computed as irq_to_desc(IRQ_EXPR).

julia

> If this is before my irq_to_desc removal rule.  We should not
> see any new irq_to_desc calls popping up.
> 
> > julia
> >
> >> @ @
> >> identifier FUNC;
> >> identifier DESC;
> >> identifier IRQ;
> >> @@
> >>  FUNC(..., struct irq_desc *DESC, ...) {
> >>  ...
> >> -	unsigned int IRQ = DESC->irq;
> >>  ... when != IRQ
> >>  }
> 
