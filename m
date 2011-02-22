Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1BVMAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:00:39 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:24553 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053Ab1BVMAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:00:37 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Cc: <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
References: 
Subject: RE: spi_topcliff_pch: reload issue
Date: Tue, 22 Feb 2011 21:00:32 +0900
Message-ID: <A5A2428223A543BFA446208332996B86@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0078_01CBD2D3.8C7F0C60"
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: 
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcvSLuuVguqATPrzRRqZBrgAILjPkwAVyDyg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0078_01CBD2D3.8C7F0C60
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Previous my question included mistake.
I show modified below.

insmod spi_topcliff_pch.ko(Then, both /dev/spidev0.0/1.0 are created with success) 
rmmod spi_topcliff_pch.ko (Then,  both /dev/spidev0.0/1.0 are NOT deleted.) 
insmod spi_topcliff_pch.ko(Then, kernel error occurred. Attached err_log)

I attached source code(power management is not updated) and kernel error log.

Do you have any information about the above ?

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: Tomoya MORINAGA [mailto:morinaga526@dsn.okisemi.com] 
> Sent: Tuesday, February 22, 2011 10:22 AM
> To: 'David Brownell'; 'Grant Likely'; 
> 'spi-devel-general@lists.sourceforge.net'; 
> 'linux-kernel@vger.kernel.org'
> Cc: 'qi.wang@intel.com'; 'yong.y.wang@intel.com'; 
> 'joel.clark@intel.com'; 'kok.howg.ewe@intel.com'; Toshiharu Okada
> Subject: spi_topcliff_pch: reload issue
> 
> Hi,
> 
> issue: after reload the spi module, it can't do SPI communication.
> 
> We have faced issue when execute the following command.
> insmod xxx.ko(Then, /dev/spidev0.0 is created with success) 
> rmmod xxx.ko (Then, /dev/spidev0.0 is deleted with success) 
> insmod xxx.ko(Then, /dev/spidev0.0 is created, however, below 
> error message is showed)
> 
>   0000:02:0c.1: registered master spi0
>   0000:02:0c.1: chipselect 0 already in use
>   0000:02:0c.1: can't create new device for spidev
> 
> Do you have any information about the above ?
> 
> kernel=2.6.37 on FC14
> 
> With Best Regards,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.

------=_NextPart_000_0078_01CBD2D3.8C7F0C60
Content-Type: text/plain;
	name="spi_topcliff_pch.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="spi_topcliff_pch.c"

/*=0A=
 * SPI bus driver for the Topcliff PCH used by Intel SoCs=0A=
 *=0A=
 * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.=0A=
 *=0A=
 * This program is free software; you can redistribute it and/or modify=0A=
 * it under the terms of the GNU General Public License as published by=0A=
 * the Free Software Foundation; version 2 of the License.=0A=
 *=0A=
 * This program is distributed in the hope that it will be useful,=0A=
 * but WITHOUT ANY WARRANTY; without even the implied warranty of=0A=
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A=
 * GNU General Public License for more details.=0A=
 *=0A=
 * You should have received a copy of the GNU General Public License=0A=
 * along with this program; if not, write to the Free Software=0A=
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, =
USA.=0A=
 */=0A=
=0A=
#include <linux/delay.h>=0A=
#include <linux/pci.h>=0A=
#include <linux/wait.h>=0A=
#include <linux/spi/spi.h>=0A=
#include <linux/interrupt.h>=0A=
#include <linux/sched.h>=0A=
#include <linux/spi/spidev.h>=0A=
#include <linux/module.h>=0A=
#include <linux/device.h>=0A=
#include <linux/platform_device.h>=0A=
=0A=
/* Register offsets */=0A=
#define PCH_SPCR		0x00	/* SPI control register */=0A=
#define PCH_SPBRR		0x04	/* SPI baud rate register */=0A=
#define PCH_SPSR		0x08	/* SPI status register */=0A=
#define PCH_SPDWR		0x0C	/* SPI write data register */=0A=
#define PCH_SPDRR		0x10	/* SPI read data register */=0A=
#define PCH_SSNXCR		0x18	/* SSN Expand Control Register */=0A=
#define PCH_SRST		0x1C	/* SPI reset register */=0A=
#define PCH_SPI_ADDRESS_SIZE	0x20=0A=
=0A=
#define PCH_SPSR_TFD		0x000007C0=0A=
#define PCH_SPSR_RFD		0x0000F800=0A=
=0A=
#define PCH_READABLE(x)		(((x) & PCH_SPSR_RFD)>>11)=0A=
#define PCH_WRITABLE(x)		(((x) & PCH_SPSR_TFD)>>6)=0A=
=0A=
#define PCH_RX_THOLD		7=0A=
#define PCH_RX_THOLD_MAX	15=0A=
=0A=
#define PCH_MAX_BAUDRATE	5000000=0A=
#define PCH_MAX_FIFO_DEPTH	16=0A=
=0A=
#define STATUS_RUNNING		1=0A=
#define STATUS_EXITING		2=0A=
#define PCH_SLEEP_TIME		10=0A=
=0A=
#define PCH_ADDRESS_SIZE	0x20=0A=
=0A=
#define SSN_LOW			0x02U=0A=
#define SSN_NO_CONTROL		0x00U=0A=
#define PCH_MAX_CS		0xFF=0A=
#define PCI_DEVICE_ID_GE_SPI	0x8816=0A=
=0A=
#define SPCR_SPE_BIT		(1 << 0)=0A=
#define SPCR_MSTR_BIT		(1 << 1)=0A=
#define SPCR_LSBF_BIT		(1 << 4)=0A=
#define SPCR_CPHA_BIT		(1 << 5)=0A=
#define SPCR_CPOL_BIT		(1 << 6)=0A=
#define SPCR_TFIE_BIT		(1 << 8)=0A=
#define SPCR_RFIE_BIT		(1 << 9)=0A=
#define SPCR_FIE_BIT		(1 << 10)=0A=
#define SPCR_ORIE_BIT		(1 << 11)=0A=
#define SPCR_MDFIE_BIT		(1 << 12)=0A=
#define SPCR_FICLR_BIT		(1 << 24)=0A=
#define SPSR_TFI_BIT		(1 << 0)=0A=
#define SPSR_RFI_BIT		(1 << 1)=0A=
#define SPSR_FI_BIT		(1 << 2)=0A=
#define SPBRR_SIZE_BIT		(1 << 10)=0A=
=0A=
#define PCH_ALL			=
(SPCR_TFIE_BIT|SPCR_RFIE_BIT|SPCR_FIE_BIT|SPCR_ORIE_BIT|SPCR_MDFIE_BIT)=0A=
=0A=
#define SPCR_RFIC_FIELD		20=0A=
#define SPCR_TFIC_FIELD		16=0A=
=0A=
#define SPSR_INT_BITS		0x1F=0A=
#define MASK_SPBRR_SPBR_BITS	(~((1 << 10) - 1))=0A=
#define MASK_RFIC_SPCR_BITS	(~(0xf << 20))=0A=
#define MASK_TFIC_SPCR_BITS	(~(0xf000f << 12))=0A=
=0A=
#define PCH_CLOCK_HZ		50000000=0A=
#define PCH_MAX_SPBR		1023=0A=
=0A=
/* Definition for ML7213 by OKI SEMICONDUCTOR */=0A=
#define PCI_VENDOR_ID_ROHM		0x10DB=0A=
#define PCI_DEVICE_ID_ML7213_SPI	0x802c=0A=
=0A=
/*=0A=
 * Set the number of SPI instance max=0A=
 * Intel EG20T PCH :		1ch=0A=
 * OKI SEMICONDUCTOR ML7213 IOH :	2ch=0A=
*/=0A=
#define PCH_SPI_MAX_DEV			2=0A=
=0A=
/**=0A=
 * struct pch_spi_data - Holds the SPI channel specific details=0A=
 * @io_remap_addr:		The remapped PCI base address=0A=
 * @master:			Pointer to the SPI master structure=0A=
 * @work:			Reference to work queue handler=0A=
 * @wk:				Workqueue for carrying out execution of the=0A=
 *				requests=0A=
 * @wait:			Wait queue for waking up upon receiving an=0A=
 *				interrupt.=0A=
 * @transfer_complete:		Status of SPI Transfer=0A=
 * @bcurrent_msg_processing:	Status flag for message processing=0A=
 * @lock:			Lock for protecting this structure=0A=
 * @queue:			SPI Message queue=0A=
 * @status:			Status of the SPI driver=0A=
 * @bpw_len:			Length of data to be transferred in bits per=0A=
 *				word=0A=
 * @transfer_active:		Flag showing active transfer=0A=
 * @tx_index:			Transmit data count; for bookkeeping during=0A=
 *				transfer=0A=
 * @rx_index:			Receive data count; for bookkeeping during=0A=
 *				transfer=0A=
 * @tx_buff:			Buffer for data to be transmitted=0A=
 * @rx_index:			Buffer for Received data=0A=
 * @n_curnt_chip:		The chip number that this SPI driver currently=0A=
 *				operates on=0A=
 * @current_chip:		Reference to the current chip that this SPI=0A=
 *				driver currently operates on=0A=
 * @current_msg:		The current message that this SPI driver is=0A=
 *				handling=0A=
 * @cur_trans:			The current transfer that this SPI driver is=0A=
 *				handling=0A=
 * @board_dat:			Reference to the SPI device data structure=0A=
 * @plat_dev:			platform_device structure=0A=
 * @ch:				SPI channel number=0A=
 */=0A=
