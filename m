Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1AQTZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:25:13 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59594 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab1AQTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:25:11 -0500
Message-ID: <4D349787.80201@metafoo.de>
Date: Mon, 17 Jan 2011 20:24:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Sven Neumann <s.neumann@raumfeld.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: resume regression in 2.6.37
References: <1294933492.2535.23.camel@sven>	<alpine.LFD.2.00.1101131720350.2678@localhost6.localdomain6>	<1294938961.10740.24.camel@sven>	<alpine.LFD.2.00.1101131827080.2678@localhost6.localdomain6>	<1295260580.2060.29.camel@sven> <alpine.LFD.2.00.1101171142380.2678@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1101171142380.2678@localhost6.localdomain6>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/17/2011 01:40 PM, Thomas Gleixner wrote:
> On Mon, 17 Jan 2011, Sven Neumann wrote:
>
>> On Thu, 2011-01-13 at 18:33 +0100, Thomas Gleixner wrote:
>>
>>>> Without the revert there is absolutely no sign of resume. With the
>>>> change reverted I can see that the PXA powers up again, there's an LED
>>>> showing that the USB controller has power again. Unfortunately there's
>>>> seems to be another problem and the resume doesn't complete. I've tried
>>>> to get console output by using no_console_suspend, but there's just
>>>> gibberish on the console after resume :(
>>>>
>>>> Any idea on how to proceed from here? I could perhaps ask our hardware
>>>> engineer to try find out where exactly we are stuck in the resume. But
>>>> I'd like to avoid that if possible.
>>>
>>> Can you stick a printk into the set_wake() function of that irq chip
>>> and print the irq and on arguments and the return value . Run that
>>> with both stock 2.6.37 and the patch reverted.
>>
>> pxa3xx_set_wake(31, 1) returns 0
>>
>> Same result with stock 2.6.37 and the patch reverted. Except that
>> without the patch reverted, the device doesn't power up again.
>
> Ok, can we agree that the patch has no functional impact on the
> set_wake function? And I don't see a reason why reverting that patch
> results in a working resume. That does not make sense at all. Which
> compiler version are you using ?
>
> Thanks,
>
> 	tglx
>

Hi

If you take a look at the pxa gpio irq handling you'll see that it sets the
"set_wake" field of it's irq_chip after calling set_irq_chip for all of the irqs, so
the compat handler gets never installed.

So I guess the following patch fixes it:

diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
- --- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -111,13 +111,13 @@ static void __init pxa_init_low_gpio_irq(set_wake_t fn)
 	GRER0 &= ~0x3;
 	GEDR0 = 0x3;

+	pxa_low_gpio_chip.set_wake = fn;
+
 	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO1; irq++) {
 		set_irq_chip(irq, &pxa_low_gpio_chip);
 		set_irq_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
- -
- -	pxa_low_gpio_chip.set_wake = fn;
 }

 void __init pxa_init_irq(int irq_nr, set_wake_t fn)
@@ -142,13 +142,14 @@ void __init pxa_init_irq(int irq_nr, set_wake_t fn)
 	/* only unmasked interrupts kick us out of idle */
 	ICCR = 1;

+	pxa_internal_irq_chip.set_wake = fn;
+
 	for (irq = PXA_IRQ(0); irq < PXA_IRQ(irq_nr); irq++) {
 		set_irq_chip(irq, &pxa_internal_irq_chip);
 		set_irq_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}

- -	pxa_internal_irq_chip.set_wake = fn;
 	pxa_init_low_gpio_irq(fn);
 }

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk00l4cACgkQBX4mSR26RiMTMQCdGCiu3ALAIEe0dUkX3u5xeHmz
dggAnj2cePanr6HFi+6KQ4tF7cT6xoq0
=yxJs
-----END PGP SIGNATURE-----
