Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab1EMUxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:53:55 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33904 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab1EMUxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <4DCC3901.9090200@fastmail.fm>
References: <BANLkTikWhA2OQABA1QYUrLdasbmH8yusNg@mail.gmail.com>
	<4DCC3901.9090200@fastmail.fm>
Date: Fri, 13 May 2011 15:53:51 -0500
Message-ID: <BANLkTi=X23M+8_qDc5N25dVSfnuwWAPXUQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] mfd: tps65912: Add new mfd device
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

On Thu, May 12, 2011 at 2:46 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
> Hi Margarita,
>
> Just a few comments.
>
> On 12/05/2011 19:42, Margarita Olaya wrote:
> [snip]
>
>> +#if defined(CONFIG_SPI_MASTER)
>> +static int tps65912_spi_write(struct tps65912 *tps65912, u8 addr,
>> +                                                     int bytes, void *src)
>> +{
>> +     struct spi_device *spi = tps65912->spi_device;
>> +     u8 *data = (u8 *) src;
>> +     int ret;
>> +
>> +     unsigned long spi_data = 1 << 23 | addr << 15 | *data;
>> +     struct spi_transfer xfer;
>> +     struct spi_message msg;
>> +     u32 tx_buf = 0, rx_buf = 0;
> These are initialized below. Can we have a blank line here please.
I will fix.

>> +     tx_buf = spi_data;
>> +     rx_buf = 0;
>> +
>> +     xfer.tx_buf     = &tx_buf;
>> +     xfer.rx_buf     = NULL;
>> +     xfer.len        = sizeof(unsigned long);
>> +     xfer.bits_per_word = 24;
>> +
>> +     spi_message_init(&msg);
>> +     spi_message_add_tail(&xfer, &msg);
>> +
>> +     ret = spi_sync(spi, &msg);
>> +     return ret;
>> +}
>> +
>> +static int tps65912_spi_read(struct tps65912 *tps65912, u8 addr,
>> +                                                     int bytes, void *dest)
>> +{
>> +     struct spi_device *spi = tps65912->spi_device;
>> +
>> +     unsigned long spi_data = 0 << 23 | addr << 15;
>
> Is the 0 << 23 meant to be 1 << 23? Like the write function.
>
No, It should be zero, I will remove.

>> +     struct spi_transfer xfer;
>> +     struct spi_message msg;
>> +     int ret;
>> +     u8 *data = (u8 *) dest;
> Shouldn't need to cast a void *
>
>> +     u32 tx_buf = 0, rx_buf = 0;
> These are initialized below.
>
>> +     tx_buf = spi_data;
>> +     rx_buf = 0;
>> +
>> +     xfer.tx_buf     = &tx_buf;
>> +     xfer.rx_buf     = &rx_buf;
>> +     xfer.len        = sizeof(unsigned long);
>> +     xfer.bits_per_word = 24;
>> +
>> +     spi_message_init(&msg);
>> +     spi_message_add_tail(&xfer, &msg);
>> +
>> +     if (spi == NULL)
>> +             return 0;
>> +
>> +     ret = spi_sync(spi, &msg);
>> +     if (ret == 0)
>> +             *data = (u8) (rx_buf & 0xFF);
>> +     return ret;
>> +}
>> +
> The spi read/write functions both ignore the bytes argument and only
> transfer one byte, whereas the i2c versions appear to read/write
> multiple bytes. Which one is correct?
>
Both are correct, I'm passing bytes argument to spi read/write to make
it compatible with the declaration of tps65912_read/write functions
pointer.

>
> I'm confused about init_data in this function.
>> +static int __devinit tps65912_spi_probe(struct spi_device *spi)
>> +{
>> +     struct tps65912 *tps65912;
>> +     struct tps65912_platform_data *init_data;
>> +     int dcdc_avs, value, ret = 0;
>> +
>> +     init_data = kzalloc(sizeof(struct tps65912_platform_data),
>> +                                                             GFP_KERNEL);
>> +     if (init_data == NULL)
>> +             return -ENOMEM;
>
> We zero allocate it here
>
>> +     tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
>> +     if (tps65912 == NULL)
>> +             return -ENOMEM;
>> +
>> +     tps65912->dev = &spi->dev;
>> +     tps65912->spi_device = spi;
>> +     tps65912->read = tps65912_spi_read;
>> +     tps65912->write = tps65912_spi_write;
>> +     mutex_init(&tps65912->io_mutex);
>> +
>> +     dcdc_avs = (init_data->is_dcdc1_avs << 0 |
>> +                             init_data->is_dcdc2_avs  << 1 |
>> +                                     init_data->is_dcdc3_avs << 2 |
>> +                                             init_data->is_dcdc4_avs << 3);
>
> And then use it here so dcdc_avs is guaranteed to be zero.
>
>> +     if (dcdc_avs) {
>> +             tps65912->read(tps65912, TPS65912_I2C_SPI_CFG, 1, &value);
>> +             dcdc_avs |= value;
>> +             tps65912->write(tps65912, TPS65912_I2C_SPI_CFG, 1, &dcdc_avs);
>> +     }
> Which means that this code will never run.
>
I will fix.

>> +
>> +     spi_set_drvdata(spi, tps65912);
>> +     ret = mfd_add_devices(tps65912->dev, -1,
>> +                           tps65912s, ARRAY_SIZE(tps65912s),
>> +                           NULL, 0);
>> +     if (ret < 0)
>> +             goto err;
>> +
>> +     return ret;
>> +
>> +err:
>> +     mfd_remove_devices(tps65912->dev);
>> +     kfree(tps65912);
>> +     return ret;
>> +}
>
> And as far as I can see nothing ever frees it.
>
I'll add kfree(init_data)

Regards,
Margarita
> Also this is not present in the i2c version of this function...
>
> Thanks,
>
> Jack
>
>
