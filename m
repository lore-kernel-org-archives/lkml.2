Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab1EXVk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:40:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46813 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab1EXVkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TsNe8R8Z5ykhp3ahwikY1svNw63JPQkf5n0A8KLnm7rJOymwDTNniX8cPPxeQmPgcY
         d5HS3KNG0V+dX8mh+8pRMSz39gQo+96wSchmRexoH5mlZicNfz7v5WY5xSlL6iemeVph
         QGwc/URjTtY3glHWil9BibZTtk1ALYNR8Phb0=
MIME-Version: 1.0
In-Reply-To: <20110516090813.GA26487@linutronix.de>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
	<1304166750-31125-8-git-send-email-dsd@laptop.org>
	<20110516090813.GA26487@linutronix.de>
Date: Tue, 24 May 2011 22:40:25 +0100
X-Google-Sender-Auth: dXKUEsEoeSuB3MUp-fGRGtdzQfs
Message-ID: <BANLkTimpFYMpQFY9J7pa0NygGoQ8dLdArA@mail.gmail.com>
Subject: Re: [PATCH 07/11] x86, olpc-xo1-sci: Add GPE handler and ebook switch functionality
From: Daniel Drake <dsd@laptop.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2011 10:08, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>>+
>>+      /* Enable EC SCI events */
>>+      cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_EVENTS_ENABLE);
>>+
>>+      /* Set the SCI to cause a PME event on group 7 */
>>+      cs5535_gpio_setup_event(OLPC_GPIO_ECSCI, 7, 1);
>>+
>>+      /* And have group 7 also fire the SCI interrupt */
>>+      cs5535_gpio_set_irq(7, sci_irq);
>
> What do you do here? Could this be hidden behind a gpio irq_chip or is
> this too olpc specific?

Thanks for looking at these patches.

I looked into irq_chip alongside the CS5535 docs. Initially this
looked like a good suggestion - any CS5535 GPIO can be mapped to one
of 8 PIC-level interrupts, which seems like a good match for irq_chip.

However, this isn't what we're doing here.

CS5535 GPIOs can either be mapped to interrupts, *or* to a Power
Management Event (PME). A PME is a CS5535-specific concept; its an
event that will bring the system out of suspend if it is sleeping. In
this case, we are mapping a GPIO to a PME. I'm not aware of any
appropriate Linux abstraction for this. Thats all done in
cs5535_gpio_setup_event().

The CS5535 also has a highly programmable PIC, with loads of possible
input and mapping options. The call to cs5535_gpio_set_irq() then
programs the PIC to map PME input to an IRQ line. This function is
both misnamed and misplaced; it is unrelated to GPIOs and is simply
one of the many generic knobs on the PIC. If there was one, this
function should belong in a cs5535-pic driver, named something
according to "IRQ Mapper Unrestricted Z Select High".

So, I'm left feeling that irq_chip isn't an appropriate abstraction,
because the mapping made to the IRQ line is indirect via PME events,
and that is significant in the context of this driver (where wakeup
control is a big thing). However, it may be worthwhile moving
cs5535_gpio_set_irq() into cs5535.h as a static inline with a more
appropriate name. I could also add some explanatory comments in this
part of the code.

What do you think?

Thanks,
Daniel
