Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1BKUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:16:56 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:6206 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756989Ab1BKUQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:16:55 -0500
Message-ID: <4D559927.9080309@bluewatersys.com>
Date: Sat, 12 Feb 2011 09:16:39 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [patch 34/75] arm: ep93xx: Kill another instance of broken irq_desc
 fiddling
References: <20110210222908.661199947@linutronix.de> <20110210223257.597367298@linutronix.de> <4D548146.5090507@bluewatersys.com> <alpine.LFD.2.00.1102111240190.31804@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102111240190.31804@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/11 00:42, Thomas Gleixner wrote:
> On Fri, 11 Feb 2011, Ryan Mallon wrote:
>
>> On 02/11/2011 12:37 PM, Thomas Gleixner wrote:
>>> 1. This is a copy of the borked code in gpiolib
>>> 2. If you need information about irq state which is not exposed, then talk
>>>     to the maintainer of that code instead of adding totaly horrible open
>>>     coded access.
>> This code got added simply because it is sometimes helpful to be able to
>> see how various gpio/irq pins are configured. I'm happy to drop the
>> functionality (see below), but is there a better way to get this
>> information? Is it already available somewhere else (proc, sys)?
> No, but we can add that if it's required in a sane form.
>
> I don't have objections to expose debug informations in general, but
> I have objections that random code does this especially, when it's
> duplicated random code :)
>

Ok. Does it make sense to expose the interrupt configuration for all 
interrupts via proc, sys, debug, etc? Is this information useful to 
enough people to warrant it? I would rather have a global debug rather 
than individual platforms and drivers implementing it.

For the time being can we fix up the ep93xx gpio code with the amended 
patch below. It keeps the information that the pin is also configured as 
an interrupt and cleans the code up a bit.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
---

diff --git a/arch/arm/mach-ep93xx/gpio.c b/arch/arm/mach-ep93xx/gpio.c
index bec34b8..d0bcce4 100644
--- a/arch/arm/mach-ep93xx/gpio.c
+++ b/arch/arm/mach-ep93xx/gpio.c
@@ -347,52 +347,14 @@ static void ep93xx_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
  	gpio = ep93xx_chip->chip.base;
  	for (i = 0; i<  chip->ngpio; i++, gpio++) {
  		int is_out = data_dir_reg&  (1<<  i);
+		int irq = gpio_to_irq(gpio);

-		seq_printf(s, " %s%d gpio-%-3d (%-12s) %s %s",
+		seq_printf(s, " %s%d gpio-%-3d (%-12s) %s %s %s\n",
  				chip->label, i, gpio,
  				gpiochip_is_requested(chip, i) ? : "",
  				is_out ? "out" : "in ",
-				(data_reg&  (1<<  i)) ? "hi" : "lo");
-
-		if (!is_out) {
-			int irq = gpio_to_irq(gpio);
-			struct irq_desc *desc = irq_desc + irq;
-
-			if (irq>= 0&&  desc->action) {
-				char *trigger;
-
-				switch (desc->status&  IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_NONE:
-					trigger = "(default)";
-					break;
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "edge-falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "edge-rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "edge-both";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "level-high";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "level-low";
-					break;
-				default:
-					trigger = "?trigger?";
-					break;
-				}
-
-				seq_printf(s, " irq-%d %s%s",
-						irq, trigger,
-						(desc->status&  IRQ_WAKEUP)
-							? " wakeup" : "");
-			}
-		}
-
-		seq_printf(s, "\n");
+				(data_reg&  (1<<  i)) ? "hi" : "lo",
+				(!is_out&&  irq>= 0) ? "(interrupt)" : "");
  	}
  }


