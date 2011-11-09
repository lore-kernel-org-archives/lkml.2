Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1KIWXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:23:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab1KIWXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:23:00 -0500
Message-ID: <4EBAFD3E.5070609@gmail.com>
Date: Thu, 10 Nov 2011 09:22:54 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: balbi@ti.com
CC: Nikolaus Voss <n.voss@weinmann.de>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, khali@linux-fr.org, nicolas.ferre@atmel.com
Subject: Re: [PATCH v4 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
References: <cover.1320853921.git.n.voss@weinmann.de> <fc7ccca66f0ffea1aa9c0409162b4a66974c46b3.1320853921.git.n.voss@weinmann.de> <20111109195925.GB17406@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111109195925.GB17406@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/11 06:59, Felipe Balbi wrote:

> Hi,
> 
> On Tue, Nov 08, 2011 at 11:49:46AM +0100, Nikolaus Voss wrote:
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index e8a1852..fba6da6 100644

>> +	ckdiv = 0;
>> +	while (cdiv > 255) {
>> +		ckdiv++;
>> +		cdiv = cdiv >> 1;
>> +	}
>> +
>> +	if (cpu_is_at91rm9200() && (ckdiv > 5)) {
>> +		dev_err(dev->dev, "AT91RM9200 Erratum #22: using ckdiv = 5.\n");
> 
> is it really an error ? Or would it be enough as dev_dbg() ?


dev_warn is probably appropriate.

> 
>> +static int at91_do_twi_transfer(struct at91_twi_dev *dev, bool is_read)
>> +{
>> +	int ret;
>> +
>> +	INIT_COMPLETION(dev->cmd_complete);
>> +	if (is_read) {
>> +		if (!dev->buf_len)
>> +			at91_twi_write(dev, AT91_TWI_CR,
>> +				       AT91_TWI_START | AT91_TWI_STOP);
>> +		else
>> +			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_START);
>> +		at91_twi_write(dev, AT91_TWI_IER,
>> +			       AT91_TWI_TXCOMP | AT91_TWI_RXRDY);
>> +	} else {
>> +		at91_twi_write_next_byte(dev);
>> +		at91_twi_write(dev, AT91_TWI_IER,
>> +			       AT91_TWI_TXCOMP | AT91_TWI_TXRDY);
>> +	}
>> +
>> +	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
>> +							dev->adapter.timeout);
>> +	if (ret == 0) {
>> +		dev_err(dev->dev, "controller timed out\n");
>> +		at91_init_twi_bus(dev);
>> +		return -ETIMEDOUT;
>> +	}
>> +	if (dev->transfer_status & AT91_TWI_NACK) {
>> +		dev_dbg(dev->dev, "received nack\n");
>> +		return -ENODEV;
> 
> not sure error code matches here. If the HW replies with NACK you tell
> your users there's no I2C adapter ? Sounds a bit weird to me...


I think -ENODEV was used because a NACK can mean that there is no device
at the address you are trying to talk to. Other drivers appear to use
-EIO or -EREMOTEIO. The latter is possibly more correct.

~Ryan



