Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0JLCrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 22:47:37 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:18237 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477Ab0JLCrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 22:47:35 -0400
Message-ID: <001601cb69b7$d2067000$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "ML linux-kernel" <linux-kernel@vger.kernel.org>
References: <20101008184902.16492.19574.stgit@localhost6.localdomain6>
Subject: Re: [PATCH] spi/topcliff: cleanups for style and conciseness
Date: Tue, 12 Oct 2010 11:47:30 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thank you for your confirming our patch and releasing your cleanup patch.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Grant Likely" <grant.likely@secretlab.ca>
To: <masa-korg@dsn.okisemi.com>; <spi-devel-general@lists.sourceforge.net>; <linux-kernel@vger.kernel.org>;
<meego-dev@meego.com>
Sent: Saturday, October 09, 2010 3:51 AM
Subject: [PATCH] spi/topcliff: cleanups for style and conciseness


> This patch makes multiple cleanups to the new topcliff pch spi driver
> including, but not limited to,
> - removing superfluous brackets around variables
> - open coding functions that are only used once
> - removing unnecessary line breaks
> - removing unused functions
> - simplifying the interrupt enable/disable code
> - remove unnecessary (void *) casts.
> - remove b_mem_fail from pch_spi_set_tx to code it more cleanly
> - shorten dev_dbg() messages for conciseness and readability
>
> More cleanups are still needed in this driver.  In particular,
> - the driver filename should be changed to spi_topcliff_pch.c
> - many of the dev_dbg() lines should be trimmed (particularly the ones
>   on unconditional code paths).
> - I suspect that the locking model not correct.  I'd like to know what
>   drivers' critical regions are, and how they are protected.
> - get_resources and release_resources probably should be open coded in
>   .probe and .release respectively.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
> Hi Ohtake,
>
> Here are the cleanups that I've applied to the topcliff spi driver.  I
> figured this was easier than rejecting your patch again and asking
> your for more specific changes.  Please try it out and make sure I
> haven't broken anything.
>
> Cheers,
> g.
>
>  drivers/spi/spi_topcliff_pch.c |  502 +++++++++++-----------------------------
>  1 files changed, 138 insertions(+), 364 deletions(-)
>
> diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
> index 58b183f..9774623 100644
> --- a/drivers/spi/spi_topcliff_pch.c
> +++ b/drivers/spi/spi_topcliff_pch.c
> @@ -1,8 +1,6 @@
>  /*
>   * SPI bus driver for the Topcliff PCH used by Intel SoCs
> - */
> -
> -/*
> + *
>   * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -19,6 +17,7 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
>   */
>
> +#include <linux/delay.h>
>  #include <linux/pci.h>
>  #include <linux/wait.h>
>  #include <linux/spi/spi.h>
> @@ -45,17 +44,7 @@
>
>  #define PCH_RX_THOLD 7
>  #define PCH_RX_THOLD_MAX 15
> -#define PCH_RX 1
> -#define PCH_TX 2
> -
> -/* various interrupts */
> -#define PCH_TFI 0x1
> -#define PCH_RFI 0x2
> -#define PCH_FI 0x4
> -#define PCH_ORI 0x8
> -#define PCH_MDFI 0x10
>
> -#define PCH_ALL (PCH_TFI|PCH_RFI|PCH_FI|PCH_ORI|PCH_MDFI)
>  #define PCH_MAX_BAUDRATE 5000000
>  #define PCH_MAX_FIFO_DEPTH 16
>
> @@ -86,6 +75,8 @@
>  #define SPSR_FI_BIT (1 << 2)
>  #define SPBRR_SIZE_BIT (1 << 10)
>
> +#define PCH_ALL (SPCR_TFIE_BIT|SPCR_RFIE_BIT|SPCR_FIE_BIT|SPCR_ORIE_BIT|SPCR_MDFIE_BIT)
> +
>  #define SPCR_RFIC_FIELD 20
>  #define SPCR_TFIC_FIELD 16
>
> @@ -176,16 +167,6 @@ static struct pci_device_id pch_spi_pcidev_id[] = {
>   {0,}
>  };
>
> -static inline void pch_set_bitmsk(u32 *var, u32 bitmask)
> -{
> - *var |= bitmask;
> -}
> -
> -static inline void pch_clr_bitmsk(u32 *var, u32 bitmask)
> -{
> - *var &= (~(bitmask));
> -}
> -
>  /**
>   * pch_spi_writereg() - Performs  register writes
>   * @master: Pointer to struct spi_master.
> @@ -194,9 +175,7 @@ static inline void pch_clr_bitmsk(u32 *var, u32 bitmask)
>   */
>  static inline void pch_spi_writereg(struct spi_master *master, int idx, u32 val)
>  {
> -
>   struct pch_spi_data *data = spi_master_get_devdata(master);
> -
>   iowrite32(val, (data->io_remap_addr + idx));
>  }
>
> @@ -208,19 +187,9 @@ static inline void pch_spi_writereg(struct spi_master *master, int idx, u32 val)
>  static inline u32 pch_spi_readreg(struct spi_master *master, int idx)
>  {
>   struct pch_spi_data *data = spi_master_get_devdata(master);
> -
>   return ioread32(data->io_remap_addr + idx);
>  }
>
> -/* ope==true:Set bit, ope==false:Clear bit */
> -static inline void pch_spi_setclr_bit(u32 *val, u32 pos, bool ope)
> -{
> - if (ope)
> - *val |= pos;
> - else
> - *val &= (~(pos));
> -}
> -
>  static inline void pch_spi_setclr_reg(struct spi_master *master, int idx,
>         u32 set, u32 clr)
>  {
> @@ -229,7 +198,6 @@ static inline void pch_spi_setclr_reg(struct spi_master *master, int idx,
>   pch_spi_writereg(master, idx, tmp);
>  }
>
> -
>  static void pch_spi_set_master_mode(struct spi_master *master)
>  {
>   pch_spi_setclr_reg(master, PCH_SPCR, SPCR_MSTR_BIT, 0);
> @@ -245,35 +213,6 @@ static void pch_spi_clear_fifo(struct spi_master *master)
>   pch_spi_setclr_reg(master, PCH_SPCR, 0, SPCR_FICLR_BIT);
>  }
>
> -/**
> - * ch_spi_disable_interrupts() - Disables specified interrupts
> - * @master: Pointer to struct spi_master.
> - * @interrupt: Interrups to be enabled.
> - */
> -static void pch_spi_disable_interrupts(struct spi_master *master, u8 interrupt)
> -{
> - u32 clr_flags = 0;
> -
> - if (interrupt & PCH_RFI)
> - clr_flags |= SPCR_RFIE_BIT;
> -
> - if (interrupt & PCH_TFI)
> - clr_flags |= SPCR_TFIE_BIT;
> -
> - if (interrupt & PCH_FI)
> - clr_flags |= SPCR_FIE_BIT;
> -
> - if (interrupt & PCH_ORI)
> - clr_flags |= SPCR_ORIE_BIT;
> -
> - if (interrupt & PCH_MDFI)
> - clr_flags |= SPCR_MDFIE_BIT;
> -
> - pch_spi_setclr_reg(master, PCH_SPCR, 0, clr_flags);
> -
> - dev_dbg(&master->dev, "%s clearing bits =%x\n", __func__, clr_flags);
> -}
> -
>  static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
>   void __iomem *io_remap_addr)
>  {
> @@ -309,9 +248,7 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
>   /* disable RFI if not needed */
>   if ((bpw_len - rx_index) <= PCH_MAX_FIFO_DEPTH) {
>   reg_spcr_val = ioread32(io_remap_addr + PCH_SPCR);
> -
> - /* disable RFI */
> - pch_clr_bitmsk(&reg_spcr_val, SPCR_RFIE_BIT);
> + reg_spcr_val &= ~SPCR_RFIE_BIT; /* disable RFI */
>
>   /* reset rx threshold */
>   reg_spcr_val &= MASK_RFIC_SPCR_BITS;
> @@ -329,7 +266,8 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
>   /* if transfer complete interrupt */
>   if (reg_spsr_val & SPSR_FI_BIT) {
>   /* disable FI & RFI interrupts */
> - pch_spi_disable_interrupts(data->master, PCH_FI | PCH_RFI);
> + pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
> +    SPCR_FIE_BIT | SPCR_TFIE_BIT);
>
>   /* transfer is completed;inform pch_spi_process_messages */
>   data->transfer_complete = true;
> @@ -337,7 +275,6 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
>   }
>  }
>
> -
>  /**
>   * pch_spi_handler() - Interrupt handler
>   * @irq: The interrupt number.
> @@ -350,7 +287,6 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>   void __iomem *spsr;
>   void __iomem *io_remap_addr;
>   irqreturn_t ret = IRQ_NONE;
> -
>   struct pch_spi_board_data *board_dat = dev_id;
>
>   if (board_dat->suspend_sts) {
> @@ -366,7 +302,6 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>   reg_spsr_val = ioread32(spsr);
>
>   /* Check if the interrupt is for SPI device */
> -
>   if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
>   pch_spi_handler_sub(data, reg_spsr_val, io_remap_addr);
>   ret = IRQ_HANDLED;
> @@ -385,12 +320,9 @@ static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>   */
>  static void pch_spi_set_baud_rate(struct spi_master *master, u32 speed_hz)
>  {
> - u32 n_spbr;
> -
> - n_spbr = PCH_CLOCK_HZ / (speed_hz * 2);
> + u32 n_spbr = PCH_CLOCK_HZ / (speed_hz * 2);
>
>   /* if baud rate is less than we can support limit it */
> -
>   if (n_spbr > PCH_MAX_SPBR)
>   n_spbr = PCH_MAX_SPBR;
>
> @@ -417,106 +349,30 @@ static void pch_spi_set_bits_per_word(struct spi_master *master,
>   */
>  static void pch_spi_setup_transfer(struct spi_device *spi)
>  {
> - u32 reg_spcr_val;
> + u32 flags = 0;
>
>   dev_dbg(&spi->dev, "%s SPBRR content =%x setting baud rate=%d\n",
>   __func__, pch_spi_readreg(spi->master, PCH_SPBRR),
>   spi->max_speed_hz);
> -
>   pch_spi_set_baud_rate(spi->master, spi->max_speed_hz);
>
>   /* set bits per word */
>   pch_spi_set_bits_per_word(spi->master, spi->bits_per_word);
>
> - if (spi->mode & SPI_LSB_FIRST)
> - pch_spi_setclr_reg(spi->master, PCH_SPCR, 0, SPCR_LSBF_BIT);
> - else
> - pch_spi_setclr_reg(spi->master, PCH_SPCR, SPCR_LSBF_BIT, 0);
> -
> + if (!(spi->mode & SPI_LSB_FIRST))
> + flags |= SPCR_LSBF_BIT;
>   if (spi->mode & SPI_CPOL)
> - pch_spi_setclr_reg(spi->master, PCH_SPCR, SPCR_CPOL_BIT, 0);
> - else
> - pch_spi_setclr_reg(spi->master, PCH_SPCR, 0, SPCR_CPOL_BIT);
> -
> + flags |= SPCR_CPOL_BIT;
>   if (spi->mode & SPI_CPHA)
> - pch_spi_setclr_reg(spi->master, PCH_SPCR, SPCR_CPHA_BIT, 0);
> - else
> - pch_spi_setclr_reg(spi->master, PCH_SPCR, 0, SPCR_CPHA_BIT);
> -
> - dev_dbg(&spi->dev,
> - "%s SPCR content after setting LSB/MSB and MODE= %x\n",
> - __func__, reg_spcr_val);
> + flags |= SPCR_CPHA_BIT;
> + pch_spi_setclr_reg(spi->master, PCH_SPCR, flags,
> +    (SPCR_LSBF_BIT | SPCR_CPOL_BIT | SPCR_CPHA_BIT));
>
>   /* Clear the FIFO by toggling  FICLR to 1 and back to 0 */
>   pch_spi_clear_fifo(spi->master);
>  }
>
>  /**
> - * pch_spi_enable_interrupts() - Enables specified interrupts
> - * @master: Pointer to struct spi_master.
> - * @interrupt: Interrups to be enabled.
> - */
> -static void pch_spi_enable_interrupts(struct spi_master *master, u8 interrupt)
> -{
> - u32 reg_val_spcr;
> -
> - dev_dbg(&master->dev, "%s SPCR content=%x\n", __func__, reg_val_spcr);
> -
> - if (interrupt & PCH_RFI) {
> - /* set RFIE bit in SPCR */
> - dev_dbg(&master->dev, "setting RFI in %s\n", __func__);
> - pch_spi_setclr_reg(master, PCH_SPCR, SPCR_RFIE_BIT, 0);
> - }
> -
> - if (interrupt & PCH_TFI) {
> - /* set TFIE bit in SPCR */
> - dev_dbg(&master->dev, "setting TFI in %s\n", __func__);
> - pch_spi_setclr_reg(master, PCH_SPCR, SPCR_TFIE_BIT, 0);
> - }
> -
> - if (interrupt & PCH_FI) {
> - /* set FIE bit in SPCR */
> - dev_dbg(&master->dev, "setting FI in %s\n", __func__);
> - pch_spi_setclr_reg(master, PCH_SPCR, SPCR_FIE_BIT, 0);
> - }
> -
> - if (interrupt & PCH_ORI) {
> - /* set ORIE bit in SPCR */
> - dev_dbg(&master->dev, "setting ORI in %s\n", __func__);
> - pch_spi_setclr_reg(master, PCH_SPCR, SPCR_ORIE_BIT, 0);
> - }
> -
> - if (interrupt & PCH_MDFI) {
> - /* set MODFIE bit in SPCR */
> - dev_dbg(&master->dev, "setting MDFI in %s\n", __func__);
> - pch_spi_setclr_reg(master, PCH_SPCR, SPCR_MDFIE_BIT, 0);
> - }
> -}
> -
> -/**
> - * pch_spi_set_threshold() - Sets Tx/Rx FIFO thresholds
> - * @spi: Pointer to struct spi_device.
> - * @threshold: Threshold value to be set.
> - * @dir: Rx or Tx threshold to be set.
> - */
> -static void pch_spi_set_threshold(struct spi_device *spi, u32 threshold, u8 dir)
> -{
> -
> - if (dir == PCH_RX) {
> - dev_dbg(&spi->dev, "%s setting Rx threshold\n", __func__);
> - pch_spi_setclr_reg(spi->master, PCH_SPCR,
> -    threshold << SPCR_RFIC_FIELD,
> -    ~MASK_RFIC_SPCR_BITS);
> -
> - } else if (dir == PCH_TX) {
> - dev_dbg(&spi->dev, "%s setting Tx threshold\n",  __func__);
> - pch_spi_setclr_reg(spi->master, PCH_SPCR,
> -   (threshold << SPCR_TFIC_FIELD) ,
> -    ~MASK_TFIC_SPCR_BITS);
> - }
> -}
> -
> -/**
>   * pch_spi_reset() - Clears SPI registers
>   * @master: Pointer to struct spi_master.
>   */
> @@ -532,13 +388,12 @@ static void pch_spi_reset(struct spi_master *master)
>  static int pch_spi_setup(struct spi_device *pspi)
>  {
>   /* check bits per word */
> - if ((pspi->bits_per_word) == 0) {
> + if (pspi->bits_per_word == 0) {
>   pspi->bits_per_word = 8;
>   dev_dbg(&pspi->dev, "%s 8 bits per word\n", __func__);
>   }
>
> - if (((pspi->bits_per_word) != 8) &&
> -     ((pspi->bits_per_word != 16))) {
> + if ((pspi->bits_per_word != 8) && (pspi->bits_per_word != 16)) {
>   dev_err(&pspi->dev, "%s Invalid bits per word\n", __func__);
>   return -EINVAL;
>   }
> @@ -550,7 +405,7 @@ static int pch_spi_setup(struct spi_device *pspi)
>   pspi->max_speed_hz = PCH_MAX_BAUDRATE;
>
>   dev_dbg(&pspi->dev, "%s MODE = %x\n", __func__,
> - ((pspi->mode) & (SPI_CPOL | SPI_CPHA)));
> + (pspi->mode) & (SPI_CPOL | SPI_CPHA));
>
>   return 0;
>  }
> @@ -564,17 +419,15 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
>   unsigned long flags;
>
>   /* validate spi message and baud rate */
> - if (unlikely((list_empty(&pmsg->transfers) == 1) ||
> -      (pspi->max_speed_hz == 0))) {
> - if (list_empty(&pmsg->transfers) == 1)
> - dev_err(&pspi->dev, "%s list empty\n", __func__);
> -
> - if ((pspi->max_speed_hz) == 0) {
> - dev_err(&pspi->dev, "%s pch_spi_tranfer maxspeed=%d\n",
> - __func__, pspi->max_speed_hz);
> - }
> - dev_err(&pspi->dev, "%s returning EINVAL\n", __func__);
> + if (unlikely(list_empty(&pmsg->transfers) == 1)) {
> + dev_err(&pspi->dev, "%s list empty\n", __func__);
> + retval = -EINVAL;
> + goto err_out;
> + }
>
> + if (unlikely(pspi->max_speed_hz == 0)) {
> + dev_err(&pspi->dev, "%s pch_spi_tranfer maxspeed=%d\n",
> + __func__, pspi->max_speed_hz);
>   retval = -EINVAL;
>   goto err_out;
>   }
> @@ -582,32 +435,28 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
>   dev_dbg(&pspi->dev, "%s Transfer List not empty. "
>   "Transfer Speed is set.\n", __func__);
>
> - spin_lock_irqsave(&data->lock, flags);
> -
>   /* validate Tx/Rx buffers and Transfer length */
>   list_for_each_entry(transfer, &pmsg->transfers, transfer_list) {
> - if ((!(transfer->tx_buf)) && (!(transfer->rx_buf))) {
> + if (!transfer->tx_buf && !transfer->rx_buf) {
>   dev_err(&pspi->dev,
>   "%s Tx and Rx buffer NULL\n", __func__);
>   retval = -EINVAL;
> - goto err_return_spinlock;
> + goto err_out;
>   }
>
> - if (!(transfer->len)) {
> + if (!transfer->len) {
>   dev_err(&pspi->dev, "%s Transfer length invalid\n",
>   __func__);
>   retval = -EINVAL;
> - goto err_return_spinlock;
> + goto err_out;
>   }
>
>   dev_dbg(&pspi->dev, "%s Tx/Rx buffer valid. Transfer length"
>   " valid\n", __func__);
>
>   /* if baud rate hs been specified validate the same */
> - if (transfer->speed_hz) {
> - if ((transfer->speed_hz) > PCH_MAX_BAUDRATE)
> - transfer->speed_hz = PCH_MAX_BAUDRATE;
> - }
> + if (transfer->speed_hz > PCH_MAX_BAUDRATE)
> + transfer->speed_hz = PCH_MAX_BAUDRATE;
>
>   /* if bits per word has been specified validate the same */
>   if (transfer->bits_per_word) {
> @@ -616,14 +465,15 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
>   retval = -EINVAL;
>   dev_err(&pspi->dev,
>   "%s Invalid bits per word\n", __func__);
> - goto err_return_spinlock;
> + goto err_out;
>   }
>   }
>   }
>
> - /* We won't process any messages if we have been asked to terminate */
> + spin_lock_irqsave(&data->lock, flags);
>
> - if (STATUS_EXITING == (data->status)) {
> + /* We won't process any messages if we have been asked to terminate */
> + if (data->status == STATUS_EXITING) {
>   dev_err(&pspi->dev, "%s status = STATUS_EXITING.\n", __func__);
>   retval = -ESHUTDOWN;
>   goto err_return_spinlock;
> @@ -631,27 +481,23 @@ static int pch_spi_transfer(struct spi_device *pspi, struct spi_message *pmsg)
>
>   /* If suspended ,return -EINVAL */
>   if (data->board_dat->suspend_sts) {
> - dev_err(&pspi->dev,
> - "%s bSuspending= true returning EINVAL\n", __func__);
> + dev_err(&pspi->dev, "%s suspend; returning EINVAL\n", __func__);
>   retval = -EINVAL;
>   goto err_return_spinlock;
>   }
>
>   /* set status of message */
>   pmsg->actual_length = 0;
> -
>   dev_dbg(&pspi->dev, "%s - pmsg->status =%d\n", __func__, pmsg->status);
>
>   pmsg->status = -EINPROGRESS;
>
>   /* add message to queue */
>   list_add_tail(&pmsg->queue, &data->queue);
> -
>   dev_dbg(&pspi->dev, "%s - Invoked list_add_tail\n", __func__);
>
>   /* schedule work queue to run */
>   queue_work(data->wk, &data->work);
> -
>   dev_dbg(&pspi->dev, "%s - Invoked queue work\n", __func__);
>
>   retval = 0;
> @@ -666,10 +512,9 @@ err_out:
>  static inline void pch_spi_select_chip(struct pch_spi_data *data,
>          struct spi_device *pspi)
>  {
> - if ((data->current_chip) != NULL) {
> - if ((pspi->chip_select) != (data->n_curnt_chip)) {
> - dev_dbg(&pspi->dev,
> - "%s : different slave-Invoking\n", __func__);
> + if (data->current_chip != NULL) {
> + if (pspi->chip_select != data->n_curnt_chip) {
> + dev_dbg(&pspi->dev, "%s : different slave\n", __func__);
>   data->current_chip = NULL;
>   }
>   }
> @@ -683,9 +528,8 @@ static inline void pch_spi_select_chip(struct pch_spi_data *data,
>  }
>
>  static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
> - struct spi_message **ppmsg)
> +    struct spi_message **ppmsg)
>  {
> - int b_mem_fail;
>   int size;
>   u32 n_writes;
>   int j;
> @@ -697,20 +541,16 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
>
>   /* set baud rate if needed */
>   if (data->cur_trans->speed_hz) {
> - dev_dbg(&data->master->dev,
> - "%s:pctrldatasetting baud rate\n", __func__);
> - pch_spi_set_baud_rate(data->master,
> -       (data->cur_trans->speed_hz));
> + dev_dbg(&data->master->dev, "%s:setting baud rate\n", __func__);
> + pch_spi_set_baud_rate(data->master, data->cur_trans->speed_hz);
>   }
>
>   /* set bits per word if needed */
> - if ((data->cur_trans->bits_per_word) &&
> -     ((data->current_msg->spi->bits_per_word) !=
> -      (data->cur_trans->bits_per_word))) {
> - dev_dbg(&data->master->dev,
> - "%s:setting bits per word\n", __func__);
> + if (data->cur_trans->bits_per_word &&
> +     (data->current_msg->spi->bits_per_word != data->cur_trans->bits_per_word)) {
> + dev_dbg(&data->master->dev, "%s:set bits per word\n", __func__);
>   pch_spi_set_bits_per_word(data->master,
> -   (data->cur_trans->bits_per_word));
> +   data->cur_trans->bits_per_word);
>   *bpw = data->cur_trans->bits_per_word;
>   } else {
>   *bpw = data->current_msg->spi->bits_per_word;
> @@ -721,28 +561,21 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
>   data->rx_index = 0;
>
>   data->bpw_len = data->cur_trans->len / (*bpw / 8);
> - b_mem_fail = false;
>
>   /* find alloc size */
> - size = (data->cur_trans->len) * (sizeof(*(data->pkt_tx_buff)));
> + size = data->cur_trans->len * sizeof(*data->pkt_tx_buff);
> +
>   /* allocate memory for pkt_tx_buff & pkt_rx_buffer */
>   data->pkt_tx_buff = kzalloc(size, GFP_KERNEL);
> -
>   if (data->pkt_tx_buff != NULL) {
>   data->pkt_rx_buff = kzalloc(size, GFP_KERNEL);
> -
> - if (data->pkt_rx_buff == NULL) {
> - b_mem_fail = true;
> + if (!data->pkt_rx_buff)
>   kfree(data->pkt_tx_buff);
> - }
> - } else {
> - b_mem_fail = true;
>   }
>
> - if (b_mem_fail) {
> + if (!data->pkt_rx_buff) {
>   /* flush queue and set status of all transfers to -ENOMEM */
> - dev_err(&data->master->dev,
> - "Kzalloc fail in %s messages\n", __func__);
> + dev_err(&data->master->dev, "%s :kzalloc failed\n", __func__);
>   list_for_each_entry(pmsg, data->queue.next, queue) {
>   pmsg->status = -ENOMEM;
>
> @@ -752,39 +585,33 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
>   /* delete from queue */
>   list_del_init(&pmsg->queue);
>   }
> -
>   return;
>   }
>
>   /* copy Tx Data */
> - if ((data->cur_trans->tx_buf) != NULL) {
> + if (data->cur_trans->tx_buf != NULL) {
>   if (*bpw == 8) {
> - for (j = 0; j < (data->bpw_len); j++) {
> - tx_buf = data->cur_trans->tx_buf;
> - data->pkt_tx_buff[j] = tx_buf[j];
> - }
> + tx_buf = data->cur_trans->tx_buf;
> + for (j = 0; j < data->bpw_len; j++)
> + data->pkt_tx_buff[j] = *tx_buf++;
>   } else {
> - for (j = 0; j < (data->bpw_len); j++) {
> - tx_sbuf = data->cur_trans->tx_buf;
> - data->pkt_tx_buff[j] = tx_sbuf[j];
> - }
> + tx_sbuf = data->cur_trans->tx_buf;
> + for (j = 0; j < data->bpw_len; j++)
> + data->pkt_tx_buff[j] = *tx_sbuf++;
>   }
>   }
>
>   /* if len greater than PCH_MAX_FIFO_DEPTH, write 16,else len bytes */
> - if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH)
> + n_writes = data->bpw_len;
> + if (n_writes > PCH_MAX_FIFO_DEPTH)
>   n_writes = PCH_MAX_FIFO_DEPTH;
> - else
> - n_writes = (data->bpw_len);
>
> - dev_dbg(&data->master->dev, "\n%s:Pulling down SSN low - writing "
> + dev_dbg(&data->master->dev, "\n%s:Pulling down SSN low - writing "
>   "0x2 to SSNXCR\n", __func__);
>   pch_spi_writereg(data->master, PCH_SSNXCR, SSN_LOW);
>
> - for (j = 0; j < n_writes; j++) {
> - pch_spi_writereg(data->master, PCH_SPDWR,
> - data->pkt_tx_buff[j]);
> - }
> + for (j = 0; j < n_writes; j++)
> + pch_spi_writereg(data->master, PCH_SPDWR, data->pkt_tx_buff[j]);
>
>   /* update tx_index */
>   data->tx_index = j;
> @@ -798,13 +625,12 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
>  static void pch_spi_nomore_transfer(struct pch_spi_data *data,
>   struct spi_message *pmsg)
>  {
> - dev_dbg(&data->master->dev,
> - "%s:no more transfers in this message\n", __func__);
> + dev_dbg(&data->master->dev, "%s called\n", __func__);
>   /* Invoke complete callback
> - [To the spi core..indicating end of transfer] */
> + * [To the spi core..indicating end of transfer] */
>   data->current_msg->status = 0;
>
> - if ((data->current_msg->complete) != 0) {
> + if (data->current_msg->complete != 0) {
>   dev_dbg(&data->master->dev,
>   "%s:Invoking callback of SPI core\n", __func__);
>   data->current_msg->complete(data->current_msg->context);
> @@ -819,28 +645,26 @@ static void pch_spi_nomore_transfer(struct pch_spi_data *data,
>   data->current_msg = NULL;
>   data->cur_trans = NULL;
>
> - /* check if we have items in list and not suspending */
> - /* return 1 if list empty */
> + /* check if we have items in list and not suspending
> + * return 1 if list empty */
>   if ((list_empty(&data->queue) == 0) &&
> -     (!(data->board_dat->suspend_sts))
> -     && (data->status != STATUS_EXITING)) {
> +     (!data->board_dat->suspend_sts) &&
> +     (data->status != STATUS_EXITING)) {
>   /* We have some more work to do (either there is more tranint
> - bpw;sfer requests in the current message or there are
> - more messages)
> - */
> - dev_dbg(&data->master->dev,
> - "%s:we have pending messages-Invoking queue_work\n",
> - __func__);
> + * bpw;sfer requests in the current message or there are
> + *more messages)
> + */
> + dev_dbg(&data->master->dev, "%s:Invoke queue_work\n", __func__);
>   queue_work(data->wk, &data->work);
> - } else if ((data->board_dat->suspend_sts) ||
> - (data->status == STATUS_EXITING)) {
> + } else if (data->board_dat->suspend_sts ||
> +    data->status == STATUS_EXITING) {
>   dev_dbg(&data->master->dev,
>   "%s suspend/remove initiated, flushing queue\n",
>   __func__);
>   list_for_each_entry(pmsg, data->queue.next, queue) {
>   pmsg->status = -EIO;
>
> - if (pmsg->complete != 0)
> + if (pmsg->complete)
>   pmsg->complete(pmsg->context);
>
>   /* delete from queue */
> @@ -851,30 +675,29 @@ static void pch_spi_nomore_transfer(struct pch_spi_data *data,
>
>  static void pch_spi_set_ir(struct pch_spi_data *data)
>  {
> - u32 reg_spcr_val;
> -
>   /* enable interrupts */
>   if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {
>   /* set receive threhold to PCH_RX_THOLD */
> - pch_spi_set_threshold(data->current_chip, PCH_RX_THOLD, PCH_RX);
> + pch_spi_setclr_reg(data->master, PCH_SPCR,
> +    PCH_RX_THOLD << SPCR_TFIC_FIELD,
> +    ~MASK_TFIC_SPCR_BITS);
>   /* enable FI and RFI interrupts */
> - pch_spi_enable_interrupts(data->master, PCH_RFI | PCH_FI);
> + pch_spi_setclr_reg(data->master, PCH_SPCR,
> +    SPCR_RFIE_BIT | SPCR_TFIE_BIT, 0);
>   } else {
>   /* set receive threhold to maximum */
> - pch_spi_set_threshold(data->current_chip, PCH_RX_THOLD_MAX,
> -       PCH_RX);
> + pch_spi_setclr_reg(data->master, PCH_SPCR,
> +    PCH_RX_THOLD_MAX << SPCR_TFIC_FIELD,
> +    ~MASK_TFIC_SPCR_BITS);
>   /* enable FI interrupt */
> - pch_spi_enable_interrupts(data->master, PCH_FI);
> + pch_spi_setclr_reg(data->master, PCH_SPCR, SPCR_FIE_BIT, 0);
>   }
>
>   dev_dbg(&data->master->dev,
>   "%s:invoking pch_spi_set_enable to enable SPI\n", __func__);
>
>   /* SPI set enable */
> - reg_spcr_val = pch_spi_readreg(data->current_chip->master, PCH_SPCR);
> - pch_set_bitmsk(&reg_spcr_val, SPCR_SPE_BIT);
> - pch_spi_writereg(data->current_chip->master, PCH_SPCR, reg_spcr_val);
> -
> + pch_spi_setclr_reg(data->current_chip->master, PCH_SPCR, SPCR_SPE_BIT, 0);
>
>   /* Wait until the transfer completes; go to sleep after
>   initiating the transfer. */
> @@ -893,9 +716,9 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
>
>   /* clear all interrupts */
>   pch_spi_writereg(data->master, PCH_SPSR,
> - (pch_spi_readreg(data->master, PCH_SPSR)));
> + pch_spi_readreg(data->master, PCH_SPSR));
>   /* disable interrupts */
> - pch_spi_disable_interrupts(data->master, PCH_ALL);
> + pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
>  }
>
>  static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
> @@ -905,19 +728,17 @@ static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
>   u16 *rx_sbuf;
>
>   /* copy Rx Data */
> - if (!(data->cur_trans->rx_buf))
> + if (!data->cur_trans->rx_buf)
>   return;
>
>   if (bpw == 8) {
> - for (j = 0; j < (data->bpw_len); j++) {
> - rx_buf = data->cur_trans->rx_buf;
> - rx_buf[j] = (data->pkt_rx_buff[j]) & 0xFF;
> - }
> + rx_buf = data->cur_trans->rx_buf;
> + for (j = 0; j < data->bpw_len; j++)
> + *rx_buf++ = data->pkt_rx_buff[j] & 0xFF;
>   } else {
> - for (j = 0; j < (data->bpw_len); j++) {
> - rx_sbuf = data->cur_trans->rx_buf;
> - rx_sbuf[j] = data->pkt_rx_buff[j];
> - }
> + rx_sbuf = data->cur_trans->rx_buf;
> + for (j = 0; j < data->bpw_len; j++)
> + *rx_sbuf++ = data->pkt_rx_buff[j];
>   }
>  }
>
> @@ -925,20 +746,20 @@ static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
>  static void pch_spi_process_messages(struct work_struct *pwork)
>  {
>   struct spi_message *pmsg;
> + struct pch_spi_data *data;
>   int bpw;
>
> - struct pch_spi_data *data =
> - container_of(pwork, struct pch_spi_data, work);
>   dev_dbg(&data->master->dev, "%s data initialized\n", __func__);
> + data = container_of(pwork, struct pch_spi_data, work);
>
>   spin_lock(&data->lock);
>
>   /* check if suspend has been initiated;if yes flush queue */
> - if ((data->board_dat->suspend_sts) ||
> - (data->status == STATUS_EXITING)) {
> + if (data->board_dat->suspend_sts || (data->status == STATUS_EXITING)) {
>   dev_dbg(&data->master->dev,
>   "%s suspend/remove initiated,flushing queue\n",
>   __func__);
> +
>   list_for_each_entry(pmsg, data->queue.next, queue) {
>   pmsg->status = -EIO;
>
> @@ -961,8 +782,8 @@ static void pch_spi_process_messages(struct work_struct *pwork)
>   "%s Set data->bcurrent_msg_processing= true\n", __func__);
>
>   /* Get the message from the queue and delete it from there. */
> - data->current_msg =
> - list_entry(data->queue.next, struct spi_message, queue);
> + data->current_msg = list_entry(data->queue.next, struct spi_message,
> + queue);
>
>   list_del_init(&data->current_msg->queue);
>
> @@ -1044,7 +865,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
>
>   spin_unlock(&data->lock);
>
> - } while ((data->cur_trans) != NULL);
> + } while (data->cur_trans != NULL);
>  }
>
>  static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)
> @@ -1063,14 +884,11 @@ static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)
>   /* disable interrupts & free IRQ */
>   if (board_dat->irq_reg_sts) {
>   /* disable interrupts */
> - pch_spi_disable_interrupts(board_dat->data->
> -    master, PCH_ALL);
> - dev_dbg(&board_dat->pdev->dev,
> - "%s pch_spi_disable_interrupts invoked "
> - "successfully\n", __func__);
> + pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
> +    PCH_ALL);
>
>   /* free IRQ */
> - free_irq(board_dat->pdev->irq, (void *)board_dat);
> + free_irq(board_dat->pdev->irq, board_dat);
>
>   dev_dbg(&board_dat->pdev->dev,
>   "%s free_irq invoked successfully\n", __func__);
> @@ -1079,7 +897,7 @@ static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)
>   }
>
>   /* unmap PCI base address */
> - if ((board_dat->data->io_remap_addr) != 0) {
> + if (board_dat->data->io_remap_addr != 0) {
>   pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);
>
>   board_dat->data->io_remap_addr = 0;
> @@ -1104,26 +922,9 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>   int retval;
>   dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
>
> - /* iniatize queue of pending messages */
> - INIT_LIST_HEAD(&(board_dat->data->queue));
> -
> - /* initialize spin locks */
> - spin_lock_init(&(board_dat->data->lock));
> -
> - /* set channel status */
> - board_dat->data->status = STATUS_RUNNING;
> -
> - /* initialize work structure */
> - INIT_WORK(&(board_dat->data->work),
> -   pch_spi_process_messages);
> -
> - /* initialize wait queues */
> - init_waitqueue_head(&(board_dat->data->wait));
> -
>   /* create workqueue */
>   board_dat->data->wk = create_singlethread_workqueue(KBUILD_MODNAME);
> -
> - if ((board_dat->data->wk) == NULL) {
> + if (!board_dat->data->wk) {
>   dev_err(&board_dat->pdev->dev,
>   "%s create_singlet hread_workqueue failed\n", __func__);
>   retval = -EBUSY;
> @@ -1143,7 +944,6 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>   board_dat->pci_req_sts = true;
>
>   io_remap_addr = pci_iomap(board_dat->pdev, 1, 0);
> -
>   if (io_remap_addr == 0) {
>   dev_err(&board_dat->pdev->dev,
>   "%s pci_iomap failed\n", __func__);
> @@ -1161,7 +961,7 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>
>   /* register IRQ */
>   retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
> - IRQF_SHARED, KBUILD_MODNAME, (void *)board_dat);
> +      IRQF_SHARED, KBUILD_MODNAME, board_dat);
>   if (retval != 0) {
>   dev_err(&board_dat->pdev->dev,
>   "%s request_irq failed\n", __func__);
> @@ -1172,8 +972,7 @@ static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
>   __func__, retval);
>
>   board_dat->irq_reg_sts = true;
> - dev_dbg(&board_dat->pdev->dev,
> - "%s data->irq_reg_sts=true\n", __func__);
> + dev_dbg(&board_dat->pdev->dev, "%s data->irq_reg_sts=true\n", __func__);
>
>  err_return:
>   if (retval != 0) {
> @@ -1187,38 +986,6 @@ err_return:
>   return retval;
>  }
>
> -static int pch_spi_check_request_pending(struct pch_spi_board_data *board_dat)
> -{
> - int sts;
> - u16 count;
> -
> - count = 500;
> - spin_lock(&(board_dat->data->lock));
> - board_dat->data->status = STATUS_EXITING;
> -
> - while ((list_empty(&(board_dat->data->queue)) == 0) &&
> -        (--count)) {
> - dev_dbg(&board_dat->pdev->dev,
> - "%s :queue not empty\n", __func__);
> - spin_unlock(&(board_dat->data->lock));
> - msleep(PCH_SLEEP_TIME);
> - spin_lock(&(board_dat->data->lock));
> - }
> -
> - spin_unlock(&(board_dat->data->lock));
> -
> - if (count) {
> - sts = 0;
> - dev_dbg(&board_dat->pdev->dev, "%s :queue empty\n", __func__);
> - } else {
> - sts = -EBUSY;
> - }
> -
> - dev_dbg(&board_dat->pdev->dev, "%s : EXIT=%d\n", __func__, sts);
> -
> - return sts;
> -}
> -
>  static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>
> @@ -1279,12 +1046,17 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   board_dat->data->master = master;
>   board_dat->data->n_curnt_chip = 255;
>   board_dat->data->board_dat = board_dat;
> + board_dat->data->status = STATUS_RUNNING;
> +
> + INIT_LIST_HEAD(&board_dat->data->queue);
> + spin_lock_init(&board_dat->data->lock);
> + INIT_WORK(&board_dat->data->work, pch_spi_process_messages);
> + init_waitqueue_head(&board_dat->data->wait);
>
>   /* allocate resources for PCH SPI */
>   retval = pch_spi_get_resources(board_dat);
> - if (retval != 0) {
> - dev_err(&pdev->dev, "%s fail(retval=%d)\n",
> - __func__, retval);
> + if (retval) {
> + dev_err(&pdev->dev, "%s fail(retval=%d)\n", __func__, retval);
>   goto err_spi_get_resources;
>   }
>
> @@ -1292,7 +1064,7 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   __func__, retval);
>
>   /* save private data in dev */
> - pci_set_drvdata(pdev, (void *)board_dat);
> + pci_set_drvdata(pdev, board_dat);
>   dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
>
>   /* set master mode */
> @@ -1329,6 +1101,7 @@ err_kmalloc:
>  static void pch_spi_remove(struct pci_dev *pdev)
>  {
>   struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
> + int count;
>
>   dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
>
> @@ -1338,19 +1111,23 @@ static void pch_spi_remove(struct pci_dev *pdev)
>   return;
>   }
>
> - /* check for any pending messages */
> - if ((-EBUSY) == pch_spi_check_request_pending(board_dat)) {
> - dev_dbg(&pdev->dev,
> - "%s pch_spi_check_request_pending returned"
> - " EBUSY\n", __func__);
> - /* no need to take any particular action; proceed with remove
> - even though queue is not empty */
> + /* check for any pending messages; no action is taken if the queue
> + * is still full; but at least we tried.  Unload anyway */
> + count = 500;
> + spin_lock(&board_dat->data->lock);
> + board_dat->data->status = STATUS_EXITING;
> + while ((list_empty(&board_dat->data->queue) == 0) && --count) {
> + dev_dbg(&board_dat->pdev->dev, "%s :queue not empty\n",
> + __func__);
> + spin_unlock(&board_dat->data->lock);
> + msleep(PCH_SLEEP_TIME);
> + spin_lock(&board_dat->data->lock);
>   }
> + spin_unlock(&board_dat->data->lock);
>
>   /* Free resources allocated for PCH SPI */
>   pch_spi_free_resources(board_dat);
>
> - /* Unregister SPI master */
>   spi_unregister_master(board_dat->data->master);
>
>   /* free memory for private data */
> @@ -1401,13 +1178,11 @@ static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
>   /* Free IRQ */
>   if (board_dat->irq_reg_sts) {
>   /* disable all interrupts */
> - pch_spi_disable_interrupts(board_dat->data->master, PCH_ALL);
> + pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR, 0,
> +    PCH_ALL);
>   pch_spi_reset(board_dat->data->master);
> - dev_dbg(&pdev->dev,
> - "%s pch_spi_disable_interrupts invoked successfully\n",
> - __func__);
>
> - free_irq(board_dat->pdev->irq, (void *)board_dat);
> + free_irq(board_dat->pdev->irq, board_dat);
>
>   board_dat->irq_reg_sts = false;
>   dev_dbg(&pdev->dev,
> @@ -1471,7 +1246,7 @@ static int pch_spi_resume(struct pci_dev *pdev)
>   pci_enable_wake(pdev, PCI_D3hot, 0);
>
>   /* register IRQ handler */
> - if (!(board->irq_reg_sts)) {
> + if (!board->irq_reg_sts) {
>   /* register IRQ */
>   retval = request_irq(board->pdev->irq, pch_spi_handler,
>        IRQF_SHARED, KBUILD_MODNAME,
> @@ -1518,7 +1293,6 @@ static int __init pch_spi_init(void)
>  }
>  module_init(pch_spi_init);
>
> -
>  static void __exit pch_spi_exit(void)
>  {
>   pci_unregister_driver(&pch_spi_pcidev);
> @@ -1526,4 +1300,4 @@ static void __exit pch_spi_exit(void)
>  module_exit(pch_spi_exit);
>
>  MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("PCH SPI PCI Driver");
> +MODULE_DESCRIPTION("Topcliff PCH SPI PCI Driver");
>


