Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab0HSHcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 03:32:01 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39997 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0HSHb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 03:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OzX24EM+YzC+t6qcFqnXjh8zp/uf5TxVSDOp0S37d3Z7/7X94wDLXDkkO7q9Gckgc2
         6kLsoHoJlX7YCc9ApXr6Qb/bj+cLltj6okNsC0DYgr3guRSBHVsiWlWF1j9rEmtY971H
         prlfqM0D1Kaa5eUotH4fK3QKzW1MvlmCkwa4U=
MIME-Version: 1.0
In-Reply-To: <AANLkTikyz_RVcCeKzf9m10xXDyKZm3+Yy7y+axZN+MMx@mail.gmail.com>
References: <4C61EBAC.4000009@dsn.okisemi.com>
	<AANLkTikyz_RVcCeKzf9m10xXDyKZm3+Yy7y+axZN+MMx@mail.gmail.com>
Date: Thu, 19 Aug 2010 09:31:58 +0200
Message-ID: <AANLkTinue_L8-E8Jqz=dZ4jRcE-4=in-Wb7YS=iL0_KM@mail.gmail.com>
Subject: Re: [PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masayuki,

Can't find the orginal patch on LKML or SPI-dev so guess it's on meego-dev.
I have to quote Grants comments to comment...

2010/8/14 Grant Likely <grant.likely@secretlab.ca>:
> 2010/8/10 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:
>>(...)
>> +struct pch_spi_data {
>> +     void __iomem *io_remap_addr;
>> +     struct spi_master *p_master;

p_* is for "pointer" is it not? Hungarian notation is not liked in the
kernel, see Documentation/CodingStyle.

>> +     struct work_struct work;
>> +     struct workqueue_struct *p_wk_q;

Dito.

>> +     wait_queue_head_t wait;
>> +     u8 b_transfer_complete;
>> +     u8 bcurrent_msg_processing;
>> +     spinlock_t lock;
>> +     struct list_head queue;
>> +     u8 status;
>> +     u32 bpw_len;
>> +     s8 b_transfer_active;

This is hungarian notation again, signifying that this s8 (signed!)
should actually be a bool.

Change to bool and drop the b_ prefix.

>> +     u32 tx_index;
>> +     u32 rx_index;
>> +     u16 *pkt_tx_buff;
>> +     u16 *pkt_rx_buff;
>> +     u8 n_curnt_chip;
>> +     struct spi_device *p_current_chip;
>> +     struct spi_message *p_current_msg;
>> +     struct spi_transfer *p_cur_trans;
>> +     struct pch_spi_board_data *p_board_dat;

The hungarian p_* prefix issue again.

>> +};
>> +
>> +/**
>> + * struct pch_spi_board_data - Holds the SPI device specific details
>> + * @pdev:            Pointer to the PCI device
>> + * @irq_reg_sts:     Status of IRQ registration
>> + * @pci_req_sts:     Status of pci_request_regions
>> + * @suspend_sts:     Status of suspend
>> + * @p_data:          Pointer to SPI channel data structure
>> + */
>> +struct pch_spi_board_data {
>> +     struct pci_dev *pdev;

Hungarian p*?

>> +     u8 irq_reg_sts;
>> +     u8 pci_req_sts;
>> +     u8 suspend_sts;
>> +     struct pch_spi_data *p_data[PCH_MAX_DEV];

Hungarian p_*?

>> (...)
>> +/**
>> + * pch_spi_handler() - Interrupt handler
>> + * @irq:     The interrupt number.
>> + * @dev_id:  Pointer to struct pch_spi_board_data.
>> + */
>> +static irqreturn_t pch_spi_handler(int irq, void *dev_id)
>> +{
>> +     /*channel & read/write indices */
>> +     int dev, read_cnt;
>> +
>> +     /*SPSR content */
>> +     u32 reg_spsr_val, reg_spcr_val;
>> +
>> +     /*book keeping variables */
>> +     u32 n_read, tx_index, rx_index, bpw_len;
>> +
>> +     /*to hold channel data */
>> +     struct pch_spi_data *p_data;

Hungarian p_*

>> +
>> +     /*buffer to store rx/tx data */
>> +     u16 *pkt_rx_buffer, *pkt_tx_buff;
>> +
>> +     /*register addresses */
>> +     void __iomem *spsr;
>> +     void __iomem *spdrr;
>> +     void __iomem *spdwr;
>> +
>> +     /*remapped pci base address */
>> +     void __iomem *io_remap_addr;
>> +
>> +     irqreturn_t tRetVal = IRQ_NONE;

Horrible hungarian construct with t* prefix for "type",
And CamlCase. What's wrong with plain "ret"?

> nit: use lowercase for variable names.
>
>> +
>> +     struct pch_spi_board_data *p_board_dat =
>> +                                     (struct pch_spi_board_data *)dev_id;
>> +
>> +     if (p_board_dat->suspend_sts == true) {
>> +             dev_dbg(&p_board_dat->pdev->dev,
>> +                             "%s returning due to suspend\n", __func__);
>> +     } else {
>> +             for (dev = 0; dev < PCH_MAX_DEV; dev++) {
>> +                     p_data = p_board_dat->p_data[dev];
>> +                     io_remap_addr = p_data->io_remap_addr;
>> +                     spsr = io_remap_addr + PCH_SPSR;
>> +
>> +                     reg_spsr_val = ioread32(spsr);
>> +
>> +                     /*Check if the interrupt is for SPI device */
>> +

>From this point...

>> +                     if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
>> +                             dev_dbg(&p_board_dat->pdev->dev,
>> +                               "SPSR in %s=%x\n", __func__, reg_spsr_val);
>> +                             /*clear interrupt */
>> +                             iowrite32(reg_spsr_val, spsr);
>> +
>> +                             if (p_data->b_transfer_active == true) {
>> +                                     rx_index = p_data->rx_index;
>> +                                     tx_index = p_data->tx_index;
>> +                                     bpw_len = p_data->bpw_len;
>> +                                     pkt_rx_buffer = p_data->pkt_rx_buff;
>> +                                     pkt_tx_buff = p_data->pkt_tx_buff;
>> +
>> +                                     spdrr = io_remap_addr + PCH_SPDRR;
>> +                                     spdwr = io_remap_addr + PCH_SPDWR;
>> +
>> +                                     n_read = PCH_READABLE(reg_spsr_val);
>> +
>> +                                     for (read_cnt = 0; (read_cnt < n_read);
>> +                                          read_cnt++) {
>> +                                             /*read data */
>> +                                             pkt_rx_buffer[rx_index++] =
>> +                                                             ioread32(spdrr);
>> +                                             /*write data */
>> +
>> +                                             if (tx_index < bpw_len) {
>> +                                                     iowrite32
>> +                                                         (pkt_tx_buff
>> +                                                          [tx_index++],
>> +                                                          spdwr);
>> +                                             }
>> +                                     }
>> +
>> +                                     /*disable RFI if not needed */
>> +                                     if ((bpw_len - rx_index) <=
>> +                                         PCH_MAX_FIFO_DEPTH) {
>> +                                             dev_dbg(&p_board_dat->pdev->dev,
>> +                                               "%s disabling RFI as data "
>> +                                               "remaining=%d\n", __func__,
>> +                                               (bpw_len - rx_index));
>> +
>> +                                             reg_spcr_val =
>> +                                               ioread32(io_remap_addr +
>> +                                                             PCH_SPCR);
>> +
>> +                                             /*disable RFI */
>> +                                             PCH_CLR_BITMSK(reg_spcr_val,
>> +                                                             SPCR_RFIE_BIT);
>> +
>> +                                             /*reset rx threshold */
>> +                                             reg_spcr_val &=
>> +                                                      MASK_RFIC_SPCR_BITS;
>> +                                             reg_spcr_val |=
>> +                                                     (PCH_RX_THOLD_MAX <<
>> +                                                     SPCR_RFIC_FIELD);
>> +
>> +                                             iowrite32(PCH_CLR_BITMSK
>> +                                                     (reg_spcr_val,
>> +                                                             SPCR_RFIE_BIT),
>> +                                                     (io_remap_addr +
>> +                                                             PCH_SPCR));
>> +                                     }
>> +
>> +                                     /*update counts */
>> +                                     p_data->tx_index = tx_index;
>> +
>> +                                     p_data->rx_index = rx_index;
>> +
>> +                                     dev_dbg(&p_board_dat->pdev->dev,
>> +                                             "%s rx_index=%d tx_index=%d "
>> +                                             "nWritable=%d n_read=%d\n",
>> +                                             __func__, rx_index, tx_index,
>> +                                             (16 -
>> +                                             (PCH_WRITABLE(reg_spsr_val))),
>> +                                             n_read);
>> +
>> +                             }
>> +
>> +                             /*if transfer complete interrupt */
>> +                             if (reg_spsr_val & SPSR_FI_BIT) {
>> +                                     dev_dbg(&p_board_dat->pdev->dev,
>> +                                                     "%s FI bit in SPSR"
>> +                                                     " set\n", __func__);
>> +
>> +                                     /*disable FI & RFI interrupts */
>> +                                     pch_spi_disable_interrupts(p_data->
>> +                                             p_master, PCH_FI | PCH_RFI);
>> +
>> +                                     /*transfer is completed;inform
>> +                                              pch_spi_process_messages */
>> +
>> +                                     if (pch_spi_gcbptr != NULL) {
>> +                                             dev_dbg(&p_board_dat->pdev->dev,
>> +                                               "%s invoking callback\n",
>> +                                               __func__);
>> +                                             (*pch_spi_gcbptr) (p_data);
>> +                                     }
>> +                             }
>> +

To this point you are implementing an arrow antipattern.
For an in-depth explanation see:
http://c2.com/cgi/wiki?ArrowAntiPattern

if (noerror)
        ... much code ...
else
        errorpath

All these should be converted to the form:

if (error)
        errorpath
        return errorcode / goto cleanup

... rest of the code ...

This removes one indent and make the code much easier to
read.

This in combination with the fact that you're obviously running
checkpatch on top and forcing it down to 80 chars/line gives this
weird looking code.

>> +static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id
>> *id)
>> +{
>> +
>> +     struct spi_master *p_master[PCH_MAX_DEV];

Hungarian p_* and even in hungarian it is also wrong because
this is an array of pointers not a plain pointer.

>> +
>> +     struct pch_spi_board_data *p_board_dat;

Hungarian p_*

>> (...)
>> +static int pch_spi_resume(struct pci_dev *pdev)
>> +{
>> +     int i;
>> +     s32 retval;

s32?? What's wrong with an int?

>> +
>> +     struct pch_spi_board_data *p_board_dat = pci_get_drvdata(pdev);
>> +     dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);

Here begins another deep nested arrow antipattern...

>> +     if (p_board_dat == NULL) {
>> +             dev_err(&pdev->dev,
>> +                     "%s pci_get_drvdata returned NULL\n", __func__);
>> +             retval = -EFAULT;

return -EFAULT and de-indent, etc. You know the drill.

>> +     } else {
>> +             retval = 0;
>> +             /* move device to DO power state */
>> +             pci_set_power_state(pdev, PCI_D0);
>> +             dev_dbg(&pdev->dev,
>> +                 "%s pci_set_power_state invoked successfully\n", __func__);
>> +
>> +             /* restore state */
>> +             pci_restore_state(pdev);
>> +             dev_dbg(&pdev->dev,
>> +                 "%s pci_restore_state invoked successfully\n", __func__);
>> +
>> +             retval = pci_enable_device(pdev);
>> +             if (retval < 0) {
>> +                     dev_err(&pdev->dev,
>> +                             "%s pci_enable_device failed\n", __func__);
>> +             } else {
>> +                     dev_dbg(&pdev->dev,
>> +                                     "%s pci_enable_device returned=%d\n",
>> +                                     __func__, retval);
>> +
>> +                     /* disable PM notifications */
>> +                     pci_enable_wake(pdev, PCI_D3hot, 0);
>> +                     dev_dbg(&pdev->dev,
>> +                      "%s pci_enable_wake invoked successfully\n", __func__);
>> +
>> +                     /* register IRQ handler */
>> +                     if ((p_board_dat->irq_reg_sts) != true) {
>> +                             /* register IRQ */
>> +                             retval = request_irq(p_board_dat->pdev->irq,
>> +                                              pch_spi_handler, IRQF_SHARED,
>> +                                              DRIVER_NAME,
>> +                                              p_board_dat);
>> +                             if (retval < 0) {
>> +                                     dev_err(&pdev->dev,
>> +                                        "%s request_irq failed\n", __func__);
>> +                             } else {
>> +                                     dev_dbg(&pdev->dev, "%s request_irq"
>> +                                        " returned=%d\n", __func__, retval);
>> +                                     p_board_dat->irq_reg_sts = true;
>> +
>> +                                     /* reset PCH SPI h/w */
>> +                                     for (i = 0; i < PCH_MAX_DEV; i++) {
>> +                                             pch_spi_reset(p_board_dat->
>> +                                                           p_data[i]->
>> +                                                           p_master);
>> +                                             dev_dbg(&pdev->dev,
>> +                                               "pdev->dev, %s pch_spi_reset "
>> +                                               "invoked successfully\n",
>> +                                               __func__);
>> +                                             pch_spi_set_master_mode
>> +                                                 (p_board_dat->p_data[i]->
>> +                                                  p_master);
>> +                                             dev_dbg(&pdev->dev,
>> +                                               "%s pch_spi_set_master_mode "
>> +                                               "invoked successfully\n",
>> +                                               __func__);
>> +                                     }
>> +
>> +                                     /* set suspend status to false */
>> +                                     p_board_dat->suspend_sts = false;
>> +
>> +                                     dev_dbg(&pdev->dev, "%s set p_board_dat"
>> +                                        "->bSuspending = false\n", __func__);
>> +                             }
>> +                     }
>> +             }
>> +     }

All the way to here.

>> (...)
>> --- /dev/null
>> +++ b/drivers/spi/pch_spi_platform_devices.c
>> @@ -0,0 +1,56 @@
>> +/*
>> + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307,
>> USA.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/spi/spidev.h>
>> +#include <linux/device.h>
>> +#include <linux/spi/spi.h>
>> +
>> +static struct spi_board_info pch_spi_slaves[] = {
>> +     {
>> +      .modalias = "spidev",
>> +      .max_speed_hz = 1000000,
>> +      .bus_num = 0,
>> +      .chip_select = 0,
>> +      .platform_data = NULL,
>> +      .mode = SPI_MODE_0,
>> +      },
>> +#if (CONFIG_PCH_SPI_PLATFORM_DEVICE_COUNT - 1)

What does this #if() actually do?

Since the range in Kconfig is set to 1..2 I *think* this can be
rewritten

#if (CONFIG_PCH_SPI_PLATFORM_DEVICE_COUNT == 2)

Which makes a lot more sense.

>> +     {
>> +      .modalias = "spidev",
>> +      .max_speed_hz = 1000000,
>> +      .bus_num = 1,
>> +      .chip_select = 1,
>> +      .platform_data = NULL,
>> +      .mode = SPI_MODE_0,
>> +      },
>> +#endif
>> +};
>> +
>> +static __init int Load(void)

Rename from "Load" to pch_init or *_init whatever like everyone
else.

>> +{
>> +     int iRetVal = -1;

Hungarian notation.

>> +
>> +     if (!spi_register_board_info
>> +         (pch_spi_slaves, ARRAY_SIZE(pch_spi_slaves)))
>> +             iRetVal = 0;
>> +
>> +     return iRetVal;
>> +}
>> +
>> +module_init(Load);

Yours,
Linus Walleij
