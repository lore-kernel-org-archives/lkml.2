Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0H0Sdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:33:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35979 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0H0Sds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:33:48 -0400
MIME-Version: 1.0
In-Reply-To: <4C77BD91.9070302@dsn.okisemi.com>
References: <4C77BD91.9070302@dsn.okisemi.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 27 Aug 2010 12:33:27 -0600
X-Google-Sender-Auth: RaUG_xIGVjcFMnBG33PBRkpgvjU
Message-ID: <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Thomas Gleixner and David Woodhouse since this driver needs to
get some data about the platform (to know what spi_devices are
present) and I don't know how that is handled for x86 SoCs.]

Hi Ohtak-san,

Comments below.

2010/8/27 Masayuki Ohtak <masa-korg@dsn.okisemi.com>:
> Hi Grant and Linus Walleij
>
> I have modified your indications.
> Please check below.
> ---
>
> SPI driver of Topcliff PCH
>
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> devices connected to SPI.
>
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---
>  drivers/spi/Kconfig          |   27 +
>  drivers/spi/Makefile         |    3 +
>  drivers/spi/spi_pch.c        | 1686
> ++++++++++++++++++++++++++++++++++++++++++
>  drivers/spi/spi_pch.h        |  179 +++++
>  drivers/spi/spi_pch_device.c |   56 ++
>  5 files changed, 1951 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/spi/spi_pch.c
>  create mode 100644 drivers/spi/spi_pch.h
>  create mode 100644 drivers/spi/spi_pch_device.c
>
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 91c2f4f..ff048b2 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -53,6 +53,33 @@ if SPI_MASTER
>
>  comment "SPI Master Controller Drivers"
>
> +config PCH_SPI
> +	tristate "PCH SPI Controller"
> +	depends on PCI
> +	help
> +	  This driver is for PCH(Platform controller Hub) SPI of Topcliff which
> +	  is an IOH(Input/Output Hub) for x86 embedded processor.
> +	  This driver can access PCH SPI bus device.
> +
> +config PCH_SPI_PLATFORM_DEVICE
> +	boolean
> +	depends on PCH_SPI
> +	default y if PCH_SPI
> +	help
> +	  This driver is for PCH SPI of Topcliff which is an
> +	  IOH(Input/Output Hub) for x86 embedded processor.
> +	  This registers SPI devices for a given board.

This shouldn't be a separate driver.  The SoC platform setup code
should take care of registering the devices which will be on the spi
bus which can be done before the bus device is initialized.

> +
> +config PCH_SPI_PLATFORM_DEVICE_COUNT
> +	int "PCH SPI Bus count"
> +	range 1 2
> +	depends on PCH_SPI_PLATFORM_DEVICE
> +	help
> +	  This driver is for PCH(Platform controller Hub) SPI of Topcliff which
> +	  is an IOH(Input/Output Hub) for x86 embedded processor.
> +	  The number of SPI buses/channels supported by the PCH SPI controller.
> +	  PCH SPI of Topcliff supports only one channel.

Hmmm.  I think I misunderstood the purpose of this symbol in your
initial posting.  This isn't the number of busses (as I originally
thought), but the number of devices registered on the bus.  I should
have read more carefully.  As mentioned above, this shouldn't be
specified in the kernel config or as a separate driver, but I don't
know how you should specify it for x86 SoCs.  I've cc'd Thomas and
David so that they can provide their feedback.

> +
>  config SPI_ATMEL
>  	tristate "Atmel SPI Controller"
>  	depends on (ARCH_AT91 || AVR32)
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index e9cbd18..b07fb5b 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -64,3 +64,6 @@ obj-$(CONFIG_SPI_TLE62X0)	+= tle62x0.o
>
>  # SPI slave drivers (protocol for that link)
>  # 	... add above this line ...
> +obj-$(CONFIG_PCH_SPI_PLATFORM_DEVICE) += spi_pch_device.o
> +obj-$(CONFIG_PCH_SPI) += spi_pch.o
> +
> diff --git a/drivers/spi/spi_pch.c b/drivers/spi/spi_pch.c
> new file mode 100644
> index 0000000..4124238
> --- /dev/null
> +++ b/drivers/spi/spi_pch.c
> @@ -0,0 +1,1686 @@
> +/*

Still need to add a one-line summary of what this file is for.  Something like:

/*
 * SPI bus driver for the Intel Topcliff SoC

> + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307,
> USA.
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/wait.h>
> +#include <linux/spi/spi.h>
> +#include <linux/interrupt.h>
> +#include <linux/sched.h>
> +#include <linux/spi/spidev.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/mutex.h>
> +#include "spi_pch.h"
> +
> +static struct pci_device_id pch_spi_pcidev_id[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_GE_SPI)},
> +	{0,}
> +};
> +
> +static DEFINE_MUTEX(pch_spi_mutex);

Move into private data structure.

> +
> +/**
> + * pch_spi_writereg() - Performs  register writes
> + * @master:	Pointer to struct spi_master.
> + * @idx:	Register offset.
> + * @val:	Value to be written to register.
> + */
> +static inline void pch_spi_writereg(struct spi_master *master, int idx, u32
> val)
> +{
> +
> +	struct pch_spi_data *data = spi_master_get_devdata(master);
> +
> +	iowrite32(val, (data->io_remap_addr + idx));
> +
> +	dev_dbg(&master->dev, "%s Offset=%x Value=%x\n", __func__, idx, val);
> +}
> +
> +/**
> + * pch_spi_readreg() - Performs register reads
> + * @master:	Pointer to struct spi_master.
> + * @idx:	Register offset.
> + */
> +static inline u32 pch_spi_readreg(struct spi_master *master, int idx)
> +{
> +	u32 reg_data;
> +
> +	struct pch_spi_data *data = spi_master_get_devdata(master);
> +
> +	dev_dbg(&master->dev, "%s Offset=%x\n", __func__, idx);
> +	reg_data = ioread32((data->io_remap_addr + idx));
> +
> +	dev_dbg(&master->dev, "%s Content=%x\n", __func__, reg_data);
> +	return reg_data;
> +}
> +
> +static void pch_spi_set_master_mode(struct spi_master *master)
> +{
> +	u32 reg_spcr_val;
> +	reg_spcr_val = pch_spi_readreg(master, PCH_SPCR);
> +	dev_dbg(&master->dev, "%s SPCR content=%x\n", __func__, reg_spcr_val);
> +
> +	/* sets the second bit of SPCR to 1:master mode */
> +	PCH_SET_BITMSK(reg_spcr_val, SPCR_MSTR_BIT);
> +
> +	/* write the value to SPCR register */
> +	pch_spi_writereg(master, PCH_SPCR, reg_spcr_val);
> +	dev_dbg(&master->dev, "%s SPCR after setting MSTR bit=%x\n",
> +		__func__, reg_spcr_val);
> +}
> +
> +/**
> + * ch_spi_disable_interrupts() - Disables specified interrupts
> + * @master:	Pointer to struct spi_master.
> + * @interrupt:	Interrups to be enabled.
> + */
> +static void pch_spi_disable_interrupts(struct spi_master *master, u8
> interrupt)
> +{
> +	u32 reg_val_spcr;
> +
> +	reg_val_spcr = pch_spi_readreg(master, PCH_SPCR);
> +
> +	dev_dbg(&master->dev, "%s SPCR content =%x\n",
> +		__func__, reg_val_spcr);
> +
> +	if (interrupt & PCH_RFI) {
> +		/* clear RFIE bit in SPCR */
> +		dev_dbg(&master->dev,
> +			"%s clearing RFI in pch_spi_disable_interrupts\n",
> +			__func__);
> +		PCH_CLR_BITMSK(reg_val_spcr, SPCR_RFIE_BIT);
> +	}
> +
> +	if (interrupt & PCH_TFI) {
> +		/* clear TFIE bit in SPCR */
> +		dev_dbg(&master->dev,
> +			"%s clearing TFI in pch_spi_disable_interrupts\n",
> +			__func__);
> +		PCH_CLR_BITMSK(reg_val_spcr, SPCR_TFIE_BIT);
> +	}
> +
> +	if (interrupt & PCH_FI) {
> +		/* clear FIE bit in SPCR */
> +		dev_dbg(&master->dev,
> +			"%s clearing FI in pch_spi_disable_interrupts\n",
> +			__func__);
> +		PCH_CLR_BITMSK(reg_val_spcr, SPCR_FIE_BIT);
> +	}
> +
> +	if (interrupt & PCH_ORI) {
> +		/* clear ORIE bit in SPCR */
> +		dev_dbg(&master->dev,
> +			"%s clearing ORI in pch_spi_disable_interrupts\n",
> +			__func__);
> +		PCH_CLR_BITMSK(reg_val_spcr, SPCR_ORIE_BIT);
> +	}
> +
> +	if (interrupt & PCH_MDFI) {
> +		/* clear MODFIE bit in SPCR */
> +		dev_dbg(&master->dev,
> +			"%s clearing MDFI in pch_spi_disable_interrupts\n",
> +			__func__);
> +		PCH_CLR_BITMSK(reg_val_spcr, SPCR_MDFIE_BIT);
> +	}
> +
> +	pch_spi_writereg(master, PCH_SPCR, reg_val_spcr);

This seems overly verbose.  Can this function simply do:

reg_val_spcr = pch_spi_readreg(master, PCH_SPCR);
reg_val_spcr &= ~(interrupts);
pch_spi_writereg(master, PCH_SPCR, reg_val_spcr);


> +
> +	dev_dbg(&master->dev, "%s SPCR after disabling interrupts =%x\n",
> +		__func__, reg_val_spcr);
> +}
> +
> +/**
> + * pch_spi_set_enable() - Sets/Resets the SPE bit in SPCR
> + * @spi:	Pointer to struct spi_device.
> + * @enable:	To enable/disable SPI transfer enable.
> + *		One can provide multiple line descriptions
> + *		for arguments.
> + */
> +static void pch_spi_set_enable(const struct spi_device *spi, u8 enable)

