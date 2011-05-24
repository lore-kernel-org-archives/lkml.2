Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1EXPkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:40:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56994 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1EXPkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SU0Z6fNN8Bt6QdtAQudQowe0EnaWJeM3hnW6ULMJ036SjDxl66iS6zww+Mxt4439U+
         /e9G8p7QJfmjbA+VrdvgZG2XxC6qTd2x34K0Gyx+7gNgeB+OfwOPiT+Zo/9VtKp8MFnW
         gWIEUyo1oenih75BUStGgtpdTnUrcC8LNiPUU=
MIME-Version: 1.0
In-Reply-To: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
Date: Tue, 24 May 2011 17:40:32 +0200
X-Google-Sender-Auth: vZcie7A7j9_zRMw22R4CIqyxxQs
Message-ID: <BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: Per Forlin <per.forlin@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Tue, May 24, 2011 at 2:04 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
> From: Vinod Koul <vinod.koul@intel.com>
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
>  Documentation/dma-slave-api.txt |   74 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 74 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/dma-slave-api.txt
I suggest putting this in subsection of dmaengine.txt instead.
dmaengine.txt would be the natural place to look at.

>
> diff --git a/Documentation/dma-slave-api.txt b/Documentation/dma-slave-api.txt
> new file mode 100644
> index 0000000..7498807
> --- /dev/null
> +++ b/Documentation/dma-slave-api.txt
> @@ -0,0 +1,74 @@
> +                    Slave DMA API Guide
> +                    ===================
> +
> +                Vinod Koul <vinod dot koul at intel.com>
> +
> +This is a guide to device driver writers on how to use the Slave-DMA API of the
> +DMA Engine. This is applicable only for slave DMA usage and not async tx. For
> +the async tx usage of DMA Engine please see
> +Documentation/crypto/async-tx-api.txt
> +
> +The slave DMA usage consists of following steps
> +1. Allocate a DMA slave channel
> +2. Set slave and controller specific parameters
> +3. Get a descriptor for transaction
> +4. Submit the transaction and wait for callback notification
> +
> +1. Allocate a DMA slave channel
> +Channel allocation is slightly different in the slave DMA context, client
> +drivers typically need a channel from a particular DMA controller only and even
> +in some cases a specific channel is desired. To request a channel
> +__dma_request_channel() API is used.
> +
> +Interface:
> +struct dma_chan *dma_request_channel(dma_cap_mask_t mask,
> +               dma_filter_fn filter_fn,
> +               void *filter_param);
> +where dma_filter_fn is defined as:
> +typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
> +
> +When the optional 'filter_fn' parameter is set to NULL dma_request_channel
> +simply returns the first channel that satisfies the capability mask.  Otherwise,
> +when the mask parameter is insufficient for specifying the necessary channel,
> +the filter_fn routine can be used to disposition the available channels in the
> +system. The filter_fn routine is called once for each free channel in the
> +system.  Upon seeing a suitable channel filter_fn returns DMA_ACK which flags
> +that channel to be the return value from dma_request_channel.  A channel
> +allocated via this interface is exclusive to the caller, until
> +dma_release_channel() is called.
> +
> +2. Set slave and controller specific parameters
> +Next step is always to pass some specific information to the DMA driver. Most of
> +the generic information which a slave DMA can use is in struct dma_slave_config.
> +It allows the clients to specify DMA direction, DMA addresses, bus widths, DMA
> +burst lengths etc. If some DMA controllers have more parameters to be sent then
> +they should try to embed struct dma_slave_config in their controller specific
> +structure. That gives flexibility to client to pass more parameters, if
> +required.
> +
> +Interface:
> +struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_sg)(
> +               struct dma_chan *chan,
> +               struct scatterlist *dst_sg, unsigned int dst_nents,
> +               struct scatterlist *src_sg, unsigned int src_nents,
> +               unsigned long flags);
> +struct dma_async_tx_descriptor *(*chan->device->device_prep_dma_cyclic)(
> +               struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +               size_t period_len, enum dma_data_direction direction);
> +
> +4. Submit the transaction(s) and wait for callback notification when slave API
> +is 3 above returns, the non NULL value would imply a "descriptor" for the
> +transaction. These transaction(s) would need to be submitted which pushes them
> +into queue in DMA driver. If DMA is idle then the first descriptor submit will
> +be pushed to DMA and subsequent ones will be queued. On completion of the DMA
> +operation the next in queue is submitted and a tasklet triggered. The tasklet
> +would then call the client driver completion callback routine for notification,
> +if set.
> +
Does submit really start the transfer as well? My interpretation of
submit is that is only adds desc to a pending queue. When calling
issue_pending all these descs will be schedule for DMA transfer. Calls
to submit after this point will added to the pending queue again and
not be issued until calling issue_pending once more.

Thanks for your initiative to document the slave parts of dmaegine.
Per
