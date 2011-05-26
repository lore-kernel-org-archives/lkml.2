Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab1EZEz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 00:55:57 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:57337 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab1EZEz4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 00:55:56 -0400
From: Bibek BASU <bibek.basu@stericsson.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 26 May 2011 06:55:05 +0200
Subject: RE: Need Implementation Guidance : GPIO : AB8500 : Marked Broken
Thread-Topic: Need Implementation Guidance : GPIO : AB8500 : Marked Broken
Thread-Index: Acwa7PUsbdFh/xLVQPybapW8N8EvtgAcoN6A
Message-ID: <4E253D605AF50140A55CF6396EC99A241CC3E68778@EXDCVYMBSTM005.EQ1STM.local>
References: <4E253D605AF50140A55CF6396EC99A241CC3E681EE@EXDCVYMBSTM005.EQ1STM.local>
 <alpine.LFD.2.02.1105251536210.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105251536210.3078@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for the input. Will do the needful and repost the patch.

Regards
Bibek

-----Original Message-----
From: Thomas Gleixner [mailto:tglx@linutronix.de] 
Sent: Wednesday, May 25, 2011 8:34 PM
To: Bibek BASU
Subject: Re: Need Implementation Guidance : GPIO : AB8500 : Marked Broken

On Wed, 25 May 2011, Bibek BASU wrote:

> Hi Thomas,

Please keep such questions on the mailing list.
 
> I want to rectify the error pointed out by you in the ab8500-gpio
> driver present in driver/gpio/

> Your first point I am taking care off. Regarding 2nd point I need
> you to comment on how to implement.

> Below is the architecture & requirement I have for ab8500 gpio driver
> 
> Architecture:
> 1>AB8500 Chipset supports 42 gpio pins.
> 2>Out of the 42 pins, random 8 pins has interrupt support .
> 3> Separate interrupt is generated for falling edge and rising edge
> on each of these 8 GPIO pins. So total 16 interrupts.

According to the code you have 16 gpio pins with 2 interrupts each and
16 virtual interrupts :)

> Requirement:

> Driver user will only request once for any irq on any interrupt
> capable GPIO with any combination of flags IRQF_TRIGGER_RISING,
> IRQF_TRIGGER_FALLING or IRQ_TYPE_EDGE_BOTH. Internally it's the gpio
> driver's job to request for irq separately for rising and falling
> edge based on the user request.

> So the irq number given to user is a virtual irq. Which in
> internally mapped to actual irqs in the system.

So that makes 2 physical interrupts per virtual interrupt line and you
need to enable either one of them or both depending on the trigger
type, right ?

I think the concept of having virtual interrupts for this is just
wrong, the right place to deal with that absurdity is ab8500-core.

Create a new irq chip for the gpio lines. Install that chip and the
handler only for the 16 rising interrupts and ignore the 16 falling
bits, so they cannot be requested ....

static void gpio_mask(struct irq_data *data)
{
	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
	int offset = data->irq - ab8500->irq_base;
	int index = offset / 8;
	int mask = 1 << (offset % 8);

	ab8500->mask[index] |= mask;
	ab8500->mask[index + 2] |= mask;
}

static void gpio_unmask(struct irq_data *data)
{
	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
	unsigned int type = irqd_get_trigger_type(data);
	int offset = data->irq - ab8500->irq_base;
	int index = offset / 8;
	int mask = 1 << (offset % 8);

	if (type & IRQ_TYPE_EDGE_RISING)
		ab8500->mask[index] &= ~mask;
	if (type & IRQ_TYPE_EDGE_FALLING)
		ab8500->mask[index + 2] &= ~mask;
}

static int gpio_set_type(struct irq_data *data, unsigned int type)

	if (valid_trigger(type))
		return 0;
	return -EINVAL;
}

in sync_unlock() you need to deal with the two types. Btw, the current
unlock function is stupid anyway. It's called for a specific
interrupt, so you only ever have one bit changed, no need to iterate
over all registers.

static void ab8500_irq_sync_unlock(struct irq_data *data)
{
	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
        int offset = data->irq - ab8500->irq_base;
        int index = offset / 8;

	if (ab8500->oldmask[index] != ab8500->newmask[index])
	   	update_register(index);
	mutex_unlock();
}

Now split out the code into

static void  __ab8500_irq_sync_unlock(unsigned int irq, struct ab8500 *ab8500)
{
        int offset = irq - ab8500->irq_base;
        int index = offset / 8;

	if (ab8500->oldmask[index] != ab8500->newmask[index])
	   	update_register(index);
}

static void ab8500_irq_sync_unlock(struct irq_data *data)
{
	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);

	__ab8500_irq_sync_unlock(data->irq, ab8500);
	mutex_unlock();
}

and for the gpio you have

static void ab8500_irq_sync_unlock(struct irq_data *data)
{
	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);

	__ab8500_irq_sync_unlock(data->irq, ab8500);
	__ab8500_irq_sync_unlock(data->irq + 16, ab8500);
	mutex_unlock();
}

So the last thing is to have the following quirk in your demux
function:

static inline bool irq_is_gpio_falling(unsigned int irq)
{
	return irq >= AB8500_INT_GPIO6F && irq <= AB8500_INT_GPIO41F;
}

static irqreturn_t ab8500_irq(int irq, void *dev)
{
	....
		do {
			int bit = __ffs(value);
			int line = i * 8 + bit;
			int irq = ab8500->irq_base + line;

			if (irq_is_gpio_falling(irq))
				irq -= 16;

			handle_nested_irq(irq);
			value &= ~(1 << bit);
		} while (value);
}

That makes the complete irq mess in your gpio controller driver go
away and you just need the irq mapping function for your pins which
always hands out the rising edge numbers.

Thanks,

	tglx
