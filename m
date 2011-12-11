Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab1LKP2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 10:28:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46889 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1LKP2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 10:28:35 -0500
MIME-Version: 1.0
In-Reply-To: <4EE39DDA.4050602@ladisch.de>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
	<CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
	<4EDBA70E.3090905@ladisch.de>
	<CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>
	<CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>
	<4EE0B156.4080708@ladisch.de>
	<CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com>
	<4EE1C55B.9010708@ladisch.de>
	<CAPRPZsDtPhjm2S5QxDSkDV2zsz+ABCkL_Rkeq-=Fnpx4+Czzcw@mail.gmail.com>
	<4EE20531.7000607@ladisch.de>
	<CAPRPZsBfLyWBSEO7UHc9irpKq-AhjT053BFQV=tamPYTb7SvsQ@mail.gmail.com>
	<4EE39DDA.4050602@ladisch.de>
Date: Sun, 11 Dec 2011 16:28:34 +0100
Message-ID: <CAPRPZsC0j765Kq4Oi+52m3YPsrEtQwEabDMoEkf8md-UyrOZyw@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the IRQ _does_ get unstuck eventually; I didn't expact that.

It would nevertheless make sense that the designer of the I/O-APIC
would have implemented a reasonable timeout for INTx-Deassert
reception. Perhaps that's what we see.

> So either the ASM1083 delays its Deassert messages, or it is just way
> too slow to react to changes in its PCI interrupt line inputs.

I'm afraid the only sensible thing to find this out would be to
somehow monitor the PCIe link traffic into the FCH from this ASM1083.
Maybe someone from AMD knows if this can be done ? Let's not forget
that the board seems to run fine under the Windows 7 O/S and maybe
Linux simply doesn't do a special trick with the bridge or the chipset
that Windows does. So, without further evidence, I would not (yet)
blame the bridge.

> I'd guess that you can make the pollig time shorter; a few milliseconds
> should be enough.

I tested the patch for a while now. I indeed decreased the polling
interval to 10 ms (100 Hz), and the IRQ is already enabled after 1
second (100 cycles). It works to a degree that the computer system
actually becomes useful. Under heavy use, the patch kicks in up to 10
times a minute. Otherwise it only is required a few times per hour. I
also turn off polling entirely when it is no longer needed.

Specifically for the Asus E45M1-M PRO I would recommend:

1. The IRQ bug manifests itself when using any device behind the
ASM1083 bridge. That includes the 2 PCI slots on the motherboard, as
well as the Firewire interface. Avoid their use. Preferably use the
PCIe x1 slot.

2. An important problem is that, when IRQ 16..19 goes down, an
integrated device, which otherwise works flawlessly, goes along with
it. This includes the SATA, USB and both audio (HDMI / Analog)
subsystems. If possible, enable the use of MSI for these devices.
Clemens's patch for AHCI MSI is a real help here.

3. Step 1 above will practically eliminate the occurrence of the IRQ
bug. If the PCI bus really is needed, the patch below must be used
(with the kernel irqpoll command line option turned on, of course).

> Your patch might be useful to others afflicted with this chip.  Could
> you publish it?

No problem, but I've never done this before. Is the result of diff
below ok ? Could someone specialized also have a look into the
thread-safety ?


J.


(Begin of patch for kernel/irq/spurious.c)

21c21
< #define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
---
> #define POLL_SPURIOUS_IRQ_INTERVAL (HZ/100)
144c144
<       int i;
---
>       int i, poll_again;
149a150
>       poll_again = 0; /* Will stay false as long as no polling candidate is found */
151c152
<               unsigned int state;
---
>               unsigned int state, irq;
161,164c162,182
<
<               local_irq_disable();
<               try_one_irq(i, desc, true);
<               local_irq_enable();
---
>
>               /* We end up here with a disabled spurious interrupt.
>                  desc->irqs_unhandled now tracks the number of times
>                  the interrupt has been polled */
>
>               irq = desc->irq_data.irq;
>               if (desc->irqs_unhandled < 100) { /* 1 second delay with poll frequency 100 Hz */
>                       if (desc->irqs_unhandled == 0)
>                               printk("Polling IRQ %d\n", irq);
>                       local_irq_disable();
>                       try_one_irq(i, desc, true);
>                       local_irq_enable();
>                       desc->irqs_unhandled++;
>                       poll_again = 1;
>               } else {
>                       printk("Reenabling IRQ %d\n", irq);
> 			irq_enable(desc); /* Reenable the interrupt line */
> 			desc->depth--;
> 			desc->istate &= (~IRQS_SPURIOUS_DISABLED);
> 			desc->irqs_unhandled = 0;
> 		}
165a184,186
> 	if (poll_again)
> 		mod_timer(&poll_spurious_irq_timer,
> 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
168,169d188
< 	mod_timer(&poll_spurious_irq_timer,
< 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
180c199
<  * If 99,900 of the previous 100,000 interrupts have not been handled
---
>  * If 9 of the previous 10 interrupts have not been handled
184c203,211
<  * (The other 100-of-100,000 interrupts may have been a correctly
---
>  * Although this may cause early deactivation of a sporadically
>  * malfunctioning IRQ line, the poll system will:
>  * a) Poll it for 100 cycles at a 100 Hz rate
>  * b) Reenable it afterwards
>  *
>  * In worst case, with current settings,  this will cause short bursts
>  * of 10 interrupts every second.
>  *
>  * (The other single interrupt may have been a correctly
305c332
< 	if (likely(desc->irq_count < 100000))
---
> 	if (likely(desc->irq_count < 10))
309c336
< 	if (unlikely(desc->irqs_unhandled > 99900)) {
---
> 	if (unlikely(desc->irqs_unhandled >= 9)) {
313c340
< 		__report_bad_irq(irq, desc, action_ret);
---
> 		/* __report_bad_irq(irq, desc, action_ret); */
317c344
< 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
---
> 		printk(KERN_EMERG "Disabling IRQ %d\n", irq);

(End of patch)
