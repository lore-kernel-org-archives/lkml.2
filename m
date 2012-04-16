Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2DPJ1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:27:31 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60632 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2DPJ13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D0905D5A1AA@wm021.weinmann.com>
References: <20120413103937.GH7154@arwen.pp.htv.fi>
	<1334317476-10044-1-git-send-email-h.feurstein@gmail.com>
	<EF2E73589CA71846A15D0B2CDF79505D0905D5A1AA@wm021.weinmann.com>
Date: Mon, 16 Apr 2012 11:27:29 +0200
Message-ID: <CAFfN3gV0Cd2rrZ7OpGk51MPi71S2u7ZxWt4VLeirY+zz11yESA@mail.gmail.com>
Subject: Re: [PATCH] i2c-at91: fix data-loss issue
From: Hubert Feurstein <h.feurstein@gmail.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "balbi@ti.com" <balbi@ti.com>, "rmallon@gmail.com" <rmallon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16. April 2012 09:30 schrieb Voss, Nikolaus <N.Voss@weinmann.de>:
> Hubert Feurstein wrote on 2012-04-13:
>> In the interrupt handler both status-flags (TXCOMP and RXRDY) might be
>> pending at the same time. In this case TXCOMP is handled but NOT RXRDY
>> which causes a data-loss on the current transfer
>
> Right, this is definitely a bug and must be corrected. Part of my
> motivation for exclusively or-ing the irq bits was not reading/
> writing beyond the buffer because of (still) pending bits despite
> of an already finished transfer, so I gave TXCOMP the highest prio.
>
> Because of other reasons, write_next_byte() already checks this and
> does nothing if all data already has been written. My suggestion is
> to have read_next_byte() do this check too, as I don't trust the
> hardware to reset RXRDY _immediately_ after reading.
Adding a check in read_next_byte() would be good just for safety.

>
>> @@ -161,18 +161,22 @@ static irqreturn_t atmel_twi_interrupt(int irq, void
>> *dev_id)
>>  {
>>       struct at91_twi_dev *dev = dev_id;
>>       const unsigned status = at91_twi_read(dev, AT91_TWI_SR);
>> -     const unsigned irqstatus = status & at91_twi_read(dev, AT91_TWI_IMR);
>> +     unsigned irqstatus = status & at91_twi_read(dev, AT91_TWI_IMR);
>> +
>> +     irqstatus &= (AT91_TWI_RXRDY | AT91_TWI_TXRDY | AT91_TWI_TXCOMP);
>
> The above line should be unnecessary as no more than those interrupts
> are enabled anyway. Any special reason for this?
No special reason for this.

>
>> +     if (!irqstatus)
>> +             return IRQ_NONE;
>> +
>> +     if (irqstatus & AT91_TWI_RXRDY)
>> +             at91_twi_read_next_byte(dev);
>> +
>> +     if (irqstatus & AT91_TWI_TXRDY)
>> +             at91_twi_write_next_byte(dev);
>
> I would like to exclusively or TXRDY and RXRDY as those really should
> not be active at the same time. Keeps the decision tree lean ;-).
I agree, it should be save to xor at least those two.

>
>> @@ -189,6 +193,10 @@ static int
>>  at91_do_twi_transfer(struct at91_twi_dev *dev)       if (dev->msg->flags &
>>  I2C_M_RD) {          unsigned start_flags = AT91_TWI_START;
>> +             /* clear any pending data */
>> +             (void)at91_twi_read(dev, AT91_TWI_SR);
>> +             (void)at91_twi_read(dev, AT91_TWI_RHR);
>
> I would like to modify this, as this is a partial fix for the above bug
> which should already be fully fixed by the modified isr.
> I fear subtle data-loss if we make (partial) tabula rasa before each
> transfer. I'd rather add an assertion to check if the corresponding
> irqs are active as an indication for a driver/hw-bug.
You also can add both, print an error/warning if the state in SR is
not as expected and then add the two recovery lines.

>
> I'll repost the driver with your fix on positive feedback from you.
> Thanks for tracking this down.
>
> Ben, is there any chance to get this driver into next?
>
> Niko
>
>

Hubert
