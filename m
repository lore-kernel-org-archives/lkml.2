Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0CUNtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:49:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35727 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0CUNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:49:19 -0400
To: Julia Lawall <julia@diku.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
	<1267697339-5491-7-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
	<4B900250.8020100@kernel.org>
	<Pine.LNX.4.64.1003050847170.21768@ask.diku.dk>
	<m1eije71et.fsf@fess.ebiederm.org>
	<Pine.LNX.4.64.1003211153470.7805@ask.diku.dk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 21 Mar 2010 06:49:12 -0700
In-Reply-To: <Pine.LNX.4.64.1003211153470.7805@ask.diku.dk> (Julia Lawall's message of "Sun\, 21 Mar 2010 12\:03\:45 +0100 \(CET\)")
Message-ID: <m1iq8p23af.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: julia@diku.dk, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> writes:

> I also worked on this, but only sent it to Thomas and Yinghai.  Onthe 
> other hand, I mostly like your solution better, because it has the 
> unintended side-effect of getting rid of some blank spaces after {s.

Wow I hadn't noticed that {s removal. That is an old coding style
violation on alpha.  There was an intentional effect of not breaking
up { }'s.  But I hadn't realized I was also fixing whitespace.

> My rule was also more complicated in that it also searches for conditions 
> in which it is not sure to be doing the right thing.  I will send those in 
> another message.
>
>> @ DECL @
>> struct irq_chip CHIP;
>> identifier METHOD;
>> identifier METHOD_NAME;
>> @@
>>  CHIP.METHOD_NAME = METHOD;
>> 
>> @ @
>> identifier DECL.METHOD;
>> identifier IRQ;
>> @@
>>  METHOD(
>> -		unsigned int IRQ
>> +		struct irq_desc *unused
>>  , ...) {
>>  }
>
> I didn't think of making a special rule for this.  It could consider any 
> case where the body is ... when != IRQ

Nice addition.

>> @ @
>> identifier DECL.METHOD;
>> identifier IRQ;
>> identifier DESC;
>> @@
>>  METHOD(
>> -		unsigned int IRQ
>> +		struct irq_desc *DESC
>>  , ...) {
>> +	unsigned int IRQ = DESC->irq;
>>  	...
>> -	struct irq_desc *DESC = irq_to_desc(IRQ);
>> 	...
>>  }
>> 
>> @ @
>> identifier DECL.METHOD;
>> identifier IRQ;
>> identifier DESC;
>> @@
>>  METHOD(
>> -		unsigned int IRQ
>> +		struct irq_desc *DESC
>>  , ...) {
>> +	unsigned int IRQ = DESC->irq;
>>  	...
>> -	struct irq_desc *DESC;
>> 	...
>> -	DESC = irq_to_desc(IRQ);
>> 	...
>>  }
>> 
>> @ @
>> identifier DECL.METHOD;
>> identifier IRQ;
>> @@
>>  METHOD(
>> -		unsigned int IRQ
>> +		struct irq_desc *desc
>>  , ...) {
>> +	unsigned int IRQ = desc->irq;
>>  ...
>>  }
>> 
>> @ @
>> identifier DECL.METHOD;
>> identifier FUNC;
>> identifier IRQ;
>> @@
>>  FUNC(...) {
>>  <...
>> 	METHOD(
>> -		IRQ
>> +		irq_to_desc(IRQ)
>>  		, ... )
>>  ...>
>>  }
>
> I don't think FUNC(...) { <... and ...> } are needed here.  The goal is to 
> make the change everywhere the call appears.

That is a reasonable simplification.

>> @ @
>> identifier FUNC;
>> identifier DESC;
>> identifier IRQ;
>> @@
>>  FUNC(..., struct irq_desc *DESC, ...) {
>>  ...
>>  	unsigned int IRQ = DESC->irq;
>>  <...
>> -	irq_to_desc(IRQ)
>> +	DESC
>>  ...>
>>  }
>
> This rule can be extended as follows:

Nice.  I had not picked up on the or operator.

> @ @
> identifier FUNC;
> identifier DESC;
> identifier IRQ;
> identifier FLD;
> @@
>  FUNC(..., struct irq_desc *DESC, ...) {
>  ...
>         unsigned int IRQ = DESC->irq;
>  <...
> (
> -       irq_to_desc(IRQ)
> +       DESC
> |
> -       irq_desc[IRQ].FLD
> +       DESC->FLD
> )
>  ...>
>  }
>
> Doing so gets rid of more references to IRQ.

Very reasonable, especially on arches like alpha where none of the
sparse irq work has hit.


> Another case that can be treated is method calls via a pointer:

I didn't actually find any cases where that rule hit on arch/x86
so I did not include it, but it makes sense.

> @@
> expression arg;
> struct irq_desc *desc;
> struct irq_chip *ic;
> identifier fun;
> @@
>
> (
>   desc->chip->fun(
> -   arg
> +   desc
>     ,...)
> |
>   ic->fun(
> -   arg
> +   irq_to_desc(arg)
>     ,...)
> )


My paranoid sense says this rule should be:
@ @
expresion IRQ_EXPR;
struct irq_desc *DESC;
struct irq_chip *CHIP;
identifier METHOD;
@@
(
 	DESC->chip->METHOD(
-			   IRQ_EXPR
+			   irq_to_desc(IRQ_EXPR)
			   , ... )
|
	CHIP->METHOD(
-		     IRQ_EXPR
+		     irq_to_desc(IRQ_EXPR)
		     , ... )

If this is before my irq_to_desc removal rule.  We should not
see any new irq_to_desc calls popping up.

> julia
>
>> @ @
>> identifier FUNC;
>> identifier DESC;
>> identifier IRQ;
>> @@
>>  FUNC(..., struct irq_desc *DESC, ...) {
>>  ...
>> -	unsigned int IRQ = DESC->irq;
>>  ... when != IRQ
>>  }
