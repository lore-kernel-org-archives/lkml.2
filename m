Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1ILIeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 04:34:10 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:51512 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1ILIeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <CANfBPZ-azGV0H7asRHD5+vdFjCkrx=E2Oypnrk_SW9K5+DwTLQ@mail.gmail.com>
References: <1314569323-6886-1-git-send-email-per.forlin@linaro.org>
	<CANfBPZ-azGV0H7asRHD5+vdFjCkrx=E2Oypnrk_SW9K5+DwTLQ@mail.gmail.com>
Date: Mon, 12 Sep 2011 10:34:06 +0200
Message-ID: <CAJ0pr1-ytbiXLYi_vXRx80j+H0CqvZSOFTQBpz=ia90GsH0TGQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: omap_hsmmc: DMA unmap only once in case of MMC error
From: Per Forlin <per.forlin@linaro.org>
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh <santosh.shilimkar@ti.com>,
        Balaji T Krishnamoorthy <balajitk@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Chris Ball <cjb@laptop.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 September 2011 21:19, S, Venkatraman <svenkatr@ti.com> wrote:
> On Mon, Aug 29, 2011 at 3:38 AM, Per Forlin <per.forlin@linaro.org> wrote:
>> Reported by Russell King:
>> ------------
>> mmcblk0: error -84 transferring data, sector 149201, nr 64,
>> cmd response 0x900, card status 0xb00
>> mmcblk0: retrying using single block read
>>
>> WARNING: at /home/rmk/git/linux-2.6-rmk/lib/dma-debug.c:811 check_unmap
>> omap_hsmmc omap_hsmmc.0: DMA-API: device driver tries to free DMA memory
>> it has not allocated [device address=0x0000000080933000] [size=20480 bytes]
>> -------------
>>
>> In case of an error dma_unmap() is issued in omap_hsmmc_dma_cleanup()
>> and then again in omap_hsmmc_post_req(). Resolve this by clearing the
>> host_cookie to indicate there is no DMA mapped memory to unmap.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> ---
>> Bug fix on 3.1-rc3
>>
>>  drivers/mmc/host/omap_hsmmc.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
>> index 21e4a79..31d9817 100644
>> --- a/drivers/mmc/host/omap_hsmmc.c
>> +++ b/drivers/mmc/host/omap_hsmmc.c
>> @@ -1011,6 +1011,7 @@ static void omap_hsmmc_dma_cleanup(struct omap_hsmmc_host *host, int errno)
>>                        host->data->sg_len,
>>                        omap_hsmmc_get_dma_dir(host, host->data));
>>                omap_free_dma(dma_ch);
>> +               host->data->host_cookie = 0;
>>        }
>>        host->data = NULL;
>>  }
>> @@ -1576,8 +1577,10 @@ static void omap_hsmmc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
>>        struct mmc_data *data = mrq->data;
>>
>>        if (host->use_dma) {
>> -               dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
>> -                            omap_hsmmc_get_dma_dir(host, data));
>> +               if (data->host_cookie)
>> +                       dma_unmap_sg(mmc_dev(host->mmc), data->sg,
>> +                                    data->sg_len,
>> +                                    omap_hsmmc_get_dma_dir(host, data));
>>                data->host_cookie = 0;
>>        }
>>  }
>> --
>> 1.7.4.1
>>
>>
>
> I just posted a patch [1] which just consolidates all unmapping to
> just post_req.
> This would obviously prevent double unmapping, and keeps all the related
> dma operations at a single place. Let me know if that works better.
>
I'm in favour of such patch. My patch only tries to do the minimal bug fix.
I have been out of office the last 10 days or so. I'll look at your
patch later today.

Thanks,
Per
