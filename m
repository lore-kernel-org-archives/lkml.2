Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0HWRai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:30:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50922 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0HWRag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xR6N3FkKZY/edpNcV6Sq3f+pFn787vs4UQbRB43oRC2ngWzuRcOqi3Zo9UZlZMYY7a
         ZDS6jZPsytAF/ZhgVx6SxlYDNhWpR+kFqCZC02VKr4sRcA5S/LO7eUlJI907XcMx67NF
         1EVSMngCO47L1bKvGFJkY9b03n6Sx8hWuKqVM=
MIME-Version: 1.0
In-Reply-To: <20100823125704.GU27749@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-4-git-send-email-s.hauer@pengutronix.de>
	<20100823125704.GU27749@pengutronix.de>
Date: Mon, 23 Aug 2010 19:30:34 +0200
Message-ID: <AANLkTinYkXwKZwin8fsiepvJh=s47uti2+2gC8r3OEOk@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/23 Sascha Hauer <s.hauer@pengutronix.de>:

> This patch adds support for the Freescale i.MX SDMA engine.

Great progress!

> (...)
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> (...)
> +/* SDMA registers */
> +#define SDMA_H_C0PTR           (sdma->regs + 0x000)
> +#define SDMA_H_INTR            (sdma->regs + 0x004)
> +#define SDMA_H_STATSTOP                (sdma->regs + 0x008)
> +#define SDMA_H_START           (sdma->regs + 0x00c)
> +#define SDMA_H_EVTOVR          (sdma->regs + 0x010)
> +#define SDMA_H_DSPOVR          (sdma->regs + 0x014)
> +#define SDMA_H_HOSTOVR         (sdma->regs + 0x018)
> +#define SDMA_H_EVTPEND         (sdma->regs + 0x01c)
> +#define SDMA_H_DSPENBL         (sdma->regs + 0x020)
> +#define SDMA_H_RESET           (sdma->regs + 0x024)
> +#define SDMA_H_EVTERR          (sdma->regs + 0x028)
> +#define SDMA_H_INTRMSK         (sdma->regs + 0x02c)
> +#define SDMA_H_PSW             (sdma->regs + 0x030)
> +#define SDMA_H_EVTERRDBG       (sdma->regs + 0x034)
> +#define SDMA_H_CONFIG          (sdma->regs + 0x038)
> +#define SDMA_ONCE_ENB          (sdma->regs + 0x040)
> +#define SDMA_ONCE_DATA         (sdma->regs + 0x044)
> +#define SDMA_ONCE_INSTR                (sdma->regs + 0x048)
> +#define SDMA_ONCE_STAT         (sdma->regs + 0x04c)
> +#define SDMA_ONCE_CMD          (sdma->regs + 0x050)
> +#define SDMA_EVT_MIRROR                (sdma->regs + 0x054)
> +#define SDMA_ILLINSTADDR       (sdma->regs + 0x058)
> +#define SDMA_CHN0ADDR          (sdma->regs + 0x05c)
> +#define SDMA_ONCE_RTB          (sdma->regs + 0x060)
> +#define SDMA_XTRIG_CONF1       (sdma->regs + 0x070)
> +#define SDMA_XTRIG_CONF2       (sdma->regs + 0x074)
> +#define SDMA_CHNENBL_0         (sdma->regs + (sdma->version == 2 ? 0x200 : 0x80))
> +#define SDMA_CHNPRI_0          (sdma->regs + 0x100)

These macros expand to the local variable "sdma" which must
be present in all functions using them. I don't know what is
considered moste readable, but I would certainly just

#define SDMA_FOO (0x0123)
(...)
u32 foo = readl(sdma->regs + SDMA_FOO);

That is more common I think.

> (...)
> +/*
> + * Channel control Block

Some kerneldoc here describing especially
@unused: padding for register cast
@usused1: padding for register cast

Hm "unused" and "unused1" wrinkles my binary brain,
can you call the first one "unused0" for my perceptions
sake?

> + */
> +struct sdma_channel_control {
> +       dma_addr_t current_bd_ptr; /* current buffer descriptor processed */
> +       dma_addr_t base_bd_ptr;    /* first element of buffer descriptor array */
> +       u32 unused;
> +       u32 unused1;
> +} __attribute__ ((packed));

