Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab0HLBul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:50:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6839 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811Ab0HLBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:50:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6071"; a="50717437"
Message-ID: <4C63536D.20201@codeaurora.org>
Date: Wed, 11 Aug 2010 19:50:37 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: srinidhi.kasagar@stericsson.com
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: QUP based bus driver for Qualcomm MSM chipsets
References: <1279853264-16311-1-git-send-email-kheitke@codeaurora.org> <1280142350.4705.809.camel@bnru03>
In-Reply-To: <1280142350.4705.809.camel@bnru03>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srinidhi,

Thanks for your feedback.

srinidhi wrote:
> On Fri, 2010-07-23 at 04:47 +0200, Kenneth Heitke wrote:
>> This bus driver supports the QUP i2c hardware controller in the Qualcomm
>> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
>> purpose data path engine with input/output FIFOs and an embedded i2c
>> mini-core. The driver supports FIFO mode (for low bandwidth applications)
>> and block mode (interrupt generated for each block-size data transfer).
>> The driver currently does not support DMA transfers.
>>
>> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
>> ---
>>  drivers/i2c/busses/Kconfig   |   12 +
>>  drivers/i2c/busses/Makefile  |    1 +
>>  drivers/i2c/busses/i2c-qup.c | 1080 ++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/i2c-msm.h      |   29 ++
>>  4 files changed, 1122 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/i2c/busses/i2c-qup.c
>>  create mode 100644 include/linux/i2c-msm.h
>>
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index bceafbf..03d8f8f 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -521,6 +521,18 @@ config I2C_PXA_SLAVE
>>           is necessary for systems where the PXA may be a target on the
>>           I2C bus.
>>
>> +config I2C_QUP
>> +       tristate "Qualcomm MSM QUP I2C Controller"
>> +       depends on I2C && HAVE_CLK && (ARCH_MSM7X30 || ARCH_MSM8X60 || \
>> +                  (ARCH_QSD8X50 && MSM_SOC_REV_A))
> 
> I think HAVE_CLK is redundant here
> 
>> +       help
>> +         If you say yes to this option, support will be included for the
>> +         built-in QUP I2C interface on Qualcomm MSM family processors.
>> +
>> +         The Qualcomm Universal Peripheral Engine (QUP) is a general
>> +         purpose data path engine with input/output FIFOs and an
>> +         embedded I2C mini-core.
>> +
>>  config I2C_S3C2410
>>         tristate "S3C2410 I2C Driver"
>>         depends on ARCH_S3C2410 || ARCH_S3C64XX
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index 936880b..6a52572 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -50,6 +50,7 @@ obj-$(CONFIG_I2C_PCA_PLATFORM)        += i2c-pca-platform.o
>>  obj-$(CONFIG_I2C_PMCMSP)       += i2c-pmcmsp.o
>>  obj-$(CONFIG_I2C_PNX)          += i2c-pnx.o
>>  obj-$(CONFIG_I2C_PXA)          += i2c-pxa.o
>> +obj-$(CONFIG_I2C_QUP)          += i2c-qup.o
>>  obj-$(CONFIG_I2C_S3C2410)      += i2c-s3c2410.o
>>  obj-$(CONFIG_I2C_S6000)                += i2c-s6000.o
>>  obj-$(CONFIG_I2C_SH7760)       += i2c-sh7760.o
>> diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
>> new file mode 100644
>> index 0000000..3d7abab
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-qup.c
>> @@ -0,0 +1,1080 @@
>> +/* Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
>> + * 02110-1301, USA.
>> + *
>> + */
>> +/*
>> + * QUP driver for Qualcomm MSM platforms
>> + *
>> + */
>> +
>> +/* #define DEBUG */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/init.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/slab.h>
>> +#include <linux/mutex.h>
>> +#include <linux/timer.h>
>> +#include <linux/i2c-msm.h>
> 
> I do not understand why yo need to expose this controller's private data
> to the whole Linux world. Shouldn't this be <mach/i2c-msm.h>?
> 
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_VERSION("0.2");
>> +MODULE_ALIAS("platform:i2c_qup");
>> +MODULE_AUTHOR("Sagar Dharia <sdharia@codeaurora.org>");
>> +
>> +/* QUP Registers */
>> +enum {
>> +       QUP_CONFIG              = 0x0,
>> +       QUP_STATE               = 0x4,
>> +       QUP_IO_MODE             = 0x8,
>> +       QUP_SW_RESET            = 0xC,
>> +       QUP_OPERATIONAL         = 0x18,
>> +       QUP_ERROR_FLAGS         = 0x1C,
>> +       QUP_ERROR_FLAGS_EN      = 0x20,
>> +       QUP_MX_READ_CNT         = 0x208,
>> +       QUP_MX_INPUT_CNT        = 0x200,
>> +       QUP_MX_WR_CNT           = 0x100,
>> +       QUP_OUT_DEBUG           = 0x108,
>> +       QUP_OUT_FIFO_CNT        = 0x10C,
>> +       QUP_OUT_FIFO_BASE       = 0x110,
>> +       QUP_IN_READ_CUR         = 0x20C,
>> +       QUP_IN_DEBUG            = 0x210,
>> +       QUP_IN_FIFO_CNT         = 0x214,
>> +       QUP_IN_FIFO_BASE        = 0x218,
>> +       QUP_I2C_CLK_CTL         = 0x400,
>> +       QUP_I2C_STATUS          = 0x404,
>> +};
> 
> anonymous?
> 
>> +
>> +/* QUP States and reset values */
>> +enum {
>> +       QUP_RESET_STATE         = 0,
>> +       QUP_RUN_STATE           = 1U,
>> +       QUP_STATE_MASK          = 3U,
>> +       QUP_PAUSE_STATE         = 3U,
>> +       QUP_STATE_VALID         = 1U << 2,
>> +       QUP_I2C_MAST_GEN        = 1U << 4,
>> +       QUP_OPERATIONAL_RESET   = 0xFF0,
>> +       QUP_I2C_STATUS_RESET    = 0xFFFFFC,
>> +};
> 
> anonymous, ditto for all the following enums.
> 
>> +
>> +/* QUP OPERATIONAL FLAGS */
>> +enum {
>> +       QUP_OUT_SVC_FLAG        = 1U << 8,
>> +       QUP_IN_SVC_FLAG         = 1U << 9,
>> +       QUP_MX_INPUT_DONE       = 1U << 11,
>> +};
>> +
>> +/* I2C mini core related values */
>> +enum {
>> +       I2C_MINI_CORE           = 2U << 8,
>> +       I2C_N_VAL               = 0xF,
>> +};
>> +
>> +/* Packing Unpacking words in FIFOs , and IO modes*/
>> +enum {
>> +       QUP_WR_BLK_MODE  = 1U << 10,
>> +       QUP_RD_BLK_MODE  = 1U << 12,
>> +       QUP_UNPACK_EN = 1U << 14,
>> +       QUP_PACK_EN = 1U << 15,
>> +};
>> +
>> +/* QUP tags */
>> +enum {
>> +       QUP_OUT_NOP   = 0,
>> +       QUP_OUT_START = 1U << 8,
>> +       QUP_OUT_DATA  = 2U << 8,
>> +       QUP_OUT_STOP  = 3U << 8,
>> +       QUP_OUT_REC   = 4U << 8,
>> +       QUP_IN_DATA   = 5U << 8,
>> +       QUP_IN_STOP   = 6U << 8,
>> +       QUP_IN_NACK   = 7U << 8,
>> +};
>> +
>> +/* Status, Error flags */
>> +enum {
>> +       I2C_STATUS_WR_BUFFER_FULL  = 1U << 0,
>> +       I2C_STATUS_BUS_ACTIVE      = 1U << 8,
>> +       I2C_STATUS_ERROR_MASK      = 0x38000FC,
>> +       QUP_I2C_NACK_FLAG          = 1U << 3,
>> +       QUP_IN_NOT_EMPTY           = 1U << 5,
>> +       QUP_STATUS_ERROR_FLAGS     = 0x7C,
>> +};
>> +
>> +/* GSBI Control Register */
>> +enum {
>> +       GSBI_I2C_PROTOCOL_CODE  = 0x2 << 4,     /* I2C protocol */
>> +};
>> +
>> +#define QUP_MAX_RETRIES        2000
>> +#define QUP_SRC_CLK_RATE       19200000        /* Default source clock rate */
> 
> why do want this while having this module dependent on HAVE_CLK
> 
>> +
>> +struct qup_i2c_dev {
>> +       struct device                *dev;
>> +       void __iomem                 *base;             /* virtual */
>> +       void __iomem                 *gsbi;             /* virtual */
>> +       int                          in_irq;
>> +       int                          out_irq;
>> +       int                          err_irq;
>> +       int                          num_irqs;
>> +       struct clk                   *clk;
>> +       struct clk                   *pclk;
>> +       struct i2c_adapter           adapter;
>> +
>> +       struct i2c_msg               *msg;
>> +       int                          pos;
>> +       int                          cnt;
>> +       int                          err;
>> +       int                          mode;
>> +       int                          clk_ctl;
>> +       int                          one_bit_t;
>> +       int                          out_fifo_sz;
>> +       int                          in_fifo_sz;
>> +       int                          out_blk_sz;
>> +       int                          in_blk_sz;
>> +       int                          wr_sz;
>> +       struct msm_i2c_platform_data *pdata;
>> +       int                          suspended;
>> +       int                          clk_state;
>> +       struct timer_list            pwr_timer;
>> +       struct mutex                 mlock;
>> +       void                         *complete;
>> +};
> 
> too many local parameters. Do you really need all of this? Moreover it
> is not readable. Would suggest to document it at least using kernel-doc
> style.

