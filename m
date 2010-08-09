Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0HINPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:15:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:37558 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab0HINPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:15:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] i2c: QUP based bus driver for Qualcomm MSM chipsets
Date: Mon, 09 Aug 2010 14:09:44 +0100
Message-ID: <4C5FFE18.4030304@fluff.org>
References: <1279853264-16311-1-git-send-email-kheitke@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-i2c@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 78.143.211.26
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
In-Reply-To: <1279853264-16311-1-git-send-email-kheitke@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/10 03:47, Kenneth Heitke wrote:
> This bus driver supports the QUP i2c hardware controller in the Qualcomm
> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
> purpose data path engine with input/output FIFOs and an embedded i2c
> mini-core. The driver supports FIFO mode (for low bandwidth applications)
> and block mode (interrupt generated for each block-size data transfer).
> The driver currently does not support DMA transfers.
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> ---
>  drivers/i2c/busses/Kconfig   |   12 +
>  drivers/i2c/busses/Makefile  |    1 +
>  drivers/i2c/busses/i2c-qup.c | 1080 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c-msm.h      |   29 ++
>  4 files changed, 1122 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-qup.c
>  create mode 100644 include/linux/i2c-msm.h

you seem to use msm and qup, could you pick one please?
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index bceafbf..03d8f8f 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -521,6 +521,18 @@ config I2C_PXA_SLAVE
>  	  is necessary for systems where the PXA may be a target on the
>  	  I2C bus.
>  
> +config I2C_QUP
> +	tristate "Qualcomm MSM QUP I2C Controller"
> +	depends on I2C && HAVE_CLK && (ARCH_MSM7X30 || ARCH_MSM8X60 || \
> +		   (ARCH_QSD8X50 && MSM_SOC_REV_A))

Do you really need HAVE_CLK in here?

I'd also say you should have a HAVE_I2C_QUP or just enable it for
all MSM arches, compiling the driver shouldn't really break if the
arch doesn't have the peripheral (it's just a waste of space).

> +	help
> +	  If you say yes to this option, support will be included for the
> +	  built-in QUP I2C interface on Qualcomm MSM family processors.
> +
> +	  The Qualcomm Universal Peripheral Engine (QUP) is a general
> +	  purpose data path engine with input/output FIFOs and an
> +	  embedded I2C mini-core.
> +
>  config I2C_S3C2410
>  	tristate "S3C2410 I2C Driver"
>  	depends on ARCH_S3C2410 || ARCH_S3C64XX

> diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
> new file mode 100644
> index 0000000..3d7abab
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-qup.c
> @@ -0,0 +1,1080 @@
> +/* Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + */
> +/*
> + * QUP driver for Qualcomm MSM platforms
> + *
> + */

I'd put the second comment at the top of the first.

> +
> +/* #define DEBUG */

please remove

> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/timer.h>
> +#include <linux/i2c-msm.h>
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION("0.2");
> +MODULE_ALIAS("platform:i2c_qup");
> +MODULE_AUTHOR("Sagar Dharia <sdharia@codeaurora.org>");
> +
> +/* QUP Registers */
> +enum {
> +	QUP_CONFIG              = 0x0,
> +	QUP_STATE               = 0x4,
> +	QUP_IO_MODE             = 0x8,
> +	QUP_SW_RESET            = 0xC,
> +	QUP_OPERATIONAL         = 0x18,
> +	QUP_ERROR_FLAGS         = 0x1C,
> +	QUP_ERROR_FLAGS_EN      = 0x20,
> +	QUP_MX_READ_CNT         = 0x208,
> +	QUP_MX_INPUT_CNT        = 0x200,
> +	QUP_MX_WR_CNT           = 0x100,
> +	QUP_OUT_DEBUG           = 0x108,
> +	QUP_OUT_FIFO_CNT        = 0x10C,
> +	QUP_OUT_FIFO_BASE       = 0x110,
> +	QUP_IN_READ_CUR         = 0x20C,
> +	QUP_IN_DEBUG            = 0x210,
> +	QUP_IN_FIFO_CNT         = 0x214,
> +	QUP_IN_FIFO_BASE        = 0x218,
> +	QUP_I2C_CLK_CTL         = 0x400,
> +	QUP_I2C_STATUS          = 0x404,
> +};
> +
> +/* QUP States and reset values */
> +enum {
> +	QUP_RESET_STATE         = 0,
> +	QUP_RUN_STATE           = 1U,
> +	QUP_STATE_MASK          = 3U,
> +	QUP_PAUSE_STATE         = 3U,
> +	QUP_STATE_VALID         = 1U << 2,
> +	QUP_I2C_MAST_GEN        = 1U << 4,
> +	QUP_OPERATIONAL_RESET   = 0xFF0,
> +	QUP_I2C_STATUS_RESET    = 0xFFFFFC,
> +};
> +
> +/* QUP OPERATIONAL FLAGS */
> +enum {
> +	QUP_OUT_SVC_FLAG        = 1U << 8,
> +	QUP_IN_SVC_FLAG         = 1U << 9,
> +	QUP_MX_INPUT_DONE       = 1U << 11,
> +};
> +
> +/* I2C mini core related values */
> +enum {
> +	I2C_MINI_CORE           = 2U << 8,
> +	I2C_N_VAL               = 0xF,
> +};
> +
> +/* Packing Unpacking words in FIFOs , and IO modes*/
> +enum {
> +	QUP_WR_BLK_MODE  = 1U << 10,
> +	QUP_RD_BLK_MODE  = 1U << 12,
> +	QUP_UNPACK_EN = 1U << 14,
> +	QUP_PACK_EN = 1U << 15,
> +};
> +
> +/* QUP tags */
> +enum {
> +	QUP_OUT_NOP   = 0,
> +	QUP_OUT_START = 1U << 8,
> +	QUP_OUT_DATA  = 2U << 8,
> +	QUP_OUT_STOP  = 3U << 8,
> +	QUP_OUT_REC   = 4U << 8,
> +	QUP_IN_DATA   = 5U << 8,
> +	QUP_IN_STOP   = 6U << 8,
> +	QUP_IN_NACK   = 7U << 8,
> +};
> +
> +/* Status, Error flags */
> +enum {
> +	I2C_STATUS_WR_BUFFER_FULL  = 1U << 0,
> +	I2C_STATUS_BUS_ACTIVE      = 1U << 8,
> +	I2C_STATUS_ERROR_MASK      = 0x38000FC,
> +	QUP_I2C_NACK_FLAG          = 1U << 3,
> +	QUP_IN_NOT_EMPTY           = 1U << 5,
> +	QUP_STATUS_ERROR_FLAGS     = 0x7C,
> +};

Please try and avoid anonymous enums.

> +/* GSBI Control Register */
> +enum {
> +	GSBI_I2C_PROTOCOL_CODE	= 0x2 << 4,	/* I2C protocol */
> +};
> +
> +#define QUP_MAX_RETRIES	2000
> +#define QUP_SRC_CLK_RATE	19200000	/* Default source clock rate */
> +
> +struct qup_i2c_dev {
> +	struct device                *dev;
> +	void __iomem                 *base;		/* virtual */
> +	void __iomem                 *gsbi;		/* virtual */
> +	int                          in_irq;
> +	int                          out_irq;
> +	int                          err_irq;
> +	int                          num_irqs;
> +	struct clk                   *clk;
> +	struct clk                   *pclk;
> +	struct i2c_adapter           adapter;
> +
> +	struct i2c_msg               *msg;
> +	int                          pos;
> +	int                          cnt;
> +	int                          err;
> +	int                          mode;
> +	int                          clk_ctl;
> +	int                          one_bit_t;
> +	int                          out_fifo_sz;
> +	int                          in_fifo_sz;
> +	int                          out_blk_sz;
> +	int                          in_blk_sz;
> +	int                          wr_sz;
> +	struct msm_i2c_platform_data *pdata;
> +	int                          suspended;
> +	int                          clk_state;
> +	struct timer_list            pwr_timer;
> +	struct mutex                 mlock;
> +	void                         *complete;
> +};

would have been nice to document this.

