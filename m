Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3AIO4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:56:49 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53214 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3AIO4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130109134757.GN19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
	<1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1357719435-29955-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130109134757.GN19691@intel.com>
Date: Wed, 9 Jan 2013 16:56:45 +0200
Message-ID: <CAHp75VfFyX=Pz3xRt15n6ffP=v0pa413BFF2zHGoiQowG1kKVg@mail.gmail.com>
Subject: Re: [resend][PATCH 01/16] dw_dmac: call .probe after we have a device
 in place
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 3:47 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Jan 09, 2013 at 10:17:00AM +0200, Andy Shevchenko wrote:
>> If we don't yet have the platform device for the driver when it is being loaded
>> we fail to probe the driver. So instead of calling probe() directly we call
>> platform_driver_register(). It will call the probe() immediately if we have the
>> device but also makes the driver to work on platforms where the platform device
>> is created later.
> Why wont you have the platform device?

It's still the same device as before. The only difference is in
boot/initialization sequence.

> Is this only due to your approach of
> creating the device in PCI probe?

No. We had an issue when driver was initialized (and with old version
immediately probed)
just before it happened in the platform devices. In such case .probe() fails.
Above patch makes sure that platform devices are already in the
internal structures and we could match them safely.

>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/dma/dw_dmac.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> index 476e9c8..b5f21ba 100644
>> --- a/drivers/dma/dw_dmac.c
>> +++ b/drivers/dma/dw_dmac.c
>> @@ -1829,6 +1829,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>>  #endif
>>
>>  static struct platform_driver dw_driver = {
>> +     .probe          = dw_probe,
>>       .remove         = dw_remove,
>>       .shutdown       = dw_shutdown,
>>       .driver = {
>> @@ -1840,7 +1841,7 @@ static struct platform_driver dw_driver = {
>>
>>  static int __init dw_init(void)
>>  {
>> -     return platform_driver_probe(&dw_driver, dw_probe);
>> +     return platform_driver_register(&dw_driver);
>>  }
>>  subsys_initcall(dw_init);
>>
>> --
>> 1.7.10.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