Use 'bool' instead of 'u8' for enable.

> +{
> +	u32 reg_spcr_val;
> +
> +	reg_spcr_val = pch_spi_readreg(spi->master, PCH_SPCR);
> +	dev_dbg(&spi->dev, "%s SPCR content=%x\n", __func__, reg_spcr_val);
> +
> +	if (enable == true) {
> +		dev_dbg(&spi->dev, "%s enable==true\n", __func__);
> +		PCH_SET_BITMSK(reg_spcr_val, SPCR_SPE_BIT);
> +	} else {
> +		dev_dbg(&spi->dev, "%s enable==false\n", __func__);
> +		PCH_CLR_BITMSK(reg_spcr_val, SPCR_SPE_BIT);
> +	}
> +
> +	pch_spi_writereg(spi->master, PCH_SPCR, reg_spcr_val);
> +
> +	dev_dbg(&spi->dev, "%s SPCR content after modifying SPE=%x\n",
> +		__func__, reg_spcr_val);
> +}

This function is only used twice; once to enable and once to disable.
The driver would be clearer if it was simply open coded at callsite.

> +
> +static void pch_spi_callback(struct pch_spi_data *data)
> +{
> +	dev_dbg(&data->master->dev, "%s waking up process\n", __func__);
> +	spin_lock(&data->lock);
> +	data->transfer_complete = true;
> +	wake_up(&data->wait);
> +	dev_dbg(&data->master->dev, "%s invoked wake_up\n", __func__);
> +	spin_unlock(&data->lock);
> +}

Also only called in one place; should be open-coded at call site.

> +static void pch_spi_handler_sub(struct pch_spi_data *data, u32
> reg_spsr_val,
> +				void __iomem *io_remap_addr)
> +{
> +	/* book keeping variables */
> +	u32 n_read, tx_index, rx_index, bpw_len;
> +
> +	/* buffer to store rx/tx data */
> +	u16 *pkt_rx_buffer, *pkt_tx_buff;
> +
> +	/* read/write indices */
> +	int read_cnt;
> +
> +	/* SPSR content */
> +	u32 reg_spcr_val;
> +
> +	/* register addresses */
> +	void __iomem *spsr;
> +	void __iomem *spdrr;
> +	void __iomem *spdwr;
> +
> +	spsr = io_remap_addr + PCH_SPSR;
> +	iowrite32(reg_spsr_val, spsr);
> +
> +	if (data->transfer_active == true) {
> +		rx_index = data->rx_index;
> +		tx_index = data->tx_index;
> +		bpw_len = data->bpw_len;
> +		pkt_rx_buffer = data->pkt_rx_buff;
> +		pkt_tx_buff = data->pkt_tx_buff;
> +
> +		spdrr = io_remap_addr + PCH_SPDRR;
> +		spdwr = io_remap_addr + PCH_SPDWR;
> +
> +		n_read = PCH_READABLE(reg_spsr_val);
> +
> +		for (read_cnt = 0; (read_cnt < n_read);
> +		     read_cnt++) {
> +			/* read data */
> +			pkt_rx_buffer[rx_index++] = ioread32(spdrr);
> +			/* write data */
> +
> +			if (tx_index < bpw_len)
> +				iowrite32(pkt_tx_buff[tx_index++], spdwr);
> +		}
> +
> +		/* disable RFI if not needed */
> +		if ((bpw_len - rx_index) <= PCH_MAX_FIFO_DEPTH) {
> +			reg_spcr_val = ioread32(io_remap_addr + PCH_SPCR);
> +
> +			/* disable RFI */
> +			PCH_CLR_BITMSK(reg_spcr_val, SPCR_RFIE_BIT);
> +
> +			/* reset rx threshold */
> +			reg_spcr_val &= MASK_RFIC_SPCR_BITS;
> +			reg_spcr_val |= (PCH_RX_THOLD_MAX << SPCR_RFIC_FIELD);
> +
> +			iowrite32(PCH_CLR_BITMSK(reg_spcr_val, SPCR_RFIE_BIT),
> +				 (io_remap_addr + PCH_SPCR));
> +		}
> +
> +		/* update counts */
> +		data->tx_index = tx_index;
> +
> +		data->rx_index = rx_index;
> +
> +	}
> +
> +	/* if transfer complete interrupt */
> +	if (reg_spsr_val & SPSR_FI_BIT) {
> +		/* disable FI & RFI interrupts */
> +		pch_spi_disable_interrupts(data->master, PCH_FI | PCH_RFI);
> +
> +		/* transfer is completed;inform
> +			 pch_spi_process_messages */
> +
> +		pch_spi_callback(data);
> +	}
> +}
> +
> +
> +/**
> + * pch_spi_handler() - Interrupt handler
> + * @irq:	The interrupt number.
> + * @dev_id:	Pointer to struct pch_spi_board_data.
> + */
> +static irqreturn_t pch_spi_handler(int irq, void *dev_id)
> +{
> +	/* channel */
> +	int dev;
> +
> +	/* SPSR content */
> +	u32 reg_spsr_val;
> +
> +	/* to hold channel data */
> +	struct pch_spi_data *data;
> +
> +	/* register addresses */
> +	void __iomem *spsr;
> +
> +	/* remapped pci base address */
> +	void __iomem *io_remap_addr;
> +
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	struct pch_spi_board_data *board_dat =
> +					(struct pch_spi_board_data *)dev_id;

Unnecessary cast because dev_id is already void*

> +
> +	if (board_dat->suspend_sts == true) {
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s returning due to suspend\n", __func__);
> +	} else {

Use this form instead to eliminate the unnecessary else nesting:

if (board_dat->suspend_st == true) {
	dev_dbg(...);
	return IRQ_NONE;
}


> +		for (dev = 0; dev < PCH_MAX_DEV; dev++) {
> +			data = board_dat->data[dev];
> +			io_remap_addr = data->io_remap_addr;
> +			spsr = io_remap_addr + PCH_SPSR;
> +
> +			reg_spsr_val = ioread32(spsr);
> +
> +			/* Check if the interrupt is for SPI device */
> +
> +			if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {
> +				pch_spi_handler_sub(data, reg_spsr_val,
> +						    io_remap_addr);
> +				ret = IRQ_HANDLED;
> +			}
> +		}

This looks sub-optimal for two reasons (this is a comment for the
whole driver).  First, PCH_MAX_DEV is hard coded to 1, so the loop is
completely redundant.

Second, if this driver does need to handle multiple spi bus instances,
then it would be better for each bus instance to be registered as a
separate device that is probed and managed separately.  One way to do
this is for the pci_driver to register a child platform_device for
each spi bus, and to put all the spi bus driver code into a
platform_driver which gets it's .probe() hook called for each
instance.

Regardless, it doesn't look liek the "for (dev = 0; dev < PCH_MAX_DEV;
dev++)" loops belong in this driver.

> +	}
> +
> +	dev_dbg(&board_dat->pdev->dev, "%s EXIT return value=%d\n",
> +		__func__, ret);
> +
> +	return ret;
> +}
> +
> +/**
> + * pch_spi_set_baud_rate() - Sets SPBR field in SPBRR
> + * @master:	Pointer to struct spi_master.
> + * @speed_hz:	Baud rate.
> + */
> +static void pch_spi_set_baud_rate(struct spi_master *master, u32 speed_hz)
> +{
> +	u32 n_spbr, spbrr_val;
> +
> +	n_spbr = PCH_CLOCK_HZ / (speed_hz * 2);
> +
> +	/* if baud rate is less than we can support limit it */
> +
> +	if (n_spbr > PCH_MAX_SPBR)
> +		n_spbr = PCH_MAX_SPBR;
> +
> +	spbrr_val = pch_spi_readreg(master, PCH_SPBRR);
> +
> +	dev_dbg(&master->dev, "%s SPBRR content=%x SPBR in SPBRR=%d\n",
> +		__func__, spbrr_val, n_spbr);
> +
> +	/* clear SPBRR */
> +	spbrr_val &= MASK_SPBRR_SPBR_BITS;
> +
> +	/* set the new value */
> +	spbrr_val |= n_spbr;
> +
> +	/* write the new value */
> +	pch_spi_writereg(master, PCH_SPBRR, spbrr_val);
> +	dev_dbg(&master->dev, "%s SPBRR content after setting SPBR=%x\n",
> +		__func__, spbrr_val);
> +}
> +
> +/**
> + * pch_spi_set_bits_per_word() - Sets SIZE field in SPBRR
> + * @master:		Pointer to struct spi_master.
> + * @bits_per_word:	Bits per word for SPI transfer.
> + */
> +static void pch_spi_set_bits_per_word(struct spi_master *master,
> +				      u8 bits_per_word)
> +{
> +	u32 spbrr_val = pch_spi_readreg(master, PCH_SPBRR);
> +	dev_dbg(&master->dev, "%s SPBRR content=%x\n", __func__, spbrr_val);
> +
> +	if (bits_per_word == PCH_8_BPW) {
> +		PCH_CLR_BITMSK(spbrr_val, SPBRR_SIZE_BIT);
> +		dev_dbg(&master->dev, "%s 8\n", __func__);
> +	} else {
> +		PCH_SET_BITMSK(spbrr_val, SPBRR_SIZE_BIT);
> +		dev_dbg(&master->dev, "%s 16\n", __func__);
> +	}

Use the new pch_spi_setclr_bit() function.

> +
> +	pch_spi_writereg(master, PCH_SPBRR, spbrr_val);
> +
> +	dev_dbg(&master->dev, "%s SPBRR after setting bits per word=%x\n",
> +		__func__, spbrr_val);
> +}
> +
> +/**
> + * pch_spi_clear_fifo() - Clears the Transmit and Receive FIFOs
> + * @master:	Pointer to struct spi_master.
> + */
> +static void pch_spi_clear_fifo(struct spi_master *master)
> +{
> +	u32 reg_spcr_val = pch_spi_readreg(master, PCH_SPCR);
> +
> +	PCH_SET_BITMSK(reg_spcr_val, SPCR_FICLR_BIT);
> +	pch_spi_writereg(master, PCH_SPCR, reg_spcr_val);
> +	dev_dbg(&master->dev, "%s SPCR content after setting FICLR  = %x\n",
> +		__func__, reg_spcr_val);
> +
> +	PCH_CLR_BITMSK(reg_spcr_val, SPCR_FICLR_BIT);
> +	pch_spi_writereg(master, PCH_SPCR, reg_spcr_val);
> +
> +	dev_dbg(&master->dev, "%s SPCR content after resetting FICLR  = %x\n",
> +		__func__, reg_spcr_val);
> +}
> +/* ope==true:Set bit, ope==false:Clear bit */
> +static inline void pch_spi_setclr_bit(u32 *val, u32 pos, u32 ope)
> +{
> +	if (ope)
> +		PCH_SET_BITMSK(*val, pos);
> +	else
> +		PCH_CLR_BITMSK(*val, pos);
> +}