> +static void
> +qup_i2c_pwr_mgmt(struct qup_i2c_dev *dev, unsigned int state)
> +{
> +	dev->clk_state = state;
> +	if (state != 0) {
> +		clk_enable(dev->clk);
> +		if (dev->pclk)
> +			clk_enable(dev->pclk);
> +	} else {
> +		clk_disable(dev->clk);
> +		if (dev->pclk)
> +			clk_disable(dev->pclk);
> +	}
> +}
> +
> +static void
> +qup_i2c_pwr_timer(unsigned long data)
> +{
> +	struct qup_i2c_dev *dev = (struct qup_i2c_dev *) data;
> +	dev_dbg(dev->dev, "QUP_Power: Inactivity based power management\n");
> +	if (dev->clk_state == 1)
> +		qup_i2c_pwr_mgmt(dev, 0);
> +}
> +
> +static int
> +qup_i2c_poll_writeready(struct qup_i2c_dev *dev)
> +{
> +	uint32_t retries = 0;
> +
> +	while (retries != QUP_MAX_RETRIES) {
> +		uint32_t status = readl(dev->base + QUP_I2C_STATUS);
> +
> +		if (!(status & I2C_STATUS_WR_BUFFER_FULL)) {
> +			if (!(status & I2C_STATUS_BUS_ACTIVE))
> +				return 0;
> +			else /* 1-bit delay before we check for bus busy */
> +				udelay(dev->one_bit_t);
> +		}
> +		if (retries++ == 1000)
> +			udelay(100);
> +	}
> +	qup_print_status(dev);
> +	return -ETIMEDOUT;
> +}
> +
> +static int
> +qup_i2c_poll_state(struct qup_i2c_dev *dev, uint32_t state)
> +{
> +	uint32_t retries = 0;
> +
> +	dev_dbg(dev->dev, "Polling Status for state:0x%x\n", state);
> +
> +	while (retries != QUP_MAX_RETRIES) {
> +		uint32_t status = readl(dev->base + QUP_STATE);
> +
> +		if ((status & (QUP_STATE_VALID | state)) ==
> +				(QUP_STATE_VALID | state))
> +			return 0;
> +		else if (retries++ == 1000)
> +			udelay(100);
> +	}
> +	return -ETIMEDOUT;
> +}
> +
> +#ifdef DEBUG
> +static void qup_verify_fifo(struct qup_i2c_dev *dev, uint32_t val,
> +				uint32_t addr, int rdwr)
> +{
> +	if (rdwr)
> +		dev_dbg(dev->dev, "RD:Wrote 0x%x to out_ff:0x%x\n", val, addr);
> +	else
> +		dev_dbg(dev->dev, "WR:Wrote 0x%x to out_ff:0x%x\n", val, addr);
> +}
> +#else
> +static inline void qup_verify_fifo(struct qup_i2c_dev *dev, uint32_t val,
> +				uint32_t addr, int rdwr)
> +{
> +}
> +#endif
> +
> +static void
> +qup_issue_read(struct qup_i2c_dev *dev, struct i2c_msg *msg, int *idx,
> +		uint32_t carry_over)
> +{
> +	uint16_t addr = (msg->addr << 1) | 1;
> +	/* QUP limit 256 bytes per read. By HW design, 0 in the 8-bit field
> +	 * is treated as 256 byte read.
> +	 */
> +	uint16_t rd_len = ((dev->cnt == 256) ? 0 : dev->cnt);
> +
> +	if (*idx % 4) {
> +		writel(carry_over | ((QUP_OUT_START | addr) << 16),
> +		dev->base + QUP_OUT_FIFO_BASE);/* + (*idx-2)); */
> +
> +		qup_verify_fifo(dev, carry_over |
> +			((QUP_OUT_START | addr) << 16), (uint32_t)dev->base
> +			+ QUP_OUT_FIFO_BASE + (*idx - 2), 1);

the casting here is nasty. how about leaving dev->base out of this?

> +		writel((QUP_OUT_REC | rd_len),
> +			dev->base + QUP_OUT_FIFO_BASE);/* + (*idx+2)); */
> +
> +		qup_verify_fifo(dev, (QUP_OUT_REC | rd_len),
> +		(uint32_t)dev->base + QUP_OUT_FIFO_BASE + (*idx + 2), 1);
> +	} else {
> +		writel(((QUP_OUT_REC | rd_len) << 16) | QUP_OUT_START | addr,
> +			dev->base + QUP_OUT_FIFO_BASE);/* + (*idx)); */
> +
> +		qup_verify_fifo(dev, QUP_OUT_REC << 16 | rd_len << 16 |
> +		QUP_OUT_START | addr,
> +		(uint32_t)dev->base + QUP_OUT_FIFO_BASE + (*idx), 1);
> +	}
> +	*idx += 4;
> +}

