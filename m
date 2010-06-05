Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab0FETsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:48:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab0FETsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IA0KgqkbcqhwtzhHIxp3e5hrwn+m0qX5SAnNgTw2O11MQHIVzMjWkSGngCAWjSAFM5
         IF4LRMzxAwrKq92YRHkIyeIr9Jb8XGfqiNsETRrT4Q6sR+BfvS2RImB1AH0alx/LX990
         N8Tw/UokseMMwR/GauCAvus2H0m7kXKONJrgc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	<AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	<20100605151031.2d562268@hina.wild-wind.fr.eu.org>
	<alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
	<AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
	<alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>
Date: Sat, 5 Jun 2010 21:48:48 +0200
Message-ID: <AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
	interrupt handlers
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@misterjones.org>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 8:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Esben,
>
> On Sat, 5 Jun 2010, Esben Haabendal wrote:
>
>> On Sat, Jun 5, 2010 at 5:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Sat, 5 Jun 2010, Marc Zyngier wrote:
>> >> You may want to give request_any_context_irq() a try (available since the
>> >> latest merge window). It still requires your driver to be changed, but it
>> >> should then work in both threaded and non-threaded cases.
>> >
>> > And it nicely annotates that somebody looked at the driver in
>> > question. That's the rule of least surprise and does not impose checks
>> > on the fast path.
>>
>> What in particular should I be looking for in a driver before changing
>> from request_irq() to request_any_context_irq() ?
>
> Whether the irq handler relies on interrupts being disabled is the
> most important thing. There are other constraints like
> enable_irq/disable_irq calls from the driver code, which are not
> allowed to run in atomic context for interrupt hanging of a i2c irq
> controller.

Yes, I were hit by this also.

The phy interrupt handler calls disable_irq, which does not work
with an i2c irq controller (ie. the genirc buslock mutex), and I specifically
got rid of the buslock for pca9535 driver (powerpc only, though).

This is really a drawback of the genirq buslock IMHO.

>> As for not checking in the fast path, it should be noted that this is "only"
>> in handle_nested_irq(), which is only used in few interupt controller
>> drivers, all of which I assume are generally not considered very "fast".
>
> Fair enough. Still I fundamentaly dislike the automagic handling of
> this and especially the irq disabled portion of it.

Yes, it would be better to not have irq disabled.
But not really much worse than with other interrupt controllers,
where the handler would be running in interrupt context anyway.

So until all handlers are rewritten to run threaded, I believe
something like the proposed patch will give value to people
with i2c irq controllers. Hopefully, not to many people are unlucky
enough to have this, but anyway...

>> Unless all interrupt handlers should be rewritten to be able to in both
>> thread and interrupt context, I fail to se the conflict between the patch
>> proposed and the work being done on request_any_context_irq().
>
> It's not a question of conflict. It's a question of semantics.
>
> We had and still have enough surprises in preempt-rt where we force
> thread all handlers which were caused by various assumptions in the
> handler code. I really prefer that the system yells in such a case
> instead of letting run people into hard to debug problems silently.

I fully appreciate that.  And for exactly that reason (combined with
a tight timeschedule), I really just need to have the phy interrupt handler
running unchanged with the i2c irq controller.

/Esben
