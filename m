Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0INXUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:20:48 -0400
Received: from trinity.fluff.org ([89.16.178.74]:53512 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab0INXUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:20:46 -0400
Date: Wed, 15 Sep 2010 00:19:50 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: khali@linux-fr.org, ben-linux@fluff.org, srinidhi.kasagar@stericsson.com,
        tsoni@codeaurora.org, linus.walleij@stericsson.com,
        sunder.svit@gmail.com, linux-arm-msm@vger.kernel.org, arve@android.com,
        swetland@google.com, sdharia@codeaurora.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Crane Cai <crane.cai@amd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4] i2c: QUP based bus driver for Qualcomm MSM chipsets
Message-ID: <20100914231949.GA7494@trinity.fluff.org>
References: <1284426217-20674-1-git-send-email-kheitke@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284426217-20674-1-git-send-email-kheitke@codeaurora.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 07:03:36PM -0600, Kenneth Heitke wrote:
> This bus driver supports the QUP i2c hardware controller in the Qualcomm
> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
> purpose data path engine with input/output FIFOs and an embedded i2c
> mini-core. The driver supports FIFO mode (for low bandwidth applications)
> and block mode (interrupt generated for each block-size data transfer).
> The driver currently does not support DMA transfers.
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> ---
> v4: Updated error codes as recommended by sunder.svit@gmail.com
> v3: uses DIV_ROUND_UP() as recommended by linus.walleij@stericsson.com
> v2: incorporated feedback from the following people:
> 	ben-linux@fluff.org
> 	srinidhi.kasagar@stericsson.com
> 	tsoni@codeaurora.org
> 
> The header file defines the platform data used by the QUP driver.  This
> file can be picked up by the i2c maintainers but also needs to be Acked
> by the msm maintainers (linux-arm-msm).
> ---
>  arch/arm/mach-msm/include/mach/msm_qup_i2c.h |   28 +
>  drivers/i2c/busses/Kconfig                   |   12 +
>  drivers/i2c/busses/Makefile                  |    1 +
>  drivers/i2c/busses/i2c-qup.c                 | 1085 ++++++++++++++++++++++++++
>  4 files changed, 1126 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/include/mach/msm_qup_i2c.h
>  create mode 100644 drivers/i2c/busses/i2c-qup.c
> 
> diff --git a/arch/arm/mach-msm/include/mach/msm_qup_i2c.h b/arch/arm/mach-msm/include/mach/msm_qup_i2c.h
> new file mode 100644
> index 0000000..e26684b
> --- /dev/null
> +++ b/arch/arm/mach-msm/include/mach/msm_qup_i2c.h
> @@ -0,0 +1,28 @@
> +/*
> + * Qualcomm MSM QUP i2c Controller Platform Data
> + *
> + * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
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
> + */
> +#ifndef __MSM_QUP_I2C_MSM_H
> +#define __MSM_QUP_I2C_MSM_H
> +
> +struct msm_i2c_platform_data {
> +	int bus_freq;		/* I2C bus frequency (Hz) */
> +	int src_clk_rate;	/* I2C controller clock rate (Hz) */
> +};
> +
> +#endif /* __MSM_QUP_I2C_MSM_H */
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index bceafbf..1f4f2a4 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -521,6 +521,18 @@ config I2C_PXA_SLAVE
>  	  is necessary for systems where the PXA may be a target on the
>  	  I2C bus.
>  
> +config I2C_QUP
> +	tristate "Qualcomm MSM QUP I2C Controller"
> +	depends on (ARCH_MSM7X30 || ARCH_MSM8X60 || \
> +		   (ARCH_QSD8X50 && MSM_SOC_REV_A))

ok, please think about this carefully... it may be worth having an
config HAVE_I2C_QUP selected from the arch. I'd rather not be accepting
patches to update this each time a new SoC/ARCH is added.

> diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
> new file mode 100644
> index 0000000..584e9d7
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-qup.c