struct pch_spi_data {=0A=
	void __iomem *io_remap_addr;=0A=
	struct spi_master *master;=0A=
	struct work_struct work;=0A=
	struct workqueue_struct *wk;=0A=
	wait_queue_head_t wait;=0A=
	u8 transfer_complete;=0A=
	u8 bcurrent_msg_processing;=0A=
	spinlock_t lock;=0A=
	struct list_head queue;=0A=
	u8 status;=0A=
	u32 bpw_len;=0A=
	u8 transfer_active;=0A=
	u32 tx_index;=0A=
	u32 rx_index;=0A=
	u16 *pkt_tx_buff;=0A=
	u16 *pkt_rx_buff;=0A=
	u8 n_curnt_chip;=0A=
	struct spi_device *current_chip;=0A=
	struct spi_message *current_msg;=0A=
	struct spi_transfer *cur_trans;=0A=
	struct pch_spi_board_data *board_dat;=0A=
	struct platform_device	*plat_dev;=0A=
	int ch;=0A=
};=0A=
=0A=
/**=0A=
 * struct pch_spi_board_data - Holds the SPI device specific details=0A=
 * @pdev:		Pointer to the PCI device=0A=
 * @irq_reg_sts:	Status of IRQ registration=0A=
 * @pci_req_sts:	Status of pci_request_regions=0A=
 * @suspend_sts:	Status of suspend=0A=
 * @data:		Pointer to SPI channel data structure=0A=
 * @num:		The number of SPI device instance=0A=
 */=0A=
struct pch_spi_board_data {=0A=
	struct pci_dev *pdev;=0A=
	u8 irq_reg_sts;=0A=
	u8 pci_req_sts;=0A=
	u8 suspend_sts;=0A=
	struct pch_spi_data *data;=0A=
	int num;=0A=
};=0A=
=0A=
static struct pci_device_id pch_spi_pcidev_id[] =3D {=0A=
	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },=0A=
	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },=0A=
	{ }=0A=
};=0A=
=0A=
/**=0A=
 * pch_spi_writereg() - Performs  register writes=0A=
 * @master:	Pointer to struct spi_master.=0A=
 * @idx:	Register offset.=0A=
 * @val:	Value to be written to register.=0A=
 */=0A=
static inline void pch_spi_writereg(struct spi_master *master, int idx, =
u32 val)=0A=
{=0A=
	struct pch_spi_data *data =3D spi_master_get_devdata(master);=0A=
	iowrite32(val, (data->io_remap_addr + idx));=0A=
}=0A=
=0A=
/**=0A=
 * pch_spi_readreg() - Performs register reads=0A=
 * @master:	Pointer to struct spi_master.=0A=
 * @idx:	Register offset.=0A=
 */=0A=
static inline u32 pch_spi_readreg(struct spi_master *master, int idx)=0A=
{=0A=
	struct pch_spi_data *data =3D spi_master_get_devdata(master);=0A=
	return ioread32(data->io_remap_addr + idx);=0A=
}=0A=
=0A=
static inline void pch_spi_setclr_reg(struct spi_master *master, int idx,=0A=
				      u32 set, u32 clr)=0A=
{=0A=
	u32 tmp =3D pch_spi_readreg(master, idx);=0A=
	tmp =3D (tmp & ~clr) | set;=0A=
	pch_spi_writereg(master, idx, tmp);=0A=
}=0A=
=0A=
static void pch_spi_set_master_mode(struct spi_master *master)=0A=
{=0A=
	pch_spi_setclr_reg(master, PCH_SPCR, SPCR_MSTR_BIT, 0);=0A=
}=0A=
=0A=
/**=0A=
 * pch_spi_clear_fifo() - Clears the Transmit and Receive FIFOs=0A=
 * @master:	Pointer to struct spi_master.=0A=
 */=0A=
static void pch_spi_clear_fifo(struct spi_master *master)=0A=
{=0A=
	pch_spi_setclr_reg(master, PCH_SPCR, SPCR_FICLR_BIT, 0);=0A=
	pch_spi_setclr_reg(master, PCH_SPCR, 0, SPCR_FICLR_BIT);=0A=
}=0A=
=0A=
static void pch_spi_handler_sub(struct pch_spi_data *data, u32 =
reg_spsr_val,=0A=
				void __iomem *io_remap_addr)=0A=
{=0A=
	u32 n_read, tx_index, rx_index, bpw_len;=0A=
	u16 *pkt_rx_buffer, *pkt_tx_buff;=0A=
	int read_cnt;=0A=
	u32 reg_spcr_val;=0A=
	void __iomem *spsr;=0A=
	void __iomem *spdrr;=0A=
	void __iomem *spdwr;=0A=
=0A=
	spsr =3D io_remap_addr + PCH_SPSR;=0A=
	iowrite32(reg_spsr_val, spsr);=0A=
=0A=
	if (data->transfer_active) {=0A=
		rx_index =3D data->rx_index;=0A=
		tx_index =3D data->tx_index;=0A=
		bpw_len =3D data->bpw_len;=0A=
		pkt_rx_buffer =3D data->pkt_rx_buff;=0A=
		pkt_tx_buff =3D data->pkt_tx_buff;=0A=
=0A=
		spdrr =3D io_remap_addr + PCH_SPDRR;=0A=
		spdwr =3D io_remap_addr + PCH_SPDWR;=0A=
=0A=
		n_read =3D PCH_READABLE(reg_spsr_val);=0A=
=0A=
		for (read_cnt =3D 0; (read_cnt < n_read); read_cnt++) {=0A=
			pkt_rx_buffer[rx_index++] =3D ioread32(spdrr);=0A=
			if (tx_index < bpw_len)=0A=
				iowrite32(pkt_tx_buff[tx_index++], spdwr);=0A=
		}=0A=
=0A=
		/* disable RFI if not needed */=0A=
		if ((bpw_len - rx_index) <=3D PCH_MAX_FIFO_DEPTH) {=0A=
			reg_spcr_val =3D ioread32(io_remap_addr + PCH_SPCR);=0A=
			reg_spcr_val &=3D ~SPCR_RFIE_BIT; /* disable RFI */=0A=
=0A=
			/* reset rx threshold */=0A=
			reg_spcr_val &=3D MASK_RFIC_SPCR_BITS;=0A=
			reg_spcr_val |=3D (PCH_RX_THOLD_MAX << SPCR_RFIC_FIELD);=0A=
			iowrite32(((reg_spcr_val) &=3D (~(SPCR_RFIE_BIT))),=0A=
				 (io_remap_addr + PCH_SPCR));=0A=
		}=0A=
=0A=
		/* update counts */=0A=
		data->tx_index =3D tx_index;=0A=
		data->rx_index =3D rx_index;=0A=
=0A=
	}=0A=
=0A=
	/* if transfer complete interrupt */=0A=
	if (reg_spsr_val & SPSR_FI_BIT) {=0A=
		/* disable FI & RFI interrupts */=0A=
		pch_spi_setclr_reg(data->master, PCH_SPCR, 0,=0A=
				   SPCR_FIE_BIT | SPCR_RFIE_BIT);=0A=
=0A=
		/* transfer is completed;inform pch_spi_process_messages */=0A=
		data->transfer_complete =3D true;=0A=
		wake_up(&data->wait);=0A=
	}=0A=
}=0A=
=0A=
/**=0A=
 * pch_spi_handler() - Interrupt handler=0A=
 * @irq:	The interrupt number.=0A=
 * @dev_id:	Pointer to struct pch_spi_board_data.=0A=
 */=0A=
static irqreturn_t pch_spi_handler(int irq, void *dev_id)=0A=
{=0A=
	u32 reg_spsr_val;=0A=
	struct pch_spi_data *data;=0A=
	void __iomem *spsr;=0A=
	void __iomem *io_remap_addr;=0A=
	irqreturn_t ret =3D IRQ_NONE;=0A=
	struct pch_spi_board_data *board_dat =3D dev_id;=0A=
=0A=
	if (board_dat->suspend_sts) {=0A=
		dev_dbg(&board_dat->pdev->dev,=0A=
			"%s returning due to suspend\n", __func__);=0A=
		return IRQ_NONE;=0A=
	}=0A=
=0A=
	data =3D board_dat->data;=0A=
	io_remap_addr =3D data->io_remap_addr;=0A=
	spsr =3D io_remap_addr + PCH_SPSR;=0A=
	reg_spsr_val =3D ioread32(spsr);=0A=
=0A=
	/* Check if the interrupt is for SPI device */=0A=
	if (reg_spsr_val & (SPSR_FI_BIT | SPSR_RFI_BIT)) {=0A=
		pch_spi_handler_sub(data, reg_spsr_val, io_remap_addr);=0A=
		ret =3D IRQ_HANDLED;=0A=
	}=0A=
=0A=
	dev_dbg(&board_dat->pdev->dev, "%s EXIT return value=3D%d\n",=0A=
		__func__, ret);=0A=
	return ret;=0A=
}=0A=
=0A=
/**=0A=
 * pch_spi_set_baud_rate() - Sets SPBR field in SPBRR=0A=
 * @master:	Pointer to struct spi_master.=0A=
 * @speed_hz:	Baud rate.=0A=
 */=0A=