> (...)
> +/**
> + * struct sdma_channel - housekeeping for a SDMA channel
> + *
> + * @sdma               pointer to the SDMA engine for this channel
> + * @channel            the channel number, matches dmaengine chan_id
> + * @direction          transfer type. Needed for setting SDMA script
> + * @peripheral_type    Peripheral type. Needed for setting SDMA script
> + * @event_id           aka dma request line
> + * @event_id2          for channels that use 2 events
> + * @word_size          peripheral access size
> + * @buf_tail           ID of the buffer that was processed
> + * @done               channel completion
> + * @num_bd             max NUM_BD. number of descriptors currently handling
> + */
> +struct sdma_channel {
> +       struct sdma_engine              *sdma;
> +       unsigned int                    channel;
> +       enum dma_data_direction         direction;
> +       enum sdma_peripheral_type       peripheral_type;
> +       unsigned int                    event_id;
> +       unsigned int                    event_id2;

id1 und id2 oder
id0 und id1 fierleicht?

> +       enum dma_slave_buswidth         word_size;
> +       unsigned int                    buf_tail;
> +       struct completion               done;
> +       unsigned int                    num_bd;
> +       struct sdma_buffer_descriptor   *bd;
> +       dma_addr_t                      bd_phys;
> +       unsigned int                    pc_from_device, pc_to_device;
> +       unsigned long                   flags;
> +       dma_addr_t                      per_address;
> +       u32                             event_mask1, event_mask2;

1 and 2, else unnumbered and 1, else unnumbered and 2 X-)

> +       u32                             watermark_level;
> +       u32                             shp_addr, per_addr;
> +       struct dma_chan                 chan;
> +       spinlock_t                      lock;
> +       struct dma_async_tx_descriptor  desc;
> +       dma_cookie_t                    last_completed;
> +       enum dma_status                 status;
> +};
> +
> +#define IMX_DMA_SG_LOOP                (1 << 0)
> +
> +#define MAX_DMA_CHANNELS 32
> +#define MXC_SDMA_DEFAULT_PRIORITY 1
> +#define MXC_SDMA_MIN_PRIORITY 1
> +#define MXC_SDMA_MAX_PRIORITY 7
> +
> +/*
> + * This enumerates transfer types
> + */
> +enum {
> +       emi_2_per = 0,          /* EMI memory to peripheral */
> +       emi_2_int,              /* EMI memory to internal RAM */
> +       emi_2_emi,              /* EMI memory to EMI memory */
> +       emi_2_dsp,              /* EMI memory to DSP memory */
> +       per_2_int,              /* Peripheral to internal RAM */
> +       per_2_emi,              /* Peripheral to internal EMI memory */
> +       per_2_dsp,              /* Peripheral to DSP memory */
> +       per_2_per,              /* Peripheral to Peripheral */
> +       int_2_per,              /* Internal RAM to peripheral */
> +       int_2_int,              /* Internal RAM to Internal RAM */
> +       int_2_emi,              /* Internal RAM to EMI memory */
> +       int_2_dsp,              /* Internal RAM to DSP memory */
> +       dsp_2_per,              /* DSP memory to peripheral */
> +       dsp_2_int,              /* DSP memory to internal RAM */
> +       dsp_2_emi,              /* DSP memory to EMI memory */
> +       dsp_2_dsp,              /* DSP memory to DSP memory */
> +       emi_2_dsp_loop,         /* EMI memory to DSP memory loopback */
> +       dsp_2_emi_loop,         /* DSP memory to EMI memory loopback */
> +       dvfs_pll,               /* DVFS script with PLL change       */
> +       dvfs_pdr                /* DVFS script without PLL change    */
> +} sdma_transfer_type;

Picky me, but it's no type, its an enum. I understand that it is
a technical term...

What about just calling is sdma_transfer? Short and nice.
Or sdma_transfer_line?

> (...)
> +/*
> + * Stores the start address of the SDMA scripts
> + */
> +static struct sdma_script_start_addrs __sdma_script_addrs;
> +static struct sdma_script_start_addrs *sdma_script_addrs = &__sdma_script_addrs;

What's the rationale behind prefixing that variable with __?

The same name for struct and variable is perfectly viable.

Apart from these smallies (and it's all minor stuff) it's nice and clean so:

Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
