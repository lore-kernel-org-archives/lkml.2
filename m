Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2EJJUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:20:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55814 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab2EJJUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:20:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAAG0J9-NDM9wLKpq04ofPkvFqiWxjmP84ojsP9Hfs0SJ_0FaXg@mail.gmail.com>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-2-git-send-email-thomas.abraham@linaro.org>
	<CAAG0J9-NDM9wLKpq04ofPkvFqiWxjmP84ojsP9Hfs0SJ_0FaXg@mail.gmail.com>
Date: Thu, 10 May 2012 14:50:04 +0530
Message-ID: <CAJuYYwQ5NLvsYK2iAaXtggbjYx7EUvc2RDjyFyrazke2E2wgiQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] mmc: dw_mmc: lookup for optional biu and ciu clocks
From: Thomas Abraham <thomas.abraham@linaro.org>
To: James Hogan <james@albanarts.com>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 20:23, James Hogan <james@albanarts.com> wrote:
> Hi
>
> On 2 May 2012 06:07, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> Some platforms allow for clock gating and control of bus interface unit clock
>> and card interface unit clock. Add support for clock lookup of optional biu
>> and ciu clocks for clock gating and clock speed determination.
>>
>> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  drivers/mmc/host/dw_mmc.c  |   35 +++++++++++++++++++++++++++++++----
>>  include/linux/mmc/dw_mmc.h |    4 ++++
>>  2 files changed, 35 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 1532357..036846f 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -1938,19 +1938,35 @@ int dw_mci_probe(struct dw_mci *host)
>>                return -ENODEV;
>>        }
>>
>> -       if (!host->pdata->bus_hz) {
>> +       host->biu_clk = clk_get(&host->dev, "biu");
>
> These clock names sound quite platform specific (what if they're
> called something else on another platform, or another platform has
> separate ones for different instantiations of the block?). Perhaps the
> clk names should get passed in through platform data. I haven't looked
> how other drivers handle that though.

The clock names 'biu' and 'ciu' are derived from the terminology used
by the data sheet of the mshc controller. The 'biu' clock is the
source clock for the bus interface unit and 'ciu' clock is the clock
source for card interface unit of the controller. So these names are
generic and not specific to a platform. Passing clock names from
platform data is generally frowned upon.

>
>> +       if (IS_ERR(host->biu_clk))
>> +               dev_info(&host->dev, "biu clock not available\n");
>
> In this case, should it set host->biu_clk to NULL or are clk_disable
> and clk_put guaranteed to handle an IS_ERR value?

Yes, the clk_disable will have to be preceded with a IS_ERR check. I
will fix this.

>
>> +       else
>> +               clk_enable(host->biu_clk);
>> +
>> +       host->ciu_clk = clk_get(&host->dev, "ciu");
>> +       if (IS_ERR(host->ciu_clk))
>> +               dev_info(&host->dev, "ciu clock not available\n");
>
> same here

Ok, this also will be fixed.

>
>> +       else
>> +               clk_enable(host->ciu_clk);
>> +
>> +       if (IS_ERR(host->ciu_clk))
>> +               host->bus_hz = host->pdata->bus_hz;
>> +       else
>> +               host->bus_hz = clk_get_rate(host->ciu_clk);
>> +
>> +       if (!host->bus_hz) {
>>                dev_err(&host->dev,
>>                        "Platform data must supply bus speed\n");
>> -               return -ENODEV;
>> +               ret = -ENODEV;
>> +               goto err_clk;
>>        }
>>
>> -       host->bus_hz = host->pdata->bus_hz;
>>        host->quirks = host->pdata->quirks;
>>
>>        spin_lock_init(&host->lock);
>>        INIT_LIST_HEAD(&host->queue);
>>
>> -
>>        host->dma_ops = host->pdata->dma_ops;
>>        dw_mci_init_dma(host);
>>
>> @@ -2095,6 +2111,13 @@ err_dmaunmap:
>>                regulator_disable(host->vmmc);
>>                regulator_put(host->vmmc);
>>        }
>> +       kfree(host);
>
> what's this about?

This is wrong. It should not have been here. I will fix this. Thanks
for pointing this out.

Thanks,
Thomas.