static void pch_spi_set_baud_rate(struct spi_master *master, u32 =
speed_hz)=0A=
{=0A=
	u32 n_spbr =3D PCH_CLOCK_HZ / (speed_hz * 2);=0A=
=0A=
	/* if baud rate is less than we can support limit it */=0A=
	if (n_spbr > PCH_MAX_SPBR)=0A=
		n_spbr =3D PCH_MAX_SPBR;=0A=
=0A=
	pch_spi_setclr_reg(master, PCH_SPBRR, n_spbr, ~MASK_SPBRR_SPBR_BITS);=0A=
}=0A=
=0A=
/**=0A=
 * pch_spi_set_bits_per_word() - Sets SIZE field in SPBRR=0A=
 * @master:		Pointer to struct spi_master.=0A=
 * @bits_per_word:	Bits per word for SPI transfer.=0A=
 */=0A=
static void pch_spi_set_bits_per_word(struct spi_master *master,=0A=
				      u8 bits_per_word)=0A=
{=0A=
	if (bits_per_word =3D=3D 8)=0A=
		pch_spi_setclr_reg(master, PCH_SPBRR, 0, SPBRR_SIZE_BIT);=0A=
	else=0A=
		pch_spi_setclr_reg(master, PCH_SPBRR, SPBRR_SIZE_BIT, 0);=0A=
}=0A=
=0A=
/**=0A=
 * pch_spi_setup_transfer() - Configures the PCH SPI hardware for =
transfer=0A=
 * @spi:	Pointer to struct spi_device.=0A=
 */=0A=
static void pch_spi_setup_transfer(struct spi_device *spi)=0A=
{=0A=
	u32 flags =3D 0;=0A=
=0A=
	dev_dbg(&spi->dev, "%s SPBRR content =3D%x setting baud rate=3D%d\n",=0A=
		__func__, pch_spi_readreg(spi->master, PCH_SPBRR),=0A=
		spi->max_speed_hz);=0A=
	pch_spi_set_baud_rate(spi->master, spi->max_speed_hz);=0A=
=0A=
	/* set bits per word */=0A=
	pch_spi_set_bits_per_word(spi->master, spi->bits_per_word);=0A=
=0A=
	if (!(spi->mode & SPI_LSB_FIRST))=0A=
		flags |=3D SPCR_LSBF_BIT;=0A=
	if (spi->mode & SPI_CPOL)=0A=
		flags |=3D SPCR_CPOL_BIT;=0A=
	if (spi->mode & SPI_CPHA)=0A=
		flags |=3D SPCR_CPHA_BIT;=0A=
	pch_spi_setclr_reg(spi->master, PCH_SPCR, flags,=0A=
			   (SPCR_LSBF_BIT | SPCR_CPOL_BIT | SPCR_CPHA_BIT));=0A=
=0A=
	/* Clear the FIFO by toggling  FICLR to 1 and back to 0 */=0A=
	pch_spi_clear_fifo(spi->master);=0A=
}=0A=
=0A=
/**=0A=
 * pch_spi_reset() - Clears SPI registers=0A=
 * @master:	Pointer to struct spi_master.=0A=
 */=0A=
