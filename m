Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1CVMiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:38:12 -0400
Received: from [77.233.226.4] ([77.233.226.4]:52378 "EHLO
	mail.doredevelopment.dk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755861Ab1CVMiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:38:10 -0400
From: Esben Haabendal <eha@dev.doredevelopment.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Subject: Re: [PATCH] Support IRQ_NOAUTOEN flag in set_irq_chained_handler()
References: <1300435389-11048-1-git-send-email-eha@doredevelopment.dk>
	<alpine.LFD.2.00.1103182135260.2787@localhost6.localdomain6>
	<87hbavv83c.fsf@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1103221215000.31464@localhost6.localdomain6>
Date: Tue, 22 Mar 2011 13:38:07 +0100
In-Reply-To: <alpine.LFD.2.00.1103221215000.31464@localhost6.localdomain6>
	(Thomas Gleixner's message of "Tue, 22 Mar 2011 12:17:20 +0100 (CET)")
Message-ID: <87r59ztjo0.fsf@eha.doredevelopment.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Tue, 22 Mar 2011, Esben Haabendal wrote:
>
>> Thomas Gleixner <tglx@linutronix.de> writes:
>> 
>> > On Fri, 18 Mar 2011, eha@doredevelopment.dk wrote:
>> >
>> >> From: Esben Haabendal <eha@doredevelopment.dk>
>> >> 
>> >> Handle IRQ_NOAUTOEN in __set_irq_handler() (ie. for
>> >> set_irq_chained_handler()) instead of just silently ignoring it, and in
>> >> the same way as is done in __setup_irq() (ie. request_irq()).
>> >> 
>> >> This give a more consistent interface, and also adheres better to
>> >> the rule of least surprise.
>> >
>> > Well, that might be less surprising for you, but you will be surprised
>> > that such a change would be a real big surprise for all users of
>> > chained handlers in arch/arm. They simply would not work anymore.
>> 
>> How is that?  I don't see any use of IRQ_NOAUTOEN flag in arch/arm at
>> all.  Is there some other way that IRQ_NOAUTOEN get's enabled in
>> arch/arm?  Or is my patch broken in some way that it does change irq
>> handler setup when IRQ_NOAUTOEN is not set?
>
> Ooops, sorry. I had it somewhere in the back of my memory that ARM
> marked all interrupts IRQ_NOAUTOEN by default. Confused that with
> NOPROBE.
>  
>> The idea of the patch is that it will do exactly the same as
>> before, unless you specifically set IRQ_NOAUTOEN before calling
>> set_irq_chained_handler...
>
> I understand the patch :)
>  
>> > So we _cannot_ change the semantics here. All we can do is document
>> > it.
>> 
>> With the current semantics, how are one supposed to be able use
>> set_irq_chained_handler without having the handler enabled immediately?
>
> Not at all. Why do you want to do that ?

I have a system where 

I setup the chained interrupt handler (together with a lot of other
stuff related to the CPLD firmware the interrupt controller lives in) in
of_platform_driver.probe().  The CPLD may be (re)programmed from
user-space, so all driver functionality is disabled until user-space
either programs the CPLD or gives a signal that this will not happen.

I thought it would be the cleanest solution to keep driver
initialization in the probe() function, and just enable it later on.

And I cannot just set the mask early, as I am not guaranteed how the irq
line is behaving and if there actually is a mask register before it is
programmed.

/Esben