> +static irqreturn_t
> +qup_i2c_interrupt(int irq, void *devid)
> +{
> +	struct qup_i2c_dev *dev = devid;
> +	uint32_t status = readl(dev->base + QUP_I2C_STATUS);
> +	uint32_t errors = readl(dev->base + QUP_ERROR_FLAGS);
> +	uint32_t op_flgs = readl(dev->base + QUP_OPERATIONAL);
> +	int err = 0;
> +
> +	if (!dev->msg)
> +		return IRQ_HANDLED;
> +
> +	if (status & I2C_STATUS_ERROR_MASK) {
> +		dev_err(dev->dev, "QUP: I2C status flags :0x%x, irq:%d\n",
> +			status, irq);
> +		err = -status;
> +		/* Clear Error interrupt if it's a level triggered interrupt */
> +		if (dev->num_irqs == 1)
> +			writel(QUP_RESET_STATE, dev->base + QUP_STATE);
> +		goto intr_done;
> +	}

does this print loads of stuff if invoked by i2cdetect?

> +static void
> +qup_i2c_pwr_timer(unsigned long data)
> +{
> +	struct qup_i2c_dev *dev = (struct qup_i2c_dev *) data;
> +	dev_dbg(dev->dev, "QUP_Power: Inactivity based power management\n");
> +	if (dev->clk_state == 1)
> +		qup_i2c_pwr_mgmt(dev, 0);
> +}

we really need a better solution to manage device power states in the kernel.

> +static int
> +qup_i2c_poll_writeready(struct qup_i2c_dev *dev)
> +			dev->in_blk_sz = 16;
> +		/*
> +		 * The block/fifo size w.r.t. 'actual data' is 1/2 due to 'tag'
> +		 * associated with each byte written/received
> +		 */
> +		dev->out_blk_sz /= 2;
> +		dev->in_blk_sz /= 2;
> +		dev->out_fifo_sz = dev->out_blk_sz *
> +					(2 << ((fifo_reg & 0x1C) >> 2));
> +		dev->in_fifo_sz = dev->in_blk_sz *
> +					(2 << ((fifo_reg & 0x380) >> 7));
> +		dev_dbg(dev->dev, "QUP IN:bl:%d, ff:%d, OUT:bl:%d, ff:%d\n",
> +				dev->in_blk_sz, dev->in_fifo_sz,
> +				dev->out_blk_sz, dev->out_fifo_sz);
> +	}


still seeing some magic constants in here even after all the register
defines at the top?