static void pch_spi_reset(struct spi_master *master)=0A=
{=0A=
	/* write 1 to reset SPI */=0A=
	pch_spi_writereg(master, PCH_SRST, 0x1);=0A=
=0A=
	/* clear reset */=0A=
	pch_spi_writereg(master, PCH_SRST, 0x0);=0A=
}=0A=
=0A=
static int pch_spi_setup(struct spi_device *pspi)=0A=
{=0A=
	/* check bits per word */=0A=
	if (pspi->bits_per_word =3D=3D 0) {=0A=
		pspi->bits_per_word =3D 8;=0A=
		dev_dbg(&pspi->dev, "%s 8 bits per word\n", __func__);=0A=
	}=0A=
=0A=
	if ((pspi->bits_per_word !=3D 8) && (pspi->bits_per_word !=3D 16)) {=0A=
		dev_err(&pspi->dev, "%s Invalid bits per word\n", __func__);=0A=
		return -EINVAL;=0A=
	}=0A=
=0A=
	/* Check baud rate setting */=0A=
	/* if baud rate of chip is greater than=0A=
	   max we can support,return error */=0A=
	if ((pspi->max_speed_hz) > PCH_MAX_BAUDRATE)=0A=
		pspi->max_speed_hz =3D PCH_MAX_BAUDRATE;=0A=
=0A=
	dev_dbg(&pspi->dev, "%s MODE =3D %x\n", __func__,=0A=
		(pspi->mode) & (SPI_CPOL | SPI_CPHA));=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
static int pch_spi_transfer(struct spi_device *pspi, struct spi_message =
*pmsg)=0A=
{=0A=
=0A=
	struct spi_transfer *transfer;=0A=
	struct pch_spi_data *data =3D spi_master_get_devdata(pspi->master);=0A=
	int retval;=0A=
	unsigned long flags;=0A=
=0A=
	/* validate spi message and baud rate */=0A=
	if (unlikely(list_empty(&pmsg->transfers) =3D=3D 1)) {=0A=
		dev_err(&pspi->dev, "%s list empty\n", __func__);=0A=
		retval =3D -EINVAL;=0A=
		goto err_out;=0A=
	}=0A=
=0A=
	if (unlikely(pspi->max_speed_hz =3D=3D 0)) {=0A=
		dev_err(&pspi->dev, "%s pch_spi_tranfer maxspeed=3D%d\n",=0A=
			__func__, pspi->max_speed_hz);=0A=
		retval =3D -EINVAL;=0A=
		goto err_out;=0A=
	}=0A=
=0A=
	dev_dbg(&pspi->dev, "%s Transfer List not empty. "=0A=
		"Transfer Speed is set.\n", __func__);=0A=
=0A=
	/* validate Tx/Rx buffers and Transfer length */=0A=
	list_for_each_entry(transfer, &pmsg->transfers, transfer_list) {=0A=
		if (!transfer->tx_buf && !transfer->rx_buf) {=0A=
			dev_err(&pspi->dev,=0A=
				"%s Tx and Rx buffer NULL\n", __func__);=0A=
			retval =3D -EINVAL;=0A=
			goto err_out;=0A=
		}=0A=
=0A=
		if (!transfer->len) {=0A=
			dev_err(&pspi->dev, "%s Transfer length invalid\n",=0A=
				__func__);=0A=
			retval =3D -EINVAL;=0A=
			goto err_out;=0A=
		}=0A=
=0A=
		dev_dbg(&pspi->dev, "%s Tx/Rx buffer valid. Transfer length"=0A=
			" valid\n", __func__);=0A=
=0A=
		/* if baud rate hs been specified validate the same */=0A=
		if (transfer->speed_hz > PCH_MAX_BAUDRATE)=0A=
			transfer->speed_hz =3D PCH_MAX_BAUDRATE;=0A=
=0A=
		/* if bits per word has been specified validate the same */=0A=
		if (transfer->bits_per_word) {=0A=
			if ((transfer->bits_per_word !=3D 8)=0A=
			    && (transfer->bits_per_word !=3D 16)) {=0A=
				retval =3D -EINVAL;=0A=
				dev_err(&pspi->dev,=0A=
					"%s Invalid bits per word\n", __func__);=0A=
				goto err_out;=0A=
			}=0A=
		}=0A=
	}=0A=
	spin_lock_irqsave(&data->lock, flags);=0A=
=0A=
	/* We won't process any messages if we have been asked to terminate */=0A=
	if (data->status =3D=3D STATUS_EXITING) {=0A=
		dev_err(&pspi->dev, "%s status =3D STATUS_EXITING.\n", __func__);=0A=
		retval =3D -ESHUTDOWN;=0A=
		goto err_return_spinlock;=0A=
	}=0A=
=0A=
	/* If suspended ,return -EINVAL */=0A=
	if (data->board_dat->suspend_sts) {=0A=
		dev_err(&pspi->dev, "%s suspend; returning EINVAL\n", __func__);=0A=
		retval =3D -EINVAL;=0A=
		goto err_return_spinlock;=0A=
	}=0A=
=0A=
	/* set status of message */=0A=
	pmsg->actual_length =3D 0;=0A=
	dev_dbg(&pspi->dev, "%s - pmsg->status =3D%d\n", __func__, =
pmsg->status);=0A=
=0A=
	pmsg->status =3D -EINPROGRESS;=0A=
=0A=
	/* add message to queue */=0A=
	list_add_tail(&pmsg->queue, &data->queue);=0A=
	dev_dbg(&pspi->dev, "%s - Invoked list_add_tail\n", __func__);=0A=
=0A=
	/* schedule work queue to run */=0A=
	queue_work(data->wk, &data->work);=0A=
	dev_dbg(&pspi->dev, "%s - Invoked queue work\n", __func__);=0A=
=0A=
	retval =3D 0;=0A=
=0A=
err_return_spinlock:=0A=
	spin_unlock_irqrestore(&data->lock, flags);=0A=
err_out:=0A=
	dev_dbg(&pspi->dev, "%s RETURN=3D%d\n", __func__, retval);=0A=
	return retval;=0A=
}=0A=
=0A=
static inline void pch_spi_select_chip(struct pch_spi_data *data,=0A=
				       struct spi_device *pspi)=0A=
{=0A=
	if (data->current_chip !=3D NULL) {=0A=
		if (pspi->chip_select !=3D data->n_curnt_chip) {=0A=
			dev_dbg(&pspi->dev, "%s : different slave\n", __func__);=0A=
			data->current_chip =3D NULL;=0A=
		}=0A=
	}=0A=
=0A=
	data->current_chip =3D pspi;=0A=
=0A=
	data->n_curnt_chip =3D data->current_chip->chip_select;=0A=
=0A=
	dev_dbg(&pspi->dev, "%s :Invoking pch_spi_setup_transfer\n", __func__);=0A=
	pch_spi_setup_transfer(pspi);=0A=
}=0A=
=0A=
static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw,=0A=
			   struct spi_message **ppmsg)=0A=
{=0A=
	int size;=0A=
	u32 n_writes;=0A=
	int j;=0A=
	struct spi_message *pmsg;=0A=
	const u8 *tx_buf;=0A=
	const u16 *tx_sbuf;=0A=
=0A=
	pmsg =3D *ppmsg;=0A=
=0A=
	/* set baud rate if needed */=0A=
	if (data->cur_trans->speed_hz) {=0A=
		dev_dbg(&data->master->dev, "%s:setting baud rate\n", __func__);=0A=
		pch_spi_set_baud_rate(data->master, data->cur_trans->speed_hz);=0A=
	}=0A=
=0A=
	/* set bits per word if needed */=0A=
	if (data->cur_trans->bits_per_word &&=0A=
	    (data->current_msg->spi->bits_per_word !=3D =
data->cur_trans->bits_per_word)) {=0A=
		dev_dbg(&data->master->dev, "%s:set bits per word\n", __func__);=0A=
		pch_spi_set_bits_per_word(data->master,=0A=
					  data->cur_trans->bits_per_word);=0A=
		*bpw =3D data->cur_trans->bits_per_word;=0A=
	} else {=0A=
		*bpw =3D data->current_msg->spi->bits_per_word;=0A=
	}=0A=
=0A=
	/* reset Tx/Rx index */=0A=
	data->tx_index =3D 0;=0A=
	data->rx_index =3D 0;=0A=
=0A=
	data->bpw_len =3D data->cur_trans->len / (*bpw / 8);=0A=
=0A=
	/* find alloc size */=0A=
	size =3D data->cur_trans->len * sizeof(*data->pkt_tx_buff);=0A=
=0A=
	/* allocate memory for pkt_tx_buff & pkt_rx_buffer */=0A=
	data->pkt_tx_buff =3D kzalloc(size, GFP_KERNEL);=0A=
	if (data->pkt_tx_buff !=3D NULL) {=0A=
		data->pkt_rx_buff =3D kzalloc(size, GFP_KERNEL);=0A=
		if (!data->pkt_rx_buff)=0A=
			kfree(data->pkt_tx_buff);=0A=
	}=0A=
=0A=
	if (!data->pkt_rx_buff) {=0A=
		/* flush queue and set status of all transfers to -ENOMEM */=0A=
		dev_err(&data->master->dev, "%s :kzalloc failed\n", __func__);=0A=
		list_for_each_entry(pmsg, data->queue.next, queue) {=0A=
			pmsg->status =3D -ENOMEM;=0A=
=0A=
			if (pmsg->complete !=3D 0)=0A=
				pmsg->complete(pmsg->context);=0A=
=0A=
			/* delete from queue */=0A=
			list_del_init(&pmsg->queue);=0A=
		}=0A=
		return;=0A=
	}=0A=
=0A=
	/* copy Tx Data */=0A=
	if (data->cur_trans->tx_buf !=3D NULL) {=0A=
		if (*bpw =3D=3D 8) {=0A=
			tx_buf =3D data->cur_trans->tx_buf;=0A=
			for (j =3D 0; j < data->bpw_len; j++)=0A=
				data->pkt_tx_buff[j] =3D *tx_buf++;=0A=
		} else {=0A=
			tx_sbuf =3D data->cur_trans->tx_buf;=0A=
			for (j =3D 0; j < data->bpw_len; j++)=0A=
				data->pkt_tx_buff[j] =3D *tx_sbuf++;=0A=
		}=0A=
	}=0A=
=0A=
	/* if len greater than PCH_MAX_FIFO_DEPTH, write 16,else len bytes */=0A=
	n_writes =3D data->bpw_len;=0A=
	if (n_writes > PCH_MAX_FIFO_DEPTH)=0A=
		n_writes =3D PCH_MAX_FIFO_DEPTH;=0A=
=0A=
	dev_dbg(&data->master->dev, "\n%s:Pulling down SSN low - writing "=0A=
		"0x2 to SSNXCR\n", __func__);=0A=
	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_LOW);=0A=
=0A=
	for (j =3D 0; j < n_writes; j++)=0A=
		pch_spi_writereg(data->master, PCH_SPDWR, data->pkt_tx_buff[j]);=0A=
=0A=
	/* update tx_index */=0A=
	data->tx_index =3D j;=0A=
=0A=
	/* reset transfer complete flag */=0A=
	data->transfer_complete =3D false;=0A=
	data->transfer_active =3D true;=0A=
}=0A=
=0A=
=0A=
static void pch_spi_nomore_transfer(struct pch_spi_data *data,=0A=
						struct spi_message *pmsg)=0A=
{=0A=
	dev_dbg(&data->master->dev, "%s called\n", __func__);=0A=
	/* Invoke complete callback=0A=
	 * [To the spi core..indicating end of transfer] */=0A=
	data->current_msg->status =3D 0;=0A=
=0A=
	if (data->current_msg->complete !=3D 0) {=0A=
		dev_dbg(&data->master->dev,=0A=
			"%s:Invoking callback of SPI core\n", __func__);=0A=
		data->current_msg->complete(data->current_msg->context);=0A=
	}=0A=
=0A=
	/* update status in global variable */=0A=
	data->bcurrent_msg_processing =3D false;=0A=
=0A=
	dev_dbg(&data->master->dev,=0A=
		"%s:data->bcurrent_msg_processing =3D false\n", __func__);=0A=
=0A=
	data->current_msg =3D NULL;=0A=
	data->cur_trans =3D NULL;=0A=
=0A=
	/* check if we have items in list and not suspending=0A=
	 * return 1 if list empty */=0A=
	if ((list_empty(&data->queue) =3D=3D 0) &&=0A=
	    (!data->board_dat->suspend_sts) &&=0A=
	    (data->status !=3D STATUS_EXITING)) {=0A=
		/* We have some more work to do (either there is more tranint=0A=
		 * bpw;sfer requests in the current message or there are=0A=
		 *more messages)=0A=
		 */=0A=
		dev_dbg(&data->master->dev, "%s:Invoke queue_work\n", __func__);=0A=
		queue_work(data->wk, &data->work);=0A=
	} else if (data->board_dat->suspend_sts ||=0A=
		   data->status =3D=3D STATUS_EXITING) {=0A=
		dev_dbg(&data->master->dev,=0A=
			"%s suspend/remove initiated, flushing queue\n",=0A=
			__func__);=0A=
		list_for_each_entry(pmsg, data->queue.next, queue) {=0A=
			pmsg->status =3D -EIO;=0A=
=0A=
			if (pmsg->complete)=0A=
				pmsg->complete(pmsg->context);=0A=
=0A=
			/* delete from queue */=0A=
			list_del_init(&pmsg->queue);=0A=
		}=0A=
	}=0A=
}=0A=
=0A=
static void pch_spi_set_ir(struct pch_spi_data *data)=0A=
{=0A=
	/* enable interrupts */=0A=
	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {=0A=
		/* set receive threshold to PCH_RX_THOLD */=0A=
		pch_spi_setclr_reg(data->master, PCH_SPCR,=0A=
				   PCH_RX_THOLD << SPCR_RFIC_FIELD,=0A=
				   ~MASK_RFIC_SPCR_BITS);=0A=
		/* enable FI and RFI interrupts */=0A=
		pch_spi_setclr_reg(data->master, PCH_SPCR,=0A=
				   SPCR_RFIE_BIT | SPCR_FIE_BIT, 0);=0A=
	} else {=0A=
		/* set receive threshold to maximum */=0A=
		pch_spi_setclr_reg(data->master, PCH_SPCR,=0A=
				   PCH_RX_THOLD_MAX << SPCR_TFIC_FIELD,=0A=
				   ~MASK_TFIC_SPCR_BITS);=0A=
		/* enable FI interrupt */=0A=
		pch_spi_setclr_reg(data->master, PCH_SPCR, SPCR_FIE_BIT, 0);=0A=
	}=0A=
=0A=
	dev_dbg(&data->master->dev,=0A=
		"%s:invoking pch_spi_set_enable to enable SPI\n", __func__);=0A=
=0A=
	/* SPI set enable */=0A=
	pch_spi_setclr_reg(data->current_chip->master, PCH_SPCR, SPCR_SPE_BIT, =
0);=0A=
=0A=
	/* Wait until the transfer completes; go to sleep after=0A=
				 initiating the transfer. */=0A=
	dev_dbg(&data->master->dev,=0A=
		"%s:waiting for transfer to get over\n", __func__);=0A=
=0A=
	wait_event_interruptible(data->wait, data->transfer_complete);=0A=
=0A=
	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);=0A=
	dev_dbg(&data->master->dev,=0A=
		"%s:no more control over SSN-writing 0 to SSNXCR.", __func__);=0A=
