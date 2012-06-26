Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2FZNta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:49:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37413 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab2FZNt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120626060936.GA12229@avionic-0098.adnet.avionic-design.de>
References: <1340658390-29569-1-git-send-email-aletes.xgr@gmail.com>
	<20120626060936.GA12229@avionic-0098.adnet.avionic-design.de>
Date: Tue, 26 Jun 2012 10:49:27 -0300
Message-ID: <CAAAP30HU8jyFFgzo39RozrOGvpSwVZRUkKsbJVe_ffEu27K-Fw@mail.gmail.com>
Subject: Re: [PATCH v2] spi/pl022: add devicetree support
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Roland Stigge <stigge@antcom.de>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 3:09 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Mon, Jun 25, 2012 at 06:06:28PM -0300, Alexandre Pereira da Silva wrote:
> [...]
>> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> [...]
>> @@ -1733,7 +1744,7 @@ static int calculate_effective_freq(struct pl022 *pl022, int freq, struct
>>   * A piece of default chip info unless the platform
>>   * supplies it.
>>   */
>> -static const struct pl022_config_chip pl022_default_chip_info = {
>> +static struct pl022_config_chip pl022_default_chip_info = {
>>       .com_mode = POLLING_TRANSFER,
>>       .iface = SSP_INTERFACE_MOTOROLA_SPI,
>>       .hierarchy = SSP_SLAVE,
>
> What's the reason for removing the const? You're only reading data from
> the structure.

I are right. I will remove this change. It was a left-over from an
older version.

> [...]
>> @@ -1998,8 +2039,14 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>>               goto err_no_pdata;
>>       }
>>
>> +     num_cs = platform_info->num_chipselect;
>> +#ifdef CONFIG_OF
>> +     of_property_read_u32(np, "pl022,num-chipselects", &num_cs);
>> +#endif
>
> This...
>
> [...]
>> @@ -2017,13 +2064,40 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>>        * on this board
>>        */
>>       master->bus_num = platform_info->bus_id;
>> -     master->num_chipselect = platform_info->num_chipselect;
>> +     master->num_chipselect = num_cs;
>>       master->cleanup = pl022_cleanup;
>>       master->setup = pl022_setup;
>>       master->prepare_transfer_hardware = pl022_prepare_transfer_hardware;
>>       master->transfer_one_message = pl022_transfer_one_message;
>>       master->unprepare_transfer_hardware = pl022_unprepare_transfer_hardware;
>>       master->rt = platform_info->rt;
>> +     master->dev.of_node = dev->of_node;
>> +
>> +#ifdef CONFIG_OF
>> +     for (i = 0; i < num_cs; i++) {
>> +             int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
>> +
>> +             if (cs_gpio == -EPROBE_DEFER) {
>> +                     status = -EPROBE_DEFER;
>> +                     goto err_no_gpio;
>> +             }
>> +
>> +             pl022->chipselect[i] = cs_gpio;
>> +
>> +             if (gpio_is_valid(cs_gpio)) {
>> +                     if (gpio_request(cs_gpio, "ssp-pl022"))
>> +                             dev_err(&adev->dev,
>> +                                     "could not request %d gpio\n", cs_gpio);
>> +                     else if (gpio_direction_output(cs_gpio, 1))
>> +                             dev_err(&adev->dev,
>> +                                     "could set gpio %d as output\n",
>> +                                     cs_gpio);
>> +             }
>> +     }
>> +#else
>> +     for (i = 0; i < num_cs; i++)
>> +             pl022->chipselect[i] = -EINVAL;
>> +#endif
>
> ... and this would be good candidates for IS_ENABLED(CONFIG_OF).
>
>>
>>       /*
>>        * Supports mode 0-3, loopback, and active low CS. Transfers are
>> @@ -2130,6 +2204,9 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>>   err_no_ioremap:
>>       amba_release_regions(adev);
>>   err_no_ioregion:
>> + #ifdef CONFIG_OF
>> + err_no_gpio:
>> + #endif
>
> If you use the IS_ENABLED() macro, then you no longer need these either.

Thanks for the suggestion, looks cleaner.