> +	if (dev->num_irqs == 3) {
> +		enable_irq(dev->in_irq);
> +		enable_irq(dev->out_irq);
> +	}
> +	enable_irq(dev->err_irq);
> +	writel(1, dev->base + QUP_SW_RESET);
> +	ret = qup_i2c_poll_state(dev, QUP_RESET_STATE);
> +	if (ret) {
> +		dev_err(dev->dev, "QUP Busy:Trying to recover\n");
> +		goto out_err;
> +	}
> +
> +	/* Initialize QUP registers */
> +	writel(0, dev->base + QUP_CONFIG);
> +	writel(QUP_OPERATIONAL_RESET, dev->base + QUP_OPERATIONAL);
> +	writel(QUP_STATUS_ERROR_FLAGS, dev->base + QUP_ERROR_FLAGS_EN);
> +
> +	writel(I2C_MINI_CORE | I2C_N_VAL, dev->base + QUP_CONFIG);
> +
> +	/* Initialize I2C mini core registers */
> +	writel(0, dev->base + QUP_I2C_CLK_CTL);
> +	writel(QUP_I2C_STATUS_RESET, dev->base + QUP_I2C_STATUS);
> +
> +	dev->cnt = msgs->len;
> +	dev->pos = 0;
> +	dev->msg = msgs;
> +	while (rem) {
> +		bool filled = false;
> +
> +		dev->wr_sz = dev->out_fifo_sz;
> +		dev->err = 0;
> +		dev->complete = &complete;
> +
> +		if (qup_i2c_poll_state(dev, QUP_I2C_MAST_GEN) != 0) {
> +			ret = -EIO;
> +			goto out_err;
> +		}
> +
> +		qup_print_status(dev);
> +		/* HW limits Read upto 256 bytes in 1 read without stop */
> +		if (dev->msg->flags & I2C_M_RD) {
> +			ret = qup_set_read_mode(dev, dev->cnt);
> +			if (ret != 0)
> +				goto out_err;
> +		} else {
> +			ret = qup_set_wr_mode(dev, rem);
> +			if (ret != 0)
> +				goto out_err;
> +			/* Don't fill block till we get interrupt */
> +			if (dev->wr_sz == dev->out_blk_sz)
> +				filled = true;
> +		}
> +
> +		err = qup_update_state(dev, QUP_RUN_STATE);
> +		if (err < 0) {
> +			ret = err;
> +			goto out_err;
> +		}
> +
> +		qup_print_status(dev);
> +		writel(dev->clk_ctl, dev->base + QUP_I2C_CLK_CTL);
> +
> +		do {
> +			int idx = 0;
> +			uint32_t carry_over = 0;
> +
> +			/* Transition to PAUSE state only possible from RUN */
> +			err = qup_update_state(dev, QUP_PAUSE_STATE);
> +			if (err < 0) {
> +				ret = err;
> +				goto out_err;
> +			}
> +
> +			qup_print_status(dev);
> +			/*
> +			 * This operation is Write, check the next operation
> +			 * and decide mode
> +			 */
> +			while (filled == false) {
> +				if ((msgs->flags & I2C_M_RD) &&
> +					(dev->cnt == msgs->len))
> +					qup_issue_read(dev, msgs, &idx,
> +							carry_over);
> +				else if (!(msgs->flags & I2C_M_RD))
> +					qup_issue_write(dev, msgs, rem, &idx,
> +							&carry_over);
> +				if (idx >= (dev->wr_sz << 1))
> +					filled = true;
> +				/* Start new message */
> +				if (filled == false) {
> +					if (msgs->flags & I2C_M_RD)
> +							filled = true;
> +					else if (rem > 1) {
> +						/*
> +						 * Only combine operations with
> +						 * same address
> +						 */
> +						struct i2c_msg *next = msgs + 1;
> +						if (next->addr != msgs->addr ||
> +							next->flags == 0)
> +							filled = true;
> +						else {
> +							rem--;
> +							msgs++;
> +							dev->msg = msgs;
> +							dev->pos = 0;
> +							dev->cnt = msgs->len;
> +						}
> +					} else
> +						filled = true;
> +				}
> +			}
> +			err = qup_update_state(dev, QUP_RUN_STATE);
> +			if (err < 0) {
> +				ret = err;
> +				goto out_err;
> +			}
> +			dev_dbg(dev->dev, "idx:%d, rem:%d, num:%d\n",
> +				idx, rem, num);
> +
> +			qup_print_status(dev);
> +			/* Allow 1 msec per byte * output FIFO size */
> +			timeout = wait_for_completion_timeout(&complete,
> +					msecs_to_jiffies(dev->out_fifo_sz));
> +			if (!timeout) {
> +				dev_err(dev->dev, "Transaction timed out\n");
> +				writel(1, dev->base + QUP_SW_RESET);
> +				ret = -ETIMEDOUT;
> +				goto out_err;
> +			}
> +			if (dev->err) {
> +				if (dev->err & QUP_I2C_NACK_FLAG)
> +					dev_err(dev->dev,
> +					"I2C slave addr:0x%x not connected\n",
> +					dev->msg->addr);
> +				else
> +					dev_err(dev->dev,
> +					"QUP data xfer error %d\n", dev->err);
> +				ret = dev->err;
> +				goto out_err;
> +			}
> +			if (dev->msg->flags & I2C_M_RD) {
> +				int i;
> +				uint32_t dval = 0;
> +				for (i = 0; dev->pos < dev->msg->len; i++,
> +						dev->pos++) {
> +					uint32_t rd_status = readl(dev->base +
> +							QUP_OPERATIONAL);
> +					if (i % 2 == 0) {
> +						if ((rd_status &
> +							QUP_IN_NOT_EMPTY) == 0)
> +							break;
> +						dval = readl(dev->base +
> +							QUP_IN_FIFO_BASE);
> +						dev->msg->buf[dev->pos] =
> +							dval & 0xFF;
> +					} else
> +						dev->msg->buf[dev->pos] =
> +							((dval & 0xFF0000) >>
> +							 16);
> +				}
> +				dev->cnt -= i;
> +			} else
> +				filled = false; /* refill output FIFO */
> +		} while (dev->cnt > 0);
> +		if (dev->cnt == 0) {
> +			rem--;
> +			msgs++;
> +			if (rem) {
> +				dev->pos = 0;
> +				dev->cnt = msgs->len;
> +				dev->msg = msgs;
> +			}
> +		}
> +		/* Wait for I2C bus to be idle */
> +		ret = qup_i2c_poll_writeready(dev);
> +		if (ret) {
> +			dev_err(dev->dev,
> +				"Error waiting for write ready\n");
> +			goto out_err;
> +		}
> +	}
> +
> +	ret = num;
> + out_err:
> +	dev->complete = NULL;
> +	dev->msg = NULL;
> +	dev->pos = 0;
> +	dev->err = 0;
> +	dev->cnt = 0;
> +	disable_irq(dev->err_irq);
> +	if (dev->num_irqs == 3) {
> +		disable_irq(dev->in_irq);
> +		disable_irq(dev->out_irq);
> +	}
> +	dev->pwr_timer.expires = jiffies + 3*HZ;
> +	add_timer(&dev->pwr_timer);
> +	mutex_unlock(&dev->mlock);
> +	return ret;
> +}
> +
> +static u32
> +qup_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
> +}
> +
> +static const struct i2c_algorithm qup_i2c_algo = {
> +	.master_xfer	= qup_i2c_xfer,
> +	.functionality	= qup_i2c_func,
> +};
> +
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
> +
> +	/* We support frequencies upto FAST Mode(400KHz) */
> +	if (pdata->bus_freq <= 0 || pdata->bus_freq > 400000) {
> +		dev_err(&pdev->dev, "clock frequency not supported: %d Hz\n",
> +				pdata->bus_freq);
> +		return -EINVAL;
> +	}
> +
> +	qup_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						"qup_phys_addr");
> +	if (!qup_mem) {
> +		dev_err(&pdev->dev, "no qup mem resource?\n");
> +		return -ENXIO;
> +	}
> +
> +	gsbi_mem = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						"gsbi_qup_i2c_addr");
> +	if (!gsbi_mem) {
> +		dev_err(&pdev->dev, "no gsbi mem resource?\n");
> +		return -ENXIO;
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
> +		return -ENXIO;
> +	}
> +
> +	qup_io = devm_request_mem_region(&pdev->dev, qup_mem->start,
> +			resource_size(qup_mem), pdev->name);
> +	if (!qup_io) {
> +		dev_err(&pdev->dev, "QUP region already claimed\n");
> +		return -EBUSY;
> +	}
> +
> +	gsbi_io = devm_request_mem_region(&pdev->dev, gsbi_mem->start,
> +			resource_size(gsbi_mem), pdev->name);
> +	if (!gsbi_io) {
> +		dev_err(&pdev->dev, "GSBI region already claimed\n");
> +		return -EBUSY;
> +	}
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(struct qup_i2c_dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->dev = &pdev->dev;
> +	dev->base = devm_ioremap(&pdev->dev,
> +			qup_mem->start, resource_size(qup_mem));
> +	if (!dev->base)
> +		return -ENOMEM;
> +
> +	dev->gsbi = devm_ioremap(&pdev->dev,
> +			gsbi_mem->start, resource_size(gsbi_mem));
> +	if (!dev->gsbi)
> +		return -ENOMEM;
> +
> +	clk = clk_get(&pdev->dev, "qup_clk");

the first arg to clk_get() should provide more info for the actual
clock being requested. This sould probably be NULL.

> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "Could not get clock\n");
> +		ret = PTR_ERR(clk);
> +		goto err_clk_get_failed;
> +	}
> +
> +	pclk = clk_get(&pdev->dev, "qup_pclk");