=0A=
	data->transfer_active =3D false;=0A=
	dev_dbg(&data->master->dev,=0A=
		"%s set data->transfer_active =3D false\n", __func__);=0A=
=0A=
	/* clear all interrupts */=0A=
	pch_spi_writereg(data->master, PCH_SPSR,=0A=
			 pch_spi_readreg(data->master, PCH_SPSR));=0A=
	/* disable interrupts */=0A=
	pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);=0A=
}=0A=
=0A=
static void pch_spi_copy_rx_data(struct pch_spi_data *data, int bpw)=0A=
{=0A=
	int j;=0A=
	u8 *rx_buf;=0A=
	u16 *rx_sbuf;=0A=
=0A=
	/* copy Rx Data */=0A=
	if (!data->cur_trans->rx_buf)=0A=
		return;=0A=
=0A=
	if (bpw =3D=3D 8) {=0A=
		rx_buf =3D data->cur_trans->rx_buf;=0A=
		for (j =3D 0; j < data->bpw_len; j++)=0A=
			*rx_buf++ =3D data->pkt_rx_buff[j] & 0xFF;=0A=
	} else {=0A=
		rx_sbuf =3D data->cur_trans->rx_buf;=0A=
		for (j =3D 0; j < data->bpw_len; j++)=0A=
			*rx_sbuf++ =3D data->pkt_rx_buff[j];=0A=
	}=0A=
}=0A=
=0A=
=0A=
static void pch_spi_process_messages(struct work_struct *pwork)=0A=
{=0A=
	struct spi_message *pmsg;=0A=
	struct pch_spi_data *data;=0A=
	int bpw;=0A=
=0A=
	data =3D container_of(pwork, struct pch_spi_data, work);=0A=
	dev_dbg(&data->master->dev, "%s data initialized\n", __func__);=0A=
=0A=
	spin_lock(&data->lock);=0A=
=0A=
	/* check if suspend has been initiated;if yes flush queue */=0A=
	if (data->board_dat->suspend_sts || (data->status =3D=3D =
STATUS_EXITING)) {=0A=
		dev_dbg(&data->master->dev,=0A=
			"%s suspend/remove initiated,flushing queue\n",=0A=
			__func__);=0A=
=0A=
		list_for_each_entry(pmsg, data->queue.next, queue) {=0A=
			pmsg->status =3D -EIO;=0A=
=0A=
			if (pmsg->complete !=3D 0) {=0A=
				spin_unlock(&data->lock);=0A=
				pmsg->complete(pmsg->context);=0A=
				spin_lock(&data->lock);=0A=
			}=0A=
=0A=
			/* delete from queue */=0A=
			list_del_init(&pmsg->queue);=0A=
		}=0A=
=0A=
		spin_unlock(&data->lock);=0A=
		return;=0A=
	}=0A=
=0A=
	data->bcurrent_msg_processing =3D true;=0A=
	dev_dbg(&data->master->dev,=0A=
		"%s Set data->bcurrent_msg_processing=3D true\n", __func__);=0A=
=0A=
	/* Get the message from the queue and delete it from there. */=0A=
	data->current_msg =3D list_entry(data->queue.next, struct spi_message,=0A=
					queue);=0A=
=0A=
	list_del_init(&data->current_msg->queue);=0A=
=0A=
	data->current_msg->status =3D 0;=0A=
=0A=
	pch_spi_select_chip(data, data->current_msg->spi);=0A=
=0A=
	spin_unlock(&data->lock);=0A=
=0A=
	do {=0A=
		/* If we are already processing a message get the next=0A=
		transfer structure from the message otherwise retrieve=0A=
		the 1st transfer request from the message. */=0A=
		spin_lock(&data->lock);=0A=
=0A=
		if (data->cur_trans =3D=3D NULL) {=0A=
			data->cur_trans =3D=0A=
			    list_entry(data->current_msg->transfers.=0A=
				       next, struct spi_transfer,=0A=
				       transfer_list);=0A=
			dev_dbg(&data->master->dev,=0A=
				"%s :Getting 1st transfer message\n", __func__);=0A=
		} else {=0A=
			data->cur_trans =3D=0A=
			    list_entry(data->cur_trans->transfer_list.next,=0A=
				       struct spi_transfer,=0A=
				       transfer_list);=0A=
			dev_dbg(&data->master->dev,=0A=
				"%s :Getting next transfer message\n",=0A=
				__func__);=0A=
		}=0A=
=0A=
		spin_unlock(&data->lock);=0A=
=0A=
		pch_spi_set_tx(data, &bpw, &pmsg);=0A=
=0A=
		/* Control interrupt*/=0A=
		pch_spi_set_ir(data);=0A=
=0A=
		/* Disable SPI transfer */=0A=
		pch_spi_setclr_reg(data->current_chip->master, PCH_SPCR, 0,=0A=
				   SPCR_SPE_BIT);=0A=
=0A=
		/* clear FIFO */=0A=
		pch_spi_clear_fifo(data->master);=0A=
=0A=
		/* copy Rx Data */=0A=
		pch_spi_copy_rx_data(data, bpw);=0A=
=0A=
		/* free memory */=0A=
		kfree(data->pkt_rx_buff);=0A=
		data->pkt_rx_buff =3D NULL;=0A=
=0A=
		kfree(data->pkt_tx_buff);=0A=
		data->pkt_tx_buff =3D NULL;=0A=
=0A=
		/* increment message count */=0A=
		data->current_msg->actual_length +=3D data->cur_trans->len;=0A=
=0A=
		dev_dbg(&data->master->dev,=0A=
			"%s:data->current_msg->actual_length=3D%d\n",=0A=
			__func__, data->current_msg->actual_length);=0A=
=0A=
		/* check for delay */=0A=
		if (data->cur_trans->delay_usecs) {=0A=
			dev_dbg(&data->master->dev, "%s:"=0A=
				"delay in usec=3D%d\n", __func__,=0A=
				data->cur_trans->delay_usecs);=0A=
			udelay(data->cur_trans->delay_usecs);=0A=
		}=0A=
=0A=
		spin_lock(&data->lock);=0A=
=0A=
		/* No more transfer in this message. */=0A=
		if ((data->cur_trans->transfer_list.next) =3D=3D=0A=
		    &(data->current_msg->transfers)) {=0A=
			pch_spi_nomore_transfer(data, pmsg);=0A=
		}=0A=
=0A=
		spin_unlock(&data->lock);=0A=
=0A=
	} while (data->cur_trans !=3D NULL);=0A=
}=0A=
=0A=
static void pch_spi_free_resources(struct pch_spi_board_data *board_dat)=0A=
{=0A=
	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);=0A=
=0A=
	/* free workqueue */=0A=
	if (board_dat->data->wk !=3D NULL) {=0A=
		destroy_workqueue(board_dat->data->wk);=0A=
		board_dat->data->wk =3D NULL;=0A=
		dev_dbg(&board_dat->pdev->dev,=0A=
			"%s destroy_workqueue invoked successfully\n",=0A=
			__func__);=0A=
	}=0A=
