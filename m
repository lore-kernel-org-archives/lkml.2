Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2BFOiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:38:14 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:55907 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab2BFOiN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:38:13 -0500
MIME-Version: 1.0
In-Reply-To: <1328528294.26182.80.camel@vkoul-udesk3>
References: <1328006840-7345-1-git-send-email-javier.martin@vista-silicon.com>
	<1328528294.26182.80.camel@vkoul-udesk3>
Date: Mon, 6 Feb 2012 15:38:11 +0100
Message-ID: <CACKLOr16kN+9DfF_vxzF_uzcmQC7cvAzR_oXpbNmc1D1qDY9sA@mail.gmail.com>
Subject: Re: [PATCH v3] dmaengine: Add support for MEMCPY for imx-dma.
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dan.j.williams@intel.com, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,
thank you for your review.

Let me first explain who we are and what are we trying to accomplish
so you can get a global view.
We are an small company of 10 workers where I am the only one in
charge of developing for the kernel. With all these DMA changes we are
trying to develop a generic, video mem2mem deinterlacing driver, and
we plan to have it ready for the next merge window which will be
probably in March, according to the Linux kernel development cycle.

Following the rule "post early, post often" we've divided our
development process in several steps:

- Step 1 (this patch):
[PATCH v3] dmaengine: Add support for MEMCPY for imx-dma.

This step is important for us since it gives us access to the dmatest
module and allows to develop a first prototype of the driver which
just copies the content of one buffer into another.

- Step 2 (also submitted to the mainling list):
[PATCH 1/2] i.MX DMA: Add support for 2D transfers.
[PATCH 2/2] dmaengine: i.MX: Add support for interleaved transfers.

With this step we have know a first working version of a driver which
actually does video deinterlacing. However, since current dmaengine
support for imx only regards a single descriptor, this code is quite
ugly and dirty.

- Step 3 (developing):
dmaengine: i.MX: Support multiple descriptors.

Supporting multiple descriptors gives us access to the feature of
queueing multiple DMA transfers and therefore we can make a cleaner
deinterlacing driver.


On 6 February 2012 12:38, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, 2012-01-31 at 11:47 +0100, Javier Martin wrote:
>> MEMCPY transfers allow DMA copies from memory to
>> memory. This patch has been tested with dmatest
>> device driver.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/dma/imx-dma.c |   36 +++++++++++++++++++++++++++++++++++-
>>  1 files changed, 35 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
>> index 3296a73..9aa6e85 100644
>> --- a/drivers/dma/imx-dma.c
>> +++ b/drivers/dma/imx-dma.c
>> @@ -196,7 +196,8 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
>>       struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
>>       struct imx_dma_data *data = chan->private;
>>
>> -     imxdmac->dma_request = data->dma_request;
>> +     if (data != NULL)
>> +             imxdmac->dma_request = data->dma_request;
> if you support memcopy then why should it _always_ require private
> pointer?

This is precisely why I have added this lines. Just to consider those
cases where a private pointer is not needed.  Note that when this
pointer is null I don't use it.


>>
>>       dma_async_tx_descriptor_init(&imxdmac->desc, chan);
>>       imxdmac->desc.tx_submit = imxdma_tx_submit;
>> @@ -328,6 +329,36 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>>       return &imxdmac->desc;
>>  }
>>
>> +static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
>> +     struct dma_chan *chan, dma_addr_t dest,
>> +     dma_addr_t src, size_t len, unsigned long flags)
>> +{
>> +     struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
>> +     struct imxdma_engine *imxdma = imxdmac->imxdma;
>> +     int ret;
>> +
>> +     dev_dbg(imxdma->dev, "%s channel: %d src=0x%x dst=0x%x len=%d\n",
>> +                     __func__, imxdmac->channel, src, dest, len);
>> +
>> +     if (imxdmac->status == DMA_IN_PROGRESS)
>> +             return NULL;
> thats not right, you should be able to prepare descriptors even if dmac
> is busy. Prepare != start

As you've probably noticed, all existen prepare callbacks (slave_sg,
cyclic)in this driver are programmed in the same way. As the driver
does only support a single descriptor, every call to a prepare
function of an active channel will fail some way or another (because
there are no free descriptors available). You can argue that actual
configuration of the HW should be done in the "tx_submit()" callback
but, since this driver does not support more than one descriptor this
wouldn't make any difference.

Moreover, I don't think it's convenient punishing developers of new
functionality for poor previous decissions, although as a maintainer I
understand you want the drivers to be clean. However, we are enforced
to fix this in "Step 3" of our development process anyway, since we
need to add support for multiple descriptors. So, it would make things
easier for us if you could let these patches pass.

>> +     imxdmac->status = DMA_IN_PROGRESS;
>> +
>> +     ret = imx_dma_config_channel(imxdmac->imxdma_channel,
>> +                            IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
>> +                            IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
>> +                            0, 0);
>> +     if (ret)
>> +             return NULL;
>> +
>> +     ret = imx_dma_setup_single(imxdmac->imxdma_channel, src, len,
>> +                                dest, DMA_MODE_WRITE);
>> +     if (ret)
>> +             return NULL;
>> +
>> +     return &imxdmac->desc;
>> +}
>> +
>>  static void imxdma_issue_pending(struct dma_chan *chan)
>>  {
>>       struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
>> @@ -349,6 +380,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
>>
>>       dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
>>       dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
>> +     dma_cap_set(DMA_MEMCPY, imxdma->dma_device.cap_mask);
>>
>>       /* Initialize channel parameters */
>>       for (i = 0; i < MAX_DMA_CHANNELS; i++) {
>> @@ -382,11 +414,13 @@ static int __init imxdma_probe(struct platform_device *pdev)
>>       imxdma->dma_device.device_tx_status = imxdma_tx_status;
>>       imxdma->dma_device.device_prep_slave_sg = imxdma_prep_slave_sg;
>>       imxdma->dma_device.device_prep_dma_cyclic = imxdma_prep_dma_cyclic;
>> +     imxdma->dma_device.device_prep_dma_memcpy = imxdma_prep_dma_memcpy;
>>       imxdma->dma_device.device_control = imxdma_control;
>>       imxdma->dma_device.device_issue_pending = imxdma_issue_pending;
>>
>>       platform_set_drvdata(pdev, imxdma);
>>
>> +     imxdma->dma_device.copy_align = 2; /* 2^2 = 4 bytes alignment */
> what is this magic number?

It indicates this driver support 32bit aligned memory accesses and we
use it as it is done in other drivers like:
http://lxr.linux.no/#linux+v3.2.4/drivers/dma/ste_dma40.c#L2437
http://lxr.linux.no/#linux+v3.2.4/drivers/dma/coh901318.c#L1557


Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