> +static void
> +qup_issue_write(struct qup_i2c_dev *dev, struct i2c_msg *msg, int rem,
> +			int *idx, uint32_t *carry_over)
> +{
> +	int entries = dev->cnt;
> +	int empty_sl = dev->wr_sz - ((*idx) >> 1);
> +	int i = 0;
> +	uint32_t val = 0;
> +	uint32_t last_entry = 0;
> +	uint16_t addr = msg->addr << 1;
> +
> +	if (dev->pos == 0) {
> +		if (*idx % 4) {
> +			writel(*carry_over | ((QUP_OUT_START | addr) << 16),
> +					dev->base + QUP_OUT_FIFO_BASE);
> +
> +			qup_verify_fifo(dev, *carry_over | QUP_OUT_DATA << 16 |
> +				addr << 16, (uint32_t)dev->base +
> +				QUP_OUT_FIFO_BASE + (*idx) - 2, 0);
> +		} else
> +			val = QUP_OUT_START | addr;
> +		*idx += 2;
> +		i++;
> +		entries++;
> +	} else {
> +		/* Avoid setp time issue by adding 1 NOP when number of bytes
> +		 * are more than FIFO/BLOCK size. setup time issue can't appear
> +		 * otherwise since next byte to be written will always be ready
> +		 */
> +		val = (QUP_OUT_NOP | 1);
> +		*idx += 2;
> +		i++;
> +		entries++;
> +	}
> +	if (entries > empty_sl)
> +		entries = empty_sl;
> +
> +	for (; i < (entries - 1); i++) {
> +		if (*idx % 4) {
> +			writel(val | ((QUP_OUT_DATA |
> +				msg->buf[dev->pos]) << 16),
> +				dev->base + QUP_OUT_FIFO_BASE);
> +
> +			qup_verify_fifo(dev, val | QUP_OUT_DATA << 16 |
> +				msg->buf[dev->pos] << 16, (uint32_t)dev->base +
> +				QUP_OUT_FIFO_BASE + (*idx) - 2, 0);
> +		} else
> +			val = QUP_OUT_DATA | msg->buf[dev->pos];
> +		(*idx) += 2;
> +		dev->pos++;
> +	}
> +	if (dev->pos < (msg->len - 1))
> +		last_entry = QUP_OUT_DATA;
> +	else if (rem > 1) /* not last array entry */
> +		last_entry = QUP_OUT_DATA;
> +	else
> +		last_entry = QUP_OUT_STOP;
> +	if ((*idx % 4) == 0) {
> +		/*
> +		 * If read-start and read-command end up in different fifos, it
> +		 * may result in extra-byte being read due to extra-read cycle.
> +		 * Avoid that by inserting NOP as the last entry of fifo only
> +		 * if write command(s) leave 1 space in fifo.
> +		 */
> +		if (rem > 1) {
> +			struct i2c_msg *next = msg + 1;
> +			if (next->addr == msg->addr && (next->flags | I2C_M_RD)
> +				&& *idx == ((dev->wr_sz*2) - 4)) {
> +				writel(((last_entry | msg->buf[dev->pos]) |
> +					((1 | QUP_OUT_NOP) << 16)), dev->base +
> +					QUP_OUT_FIFO_BASE);/* + (*idx) - 2); */
> +				*idx += 2;
> +			} else
> +				*carry_over = (last_entry | msg->buf[dev->pos]);
> +		} else {
> +			writel((last_entry | msg->buf[dev->pos]),
> +			dev->base + QUP_OUT_FIFO_BASE);/* + (*idx) - 2); */
> +
> +			qup_verify_fifo(dev, last_entry | msg->buf[dev->pos],
> +			(uint32_t)dev->base + QUP_OUT_FIFO_BASE +
> +			(*idx), 0);
> +		}
> +	} else {
> +		writel(val | ((last_entry | msg->buf[dev->pos]) << 16),
> +		dev->base + QUP_OUT_FIFO_BASE);/* + (*idx) - 2); */
> +
> +		qup_verify_fifo(dev, val | (last_entry << 16) |
> +		(msg->buf[dev->pos] << 16), (uint32_t)dev->base +
> +		QUP_OUT_FIFO_BASE + (*idx) - 2, 0);
> +	}
> +
> +	*idx += 2;
> +	dev->pos++;
> +	dev->cnt = msg->len - dev->pos;
> +}

