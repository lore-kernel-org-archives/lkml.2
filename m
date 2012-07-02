Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2GBKcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:32:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39607 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab2GBKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120701083923.GA29380@avionic-0098.mockup.avionic-design.de>
References: <1340719537-627-1-git-send-email-aletes.xgr@gmail.com>
	<20120701083923.GA29380@avionic-0098.mockup.avionic-design.de>
Date: Mon, 2 Jul 2012 07:32:00 -0300
Message-ID: <CAAAP30FzMhs+o+i3CF-+TNO-yBjg=aVSOWukseqD=HhLhS37cg@mail.gmail.com>
Subject: Re: [PATCH v3] spi/pl022: add devicetree support
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Roland Stigge <stigge@antcom.de>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 1, 2012 at 5:39 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Tue, Jun 26, 2012 at 11:05:36AM -0300, Alexandre Pereira da Silva wrote:
>> Add the chipselect array and cur_cs properties to pl022 main structure
>>
>> Add a wrapper function to decide if the cs should be controlled by the
>> cs_control callback or the chipselect gpio
>>
>> Populate chipselect property from cs-gpios
>>
>> Populate master->dev.of_node, so the spi bus can find child spi
>> devices and register them
>>
>> At pl022 setup, fill chip_data structure from dt nodes, if not provided
>> by platform.
>>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> Tested-by: Roland Stigge <stigge@antcom.de>
>> ---
>> Applies to v3.5-rc4
>>
>> Changes since v2:
>> * Use IS_ENABLED instead of #ifdef
>> * Remove bogus const change
>>
>> Changes since v1:
>> * return EPROBE_DEFFER if gpios are not initialized yet
>>
>> Thanks Thierry Reding for reviewing and improvements suggestions
>>
>>  .../devicetree/bindings/spi/spi_pl022.txt          |   15 +++
>>  drivers/spi/spi-pl022.c                            |  115 ++++++++++++++++----
>>  2 files changed, 111 insertions(+), 19 deletions(-)
>>
> [...]
>> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> [...]
>> @@ -1998,8 +2039,14 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>>               goto err_no_pdata;
>>       }
>>
>> +     num_cs = platform_info->num_chipselect;
>> +#if IS_ENABLED(CONFIG_OF)
>> +     of_property_read_u32(np, "pl022,num-chipselects", &num_cs);
>> +#endif
>> +
>
> Actually this has even more advantages if you use it as a condition in
> an if expression:
>
>         if (IS_ENABLED(CONFIG_OF))
>                 of_property_read_u32(...);
>
> The above will be compiled wether CONFIG_OF is enabled or not, but it
> will not be included in the final output because of the compiler's DCE
> (dead code elimination) seeing this as "if (0)". The result is that the
> source code gets much better compile coverage and errors in the
> conditional code can be caught earlier.
>
>> @@ -2017,13 +2064,40 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>>        * on this board
>>        */
>>       master->bus_num = platform_info->bus_id;
>> -     master->num_chipselect = platform_info->num_chipselect;
>> +     master->num_chipselect = num_cs;
>>       master->cleanup = pl022_cleanup;
>>       master->setup = pl022_setup;
>>       master->prepare_transfer_hardware = pl022_prepare_transfer_hardware;
>>       master->transfer_one_message = pl022_transfer_one_message;
>>       master->unprepare_transfer_hardware = pl022_unprepare_transfer_hardware;
>>       master->rt = platform_info->rt;
>> +     master->dev.of_node = dev->of_node;
>> +
>> +#if IS_ENABLED(CONFIG_OF)
>> +     for (i = 0; i < num_cs; i++) {
>> +             int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
>> +
>> +             if (cs_gpio == -EPROBE_DEFER) {
>> +                     status = -EPROBE_DEFER;
>> +                     goto err_no_gpio;
>> +             }
>> +
>> +             pl022->chipselect[i] = cs_gpio;
>> +
>> +             if (gpio_is_valid(cs_gpio)) {
>> +                     if (gpio_request(cs_gpio, "ssp-pl022"))
>> +                             dev_err(&adev->dev,
>> +                                     "could not request %d gpio\n", cs_gpio);
>> +                     else if (gpio_direction_output(cs_gpio, 1))
>> +                             dev_err(&adev->dev,
>> +                                     "could set gpio %d as output\n",
>> +                                     cs_gpio);
>> +             }
>> +     }
>> +#else
>> +     for (i = 0; i < num_cs; i++)
>> +             pl022->chipselect[i] = -EINVAL;
>> +#endif
>
> Same here.
>
>>       /*
>>        * Supports mode 0-3, loopback, and active low CS. Transfers are
>> @@ -2130,6 +2204,9 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>>   err_no_ioremap:
>>       amba_release_regions(adev);
>>   err_no_ioregion:
>> + #if IS_ENABLED(CONFIG_OF)
>> + err_no_gpio:
>> + #endif
>
> And here.

Thanks for the hint. I will update the patch and repost later.