I believe everything is needed but I will improve the documentation

> 
>> +
>> +#ifdef DEBUG
>> +static void
>> +qup_print_status(struct qup_i2c_dev *dev)
>> +{
>> +       uint32_t val;
>> +       val = readl(dev->base+QUP_CONFIG);
> 
> space after & before '+'. checkpatch would've complained this about..
> 
>> +       dev_dbg(dev->dev, "Qup config is :0x%x\n", val);
>> +       val = readl(dev->base+QUP_STATE);
> 
> ditto
> 
>> +       dev_dbg(dev->dev, "Qup state is :0x%x\n", val);
>> +       val = readl(dev->base+QUP_IO_MODE);
> 
> ditto
> 
>> +       dev_dbg(dev->dev, "Qup mode is :0x%x\n", val);
>> +}
>> +#else
>> +static inline void qup_print_status(struct qup_i2c_dev *dev)
>> +{
>> +}
>> +#endif
>> +
>> +static irqreturn_t
>> +qup_i2c_interrupt(int irq, void *devid)
>> +{
>> +       struct qup_i2c_dev *dev = devid;
>> +       uint32_t status = readl(dev->base + QUP_I2C_STATUS);
>> +       uint32_t errors = readl(dev->base + QUP_ERROR_FLAGS);
>> +       uint32_t op_flgs = readl(dev->base + QUP_OPERATIONAL);
>> +       int err = 0;
>> +
>> +       if (!dev->msg)
>> +               return IRQ_HANDLED;
>> +
>> +       if (status & I2C_STATUS_ERROR_MASK) {
>> +               dev_err(dev->dev, "QUP: I2C status flags :0x%x, irq:%d\n",
>> +                       status, irq);
>> +               err = -status;
>> +               /* Clear Error interrupt if it's a level triggered interrupt*/
> 
> /*<space> ... <space>*/
> 
>> +               if (dev->num_irqs == 1)
>> +                       writel(QUP_RESET_STATE, dev->base+QUP_STATE);
>> +               goto intr_done;
>> +       }
>> +
>> +       if (errors & QUP_STATUS_ERROR_FLAGS) {
>> +               dev_err(dev->dev, "QUP: QUP status flags :0x%x\n", errors);
>> +               err = -errors;
>> +               /* Clear Error interrupt if it's a level triggered interrupt*/
> 
> ditto
> 
>> +               if (dev->num_irqs == 1)
>> +                       writel(errors & QUP_STATUS_ERROR_FLAGS,
>> +                               dev->base + QUP_ERROR_FLAGS);
>> +               goto intr_done;
>> +       }
>> +
>> +       if ((dev->num_irqs == 3) && (dev->msg->flags == I2C_M_RD)
>> +               && (irq == dev->out_irq))
>> +               return IRQ_HANDLED;
>> +       if (op_flgs & QUP_OUT_SVC_FLAG)
>> +               writel(QUP_OUT_SVC_FLAG, dev->base + QUP_OPERATIONAL);
>> +       if (dev->msg->flags == I2C_M_RD) {
>> +               if ((op_flgs & QUP_MX_INPUT_DONE) ||
>> +                       (op_flgs & QUP_IN_SVC_FLAG))
>> +                       writel(QUP_IN_SVC_FLAG, dev->base + QUP_OPERATIONAL);
>> +               else
>> +                       return IRQ_HANDLED;
>> +       }
>> +
>> +intr_done:
>> +       dev_dbg(dev->dev, "QUP intr= %d, i2c status=0x%x, qup status = 0x%x\n",
>> +                       irq, status, errors);
>> +       qup_print_status(dev);
>> +       dev->err = err;
>> +       complete(dev->complete);
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static void
>> +qup_i2c_pwr_mgmt(struct qup_i2c_dev *dev, unsigned int state)
>> +{
>> +       dev->clk_state = state;
>> +       if (state != 0) {
>> +               clk_enable(dev->clk);
>> +               if (dev->pclk)
>> +                       clk_enable(dev->pclk);
>> +       } else {
>> +               clk_disable(dev->clk);
>> +               if (dev->pclk)
>> +                       clk_disable(dev->pclk);
>> +       }
>> +}
>> +
>> +static void
>> +qup_i2c_pwr_timer(unsigned long data)
>> +{
>> +       struct qup_i2c_dev *dev = (struct qup_i2c_dev *) data;
>> +       dev_dbg(dev->dev, "QUP_Power: Inactivity based power management\n");
>> +       if (dev->clk_state == 1)
>> +               qup_i2c_pwr_mgmt(dev, 0);
>> +}
>> +
>> +static int
>> +qup_i2c_poll_writeready(struct qup_i2c_dev *dev)
>> +{
>> +       uint32_t retries = 0;
>> +
>> +       while (retries != QUP_MAX_RETRIES) {
>> +               uint32_t status = readl(dev->base + QUP_I2C_STATUS);
>> +
>> +               if (!(status & I2C_STATUS_WR_BUFFER_FULL)) {
>> +                       if (!(status & I2C_STATUS_BUS_ACTIVE))
>> +                               return 0;
>> +                       else /* 1-bit delay before we check for bus busy */
>> +                               udelay(dev->one_bit_t);
>> +               }
>> +               if (retries++ == 1000)
>> +                       udelay(100);
>> +       }
>> +       qup_print_status(dev);
>> +       return -ETIMEDOUT;
>> +}
>> +
>> +static int
>> +qup_i2c_poll_state(struct qup_i2c_dev *dev, uint32_t state)
>> +{
>> +       uint32_t retries = 0;
>> +
>> +       dev_dbg(dev->dev, "Polling Status for state:0x%x\n", state);
> 
> &dev->dev

dev->dev is a pointer to a struct device so this should be valid unless 
I am missing something.

> 
> 
> (...)
> 
> Srinidhi
> 
> 
> 


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
