Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0FETi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:38:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab0FETiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AWs3RRz8W830ovcPQUtIOUC7zNqg3Gf2Pk36zoQqb6chZllmJ6qcjM2jhjvLfKfrke
         ovlcpExBcXbvPrE0dhIRz8zAZgfNZdIl2qX5c6I/6YD/dtkYPI+N9Xp8jufBKxmic5pC
         qKRpCV1RZB8/bhyemV/hM+i7k2/+zrnxXPFAk=
MIME-Version: 1.0
In-Reply-To: <20100605181816.7aae71c7@hina.wild-wind.fr.eu.org>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	<AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	<20100605151031.2d562268@hina.wild-wind.fr.eu.org>
	<AANLkTilUGOVPBtdl2KB2nrbra8uBO8q4AX0v57hCtr_9@mail.gmail.com>
	<20100605181816.7aae71c7@hina.wild-wind.fr.eu.org>
Date: Sat, 5 Jun 2010 21:38:20 +0200
Message-ID: <AANLkTimqTQ9FbewtwoVZiwinPFne8MWPowuJDjMgODW2@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
	interrupt handlers
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Marc Zyngier <maz@misterjones.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> What is the plan here, should all drivers change from
>> request_any_context_irq() at some point in time?
>
> All? Probably not. Only the few where the need arises, and after carefully
> checking that you're not introducing a horrible race condition somewhere
> (threaded handlers are running with interrupts enabled...).

Yes, and that is exactly one of the issues I wanted to address with the patch.
If you have a driver which uses an interrupt handler, which is designed
and tested in interrupt context, you really have to take care before turning
it into a threaded interrupt handler.

But if you have a slow interrupt controller which uses nested threaded
interrupt handler, then it should be safe to let the interrupt handler
run within the interrupt controllers thread, but with interrupts disabled.

Yes, it is propably better to rewrite the handler to be able to run
threaded, but the same could be said without the slow interrupt
handler. So unless all interrupt handlers should be rewritten
as threaded handlers, I don't see why it should not be possible
to just run a non-threaded interrupt handler, in a threaded
interrupt controllers thread, but with interrupts disabled.

Carefully checking for horrible race condition in a driver that you
really did not otherwise needed to work on is asking for
quite a bit, and I fear that this approach is doomed to actually
cause the horrible race conditions, because the checking
will be done by people without sufficient insight in the driver
in question.

/Esben
-- 
Esben Haabendal, Senior Software Consultant
DoréDevelopment ApS, Ved Stranden 1, 9560 Hadsund, DK-Denmark
Phone: +45 51 92 53 93, E-mail: eha@doredevelopment.dk
WWW: http://www.doredevelopment.dk
