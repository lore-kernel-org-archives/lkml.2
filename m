Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1I1IvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:51:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61637 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1I1IvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:51:05 -0400
MIME-Version: 1.0
In-Reply-To: <4E82D0A1.8050203@st.com>
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com>
 <1317189007-23033-2-git-send-email-alim.akhtar@samsung.com> <4E82D0A1.8050203@st.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Wed, 28 Sep 2011 14:20:24 +0530
Message-ID: <CAGOxZ53qZy+VUM65oK68W088QR=RgQ=cNxOCbO7_WESJesJaVQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] dmaengine/amba-pl08x: Add support for s3c64xx DMAC
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Thanks for reviewing the patch.

On Wed, Sep 28, 2011 at 1:15 PM, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 9/28/2011 11:20 AM, Alim Akhtar wrote:
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> ---
>>  drivers/dma/amba-pl08x.c |  135 ++++++++++++++++++++++++++++++++++++++--------
>>  1 files changed, 112 insertions(+), 23 deletions(-)
>>
>
> It would be good if you can add pick some part from cover-letter and put it in
> commit log too.
>
Ok, I will write more comments in the commit log.

>> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
>> index cd8df7f..501540f 100644
>> --- a/drivers/dma/amba-pl08x.c
>> +++ b/drivers/dma/amba-pl08x.c
>> @@ -110,6 +129,11 @@ struct pl08x_lli {
>>       u32 dst;
>>       u32 lli;
>>       u32 cctl;
>> +     /*
>> +      * Samsung pl080 DMAC has one exrta control register
>> +      * which is used to hold the transfer_size
>> +      */
>> +     u32 cctl1;
>
> Will you write transfer_size in cctl also? What is the purpose of cctl1?
>
The main difference between Primecell PL080 and samsung variant is in
LLI control register bit [0:11] is reserved in case of samsung pl080
and one extra register is add to hold the transfer size at offset
0x10. The purpose of cctl1 is store the transfer_size.

>> @@ -215,11 +255,23 @@ static void pl08x_start_txd(struct pl08x_dma_chan *plchan,
>>               cpu_relax();
>>
>>       /* Do not access config register until channel shows as inactive */
>> -     val = readl(phychan->base + PL080_CH_CONFIG);
>> -     while ((val & PL080_CONFIG_ACTIVE) || (val & PL080_CONFIG_ENABLE))
>> +     if (pl08x->vd->is_pl080_s3c) {
>> +             val = readl(phychan->base + PL080S_CH_CONFIG);
>> +             while ((val & PL080_CONFIG_ACTIVE) ||
>> +                     (val & PL080_CONFIG_ENABLE))
>> +                     val = readl(phychan->base + PL080S_CH_CONFIG);
>> +
>> +             writel(val | PL080_CONFIG_ENABLE,
>> +                     phychan->base + PL080S_CH_CONFIG);
>> +     } else {
>>               val = readl(phychan->base + PL080_CH_CONFIG);
>> +                     while ((val & PL080_CONFIG_ACTIVE) ||
>> +                             (val & PL080_CONFIG_ENABLE))
>> +                             val = readl(phychan->base + PL080_CH_CONFIG);
>>
>> -     writel(val | PL080_CONFIG_ENABLE, phychan->base + PL080_CH_CONFIG);
>> +             writel(val | PL080_CONFIG_ENABLE,
>> +                     phychan->base + PL080_CH_CONFIG);
>> +     }
>
> You have similar stuff in most the the changes in this patch, because offset of
> config register changes for s3c, you placed in if,else block.
>
> If you check these changes again, there is a lot of code duplication in this if,else
> blocks. The only different thing in if,else is the offset of CH_CONFIG register.
>
> It would be much better if you can do following:
>
> u32 ch_cfg_off;
>
>        if (pl08x->vd->is_pl080_s3c)
>                ch_cfg_off = PL080S_CH_CONFIG;
>        else
>                ch_cfg_off = PL080_CH_CONFIG;
>
> Now, this offset can be used in existing code, without much code duplication.
>
I will use suggestion and remove the code duplications.

>> @@ -569,6 +641,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>>       u32 cctl, early_bytes = 0;
>>       size_t max_bytes_per_lli, total_bytes = 0;
>>       struct pl08x_lli *llis_va;
>> +     size_t lli_len = 0, target_len, tsize, odd_bytes;
>>
>>       txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_NOWAIT, &txd->llis_bus);
>>       if (!txd->llis_va) {
>> @@ -700,7 +773,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>>                * width left
>>                */
>>               while (bd.remainder > (mbus->buswidth - 1)) {
>> -                     size_t lli_len, tsize, width;
>> +                     size_t width;
>>
>
> why do we need above two changes. odd_bytes and target_len are still unused.
>
sorry, I will remove the used variables.
>>                       /*
>>                        * If enough left try to send max possible,
>> @@ -759,6 +832,9 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>>       llis_va[num_llis - 1].lli = 0;
>>       /* The final LLI element shall also fire an interrupt. */
>>       llis_va[num_llis - 1].cctl |= PL080_CONTROL_TC_IRQ_EN;
>> +     /* Keep the TransferSize seperate to fill samsung specific register */
>> +     if (pl08x->vd->is_pl080_s3c)
>> +             llis_va[num_llis - 1].cctl1 |= lli_len;
>
> I couldn't get this completely. Why do you keep only length of
> last lli in cctl1. what about all other llis. Also why |=
> and not directly cctl1 = lli_len
>
I will write more explanation about it.
> --
> viresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