=0A=
	/* disable interrupts & free IRQ */=0A=
	if (board_dat->irq_reg_sts) {=0A=
		/* disable interrupts */=0A=
		pch_spi_setclr_reg(board_dat->data->master, PCH_SPCR,=0A=
				   0, PCH_ALL);=0A=
=0A=
		dev_dbg(&board_dat->pdev->dev,=0A=
			"%s free_irq invoked successfully\n",=0A=
			__func__);=0A=
=0A=
		board_dat->irq_reg_sts =3D false;=0A=
	}=0A=
}=0A=
=0A=
static int pch_spi_get_resources(struct pch_spi_board_data *board_dat)=0A=
{=0A=
	int retval =3D 0;=0A=
=0A=
	dev_dbg(&board_dat->pdev->dev, "%s ENTRY\n", __func__);=0A=
=0A=
	/* create workqueue */=0A=
	board_dat->data->wk =3D create_singlethread_workqueue(KBUILD_MODNAME);=0A=
=0A=
	if (!board_dat->data->wk) {=0A=
		dev_err(&board_dat->pdev->dev,=0A=
			"%s create_singlet hread_workqueue failed\n", __func__);=0A=
		retval =3D -EBUSY;=0A=
		goto err_return;=0A=
	}=0A=
=0A=
	board_dat->pci_req_sts =3D true;=0A=
=0A=
	/* reset PCH SPI h/w */=0A=
	pch_spi_reset(board_dat->data->master);=0A=
	dev_dbg(&board_dat->pdev->dev,=0A=
		"%s pch_spi_reset invoked successfully\n", __func__);=0A=
=0A=
	board_dat->irq_reg_sts =3D true;=0A=
	dev_dbg(&board_dat->pdev->dev, "%s data->irq_reg_sts=3Dtrue\n", =
__func__);=0A=
=0A=
err_return:=0A=
	if (retval !=3D 0) {=0A=
		dev_err(&board_dat->pdev->dev,=0A=
			"%s FAIL:invoking pch_spi_free_resources\n", __func__);=0A=
		pch_spi_free_resources(board_dat);=0A=
	}=0A=
=0A=
	dev_dbg(&board_dat->pdev->dev, "%s Return=3D%d\n", __func__, retval);=0A=
=0A=
	return retval;=0A=
}=0A=
=0A=
static void pch_spi_release_slot(struct device *dev)=0A=
{=0A=
	struct pch_spi_board_data *board_dat =3D dev_get_platdata(dev);=0A=
=0A=
	if (board_dat)=0A=
		platform_device_unregister(board_dat->data->plat_dev);=0A=
}=0A=
=0A=
static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)=0A=
{=0A=
	int ret;=0A=
	struct spi_master *master;=0A=
	struct pch_spi_board_data *board_dat =3D =
dev_get_platdata(&plat_dev->dev);=0A=
=0A=
	master =3D spi_alloc_master(&board_dat->pdev->dev,=0A=
				  sizeof(struct pch_spi_data));=0A=
	if (!master) {=0A=
		dev_err(&plat_dev->dev, "spi_alloc_master[%d] failed.\n",=0A=
			plat_dev->id);=0A=
		return -ENOMEM;=0A=
	}=0A=
=0A=
	board_dat->data =3D spi_master_get_devdata(master);=0A=
	board_dat->data->master =3D master;=0A=
=0A=
	/* baseaddress + 0x20(offset) */=0A=
	board_dat->data->io_remap_addr =3D pci_iomap(board_dat->pdev, 1, 0) +=0A=
							0x20 * plat_dev->id;=0A=
	if (!board_dat->data->io_remap_addr) {=0A=
		dev_err(&plat_dev->dev, "%s pci_iomap failed\n", __func__);=0A=
		ret =3D -ENOMEM;=0A=
		goto err_pci_iomap;=0A=
	}=0A=
=0A=
	dev_dbg(&plat_dev->dev, "[ch%d] remap_addr=3D%p \n",=0A=
		plat_dev->id, board_dat->data->io_remap_addr);=0A=
=0A=
	/* initialize members of SPI master */=0A=
	master->bus_num =3D plat_dev->id;=0A=
	master->num_chipselect =3D PCH_MAX_CS;=0A=
	master->setup =3D pch_spi_setup;=0A=
	master->transfer =3D pch_spi_transfer;=0A=
=0A=
	board_dat->data->plat_dev =3D plat_dev;=0A=
	board_dat->data->n_curnt_chip =3D 255;=0A=
	board_dat->data->status =3D STATUS_RUNNING;=0A=
	board_dat->data->board_dat =3D board_dat;=0A=
	board_dat->data->ch =3D plat_dev->id;=0A=
=0A=
	INIT_LIST_HEAD(&board_dat->data->queue);=0A=
	spin_lock_init(&board_dat->data->lock);=0A=
	INIT_WORK(&board_dat->data->work, pch_spi_process_messages);=0A=
	init_waitqueue_head(&board_dat->data->wait);=0A=
=0A=
	ret =3D pch_spi_get_resources(board_dat);=0A=
	if (ret) {=0A=
		dev_err(&plat_dev->dev, "%s fail(retval=3D%d)\n", __func__, ret);=0A=
		goto err_spi_get_resources;=0A=
	}=0A=
=0A=
	ret =3D request_irq(board_dat->pdev->irq, pch_spi_handler,=0A=
			  IRQF_SHARED, KBUILD_MODNAME, board_dat);=0A=
	if (ret) {=0A=
		dev_err(&plat_dev->dev,=0A=
			"%s request_irq failed\n", __func__);=0A=
		goto err_request_irq;=0A=
	}=0A=
=0A=
	pch_spi_set_master_mode(master);=0A=
=0A=
	ret =3D spi_register_master(master);=0A=
	if (ret !=3D 0) {=0A=
		dev_err(&plat_dev->dev,=0A=
			"%s spi_register_master FAILED\n", __func__);=0A=
		goto err_spi_register_master;=0A=
	}=0A=
=0A=
	return 0;=0A=
=0A=
err_spi_register_master:=0A=
	free_irq(board_dat->pdev->irq, board_dat);=0A=
err_request_irq:=0A=
	pch_spi_free_resources(board_dat);=0A=
err_spi_get_resources:=0A=
	pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);=0A=
err_pci_iomap:=0A=
	spi_master_put(master);=0A=
=0A=
	return ret;=0A=
}=0A=
=0A=
static int pch_spi_pd_remove(struct platform_device *plat_dev)=0A=
{=0A=
	struct pch_spi_board_data *board_dat =3D =
dev_get_platdata(&plat_dev->dev);=0A=
=0A=
	dev_dbg(&plat_dev->dev, "%s:[ch%d] irq=3D%d \n",=0A=
		__func__, plat_dev->id, board_dat->pdev->irq);=0A=
=0A=
	free_irq(board_dat->pdev->irq, board_dat);=0A=
	pch_spi_free_resources(board_dat);=0A=
	spi_unregister_master(board_dat->data->master);=0A=
	pci_iounmap(board_dat->pdev, board_dat->data->io_remap_addr);=0A=
	spi_master_put(board_dat->data->master);=0A=
	platform_set_drvdata(plat_dev, NULL);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
static struct platform_driver pch_spi_pd_driver =3D {=0A=
	.driver =3D {=0A=
		.name =3D "pch-spi",=0A=
		.owner =3D THIS_MODULE,=0A=
	},=0A=
	.probe =3D pch_spi_pd_probe,=0A=
	.remove =3D __devexit_p(pch_spi_pd_remove)=0A=
};=0A=
=0A=
static int pch_spi_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)=0A=
{=0A=
	struct pch_spi_board_data board_dat;=0A=
	struct platform_device *pd_dev =3D NULL;=0A=
	int retval;=0A=
	int i;=0A=
=0A=
	retval =3D pci_request_regions(pdev, KBUILD_MODNAME);=0A=
	if (retval) {=0A=
		dev_err(&pdev->dev, "%s request_region failed\n", __func__);=0A=
		return retval;=0A=
	}=0A=
=0A=
	memset(&board_dat, 0, sizeof(board_dat));=0A=
	board_dat.pdev =3D pdev;=0A=
	board_dat.num =3D id->driver_data;=0A=
=0A=
	retval =3D pci_enable_device(pdev);=0A=
	if (retval) {=0A=
		dev_err(&pdev->dev, "%s pci_enable_device FAILED\n", __func__);=0A=
		goto pci_enable_device;=0A=
	}=0A=
=0A=
	for (i =3D 0; i < board_dat.num; i++) {=0A=
		pd_dev =3D platform_device_alloc("pch-spi", i);=0A=
		if (!pd_dev) {=0A=
			dev_err(&pdev->dev, "platform_device_alloc failed\n");=0A=
			goto err_platform_device;=0A=
		}=0A=
		pd_dev->dev.parent =3D &pdev->dev;=0A=
		pd_dev->dev.release =3D pch_spi_release_slot;=0A=
=0A=
		retval =3D platform_device_add_data(pd_dev, &board_dat,=0A=
						  sizeof(board_dat));=0A=
		if (retval) {=0A=
			dev_err(&pdev->dev,=0A=
				"platform_device_add_data failed\n");=0A=
			platform_device_put(pd_dev);=0A=
			goto err_platform_device;=0A=
		}=0A=
=0A=
		retval =3D platform_device_add(pd_dev);=0A=
		if (retval) {=0A=
			dev_err(&pdev->dev, "platform_device_add failed\n");=0A=
			platform_device_put(pd_dev);=0A=
			goto err_platform_device;=0A=
		}=0A=
	}=0A=
	pci_set_drvdata(pdev, pd_dev);=0A=
=0A=
	return 0;=0A=
=0A=
err_platform_device:=0A=
	pci_disable_device(pdev);=0A=
pci_enable_device:=0A=
	pci_release_regions(pdev);=0A=
=0A=
	return retval;=0A=
}=0A=
=0A=
static void pch_spi_remove(struct pci_dev *pdev)=0A=
{=0A=
	dev_dbg(&pdev->dev, "%s ENTRY:pdev=3D%p\n", __func__, pdev);=0A=
=0A=
	pci_disable_device(pdev);=0A=
	pci_release_regions(pdev);=0A=
}=0A=
=0A=
#ifdef CONFIG_PM=0A=
static int pch_spi_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
{=0A=
//	u8 count;=0A=
	int retval;=0A=
=0A=
	struct pch_spi_board_data *board_dat =3D pci_get_drvdata(pdev);=0A=
=0A=
	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);=0A=
