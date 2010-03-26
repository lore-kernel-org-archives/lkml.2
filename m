Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0CZWAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:00:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53599 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0CZWAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <1268843169-15246-1-git-send-email-steve@digidescorp.com>
References: <1268843169-15246-1-git-send-email-steve@digidescorp.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Mar 2010 16:00:21 -0600
X-Google-Sender-Auth: 013daa52c4afe53f
Message-ID: <fa686aa41003261500k65470257j7069bc14bbe705a@mail.gmail.com>
Subject: Re: [PATCH 1/4] dmaengine: xlldma core driver
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, monstr@monstr.eu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 10:26 AM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> Core DMA engine for Xilinx Multi-Port Memory Controller (MPMC) SDMA channels.
> Requires a bus driver to actually connect to a device.
>
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/drivers/dma/xlldma.h b/drivers/dma/xlldma.h
> --- a/drivers/dma/xlldma.h      1969-12-31 18:00:00.000000000 -0600
> +++ b/drivers/dma/xlldma.h      2010-03-17 11:11:16.000000000 -0500

Only put stuff that is actually used by multiple .c files into a .h
file.  Most of this stuff is only used by xlldma.c, so it should be
defined there.

> @@ -0,0 +1,259 @@
> +/*
> + * Xilinx Multi-Port Memory Controller (MPMC) DMA Engine support
> + *
> + * Copyright (C) 2010 Digital Design Corporation. All rights reserved.
> + *
> + * Based on fsldma code that is:
> + * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
> + *
> + * Authors:
> + *   Steve Magnani <steve@digidescorp.com>, Mar 2010
> + *
> + * fsldma authors:
> + *   Zhang Wei     <wei.zhang@freescale.com>, Jul 2007
> + *   Ebony Zhu     <ebony.zhu@freescale.com>, May 2007
> + *
> + * Description:
> + *   DMA engine driver for Xilinx MPMC Soft Direct Memory Access Controller.
> + *   The driver can be attached to "loopback" MPMC SDMA ports, i.e., those
> + *   whose LL_TX signals are connected to the LL_RX signals.
> + *
> + * This is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#ifndef __DMA_XLLDMA_H
> +#define __DMA_XLLDMA_H
> +
> +#include <linux/device.h>
> +#include <linux/dmapool.h>
> +#include <linux/dmaengine.h>
> +
> +/* MPMC SDMA registers definition */
> +
> +#define TX_NXTDESC_PTR      0x00            /* r */
> +#define TX_CURBUF_ADDR      0x01            /* r */
> +#define TX_CURBUF_LENGTH    0x02            /* r */
> +#define TX_CURDESC_PTR      0x03            /* rw */
> +#define TX_TAILDESC_PTR     0x04            /* rw */
> +#define TX_CHNL_CTRL        0x05            /* rw */
> +/*
> + 0:7      24:31       IRQTimeout
> + 8:15     16:23       IRQCount
> + 16:20    11:15       Reserved
> + 21       10          0
> + 22       9           UseIntOnEnd
> + 23       8           LdIRQCnt
> + 24       7           IRQEn
> + 25:28    3:6         Reserved
> + 29       2           IrqErrEn
> + 30       1           IrqDlyEn
> + 31       0           IrqCoalEn
> +*/
> +#define CHNL_CTRL_IRQ_IOE       (1 << 9)
> +#define CHNL_CTRL_IRQ_LD_CNT   (1 << 8)
> +#define CHNL_CTRL_IRQ_EN        (1 << 7)
> +#define CHNL_CTRL_IRQ_ERR_EN    (1 << 2)
> +#define CHNL_CTRL_IRQ_DLY_EN    (1 << 1)
> +#define CHNL_CTRL_IRQ_COAL_EN   (1 << 0)
> +#define TX_IRQ_REG          0x06            /* rw */
> +/*
> +  0:7      24:31       DltTmrValue
> + 8:15     16:23       ClscCntrValue
> + 16:17    14:15       Reserved
> + 18:21    10:13       ClscCnt
> + 22:23    8:9         DlyCnt
> + 24:28    3::7        Reserved
> + 29       2           ErrIrq
> + 30       1           DlyIrq
> + 31       0           CoalIrq
> + */
> +#define TX_CHNL_STS         0x07            /* r */
> +/*
> +   0:9      22:31   Reserved
> + 10       21      TailPErr
> + 11       20      CmpErr
> + 12       19      AddrErr
> + 13       18      NxtPErr
> + 14       17      CurPErr
> + 15       16      BsyWr
> + 16:23    8:15    Reserved
> + 24       7       Error
> + 25       6       IOE
> + 26       5       SOE
> + 27       4       Cmplt
> + 28       3       SOP
> + 29       2       EOP
> + 30       1       EngBusy
> + 31       0       Reserved
> +*/
> +
> +#define RX_NXTDESC_PTR      0x08            /* r */
> +#define RX_CURBUF_ADDR      0x09            /* r */
> +#define RX_CURBUF_LENGTH    0x0a            /* r */
> +#define RX_CURDESC_PTR      0x0b            /* rw */
> +#define RX_TAILDESC_PTR     0x0c            /* rw */
> +#define RX_CHNL_CTRL        0x0d            /* rw */
> +/*
> + 0:7      24:31       IRQTimeout
> + 8:15     16:23       IRQCount
> + 16:20    11:15       Reserved
> + 21       10          0
> + 22       9           UseIntOnEnd
> + 23       8           LdIRQCnt
> + 24       7           IRQEn
> + 25:28    3:6         Reserved
> + 29       2           IrqErrEn
> + 30       1           IrqDlyEn
> + 31       0           IrqCoalEn
> + */
> +#define RX_IRQ_REG          0x0e            /* rw */
> +#define IRQ_COAL        (1 << 0)
> +#define IRQ_DLY         (1 << 1)
> +#define IRQ_ERR         (1 << 2)
> +#define IRQ_DMAERR      (1 << 7)            /* this is not documented ??? */
> +/*
> + 0:7      24:31       DltTmrValue
> + 8:15     16:23       ClscCntrValue
> + 16:17    14:15       Reserved
> + 18:21    10:13       ClscCnt
> + 22:23    8:9         DlyCnt
> + 24:28    3::7        Reserved
> +*/
> +#define RX_CHNL_STS         0x0f        /* r */
> +#define CHNL_STS_ENGBUSY    (1 << 1)
> +#define CHNL_STS_EOP        (1 << 2)
> +#define CHNL_STS_SOP        (1 << 3)
> +#define CHNL_STS_CMPLT      (1 << 4)
> +#define CHNL_STS_SOE        (1 << 5)
> +#define CHNL_STS_IOE        (1 << 6)
> +#define CHNL_STS_ERR        (1 << 7)
> +
> +#define CHNL_STS_BSYWR      (1 << 16)
> +#define CHNL_STS_CURPERR    (1 << 17)
> +#define CHNL_STS_NXTPERR    (1 << 18)
> +#define CHNL_STS_ADDRERR    (1 << 19)
> +#define CHNL_STS_CMPERR     (1 << 20)
> +#define CHNL_STS_TAILERR    (1 << 21)
> +/*
> + 0:9      22:31   Reserved
> + 10       21      TailPErr
> + 11       20      CmpErr
> + 12       19      AddrErr
> + 13       18      NxtPErr
> + 14       17      CurPErr
> + 15       16      BsyWr
> + 16:23    8:15    Reserved
> + 24       7       Error
> + 25       6       IOE
> + 26       5       SOE
> + 27       4       Cmplt
> + 28       3       SOP
> + 29       2       EOP
> + 30       1       EngBusy
> + 31       0       Reserved
> +*/
> +
> +#define DMA_CONTROL_REG             0x10            /* rw */
> +#define DMA_CONTROL_RST                 (1 << 0)
> +#define DMA_TAIL_ENABLE                 (1 << 2)
> +
> +/* CDMAC descriptor status bit definitions */
> +
> +#define STS_CTRL_APP0_ERR         (1 << 31)
> +#define STS_CTRL_APP0_IRQONEND    (1 << 30)
> +/* undoccumented */
> +#define STS_CTRL_APP0_STOPONEND   (1 << 29)
> +#define STS_CTRL_APP0_CMPLT       (1 << 28)
> +#define STS_CTRL_APP0_SOP         (1 << 27)
> +#define STS_CTRL_APP0_EOP         (1 << 26)
> +#define STS_CTRL_APP0_ENGBUSY     (1 << 25)
> +/* undocumented */
> +#define STS_CTRL_APP0_ENGRST      (1 << 24)
> +
> +/**
> + * struct cdmac_bd - LocalLink buffer descriptor format
> + *
> + * app0 bits:
> + *     0    Error
> + *     1    IrqOnEnd    generate an interrupt at completion of DMA  op
> + *     2    reserved
> + *     3    completed   Current descriptor completed
> + *     4    SOP         TX - marks first desc/ RX marks first desct
> + *     5    EOP         TX marks last desc/RX marks last desc
> + *     6    EngBusy     DMA is processing
> + *     7    reserved
> + *     8:31 application specific
> + */
> +struct cdmac_bd {
> +       u32 next;       /* Physical address of next buffer descriptor */
> +       u32 phys;       /* Physical address of transfer buffer */
> +       u32 len;        /* Length of transfer buffer, in bytes */
> +       u32 app0;
> +       u32 app1;
> +       u32 app2;
> +       u32 app3;
> +       u32 app4;
> +};

