Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3AIPCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:02:43 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:52769 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab3AIPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:02:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130109142443.GQ19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
	<1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1357719435-29955-12-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130109142443.GQ19691@intel.com>
Date: Wed, 9 Jan 2013 17:02:39 +0200
Message-ID: <CAHp75Vfpvd87JP=W=u0CAHhdJinJhCdQHDye_te5+tfjgfKz3Q@mail.gmail.com>
Subject: Re: [resend][PATCH 11/16] dw_dmac: backlink to dw_dma in dw_dma_chan
 is superfluous
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 4:24 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Jan 09, 2013 at 10:17:10AM +0200, Andy Shevchenko wrote:
>> The same information could be exctracted from the struct dma_chan.
> typo...                         ^^^^^^^^^^

Thanks for finding this. Fixed in my local tree.
Shall I resubmit it here?

>> The patch introduces helper function dwc_get_data_width() as well.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/dma/dw_dmac.c      |   27 ++++++++++++++++++++-------
>>  drivers/dma/dw_dmac_regs.h |    3 ---
>>  2 files changed, 20 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>> index ff9d68b..39a6506 100644
>> --- a/drivers/dma/dw_dmac.c
>> +++ b/drivers/dma/dw_dmac.c
>> @@ -73,6 +73,22 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
>>   */
>>  #define NR_DESCS_PER_CHANNEL 64
>>
>> +#define SRC_MASTER   0
>> +#define DST_MASTER   1
>> +
>> +static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
>> +{
>> +     struct dw_dma *dw = to_dw_dma(chan->device);
>> +     struct dw_dma_slave *dws = chan->private;
>> +
>> +     if (master == SRC_MASTER)
>> +             return dw->data_width[dwc_get_sms(dws)];
>> +     else if (master == DST_MASTER)
>> +             return dw->data_width[dwc_get_dms(dws)];
>> +
>> +     return 0;
>> +}
>> +
>>  /*----------------------------------------------------------------------*/
>>
>>  /*
>> @@ -703,7 +719,6 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>>               size_t len, unsigned long flags)
>>  {
>>       struct dw_dma_chan      *dwc = to_dw_dma_chan(chan);
>> -     struct dw_dma_slave     *dws = chan->private;
>>       struct dw_desc          *desc;
>>       struct dw_desc          *first;
>>       struct dw_desc          *prev;
>> @@ -726,8 +741,8 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>>
>>       dwc->direction = DMA_MEM_TO_MEM;
>>
>> -     data_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_sms(dws)],
>> -                                      dwc->dw->data_width[dwc_get_dms(dws)]);
>> +     data_width = min_t(unsigned int, dwc_get_data_width(chan, SRC_MASTER),
>> +                        dwc_get_data_width(chan, DST_MASTER));
>>
>>       src_width = dst_width = min_t(unsigned int, data_width,
>>                                     dwc_fast_fls(src | dest | len));
>> @@ -792,7 +807,6 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>>               unsigned long flags, void *context)
>>  {
>>       struct dw_dma_chan      *dwc = to_dw_dma_chan(chan);
>> -     struct dw_dma_slave     *dws = chan->private;
>>       struct dma_slave_config *sconfig = &dwc->dma_sconfig;
>>       struct dw_desc          *prev;
>>       struct dw_desc          *first;
>> @@ -826,7 +840,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>>               ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_M2P) :
>>                       DWC_CTLL_FC(DW_DMA_FC_D_M2P);
>>
>> -             data_width = dwc->dw->data_width[dwc_get_sms(dws)];
>> +             data_width = dwc_get_data_width(chan, SRC_MASTER);
>>
>>               for_each_sg(sgl, sg, sg_len, i) {
>>                       struct dw_desc  *desc;
>> @@ -889,7 +903,7 @@ slave_sg_todev_fill_desc:
>>               ctllo |= sconfig->device_fc ? DWC_CTLL_FC(DW_DMA_FC_P_P2M) :
>>                       DWC_CTLL_FC(DW_DMA_FC_D_P2M);
>>
>> -             data_width = dwc->dw->data_width[dwc_get_dms(dws)];
>> +             data_width = dwc_get_data_width(chan, DST_MASTER);
>>
>>               for_each_sg(sgl, sg, sg_len, i) {
>>                       struct dw_desc  *desc;
>> @@ -1720,7 +1734,6 @@ static int dw_probe(struct platform_device *pdev)
>>
>>               channel_clear_bit(dw, CH_EN, dwc->mask);
>>
>> -             dwc->dw = dw;
>>               dwc->direction = DMA_TRANS_NONE;
>>
>>               /* hardware configuration */
>> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
>> index f9532c2..577f2dd 100644
>> --- a/drivers/dma/dw_dmac_regs.h
>> +++ b/drivers/dma/dw_dmac_regs.h
>> @@ -214,9 +214,6 @@ struct dw_dma_chan {
>>
>>       /* configuration passed via DMA_SLAVE_CONFIG */
>>       struct dma_slave_config dma_sconfig;
>> -
>> -     /* backlink to dw_dma */
>> -     struct dw_dma           *dw;
>>  };
>>
>>  static inline struct dw_dma_chan_regs __iomem *
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