> +static int __devinit
> +qup_i2c_probe(struct platform_device *pdev)
> +{
> +	struct qup_i2c_dev	*dev;
> +	struct resource         *qup_mem, *gsbi_mem, *qup_io, *gsbi_io;
> +	struct resource		*in_irq, *out_irq, *err_irq;
> +	struct clk         *clk, *pclk;
> +	int ret = 0;
> +	struct msm_i2c_platform_data *pdata;
> +
> +	dev_dbg(&pdev->dev, "qup_i2c_probe\n");
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "platform data not initialized\n");
> +		return -ENOSYS;
> +	}
> +	qup_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						"qup_phys_addr");
> +	if (!qup_mem) {
> +		dev_err(&pdev->dev, "no qup mem resource?\n");
> +		return -ENODEV;
> +	}
> +	gsbi_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						"gsbi_qup_i2c_addr");
> +	if (!gsbi_mem) {
> +		dev_err(&pdev->dev, "no gsbi mem resource?\n");
> +		return -ENODEV;
> +	}
> +
> +	/*
> +	 * We only have 1 interrupt for new hardware targets and in_irq,
> +	 * out_irq will be NULL for those platforms
> +	 */
> +	in_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +						"qup_in_intr");
> +
> +	out_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +						"qup_out_intr");
> +
> +	err_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
> +						"qup_err_intr");
> +	if (!err_irq) {
> +		dev_err(&pdev->dev, "no error irq resource?\n");
> +		return -ENODEV;
> +	}
> +
> +	qup_io = request_mem_region(qup_mem->start, resource_size(qup_mem),
> +					pdev->name);
> +	if (!qup_io) {
> +		dev_err(&pdev->dev, "QUP region already claimed\n");
> +		return -EBUSY;
> +	}
> +	gsbi_io = request_mem_region(gsbi_mem->start, resource_size(gsbi_mem),
> +					pdev->name);
> +	if (!gsbi_io) {
> +		release_mem_region(qup_mem->start, resource_size(qup_mem));
> +		dev_err(&pdev->dev, "GSBI region already claimed\n");
> +		return -EBUSY;
> +	}
> +
> +	clk = clk_get(&pdev->dev, "qup_clk");
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "Could not get clock\n");
> +		ret = PTR_ERR(clk);
> +		goto err_clk_get_failed;
> +	}

the device's bus clock really shouldn't need a name.

> +
> +	pclk = clk_get(&pdev->dev, "qup_pclk");
> +	if (IS_ERR(pclk))
> +		pclk = NULL;
> +
> +	if (!pdata->msm_i2c_config_gpio) {
> +		dev_err(&pdev->dev, "config_gpio function not initialized\n");
> +		ret = -ENOSYS;
> +		goto err_config_failed;
> +	}
> +
> +	/* We support frequencies upto FAST Mode(400KHz) */
> +	if (pdata->clk_freq <= 0 ||
> +			pdata->clk_freq > 400000) {
> +		dev_err(&pdev->dev, "clock frequency not supported\n");
> +		ret = -EIO;
> +		goto err_config_failed;
> +	}

> +qup_i2c_remove(struct platform_device *pdev)
> +{
> +	struct qup_i2c_dev	*dev = platform_get_drvdata(pdev);
> +	struct resource		*qup_mem, *gsbi_mem;
> +
> +	/* Grab mutex to ensure ongoing transaction is over */
> +	mutex_lock(&dev->mlock);
> +	dev->suspended = 1;
> +	mutex_unlock(&dev->mlock);
> +	mutex_destroy(&dev->mlock);
> +	del_timer_sync(&dev->pwr_timer);
> +	if (dev->clk_state != 0)
> +		qup_i2c_pwr_mgmt(dev, 0);
> +	platform_set_drvdata(pdev, NULL);
> +	if (dev->num_irqs == 3) {
> +		free_irq(dev->out_irq, dev);
> +		free_irq(dev->in_irq, dev);
> +	}
> +	free_irq(dev->err_irq, dev);
> +	i2c_del_adapter(&dev->adapter);
> +	clk_put(dev->clk);
> +	if (dev->pclk)
> +		clk_put(dev->pclk);
> +	iounmap(dev->gsbi);
> +	iounmap(dev->base);
> +	kfree(dev);
> +	gsbi_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						"gsbi_qup_i2c_addr");
> +	release_mem_region(gsbi_mem->start, resource_size(gsbi_mem));
> +	qup_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						"qup_phys_addr");
> +	release_mem_region(qup_mem->start, resource_size(qup_mem));
> +	return 0;
> +}

you'd have been better off using devm to keep track of your resources.