Hmmm.  All this stuff looks *really* familiar.  It looks like it was
lifted directly from ll_temac.c.  Instead of cloning you should factor
out the common bits for the Xilinx dma interface out into a common
file.  In fact, ll_temac.c and this dma driver can probably share
common bd management routines.  Both drivers would gain the benefit of
having a single code base.

> +
> +struct xlldma_bd {
> +       struct cdmac_bd   dst;  /* LL recv. */
> +       struct cdmac_bd   src;  /* LL xmit */
> +} __attribute__((aligned(32)));
> +
> +struct xlldma_desc {
> +       struct xlldma_bd *bd;           /* HW buffer descriptors */
> +       struct list_head  node;         /* Position in tx_list */
> +       struct list_head  tx_list;      /* Fragments of a DMA request */
> +       struct dma_async_tx_descriptor async_tx;
> +};
> +
> +struct xlldma_chan;
> +#define XLLDMA_MAX_CHANS_PER_DEVICE 8
> +
> +struct xlldma_device {
> +       struct device       *dev;
> +       struct dma_device   common;
> +       struct kmem_cache   *desc_cache;
> +       struct xlldma_chan  *chan[XLLDMA_MAX_CHANS_PER_DEVICE];
> +};
> +
> +struct xlldma_chan {
> +#ifdef CONFIG_PPC_DCR_NATIVE
> +       dcr_host_t reg_dcrs;
> +#else
> +       struct resource reg;            /* Resource for register */
> +       u32 __iomem *reg_base;
> +#endif
> +       dma_cookie_t        completed_cookie; /* Most recent cookie completed */
> +       dma_cookie_t        stop_after_cookie;/* Last cookie released to HW */
> +       spinlock_t          desc_lock;        /* Descriptor operation lock */
> +       struct list_head    desc_queue;       /* Descriptors queue */
> +       struct list_head    pending_free;     /* Waiting for ACK */
> +       struct dma_chan     common;           /* DMA common channel */
> +       struct dma_pool     *bd_pool;         /* HW descriptors pool */
> +       struct xlldma_device *xdev;           /* Channel device */
> +       struct xlldma_bd    *bd_tail;         /* Tail of the HW desc chain */
> +       dma_addr_t          bd_tail_phys;     /* Physical addr of bd_tail */
> +       int                 rx_irq;           /* Channel receive IRQ */
> +       int                 tx_irq;           /* Channel transmit IRQ */
> +       int                 id;               /* Raw id of this channel */
> +       struct tasklet_struct tasklet;
> +};
> +
> +#define to_xlldma_chan(chan) container_of(chan, struct xlldma_chan, common)
> +#define to_xlldma_desc(lh) list_entry(lh, struct xlldma_desc, node)
> +#define tx_to_xlldma_desc(tx) container_of(tx, struct xlldma_desc, async_tx)
> +
> +/* Bus driver interface */
> +int xlldma_device_setup(struct device *dev);
> +int xlldma_device_teardown(struct device *dev);
> +void xlldma_chan_remove(struct xlldma_chan *xchan);
> +void xlldma_cleanup_tasklet(unsigned long data);
> +irqreturn_t xlldma_chan_rx_interrupt(int irq, void *data);
> +irqreturn_t xlldma_chan_tx_interrupt(int irq, void *data);
> +
> +#endif /* __DMA_XLLDMA_H */
> diff -uprN a/drivers/dma/xlldma.c b/drivers/dma/xlldma.c
> --- a/drivers/dma/xlldma.c      1969-12-31 18:00:00.000000000 -0600
> +++ b/drivers/dma/xlldma.c      2010-03-17 11:11:16.000000000 -0500
> @@ -0,0 +1,1099 @@
> +/*
> + * Xilinx Multi-Port Memory Controller (MPMC) DMA Engine support
> + *
> + * Copyright (C) 2010 Digital Design Corporation. All rights reserved.
> + *
> + * Based on fsldma code that is:
> + * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
> + *
> + * Authors:
> + *   Steve Magnani <steve@digidescorp.com>, Mar 2010
> + *
> + * fsldma authors:
> + *   Zhang Wei     <wei.zhang@freescale.com>, Jul 2007
> + *   Ebony Zhu     <ebony.zhu@freescale.com>, May 2007
> + *
> + * Description:
> + *   DMA engine driver for Xilinx MPMC Soft Direct Memory Access Controller.
> + *   The driver can be attached to "loopback" MPMC SDMA ports, i.e., those
> + *   whose LL_TX signals are connected to the LL_RX signals.
> + *
> + * This is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/interrupt.h>
> +#include <linux/dmaengine.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dmapool.h>
> +#include <linux/sysfs.h>
> +
> +#include "xlldma.h"
> +
> +/* Forward declarations */
> +static enum dma_status xlldma_desc_status(struct xlldma_chan *chan,
> +                                         struct xlldma_desc *desc);
> +
> +/* ---------------------------------------------------------------------
> + * Descriptor accessors
> + */
> +inline void set_desc_cnt(struct xlldma_desc *desc, u32 count)
> +{
> +       desc->bd->src.len = count;
> +       desc->bd->dst.len = count;
> +}
> +
> +inline void set_desc_src(struct xlldma_desc *desc, dma_addr_t src)
> +{
> +       desc->bd->src.phys = src;
> +}
> +
> +inline void set_desc_dest(struct xlldma_desc *desc, dma_addr_t dest)
> +{
> +       desc->bd->dst.phys = dest;
> +}
> +
> +inline void set_desc_next_bd(struct xlldma_desc *desc, dma_addr_t next_bd_phys)
> +{
> +       desc->bd->dst.next = next_bd_phys + offsetof(struct xlldma_bd, dst);
> +       desc->bd->src.next = next_bd_phys + offsetof(struct xlldma_bd, src);
> +}
> +
> +inline void set_desc_next(struct xlldma_desc *desc, struct xlldma_desc *next)
> +{
> +       set_desc_next_bd(desc, next->async_tx.phys);
> +}
> +
> +inline void set_desc_start(struct xlldma_desc *desc)
> +{
> +       desc->bd->src.app0 |= STS_CTRL_APP0_SOP;
> +       desc->bd->dst.app0 |= STS_CTRL_APP0_SOP;
> +}
> +
> +inline void set_desc_end(struct xlldma_desc *desc)
> +{
> +       desc->bd->src.app0 |= STS_CTRL_APP0_EOP;
> +       desc->bd->dst.app0 |= STS_CTRL_APP0_EOP;
> +}
> +
> +inline void set_desc_single(struct xlldma_desc *desc)
> +{
> +       desc->bd->src.app0 |= STS_CTRL_APP0_SOP | STS_CTRL_APP0_EOP;
> +       desc->bd->dst.app0 |= STS_CTRL_APP0_SOP | STS_CTRL_APP0_EOP;
> +}
> +
> +/* ---------------------------------------------------------------------
> + * Low level register access functions
> + */
> +
> +inline u32 xlldma_in32(const struct xlldma_chan *chan, int reg)
> +{
> +#ifdef CONFIG_PPC_DCR_NATIVE
> +       return dcr_read(chan->reg_dcrs, reg);
> +#else
> +       return __raw_readl(chan->reg_base + reg);
> +#endif
> +}
> +
> +inline void xlldma_out32(const struct xlldma_chan *chan, int reg,
> +                        u32 value)
> +{
> +#ifdef CONFIG_PPC_DCR_NATIVE
> +       dcr_write(chan->reg_dcrs, reg, value);
> +#else
> +       __raw_writel(value, chan->reg_base + reg);
> +#endif
> +}
> +
> +/* ---------------------------------------------------------------------
> + * Debugging
> + */
> +
> +#ifndef DEBUG
> +static inline void xlldma_log_dma_chain(struct xlldma_chan *chan) { }
> +#else

