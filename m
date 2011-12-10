Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab1LJR7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 12:59:14 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38390 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab1LJR7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 12:59:08 -0500
X-Sasl-enc: BeDviL45EoowNiSQ0IpRkmQQxgCCWZEa3XHHpiQcovKb 1323539946
Message-ID: <4EE39DDA.4050602@ladisch.de>
Date: Sat, 10 Dec 2011 18:58:50 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>	<4EDB6C10.10102@ladisch.de>	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>	<CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>	<4EDBA70E.3090905@ladisch.de>	<CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>	<CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>	<4EE0B156.4080708@ladisch.de>	<CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com>	<4EE1C55B.9010708@ladisch.de>	<CAPRPZsDtPhjm2S5QxDSkDV2zsz+ABCkL_Rkeq-=Fnpx4+Czzcw@mail.gmail.com>	<4EE20531.7000607@ladisch.de> <CAPRPZsBfLyWBSEO7UHc9irpKq-AhjT053BFQV=tamPYTb7SvsQ@mail.gmail.com>
In-Reply-To: <CAPRPZsBfLyWBSEO7UHc9irpKq-AhjT053BFQV=tamPYTb7SvsQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
> [...]
> - CPU services the IRQ, and does at least one (slow) PCI read to have
> the device deassert its IRQ line. In practice, more PCI read/writes
> are needed, requiring the bridge to do some PCIe traffic generation.
> - Bridge sees the IRQ line trasition and signals Deassert, This
> message has only a few usecs to arrive at the I/O-APIC.
> - _However_ the CPU has by large already handled the IRQ and gets
> interrupted again before the Deassert ever gets out. The resulting PCI
> bus traffic further delays the Deassert message (due to e.g. PCIe
> transmit credit exhaustion).
>
> My idea is that if we would not immediately hammer the bridge with
> PCIe transactions, the Deassert message may eventually arrive ?

PCIe messages are somewhat ordered; posted memory writes are allowed,
but IIRC a read transaction serializes all previous and following
transactions.  Assuming that all involved devices work correctly.

> Also, is there any control by Linux of the credits issued ?

I don't think these can be controlled by software.  The hardware is
supposed to get them correct.

> I therefore patched the polling system by detecting a stuck IRQ
> already after 10 unserviced IRQs. Then the polling system will take
> over for 50 cycles (5 seconds), after which the IRQ is reenabled.
>
> [ 1607.941232] irq 19: nobody cared (try booting with the "irqpoll" option)
> [ 1613.040185] Reenabling IRQ.
> [ 1908.541558] irq 19: nobody cared (try booting with the "irqpoll" option)
> [ 1913.640088] Reenabling IRQ.
> [ 2319.361659] irq 19: nobody cared (try booting with the "irqpoll" option)
> [ 2324.460064] Reenabling IRQ.
> [ 2782.285470] irq 19: nobody cared (try booting with the "irqpoll" option)
> [ 2787.384222] Reenabling IRQ.
> [ 3485.689347] irq 19: nobody cared (try booting with the "irqpoll" option)
> [ 3490.788079] Reenabling IRQ.
> [ 3810.336883] irq 19: nobody cared (try booting with the "irqpoll" option)

So the IRQ _does_ get unstuck eventually; I didn't expact that.

So either the ASM1083 delays its Deassert messages, or it is just way
too slow to react to changes in its PCI interrupt line inputs.

I'd guess that you can make the pollig time shorter; a few milliseconds
should be enough.


Your patch might be useful to others afflicted with this chip.  Could
you publish it?


Regards,
Clemens
