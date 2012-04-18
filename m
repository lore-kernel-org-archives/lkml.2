Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2DRWcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:32:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37015 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2DRWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:32:46 -0400
MIME-Version: 1.0
In-Reply-To: <1334787792.3143.19.camel@pasglop>
References: <1334756420-12019-1-git-send-email-linus.walleij@stericsson.com>
	<1334787792.3143.19.camel@pasglop>
Date: Thu, 19 Apr 2012 00:32:45 +0200
Message-ID: <CACRpkdZkfr6dx6hRQunCKVm7E2jDz5yud1vZ4V=9-oLOk1YLQQ@mail.gmail.com>
Subject: Re: [PATCH] irqdomain: print a warning if domains contain IRQ 0
From: Linus Walleij <linus.walleij@linaro.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 12:23 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2012-04-18 at 15:40 +0200, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Some of the clients using IRQ domains from the ARM VIC
>> (arch/arm/common/vic.c) don't know that their (hardware) IRQ 0
>> is silently ignored by the IRQ core, they will just notice
>> that they're not getting this IRQ anymore. So print a warning
>> if a domain contains IRQ 0 (NO_IRQ) so we get some noise about
>> it atleast.
>
> I don't understand. HW IRQ 0 is not ignored and works perfectly
> fine on "normal" remapped domains. Or is this specific to "legacy
> domains" ? In this case pls make it clear in the subject :-)

I'm trying ... but maybe not succeeding.

The ARM platforms using the VIC and its domain translation
have been converted to use domains without also renumbering
their Linux IRQ numbers. So they still have, in their low IRQ range,
still a 1-1 mapping between HW and Linux IRQ. Including IRQ 0.

E.g (as recently posted a patch for):

(arch/arm/mach-u300/include/mach/irqs.h)
#define IRQ_U300_INTCON0_START          0
#define IRQ_U300_INTCON1_START          32
/* These are on INTCON0 - 30 lines */
#define IRQ_U300_IRQ0_EXT               0
#define IRQ_U300_IRQ1_EXT               1
#define IRQ_U300_DMA                    2

The kernel is using IRQ_U300_IRQ0_EXT which of course
stopped working now.

Another example, mach-nomadik/include/mach/irqs.h:

#define IRQ_VIC_START           0       /* first VIC interrupt is 0 */
/*
 * Interrupt numbers generic for all Nomadik Chip cuts
 */
#define IRQ_WATCHDOG                    0
#define IRQ_SOFTINT                     1
#define IRQ_CRYPTO                      2
#define IRQ_OWM                         3
#define IRQ_MTU0                        4

I hope nobody tries to use the watchdog now...

Another example:
arch/arm/mach-versatile/include/mach/irqs.h

#define IRQ_VIC_START           0
#define IRQ_WDOGINT             (IRQ_VIC_START + INT_WDOGINT)
#define IRQ_SOFTINT             (IRQ_VIC_START + INT_SOFTINT)
#define IRQ_COMMRx              (IRQ_VIC_START + INT_COMMRx)
#define IRQ_COMMTx              (IRQ_VIC_START + INT_COMMTx)

This INT_WDOGINT is incidentally also 0.

So all of these are effectively broken now, and needs to have
their IRQ offsets changed. I just sent a patch to U300 fixing
this for that platform, but if I had this warning I would have
noticed that something was wrong much earlier.

Yours,
Linus Walleij
