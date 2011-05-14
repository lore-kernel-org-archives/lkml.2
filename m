Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1ENJxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 05:53:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56740 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860Ab1ENJxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 05:53:47 -0400
X-Sasl-enc: RN+Zvw8cvDFr9B7dd2/xf3PtoF7a7a2R6Ge3YYLvknnX 1305366826
Message-ID: <4DCE512B.50701@fastmail.fm>
Date: Sat, 14 May 2011 10:53:47 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Margarita Olaya <magi@slimlogic.co.uk>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Subject: Re: [PATCHv2 1/4] mfd: tps65912: Add new mfd device
References: <BANLkTikWhA2OQABA1QYUrLdasbmH8yusNg@mail.gmail.com>	<4DCC3901.9090200@fastmail.fm> <BANLkTi=X23M+8_qDc5N25dVSfnuwWAPXUQ@mail.gmail.com>
In-Reply-To: <BANLkTi=X23M+8_qDc5N25dVSfnuwWAPXUQ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/2011 21:53, Margarita Olaya wrote:
>>> +static int tps65912_spi_read(struct tps65912 *tps65912, u8 addr,
>>> +                                                     int bytes, void *dest)
>>> +{
>>> +     struct spi_device *spi = tps65912->spi_device;
>>> +
>>> +     unsigned long spi_data = 0 << 23 | addr << 15;
>>
>> Is the 0 << 23 meant to be 1 << 23? Like the write function.
>>
> No, It should be zero, I will remove.

Is it a read vs write bit?

You don't have to remove it but a comment explaining that bit 23 is the
read bit would help.

> 
>>> +     struct spi_transfer xfer;
>>> +     struct spi_message msg;
>>> +     int ret;
>>> +     u8 *data = (u8 *) dest;
>> Shouldn't need to cast a void *
>>
>>> +     u32 tx_buf = 0, rx_buf = 0;
>> These are initialized below.
>>
>>> +     tx_buf = spi_data;
>>> +     rx_buf = 0;
>>> +
>>> +     xfer.tx_buf     = &tx_buf;
>>> +     xfer.rx_buf     = &rx_buf;
>>> +     xfer.len        = sizeof(unsigned long);
>>> +     xfer.bits_per_word = 24;
>>> +
>>> +     spi_message_init(&msg);
>>> +     spi_message_add_tail(&xfer, &msg);
>>> +
>>> +     if (spi == NULL)
>>> +             return 0;
>>> +
>>> +     ret = spi_sync(spi, &msg);
>>> +     if (ret == 0)
>>> +             *data = (u8) (rx_buf & 0xFF);
>>> +     return ret;
>>> +}
>>> +
>> The spi read/write functions both ignore the bytes argument and only
>> transfer one byte, whereas the i2c versions appear to read/write
>> multiple bytes. Which one is correct?
>>
> Both are correct, I'm passing bytes argument to spi read/write to make
> it compatible with the declaration of tps65912_read/write functions
> pointer.
> 

But if anyone ever calls the tps65912_read/write functions with bytes !=
1 then this will fail, but only on the SPI case.

If they are only ever called with bytes == 1 then you can simply remove
the bytes argument.

Thanks,

Jack