=0A=
	if (!board_dat) {=0A=
		dev_err(&pdev->dev,=0A=
			"%s pci_get_drvdata returned NULL\n", __func__);=0A=
		return -EFAULT;=0A=
	}=0A=
=0A=
	retval =3D 0;=0A=
	board_dat->suspend_sts =3D true;=0A=
#if 0=0A=
	/* check if the current message is processed:=0A=
	   Only after thats done the transfer will be suspended */=0A=
	for (i =3D 0; i < board_dat->num; i++) {=0A=
		count =3D 255;=0A=
		while ((--count) > 0) {=0A=
			if (!(board_dat->data[i]->bcurrent_msg_processing)) {=0A=
				dev_dbg(&pdev->dev, "%s board_dat->data->bCurre"=0A=
					"nt_msg_processing=3Dfalse\n", __func__);=0A=
				break;=0A=
			} else {=0A=
				dev_dbg(&pdev->dev, "%s board_dat->data->bCurre"=0A=
					"nt_msg_processing=3Dtrue\n", __func__);=0A=
			}=0A=
			msleep(PCH_SLEEP_TIME);=0A=
		}=0A=
	}=0A=
=0A=
	/* Free IRQ */=0A=
	if (board_dat->irq_reg_sts) {=0A=
		/* disable all interrupts */=0A=
		for (i =3D 0; i < board_dat->num; i++) {=0A=
			pch_spi_setclr_reg(board_dat->data[i]->master, PCH_SPCR,=0A=
					   0, PCH_ALL);=0A=
			pch_spi_reset(board_dat->data[i]->master);=0A=
		}=0A=
=0A=
		free_irq(board_dat->pdev->irq, board_dat);=0A=
=0A=
		board_dat->irq_reg_sts =3D false;=0A=
		dev_dbg(&pdev->dev,=0A=
			"%s free_irq invoked successfully.\n", __func__);=0A=
	}=0A=
#endif=0A=
	/* save config space */=0A=
	retval =3D pci_save_state(pdev);=0A=
=0A=
	if (retval =3D=3D 0) {=0A=
		dev_dbg(&pdev->dev, "%s pci_save_state returned=3D%d\n",=0A=
			__func__, retval);=0A=
		/* disable PM notifications */=0A=
		pci_enable_wake(pdev, PCI_D3hot, 0);=0A=
		dev_dbg(&pdev->dev,=0A=
			"%s pci_enable_wake invoked successfully\n", __func__);=0A=
		/* disable PCI device */=0A=
		pci_disable_device(pdev);=0A=
		dev_dbg(&pdev->dev,=0A=
			"%s pci_disable_device invoked successfully\n",=0A=
			__func__);=0A=
		/* move device to D3hot  state */=0A=
		pci_set_power_state(pdev, PCI_D3hot);=0A=
		dev_dbg(&pdev->dev,=0A=
			"%s pci_set_power_state invoked successfully\n",=0A=
			__func__);=0A=
	} else {=0A=
		dev_err(&pdev->dev, "%s pci_save_state failed\n", __func__);=0A=
	}=0A=
=0A=
	dev_dbg(&pdev->dev, "%s return=3D%d\n", __func__, retval);=0A=
=0A=
	return retval;=0A=
}=0A=
=0A=
static int pch_spi_resume(struct pci_dev *pdev)=0A=
{=0A=
	int retval;=0A=
	int i;=0A=
=0A=
	struct pch_spi_board_data *board =3D pci_get_drvdata(pdev);=0A=
	dev_dbg(&pdev->dev, "%s ENTRY\n", __func__);=0A=
=0A=
	if (!board) {=0A=
		dev_err(&pdev->dev,=0A=
			"%s pci_get_drvdata returned NULL\n", __func__);=0A=
		return -EFAULT;=0A=
	}=0A=
=0A=
	/* move device to DO power state */=0A=
	pci_set_power_state(pdev, PCI_D0);=0A=
=0A=
	/* restore state */=0A=
	pci_restore_state(pdev);=0A=
=0A=
	retval =3D pci_enable_device(pdev);=0A=
	if (retval < 0) {=0A=
		dev_err(&pdev->dev,=0A=
			"%s pci_enable_device failed\n", __func__);=0A=
	} else {=0A=
		/* disable PM notifications */=0A=
		pci_enable_wake(pdev, PCI_D3hot, 0);=0A=
=0A=
		/* register IRQ handler */=0A=
		if (!board->irq_reg_sts) {=0A=
			/* register IRQ */=0A=
			retval =3D request_irq(board->pdev->irq, pch_spi_handler,=0A=
					     IRQF_SHARED, KBUILD_MODNAME,=0A=
					     board);=0A=
			if (retval < 0) {=0A=
				dev_err(&pdev->dev,=0A=
					"%s request_irq failed\n", __func__);=0A=
				return retval;=0A=
			}=0A=
			board->irq_reg_sts =3D true;=0A=
=0A=
			/* reset PCH SPI h/w */=0A=
			for (i =3D 0; i < board->num; i++) {=0A=
//				pch_spi_reset(board->data[i]->master);=0A=
//				pch_spi_set_master_mode(board->data[i]->master);=0A=
			}=0A=
=0A=
			/* set suspend status to false */=0A=
			board->suspend_sts =3D false;=0A=
=0A=
		}=0A=
	}=0A=
=0A=
	dev_dbg(&pdev->dev, "%s returning=3D%d\n", __func__, retval);=0A=
=0A=
	return retval;=0A=
}=0A=
#else=0A=
#define pch_spi_suspend NULL=0A=
#define pch_spi_resume NULL=0A=
=0A=
#endif=0A=
=0A=
static struct pci_driver pch_spi_pcidev =3D {=0A=
	.name =3D "pch_spi",=0A=
	.id_table =3D pch_spi_pcidev_id,=0A=
	.probe =3D pch_spi_probe,=0A=
	.remove =3D pch_spi_remove,=0A=
	.suspend =3D pch_spi_suspend,=0A=
	.resume =3D pch_spi_resume,=0A=
};=0A=
=0A=
static int __init pch_spi_init(void)=0A=
{=0A=
	platform_driver_register(&pch_spi_pd_driver);=0A=
	return pci_register_driver(&pch_spi_pcidev);=0A=
}=0A=
module_init(pch_spi_init);=0A=
=0A=
static void __exit pch_spi_exit(void)=0A=
{=0A=
	platform_driver_unregister(&pch_spi_pd_driver);=0A=
	pci_unregister_driver(&pch_spi_pcidev);=0A=
}=0A=
module_exit(pch_spi_exit);=0A=
=0A=
MODULE_LICENSE("GPL");=0A=
MODULE_DESCRIPTION("Topcliff PCH SPI PCI Driver");=0A=

------=_NextPart_000_0078_01CBD2D3.8C7F0C60
Content-Type: application/octet-stream;
	name="err_log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="err_log"