Move this function up with your other accessor helpers.

> +
> +/**
> + * pch_spi_setup_transfe() - Configures the PCH SPI hardware for transfer
> + * @spi:	Pointer to struct spi_device.
> + */
> +static void pch_spi_setup_transfer(struct spi_device *spi)
> +{
> +	u32 reg_spcr_val;
> +
> +	dev_dbg(&spi->dev, "%s SPBRR content =%x setting baud rate=%d\n",
> +		__func__, pch_spi_readreg(spi->master, PCH_SPBRR),
> +		spi->max_speed_hz);
> +
> +	pch_spi_set_baud_rate(spi->master, spi->max_speed_hz);
> +
> +	/* set bits per word */
> +	dev_dbg(&spi->dev, "%s :setting bits_per_word=%d\n",
> +		__func__, spi->bits_per_word);
> +	pch_spi_set_bits_per_word(spi->master, spi->bits_per_word);
> +
> +	dev_dbg(&spi->dev,
> +		"%s SPBRR content after setting baud rate & bits per word=%x\n",
> +		__func__, pch_spi_readreg(spi->master, PCH_SPBRR));
> +
> +	reg_spcr_val = pch_spi_readreg(spi->master, PCH_SPCR);
> +	dev_dbg(&spi->dev, "%s SPCR content = %x\n", __func__, reg_spcr_val);
> +	/* set bit justification */
> +	pch_spi_setclr_bit(&reg_spcr_val, SPCR_LSBF_BIT,
> +						!(spi->mode & SPI_LSB_FIRST));
> +	pch_spi_setclr_bit(&reg_spcr_val, SPCR_CPOL_BIT, spi->mode & SPI_CPOL);
> +	pch_spi_setclr_bit(&reg_spcr_val, SPCR_CPHA_BIT, spi->mode & SPI_CPHA);
> +
> +	/* write SPCR SPCR register */
> +	pch_spi_writereg(spi->master, PCH_SPCR, reg_spcr_val);
> +
> +	dev_dbg(&spi->dev,
> +		"%s SPCR content after setting LSB/MSB and MODE= %x\n",
> +		__func__, reg_spcr_val);
> +
> +	/* Clear the FIFO by toggling  FICLR to 1 and back to 0 */
> +	pch_spi_clear_fifo(spi->master);
> +}
> +
> +/**
> + * pch_spi_enable_interrupts() - Enables specified interrupts
> + * @master:	Pointer to struct spi_master.
> + * @interrupt:	Interrups to be enabled.
> + */
> +static void pch_spi_enable_interrupts(struct spi_master *master, u8
> interrupt)
> +{
> +	u32 reg_val_spcr;
> +
> +	reg_val_spcr = pch_spi_readreg(master, PCH_SPCR);
> +
> +	dev_dbg(&master->dev, "%s SPCR content=%x\n", __func__, reg_val_spcr);
> +
> +	if ((interrupt & PCH_RFI) != 0) {
> +		/* set RFIE bit in SPCR */
> +		dev_dbg(&master->dev, "setting RFI in %s\n", __func__);
> +		PCH_SET_BITMSK(reg_val_spcr, SPCR_RFIE_BIT);
> +	}
> +
> +	if ((interrupt & PCH_TFI) != 0) {
> +		/* set TFIE bit in SPCR */
> +		dev_dbg(&master->dev, "setting TFI in %s\n", __func__);
> +		PCH_SET_BITMSK(reg_val_spcr, SPCR_TFIE_BIT);
> +	}
> +
> +	if ((interrupt & PCH_FI) != 0) {
> +		/* set FIE bit in SPCR */
> +		dev_dbg(&master->dev, "setting FI in %s\n", __func__);
> +		PCH_SET_BITMSK(reg_val_spcr, SPCR_FIE_BIT);
> +	}
> +
> +	if ((interrupt & PCH_ORI) != 0) {
> +		/* set ORIE bit in SPCR */
> +		dev_dbg(&master->dev, "setting ORI in %s\n", __func__);
> +		PCH_SET_BITMSK(reg_val_spcr, SPCR_ORIE_BIT);
> +	}
> +
> +	if ((interrupt & PCH_MDFI) != 0) {
> +		/* set MODFIE bit in SPCR */
> +		dev_dbg(&master->dev, "setting MDFI in %s\n", __func__);
> +		PCH_SET_BITMSK(reg_val_spcr, SPCR_MDFIE_BIT);
> +	}
> +
> +	pch_spi_writereg(master, PCH_SPCR, reg_val_spcr);
> +
> +	dev_dbg(&master->dev, "%s SPCR content after enabling interrupt =%x\n",
> +		__func__, reg_val_spcr);
> +}

Simple function called in only two side-by-side locations.  This can
be removed and replaced with about 4 lines open coded at the call
site.

