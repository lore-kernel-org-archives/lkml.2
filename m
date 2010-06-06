Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0FFTu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:50:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41287 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0FFTuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cfni4eBZJ0SlD4lpcXVOfQkxhY9+IjuIDQGJaPwJWMpsh2f0rg+RHBNCkZBv6MKHde
         R5NNcVW7aSePhdpd4t5NpxknwFbaeF0nT/0k/4OvXkezixHKLxmQvirqfztC2oDSo2um
         PLgnKNwSALZAUQOU2vxfTMbQlorQEVX1dQ9SE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006052155100.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	<AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	<20100605151031.2d562268@hina.wild-wind.fr.eu.org>
	<alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
	<AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
	<alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>
	<AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
	<alpine.LFD.2.00.1006052155100.2933@localhost.localdomain>
Date: Sun, 6 Jun 2010 21:50:22 +0200
Message-ID: <AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
	interrupt handlers
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@misterjones.org>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 10:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> The phy interrupt handler calls disable_irq, which does not work
>> with an i2c irq controller (ie. the genirc buslock mutex), and I specifically
>> got rid of the buslock for pca9535 driver (powerpc only, though).
>
> And that's the fundamentally wrong approach.

Well, given you haven't seen what I have done there, I don't see how you
can be so sure ;-)

The only reason for the buslock in the pca9535 driver is to set the
direction (ie. input) for interrupt pins.  On powerpc, I do this in the map()
irq_chip function. So I don't see the need for buslock on powerpc.

>> This is really a drawback of the genirq buslock IMHO.
>
> No, it avoids races even on UP. It's there for a reason and there was
> a huge discussion about this last year.

I am not talking about it in general, but for the pca953x driver in particular.
The only thing that is done in the unlock is to set direction, and I don't see
the point in not doing this in earlier.  In most situations, it will
likely be set
even eariler, given that default direction is input, and that it is not uncommon
to set the direction appropriately early in the board init phase.

> Just because you have not hit the problem yet does not make it non
> existant.

Which particular problem should I be on the lookout for in pca953x
driver?

>> So until all handlers are rewritten to run threaded, I believe
>> something like the proposed patch will give value to people
>> with i2c irq controllers. Hopefully, not to many people are unlucky
>> enough to have this, but anyway...
>
> No it does not, as it just encourages people to disable buslocks and
> do simliar shitty crap.

Hold your horses, no reason to call it shitty when you haven't even seen
it. I didn't try to start any kind of general duscission for/against genirq
buslock.

Anyway,

>
>> >> Unless all interrupt handlers should be rewritten to be able to in both
>> >> thread and interrupt context, I fail to se the conflict between the patch
>> >> proposed and the work being done on request_any_context_irq().
>> >
>> > It's not a question of conflict. It's a question of semantics.
>> >
>> > We had and still have enough surprises in preempt-rt where we force
>> > thread all handlers which were caused by various assumptions in the
>> > handler code. I really prefer that the system yells in such a case
>> > instead of letting run people into hard to debug problems silently.
>>
>> I fully appreciate that.  And for exactly that reason (combined with
>> a tight timeschedule), I really just need to have the phy interrupt handler
>> running unchanged with the i2c irq controller.
>
> Yeah, and at the same time you rip out the buslock. Why are you not
> sending this patch as well ? Simply because you know that it is
> utterly wrong and a horrible hack.

No, it was send at the same time, but to the linuxppc-dev.  I do not
see it as utterly wrong, and I hope you will give it a look with an open
mind, not just assuming that it is shitty crap, utterly wrong or horrible
hack even before reading it, thanks ;-)

http://patchwork.ozlabs.org/patch/54717/

It is a longer patch, and I expect that it could be improved quite a
bit, but I really don't see it as a fundanmentally shitty.

> But at the same time you want to sell me a patch which rips out the
> prevention mechanism for your hack.

Which patch are you refering to?

The patch we are discussing here does not rip out any thing,

It simply adds support for using existing dirvers together
with handle_nested_irq().

> The time you spent to fiddle with the generic code and ripping out the
> buslock is probably more than it had taken to make the PHY driver
> thread safe.

Maybe, but I am not so sure.

The phy driver calls disable_irq_nosync(), which is documented as
"This function may be called from IRQ context."
And with disable_irq_nosync() calling chip_bus_lock() and
chip_bus_sync_unlock(), which definitely is not meant
for IRQ context, I got the understanding that it was not
the phy driver that needed fixing, but mroe the generic
buslock stuff, which I did not have the guts to touch, as
I understand it would be easy to get wrong.

So maybe you can help me out here, is disable_irq_nosync()
to be improved here?  It does not seem to be fair to
document that it can be called in IRQ context, and then
have it designed to blow up if done so in combination
with a genirq buslock driver.

> The buslock is there for a reason and if you can't use the code with
> the disable/enable_irq() in the atomic context, then this needs to be
> fixed there if you need to run the irq handler in thread context.

How can I disable_irq in interrupt context, with the interrupt handled
by a genirq buslock driver?

/Esben
-- 
Esben Haabendal, Senior Software Consultant
DoréDevelopment ApS, Ved Stranden 1, 9560 Hadsund, DK-Denmark
Phone: +45 51 92 53 93, E-mail: eha@doredevelopment.dk
WWW: http://www.doredevelopment.dk
