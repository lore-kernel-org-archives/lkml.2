Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab2JLIe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:34:29 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34582 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625Ab2JLIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <1350030203.10584.139.camel@smile>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
	<1350030203.10584.139.camel@smile>
Date: Fri, 12 Oct 2012 14:04:02 +0530
Message-ID: <CAKohpon4FZdPXFOXvVqExY=xrwozELYvNbE3_zHoRw2O0nszhw@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 13:53, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Fri, 2012-10-12 at 11:14 +0530, Viresh Kumar wrote:

> My few comments are below.

Most welcome :)

>> diff --git a/Documentation/devicetree/bindings/dma/snps-dma.txt b/Documentation/devicetree/bindings/dma/snps-dma.txt
>> @@ -14,4 +34,28 @@ Example:
>>               reg = <0xfc000000 0x1000>;
>>               interrupt-parent = <&vic1>;
>>               interrupts = <12>;
>> +
>> +             nr_channels = <8>;
>> +             chan_allocation_order = <1>;
>> +             chan_priority = <1>;
>> +             block_size = <0xfff>;
>> +             nr_masters = <2>;
>> +             data_width = <3 3 0 0>;
>> +
>> +             slave_info {
>> +                     uart0-tx {
>> +                             bus_id = "uart0-tx";
>> +                             cfg_hi = <0x4000>;      /* 0x8 << 11 */
>> +                             cfg_lo = <0>;
>> +                             src_master = <0>;
>> +                             dst_master = <1>;
>> +                     };
>> +                     spi0-tx {
>> +                             bus_id = "spi0-tx";
>> +                             cfg_hi = <0x2000>;      /* 0x4 << 11 */
>> +                             cfg_lo = <0>;
>> +                             src_master = <0>;
>> +                             dst_master = <0>;
>> +                     };
>> +             };
> Why do you locate slave information under DMA controller node? From my
> point of view the slave info belongs to corresponding device. For
> example, above sections belong to UART0 and SPI0.

Consider one spi driver is used on 5 different platforms with
different DMA controllers.
So, 5 DMA drivers and so 5 DMA platform_data. Wherever we add this node, this
data can't be processed by spi-driver, as we can't add DT processing routines
for all DMA drivers in spi.

The best place to process DT nodes is DW_DMAC driver, because it is
dw_dmac's data.
That's why i added them under DMA.

>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

>> +     while (++i < dw->sd_count) {
>> +             if (!strcmp(dw->sd[i].bus_id, param)) {
>> +                     found = 1;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (!found) {
>> +             last_dw = dw;
>> +             last_bus_id = param;
>> +             return false;
> Because of return here you could eliminate 'found' flag at all.

Yeah.

>> +static struct dw_dma_platform_data *
>> +__devinit dw_dma_parse_dt(struct platform_device *pdev)
>> +{

>> +     for_each_child_of_node(sn, cn)
>> +             count++;
> Is there any other way to get amount of children?

I tried my best to find one, referred to lots of drivers. And found
this way in most of the places. ex: drivers/pinctrl/***

>> +     return pdata;
> Here you return NULL or valid pointer
>> +}
>> +#else
>> +static inline int dw_dma_parse_dt(struct platform_device *pdev)
>> +{
>> +     return -ENOSYS;
> ...here you return an error.

Look at prototype of both versions of these routines. Its a bug. Thanks
for pointing out.

>>       if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
> ...and here you didn't check for an error.

With above bug fixed, this will be automatically resolved as NULL is treated as
failure.

--
viresh