this really should be clk_get(&pdev->dev, "pclk");

> +	if (IS_ERR(pclk))
> +		pclk = NULL;
> +
> +	if (in_irq)
> +		dev->in_irq = in_irq->start;
> +	if (out_irq)
> +		dev->out_irq = out_irq->start;
> +	dev->err_irq = err_irq->start;
> +	if (in_irq && out_irq)
> +		dev->num_irqs = 3;
> +	else
> +		dev->num_irqs = 1;
> +	dev->clk = clk;
> +	dev->pclk = pclk;
> +
> +	platform_set_drvdata(pdev, dev);
> +
> +	dev->one_bit_t = DIV_ROUND_UP(USEC_PER_SEC, pdata->bus_freq);
> +	dev->pdata = pdata;
> +	dev->clk_ctl = 0;
> +
> +	/*
> +	 * We use num_irqs to also indicate if we got 3 interrupts or just 1.
> +	 * If we have just 1, we use err_irq as the general purpose irq
> +	 * and handle the changes in ISR accordingly
> +	 * Per Hardware guidelines, if we have 3 interrupts, they are always
> +	 * edge triggering, and if we have 1, it's always level-triggering
> +	 */
> +	if (dev->num_irqs == 3) {
> +		ret = request_irq(dev->in_irq, qup_i2c_interrupt,
> +				IRQF_TRIGGER_RISING, "qup_in_intr", dev);
> +		if (ret) {
> +			dev_err(&pdev->dev, "request_in_irq failed\n");
> +			goto err_request_irq_failed;
> +		}
> +		/*
> +		 * We assume out_irq exists if in_irq does since platform
> +		 * configuration either has 3 interrupts assigned to QUP or 1
> +		 */
> +		ret = request_irq(dev->out_irq, qup_i2c_interrupt,
> +				IRQF_TRIGGER_RISING, "qup_out_intr", dev);
> +		if (ret) {
> +			dev_err(&pdev->dev, "request_out_irq failed\n");
> +			free_irq(dev->in_irq, dev);
> +			goto err_request_irq_failed;
> +		}
> +		ret = request_irq(dev->err_irq, qup_i2c_interrupt,
> +				IRQF_TRIGGER_RISING, "qup_err_intr", dev);
> +		if (ret) {
> +			dev_err(&pdev->dev, "request_err_irq failed\n");
> +			free_irq(dev->out_irq, dev);
> +			free_irq(dev->in_irq, dev);
> +			goto err_request_irq_failed;
> +		}
> +	} else {
> +		ret = request_irq(dev->err_irq, qup_i2c_interrupt,
> +				IRQF_TRIGGER_HIGH, "qup_err_intr", dev);
> +		if (ret) {
> +			dev_err(&pdev->dev, "request_err_irq failed\n");
> +			goto err_request_irq_failed;
> +		}
> +	}
> +	disable_irq(dev->err_irq);
> +	if (dev->num_irqs == 3) {
> +		disable_irq(dev->in_irq);
> +		disable_irq(dev->out_irq);
> +	}
> +	i2c_set_adapdata(&dev->adapter, dev);
> +	dev->adapter.algo = &qup_i2c_algo;
> +	strlcpy(dev->adapter.name,
> +		"QUP I2C adapter",
> +		sizeof(dev->adapter.name));
> +	dev->adapter.nr = pdev->id;
> +
> +	dev->suspended = 0;
> +	mutex_init(&dev->mlock);
> +	dev->clk_state = 0;
> +	setup_timer(&dev->pwr_timer, qup_i2c_pwr_timer, (unsigned long) dev);
> +
> +	ret = i2c_add_numbered_adapter(&dev->adapter);
> +	if (ret) {
> +		dev_err(&pdev->dev, "i2c_add_adapter failed\n");
> +		if (dev->num_irqs == 3) {
> +			free_irq(dev->out_irq, dev);
> +			free_irq(dev->in_irq, dev);
> +		}
> +		free_irq(dev->err_irq, dev);
> +	} else
> +		return 0;
> +
> +err_request_irq_failed:
> +	clk_put(clk);
> +	if (pclk)
> +		clk_put(pclk);
> +err_clk_get_failed:
> +	return ret;
> +}
> +
> +static int __devexit
> +qup_i2c_remove(struct platform_device *pdev)
> +{
> +	struct qup_i2c_dev	*dev = platform_get_drvdata(pdev);
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
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int qup_i2c_suspend(struct device *dev)

someone should add __pm like the __devinit/__devexit calls to
reduce the #ifdef usage...

> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct qup_i2c_dev *qup = platform_get_drvdata(pdev);
> +
> +	/* Grab mutex to ensure ongoing transaction is over */
> +	mutex_lock(&qup->mlock);
> +	qup->suspended = 1;
> +	mutex_unlock(&qup->mlock);
> +	del_timer_sync(&qup->pwr_timer);
> +	if (qup->clk_state != 0)
> +		qup_i2c_pwr_mgmt(qup, 0);
> +	return 0;
> +}
> +
> +static int qup_i2c_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct qup_i2c_dev *qup = platform_get_drvdata(pdev);
> +
> +	qup->suspended = 0;
> +	return 0;
> +}
> +
> +static const SIMPLE_DEV_PM_OPS(qup_i2c_pm_ops,
> +				qup_i2c_suspend, qup_i2c_resume);
> +#endif /* CONFIG_PM */
> +
> +static struct platform_driver qup_i2c_driver = {
> +	.probe		= qup_i2c_probe,
> +	.remove		= __devexit_p(qup_i2c_remove),
> +	.driver		= {
> +		.name	= "qup_i2c",
> +		.owner	= THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm	= &qup_i2c_pm_ops,
> +#endif
> +	},
> +};
> +
> +/* QUP may be needed to bring up other drivers */
> +static int __init
> +qup_i2c_init_driver(void)
> +{
> +	return platform_driver_register(&qup_i2c_driver);
> +}
> +arch_initcall(qup_i2c_init_driver);
> +
> +static void __exit qup_i2c_exit_driver(void)
> +{
> +	platform_driver_unregister(&qup_i2c_driver);
> +}
> +module_exit(qup_i2c_exit_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION("0.2");
> +MODULE_ALIAS("platform:i2c_qup");
> +MODULE_AUTHOR("Sagar Dharia <sdharia@codeaurora.org>");

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

