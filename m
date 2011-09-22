Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab1IVF4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 01:56:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36005 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1IVF4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 01:56:15 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY3T7JmcLXY-6GYHqF+3SiVK5N0xGzqsE8pv8A+S10hWQw@mail.gmail.com>
References: <1316166200-20595-1-git-send-email-Baohua.Song@csr.com>
 <CABb+yY2L=wfRoascoriAcnNMKkV7LbQEHCpp78+rCY=aM46x7A@mail.gmail.com>
 <CAGsJ_4zURv1_zJ0rwZawa8VSOw0kT9U4-cCCj2Q4-BhV1pdTHA@mail.gmail.com> <CABb+yY3T7JmcLXY-6GYHqF+3SiVK5N0xGzqsE8pv8A+S10hWQw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 22 Sep 2011 13:55:54 +0800
Message-ID: <CAGsJ_4waZs7jp=3oS85JY9oriioLWF6DgBLrcdwJ9CyG2ieeew@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: delete redundant chan_id and chancnt
 initialization in dma drivers
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Barry Song <Baohua.Song@csr.com>, Piotr Ziecik <kosmo@semihalf.com>,
        Jaswinder Singh <jassi.brar@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Pelagicore AB <info@pelagicore.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Yong Wang <yong.y.wang@intel.com>, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/22 Jassi Brar <jassisinghbrar@gmail.com>:
> On Thu, Sep 22, 2011 at 5:38 AM, Barry Song <21cnbao@gmail.com> wrote:
>> 2011/9/21 Jassi Brar <jassisinghbrar@gmail.com>:
>>> On Fri, Sep 16, 2011 at 3:13 PM, Barry Song <Baohua.Song@csr.com> wrote:
>>>> dma_async_device_register will re-init chan_id and chancnt,
>>>> so whatever chan_id and chancnt are set in drivers, they will
>>>> be re-written by dma_async_device_register.
>>>>
>>>> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> Cc: Viresh Kumar <viresh.kumar@st.com>
>>>> Cc: Vinod Koul <vinod.koul@intel.com>
>>>> Cc: Piotr Ziecik <kosmo@semihalf.com>
>>>> Cc: Yong Wang <yong.y.wang@intel.com>
>>>> Cc: Jaswinder Singh <jassi.brar@samsung.com>
>>>> Cc: Pelagicore AB <info@pelagicore.com>
>>>> Signed-off-by: Barry Song <Baohua.Song@csr.com>
>>>> ---
>>>>  drivers/dma/at_hdmac.c      |    5 ++---
>>>>  drivers/dma/dw_dmac.c       |    5 ++---
>>>>  drivers/dma/intel_mid_dma.c |    2 --
>>>>  drivers/dma/mpc512x_dma.c   |    1 -
>>>>  drivers/dma/pch_dma.c       |    2 --
>>>>  drivers/dma/pl330.c         |    2 --
>>>>  drivers/dma/timb_dma.c      |    3 +--
>>>
>>> Apparently ....
>>>
>>> drivers/dma/ppc4xx/adma.c
>>> drivers/dma/ipu/ipu_idmac.c
>>>       still write to chan_id.
>>>
>>> drivers/dma/amba-pl08x.c
>>> drivers/dma/fsldma.c
>>> drivers/dma/ioat/dma_v2.c
>>> drivers/dma/ioat/dma.c
>>> drivers/dma/mpc512x_dma.c
>>> drivers/dma/shdma.c
>>>       still write to chancnt
>>>
> My question was if you really intended to convert only some of
> the drivers and not others?

i intended to convert all. but i lost some....

>
>>> Most of them are simply a matter of removal, but some seem
>>> like really depending upon setting them(?)
>>>
>>> Anyways, even after you modify those as well, chan_id and chancnt
>>> are rendered overstaying guests in dmaengine core. Because chan_id
>>> of each channel would be _precisely_ the order in which the
>>> _dmac-driver_ added the channel to the 'channels' list.
>>>
>>> So if their values are _always_ gonna be just contiguously incrementing
>>> why need variables for that in the dmaengine api?
>>> Dmac drivers could use local variables for that.
>>>
>>> OTOH, why not chan_id be left solely for use by dmac drivers read by the
>>> dmaengine only to create sysfs entries ?
>>
>> actually i don't like the way dmaengine core handles chan_id. in my
>> opinion, every dmac only needs to tell dmaengine core the chan_base.
>> then dmaengine core set the id in a global scale.
>>
>> for example, if you have two dmac in system:
>> dmac0 chan_base 0
>> dmac1 chan_base 16
>> then core will have chan 0~31 by chan_id from 0 to 31 but not
>> dmac0chan0~15, dmac1chan0~15.
> But note the numbering is still decided by the dmac driver - directly
> or indirectly.
> That is, if the dmac driver reorder registering of dmac or adding
> channels to the 'channels' list, the assigned chan_id's would change.
> So why not rather get rid of chan_id assignment from dmaengine
> and do explicitly in dmac drivers ?
> Which I already submitted a patch for https://lkml.org/lkml/2011/7/21/1

i don't agree chan_id is just a property of dmac. i think chan_id is
also a property core wants.
why could not dmac driver decide the chan_id in dmaengine core? i
think that is just what dmac driver wants.dmac just tells the base,
core re-number them one by one.
if dmac can't decide the ID directly or indirectly, this will be
random. how could client driver request the channel it wants?

>
>> client drivers can request a specific chan_id just like it can request a gpio.
> No dear. That's not gonna fly if we are to have common client drivers
> across SoCs.
>
>> now dmac drivers and dmaengine core have repeated chan_id and chancnt,
>> anyway, it is a problem that should be fixed at first.
> Correct, chan_id assignment should be completely either in dmaengine
> or in dmac drivers. But this patch does neither.
>
i like the way gpiolib handles ID more.

-barry