------------[ cut here ]------------=0A=
WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x6e/0x83()=0A=
Hardware name: To be filled by O.E.M.=0A=
sysfs: cannot create duplicate filename =
'/devices/pci0000:00/0000:00:17.0/0000:01:00.0/0000:02:0c.1/pch-spi.0'=0A=
Modules linked in: spi_topcliff_pch(+) spidev fuse mga drm =
cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 =
nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput =
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep 8250_pnp =
snd_seq snd_seq_device ppdev parport_pc snd_pcm 8250 matroxfb_base =
matroxfb_DAC1064 pegasus video parport serial_core floppy snd_timer =
matroxfb_accel matroxfb_Ti3026 snd matroxfb_g450 output g450_pll =
matroxfb_misc soundcore serio_raw snd_page_alloc pcspkr ext4 jbd2 crc16 =
sdhci_pci sdhci mmc_core [last unloaded: spi_topcliff_pch]=0A=
Pid: 3281, comm: insmod Not tainted 2.6.37.upstream_check+ #39=0A=
Call Trace:=0A=
 [<c0433add>] warn_slowpath_common+0x65/0x7a=0A=
 [<c04e8274>] ? sysfs_add_one+0x6e/0x83=0A=
 [<c0433b56>] warn_slowpath_fmt+0x26/0x2a=0A=
 [<c04e8274>] sysfs_add_one+0x6e/0x83=0A=
 [<c04e82df>] create_dir+0x56/0x7f=0A=
 [<c04e8398>] sysfs_create_dir+0x77/0x8c=0A=
 [<c0539d27>] kobject_add_internal+0xaa/0x192=0A=
 [<c053a066>] kobject_add+0x5b/0x66=0A=
 [<c05b78b4>] device_add+0x97/0x414=0A=
 [<c05b6eb9>] ? dev_set_name+0x14/0x16=0A=
 [<c05ba879>] platform_device_add+0xe3/0x12a=0A=
 [<f831d6c6>] pch_spi_probe+0x12a/0x186 [spi_topcliff_pch]=0A=
 [<c054b4b2>] local_pci_probe+0xe/0x10=0A=
 [<c054b8dc>] pci_device_probe+0x45/0x68=0A=
 [<c05b97d6>] driver_probe_device+0x81/0xf9=0A=
 [<c05b9891>] __driver_attach+0x43/0x5f=0A=
 [<c05b8d3d>] bus_for_each_dev+0x3d/0x60=0A=
 [<c05b958f>] driver_attach+0x14/0x16=0A=
 [<c05b984e>] ? __driver_attach+0x0/0x5f=0A=
 [<c05b92b3>] bus_add_driver+0x88/0x1c0=0A=
 [<c05b9a55>] driver_register+0x77/0xd6=0A=
 [<c054ba9d>] __pci_register_driver+0x38/0x95=0A=
 [<f8322021>] pch_spi_init+0x21/0x23 [spi_topcliff_pch]=0A=
 [<c0401247>] do_one_initcall+0x71/0x11a=0A=
 [<f8322000>] ? pch_spi_init+0x0/0x23 [spi_topcliff_pch]=0A=
 [<c04586d8>] sys_init_module+0x116e/0x12f5=0A=
 [<c0403018>] sysenter_do_call+0x12/0x28=0A=
---[ end trace f50c01d53c40627e ]---=0A=
kobject_add_internal failed for pch-spi.0 with -EEXIST, don't try to =
register things with the same name in the same directory.=0A=
Pid: 3281, comm: insmod Tainted: G        W   2.6.37.upstream_check+ #39=0A=
Call Trace:=0A=
 [<c0539df7>] kobject_add_internal+0x17a/0x192=0A=
 [<c053a066>] kobject_add+0x5b/0x66=0A=
 [<c05b78b4>] device_add+0x97/0x414=0A=
 [<c05b6eb9>] ? dev_set_name+0x14/0x16=0A=
 [<c05ba879>] platform_device_add+0xe3/0x12a=0A=
 [<f831d6c6>] pch_spi_probe+0x12a/0x186 [spi_topcliff_pch]=0A=
 [<c054b4b2>] local_pci_probe+0xe/0x10=0A=
 [<c054b8dc>] pci_device_probe+0x45/0x68=0A=
 [<c05b97d6>] driver_probe_device+0x81/0xf9=0A=
 [<c05b9891>] __driver_attach+0x43/0x5f=0A=
 [<c05b8d3d>] bus_for_each_dev+0x3d/0x60=0A=
 [<c05b958f>] driver_attach+0x14/0x16=0A=
 [<c05b984e>] ? __driver_attach+0x0/0x5f=0A=
 [<c05b92b3>] bus_add_driver+0x88/0x1c0=0A=
 [<c05b9a55>] driver_register+0x77/0xd6=0A=
 [<c054ba9d>] __pci_register_driver+0x38/0x95=0A=
 [<f8322021>] pch_spi_init+0x21/0x23 [spi_topcliff_pch]=0A=
 [<c0401247>] do_one_initcall+0x71/0x11a=0A=
 [<f8322000>] ? pch_spi_init+0x0/0x23 [spi_topcliff_pch]=0A=
 [<c04586d8>] sys_init_module+0x116e/0x12f5=0A=
 [<c0403018>] sysenter_do_call+0x12/0x28=0A=
pch_spi 0000:02:0c.1: platform_device_add failed=0A=
BUG: unable to handle kernel NULL pointer dereference at 00000068=0A=
IP: [<f831d72c>] pch_spi_release_slot+0xa/0x33 [spi_topcliff_pch]=0A=
*pde =3D 00000000 =0A=
Oops: 0000 [#1] SMP =0A=
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map=0A=
Modules linked in: spi_topcliff_pch(+) spidev fuse mga drm =
cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 =
nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput =
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep 8250_pnp =
snd_seq snd_seq_device ppdev parport_pc snd_pcm 8250 matroxfb_base =
matroxfb_DAC1064 pegasus video parport serial_core floppy snd_timer =
matroxfb_accel matroxfb_Ti3026 snd matroxfb_g450 output g450_pll =
matroxfb_misc soundcore serio_raw snd_page_alloc pcspkr ext4 jbd2 crc16 =
sdhci_pci sdhci mmc_core [last unloaded: spi_topcliff_pch]=0A=
=0A=
Pid: 3281, comm: insmod Tainted: G        W   2.6.37.upstream_check+ #39 =
To be filled by O.E.M./To be filled by O.E.M.=0A=
EIP: 0060:[<f831d72c>] EFLAGS: 00210286 CPU: 1=0A=
EIP is at pch_spi_release_slot+0xa/0x33 [spi_topcliff_pch]=0A=
EAX: 00000000 EBX: ed729db0 ECX: 00200086 EDX: f831d722=0A=
ESI: c0888ee8 EDI: ed729e50 EBP: f707fdb8 ESP: f707fdb4=0A=
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068=0A=
Process insmod (pid: 3281, ti=3Df707e000 task=3Df106caa0 =
task.ti=3Df707e000)=0A=
Stack:=0A=
 00000000 f707fdc4 c05b6f26 f0a69e10 f707fdd8 c0539c56 f0a69e2c c0539c16=0A=
 f5946060 f707fde8 c053aac5 f0a69e10 f5946000 f707fdf4 c0539ba2 f0a69e00=0A=
 f707fdfc c05b6de4 f707fe04 c05ba9cb f707fe40 f831d6e4 f5946060 f831e9f1=0A=
Call Trace:=0A=
 [<c05b6f26>] ? device_release+0x35/0x65=0A=
 [<c0539c56>] ? kobject_release+0x40/0x50=0A=
 [<c0539c16>] ? kobject_release+0x0/0x50=0A=
 [<c053aac5>] ? kref_put+0x39/0x42=0A=
 [<c0539ba2>] ? kobject_put+0x37/0x3c=0A=
 [<c05b6de4>] ? put_device+0xf/0x11=0A=
 [<c05ba9cb>] ? platform_device_put+0xf/0x11=0A=
 [<f831d6e4>] ? pch_spi_probe+0x148/0x186 [spi_topcliff_pch]=0A=
 [<c054b4b2>] ? local_pci_probe+0xe/0x10=0A=
 [<c054b8dc>] ? pci_device_probe+0x45/0x68=0A=
 [<c05b97d6>] ? driver_probe_device+0x81/0xf9=0A=
 [<c05b9891>] ? __driver_attach+0x43/0x5f=0A=
 [<c05b8d3d>] ? bus_for_each_dev+0x3d/0x60=0A=
 [<c05b958f>] ? driver_attach+0x14/0x16=0A=
 [<c05b984e>] ? __driver_attach+0x0/0x5f=0A=
 [<c05b92b3>] ? bus_add_driver+0x88/0x1c0=0A=
 [<c05b9a55>] ? driver_register+0x77/0xd6=0A=
 [<c054ba9d>] ? __pci_register_driver+0x38/0x95=0A=
 [<f8322021>] ? pch_spi_init+0x21/0x23 [spi_topcliff_pch]=0A=
 [<c0401247>] ? do_one_initcall+0x71/0x11a=0A=
 [<f8322000>] ? pch_spi_init+0x0/0x23 [spi_topcliff_pch]=0A=
 [<c04586d8>] ? sys_init_module+0x116e/0x12f5=0A=
 [<c0403018>] ? sysenter_do_call+0x12/0x28=0A=
Code: da e8 88 bd 29 c8 eb 0e 89 f0 e8 b1 d3 22 c8 89 f0 e8 e2 c2 22 c8 =
8b 45 e0 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 8b 58 50 8b 43 08 <ff> 70 =
68 68 0c f2 31 f8 68 0d ea 31 f8 e8 ae ca 3c c8 83 c4 0c =0A=
EIP: [<f831d72c>] pch_spi_release_slot+0xa/0x33 [spi_topcliff_pch] =
SS:ESP 0068:f707fdb4=0A=
CR2: 0000000000000068=0A=
---[ end trace f50c01d53c40627f ]---=0A=

------=_NextPart_000_0078_01CBD2D3.8C7F0C60--

