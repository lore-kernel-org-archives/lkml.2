Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0GFMhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 08:37:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38061 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab0GFMhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 08:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iX4ajsaW/h0Xu4n4+I58JMhGTttmk8VrWf3+Kletg2fgU+H16TNZBGpBJESHZBOri4
         zCyXE1i1Rph6evaRUlFY/9ROB3dLWEdLNpthe4tgDrzyklYP8SJ52QwWR09HHLc38nEG
         6jF0JkZ9DVTLeTGpZCx3BLxr2fsG2V47R3EDU=
MIME-Version: 1.0
In-Reply-To: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
References: <1277770577-11024-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 6 Jul 2010 14:37:19 +0200
Message-ID: <AANLkTimYqUZvxaWVvT5FPsW36NTpqLLCqCiSuRAy_ER5@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

any thoughts on this? Personally I really like this abstraction from
my experience with embedded DMA controllers, but I don't have your
wide experience of DMA hardware.

Yours,
Linus Walleij

2010/6/29 Linus Walleij <linus.walleij@stericsson.com>:
> This adds an interface to the DMAengine to make it possible to
> reconfigure a slave channel at runtime. We add a few foreseen
> config parameters to the passed struct, with a void * pointer
> for custom per-device or per-platform runtime slave data.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  include/linux/dmaengine.h |   48 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 5204f01..e2601bd 100644
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
> @@ -199,6 +205,48 @@ struct dma_chan_dev {
>        atomic_t *idr_ref;
>  };
>
> +/**
> + * struct dma_slave_config - dma slave channel runtime config
> + * @addr: this is the physical address where DMA slave data should be
> + * read (RX) or written (TX)
> + * @addr_width: this is the width of the source (RX) or target
> + * (TX) register where DMA data shall be read/written, in bytes.
> + * legal values: 1, 2, 4, 8.
> + * @direction: whether the data shall go in or out on this slave
> + * channel, right now.
> + * @maxburst: the maximum number of words (note: words, as in units
> + * of the addr_width member, not bytes) that can be sent in one burst
> + * to the device. Typically something like half the FIFO depth on
> + * I/O peripherals so you don't overflow it.
> + * @private_config: if you need to pass in specialized configuration
> + * at runtime, apart from the generic things supported in this
> + * struct, you provide it in this pointer and dereference it inside
> + * your dmaengine driver to get the proper configuration bits out.
> + *
> + * This struct is passed in as configuration data to a DMA engine
> + * in order to set up a certain channel for DMA transport at runtime.
> + * The DMA device/engine has to provide support for an additional
> + * command in the channel config interface, DMA_SLAVE_CONFIG
> + * and this struct will then be passed in as an argument to the
> + * DMA engine device_control() function.
> + *
> + * The rationale for adding configuration information to this struct
> + * is as follows: if it is likely that most DMA slave controllers in
> + * the world will support the configuration option, then make it
> + * generic. If not, if it is fixed so that it be sent in static from
> + * the platform data, then prefer to do that. Else, if it is neither
> + * fixed, not generic enough (such as bus mastership on some CPU
> + * family and whatnot) then pass it in the private_config member
> + * and dereference it to some per-device struct in your driver.
> + */
> +struct dma_slave_config {
> +       dma_addr_t addr;
> +       u8 addr_width:4;
> +       enum dma_data_direction direction;
> +       int maxburst;
> +       void *private_config;
> +};
> +
>  static inline const char *dma_chan_name(struct dma_chan *chan)
>  {
>        return dev_name(&chan->dev->device);
> --
> 1.7.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