Typically the negative case is put at the bottom for things like this.

> +/**
> + * Print the status of the specified DMA chain.
> + *
> + * @chan : DMA channel
> + */
> +static void xlldma_log_dma_chain(struct xlldma_chan *chan)
> +{
> +       unsigned long flags;
> +       struct xlldma_desc *desc;
> +       struct device *dev = chan->xdev->dev;
> +
> +       local_irq_save(flags);
> +
> +       dev_info(dev, "\n");
> +       dev_info(dev,
> +                "**************** DMA Chain, channel %d *****************\n",
> +                chan->id);
> +       dev_info(dev, "\n");
> +       dev_info(dev, "Last completed cookie: %ld\n",
> +                (unsigned long)chan->completed_cookie);
> +       dev_info(dev, "HW stop-after cookie:  %ld\n",
> +                (unsigned long)chan->stop_after_cookie);
> +       dev_info(dev, "Last allocated cookie: %ld\n",
> +                (unsigned long)chan->common.cookie);
> +       dev_info(dev, "\n");
> +
> +       dev_info(dev, "    Register            TX         RX\n");
> +       dev_info(dev, "    --------         --------   --------\n");
> +#ifndef CONFIG_PPC_DCR_NATIVE
> +       dev_info(dev, "    Base Address     %08lX   %08lX\n",
> +                (unsigned long) (chan->reg_base),
> +                (unsigned long) (chan->reg_base + RX_NXTDESC_PTR));
> +#endif
> +       dev_info(dev, "    Curr descriptor  %08X   %08X\n",
> +                xlldma_in32(chan, TX_CURDESC_PTR),
> +                xlldma_in32(chan, RX_CURDESC_PTR));
> +       dev_info(dev, "    Next descriptor  %08X   %08X\n",
> +                xlldma_in32(chan, TX_NXTDESC_PTR),
> +                xlldma_in32(chan, RX_NXTDESC_PTR));
> +       dev_info(dev, "    Tail descriptor  %08X   %08X\n",
> +                xlldma_in32(chan, TX_TAILDESC_PTR),
> +                xlldma_in32(chan, RX_TAILDESC_PTR));
> +       dev_info(dev, "    Current buffer   %08X   %08X\n",
> +                xlldma_in32(chan, TX_CURBUF_ADDR),
> +                xlldma_in32(chan, RX_CURBUF_ADDR));
> +       dev_info(dev, "    Current length   %08X   %08X\n",
> +                xlldma_in32(chan, TX_CURBUF_LENGTH),
> +                xlldma_in32(chan, RX_CURBUF_LENGTH));
> +
> +       /* Dump BDs based on the desc_queue */
> +       if (!list_empty(&chan->desc_queue)) {
> +               dev_info(dev, "\n");
> +               dev_info(dev, "          Descriptor                           "
> +                             "               Status\n");
> +               dev_info(dev, " Cookie   & RX BD      TX BD      From       "
> +                             "To     XferLen   TX  RX\n");
> +               dev_info(dev, "--------  ----------  --------  --------  "
> +                             "--------  --------  --  --\n");
> +       }
> +
> +       list_for_each_entry(desc, &chan->desc_queue, node) {
> +               dev_info(dev, "%08lX   %08lX   %08lX  %08lX  %08lX  %8lu  "
> +                             "%02X  %02X\n",
> +                        (unsigned long) desc->async_tx.cookie,
> +                        (unsigned long) desc->async_tx.phys
> +                            + offsetof(struct xlldma_bd, dst),
> +                        (unsigned long) desc->async_tx.phys
> +                            + offsetof(struct xlldma_bd, src),
> +                        (unsigned long) desc->bd->src.phys,
> +                        (unsigned long) desc->bd->dst.phys,
> +                        (unsigned long) desc->bd->src.len,
> +                        desc->bd->src.app0 >> 24, desc->bd->dst.app0 >> 24);
> +       }
> +
> +       local_irq_restore(flags);
> +}
> +#endif
> +
> +/* ---------------------------------------------------------------------
> + * SDMA HW control
> + */
> +
> +static void dma_init(struct xlldma_chan *chan)
> +{
> +       u32 timeout;
> +
> +       /* Reset the channel */
> +       xlldma_out32(chan, DMA_CONTROL_REG, DMA_CONTROL_RST);
> +       timeout = 1000;         /* microseconds, nominally */
> +       while (xlldma_in32(chan, DMA_CONTROL_REG) & DMA_CONTROL_RST) {
> +               udelay(1);

Be careful with udelays.  You may be wasting processor cycles better
used for something else.  Is the udelay strictly necessary?  Could you
sleep instead?

> +               if (--timeout == 0) {
> +                       dev_err(chan->xdev->dev,
> +                               "DMA reset timeout, channel %d!!\n", chan->id);
> +                       break;
> +               }
> +       }
> +
> +       /* NOTE: No-op on modern MPMCs (>= 3.00.a, possibly earlier) */
> +       xlldma_out32(chan, DMA_CONTROL_REG, DMA_TAIL_ENABLE);
> +
> +       /* Clear Interrupt registers of both channels, as the software reset
> +        * does not clear any register values. Not doing so will cause
> +        * interrupts asserted after the software reset if there is any
> +        * interrupt left over before.
> +        */
> +       xlldma_out32(chan, RX_IRQ_REG,
> +                    IRQ_COAL | IRQ_DLY | IRQ_ERR | IRQ_DMAERR);
> +       xlldma_out32(chan, TX_IRQ_REG,
> +                    IRQ_COAL | IRQ_DLY | IRQ_ERR | IRQ_DMAERR);
> +
> +       /* Configure interrupt enables */
> +       /* On the TX side, we optionally look only for errors */
> +       /* On the RX side, we look for errors and EOPs */
> +       if (chan->tx_irq == NO_IRQ)
> +               xlldma_out32(chan, TX_CHNL_CTRL, 0);
> +       else {
> +               xlldma_out32(chan, TX_CHNL_CTRL,
> +                            CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_ERR_EN);
> +       }

simplify:
reg = chan->tx_irq != NO_IRQ ? CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_ERR_EN : 0;
xlldma_out32(chan, TX_CHNL_CTRL, reg);

It's easier to follow if the calculation is done first and there is
only one xlldma_out32() statement.

> +
> +       if (chan->rx_irq == NO_IRQ)
> +               xlldma_out32(chan, RX_CHNL_CTRL, 0);
> +       else {
> +               /* Set up for interrupt on every EOP */
> +               u32 rx_control = (1 << 16) | CHNL_CTRL_IRQ_LD_CNT;
> +               rx_control |=   CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_COAL_EN
> +                             | CHNL_CTRL_IRQ_ERR_EN;
> +
> +               xlldma_out32(chan, RX_CHNL_CTRL, rx_control);
> +       }

ditto

> +}
> +
> +/**
> + * dma_set_start_bd - Tell the DMA HW where to find the first descriptor
> + *
> + * @chan         : DMA channel
> + * @start_bd_phys : Physical address of first descriptor
> + */
> +static void dma_set_start_bd(struct xlldma_chan *chan, dma_addr_t start_bd_phys)
> +{
> +       dma_addr_t tx_start_phys, rx_start_phys;
> +
> +       tx_start_phys = start_bd_phys + offsetof(struct xlldma_bd, src);
> +       rx_start_phys = start_bd_phys + offsetof(struct xlldma_bd, dst);
> +
> +       dev_dbg(chan->xdev->dev, "SDMA HW starts with 0x%lx\n",
> +               (unsigned long)start_bd_phys);
> +
> +       xlldma_out32(chan, RX_CURDESC_PTR, rx_start_phys);
> +       xlldma_out32(chan, TX_CURDESC_PTR, tx_start_phys);
> +}
> +
> +/**
> + * xlldma_set_start - Find the first transfer and tell the HW where to find
> + *                   its descriptor
> + *
> + * @chan : DMA channel
> + */
> +static void xlldma_set_start(struct xlldma_chan *chan)
> +{
> +       struct list_head *entry;
> +
> +       /* Find the first un-transferred desciptor */
> +       list_for_each(entry, &chan->desc_queue) {
> +               if (xlldma_desc_status(chan, to_xlldma_desc(entry))
> +                   != DMA_SUCCESS)
> +                       break;
> +       }
> +
> +       if (entry != &chan->desc_queue) {
> +               struct xlldma_desc *desc = to_xlldma_desc(entry);
> +               dma_set_start_bd(chan, desc->async_tx.phys);
> +       } else
> +               dma_set_start_bd(chan, chan->bd_tail_phys);

This could use a comment describing what is is making a decision on.

> +}
> +
> +/**
> + * dma_set_tail        - Tell the DMA HW where the last descriptor to proccess resides
> + *               This starts data transfer if the engine was idle.
> + *
> + * @chan       : DMA channel
> + * @tail_desc  : Last transfer to perform
> + */
> +static void dma_set_tail(struct xlldma_chan *chan,
> +                        struct xlldma_desc *tail_desc)
> +{
> +       dma_addr_t tail_desc_phys;
> +       dma_addr_t rx_tail_phys, tx_tail_phys;
> +
> +       tail_desc_phys = tail_desc->async_tx.phys;
> +
> +       tx_tail_phys  = tail_desc_phys + offsetof(struct xlldma_bd, src);
> +       rx_tail_phys  = tail_desc_phys + offsetof(struct xlldma_bd, dst);
> +
> +       /* Keep track of where we've told the HW to stop, in cookie-space */
> +       chan->stop_after_cookie = tail_desc->async_tx.cookie;
> +
> +       dev_dbg(chan->xdev->dev, "SDMA HW ends with   0x%lx (cookie %lu)\n",
> +               (unsigned long)tail_desc_phys,
> +               (unsigned long)chan->stop_after_cookie);
> +
> +       /* Go! */
> +       xlldma_out32(chan, RX_TAILDESC_PTR, rx_tail_phys);
> +       xlldma_out32(chan, TX_TAILDESC_PTR, tx_tail_phys);
> +}
> +
> +static void dma_abort(struct xlldma_chan *chan)
> +{
> +       /* Disable interrupts before resetting the core */
> +       xlldma_out32(chan, TX_CHNL_CTRL, 0);
> +       xlldma_out32(chan, RX_CHNL_CTRL, 0);
> +
> +       dma_init(chan);
> +}
> +
> +/**
> + * append_bd_chain - Link the HW buffer descriptors of a new request to
> + *                the end of the chain of requests in progress (if any).
> + *
> + * The caller is assumed to hold the desc_lock.
> + *
> + * @chan     : DMA channel
> + * @req_desc : Request to link into the HW processing chain
> + */
> +static void append_bd_chain(struct xlldma_chan *chan,
> +                           struct xlldma_desc *req_desc)
> +{
> +       struct xlldma_desc *first_desc, *last_desc;
> +       struct xlldma_bd   *first_bd;
> +       dma_addr_t      first_bd_phys;
> +
> +       first_desc = to_xlldma_desc(req_desc->tx_list.next);
> +       last_desc  = to_xlldma_desc(req_desc->tx_list.prev);
> +
> +       /* Make the bd_tail the BD for the first descriptor of this request */
> +       first_bd = first_desc->bd;
> +       first_bd_phys = first_desc->async_tx.phys;
> +
> +       memcpy(chan->bd_tail, first_bd, sizeof(*chan->bd_tail));
> +       first_desc->bd = chan->bd_tail;
> +       first_desc->async_tx.phys = chan->bd_tail_phys;
> +
> +       /* The original first descriptor BD now becomes the bd_tail. */
> +       chan->bd_tail = first_bd;
> +       chan->bd_tail_phys = first_bd_phys;
> +
> +       /* Link the tail of this request to the bd_tail */
> +       set_desc_next_bd(last_desc, chan->bd_tail_phys);
> +}
> +
> +/**
> + * xlldma_tx_submit - DMAEngine API for queuing a new request.
> + *
> + * NOTE: this function does not make the new request visible to HW.
> + *
> + * @tx : Request chain to queue
> + *
> + * Return - 'cookie' we've assigned to the request
> + */
> +static dma_cookie_t xlldma_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +       struct xlldma_chan *chan = to_xlldma_chan(tx->chan);
> +       struct xlldma_desc *req_desc = tx_to_xlldma_desc(tx);
> +       struct xlldma_desc *child;
> +       unsigned long flags;
> +       dma_cookie_t cookie;
> +
> +       spin_lock_irqsave(&chan->desc_lock, flags);
> +
> +       /*
> +        * assign cookies to all of the software descriptors
> +        * that make up this request
> +        */
> +       cookie = chan->common.cookie;
> +       list_for_each_entry(child, &req_desc->tx_list, node) {
> +               cookie++;
> +               if (cookie < 0)
> +                       cookie = DMA_MIN_COOKIE;
> +
> +               child->async_tx.cookie = cookie;
> +       }
> +       chan->common.cookie = cookie;
> +
> +       append_bd_chain(chan, req_desc);
> +       list_splice_tail_init(&req_desc->tx_list, &chan->desc_queue);
> +
> +       spin_unlock_irqrestore(&chan->desc_lock, flags);
> +
> +       return cookie;
> +}
> +
> +/**
> + * xlldma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
> + * @chan : DMA channel
> + *
> + * Return - An allocated descriptor. NULL for failed.
> + */
> +static struct xlldma_desc *xlldma_alloc_descriptor(struct xlldma_chan *chan)
> +{
> +       struct xlldma_desc *xdesc;
> +       struct xlldma_device *xdev = chan->xdev;
> +
> +       xdesc = kmem_cache_zalloc(xdev->desc_cache, GFP_ATOMIC);
> +       if (unlikely(!xdesc)) {
> +               dev_err(xdev->dev, "Descriptor allocation failed\n");
> +               return NULL;
> +       }
> +
> +       INIT_LIST_HEAD(&xdesc->tx_list);
> +       dma_async_tx_descriptor_init(&xdesc->async_tx, &chan->common);
> +       xdesc->async_tx.tx_submit = xlldma_tx_submit;
> +
> +       xdesc->bd = dma_pool_alloc(chan->bd_pool, GFP_ATOMIC,
> +                                  &xdesc->async_tx.phys);
> +       if (likely(xdesc->bd)) {
> +               memset(xdesc->bd, 0, sizeof(*xdesc->bd));
> +       } else {
> +               dev_err(xdev->dev, "DMA pool exhausted\n");
> +               kmem_cache_free(xdev->desc_cache, xdesc);
> +               return NULL;
> +       }

Again, common convention is to put the failure case first and remove
the need for an else block.

> +
> +       return xdesc;
> +}
> +
> +/**
> + * xlldma_free_descriptor - Free a previously allocated descriptor
> + * @chan  : DMA channel
> + * @xdesc : Descriptor to free (may be NULL)
> + *
> + * Return - An allocated descriptor. NULL for failed.
> + */
> +static void xlldma_free_descriptor(struct xlldma_chan *chan,
> +                                  struct xlldma_desc *xdesc)
> +{
> +       if (likely(xdesc)) {
> +               dma_pool_free(chan->bd_pool, xdesc->bd, xdesc->async_tx.phys);
> +               kmem_cache_free(chan->xdev->desc_cache, xdesc);
> +       }
> +}
> +
> +/**
> + * xlldma_alloc_chan_resources - Allocate resources for DMA channel.
> + * @dchan : DMA channel
> + *
> + * This function will create the dma pool for descriptor allocation.
> + *
> + * Return - The number of descriptors allocated.
> + *       -ENOMEM on error.
> + */
> +static int xlldma_alloc_chan_resources(struct dma_chan *dchan)
> +{
> +       struct xlldma_chan *chan = to_xlldma_chan(dchan);
> +
> +       might_sleep();
> +
> +       /* Has this channel already been allocated? */
> +       if (chan->bd_pool)
> +               return 1;
> +
> +       chan->bd_pool = dma_pool_create("xlldma_engine_bd_pool",
> +                                       chan->xdev->dev,
> +                                       sizeof(struct xlldma_bd),
> +                                       __alignof__(struct xlldma_bd), 0);
> +       if (!chan->bd_pool) {
> +               dev_err(chan->xdev->dev,
> +                       "unable to allocate channel %d BD pool.\n", chan->id);
> +               return -ENOMEM;
> +       }
> +
> +       chan->bd_tail = dma_pool_alloc(chan->bd_pool, GFP_KERNEL,
> +                                      &chan->bd_tail_phys);
> +       if (likely(chan->bd_tail)) {
> +               dma_set_start_bd(chan, chan->bd_tail_phys);
> +       } else {
> +               dma_pool_destroy(chan->bd_pool);
> +               chan->bd_pool = NULL;
> +               return -ENOMEM;
> +       }
> +
> +       /* there is at least one descriptor free to be allocated */
> +       return 1;
> +}
> +
> +/**
> + * xlldma_free_desc_list - Free all descriptors in a queue
> + * @chan: DMA channel
> + * @list: the list to free
> + *
> + * LOCKING: must hold chan->desc_lock
> + */
> +static void xlldma_free_desc_list(struct xlldma_chan *chan,
> +                                 struct list_head *list)
> +{
> +       struct xlldma_desc *desc, *_desc;
> +
> +       list_for_each_entry_safe(desc, _desc, list, node) {
> +               list_del(&desc->node);
> +               xlldma_free_descriptor(chan, desc);
> +       }
> +}
> +
> +/**
> + * xlldma_free_chan_resources - Free all resources of the channel.
> + * @dchan : DMA channel
> + */
> +static void xlldma_free_chan_resources(struct dma_chan *dchan)
> +{
> +       struct xlldma_chan *chan = to_xlldma_chan(dchan);
> +       unsigned long flags;
> +
> +       dev_dbg(chan->xdev->dev, "Free all channel resources.\n");
> +       spin_lock_irqsave(&chan->desc_lock, flags);
> +       xlldma_free_desc_list(chan, &chan->desc_queue);
> +       dma_pool_free(chan->bd_pool, chan->bd_tail, chan->bd_tail_phys);
> +       spin_unlock_irqrestore(&chan->desc_lock, flags);
> +
> +       dma_pool_destroy(chan->bd_pool);
> +       chan->bd_pool = NULL;
> +}
> +
> +static struct dma_async_tx_descriptor *
> +xlldma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
> +{
> +       struct xlldma_chan *chan;
> +       struct xlldma_desc *xdesc = NULL;
> +
> +       if (!dchan)
> +               return NULL;
> +
> +       chan = to_xlldma_chan(dchan);
> +
> +       if (chan->tx_irq == NO_IRQ) {
> +               dev_dbg(chan->xdev->dev,
> +                       "Channel does not support DMA_INTERRUPT\n");
> +               goto fail;
> +       }
> +
> +       dev_dbg(chan->xdev->dev, "DMA_INTERRUPT request\n");
> +       xdesc = xlldma_alloc_descriptor(chan);
> +       if (!xdesc)
> +               goto fail;

But is the descriptor alloc failed, then what is there to free (after
the fail label)?

> +
> +       /*
> +        * Subtle point:
> +        * Interrupts are achieved by setting up a DMA operation
> +        * that will fail with an invalid source buffer address (0)
> +        */
> +       set_desc_single(xdesc);
> +
> +       xdesc->async_tx.flags  = flags; /* client is in control of this ack */
> +       xdesc->async_tx.cookie = -EBUSY;
> +
> +       list_add_tail(&xdesc->node, &xdesc->tx_list);
> +
> +       return &xdesc->async_tx;
> +
> +fail:
> +       xlldma_free_descriptor(chan, xdesc);
> +       return NULL;
> +}
> +
> +static struct dma_async_tx_descriptor *
> +xlldma_prep_memcpy(struct dma_chan *dchan, dma_addr_t dma_dest,
> +                  dma_addr_t dma_src,  size_t len, unsigned long flags)
> +{
> +       struct xlldma_chan *chan;
> +       struct xlldma_desc *xdesc = NULL;
> +
> +       if (!dchan || !len)
> +               return NULL;
> +
> +       chan = to_xlldma_chan(dchan);
> +
> +       dev_dbg(chan->xdev->dev, "Memcpy: 0x%lX to 0x%lX (%u bytes)\n",
> +               (unsigned long) dma_src, (unsigned long) dma_dest, len);
> +
> +       /* Allocate the descriptor from DMA pool */
> +       xdesc = xlldma_alloc_descriptor(chan);
> +       if (!xdesc)
> +               goto fail;

Ditto here.

> +
> +       set_desc_cnt(xdesc,  len);
> +       set_desc_src(xdesc,  dma_src);
> +       set_desc_dest(xdesc, dma_dest);
> +       set_desc_single(xdesc);
> +
> +       xdesc->async_tx.flags  = flags; /* client is in control of this ack */
> +       xdesc->async_tx.cookie = -EBUSY;
> +
> +       list_add_tail(&xdesc->node, &xdesc->tx_list);
> +
> +       return &xdesc->async_tx;
> +
> +fail:
> +       xlldma_free_descriptor(chan, xdesc);
> +       return NULL;
> +}
> +
> +static void xlldma_device_terminate_all(struct dma_chan *dchan)
> +{
> +       struct xlldma_chan *chan;
> +       unsigned long flags;
> +
> +       if (!dchan)
> +               return;
> +
> +       chan = to_xlldma_chan(dchan);
> +
> +       /* Halt the DMA engine */
> +       dma_abort(chan);
> +
> +       spin_lock_irqsave(&chan->desc_lock, flags);
> +
> +       xlldma_free_desc_list(chan, &chan->desc_queue);
> +       xlldma_free_desc_list(chan, &chan->pending_free);
> +
> +       spin_unlock_irqrestore(&chan->desc_lock, flags);
> +}
> +
> +/**
> + * xlldma_update_completed_cookie - Update the completed cookie based on
> + *                                 the HW's current status.
> + * @chan : DMA channel
> + *
> + * CONTEXT: hardirq
> + */
> +static void xlldma_update_completed_cookie(struct xlldma_chan *chan)
> +{
> +       struct xlldma_desc *last_completed = NULL;
> +       struct xlldma_desc *desc;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&chan->desc_lock, flags);
> +
> +       list_for_each_entry(desc, &chan->desc_queue, node) {
> +               if (desc->bd->dst.app0 & STS_CTRL_APP0_CMPLT)
> +                       last_completed = desc;
> +               else
> +                       break;

+               if (!(desc->bd->dst.app0 & STS_CTRL_APP0_CMPLT))
+                       break;
+               last_completed = desc;

> +       }
> +
> +       if (last_completed)
> +               chan->completed_cookie = last_completed->async_tx.cookie;
> +
> +       spin_unlock_irqrestore(&chan->desc_lock, flags);
> +}
> +
> +
> +/**
> + * xlldma_desc_status - Check the status of a descriptor
> + * @chan: DMA channel
> + * @desc: DMA SW descriptor
> + *
> + * This function will return the status of the given descriptor
> + */
> +static enum dma_status xlldma_desc_status(struct xlldma_chan *chan,
> +                                         struct xlldma_desc *desc)
> +{
> +       return dma_async_is_complete(desc->async_tx.cookie,
> +                                    chan->completed_cookie,
> +                                    chan->common.cookie);
> +}
> +
> +/**
> + * xlldma_unmap_desc - Unmap DMA addresses used by a descriptor
> + * @chan : DMA channel
> + * @desc : Descriptor
> + */
> +static inline void xlldma_unmap_desc(struct xlldma_chan *chan,
> +                                    struct xlldma_desc *desc)
> +{
> +       enum dma_ctrl_flags flags = desc->async_tx.flags;
> +       struct device *dev = chan->xdev->dev;
> +
> +       if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> +               if (flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> +                       dma_unmap_single(dev, desc->bd->dst.phys,
> +                                        desc->bd->dst.len, DMA_FROM_DEVICE);
> +               else
> +                       dma_unmap_page(dev, desc->bd->dst.phys,
> +                                      desc->bd->dst.len, DMA_FROM_DEVICE);
> +       }
> +       if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> +               if (flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> +                       dma_unmap_single(dev, desc->bd->src.phys,
> +                                        desc->bd->src.len, DMA_TO_DEVICE);
> +               else
> +                       dma_unmap_page(dev, desc->bd->src.phys,
> +                                      desc->bd->src.len, DMA_TO_DEVICE);
> +       }
> +}
> +
> +/**
> + * xlldma_chan_desc_cleanup - Clean up descriptors
> + * @chan : DMA channel
> + *
> + * This function cleans up the desc_queue of DMA channel.
> + * Completions are issued for finished descriptors.
> + */
> +static void xlldma_chan_desc_cleanup(struct xlldma_chan *chan)
> +{
> +       struct xlldma_desc *desc, *_desc;
> +       struct list_head *last_complete = &chan->desc_queue;
> +       struct list_head *entry;
> +       struct list_head cleanup_list;
> +
> +       unsigned long flags;
> +
> +       INIT_LIST_HEAD(&cleanup_list);
> +       spin_lock_irqsave(&chan->desc_lock, flags);
> +
> +       /* First try to clean up old descriptors */
> +       list_for_each_entry_safe(desc, _desc, &chan->pending_free, node) {
> +               if (async_tx_test_ack(&desc->async_tx)) {
> +                       list_del(&desc->node);
> +                       xlldma_free_descriptor(chan, desc);
> +               }
> +       }
> +
> +       /* Move all newly completed entries to the cleanup_list
> +        * so we can minimize time spent with the desc_lock held
> +        */
> +       list_for_each(entry, &chan->desc_queue) {
> +               if (xlldma_desc_status(chan, to_xlldma_desc(entry))
> +                   != DMA_IN_PROGRESS)
> +                       last_complete = entry;
> +       }
> +
> +       list_cut_position(&cleanup_list, &chan->desc_queue, last_complete);
> +       spin_unlock_irqrestore(&chan->desc_lock, flags);
> +
> +       list_for_each_entry_safe(desc, _desc, &cleanup_list, node) {
> +               dma_async_tx_callback callback;
> +               void *callback_param;
> +
> +               xlldma_unmap_desc(chan, desc);
> +
> +               /* Run the descriptor callback function */
> +               callback = desc->async_tx.callback;
> +               callback_param = desc->async_tx.callback_param;
> +               if (callback) {
> +                       dev_dbg(chan->xdev->dev, "descriptor %p callback\n",
> +                               desc);
> +                       callback(callback_param);
> +               }
> +
> +               dma_run_dependencies(&desc->async_tx);
> +
> +               if (async_tx_test_ack(&desc->async_tx))
> +                       xlldma_free_descriptor(chan, desc);
> +               else {
> +                       /* Defer free until client has ACKed */
> +                       spin_lock_irqsave(&chan->desc_lock, flags);
> +                       list_move_tail(&desc->node, &chan->pending_free);
> +                       spin_unlock_irqrestore(&chan->desc_lock, flags);
> +               }
> +       }
> +}
> +
> +/**
> + * xlldma_desc_xfer_to_hw - Release descriptors to SDMA HW for processing.
> + * @chan : DMA channel
> + */
> +static void xlldma_desc_xfer_to_hw(struct xlldma_chan *chan)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&chan->desc_lock, flags);
> +
> +       if (chan->common.cookie != chan->stop_after_cookie) {
> +               BUG_ON(list_empty(&chan->desc_queue));
> +               dma_set_tail(chan, to_xlldma_desc(chan->desc_queue.prev));
> +       }
> +
> +       spin_unlock_irqrestore(&chan->desc_lock, flags);
> +}
> +
> +/**
> + * xlldma_memcpy_issue_pending - Issue the DMA start command
> + * @dchan : DMA channel
> + */
> +static void xlldma_memcpy_issue_pending(struct dma_chan *dchan)
> +{
> +       struct xlldma_chan *chan = to_xlldma_chan(dchan);
> +       xlldma_desc_xfer_to_hw(chan);
> +}
> +
> +/**
> + * xlldma_is_complete - Determine the DMA status
> + * @dchan : DMA channel
> + * @cookie: transaction identifier to check status of
> + * @done: returns last completed cookie, can be NULL
> + * @used: returns last issued cookie, can be NULL
> + */
> +static enum dma_status xlldma_is_complete(struct dma_chan *dchan,
> +                                         dma_cookie_t cookie,
> +                                         dma_cookie_t *done,
> +                                         dma_cookie_t *used)
> +{
> +       struct xlldma_chan *chan = to_xlldma_chan(dchan);
> +       dma_cookie_t last_used;
> +       dma_cookie_t last_complete;
> +
> +       xlldma_chan_desc_cleanup(chan);
> +
> +       last_used     = dchan->cookie;
> +       last_complete = chan->completed_cookie;
> +
> +       if (done)
> +               *done = last_complete;
> +
> +       if (used)
> +               *used = last_used;
> +
> +       return dma_async_is_complete(cookie, last_complete, last_used);
> +}
> +
> +/*--------------------------------------------------------------------------
> + * Interrupt Handling
> + */
> +
> +irqreturn_t xlldma_chan_rx_interrupt(int irq, void *data)
> +{
> +       struct xlldma_chan *chan = (struct xlldma_chan *)data;
> +       u32 irq_causes;
> +       u32 error_causes = 0;
> +
> +       irq_causes = xlldma_in32(chan, RX_IRQ_REG);
> +
> +       /* Clear the events */
> +       xlldma_out32(chan, RX_IRQ_REG, irq_causes);
> +
> +       irq_causes &= ~(IRQ_COAL | IRQ_ERR);
> +       if (!irq_causes)
> +               return IRQ_NONE;
> +
> +       /* DMA Error */
> +       if (irq_causes & IRQ_ERR) {
> +               error_causes = xlldma_in32(chan, RX_CHNL_STS);
> +               error_causes &=  (CHNL_STS_BSYWR     | CHNL_STS_CURPERR
> +                                 | CHNL_STS_NXTPERR | CHNL_STS_ADDRERR
> +                                 | CHNL_STS_CMPERR  | CHNL_STS_TAILERR);
> +               dev_emerg(chan->xdev->dev,
> +                         "Channel %d RX DMA Error, causes = 0x%X\n",
> +                         chan->id, error_causes);
> +               xlldma_log_dma_chain(chan);
> +
> +               dma_abort(chan);
> +               panic("DMA Error!\n");
> +       }
> +
> +       dev_dbg(chan->xdev->dev, "RX irq: DMA EOP\n");
> +       xlldma_update_completed_cookie(chan);
> +       xlldma_desc_xfer_to_hw(chan);
> +
> +       dev_dbg(chan->xdev->dev, "RX irq: Exit\n");
> +       tasklet_schedule(&chan->tasklet);
> +       return IRQ_HANDLED;
> +}
> +EXPORT_SYMBOL(xlldma_chan_rx_interrupt);
> +
> +irqreturn_t xlldma_chan_tx_interrupt(int irq, void *data)
> +{
> +       struct xlldma_chan *chan = (struct xlldma_chan *)data;
> +       struct xlldma_bd *bd;
> +       u32 irq_causes, error_causes;
> +       u32 desc_phys;
> +
> +       irq_causes = xlldma_in32(chan, TX_IRQ_REG);
> +       dev_dbg(chan->xdev->dev, "TX irq: channel %d, causes = 0x%X\n",
> +               chan->id, irq_causes);
> +       /* Clear the events */
> +       xlldma_out32(chan, TX_IRQ_REG, irq_causes);
> +
> +       if (!(irq_causes & IRQ_ERR))
> +               return IRQ_NONE;
> +
> +       /* DMA Error */
> +       error_causes = xlldma_in32(chan, TX_CHNL_STS);
> +       error_causes &=  (CHNL_STS_BSYWR     | CHNL_STS_CURPERR
> +                         | CHNL_STS_NXTPERR | CHNL_STS_ADDRERR
> +                         | CHNL_STS_CMPERR  | CHNL_STS_TAILERR);
> +
> +       if (!(error_causes & CHNL_STS_ADDRERR)) {
> +               dev_emerg(chan->xdev->dev,
> +                         "Channel %d TX DMA Error, causes = 0x%X\n",
> +                         chan->id, error_causes);
> +               xlldma_log_dma_chain(chan);
> +
> +               dma_abort(chan);
> +               panic("DMA Error!\n");
> +       }
> +
> +       /* DMA_INTERRUPT request complete */
> +       /* This is the only 'expected' DMA error */
> +       dev_dbg(chan->xdev->dev, "irq: DMA_INTERRUPT\n");
> +
> +       /* Set the complete flag by hand since the HW won't do it,
> +        * and we need it to update the completed cookie
> +        */
> +       desc_phys =   xlldma_in32(chan, TX_CURDESC_PTR)
> +                   - offsetof(struct xlldma_bd, src);
> +
> +       bd = (struct xlldma_bd *) bus_to_virt(desc_phys);
> +       bd->dst.app0 = STS_CTRL_APP0_CMPLT;
> +
> +       dma_abort(chan);
> +       xlldma_update_completed_cookie(chan);
> +       xlldma_set_start(chan);
> +       xlldma_desc_xfer_to_hw(chan);
> +
> +       dev_dbg(chan->xdev->dev, "TX irq: Exit\n");
> +       tasklet_schedule(&chan->tasklet);
> +       return IRQ_HANDLED;
> +}
> +EXPORT_SYMBOL(xlldma_chan_tx_interrupt);
> +
> +void xlldma_cleanup_tasklet(unsigned long data)
> +{
> +       struct xlldma_chan *chan = (struct xlldma_chan *)data;
> +       xlldma_chan_desc_cleanup(chan);
> +}
> +EXPORT_SYMBOL(xlldma_cleanup_tasklet);
> +
> +/* ---------------------------------------------------------------------
> + * Initialization / Termination / Enumeration
> + */
> +
> +void xlldma_chan_remove(struct xlldma_chan *xchan)
> +{
> +       if (xchan->tx_irq != NO_IRQ)
> +               free_irq(xchan->tx_irq, xchan);
> +       if (xchan->rx_irq != NO_IRQ)
> +               free_irq(xchan->rx_irq, xchan);
> +       list_del(&xchan->common.device_node);
> +#ifdef CONFIG_PPC_DCR_NATIVE
> +       dcr_unmap(xchan->reg_dcrs, xchan->dcr_c);
> +#else
> +       iounmap(xchan->reg_base);
> +#endif
> +       kfree(xchan);
> +}
> +EXPORT_SYMBOL(xlldma_chan_remove);
> +
> +/*---------------------------------------------------------------------------
> + * sysfs interface
> + */
> +
> +#ifdef DEBUG
> +/**
> + * Print the DMA chain in response to a userland request
> + * @dev   :  Device being accessed
> + * @buf   :  Data being written from userspace
> + *          The first character controls which channel is printed
> + *          ('0' - '7')
> + * @count :  Number of bytes of data being written
> + *
> + * @return  count   (accept all data)
> + */
> +static ssize_t do_xlldma_log_dma_chain(struct device *dev,
> +                               struct device_attribute *attr,
> +                               const char *buf, size_t count)
> +{
> +       struct xlldma_device *xdev = dev_get_drvdata(dev);
> +
> +       if (count && (*buf >= '0')) {
> +               int idx = *buf - '0';
> +               if ((idx < XLLDMA_MAX_CHANS_PER_DEVICE) && xdev->chan[idx])
> +                       xlldma_log_dma_chain(xdev->chan[idx]);
> +               else
> +                       dev_info(xdev->dev, "Channel %c not active\n", *buf);
> +       }
> +
> +       return count;
> +}
> +
> +static struct device_attribute xlldma_attrs[] = {
> +       __ATTR(log_dma_chain, S_IWUSR, NULL, do_xlldma_log_dma_chain),
> +       __ATTR_NULL
> +};
> +#endif