> +
> +/**
> + * pch_spi_set_threshold() - Sets Tx/Rx FIFO thresholds
> + * @spi:	Pointer to struct spi_device.
> + * @threshold:	Threshold value to be set.
> + * @dir:	Rx or Tx threshold to be set.
> + */
> +static void pch_spi_set_threshold(struct spi_device *spi, u32 threshold, u8
> dir)
> +{
> +	u32 reg_val_spcr;
> +
> +	reg_val_spcr = pch_spi_readreg(spi->master, PCH_SPCR);
> +	dev_dbg(&spi->dev, "%s SPCR before modifying =%x threshold=%d\n",
> +		__func__, reg_val_spcr, threshold + 1);
> +
> +	if (dir == PCH_RX) {
> +		dev_dbg(&spi->dev, "%s setting Rx threshold\n", __func__);
> +		reg_val_spcr &= MASK_RFIC_SPCR_BITS;
> +		reg_val_spcr |= (threshold << SPCR_RFIC_FIELD);
> +	} else if (dir == PCH_TX) {
> +		dev_dbg(&spi->dev, "%s setting Tx threshold\n",  __func__);
> +		reg_val_spcr &= MASK_TFIC_SPCR_BITS;
> +		reg_val_spcr |= (threshold << SPCR_TFIC_FIELD);
> +	}
> +
> +	pch_spi_writereg(spi->master, PCH_SPCR, reg_val_spcr);
> +
> +	dev_dbg(&spi->dev, "%s SPCR after modifying =%x\n", __func__,
> +		reg_val_spcr);
> +}
> +
> +/**
> + * pch_spi_reset() - Clears SPI registers
> + * @master:	Pointer to struct spi_master.
> + */
> +static void pch_spi_reset(struct spi_master *master)
> +{
> +	/* write 1 to reset SPI */
> +	pch_spi_writereg(master, PCH_SRST, 0x1);
> +
> +	/* clear reset */
> +	pch_spi_writereg(master, PCH_SRST, 0x0);
> +}
> +
> +static int pch_spi_setup(struct spi_device *pspi)
> +{
> +	/* check bits per word */
> +	if ((pspi->bits_per_word) == 0) {
> +		pspi->bits_per_word = PCH_8_BPW;
> +		dev_dbg(&pspi->dev, "%s 8 bits per word\n", __func__);
> +	}
> +
> +	if (((pspi->bits_per_word) != PCH_8_BPW) &&
> +	    ((pspi->bits_per_word != PCH_16_BPW))) {
> +		dev_err(&pspi->dev, "%s Invalid bits per word\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* Check baud rate setting */
> +	/* if baud rate of chip is greater than
> +	   max we can support,return error */
> +	if ((pspi->max_speed_hz) > PCH_MAX_BAUDRATE) {
> +		dev_err(&pspi->dev, "%s Invalid Baud rate\n", __func__);
> +		return -EINVAL;
> +	}

As mentioned before, if the max speed requested is greater than the
max speed of the bus, then the max bus speed should be used instead.
This should not cause the transfer to fail.

> +
> +	dev_info(&pspi->dev, "%s MODE = %x\n", __func__,
> +		((pspi->mode) & (SPI_CPOL | SPI_CPHA)));

I'd be very surprised if you want to have a kernel log message
generated on each and every spi transfer.

> +
> +	if (((pspi->mode) & SPI_LSB_FIRST) != 0)
> +		dev_dbg(&pspi->dev, "%s LSB_FIRST\n", __func__);
> +	else
> +		dev_dbg(&pspi->dev, "%s MSB_FIRST\n", __func__);
> +
> +	return 0;
> +}
> +
> +static int pch_spi_transfer(struct spi_device *pspi, struct spi_message
> *pmsg)
> +{
> +
> +	struct spi_transfer *transfer;
> +	struct pch_spi_data *data = spi_master_get_devdata(pspi->master);
> +	int retval;
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&pch_spi_mutex);
> +	if (ret) {
> +		retval = -ERESTARTSYS;
> +		goto err_return;
> +	}

The driver shouldn't need the mutex at this point since it is only
validating the message.  Obtaining the mutex can be deferred until
actually adding the transfer to the list later in the function. (right
before obtaining the spinlock)

> +
> +	/* validate spi message and baud rate */
> +	if (unlikely((list_empty(&pmsg->transfers) == 1) ||
> +		     ((pspi->max_speed_hz) == 0))) {
> +		if (list_empty(&pmsg->transfers) == 1)
> +			dev_err(&pspi->dev, "%s list empty\n", __func__);
> +
> +		if ((pspi->max_speed_hz) == 0) {
> +			dev_err(&pspi->dev, "%s pch_spi_tranfer maxspeed=%d\n",
> +				__func__, (pspi->max_speed_hz));
> +		}
> +		dev_err(&pspi->dev, "%s returning EINVAL\n", __func__);
> +
> +		retval = -EINVAL;
> +		goto err_return_mutex;
> +	}
> +
> +	dev_dbg(&pspi->dev, "%s Transfer List not empty. "
> +		"Transfer Speed is set.\n", __func__);
> +
> +	/* validate Tx/Rx buffers and Transfer length */
> +	list_for_each_entry(transfer, &pmsg->transfers,
> +						 transfer_list) {
> +		if ((((transfer->tx_buf) == NULL)
> +		     && ((transfer->rx_buf) == NULL))
> +		    || (transfer->len == 0)) {
> +			if (((transfer->tx_buf) == NULL)
> +			    && ((transfer->rx_buf) == NULL)) {
> +				dev_err(&pspi->dev,
> +					"%s Tx and Rx buffer NULL\n", __func__);
> +			}
> +
> +			if (transfer->len == 0) {
> +				dev_err(&pspi->dev, "%s Transfer"
> +					" length invalid\n", __func__);
> +			}
> +
> +			dev_err(&pspi->dev, "%s returning EINVAL\n", __func__);
> +
> +			retval = -EINVAL;
> +			goto err_return_mutex;
> +		}
> +
> +		dev_dbg(&pspi->dev, "%s Tx/Rx buffer valid. Transfer length"
> +			" valid\n", __func__);
> +
> +		/* if baud rate hs been specified validate the same */
> +		if (transfer->speed_hz) {
> +			if ((transfer->speed_hz) > PCH_MAX_BAUDRATE)
> +				transfer->speed_hz = PCH_MAX_BAUDRATE;
> +		}
> +
> +		/* if bits per word has been specified validate the same */
> +		if (transfer->bits_per_word) {
> +			if ((transfer->bits_per_word != PCH_8_BPW)
> +			    && (transfer->bits_per_word != PCH_16_BPW)) {
> +				retval = -EINVAL;
> +				dev_err(&pspi->dev,
> +					"%s Invalid bits per word\n", __func__);
> +				goto err_return_mutex;
> +			}
> +		}
> +	}
> +
> +	spin_lock(&data->lock);
> +
> +	/* We won't process any messages if we have been asked to terminate */
> +
> +	if (STATUS_EXITING == (data->status)) {
> +		spin_unlock(&data->lock);
> +		dev_err(&pspi->dev, "%s status = STATUS_EXITING.\n", __func__);
> +		retval = -ESHUTDOWN;
> +		goto err_return_spinlock;
> +	}
> +
> +	/* If suspended ,return -EINVAL */
> +	if (data->board_dat->suspend_sts == true) {
> +		dev_err(&pspi->dev,
> +			"%s bSuspending= true returning EINVAL\n", __func__);
> +		spin_unlock(&data->lock);
> +		retval = -EINVAL;
> +		goto err_return_spinlock;
> +	}
> +
> +	/* set status of message */
> +	pmsg->actual_length = 0;
> +
> +	dev_dbg(&pspi->dev, "%s - pmsg->status =%d\n", __func__, pmsg->status);
> +
> +	pmsg->status = -EINPROGRESS;
> +
> +	/* add message to queue */
> +	list_add_tail(&pmsg->queue, &data->queue);
> +
> +	dev_dbg(&pspi->dev, "%s - Invoked list_add_tail\n", __func__);
> +
> +	/* schedule work queue to run */
> +	queue_work(data->wk, &data->work);
> +
> +	dev_dbg(&pspi->dev, "%s - Invoked queue work\n", __func__);
> +
> +	retval = 0;
> +
> +err_return_spinlock:
> +	spin_unlock(&data->lock);
> +err_return_mutex:
> +	mutex_unlock(&pch_spi_mutex);
> +err_return:
> +	dev_dbg(&pspi->dev, "%s RETURN=%d\n", __func__, retval);
> +	return retval;
> +}
> +
> +static void pch_spi_cleanup(struct spi_device *pspi)
> +{
> +	dev_dbg(&pspi->dev, "%s\n", __func__);
> +}

If there are no cleanup operations, then just remove the cleanup hook entirely.

> +
> +static inline void pch_spi_deselect_chip(struct pch_spi_data *data)
> +{
> +	if (data->current_chip != NULL)
> +		data->current_chip = NULL;

Redundant if() statement, and this function is only used once.  Open
code at the call site.

> +}
> +
> +static inline void pch_spi_select_chip(struct pch_spi_data *data,
> +				       struct spi_device *pspi)
> +{
> +	if ((data->current_chip) != NULL) {
> +		if ((pspi->chip_select) != (data->n_curnt_chip)) {
> +			dev_dbg(&pspi->dev,
> +				"%s : different slave-Invoking\n", __func__);
> +			pch_spi_deselect_chip(data);
> +		}
> +	}
> +
> +	data->current_chip = pspi;
> +
> +	data->n_curnt_chip = data->current_chip->chip_select;
> +
> +	dev_dbg(&pspi->dev, "%s :Invoking pch_spi_setup_transfer\n", __func__);
> +	pch_spi_setup_transfer(pspi);
> +}
> +
> +static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,
> +						struct spi_message **ppmsg)
> +{
> +	int b_mem_fail;
> +	int size;
> +	u32 n_writes;
> +	int j;
> +	struct spi_message *pmsg;
> +	pmsg = *ppmsg;
> +
> +	/* set baud rate if needed */
> +	if (data->cur_trans->speed_hz) {
> +		dev_dbg(&data->master->dev,
> +			"%s:pctrldatasetting baud rate\n", __func__);
> +		pch_spi_set_baud_rate(data->master,
> +				      (data->cur_trans->speed_hz));
> +	}
> +
> +	/* set bits per word if needed */
> +	if ((data->cur_trans->bits_per_word) &&
> +	    ((data->current_msg->spi->bits_per_word) !=
> +	     (data->cur_trans->bits_per_word))) {
> +		dev_dbg(&data->master->dev,
> +			"%s:setting bits per word\n", __func__);
> +		pch_spi_set_bits_per_word(data->master,
> +					  (data->cur_trans->
> +					   bits_per_word));
> +		*bpw = data->cur_trans->bits_per_word;
> +	} else {
> +		*bpw = data->current_msg->spi->bits_per_word;
> +	}
> +
> +	/* reset Tx/Rx index */
> +	data->tx_index = 0;
> +
> +	data->rx_index = 0;
> +
> +	if (PCH_8_BPW == *bpw) {
> +		/* 8 bits per word */
> +		data->bpw_len = data->cur_trans->len;
> +	} else {
> +		/* 16 bits per word */
> +		data->bpw_len = (data->cur_trans->len) / 2;
> +	}
> +
> +	b_mem_fail = false;
> +
> +	/* find alloc size */
> +	size = (data->cur_trans->len) *
> +					(sizeof(*(data->pkt_tx_buff)));
> +	/* allocate memory for pkt_tx_buff & pkt_rx_buffer */
> +	data->pkt_tx_buff = kzalloc(size, GFP_KERNEL);
> +
> +	if (data->pkt_tx_buff != NULL) {
> +		data->pkt_rx_buff = kzalloc(size, GFP_KERNEL);
> +
> +		if (data->pkt_rx_buff == NULL) {
> +			b_mem_fail = true;
> +			kfree(data->pkt_tx_buff);
> +		}
> +	} else {
> +		b_mem_fail = true;
> +	}
> +
> +	if (b_mem_fail) {
> +		/* flush queue and set status of all transfers to -ENOMEM */
> +		dev_err(&data->master->dev,
> +			"Kzalloc fail in %s messages\n", __func__);
> +		list_for_each_entry(pmsg, data->queue.next, queue) {
> +			pmsg->status = -ENOMEM;
> +
> +			if (pmsg->complete != 0)
> +				pmsg->complete(pmsg->context);
> +
> +			/* delete from queue */
> +			list_del_init(&pmsg->queue);
> +		}
> +
> +		return;
> +	}
> +
> +	/* copy Tx Data */
> +	if ((data->cur_trans->tx_buf) != NULL) {
> +		if (PCH_8_BPW == *bpw) {
> +			for (j = 0; j < (data->bpw_len); j++)
> +				data->pkt_tx_buff[j] =
> +				    (((u8 *) (data->cur_trans->tx_buf))[j]);
> +		} else {
> +			for (j = 0; j < (data->bpw_len); j++)
> +				data->pkt_tx_buff[j] =
> +				    ((u16 *) (data->cur_trans->tx_buf))[j];
> +		}
> +	}
> +
> +	/* if len greater than PCH_MAX_FIFO_DEPTH, write 16,else len bytes */
> +	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH)
> +		n_writes = PCH_MAX_FIFO_DEPTH;
> +	else
> +		n_writes = (data->bpw_len);
> +
> +	dev_dbg(&data->master->dev,	"\n%s:Pulling down SSN low - writing "
> +		"0x2 to SSNXCR\n", __func__);
> +	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_LOW);
> +
> +	dev_dbg(&data->master->dev,
> +		"\n%s:Writing %u items\n", __func__, n_writes);
> +
> +	for (j = 0; j < n_writes; j++) {
> +		pch_spi_writereg(data->master, PCH_SPDWR,
> +				 data->pkt_tx_buff[j]);
> +	}
> +
> +	/* update tx_index */
> +	data->tx_index = j;
> +	dev_dbg(&data->master->dev, "%s:enabling interrupts\n", __func__);
> +
> +	/* reset transfer complete flag */
> +	data->transfer_complete = false;
> +	data->transfer_active = true;
> +	dev_dbg(&data->master->dev,
> +		"%s set data->transfer_active = true\n", __func__);
> +
> +}
> +
> +
> +static void pch_spi_nomore_transfer(struct pch_spi_data *data,
> +						struct spi_message *pmsg)
> +{
> +	dev_dbg(&data->master->dev,
> +		"%s:no more transfers in this message\n", __func__);
> +	/* Invoke complete callback
> +	 [To the spi core..indicating end of transfer] */
> +	data->current_msg->status = 0;
> +
> +	if ((data->current_msg->complete) != 0) {
> +		dev_dbg(&data->master->dev,
> +			"%s:Invoking callback of SPI core\n", __func__);
> +		data->current_msg->complete(data->current_msg->context);
> +	}
> +
> +	/* update status in global variable */
> +	data->bcurrent_msg_processing = false;
> +
> +	dev_dbg(&data->master->dev,
> +		"%s:data->bcurrent_msg_processing = false\n", __func__);
> +
> +	data->current_msg = NULL;
> +	data->cur_trans = NULL;
> +
> +	/* check if we have items in list and not suspending */
> +	/* return 1 if list empty */
> +	if ((list_empty(&data->queue) == 0) &&
> +	    (data->board_dat->suspend_sts == false)
> +	    && (data->status != STATUS_EXITING)) {
> +		/* We have some more work to do (either there is more tranint
> +			bpw;sfer requests in the current message or there are
> +			more messages)
> +		*/
> +		dev_dbg(&data->master->dev,
> +			"%s:we have pending messages-Invoking queue_work\n",
> +			__func__);
> +		queue_work(data->wk, &data->work);
> +	}
> +
> +	/* check if suspend has been initiated;	if yes flush queue */
> +	else if ((data->board_dat->suspend_sts == true) ||
> +					(data->status == STATUS_EXITING)) {
> +		dev_dbg(&data->master->dev,
> +			"%s suspend/remove initiated, flushing queue\n",
> +			__func__);
> +		list_for_each_entry(pmsg, data->queue.next, queue) {
> +			pmsg->status = -EIO;
> +
> +			if (pmsg->complete != 0)
> +				pmsg->complete(pmsg->context);
> +
> +			/* delete from queue */
> +			list_del_init(&pmsg->queue);
> +		}
> +	}
> +}
> +
> +static void pch_spi_set_ir(struct pch_spi_data *data)
> +{
> +	/* enable interrupts */
> +	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {
> +		/* set receive threhold to PCH_RX_THOLD */
> +		pch_spi_set_threshold(data->current_chip,
> +				      PCH_RX_THOLD,
> +				      PCH_RX);
> +		/* enable FI and RFI interrupts */
> +		pch_spi_enable_interrupts(data->master,
> +					  PCH_RFI |
> +					  PCH_FI);
> +	} else {
> +		/* set receive threhold to maximum */
> +		pch_spi_set_threshold(data->current_chip,
> +				      PCH_RX_THOLD_MAX,
> +				      PCH_RX);
> +		/* enable FI interrupt */
> +		pch_spi_enable_interrupts(data->master,
> +					  PCH_FI);
> +	}
> +
> +	dev_dbg(&data->master->dev,
> +		"%s:invoking pch_spi_set_enable to enable SPI\n", __func__);
> +
> +	pch_spi_set_enable((data->current_chip), true);
> +
> +	/* Wait until the transfer completes; go to sleep after
> +				 initiating the transfer. */
> +	dev_dbg(&data->master->dev,
> +		"%s:waiting for transfer to get over\n", __func__);
> +
> +	wait_event_interruptible(data->wait,
> +					data->transfer_complete != false);
> +
> +	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);
> +	dev_dbg(&data->master->dev,
> +		"%s:no more control over SSN-writing 0x0 to SSNXCR."
> +		"transmit over.", __func__);
> +
> +	data->transfer_active = false;
> +	dev_dbg(&data->master->dev,
> +		"%s set data->transfer_active = false\n", __func__);
> +
> +	/* clear all interrupts */
> +	pch_spi_writereg(data->master, PCH_SPSR,
> +			 (pch_spi_readreg(data->master, PCH_SPSR)));
> +	/* disable interrupts */
> +	pch_spi_disable_interrupts(data->master, PCH_ALL);
> +}
> +
> +static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)
> +{
> +	int j;
> +	/* copy Rx Data */
> +	if (!(data->cur_trans->rx_buf))
> +		return;
> +
> +	if (PCH_8_BPW == bpw) {
> +		for (j = 0; j < (data->bpw_len); j++)
> +			((u8 *) (data->cur_trans->rx_buf))[j] =
> +			    (u8) ((data->pkt_rx_buff[j]) & 0xFF);
> +
> +	} else {
> +		for (j = 0; j < (data->bpw_len); j++)
> +			((u16 *) (data->cur_trans->rx_buf))[j] =
> +			    (u16) (data->pkt_rx_buff[j]);
> +	}
> +}
> +
> +
> +static void pch_spi_process_messages(struct work_struct *pwork)
> +{
> +	struct spi_message *pmsg;
> +	int bpw;
> +
> +	struct pch_spi_data *data =
> +				container_of(pwork, struct pch_spi_data, work);
> +	dev_dbg(&data->master->dev, "%s data initialized\n", __func__);
> +
> +	spin_lock(&data->lock);
> +
> +	/* check if suspend has been initiated;if yes flush queue */
> +	if ((data->board_dat->suspend_sts) ||
> +					(data->status == STATUS_EXITING)) {
> +		dev_dbg(&data->master->dev,
> +			"%s suspend/remove initiated,flushing queue\n",
> +			__func__);
> +		list_for_each_entry(pmsg, data->queue.next, queue) {
> +			pmsg->status = -EIO;
> +
> +			if (pmsg->complete != 0) {
> +				spin_unlock(&data->lock);
> +				pmsg->complete(pmsg->context);
> +				spin_lock(&data->lock);
> +			}
> +
> +			/* delete from queue */
> +			list_del_init(&pmsg->queue);
> +		}
> +
> +		spin_unlock(&data->lock);
> +		return;
> +	}
> +
> +	data->bcurrent_msg_processing = true;
> +	dev_dbg(&data->master->dev,
> +		"%s Set data->bcurrent_msg_processing= true\n", __func__);
> +
> +	/* Get the message from the queue and delete it from there. */
> +	data->current_msg =
> +		list_entry(data->queue.next, struct spi_message, queue);
> +
> +	list_del_init(&data->current_msg->queue);
> +
> +	data->current_msg->status = 0;
> +
> +	pch_spi_select_chip(data, data->current_msg->spi);
> +
> +	spin_unlock(&data->lock);
> +
> +	do {
> +		/* If we are already processing a message get the next
> +		transfer structure from the message otherwise retrieve
> +		the 1st transfer request from the message. */
> +		spin_lock(&data->lock);
> +
> +		if (data->cur_trans == NULL) {
> +			data->cur_trans =
> +			    list_entry(data->current_msg->transfers.
> +				       next, struct spi_transfer,
> +				       transfer_list);
> +			dev_dbg(&data->master->dev,
> +				"%s :Getting 1st transfer message\n", __func__);
> +		} else {
> +			data->cur_trans =
> +			    list_entry(data->cur_trans->
> +				       transfer_list.next,
> +				       struct spi_transfer,
> +				       transfer_list);
> +			dev_dbg(&data->master->dev,
> +				"%s :Getting next transfer message\n",
> +				__func__);
> +		}
> +
> +		spin_unlock(&data->lock);
> +
> +		pch_spi_set_tx(data, &bpw, &pmsg);
> +
> +		/* Control interrupt*/
> +		pch_spi_set_ir(data);
> +
> +		/* Disable SPI transfer */
> +		pch_spi_set_enable((data->current_chip), false);
> +
> +		/* clear FIFO */
> +		pch_spi_clear_fifo(data->master);
> +
> +		/* copy Rx Data */
> +		pch_spi_copy_rx_data(data, bpw);
> +
> +		/* free memory */
> +		kfree(data->pkt_rx_buff);
> +		if (data->pkt_rx_buff)
> +			data->pkt_rx_buff = NULL;
> +
> +		kfree(data->pkt_tx_buff);
> +		if (data->pkt_tx_buff)
> +			data->pkt_tx_buff = NULL;
> +
> +		/* increment message count */
> +		data->current_msg->actual_length +=
> +		    data->cur_trans->len;
> +
> +		dev_dbg(&data->master->dev,
> +			"%s:data->current_msg->actual_length=%d\n",
> +			__func__, data->current_msg->actual_length);
> +
> +		/* check for delay */
> +		if (data->cur_trans->delay_usecs) {
> +			dev_dbg(&data->master->dev, "%s:"
> +				"delay in usec=%d\n", __func__,
> +				data->cur_trans->delay_usecs);
> +			udelay(data->cur_trans->delay_usecs);
> +		}
> +
> +		spin_lock(&data->lock);
> +
> +		/* No more transfer in this message. */
> +		if ((data->cur_trans->transfer_list.next) ==
> +		    &(data->current_msg->transfers)) {
> +			pch_spi_nomore_transfer(data, pmsg);
> +		}
> +
> +		spin_unlock(&data->lock);
> +
> +	} while ((data->cur_trans) != NULL);
> +}
> +
> +static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)
> +{
> +	int i;
> +
> +	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
> +
> +	/* free workqueue */
> +	for (i = 0; i < PCH_MAX_DEV; i++) {
> +		if (board_dat->data[i]->wk != NULL) {
> +			destroy_workqueue(board_dat->data[i]->wk);
> +			board_dat->data[i]->wk = NULL;
> +			dev_dbg(&board_dat->pdev->dev,
> +				"%s destroy_workqueue invoked successfully\n",
> +				__func__);
> +		}
> +	}
> +
> +	/* disable interrupts & free IRQ */
> +	if (board_dat->irq_reg_sts == true) {
> +		/* disable interrupts */
> +		for (i = 0; i < PCH_MAX_DEV; i++) {
> +			pch_spi_disable_interrupts(board_dat->data[i]->
> +						   master, PCH_ALL);
> +			dev_dbg(&board_dat->pdev->dev,
> +				"%s pch_spi_disable_interrupts invoked "
> +				"successfully\n", __func__);
> +		}
> +
> +		/* free IRQ */
> +		free_irq(board_dat->pdev->irq, (void *)board_dat);
> +
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s free_irq invoked successfully\n", __func__);
> +
> +		board_dat->irq_reg_sts = false;
> +	}
> +
> +	/* unmap PCI base address */
> +	if ((board_dat->data[0]->io_remap_addr) != 0) {
> +		pci_iounmap(board_dat->pdev,
> +			    board_dat->data[0]->io_remap_addr);
> +
> +		for (i = 0; i < PCH_MAX_DEV; i++)
> +			board_dat->data[i]->io_remap_addr = 0;
> +
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s pci_iounmap invoked successfully\n", __func__);
> +	}
> +
> +	/* release PCI region */
> +	if (board_dat->pci_req_sts == true) {
> +		pci_release_regions(board_dat->pdev);
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s pci_release_regions invoked successfully\n",
> +			__func__);
> +		board_dat->pci_req_sts = false;
> +	}
> +}
> +
> +static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)
> +{
> +	int i, j, m, n;
> +	void __iomem *io_remap_addr;
> +	int retval;
> +	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);
> +
> +	for (i = 0; i < PCH_MAX_DEV; i++) {
> +		/* iniatize queue of pending messages */
> +		INIT_LIST_HEAD(&(board_dat->data[i]->queue));
> +
> +		/* initialize spin locks */
> +		spin_lock_init(&(board_dat->data[i]->lock));
> +
> +		/* set channel status */
> +		board_dat->data[i]->status = STATUS_RUNNING;
> +
> +		/* initialize work structure */
> +		INIT_WORK(&(board_dat->data[i]->work),
> +			  pch_spi_process_messages);
> +
> +		/* initialize wait queues */
> +		init_waitqueue_head(&(board_dat->data[i]->wait));
> +	}
> +
> +	for (j = 0, retval = 0; j < PCH_MAX_DEV; j++) {
> +		/* create workqueue */
> +		board_dat->data[j]->wk =
> +				    create_singlethread_workqueue(DRIVER_NAME);
> +
> +		if ((board_dat->data[j]->wk) == NULL) {
> +			dev_err(&board_dat->pdev->dev,
> +				"%s create_singlet hread_workqueue failed\n",
> +				__func__);
> +			retval = -EBUSY;
> +			goto err_return;
> +		}
> +	}
> +
> +	if (retval != 0)
> +		goto err_return;
> +
> +	dev_dbg(&board_dat->pdev->dev,
> +		"%s create_singlethread_workqueue success\n", __func__);
> +
> +	retval = pci_request_regions(board_dat->pdev, DRIVER_NAME);
> +	if (retval != 0) {
> +		dev_err(&board_dat->pdev->dev,
> +			"%s request_region failed\n", __func__);
> +		goto err_return;
> +	}
> +
> +	board_dat->pci_req_sts = true;
> +
> +	io_remap_addr = pci_iomap(board_dat->pdev, 1, 0);
> +
> +	if (io_remap_addr == 0) {
> +		dev_err(&board_dat->pdev->dev,
> +			"%s pci_iomap failed\n", __func__);
> +		retval = -ENOMEM;
> +		goto err_return;
> +	}
> +
> +	/* calculate base address for all channels */
> +	for (m = 0; m < PCH_MAX_DEV; m++) {
> +		board_dat->data[m]->io_remap_addr =
> +		    io_remap_addr + (PCH_ADDRESS_SIZE * m);
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s Base address for channel %d= %x\n", __func__, m ,
> +			(u32)(board_dat->data[m]->io_remap_addr));
> +	}
> +
> +	/* reset PCH SPI h/w */
> +	for (n = 0; n < PCH_MAX_DEV; n++) {
> +		pch_spi_reset(board_dat->data[n]->master);
> +		dev_dbg(&board_dat->pdev->dev,
> +			"%s pch_spi_reset invoked successfully\n", __func__);
> +	}
> +
> +	/* register IRQ */
> +	retval = request_irq(board_dat->pdev->irq, pch_spi_handler,
> +			 IRQF_SHARED, DRIVER_NAME, (void *)board_dat);
> +	if (retval != 0) {
> +		dev_err(&board_dat->pdev->dev,
> +			"%s request_irq failed\n", __func__);
> +		goto err_return;
> +	}
> +
> +	dev_dbg(&board_dat->pdev->dev, "%s request_irq returned=%d\n",
> +		__func__, retval);
> +
> +	board_dat->irq_reg_sts = true;
> +	dev_dbg(&board_dat->pdev->dev,
> +		"%s data->irq_reg_sts=true\n", __func__);
> +
> +err_return:
> +	if (retval != 0) {
> +		dev_err(&board_dat->pdev->dev,
> +			"%s FAIL:invoking pch_spi_free_resources\n", __func__);
> +		pch_spi_free_resources(board_dat);
> +	}
> +
> +	dev_dbg(&board_dat->pdev->dev, "%s Return=%d\n", __func__, retval);
> +
> +	return retval;
> +}
> +
> +static int
> +pch_spi_check_request_pending(struct pch_spi_board_data *board_dat)
> +{
> +	int i;
> +	int sts;
> +	u16 count;
> +
> +	for (i = 0; i < PCH_MAX_DEV; i++) {
> +		count = 500;
> +		spin_lock(&(board_dat->data[i]->lock));
> +		board_dat->data[i]->status = STATUS_EXITING;
> +
> +		while ((list_empty(&(board_dat->data[i]->queue)) == 0) &&
> +		       (--count)) {
> +			dev_dbg(&board_dat->pdev->dev,
> +				"%s :queue not empty\n", __func__);
> +			spin_unlock(&(board_dat->data[i]->lock));
> +			msleep(PCH_SLEEP_TIME);
> +			spin_lock(&(board_dat->data[i]->lock));
> +		}
> +
> +		spin_unlock(&(board_dat->data[i]->lock));
> +
> +		if (count) {
> +			sts = 0;
> +			dev_dbg(&board_dat->pdev->dev,
> +				"%s :queue empty\n", __func__);
> +		} else {
> +			sts = -EBUSY;
> +		}
> +	}
> +
> +	dev_dbg(&board_dat->pdev->dev, "%s : EXIT=%d\n", __func__, sts);
> +
> +	return sts;
> +}
> +
> +static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id
> *id)
> +{
> +
> +	struct spi_master *master[PCH_MAX_DEV];
> +
> +	struct pch_spi_board_data *board_dat;
> +	int retval, i, j, k, l, m;

As already mentioned; don't use a separate loop index for each and
every non-nested for-loop.  It is safe to reuse 'i'.

> +	int spi_alloc_num, spi_master_num;
> +
> +	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> +
> +	/* allocate memory for private data */
> +	board_dat = kzalloc(sizeof(struct pch_spi_board_data), GFP_KERNEL);
> +
> +	if (board_dat == NULL) {
> +		dev_err(&pdev->dev,
> +			" %s memory allocation for private data failed\n",
> +			__func__);
> +		retval = -ENOMEM;
> +		goto err_kmalloc;
> +	}
> +
> +	dev_dbg(&pdev->dev,
> +		"%s memory allocation for private data success\n", __func__);
> +
> +	/* enable PCI device */
> +	retval = pci_enable_device(pdev);
> +	if (retval != 0) {
> +		dev_err(&pdev->dev, "%s pci_enable_device FAILED\n", __func__);
> +
> +		goto err_pci_en_device;
> +	}
> +
> +	dev_dbg(&pdev->dev, "%s pci_enable_device returned=%d\n",
> +		__func__, retval);
> +
> +	board_dat->pdev = pdev;
> +
> +	/* alllocate memory for SPI master */
> +	for (i = 0, spi_alloc_num = 0; i < PCH_MAX_DEV; i++, spi_alloc_num++) {
> +		master[i] = spi_alloc_master(&pdev->dev,
> +				     sizeof(struct pch_spi_data));
> +
> +		if (master[i] == NULL) {
> +			retval = -ENOMEM;
> +			dev_err(&pdev->dev, "%s [ch=%d]Fail.\n", __func__, i);
> +			goto err_spi_alloc_master;
> +		}
> +	}
> +
> +	dev_dbg(&pdev->dev,
> +		"%s spi_alloc_master returned non NULL\n", __func__);
> +
> +	/* initialize members of SPI master */
> +	for (j = 0, spi_master_num = 0; j < PCH_MAX_DEV;
> +							j++, spi_master_num++) {
> +		master[j]->bus_num = 0;

bus_num = -1.  Let the spi layer dynamically assign the bus number.
There may also be other SPI busses in the system, so you cannot hard
code bus numbers in this driver anyway.

> +		master[j]->num_chipselect = PCH_MAX_CS;
> +		master[j]->setup = pch_spi_setup;
> +		dev_dbg(&pdev->dev,
> +			"%s setup member of SPI master initialized\n",
> +			__func__);
> +		master[j]->transfer = pch_spi_transfer;
> +		dev_dbg(&pdev->dev,
> +			"%s transfer member of SPI master initialized\n",
> +			__func__);
> +		master[j]->cleanup = pch_spi_cleanup;
> +		dev_dbg(&pdev->dev,
> +			"%s cleanup member of SPI master initialized\n",
> +			__func__);
> +
> +		board_dat->data[j] =
> +				spi_master_get_devdata(master[j]);
> +
> +		board_dat->data[j]->master = master[j];
> +		board_dat->data[j]->n_curnt_chip = 255;
> +		board_dat->data[j]->current_chip = NULL;
> +		board_dat->data[j]->transfer_complete = false;
> +		board_dat->data[j]->pkt_tx_buff = NULL;
> +		board_dat->data[j]->pkt_rx_buff = NULL;
> +		board_dat->data[j]->tx_index = 0;
> +		board_dat->data[j]->rx_index = 0;
> +		board_dat->data[j]->transfer_active = false;
> +		board_dat->data[j]->board_dat = board_dat;
> +		board_dat->suspend_sts = false;
> +
> +		/* Register the controller with the SPI core. */
> +		retval = spi_register_master(master[j]);
> +		if (retval != 0) {
> +			dev_err(&pdev->dev,
> +				"%s spi_register_master FAILED\n", __func__);
> +			goto err_spi_reg_master;
> +		}
> +
> +		dev_dbg(&pdev->dev, "%s spi_register_master returned=%d\n",
> +			__func__, retval);
> +	}

Registering the bus should be the *last* thing that happens.  SPI
transfers can begin the moment the device is registered, so all the
setup code below this point needs to be completed before registering
the bus.

> +
> +	/* allocate resources for PCH SPI */
> +	retval = pch_spi_get_resources(board_dat);
> +	if (retval != 0) {
> +		dev_err(&pdev->dev, "%s fail(retval=%d)\n",
> +			__func__, retval);
> +		goto err_spi_get_resources;
> +	}
> +
> +	dev_dbg(&pdev->dev, "%s pch_spi_get_resources returned=%d\n",
> +		__func__, retval);
> +
> +	/* save private data in dev */
> +	pci_set_drvdata(pdev, (void *)board_dat);
> +	dev_dbg(&pdev->dev, "%s invoked pci_set_drvdata\n", __func__);
> +
> +	/* set master mode */
> +	for (k = 0; k < PCH_MAX_DEV; k++) {
> +		pch_spi_set_master_mode(master[k]);
> +		dev_dbg(&pdev->dev,
> +			"%s invoked pch_spi_set_master_mode\n", __func__);
> +	}
> +
> +	return 0;
> +
> +err_spi_get_resources:
> +	for (l = 0; l <= spi_master_num; l++)
> +		spi_unregister_master(master[l]);
> +err_spi_reg_master:
> +err_spi_alloc_master:
> +	for (m = 0; m <= spi_alloc_num; m++)
> +		spi_master_put(master[m]);
> +	pci_disable_device(pdev);
> +err_pci_en_device:
> +	kfree(board_dat);
> +err_kmalloc:
> +	return retval;
> +}
> +
> +static void pch_spi_remove(struct pci_dev *pdev)
> +{
> +	int i;
> +
> +	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
> +
> +	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> +
> +	if (!board_dat) {
> +		dev_err(&pdev->dev,
> +			"%s pci_get_drvdata returned NULL\n", __func__);
> +		return;
> +	}
> +
> +	/* check for any pending messages */
> +	if ((-EBUSY) == pch_spi_check_request_pending(board_dat)) {
> +		dev_dbg(&pdev->dev,
> +			"%s pch_spi_check_request_pending returned"
> +			" EBUSY\n", __func__);
> +		/* no need to take any particular action; proceed with remove
> +		even though queue is not empty */
> +	}
> +
> +	dev_dbg(&pdev->dev,
> +		"%s pch_spi_check_request_pending invoked\n", __func__);
> +
> +	/* Free resources allocated for PCH SPI */
> +	pch_spi_free_resources(board_dat);
> +	dev_dbg(&pdev->dev,
> +		"%s invoked pch_spi_free_resources\n", __func__);
> +
> +	/* Unregister SPI master */
> +	for (i = 0; i < PCH_MAX_DEV; i++) {
> +		spi_unregister_master(board_dat->data[i]->
> +				      master);
> +		dev_dbg(&pdev->dev,
> +			"%s invoked spi_unregister_master\n", __func__);
> +	}
> +
> +	/* free memory for private data */
> +	kfree(board_dat);
> +
> +	pci_set_drvdata(pdev, NULL);
> +
> +	dev_dbg(&pdev->dev,
> +		"%s memory for private data freed\n", __func__);
> +
> +	/* disable PCI device */
> +	pci_disable_device(pdev);
> +
> +	dev_dbg(&pdev->dev,
> +		"%s invoked pci_disable_device\n", __func__);
> +}
> +
> +#ifdef CONFIG_PM
> +static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	int i;
> +	u8 count;
> +	int retval;
> +
> +	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
> +
> +	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> +
> +	if (!board_dat) {
> +		dev_err(&pdev->dev,
> +			"%s pci_get_drvdata returned NULL\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +	retval = 0;
> +	dev_dbg(&pdev->dev,
> +		"%s pci_get_drvdata invoked successfully\n", __func__);
> +	board_dat->suspend_sts = true;
> +	dev_dbg(&pdev->dev,
> +		"%s board_dat->bSuspending set to true\n", __func__);
> +
> +	/* check if the current message is processed:
> +	   Only after thats done the transfer will be suspended */
> +	for (i = 0; i < PCH_MAX_DEV; i++) {
> +		count = 255;
> +
> +		while ((--count) > 0) {
> +			if (board_dat->data[i]->
> +			    bcurrent_msg_processing == false) {
> +				dev_dbg(&pdev->dev, "%s board_dat->"
> +					"data->bCurrent_"
> +					"msg_processing = false\n",
> +					__func__);
> +				break;
> +			} else {
> +				dev_dbg(&pdev->dev, "%s board_dat->"
> +					"data->bCurrent_msg_"
> +					"processing = true\n",
> +					__func__);
> +			}
> +			msleep(PCH_SLEEP_TIME);
> +		}
> +	}
> +
> +	/* Free IRQ */
> +	if (board_dat->irq_reg_sts == true) {
> +		/* disable all interrupts */
> +		for (i = 0; i < PCH_MAX_DEV; i++) {
> +			pch_spi_disable_interrupts(board_dat->data[i]->
> +						   master,
> +						   PCH_ALL);
> +			pch_spi_reset(board_dat->data[i]->master);
> +			dev_dbg(&pdev->dev,
> +				"%s pch_spi_disable_interrupts invoked"
> +				"successfully\n", __func__);
> +		}
> +
> +		free_irq(board_dat->pdev->irq, (void *)board_dat);
> +
> +		board_dat->irq_reg_sts = false;
> +		dev_dbg(&pdev->dev,
> +			"%s free_irq invoked successfully."
> +			"data->irq_reg_sts = false\n",
> +			__func__);
> +	}
> +
> +	/* save config space */
> +	retval = pci_save_state(pdev);
> +
> +	if (retval == 0) {
> +		dev_dbg(&pdev->dev, "%s pci_save_state returned=%d\n",
> +			__func__, retval);
> +		/* disable PM notifications */
> +		pci_enable_wake(pdev, PCI_D3hot, 0);
> +		dev_dbg(&pdev->dev,
> +			"%s pci_enable_wake invoked successfully\n", __func__);
> +		/* disable PCI device */
> +		pci_disable_device(pdev);
> +		dev_dbg(&pdev->dev,
> +			"%s pci_disable_device invoked successfully\n",
> +			__func__);
> +		/* move device to D3hot  state */
> +		pci_set_power_state(pdev, PCI_D3hot);
> +		dev_dbg(&pdev->dev,
> +			"%s pci_set_power_state invoked successfully\n",
> +			__func__);
> +	} else {
> +		dev_err(&pdev->dev, "%s pci_save_state failed\n", __func__);
> +	}
> +
> +	dev_dbg(&pdev->dev, "%s return=%d\n", __func__, retval);
> +
> +	return retval;
> +}
> +
> +static int pch_spi_resume(struct pci_dev *pdev)
> +{
> +	int i;
> +	int retval;
> +
> +	struct pch_spi_board_data *board_dat = pci_get_drvdata(pdev);
> +	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);
> +
> +	if (!board_dat) {
> +		dev_err(&pdev->dev,
> +			"%s pci_get_drvdata returned NULL\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +	retval = 0;
> +	/* move device to DO power state */
> +	pci_set_power_state(pdev, PCI_D0);
> +
> +	/* restore state */
> +	pci_restore_state(pdev);
> +
> +	retval = pci_enable_device(pdev);
> +	if (retval < 0) {
> +		dev_err(&pdev->dev,
> +			"%s pci_enable_device failed\n", __func__);

if (retval < 0) {
	return retval;
	dev_err(...);
}

> +	} else {
> +		/* disable PM notifications */
> +		pci_enable_wake(pdev, PCI_D3hot, 0);
> +
> +		/* register IRQ handler */
> +		if ((board_dat->irq_reg_sts) != true) {
> +			/* register IRQ */
> +			retval = request_irq(board_dat->pdev->irq,
> +					 pch_spi_handler, IRQF_SHARED,
> +					 DRIVER_NAME, board_dat);
> +			if (retval < 0) {
> +				dev_err(&pdev->dev,
> +					"%s request_irq failed\n", __func__);
> +			} else {
> +				board_dat->irq_reg_sts = true;
> +
> +				/* reset PCH SPI h/w */
> +				for (i = 0; i < PCH_MAX_DEV; i++) {
> +					pch_spi_reset(board_dat->data[i]->
> +						      master);
> +					pch_spi_set_master_mode
> +					    (board_dat->data[i]->master);
> +				}
> +
> +				/* set suspend status to false */
> +				board_dat->suspend_sts = false;
> +
> +			}
> +		}
> +	}
> +
> +	dev_dbg(&pdev->dev, "%s returning=%d\n", __func__, retval);
> +
> +	return retval;
> +}
> +#else
> +#define pch_spi_suspend NULL
> +#define pch_spi_resume NULL
> +
> +#endif
> +
> +static struct pci_driver pch_spi_pcidev = {
> +	.name = "pch_spi",
> +	.id_table = pch_spi_pcidev_id,
> +	.probe = pch_spi_probe,
> +	.remove = pch_spi_remove,
> +	.suspend = pch_spi_suspend,
> +	.resume = pch_spi_resume,
> +};
> +
> +static int __init pch_spi_init(void)
> +{
> +	return pci_register_driver(&pch_spi_pcidev);
> +}
> +
> +
> +static void __exit pch_spi_exit(void)
> +{
> +	pci_unregister_driver(&pch_spi_pcidev);
> +}
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("PCH SPI PCI Driver");
> +module_init(pch_spi_init);
> +module_exit(pch_spi_exit);
> +
> diff --git a/drivers/spi/spi_pch.h b/drivers/spi/spi_pch.h
> new file mode 100644
> index 0000000..aab4411
> --- /dev/null
> +++ b/drivers/spi/spi_pch.h

This header file needs to be rolled into the drivers/spi/spi_pch.c file.

> diff --git a/drivers/spi/spi_pch_device.c b/drivers/spi/spi_pch_device.c
> new file mode 100644
> index 0000000..853aee9
> --- /dev/null
> +++ b/drivers/spi/spi_pch_device.c
> @@ -0,0 +1,56 @@
> +/*
> + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307,
> USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/spi/spidev.h>
> +#include <linux/device.h>
> +#include <linux/spi/spi.h>
> +
> +static struct spi_board_info pch_spi_slaves[] = {
> +	{
> +	 .modalias = "spidev",
> +	 .max_speed_hz = 1000000,
> +	 .bus_num = 0,
> +	 .chip_select = 0,
> +	 .platform_data = NULL,
> +	 .mode = SPI_MODE_0,
> +	 },
> +#if (CONFIG_PCH_SPI_PLATFORM_DEVICE_COUNT == 2)
> +	{
> +	 .modalias = "spidev",
> +	 .max_speed_hz = 1000000,
> +	 .bus_num = 1,
> +	 .chip_select = 1,
> +	 .platform_data = NULL,
> +	 .mode = SPI_MODE_0,
> +	 },
> +#endif
> +};
> +
> +static __init int pch_init(void)
> +{
> +	int rc = -1;
> +
> +	if (!spi_register_board_info
> +	    (pch_spi_slaves, ARRAY_SIZE(pch_spi_slaves)))
> +		rc = 0;
> +
> +	return rc;
> +}

As mentioned at top of email, this is the wrong way to register spi
bus data.  It needs to be done in the platform setup code (need
feedback from tglx and dwmw2 on how best to do this).

g.
