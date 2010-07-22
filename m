Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0GVXdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:33:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45654 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0GVXdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PD4Qbav6YCqxSlqtNuwwOUaZqfsXUv0+SeYxPGchxK19UD9y/N/OiWL2GU33bZMYZU
         jk7g/V/g2f+u+p9ZBkiAqf4J9XlB2ykBMdAFnhWmdgbZ2qRChW5MSQflijNTGCoFuliZ
         98MHhBVD3hQ8rFjooLEYiDCMzbpSowOXNMeQ4=
MIME-Version: 1.0
In-Reply-To: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
References: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 22 Jul 2010 16:33:36 -0700
X-Google-Sender-Auth: C9LgxCgjoBaFYzf0yPKI5rDlAIo
Message-ID: <AANLkTik4htT0J6xvUHn5RzvjuxqgZSAWw7c7AnMLpLor@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control v2
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Jul 21, 2010 at 12:22 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This adds an interface to the DMAengine to make it possible to
> reconfigure a slave channel at runtime. We add a few foreseen
> config parameters to the passed struct, with a void * pointer
> for custom per-device or per-platform runtime slave data.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> This version was revised after discussion, it splits the control
> arguments in source/destination pairs to prepare for (among other
> things) device to device transfers.
> ---
>  include/linux/dmaengine.h |   75 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 75 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 5204f01..406b820 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -114,11 +114,17 @@ enum dma_ctrl_flags {
>  * @DMA_TERMINATE_ALL: terminate all ongoing transfers
>  * @DMA_PAUSE: pause ongoing transfers
>  * @DMA_RESUME: resume paused transfer
> + * @DMA_SLAVE_CONFIG: this command is only implemented by DMA controllers
> + * that need to runtime reconfigure the slave channels (as opposed to passing
> + * configuration data in statically from the platform). An additional
> + * argument of struct dma_slave_config must be passed in with this
> + * command.
>  */
>  enum dma_ctrl_cmd {
>        DMA_TERMINATE_ALL,
>        DMA_PAUSE,
>        DMA_RESUME,
> +       DMA_SLAVE_CONFIG,
>  };
>
>  /**
> @@ -199,6 +205,75 @@ struct dma_chan_dev {
>        atomic_t *idr_ref;
>  };
>
> +/**
> + * enum dma_slave_buswidth - defines bus with of the DMA slave
> + * device, source or target busses

s/busses/buses/

> + */
> +enum dma_slave_buswidth {
> +       DMA_SLAVE_BUSWIDTH_UNDEFINED = 0,
> +       DMA_SLAVE_BUSWIDTH_1_BYTE = 1,
> +       DMA_SLAVE_BUSWIDTH_2_BYTES = 2,
> +       DMA_SLAVE_BUSWIDTH_4_BYTES = 4,
> +       DMA_SLAVE_BUSWIDTH_8_BYTES = 8,
> +};
> +
> +/**
> + * struct dma_slave_config - dma slave channel runtime config
> + * @direction: whether the data shall go in or out on this slave
> + * channel, right now. DMA_TO_DEVICE and DMA_FROM_DEVICE are
> + * legal values, DMA_BIDIRECTIONAL is not acceptable since we
> + * need to differentiate source and target addresses.
> + * @src_addr: this is the physical address where DMA slave data
> + * should be read (RX), if the source is memory this argument is
> + * ignored.
> + * @dst_addr: this is the physical address where DMA slave data
> + * should be written (TX), if the source is memory this argument
> + * is ignored.
> + * @src_addr_width: this is the width in bytes of the source (RX)
> + * register where DMA data shall be read. If the source
> + * is memory this may be ignored depending on architecture.
> + * Legal values: 1, 2, 4, 8.
> + * @dst_addr_width: same as src_addr_width but for destination
> + * target (TX) mutatis mutandis.

/me wikipedias "mutatis mutandis", ah sort of latin for the s/// operator :-).

> + * @src_maxburst: the maximum number of words (note: words, as in
> + * units of the src_addr_width member, not bytes) that can be sent
> + * in one burst to the device. Typically something like half the
> + * FIFO depth on I/O peripherals so you don't overflow it. This
> + * may or may not be applicable on memory sources.
> + * @dst_maxburst: same as src_maxburst but for destination target
> + * mutatus mutandis.

s/mutatus/mutatis/

> + * @private_config: if you need to pass in specialized configuration
> + * at runtime, apart from the generic things supported in this
> + * struct, you provide it in this pointer and dereference it inside
> + * your dmaengine driver to get the proper configuration bits out.
> + *

Will there be any users of this field initially, I'd just as soon
leave it out?  Like I mentioned to Vinod I think requiring
dma_slave_config to be wrapped is a better way to extend this
structure.

--
Dan
