Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab1EMSXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:23:48 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60637 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098Ab1EMSXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <4DCC3B5A.7090908@fastmail.fm>
References: <BANLkTimZkNa4_N8=7=H8JThZgjtocN0gFg@mail.gmail.com>
	<4DCC3B5A.7090908@fastmail.fm>
Date: Fri, 13 May 2011 13:23:43 -0500
Message-ID: <BANLkTi=zKvJx5QMHCsnhtEkiJ2yy649QEQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] tps65912: irq: add interrupt controller
From: Margarita Olaya <magi@slimlogic.co.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jack,

On Thu, May 12, 2011 at 2:56 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
> Hi Margarita,
>
> I'm no irq expert so the following might be wrong.
>
> This comment seems to contradict the code - the comment states that all
> interrupts are clear on read but the irq handler explicitly writes the
> value back to the interrupt register.
>
> Did you mean the comment to say that the irq handler explicitly clears
> the interrupts it handles?

Yeap, the current comment is not correct, I will update it, for
tps65912 we need to write 1 to clear the irq.
Thanks for review.

Regards,
Margarita

>
> On 12/05/2011 19:43, Margarita Olaya wrote:
>> +++ b/drivers/mfd/tps65912-irq.c
>> +/*
>> + * This is a threaded IRQ handler so can access I2C/SPI.  Since all
>> + * interrupts are clear on read the IRQ line will be reasserted and
>> + * the physical IRQ will be handled again if another interrupt is
>> + * asserted while we run - in the normal course of events this is a
>> + * rare occurrence so we save I2C/SPI reads.  We're also assuming that
>> + * it's rare to get lots of interrupts firing simultaneously so try to
>> + * minimise I/O.
>> + */
>> +static irqreturn_t tps65912_irq(int irq, void *irq_data)
>> +{
>> +     struct tps65912 *tps65912 = irq_data;
>> +     u32 irq_sts;
>> +     u32 irq_mask;
>> +     u8 reg;
>> +     int i;
>> +
>> +
>> +     tps65912->read(tps65912, TPS65912_INT_STS, 1, &reg);
>> +     irq_sts = reg;
>> +     tps65912->read(tps65912, TPS65912_INT_STS2, 1, &reg);
>> +     irq_sts |= reg << 8;
>> +     tps65912->read(tps65912, TPS65912_INT_STS3, 1, &reg);
>> +     irq_sts |= reg << 16;
>> +     tps65912->read(tps65912, TPS65912_INT_STS4, 1, &reg);
>> +     irq_sts |= reg << 24;
>> +
>> +     tps65912->read(tps65912, TPS65912_INT_MSK, 1, &reg);
>> +     irq_mask = reg;
>> +     tps65912->read(tps65912, TPS65912_INT_MSK2, 1, &reg);
>> +     irq_mask |= reg << 8;
>> +     tps65912->read(tps65912, TPS65912_INT_MSK3, 1, &reg);
>> +     irq_mask |= reg << 16;
>> +     tps65912->read(tps65912, TPS65912_INT_MSK4, 1, &reg);
>> +     irq_mask |= reg << 24;
>> +
>> +     irq_sts &= ~irq_mask;
>> +     if (!irq_sts)
>> +             return IRQ_NONE;
>> +
>> +     for (i = 0; i < tps65912->irq_num; i++) {
>> +             if (!(irq_sts & (1 << i)))
>> +                     continue;
>> +
>> +             handle_nested_irq(tps65912->irq_base + i);
>> +     }
>> +
>> +     /* Write the STS register back to clear IRQs we handled */
>> +     reg = irq_sts & 0xFF;
>> +     irq_sts >>= 8;
>> +     if (reg)
>> +             tps65912->write(tps65912, TPS65912_INT_STS, 1, &reg);
>> +     reg = irq_sts & 0xFF;
>> +     irq_sts >>= 8;
>> +     if (reg)
>> +             tps65912->write(tps65912, TPS65912_INT_STS2, 1, &reg);
>> +     reg = irq_sts & 0xFF;
>> +     irq_sts >>= 8;
>> +     if (reg)
>> +             tps65912->write(tps65912, TPS65912_INT_STS3, 1, &reg);
>> +     reg = irq_sts & 0xFF;
>> +     if (reg)
>> +             tps65912->write(tps65912, TPS65912_INT_STS4, 1, &reg);
>> +
>> +     return IRQ_HANDLED;
>> +}
>
> Thanks,
>
> Jack
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