This should probably be using debugfs instead.

> +
> +/*----------------------------------------------------------------------------
> + * Generic probe/remove
> + */
> +
> +/**
> + * xlldma_device_setup: Complete initialization and registration of a xlldma
> + *                     device. Assumes bus-specific code has enumerated
> + *                     the channels for the device.
> + * @dev   :  Device being initialized
> + */
> +int xlldma_device_setup(struct device *dev)
> +{
> +       struct xlldma_device *xdev = dev_get_drvdata(dev);
> +       int i, rc;
> +
> +       dma_cap_set(DMA_MEMCPY,    xdev->common.cap_mask);
> +       xdev->common.device_alloc_chan_resources = xlldma_alloc_chan_resources;
> +       xdev->common.device_free_chan_resources  = xlldma_free_chan_resources;
> +       xdev->common.device_prep_dma_interrupt   = xlldma_prep_interrupt;
> +       xdev->common.device_prep_dma_memcpy      = xlldma_prep_memcpy;
> +       xdev->common.device_is_tx_complete       = xlldma_is_complete;
> +       xdev->common.device_issue_pending        = xlldma_memcpy_issue_pending;
> +       xdev->common.device_terminate_all        = xlldma_device_terminate_all;
> +
> +       for (i = 0; i < XLLDMA_MAX_CHANS_PER_DEVICE; i++) {
> +               if (xdev->chan[i] && (xdev->chan[i]->tx_irq != NO_IRQ)) {
> +                       dma_cap_set(DMA_INTERRUPT, xdev->common.cap_mask);
> +                       break;
> +               }
> +       }
> +
> +       xdev->desc_cache = KMEM_CACHE(xlldma_desc, 0);
> +       if (!xdev->desc_cache) {
> +               printk(KERN_INFO "Could not allocate descriptor cache.\n");
> +               rc = -ENOMEM;
> +               goto fail;
> +       }
> +
> +       for (i = 0; i < XLLDMA_MAX_CHANS_PER_DEVICE; i++) {
> +               if (xdev->chan[i])
> +                       dma_init(xdev->chan[i]);        /* HW initialization */
> +       }
> +
> +       rc = dma_async_device_register(&xdev->common);
> +       if (rc)
> +               goto fail;
> +
> +#ifdef DEBUG
> +       for (i = 0; attr_name(xlldma_attrs[i]); i++) {
> +               rc = device_create_file(xdev->dev, &xlldma_attrs[i]);
> +               if (rc)
> +                       goto fail;
> +       }
> +#endif

Ugly #ifdefs.  Put the debug setup code into a separate function that
becomes an empty static inline when configured out, and takes care of
its own cleanup when it fails.

> +       return 0;
> +
> +fail:
> +#ifdef DEBUG
> +       for (i = 0; attr_name(xlldma_attrs[i]); i++)
> +               device_remove_file(xdev->dev, &xlldma_attrs[i]);
> +#endif
> +       if (xdev->desc_cache)
> +               kmem_cache_destroy(xdev->desc_cache);
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL(xlldma_device_setup);

Most of these symbols really shouldn't be exported.  They are driver
internal.  You should build all the .c files into a single .ko to
avoid the need of exporting.  (although and I mentioned earlier, the
bus binding code really should just be merged into this file).

Also, your irq request code probably belongs in xlldma_device_setup()
instead of the bus binding code.

> +
> +int xlldma_device_teardown(struct device *dev)
> +{
> +       struct xlldma_device *xdev = dev_get_drvdata(dev);
> +       unsigned int i;
> +
> +#ifdef DEBUG
> +       for (i = 0; attr_name(xlldma_attrs[i]); i++)
> +               device_remove_file(xdev->dev, &xlldma_attrs[i]);
> +#endif

ditto.

> +       kmem_cache_destroy(xdev->desc_cache);
> +       dma_async_device_unregister(&xdev->common);
> +
> +       for (i = 0; i < XLLDMA_MAX_CHANS_PER_DEVICE; i++)
> +               if (xdev->chan[i])
> +                       xlldma_chan_remove(xdev->chan[i]);
> +
> +       dev_set_drvdata(dev, NULL);
> +       kfree(xdev);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(xlldma_device_teardown);
> +
> +MODULE_AUTHOR("Digital Design Corporation");
> +MODULE_DESCRIPTION("Xilinx LocalLink DMA driver");
> +MODULE_LICENSE("GPL");

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
