Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1FPNxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:53:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:25211 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1FPNxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:53:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,375,1304319600"; 
   d="scan'208";a="14289687"
Date: Thu, 16 Jun 2011 22:00:03 +0800
From: Feng Tang <feng.tang@intel.com>
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        <alan@linux.intel.com>, <alek.du@intel.com>
Subject: Re: [PATCH 3/5] dw_spi: rework message processing
Message-ID: <20110616220003.7ac89d56@feng-i7>
In-Reply-To: <1308158588-17249-4-git-send-email-dirk.brandewie@gmail.com>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
	<1308158588-17249-4-git-send-email-dirk.brandewie@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

On Thu, 16 Jun 2011 01:23:06 +0800
"dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com> wrote:

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> NOTE: patch created git format-patch --break-rewrites=/50%
> 
> This patch reworks the message pump worker thread function to run
> until all messages queued to the driver have been handled. The
> function to handle individual spi_transfers is now a synchronus
> function the tasklet to handle spi_transfers has been removed. Work
> for the worker thread is only queued in host controller transfer
> function.
> 
> Psuedo code for new thread function:
>   message = get_message()
>   while (message){
>     for_each_transfer_in_msg(message){
>       transfer_setup(transfer)
>       do_transfer()
>     }
>     complete_message()
>     message = get_message()
>   }
> 
> Changes that fell out of the message thread changes:
> Non-DMA transfers that are larger than the size of the controller FIFO
> are handled as interrupt driven transfers.
> 
> Common FIFO handling functions shared PIO and interrupt transfers.
> 
> Simplified queue stop/start funcitons.
> 
> Cleanup fixes:
> Changed exported all exported function names to have dw_spi_ prefix
> 
> Removed support for registering chip select control function. Setting
> the slave chip select is handled by setting the SER (Slave enable
> register)
> 
> Removed code that looked at the cs_change hint in the
> spi_transfer. Software has no contorl over whether the slave chip
> select is de-asserted at the end of the transfer.  Once the TX FIFO
> goes empty the slave chip select is dropped.
> 
> Added dw_spi_{en,dis}able inline functions to replace
> spi_enable_chip() Added dw_spi_{mask,umask}_intr inline functions


IMHO, the patch is too big, it contains too many changes to the original
drivers, and we can't see clearly what you've changed to each logical
code part or section, If possible, could you separate this patch to
several small ones in a logical way.

First, I have some questions, what devices have you tested with this patch?
high speed, low speed? Do you have any performance data to show the benefit
of this change? Current dw_spi driver has been tested with many devices, so
to not break them or cause obvious regression, we have to be cautious.

Here are some general comments according to the commit logs:
1. I think the threaded irq handling is a good idea. And let driver chose to
   use poll or interrupt is good, some other spi controller driver has used
   that way for a long time
2. Why you remove the cs_change code, in some case, the controller is only
   be used by one device, we don't need do the config for every single
   spi_transfer
3. Why do you remove the chip select control code, dw_spi controller hw has
   some problem in chip select controller by SER, and thus many devices has
   to use external GPIO has their chip select, this is real world usages!
4. I saw you enable both TX/RX interrupt when doing interrupt transfer, spi
   devices' TX/RX are born to be simutaneous, when one word is sent over
   TX line, a RX word will be received from RX line, so both the orignal
   interrupt transfer handling written by me and the later optimization
   from Alek Du only enable TX interrupt, which will only generate half of
   IRQs comparing to enble both TX/RX, this is huge when the data rate is
   several Mb per second
5. Why do you change the logic of filling TX FIFO, the logic comes from use
   case that the dw_spi driver is dealing with several high speed devices.

Thanks,
Feng




> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/spi/spi-dw-mid.c |   43 +-
>  drivers/spi/spi-dw.c     | 1670
> ++++++++++++++++++++--------------------------
> drivers/spi/spi-dw.h     |   92 ++-- 3 files changed, 809
> insertions(+), 996 deletions(-) rewrite drivers/spi/spi-dw.c (55%)
> 
> diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
> index 130e555..e44e37f 100644
> --- a/drivers/spi/spi-dw-mid.c
> +++ b/drivers/spi/spi-dw-mid.c
> @@ -38,7 +38,10 @@ static bool mid_spi_dma_chan_filter(struct
> dma_chan *chan, void *param) {
>         struct dw_spi *dws = param;
> 
> -       return dws->dmac && (&dws->dmac->dev == chan->device->dev);
> +       if (dws->dmac && &dws->dmac->dev == chan->device->dev)
> +               return true;
> +       else
> +               return false;
>  }
> 
>  static int mid_spi_dma_init(struct dw_spi *dws)
> @@ -103,10 +106,10 @@ static void dw_spi_dma_done(void *arg)
> 
>         if (++dws->dma_chan_done != 2)
>                 return;
> -       dw_spi_xfer_done(dws);
> +       complete(&dws->xfer.complete);
>  }
> 
> -static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
> +static int mid_spi_dma_transfer(struct dw_spi *dws)
>  {
>         struct dma_async_tx_descriptor *txdesc = NULL, *rxdesc = NULL;
>         struct dma_chan *txchan, *rxchan;
> @@ -114,17 +117,17 @@ static int mid_spi_dma_transfer(struct dw_spi
> *dws, int cs_change) u16 dma_ctrl = 0;
> 
>         /* 1. setup DMA related registers */
> -       if (cs_change) {
> -               spi_enable_chip(dws, 0);
> -               dw_writew(dws, dmardlr, 0xf);
> -               dw_writew(dws, dmatdlr, 0x10);
> -               if (dws->tx_dma)
> -                       dma_ctrl |= 0x2;
> -               if (dws->rx_dma)
> -                       dma_ctrl |= 0x1;
> -               dw_writew(dws, dmacr, dma_ctrl);
> -               spi_enable_chip(dws, 1);
> -       }
> +
> +       dw_spi_disable(dws);
> +       dw_writew(dws, dmardlr, 0xf);
> +       dw_writew(dws, dmatdlr, 0x10);
> +       if (dws->xfer.tx_dma)
> +               dma_ctrl |= 0x2;
> +       if (dws->xfer.rx_dma)
> +               dma_ctrl |= 0x1;
> +       dw_writew(dws, dmacr, dma_ctrl);
> +       dw_spi_enable(dws);
> +
> 
>         dws->dma_chan_done = 0;
>         txchan = dws->txchan;
> @@ -141,8 +144,8 @@ static int mid_spi_dma_transfer(struct dw_spi
> *dws, int cs_change) (unsigned long) &txconf);
> 
>         memset(&dws->tx_sgl, 0, sizeof(dws->tx_sgl));
> -       dws->tx_sgl.dma_address = dws->tx_dma;
> -       dws->tx_sgl.length = dws->len;
> +       dws->tx_sgl.dma_address = dws->xfer.tx_dma;
> +       dws->tx_sgl.length = dws->xfer.len;
> 
>         txdesc = txchan->device->device_prep_slave_sg(txchan,
>                                 &dws->tx_sgl,
> @@ -163,8 +166,8 @@ static int mid_spi_dma_transfer(struct dw_spi
> *dws, int cs_change) (unsigned long) &rxconf);
> 
>         memset(&dws->rx_sgl, 0, sizeof(dws->rx_sgl));
> -       dws->rx_sgl.dma_address = dws->rx_dma;
> -       dws->rx_sgl.length = dws->len;
> +       dws->rx_sgl.dma_address = dws->xfer.rx_dma;
> +       dws->rx_sgl.length = dws->xfer.len;
> 
>         rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
>                                 &dws->rx_sgl,
> @@ -188,7 +191,6 @@ static struct dw_spi_dma_ops mid_dma_ops = {
>  #endif
> 
>  /* Some specific info for SPI0 controller on Moorestown */
> -
>  /* HW info for MRST CLk Control Unit, one 32b reg */
>  #define MRST_SPI_CLK_BASE      100000000       /* 100m */
>  #define MRST_CLK_SPI0_REG      0xff11d86c
> @@ -202,12 +204,13 @@ int dw_spi_mid_init(struct dw_spi *dws)
>  {
>         u32 *clk_reg, clk_cdiv;
> 
> +
>         clk_reg = ioremap_nocache(MRST_CLK_SPI0_REG, 16);
>         if (!clk_reg)
>                 return -ENOMEM;
> 
>         /* get SPI controller operating freq info */
> -       clk_cdiv  = (readl(clk_reg) & CLK_SPI_CDIV_MASK) >>
> CLK_SPI_CDIV_OFFSET;
> +       clk_cdiv  = ((*clk_reg) & CLK_SPI_CDIV_MASK) >>
> CLK_SPI_CDIV_OFFSET; dws->max_freq = MRST_SPI_CLK_BASE / (clk_cdiv +
> 1); iounmap(clk_reg);
> 
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> dissimilarity index 55%
> index ece5f69..2dacb8f 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -1,936 +1,734 @@
> -/*
> - * Designware SPI core controller driver (refer pxa2xx_spi.c)
> - *
> - * Copyright (c) 2009, Intel Corporation.
> - *
> - * This program is free software; you can redistribute it and/or
> modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but
> WITHOUT
> - * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License
> along with
> - * this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> - */
> -
> -#include <linux/dma-mapping.h>
> -#include <linux/interrupt.h>
> -#include <linux/highmem.h>
> -#include <linux/delay.h>
> -#include <linux/slab.h>
> -#include <linux/spi/spi.h>
> -
> -#include "spi-dw.h"
> -
> -#ifdef CONFIG_DEBUG_FS
> -#include <linux/debugfs.h>
> -#endif
> -
> -#define START_STATE    ((void *)0)
> -#define RUNNING_STATE  ((void *)1)
> -#define DONE_STATE     ((void *)2)
> -#define ERROR_STATE    ((void *)-1)
> -
> -#define QUEUE_RUNNING  0
> -#define QUEUE_STOPPED  1
> -
> -#define MRST_SPI_DEASSERT      0
> -#define MRST_SPI_ASSERT                1
> -
> -/* Slave spi_dev related */
> -struct chip_data {
> -       u16 cr0;
> -       u8 cs;                  /* chip select pin */
> -       u8 n_bytes;             /* current is a 1/2/4 byte op */
> -       u8 tmode;               /* TR/TO/RO/EEPROM */
> -       u8 type;                /* SPI/SSP/MicroWire */
> -
> -       u8 poll_mode;           /* 1 means use poll mode */
> -
> -       u32 dma_width;
> -       u32 rx_threshold;
> -       u32 tx_threshold;
> -       u8 enable_dma;
> -       u8 bits_per_word;
> -       u16 clk_div;            /* baud rate divider */
> -       u32 speed_hz;           /* baud rate */
> -       void (*cs_control)(u32 command);
> -};
> -
> -#ifdef CONFIG_DEBUG_FS
> -static int spi_show_regs_open(struct inode *inode, struct file *file)
> -{
> -       file->private_data = inode->i_private;
> -       return 0;
> -}
> -
> -#define SPI_REGS_BUFSIZE       1024
> -static ssize_t  spi_show_regs(struct file *file, char __user
> *user_buf,
> -                               size_t count, loff_t *ppos)
> -{
> -       struct dw_spi *dws;
> -       char *buf;
> -       u32 len = 0;
> -       ssize_t ret;
> -
> -       dws = file->private_data;
> -
> -       buf = kzalloc(SPI_REGS_BUFSIZE, GFP_KERNEL);
> -       if (!buf)
> -               return 0;
> -
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "MRST SPI0 registers:\n");
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "=================================\n");
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "CTRL0: \t\t0x%08x\n", dw_readl(dws, ctrl0));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "CTRL1: \t\t0x%08x\n", dw_readl(dws, ctrl1));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "SSIENR: \t0x%08x\n", dw_readl(dws, ssienr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "SER: \t\t0x%08x\n", dw_readl(dws, ser));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "BAUDR: \t\t0x%08x\n", dw_readl(dws, baudr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "TXFTLR: \t0x%08x\n", dw_readl(dws, txfltr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "RXFTLR: \t0x%08x\n", dw_readl(dws, rxfltr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "TXFLR: \t\t0x%08x\n", dw_readl(dws, txflr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "RXFLR: \t\t0x%08x\n", dw_readl(dws, rxflr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "SR: \t\t0x%08x\n", dw_readl(dws, sr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "IMR: \t\t0x%08x\n", dw_readl(dws, imr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "ISR: \t\t0x%08x\n", dw_readl(dws, isr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "DMACR: \t\t0x%08x\n", dw_readl(dws, dmacr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "DMATDLR: \t0x%08x\n", dw_readl(dws,
> dmatdlr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "DMARDLR: \t0x%08x\n", dw_readl(dws,
> dmardlr));
> -       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> -                       "=================================\n");
> -
> -       ret =  simple_read_from_buffer(user_buf, count, ppos, buf,
> len);
> -       kfree(buf);
> -       return ret;
> -}
> -
> -static const struct file_operations mrst_spi_regs_ops = {
> -       .owner          = THIS_MODULE,
> -       .open           = spi_show_regs_open,
> -       .read           = spi_show_regs,
> -       .llseek         = default_llseek,
> -};
> -
> -static int mrst_spi_debugfs_init(struct dw_spi *dws)
> -{
> -       dws->debugfs = debugfs_create_dir("mrst_spi", NULL);
> -       if (!dws->debugfs)
> -               return -ENOMEM;
> -
> -       debugfs_create_file("registers", S_IFREG | S_IRUGO,
> -               dws->debugfs, (void *)dws, &mrst_spi_regs_ops);
> -       return 0;
> -}
> -
> -static void mrst_spi_debugfs_remove(struct dw_spi *dws)
> -{
> -       if (dws->debugfs)
> -               debugfs_remove_recursive(dws->debugfs);
> -}
> -
> -#else
> -static inline int mrst_spi_debugfs_init(struct dw_spi *dws)
> -{
> -       return 0;
> -}
> -
> -static inline void mrst_spi_debugfs_remove(struct dw_spi *dws)
> -{
> -}
> -#endif /* CONFIG_DEBUG_FS */
> -
> -/* Return the max entries we can fill into tx fifo */
> -static inline u32 tx_max(struct dw_spi *dws)
> -{
> -       u32 tx_left, tx_room, rxtx_gap;
> -
> -       tx_left = (dws->tx_end - dws->tx) / dws->n_bytes;
> -       tx_room = dws->fifo_len - dw_readw(dws, txflr);
> -
> -       /*
> -        * Another concern is about the tx/rx mismatch, we
> -        * though to use (dws->fifo_len - rxflr - txflr) as
> -        * one maximum value for tx, but it doesn't cover the
> -        * data which is out of tx/rx fifo and inside the
> -        * shift registers. So a control from sw point of
> -        * view is taken.
> -        */
> -       rxtx_gap =  ((dws->rx_end - dws->rx) - (dws->tx_end -
> dws->tx))
> -                       / dws->n_bytes;
> -
> -       return min3(tx_left, tx_room, (u32) (dws->fifo_len -
> rxtx_gap)); -}
> -
> -/* Return the max entries we should read out of rx fifo */
> -static inline u32 rx_max(struct dw_spi *dws)
> -{
> -       u32 rx_left = (dws->rx_end - dws->rx) / dws->n_bytes;
> -
> -       return min(rx_left, (u32)dw_readw(dws, rxflr));
> -}
> -
> -static void dw_writer(struct dw_spi *dws)
> -{
> -       u32 max = tx_max(dws);
> -       u16 txw = 0;
> -
> -       while (max--) {
> -               /* Set the tx word if the transfer's original "tx" is
> not null */
> -               if (dws->tx_end - dws->len) {
> -                       if (dws->n_bytes == 1)
> -                               txw = *(u8 *)(dws->tx);
> -                       else
> -                               txw = *(u16 *)(dws->tx);
> -               }
> -               dw_writew(dws, dr, txw);
> -               dws->tx += dws->n_bytes;
> -       }
> -}
> -
> -static void dw_reader(struct dw_spi *dws)
> -{
> -       u32 max = rx_max(dws);
> -       u16 rxw;
> -
> -       while (max--) {
> -               rxw = dw_readw(dws, dr);
> -               /* Care rx only if the transfer's original "rx" is
> not null */
> -               if (dws->rx_end - dws->len) {
> -                       if (dws->n_bytes == 1)
> -                               *(u8 *)(dws->rx) = rxw;
> -                       else
> -                               *(u16 *)(dws->rx) = rxw;
> -               }
> -               dws->rx += dws->n_bytes;
> -       }
> -}
> -
> -static void *next_transfer(struct dw_spi *dws)
> -{
> -       struct spi_message *msg = dws->cur_msg;
> -       struct spi_transfer *trans = dws->cur_transfer;
> -
> -       /* Move to next transfer */
> -       if (trans->transfer_list.next != &msg->transfers) {
> -               dws->cur_transfer =
> -                       list_entry(trans->transfer_list.next,
> -                                       struct spi_transfer,
> -                                       transfer_list);
> -               return RUNNING_STATE;
> -       } else
> -               return DONE_STATE;
> -}
> -
> -/*
> - * Note: first step is the protocol driver prepares
> - * a dma-capable memory, and this func just need translate
> - * the virt addr to physical
> - */
> -static int map_dma_buffers(struct dw_spi *dws)
> -{
> -       if (!dws->cur_msg->is_dma_mapped
> -               || !dws->dma_inited
> -               || !dws->cur_chip->enable_dma
> -               || !dws->dma_ops)
> -               return 0;
> -
> -       if (dws->cur_transfer->tx_dma)
> -               dws->tx_dma = dws->cur_transfer->tx_dma;
> -
> -       if (dws->cur_transfer->rx_dma)
> -               dws->rx_dma = dws->cur_transfer->rx_dma;
> -
> -       return 1;
> -}
> -
> -/* Caller already set message->status; dma and pio irqs are blocked
> */ -static void giveback(struct dw_spi *dws)
> -{
> -       struct spi_transfer *last_transfer;
> -       unsigned long flags;
> -       struct spi_message *msg;
> -
> -       spin_lock_irqsave(&dws->lock, flags);
> -       msg = dws->cur_msg;
> -       dws->cur_msg = NULL;
> -       dws->cur_transfer = NULL;
> -       dws->prev_chip = dws->cur_chip;
> -       dws->cur_chip = NULL;
> -       dws->dma_mapped = 0;
> -       queue_work(dws->workqueue, &dws->pump_messages);
> -       spin_unlock_irqrestore(&dws->lock, flags);
> -
> -       last_transfer = list_entry(msg->transfers.prev,
> -                                       struct spi_transfer,
> -                                       transfer_list);
> -
> -       if (!last_transfer->cs_change && dws->cs_control)
> -               dws->cs_control(MRST_SPI_DEASSERT);
> -
> -       msg->state = NULL;
> -       if (msg->complete)
> -               msg->complete(msg->context);
> -}
> -
> -static void int_error_stop(struct dw_spi *dws, const char *msg)
> -{
> -       /* Stop the hw */
> -       spi_enable_chip(dws, 0);
> -
> -       dev_err(&dws->master->dev, "%s\n", msg);
> -       dws->cur_msg->state = ERROR_STATE;
> -       tasklet_schedule(&dws->pump_transfers);
> -}
> -
> -void dw_spi_xfer_done(struct dw_spi *dws)
> -{
> -       /* Update total byte transferred return count actual bytes
> read */
> -       dws->cur_msg->actual_length += dws->len;
> -
> -       /* Move to next transfer */
> -       dws->cur_msg->state = next_transfer(dws);
> -
> -       /* Handle end of message */
> -       if (dws->cur_msg->state == DONE_STATE) {
> -               dws->cur_msg->status = 0;
> -               giveback(dws);
> -       } else
> -               tasklet_schedule(&dws->pump_transfers);
> -}
> -EXPORT_SYMBOL_GPL(dw_spi_xfer_done);
> -
> -static irqreturn_t interrupt_transfer(struct dw_spi *dws)
> -{
> -       u16 irq_status = dw_readw(dws, isr);
> -
> -       /* Error handling */
> -       if (irq_status & (SPI_INT_TXOI | SPI_INT_RXOI |
> SPI_INT_RXUI)) {
> -               dw_readw(dws, txoicr);
> -               dw_readw(dws, rxoicr);
> -               dw_readw(dws, rxuicr);
> -               int_error_stop(dws, "interrupt_transfer: fifo
> overrun/underrun");
> -               return IRQ_HANDLED;
> -       }
> -
> -       dw_reader(dws);
> -       if (dws->rx_end == dws->rx) {
> -               spi_mask_intr(dws, SPI_INT_TXEI);
> -               dw_spi_xfer_done(dws);
> -               return IRQ_HANDLED;
> -       }
> -       if (irq_status & SPI_INT_TXEI) {
> -               spi_mask_intr(dws, SPI_INT_TXEI);
> -               dw_writer(dws);
> -               /* Enable TX irq always, it will be disabled when RX
> finished */
> -               spi_umask_intr(dws, SPI_INT_TXEI);
> -       }
> -
> -       return IRQ_HANDLED;
> -}
> -
> -static irqreturn_t dw_spi_irq(int irq, void *dev_id)
> -{
> -       struct dw_spi *dws = dev_id;
> -       u16 irq_status = dw_readw(dws, isr) & 0x3f;
> -
> -       if (!irq_status)
> -               return IRQ_NONE;
> -
> -       if (!dws->cur_msg) {
> -               spi_mask_intr(dws, SPI_INT_TXEI);
> -               return IRQ_HANDLED;
> -       }
> -
> -       return dws->transfer_handler(dws);
> -}
> -
> -/* Must be called inside pump_transfers() */
> -static void poll_transfer(struct dw_spi *dws)
> -{
> -       do {
> -               dw_writer(dws);
> -               dw_reader(dws);
> -               cpu_relax();
> -       } while (dws->rx_end > dws->rx);
> -
> -       dw_spi_xfer_done(dws);
> -}
> -
> -static void pump_transfers(unsigned long data)
> -{
> -       struct dw_spi *dws = (struct dw_spi *)data;
> -       struct spi_message *message = NULL;
> -       struct spi_transfer *transfer = NULL;
> -       struct spi_transfer *previous = NULL;
> -       struct spi_device *spi = NULL;
> -       struct chip_data *chip = NULL;
> -       u8 bits = 0;
> -       u8 imask = 0;
> -       u8 cs_change = 0;
> -       u16 txint_level = 0;
> -       u16 clk_div = 0;
> -       u32 speed = 0;
> -       u32 cr0 = 0;
> -
> -       /* Get current state information */
> -       message = dws->cur_msg;
> -       transfer = dws->cur_transfer;
> -       chip = dws->cur_chip;
> -       spi = message->spi;
> -
> -       if (unlikely(!chip->clk_div))
> -               chip->clk_div = dws->max_freq / chip->speed_hz;
> -
> -       if (message->state == ERROR_STATE) {
> -               message->status = -EIO;
> -               goto early_exit;
> -       }
> -
> -       /* Handle end of message */
> -       if (message->state == DONE_STATE) {
> -               message->status = 0;
> -               goto early_exit;
> -       }
> -
> -       /* Delay if requested at end of transfer*/
> -       if (message->state == RUNNING_STATE) {
> -               previous = list_entry(transfer->transfer_list.prev,
> -                                       struct spi_transfer,
> -                                       transfer_list);
> -               if (previous->delay_usecs)
> -                       udelay(previous->delay_usecs);
> -       }
> -
> -       dws->n_bytes = chip->n_bytes;
> -       dws->dma_width = chip->dma_width;
> -       dws->cs_control = chip->cs_control;
> -
> -       dws->rx_dma = transfer->rx_dma;
> -       dws->tx_dma = transfer->tx_dma;
> -       dws->tx = (void *)transfer->tx_buf;
> -       dws->tx_end = dws->tx + transfer->len;
> -       dws->rx = transfer->rx_buf;
> -       dws->rx_end = dws->rx + transfer->len;
> -       dws->cs_change = transfer->cs_change;
> -       dws->len = dws->cur_transfer->len;
> -       if (chip != dws->prev_chip)
> -               cs_change = 1;
> -
> -       cr0 = chip->cr0;
> -
> -       /* Handle per transfer options for bpw and speed */
> -       if (transfer->speed_hz) {
> -               speed = chip->speed_hz;
> -
> -               if (transfer->speed_hz != speed) {
> -                       speed = transfer->speed_hz;
> -                       if (speed > dws->max_freq) {
> -                               printk(KERN_ERR "MRST SPI0:
> unsupported"
> -                                       "freq: %dHz\n", speed);
> -                               message->status = -EIO;
> -                               goto early_exit;
> -                       }
> -
> -                       /* clk_div doesn't support odd number */
> -                       clk_div = dws->max_freq / speed;
> -                       clk_div = (clk_div + 1) & 0xfffe;
> -
> -                       chip->speed_hz = speed;
> -                       chip->clk_div = clk_div;
> -               }
> -       }
> -       if (transfer->bits_per_word) {
> -               bits = transfer->bits_per_word;
> -
> -               switch (bits) {
> -               case 8:
> -               case 16:
> -                       dws->n_bytes = dws->dma_width = bits >> 3;
> -                       break;
> -               default:
> -                       printk(KERN_ERR "MRST SPI0: unsupported bits:"
> -                               "%db\n", bits);
> -                       message->status = -EIO;
> -                       goto early_exit;
> -               }
> -
> -               cr0 = (bits - 1)
> -                       | (chip->type << SPI_FRF_OFFSET)
> -                       | (spi->mode << SPI_MODE_OFFSET)
> -                       | (chip->tmode << SPI_TMOD_OFFSET);
> -       }
> -       message->state = RUNNING_STATE;
> -
> -       /*
> -        * Adjust transfer mode if necessary. Requires platform
> dependent
> -        * chipselect mechanism.
> -        */
> -       if (dws->cs_control) {
> -               if (dws->rx && dws->tx)
> -                       chip->tmode = SPI_TMOD_TR;
> -               else if (dws->rx)
> -                       chip->tmode = SPI_TMOD_RO;
> -               else
> -                       chip->tmode = SPI_TMOD_TO;
> -
> -               cr0 &= ~SPI_TMOD_MASK;
> -               cr0 |= (chip->tmode << SPI_TMOD_OFFSET);
> -       }
> -
> -       /* Check if current transfer is a DMA transaction */
> -       dws->dma_mapped = map_dma_buffers(dws);
> -
> -       /*
> -        * Interrupt mode
> -        * we only need set the TXEI IRQ, as TX/RX always happen
> syncronizely
> -        */
> -       if (!dws->dma_mapped && !chip->poll_mode) {
> -               int templen = dws->len / dws->n_bytes;
> -               txint_level = dws->fifo_len / 2;
> -               txint_level = (templen > txint_level) ? txint_level :
> templen; -
> -               imask |= SPI_INT_TXEI | SPI_INT_TXOI | SPI_INT_RXUI |
> SPI_INT_RXOI;
> -               dws->transfer_handler = interrupt_transfer;
> -       }
> -
> -       /*
> -        * Reprogram registers only if
> -        *      1. chip select changes
> -        *      2. clk_div is changed
> -        *      3. control value changes
> -        */
> -       if (dw_readw(dws, ctrl0) != cr0 || cs_change || clk_div ||
> imask) {
> -               spi_enable_chip(dws, 0);
> -
> -               if (dw_readw(dws, ctrl0) != cr0)
> -                       dw_writew(dws, ctrl0, cr0);
> -
> -               spi_set_clk(dws, clk_div ? clk_div : chip->clk_div);
> -               spi_chip_sel(dws, spi->chip_select);
> -
> -               /* Set the interrupt mask, for poll mode just disable
> all int */
> -               spi_mask_intr(dws, 0xff);
> -               if (imask)
> -                       spi_umask_intr(dws, imask);
> -               if (txint_level)
> -                       dw_writew(dws, txfltr, txint_level);
> -
> -               spi_enable_chip(dws, 1);
> -               if (cs_change)
> -                       dws->prev_chip = chip;
> -       }
> -
> -       if (dws->dma_mapped)
> -               dws->dma_ops->dma_transfer(dws, cs_change);
> -
> -       if (chip->poll_mode)
> -               poll_transfer(dws);
> -
> -       return;
> -
> -early_exit:
> -       giveback(dws);
> -       return;
> -}
> -
> -static void pump_messages(struct work_struct *work)
> -{
> -       struct dw_spi *dws =
> -               container_of(work, struct dw_spi, pump_messages);
> -       unsigned long flags;
> -
> -       /* Lock queue and check for queue work */
> -       spin_lock_irqsave(&dws->lock, flags);
> -       if (list_empty(&dws->queue) || dws->run == QUEUE_STOPPED) {
> -               dws->busy = 0;
> -               spin_unlock_irqrestore(&dws->lock, flags);
> -               return;
> -       }
> -
> -       /* Make sure we are not already running a message */
> -       if (dws->cur_msg) {
> -               spin_unlock_irqrestore(&dws->lock, flags);
> -               return;
> -       }
> -
> -       /* Extract head of queue */
> -       dws->cur_msg = list_entry(dws->queue.next, struct
> spi_message, queue);
> -       list_del_init(&dws->cur_msg->queue);
> -
> -       /* Initial message state*/
> -       dws->cur_msg->state = START_STATE;
> -       dws->cur_transfer = list_entry(dws->cur_msg->transfers.next,
> -                                               struct spi_transfer,
> -                                               transfer_list);
> -       dws->cur_chip = spi_get_ctldata(dws->cur_msg->spi);
> -
> -       /* Mark as busy and launch transfers */
> -       tasklet_schedule(&dws->pump_transfers);
> -
> -       dws->busy = 1;
> -       spin_unlock_irqrestore(&dws->lock, flags);
> -}
> -
> -/* spi_device use this to queue in their spi_msg */
> -static int dw_spi_transfer(struct spi_device *spi, struct
> spi_message *msg) -{
> -       struct dw_spi *dws = spi_master_get_devdata(spi->master);
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&dws->lock, flags);
> -
> -       if (dws->run == QUEUE_STOPPED) {
> -               spin_unlock_irqrestore(&dws->lock, flags);
> -               return -ESHUTDOWN;
> -       }
> -
> -       msg->actual_length = 0;
> -       msg->status = -EINPROGRESS;
> -       msg->state = START_STATE;
> -
> -       list_add_tail(&msg->queue, &dws->queue);
> -
> -       if (dws->run == QUEUE_RUNNING && !dws->busy) {
> -
> -               if (dws->cur_transfer || dws->cur_msg)
> -                       queue_work(dws->workqueue,
> -                                       &dws->pump_messages);
> -               else {
> -                       /* If no other data transaction in air, just
> go */
> -                       spin_unlock_irqrestore(&dws->lock, flags);
> -                       pump_messages(&dws->pump_messages);
> -                       return 0;
> -               }
> -       }
> -
> -       spin_unlock_irqrestore(&dws->lock, flags);
> -       return 0;
> -}
> -
> -/* This may be called twice for each spi dev */
> -static int dw_spi_setup(struct spi_device *spi)
> -{
> -       struct dw_spi_chip *chip_info = NULL;
> -       struct chip_data *chip;
> -
> -       if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
> -               return -EINVAL;
> -
> -       /* Only alloc on first setup */
> -       chip = spi_get_ctldata(spi);
> -       if (!chip) {
> -               chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
> -               if (!chip)
> -                       return -ENOMEM;
> -       }
> -
> -       /*
> -        * Protocol drivers may change the chip settings, so...
> -        * if chip_info exists, use it
> -        */
> -       chip_info = spi->controller_data;
> -
> -       /* chip_info doesn't always exist */
> -       if (chip_info) {
> -               if (chip_info->cs_control)
> -                       chip->cs_control = chip_info->cs_control;
> -
> -               chip->poll_mode = chip_info->poll_mode;
> -               chip->type = chip_info->type;
> -
> -               chip->rx_threshold = 0;
> -               chip->tx_threshold = 0;
> -
> -               chip->enable_dma = chip_info->enable_dma;
> -       }
> -
> -       if (spi->bits_per_word <= 8) {
> -               chip->n_bytes = 1;
> -               chip->dma_width = 1;
> -       } else if (spi->bits_per_word <= 16) {
> -               chip->n_bytes = 2;
> -               chip->dma_width = 2;
> -       } else {
> -               /* Never take >16b case for MRST SPIC */
> -               dev_err(&spi->dev, "invalid wordsize\n");
> -               return -EINVAL;
> -       }
> -       chip->bits_per_word = spi->bits_per_word;
> -
> -       if (!spi->max_speed_hz) {
> -               dev_err(&spi->dev, "No max speed HZ parameter\n");
> -               return -EINVAL;
> -       }
> -       chip->speed_hz = spi->max_speed_hz;
> -
> -       chip->tmode = 0; /* Tx & Rx */
> -       /* Default SPI mode is SCPOL = 0, SCPH = 0 */
> -       chip->cr0 = (chip->bits_per_word - 1)
> -                       | (chip->type << SPI_FRF_OFFSET)
> -                       | (spi->mode  << SPI_MODE_OFFSET)
> -                       | (chip->tmode << SPI_TMOD_OFFSET);
> -
> -       spi_set_ctldata(spi, chip);
> -       return 0;
> -}
> -
> -static void dw_spi_cleanup(struct spi_device *spi)
> -{
> -       struct chip_data *chip = spi_get_ctldata(spi);
> -       kfree(chip);
> -}
> -
> -static int __devinit init_queue(struct dw_spi *dws)
> -{
> -       INIT_LIST_HEAD(&dws->queue);
> -       spin_lock_init(&dws->lock);
> -
> -       dws->run = QUEUE_STOPPED;
> -       dws->busy = 0;
> -
> -       tasklet_init(&dws->pump_transfers,
> -                       pump_transfers, (unsigned long)dws);
> -
> -       INIT_WORK(&dws->pump_messages, pump_messages);
> -       dws->workqueue = create_singlethread_workqueue(
> -
> dev_name(dws->master->dev.parent));
> -       if (dws->workqueue == NULL)
> -               return -EBUSY;
> -
> -       return 0;
> -}
> -
> -static int start_queue(struct dw_spi *dws)
> -{
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&dws->lock, flags);
> -
> -       if (dws->run == QUEUE_RUNNING || dws->busy) {
> -               spin_unlock_irqrestore(&dws->lock, flags);
> -               return -EBUSY;
> -       }
> -
> -       dws->run = QUEUE_RUNNING;
> -       dws->cur_msg = NULL;
> -       dws->cur_transfer = NULL;
> -       dws->cur_chip = NULL;
> -       dws->prev_chip = NULL;
> -       spin_unlock_irqrestore(&dws->lock, flags);
> -
> -       queue_work(dws->workqueue, &dws->pump_messages);
> -
> -       return 0;
> -}
> -
> -static int stop_queue(struct dw_spi *dws)
> -{
> -       unsigned long flags;
> -       unsigned limit = 50;
> -       int status = 0;
> -
> -       spin_lock_irqsave(&dws->lock, flags);
> -       dws->run = QUEUE_STOPPED;
> -       while ((!list_empty(&dws->queue) || dws->busy) && limit--) {
> -               spin_unlock_irqrestore(&dws->lock, flags);
> -               msleep(10);
> -               spin_lock_irqsave(&dws->lock, flags);
> -       }
> -
> -       if (!list_empty(&dws->queue) || dws->busy)
> -               status = -EBUSY;
> -       spin_unlock_irqrestore(&dws->lock, flags);
> -
> -       return status;
> -}
> -
> -static int destroy_queue(struct dw_spi *dws)
> -{
> -       int status;
> -
> -       status = stop_queue(dws);
> -       if (status != 0)
> -               return status;
> -       destroy_workqueue(dws->workqueue);
> -       return 0;
> -}
> -
> -/* Restart the controller, disable all interrupts, clean rx fifo */
> -static void spi_hw_init(struct dw_spi *dws)
> -{
> -       spi_enable_chip(dws, 0);
> -       spi_mask_intr(dws, 0xff);
> -       spi_enable_chip(dws, 1);
> -
> -       /*
> -        * Try to detect the FIFO depth if not set by interface
> driver,
> -        * the depth could be from 2 to 256 from HW spec
> -        */
> -       if (!dws->fifo_len) {
> -               u32 fifo;
> -               for (fifo = 2; fifo <= 257; fifo++) {
> -                       dw_writew(dws, txfltr, fifo);
> -                       if (fifo != dw_readw(dws, txfltr))
> -                               break;
> -               }
> -
> -               dws->fifo_len = (fifo == 257) ? 0 : fifo;
> -               dw_writew(dws, txfltr, 0);
> -       }
> -}
> -
> -int __devinit dw_spi_add_host(struct dw_spi *dws)
> -{
> -       struct spi_master *master;
> -       int ret;
> -
> -       BUG_ON(dws == NULL);
> -
> -       master = spi_alloc_master(dws->parent_dev, 0);
> -       if (!master) {
> -               ret = -ENOMEM;
> -               goto exit;
> -       }
> -
> -       dws->master = master;
> -       dws->type = SSI_MOTO_SPI;
> -       dws->prev_chip = NULL;
> -       dws->dma_inited = 0;
> -       dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
> -
> -       ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED,
> -                       "dw_spi", dws);
> -       if (ret < 0) {
> -               dev_err(&master->dev, "can not get IRQ\n");
> -               goto err_free_master;
> -       }
> -
> -       master->mode_bits = SPI_CPOL | SPI_CPHA;
> -       master->bus_num = dws->bus_num;
> -       master->num_chipselect = dws->num_cs;
> -       master->cleanup = dw_spi_cleanup;
> -       master->setup = dw_spi_setup;
> -       master->transfer = dw_spi_transfer;
> -
> -       /* Basic HW init */
> -       spi_hw_init(dws);
> -
> -       if (dws->dma_ops && dws->dma_ops->dma_init) {
> -               ret = dws->dma_ops->dma_init(dws);
> -               if (ret) {
> -                       dev_warn(&master->dev, "DMA init failed\n");
> -                       dws->dma_inited = 0;
> -               }
> -       }
> -
> -       /* Initial and start queue */
> -       ret = init_queue(dws);
> -       if (ret) {
> -               dev_err(&master->dev, "problem initializing queue\n");
> -               goto err_diable_hw;
> -       }
> -       ret = start_queue(dws);
> -       if (ret) {
> -               dev_err(&master->dev, "problem starting queue\n");
> -               goto err_diable_hw;
> -       }
> -
> -       spi_master_set_devdata(master, dws);
> -       ret = spi_register_master(master);
> -       if (ret) {
> -               dev_err(&master->dev, "problem registering spi
> master\n");
> -               goto err_queue_alloc;
> -       }
> -
> -       mrst_spi_debugfs_init(dws);
> -       return 0;
> -
> -err_queue_alloc:
> -       destroy_queue(dws);
> -       if (dws->dma_ops && dws->dma_ops->dma_exit)
> -               dws->dma_ops->dma_exit(dws);
> -err_diable_hw:
> -       spi_enable_chip(dws, 0);
> -       free_irq(dws->irq, dws);
> -err_free_master:
> -       spi_master_put(master);
> -exit:
> -       return ret;
> -}
> -EXPORT_SYMBOL_GPL(dw_spi_add_host);
> -
> -void __devexit dw_spi_remove_host(struct dw_spi *dws)
> -{
> -       int status = 0;
> -
> -       if (!dws)
> -               return;
> -       mrst_spi_debugfs_remove(dws);
> -
> -       /* Remove the queue */
> -       status = destroy_queue(dws);
> -       if (status != 0)
> -               dev_err(&dws->master->dev, "dw_spi_remove: workqueue
> will not "
> -                       "complete, message memory not freed\n");
> -
> -       if (dws->dma_ops && dws->dma_ops->dma_exit)
> -               dws->dma_ops->dma_exit(dws);
> -       spi_enable_chip(dws, 0);
> -       /* Disable clk */
> -       spi_set_clk(dws, 0);
> -       free_irq(dws->irq, dws);
> -
> -       /* Disconnect from the SPI framework */
> -       spi_unregister_master(dws->master);
> -}
> -EXPORT_SYMBOL_GPL(dw_spi_remove_host);
> -
> -int dw_spi_suspend_host(struct dw_spi *dws)
> -{
> -       int ret = 0;
> -
> -       ret = stop_queue(dws);
> -       if (ret)
> -               return ret;
> -       spi_enable_chip(dws, 0);
> -       spi_set_clk(dws, 0);
> -       return ret;
> -}
> -EXPORT_SYMBOL_GPL(dw_spi_suspend_host);
> -
> -int dw_spi_resume_host(struct dw_spi *dws)
> -{
> -       int ret;
> -
> -       spi_hw_init(dws);
> -       ret = start_queue(dws);
> -       if (ret)
> -               dev_err(&dws->master->dev, "fail to start queue
> (%d)\n", ret);
> -       return ret;
> -}
> -EXPORT_SYMBOL_GPL(dw_spi_resume_host);
> -
> -MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
> -MODULE_DESCRIPTION("Driver for DesignWare SPI controller core");
> -MODULE_LICENSE("GPL v2");
> +/*
> + * dw_spi.c - Designware SPI core controller driver
> + *
> + * Copyright (c) 2009, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but
> WITHOUT
> + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>
> +#include <linux/highmem.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/spi/spi.h>
> +
> +#include "spi-dw.h"
> +
> +#ifdef CONFIG_DEBUG_FS
> +#include <linux/debugfs.h>
> +#endif
> +
> +
> +#define QUEUE_RUNNING  0
> +#define QUEUE_STOPPED  1
> +
> +
> +/* Slave spi_dev related */
> +struct chip_data {
> +       struct spi_device *spi_dev;
> +       u32 cr0;
> +       u32 cs;                 /* chip select pin */
> +       u32 n_bytes;            /* current is a 1/2/4 byte op */
> +       u32 type;               /* SPI/SSP/MicroWire */
> +
> +       u32 dma_width;
> +       u32 enable_dma;
> +       u32 bits_per_word;
> +       u32 clk_div;            /* baud rate divider */
> +       u32 speed_hz;           /* baud rate */
> +};
> +
> +#ifdef CONFIG_DEBUG_FS
> +static int spi_show_regs_open(struct inode *inode, struct file *file)
> +{
> +       file->private_data = inode->i_private;
> +       return 0;
> +}
> +
> +#define SPI_REGS_BUFSIZE       1024
> +static ssize_t  spi_show_regs(struct file *file, char __user
> *user_buf,
> +                               size_t count, loff_t *ppos)
> +{
> +       struct dw_spi *dws;
> +       char *buf;
> +       u32 len = 0;
> +       ssize_t ret;
> +
> +       dws = file->private_data;
> +
> +       buf = kzalloc(SPI_REGS_BUFSIZE, GFP_KERNEL);
> +       if (!buf)
> +               return 0;
> +
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "MRST SPI0 registers:\n");
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "=================================\n");
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "CTRL0: \t\t0x%08x\n", dw_readl(dws, ctrl0));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "CTRL1: \t\t0x%08x\n", dw_readl(dws, ctrl1));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "SSIENR: \t0x%08x\n", dw_readl(dws, ssienr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "SER: \t\t0x%08x\n", dw_readl(dws, ser));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "BAUDR: \t\t0x%08x\n", dw_readl(dws, baudr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "TXFTLR: \t0x%08x\n", dw_readl(dws, txfltr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "RXFTLR: \t0x%08x\n", dw_readl(dws, rxfltr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "TXFLR: \t\t0x%08x\n", dw_readl(dws, txflr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "RXFLR: \t\t0x%08x\n", dw_readl(dws, rxflr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "SR: \t\t0x%08x\n", dw_readl(dws, sr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "IMR: \t\t0x%08x\n", dw_readl(dws, imr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "ISR: \t\t0x%08x\n", dw_readl(dws, isr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "DMACR: \t\t0x%08x\n", dw_readl(dws, dmacr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "DMATDLR: \t0x%08x\n", dw_readl(dws,
> dmatdlr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "DMARDLR: \t0x%08x\n", dw_readl(dws,
> dmardlr));
> +       len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
> +                       "=================================\n");
> +
> +       ret =  simple_read_from_buffer(user_buf, count, ppos, buf,
> len);
> +       kfree(buf);
> +       return ret;
> +}
> +
> +static const struct file_operations mrst_spi_regs_ops = {
> +       .owner          = THIS_MODULE,
> +       .open           = spi_show_regs_open,
> +       .read           = spi_show_regs,
> +       .llseek         = default_llseek,
> +};
> +
> +static int mrst_spi_debugfs_init(struct dw_spi *dws)
> +{
> +       dws->debugfs = debugfs_create_dir("mrst_spi", NULL);
> +       if (!dws->debugfs)
> +               return -ENOMEM;
> +
> +       debugfs_create_file("registers", S_IFREG | S_IRUGO,
> +               dws->debugfs, (void *)dws, &mrst_spi_regs_ops);
> +       return 0;
> +}
> +
> +static void mrst_spi_debugfs_remove(struct dw_spi *dws)
> +{
> +       if (dws->debugfs)
> +               debugfs_remove_recursive(dws->debugfs);
> +}
> +
> +#else
> +static inline int mrst_spi_debugfs_init(struct dw_spi *dws)
> +{
> +       return 0;
> +}
> +
> +static inline void mrst_spi_debugfs_remove(struct dw_spi *dws)
> +{
> +}
> +#endif /* CONFIG_DEBUG_FS */
> +
> +static irqreturn_t dw_spi_irq(int irq, void *dev_id)
> +{
> +       struct dw_spi *dws = dev_id;
> +       u16  irq_mask = 0x3f;
> +
> +       dws->xfer.irq_status = dw_readw(dws, isr) & irq_mask;
> +
> +       if (!dws->xfer.irq_status)
> +               return IRQ_NONE;
> +       if (dws->xfer.irq_status &
> +                       (SPI_INT_TXOI | SPI_INT_RXOI | SPI_INT_RXUI))
> {
> +               dw_readw(dws, txoicr);
> +               dw_readw(dws, rxoicr);
> +               dw_readw(dws, rxuicr);
> +               dws->xfer.err = -EIO;
> +               dw_spi_disable(dws);
> +               complete(&dws->xfer.complete);
> +               return IRQ_HANDLED;
> +       }
> +
> +       /* disable interrupts */
> +       dw_spi_mask_intr(dws, irq_mask);
> +       return IRQ_WAKE_THREAD;
> +}
> +struct spi_message *get_message(struct dw_spi *dws)
> +{
> +       struct spi_message *message = NULL;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&dws->lock, flags);
> +       if (!list_empty(&dws->queue)) {
> +               message = list_entry(dws->queue.next,
> +                               struct spi_message, queue);
> +               list_del_init(&message->queue);
> +       }
> +       spin_unlock_irqrestore(&dws->lock, flags);
> +       return message;
> +}
> +static inline u32 tx_max(struct dw_spi *dws)
> +{
> +       u32 tx_left, tx_room;
> +
> +       tx_left = (dws->xfer.len - dws->xfer.sent) /
> dws->xfer.n_bytes;
> +       tx_room = (dws->fifo_len - dw_readw(dws, txflr));
> +
> +       return min(tx_left, tx_room);
> +}
> +
> +/* Return the max entries we should read out of rx fifo */
> +static inline u32 rx_max(struct dw_spi *dws)
> +{
> +       u32 rx_left = (dws->xfer.len - dws->xfer.rcvd) /
> dws->xfer.n_bytes;
> +       return min(rx_left, (u32)dw_readw(dws, rxflr));
> +}
> +
> +static int transfer_setup(struct dw_spi *dws, struct chip_data
> *controller,
> +                       struct spi_transfer *transfer, struct
> spi_message *msg) +{
> +       int err = 0;
> +       u32 cr0 = controller->cr0;
> +       u32 clk_div;
> +
> +       dws->xfer.tx_buf = transfer->tx_buf;
> +       dws->xfer.tx_dma = transfer->tx_dma;
> +       dws->xfer.rx_buf = transfer->rx_buf;
> +       dws->xfer.rx_dma = transfer->rx_dma;
> +
> +       dws->xfer.len = transfer->len;
> +       dws->xfer.n_bytes = controller->n_bytes;
> +       dws->xfer.sent = 0;
> +       dws->xfer.rcvd = 0;
> +       dws->xfer.msg = msg;
> +       dws->xfer.err = 0;
> +       dws->xfer.irq_status = 0;
> +       INIT_COMPLETION(dws->xfer.complete);
> +
> +       /* {tx, rx}_threshold should probably be a module param with
> +        *  some reasonable default but these work for now.
> +        */
> +       dws->xfer.tx_threshold = 10;
> +       dws->xfer.rx_threshold = dws->xfer.tx_threshold - 1;
> +
> +       /* we need to make the decsion about the type of transfer more
> +        *  inteligently but this works for now
> +        */
> +       if (transfer->len > dws->fifo_len)
> +               dws->xfer.type = INT_XFER;
> +       else
> +               dws->xfer.type = PIO_XFER;
> +
> +       if (controller->enable_dma &&
> +               msg->is_dma_mapped &&
> +               dws->dma_inited &&
> +               dws->dma_ops)
> +               dws->xfer.type = DMA_XFER;
> +
> +       /* Setup the controller based on parameters in the transfer
> +        * each transfer can set the bit_per_word and the speed_hz to
> +        * change these values in the controller the controller MUST
> +        * be disabled
> +        */
> +       if (unlikely(!controller->clk_div)) {
> +               controller->clk_div = dws->max_freq /
> controller->speed_hz;
> +               controller->clk_div = (controller->clk_div + 1) &
> 0xfffe;
> +               dw_spi_set_clk(dws, controller->clk_div);
> +               dev_err(&dws->master->dev, "setting default clk_div");
> +               err = 1;
> +       }
> +
> +       if (transfer->speed_hz) {
> +               if (transfer->speed_hz != controller->speed_hz) {
> +                       if (transfer->speed_hz > dws->max_freq) {
> +                               err = -EIO;
> +                               goto out;
> +                       }
> +
> +                       clk_div = dws->max_freq / transfer->speed_hz;
> +                       clk_div = (clk_div + 1) & 0xfffe;
> +                       controller->clk_div = clk_div;
> +                       controller->speed_hz = transfer->speed_hz;
> +                       err = 1;
> +               }
> +       }
> +
> +       if (transfer->bits_per_word) {
> +               if (transfer->bits_per_word != 8 &&
> +                       transfer->bits_per_word != 16) {
> +                       err = -EIO;
> +                       goto out;
> +               }
> +               cr0 &= ~SPI_DFS_MASK;
> +               cr0 |= transfer->bits_per_word - 1;
> +               err = 1;
> +       } else {
> +               cr0 &= ~SPI_DFS_MASK;
> +               cr0 |= controller->spi_dev->bits_per_word - 1;
> +       }
> +
> +       cr0 &= ~SPI_MODE_MASK;
> +       cr0 |= (controller->spi_dev->mode << SPI_MODE_OFFSET);
> +       controller->cr0 = cr0;
> +
> +       if (err || dw_readw(dws, ctrl0) != cr0) {
> +               dw_spi_disable(dws);
> +               dw_spi_chip_sel(dws,
> controller->spi_dev->chip_select);
> +               dw_writew(dws, ctrl0, cr0);
> +               dw_spi_set_clk(dws, controller->clk_div);
> +               dw_spi_enable(dws);
> +               err = 0;
> +       }
> +out:
> +       return err;
> +}
> +
> +static void tx_fifo_fill(struct dw_spi *dws)
> +{
> +       int room;
> +       u16 txw = 0;
> +       if (dws->xfer.sent < dws->xfer.len) {
> +               room = tx_max(dws);
> +               while (room--) {
> +                       if (dws->xfer.tx_buf) {
> +                               if (dws->xfer.n_bytes == 2)
> +                                       txw = *(u16
> *)dws->xfer.tx_buf;
> +                               else
> +                                       txw = *(u8 *)dws->xfer.tx_buf;
> +                               dws->xfer.tx_buf += dws->xfer.n_bytes;
> +                       }
> +                       dw_writew(dws, dr, txw);
> +                       dws->xfer.sent += dws->xfer.n_bytes;
> +               }
> +       }
> +}
> +
> +
> +static void rx_fifo_drain(struct dw_spi *dws)
> +{
> +       u16 rx_val;
> +       int avail;
> +
> +       if (dws->xfer.rcvd < dws->xfer.len) {
> +               avail = rx_max(dws);
> +               while (avail--) {
> +                       rx_val = dw_readw(dws, dr);
> +                       if (dws->xfer.rx_buf) {
> +                               if (dws->xfer.n_bytes == 2)
> +                                       *(u16 *)(dws->xfer.rx_buf) =
> +                                               (u16)rx_val;
> +                               else
> +                                       *dws->xfer.rx_buf =
> (u8)rx_val;
> +                               dws->xfer.rx_buf += dws->xfer.n_bytes;
> +                       }
> +                       dws->xfer.rcvd += dws->xfer.n_bytes;
> +               }
> +       }
> +}
> +
> +static inline void do_pio(struct dw_spi *dws)
> +{
> +       while (dws->xfer.sent < dws->xfer.len ||
> +                                       dws->xfer.rcvd <
> dws->xfer.len) {
> +               tx_fifo_fill(dws);
> +               rx_fifo_drain(dws);
> +               cpu_relax();
> +       }
> +       complete(&dws->xfer.complete);
> +}
> +
> +static irqreturn_t dw_spi_irq_thread_handler(int irq, void *dev_id)
> +{
> +       struct dw_spi *dws = dev_id;
> +
> +       if (dws->xfer.irq_status & SPI_INT_TXEI) {
> +               rx_fifo_drain(dws);
> +               tx_fifo_fill(dws);
> +       }
> +
> +       if (dws->xfer.irq_status & SPI_INT_RXFI) {
> +               tx_fifo_fill(dws);
> +               rx_fifo_drain(dws);
> +       }
> +
> +       if (dws->xfer.len == dws->xfer.rcvd &&
> +               dws->xfer.len == dws->xfer.sent) {
> +               complete(&dws->xfer.complete);
> +               goto out;
> +       }
> +
> +       dw_spi_umask_intr(dws, SPI_INT_ALL);
> +out:
> +       return IRQ_HANDLED;
> +}
> +
> +static inline void do_int_xfer(struct dw_spi *dws)
> +{
> +       dw_spi_disable(dws);
> +       dw_writew(dws, txfltr, dws->xfer.tx_threshold);
> +       dw_writew(dws, rxfltr, dws->xfer.rx_threshold);
> +       dw_spi_enable(dws);
> +       dw_readw(dws, icr);
> +       tx_fifo_fill(dws);
> +       dw_writew(dws, imr, SPI_INT_ALL);
> +}
> +
> +static inline int do_transfer(struct dw_spi *dws)
> +{
> +       switch (dws->xfer.type) {
> +       case PIO_XFER:
> +               do_pio(dws);
> +               break;
> +       case INT_XFER:
> +               do_int_xfer(dws);
> +               break;
> +       case DMA_XFER:
> +               dws->dma_ops->dma_transfer(dws);
> +               break;
> +       default:
> +               BUG();
> +       }
> +
> +       wait_for_completion(&dws->xfer.complete);
> +
> +
> +       return dws->xfer.err;
> +}
> +
> +static void drain_message_queue(struct dw_spi *dws)
> +{
> +       struct spi_message *message;
> +
> +       message = get_message(dws);
> +       while (message) {
> +               message->status = -ESHUTDOWN;
> +               message->complete(message->context);
> +               message = get_message(dws);
> +       }
> +}
> +
> +static void pump_messages(struct work_struct *work)
> +{
> +       struct dw_spi *dws =
> +               container_of(work, struct dw_spi, pump_messages);
> +       struct spi_transfer *transfer;
> +       struct spi_message *message;
> +       struct chip_data *controller;
> +       int err = 0;
> +
> +
> +       message = get_message(dws);
> +
> +       while (message && dws->run != QUEUE_STOPPED) {
> +               controller = spi_get_ctldata(message->spi);
> +               list_for_each_entry(transfer, &message->transfers,
> +                               transfer_list){
> +
> +                       err = transfer_setup(dws, controller,
> +                                               transfer, message);
> +                       if (err < 0) {
> +                               dev_err(&dws->master->dev,
> +                                       "transfer_setup failed");
> +                               dws->xfer.err = -EIO;
> +                               break;
> +                       }
> +
> +                       err = do_transfer(dws);
> +                       if (err < 0) {
> +                               dev_err(&dws->master->dev,
> +                                       "do_transfer failed");
> +                               break;
> +                       }
> +                       message->actual_length += dws->xfer.len;
> +
> +                       if (transfer->delay_usecs)
> +                               udelay(transfer->delay_usecs);
> +               }
> +
> +               message->status = dws->xfer.err;
> +               message->complete(message->context);
> +               message =  get_message(dws);
> +       }
> +       if (dws->run == QUEUE_STOPPED)
> +               drain_message_queue(dws);
> +}
> +
> +/* spi_device use this to queue in their spi_msg */
> +static int dw_spi_transfer(struct spi_device *spi, struct
> spi_message *msg) +{
> +       struct dw_spi *dws = spi_master_get_devdata(spi->master);
> +       unsigned long flags;
> +
> +
> +       spin_lock_irqsave(&dws->lock, flags);
> +
> +       msg->actual_length = 0;
> +       msg->status = -EINPROGRESS;
> +
> +       list_add_tail(&msg->queue, &dws->queue);
> +
> +       queue_work(dws->workqueue,
> +               &dws->pump_messages);
> +
> +       spin_unlock_irqrestore(&dws->lock, flags);
> +
> +       return 0;
> +}
> +
> +/* This may be called twice for each spi dev */
> +static int dw_spi_setup(struct spi_device *spi)
> +{
> +       struct dw_spi_chip *chip_info = NULL;
> +       struct chip_data *chip;
> +
> +       if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
> +               return -EINVAL;
> +
> +       if (!spi->max_speed_hz) {
> +               dev_err(&spi->dev, "No max speed HZ parameter\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Only alloc on first setup */
> +       chip = spi_get_ctldata(spi);
> +       if (!chip) {
> +               chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
> +               if (!chip)
> +                       return -ENOMEM;
> +       }
> +       chip->spi_dev = spi;
> +
> +       /*
> +        * Protocol drivers may change the chip settings, so...
> +        * if chip_info exists, use it
> +        */
> +       chip_info = spi->controller_data;
> +
> +       /* chip_info doesn't always exist */
> +       if (chip_info) {
> +               chip->type = chip_info->type;
> +               chip->enable_dma = chip_info->enable_dma;
> +       }
> +
> +       chip->bits_per_word = spi->bits_per_word;
> +       chip->n_bytes = chip->bits_per_word / 8;
> +       chip->dma_width = chip->bits_per_word / 8;
> +
> +       chip->speed_hz = spi->max_speed_hz;
> +
> +       /* Default SPI mode is SCPOL = 0, SCPH = 0 */
> +       chip->cr0 = (chip->bits_per_word - 1)
> +               | (chip->type << SPI_FRF_OFFSET)
> +               | (spi->mode  << SPI_MODE_OFFSET);
> +
> +       spi_set_ctldata(spi, chip);
> +       return 0;
> +}
> +
> +static void dw_spi_cleanup(struct spi_device *spi)
> +{
> +       struct chip_data *chip = spi_get_ctldata(spi);
> +       kfree(chip);
> +}
> +
> +static int __devinit init_queue(struct dw_spi *dws)
> +{
> +       INIT_LIST_HEAD(&dws->queue);
> +       spin_lock_init(&dws->lock);
> +
> +       dws->run = QUEUE_STOPPED;
> +
> +       INIT_WORK(&dws->pump_messages, pump_messages);
> +       dws->workqueue = create_singlethread_workqueue(
> +
> dev_name(dws->master->dev.parent));
> +       if (dws->workqueue == NULL)
> +               return -EBUSY;
> +       dws->run = QUEUE_RUNNING;
> +       return 0;
> +}
> +
> +
> +int dw_spi_stop_queue(struct dw_spi *dws)
> +{
> +       unsigned long flags;
> +       int status = 0;
> +
> +       spin_lock_irqsave(&dws->lock, flags);
> +       dws->run = QUEUE_STOPPED;
> +
> +       if (!list_empty(&dws->queue))
> +               status = -EBUSY;
> +       spin_unlock_irqrestore(&dws->lock, flags);
> +
> +       return status;
> +}
> +EXPORT_SYMBOL_GPL(dw_spi_stop_queue);
> +
> +static int destroy_queue(struct dw_spi *dws)
> +{
> +       int status;
> +
> +       status = dw_spi_stop_queue(dws);
> +       if (status != 0)
> +               return status;
> +       destroy_workqueue(dws->workqueue);
> +       return 0;
> +}
> +
> +/* Restart the controller, disable all interrupts, clean rx fifo */
> +static void spi_hw_init(struct dw_spi *dws)
> +{
> +       dw_spi_disable(dws);
> +       dw_spi_mask_intr(dws, 0xff);
> +       dw_readw(dws, icr);
> +       dw_spi_enable(dws);
> +
> +       BUG_ON(!dws->fifo_len);
> +}
> +
> +int __devinit dw_spi_add_host(struct dw_spi *dws)
> +{
> +       struct spi_master *master;
> +       int ret;
> +
> +       BUG_ON(dws == NULL);
> +
> +       master = spi_alloc_master(dws->parent_dev, 0);
> +       if (!master) {
> +               ret = -ENOMEM;
> +               goto exit;
> +       }
> +
> +       dws->master = master;
> +       dws->type = SSI_MOTO_SPI;
> +
> +       init_completion(&dws->xfer.complete);
> +       dws->dma_inited = 0;
> +       /* Change to address of FIFO */
> +       dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
> +
> +       ret = request_threaded_irq(dws->irq, dw_spi_irq,
> +                               dw_spi_irq_thread_handler,
> +                               IRQF_SHARED, "dw_spi", dws);
> +       if (ret < 0) {
> +               dev_err(&master->dev, "can not get IRQ\n");
> +               goto err_free_master;
> +       }
> +
> +       master->mode_bits = SPI_CPOL | SPI_CPHA;
> +       master->bus_num = dws->bus_num;
> +       master->num_chipselect = dws->num_cs;
> +       master->cleanup = dw_spi_cleanup;
> +       master->setup = dw_spi_setup;
> +       master->transfer = dw_spi_transfer;
> +
> +       /* Basic HW init */
> +       spi_hw_init(dws);
> +
> +       if (dws->dma_ops && dws->dma_ops->dma_init) {
> +               ret = dws->dma_ops->dma_init(dws);
> +               if (ret) {
> +                       dev_warn(&master->dev, "DMA init failed\n");
> +                       dws->dma_inited = 0;
> +               }
> +       }
> +
> +       /* Initial and start queue */
> +       ret = init_queue(dws);
> +       if (ret) {
> +               dev_err(&master->dev, "problem initializing queue\n");
> +               goto err_diable_hw;
> +       }
> +
> +       spi_master_set_devdata(master, dws);
> +       ret = spi_register_master(master);
> +       if (ret) {
> +               dev_err(&master->dev, "problem registering spi
> master\n");
> +               goto err_queue_alloc;
> +       }
> +
> +       mrst_spi_debugfs_init(dws);
> +       return 0;
> +
> +err_queue_alloc:
> +       destroy_queue(dws);
> +       if (dws->dma_ops && dws->dma_ops->dma_exit)
> +               dws->dma_ops->dma_exit(dws);
> +err_diable_hw:
> +       dw_spi_disable(dws);
> +       free_irq(dws->irq, dws);
> +err_free_master:
> +       spi_master_put(master);
> +exit:
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(dw_spi_add_host);
> +
> +void __devexit dw_spi_remove_host(struct dw_spi *dws)
> +{
> +       int status = 0;
> +
> +       if (!dws)
> +               return;
> +       mrst_spi_debugfs_remove(dws);
> +
> +       /* Remove the queue */
> +       status = destroy_queue(dws);
> +       if (status != 0)
> +               dev_err(&dws->master->dev, "dw_spi_remove: workqueue
> will not "
> +                       "complete, message memory not freed\n");
> +
> +       if (dws->dma_ops && dws->dma_ops->dma_exit)
> +               dws->dma_ops->dma_exit(dws);
> +       dw_spi_disable(dws);
> +       dw_readw(dws, icr);
> +       free_irq(dws->irq, dws);
> +
> +       /* Disconnect from the SPI framework */
> +       spi_unregister_master(dws->master);
> +}
> +EXPORT_SYMBOL_GPL(dw_spi_remove_host);
> +
> +int dw_spi_suspend_host(struct dw_spi *dws)
> +{
> +       int ret = 0;
> +
> +       ret = dw_spi_stop_queue(dws);
> +       if (ret)
> +               return ret;
> +       dw_spi_disable(dws);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(dw_spi_suspend_host);
> +
> +int dw_spi_resume_host(struct dw_spi *dws)
> +{
> +       spi_hw_init(dws);
> +       dws->run = QUEUE_RUNNING;
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(dw_spi_resume_host);
> +
> +MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
> +MODULE_DESCRIPTION("Driver for DesignWare SPI controller core");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
> index 97baff6..b016b85 100644
> --- a/drivers/spi/spi-dw.h
> +++ b/drivers/spi/spi-dw.h
> @@ -7,6 +7,7 @@
> 
>  /* Bit fields in CTRLR0 */
>  #define SPI_DFS_OFFSET                 0
> +#define SPI_DFS_MASK                   0xf
> 
>  #define SPI_FRF_OFFSET                 4
>  #define SPI_FRF_SPI                    0x0
> @@ -17,6 +18,7 @@
>  #define SPI_MODE_OFFSET                        6
>  #define SPI_SCPH_OFFSET                        6
>  #define SPI_SCOL_OFFSET                        7
> +#define SPI_MODE_MASK                  (0x3 << SPI_MODE_OFFSET)
> 
>  #define SPI_TMOD_OFFSET                        8
>  #define SPI_TMOD_MASK                  (0x3 << SPI_TMOD_OFFSET)
> @@ -46,6 +48,7 @@
>  #define SPI_INT_RXOI                   (1 << 3)
>  #define SPI_INT_RXFI                   (1 << 4)
>  #define SPI_INT_MSTI                   (1 << 5)
> +#define SPI_INT_ALL  0x3f
> 
>  /* TX RX interrupt level threshold, max can be 256 */
>  #define SPI_INT_THRESHOLD              32
> @@ -83,65 +86,67 @@ struct dw_spi;
>  struct dw_spi_dma_ops {
>         int (*dma_init)(struct dw_spi *dws);
>         void (*dma_exit)(struct dw_spi *dws);
> -       int (*dma_transfer)(struct dw_spi *dws, int cs_change);
> +       int (*dma_transfer)(struct dw_spi *dws);
> +};
> +
> +enum xfer_type {
> +       PIO_XFER,
> +       INT_XFER,
> +       DMA_XFER,
> +};
> +
> +
> +struct xfer_state {
> +       const u8 *tx_buf;
> +       dma_addr_t tx_dma;
> +       u8 *rx_buf;
> +       dma_addr_t rx_dma;
> +       struct spi_message *msg;
> +       u32 n_bytes;
> +       u32 len;
> +       u32 sent;
> +       u32 rcvd;
> +       u32 err;
> +       u32 type;
> +       u32  tx_threshold;
> +       u32  rx_threshold;
> +       u32 irq_status;
> +       struct completion complete;
>  };
> 
>  struct dw_spi {
>         struct spi_master       *master;
> -       struct spi_device       *cur_dev;
>         struct device           *parent_dev;
>         enum dw_ssi_type        type;
> 
>         void __iomem            *regs;
>         unsigned long           paddr;
>         u32                     iolen;
> -       int                     irq;
> +       u32                     irq;
>         u32                     fifo_len;       /* depth of the FIFO
> buffer */ u32                     max_freq;       /* max bus freq
> supported */
> 
>         u16                     bus_num;
>         u16                     num_cs;         /* supported slave
> numbers */ -
> +
>         /* Driver message queue */
>         struct workqueue_struct *workqueue;
>         struct work_struct      pump_messages;
>         spinlock_t              lock;
>         struct list_head        queue;
> -       int                     busy;
> -       int                     run;
> -
> -       /* Message Transfer pump */
> -       struct tasklet_struct   pump_transfers;
> +       u32                     run;
> 
>         /* Current message transfer state info */
> -       struct spi_message      *cur_msg;
> -       struct spi_transfer     *cur_transfer;
> -       struct chip_data        *cur_chip;
> -       struct chip_data        *prev_chip;
> -       size_t                  len;
> -       void                    *tx;
> -       void                    *tx_end;
> -       void                    *rx;
> -       void                    *rx_end;
> -       int                     dma_mapped;
> -       dma_addr_t              rx_dma;
> -       dma_addr_t              tx_dma;
> -       size_t                  rx_map_len;
> -       size_t                  tx_map_len;
> -       u8                      n_bytes;        /* current is a 1/2
> bytes op */
> -       u8                      max_bits_per_word;      /* maxim is
> 16b */
> -       u32                     dma_width;
> -       int                     cs_change;
> -       irqreturn_t             (*transfer_handler)(struct dw_spi
> *dws);
> -       void                    (*cs_control)(u32 command);
> +       struct xfer_state       xfer;
> 
>         /* Dma info */
> -       int                     dma_inited;
> +//     int                     dma_width;
> +       u32                     dma_inited;
>         struct dma_chan         *txchan;
>         struct scatterlist      tx_sgl;
>         struct dma_chan         *rxchan;
>         struct scatterlist      rx_sgl;
> -       int                     dma_chan_done;
> +       u32                     dma_chan_done;
>         struct device           *dma_dev;
>         dma_addr_t              dma_addr; /* phy address of the Data
> register */ struct dw_spi_dma_ops   *dma_ops;
> @@ -163,30 +168,36 @@ struct dw_spi {
>         __raw_readw(&(((struct dw_spi_reg *)dw->regs)->name))
>  #define dw_writew(dw, name, val) \
>         __raw_writew((val), &(((struct dw_spi_reg *)dw->regs)->name))
> +#define dw_readb(dw, name) \
> +       __raw_readb(&(((struct dw_spi_reg *)dw->regs)->name))
> +#define dw_writeb(dw, name, val) \
> +       __raw_writeb((val), &(((struct dw_spi_reg *)dw->regs)->name))
> 
> -static inline void spi_enable_chip(struct dw_spi *dws, int enable)
> +static inline void dw_spi_disable(struct dw_spi *dws)
>  {
> -       dw_writel(dws, ssienr, (enable ? 1 : 0));
> +       dw_writel(dws, ssienr, 0);
>  }
> 
> -static inline void spi_set_clk(struct dw_spi *dws, u16 div)
> +static inline void dw_spi_enable(struct dw_spi *dws)
> +{
> +       dw_writel(dws, ssienr, 1);
> +}
> +
> +static inline void dw_spi_set_clk(struct dw_spi *dws, u16 div)
>  {
>         dw_writel(dws, baudr, div);
>  }
> 
> -static inline void spi_chip_sel(struct dw_spi *dws, u16 cs)
> +static inline void dw_spi_chip_sel(struct dw_spi *dws, u16 cs)
>  {
>         if (cs > dws->num_cs)
>                 return;
> 
> -       if (dws->cs_control)
> -               dws->cs_control(1);
> -
>         dw_writel(dws, ser, 1 << cs);
>  }
> 
>  /* Disable IRQ bits */
> -static inline void spi_mask_intr(struct dw_spi *dws, u32 mask)
> +static inline void dw_spi_mask_intr(struct dw_spi *dws, u32 mask)
>  {
>         u32 new_mask;
> 
> @@ -195,7 +206,7 @@ static inline void spi_mask_intr(struct dw_spi
> *dws, u32 mask) }
> 
>  /* Enable IRQ bits */
> -static inline void spi_umask_intr(struct dw_spi *dws, u32 mask)
> +static inline void dw_spi_umask_intr(struct dw_spi *dws, u32 mask)
>  {
>         u32 new_mask;
> 
> @@ -208,6 +219,7 @@ extern void dw_spi_remove_host(struct dw_spi
> *dws); extern int dw_spi_suspend_host(struct dw_spi *dws);
>  extern int dw_spi_resume_host(struct dw_spi *dws);
>  extern void dw_spi_xfer_done(struct dw_spi *dws);
> +extern int dw_spi_stop_queue(struct dw_spi *dws);
> 
>  /* platform related setup */
>  extern int dw_spi_mid_init(struct dw_spi *dws); /* Intel MID
> platforms */ --
> 1.7.3.4
> 
> 
> ------------------------------------------------------------------------------
> EditLive Enterprise is the world's most technically advanced content
> authoring tool. Experience the power of Track Changes, Inline Image
> Editing and ensure content is compliant with Accessibility Checking.
> http://p.sf.net/sfu/ephox-dev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
