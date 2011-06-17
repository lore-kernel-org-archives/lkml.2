Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1FQKP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 06:15:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62829 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1FQKP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 06:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikP8pveKPPG+_h6_hBenh91vAi4mQ@mail.gmail.com>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
	<1306360653-6196-4-git-send-email-per.forlin@linaro.org>
	<BANLkTikP8pveKPPG+_h6_hBenh91vAi4mQ@mail.gmail.com>
Date: Fri, 17 Jun 2011 12:15:55 +0200
Message-ID: <BANLkTikk14y_tweX45JdDb+qqYtOTuMnbg@mail.gmail.com>
Subject: Re: [PATCH v4 03/12] omap_hsmmc: add support for pre_req and post_req
From: Per Forlin <per.forlin@linaro.org>
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        David Vrabel <david.vrabel@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 15:14, S, Venkatraman <svenkatr@ti.com> wrote:
> On Thu, May 26, 2011 at 3:27 AM, Per Forlin <per.forlin@linaro.org> wrote:
>> pre_req() runs dma_map_sg(), post_req() runs dma_unmap_sg.
>> If not calling pre_req() before omap_hsmmc_request()
>> dma_map_sg will be issued before starting the transfer.
>> It is optional to use pre_req(). If issuing pre_req()
>> post_req() must be to be called as well.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> ---
>>  drivers/mmc/host/omap_hsmmc.c |   87 +++++++++++++++++++++++++++++++++++++++--
>>  1 files changed, 83 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
>> index ad3731a..2116c09 100644
>> --- a/drivers/mmc/host/omap_hsmmc.c
>> +++ b/drivers/mmc/host/omap_hsmmc.c
>> @@ -141,6 +141,11 @@
>>  #define OMAP_HSMMC_WRITE(base, reg, val) \
>>        __raw_writel((val), (base) + OMAP_HSMMC_##reg)
>>
>> +struct omap_hsmmc_next {
>> +       unsigned int    dma_len;
>> +       s32             cookie;
>> +};
>> +
>>  struct omap_hsmmc_host {
>>        struct  device          *dev;
>>        struct  mmc_host        *mmc;
>> @@ -184,6 +189,7 @@ struct omap_hsmmc_host {
>>        int                     reqs_blocked;
>>        int                     use_reg;
>>        int                     req_in_progress;
>> +       struct omap_hsmmc_next  next_data;
>>
>>        struct  omap_mmc_platform_data  *pdata;
>>  };
>> @@ -1344,8 +1350,9 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
>>                return;
>>        }
>>
>> -       dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
>> -               omap_hsmmc_get_dma_dir(host, data));
>> +       if (!data->host_cookie)
>> +               dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
>> +                            omap_hsmmc_get_dma_dir(host, data));
>>
>>        req_in_progress = host->req_in_progress;
>>        dma_ch = host->dma_ch;
>> @@ -1363,6 +1370,45 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
>>        }
>>  }
>>
>> +static int omap_hsmmc_pre_dma_transfer(struct omap_hsmmc_host *host,
>> +                                      struct mmc_data *data,
>> +                                      struct omap_hsmmc_next *next)
>> +{
>
> As you are passing &host->next_data into next, next will always be a
> valid pointer. So..
>
omap_hsmmc_pre_dma_transfer() is called from two places. in pre_req()
and start_dma_transfer().
next is NULL if called from start_dma_transfer.

/Per
