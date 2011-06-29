Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1F2GkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:40:05 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46571 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1F2GkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:40:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110627215955.GA23027@freya.fluff.org>
References: <1308032369-1615-1-git-send-email-ratbert.chuang@gmail.com> <20110627215955.GA23027@freya.fluff.org>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Wed, 29 Jun 2011 14:39:38 +0800
Message-ID: <BANLkTinHsg1FWRdAE2dxsJ6Shxrh7+HUeA@mail.gmail.com>
Subject: Re: [PATCH] i2c: add Faraday FTIIC010 I2C controller support
To: Ben Dooks <ben-i2c@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org, ben-linux@fluff.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Tue, Jun 28, 2011 at 5:59 AM, Ben Dooks <ben-i2c@fluff.org> wrote:
> On Tue, Jun 14, 2011 at 02:19:29PM +0800, Po-Yu Chuang wrote:
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> Support for Faraday FTIIC010 I2C controller. It is used on
>> Faraday A320, A369 and some other ARM SoC's.
>>
>> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
>> ---
>>  drivers/i2c/busses/Kconfig        |    7 +
>>  drivers/i2c/busses/Makefile       |    1 +
>>  drivers/i2c/busses/i2c-ftiic010.c |  434 +++++++++++++++++++++++++++++++++++++
>>  drivers/i2c/busses/i2c-ftiic010.h |  155 +++++++++++++
>>  4 files changed, 597 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/i2c/busses/i2c-ftiic010.c
>>  create mode 100644 drivers/i2c/busses/i2c-ftiic010.h
>>
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index 326652f..612c2b1 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -358,6 +358,13 @@ config I2C_DESIGNWARE
>>         This driver can also be built as a module.  If so, the module
>>         will be called i2c-designware.
>>
>> +config I2C_FTIIC010
>> +     tristate "Faraday FTIIC010 I2C controller"
>> +     depends on HAVE_CLK
>> +     help
>> +       Support for Faraday FTIIC010 I2C controller. It is used on
>> +       Faraday A320, A369 and some other ARM SoC's.
>> +
>
> is there a better depends line for this? is there an ARCH_xxx or some
> other way of ensuring this doesn't get shown for all systems that
> happen to support CLK?

OK, will fix this.

>
>>  config I2C_GPIO
>>       tristate "GPIO-based bitbanging I2C"
>>       depends on GENERIC_GPIO
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index e6cf294..c49570d 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -34,6 +34,7 @@ obj-$(CONFIG_I2C_BLACKFIN_TWI)      += i2c-bfin-twi.o
>>  obj-$(CONFIG_I2C_CPM)                += i2c-cpm.o
>>  obj-$(CONFIG_I2C_DAVINCI)    += i2c-davinci.o
>>  obj-$(CONFIG_I2C_DESIGNWARE) += i2c-designware.o
>> +obj-$(CONFIG_I2C_FTIIC010)   += i2c-ftiic010.o
>>  obj-$(CONFIG_I2C_GPIO)               += i2c-gpio.o
>>  obj-$(CONFIG_I2C_HIGHLANDER) += i2c-highlander.o
>>  obj-$(CONFIG_I2C_IBM_IIC)    += i2c-ibm_iic.o
>> diff --git a/drivers/i2c/busses/i2c-ftiic010.c b/drivers/i2c/busses/i2c-ftiic010.c
>> new file mode 100644
>> index 0000000..ed86f06
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-ftiic010.c
>> @@ -0,0 +1,434 @@
>> +/*
>> + * Faraday FTIIC010 I2C Controller
>> + *
>> + * (C) Copyright 2010-2011 Faraday Technology
>> + * Po-Yu Chuang <ratbert@faraday-tech.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +
>> +#include "i2c-ftiic010.h"
>> +
>> +#define SCL_SPEED    (100 * 1000)
>> +#define MAX_RETRY    1000
>> +
>> +#define GSR  5
>> +#define TSR  5
>> +
>> +struct ftiic010 {
>> +     struct resource *res;
>> +     void __iomem *base;
>> +     int irq;
>> +     struct clk *clk;
>> +     struct i2c_adapter adapter;
>> +};
>> +
>> +/******************************************************************************
>> + * internal functions
>> + *****************************************************************************/
>> +static void ftiic010_reset(struct ftiic010 *ftiic010)
>> +{
>> +     int cr = FTIIC010_CR_I2C_RST;
>> +
>> +     iowrite32(cr, ftiic010->base + FTIIC010_OFFSET_CR);
>> +
>> +     /* wait until reset bit cleared by hw */
>> +     while (ioread32(ftiic010->base + FTIIC010_OFFSET_CR) & FTIIC010_CR_I2C_RST)
>> +             ;
>
> how about calls to cpu_relax() during these loops?
> also, do we ever expect timeout?

OK, will fix this.

>
>> +}
>
> I think iowrite32/ioread32 are ok on these.

Not sure what do you mean here.

>> +
>> +static void ftiic010_set_clock_speed(struct ftiic010 *ftiic010, int hz)
>> +{
>> +     unsigned long pclk;
>> +     int cdr;
>> +
>> +     pclk = clk_get_rate(ftiic010->clk);
>> +
>> +     cdr = (pclk / hz - GSR) / 2 - 2;
>> +     cdr &= FTIIC010_CDR_MASK;
>> +
>> +     dev_dbg(&ftiic010->adapter.dev, "  [CDR] = %08x\n", cdr);
>> +     iowrite32(cdr, ftiic010->base + FTIIC010_OFFSET_CDR);
>> +}
>> +
>> +static void ftiic010_set_tgsr(struct ftiic010 *ftiic010, int tsr, int gsr)
>> +{
>> +     int tgsr;
>> +
>> +     tgsr = FTIIC010_TGSR_TSR(tsr);
>> +     tgsr |= FTIIC010_TGSR_GSR(gsr);
>> +
>> +     dev_dbg(&ftiic010->adapter.dev, "  [TGSR] = %08x\n", tgsr);
>> +     iowrite32(tgsr, ftiic010->base + FTIIC010_OFFSET_TGSR);
>> +}
>> +
>> +static void ftiic010_hw_init(struct ftiic010 *ftiic010)
>> +{
>> +     ftiic010_reset(ftiic010);
>> +     ftiic010_set_tgsr(ftiic010, TSR, GSR);
>> +     ftiic010_set_clock_speed(ftiic010, SCL_SPEED);
>> +}
>> +
>> +static inline void ftiic010_set_cr(struct ftiic010 *ftiic010, int start,
>> +             int stop, int nak)
>> +{
>> +     int cr;
>> +
>> +     cr = FTIIC010_CR_I2C_EN
>> +        | FTIIC010_CR_SCL_EN
>> +        | FTIIC010_CR_TB_EN
>> +        | FTIIC010_CR_BERRI_EN
>> +        | FTIIC010_CR_ALI_EN;
>> +
>> +     if (start)
>> +             cr |= FTIIC010_CR_START;
>> +
>> +     if (stop)
>> +             cr |= FTIIC010_CR_STOP;
>> +
>> +     if (nak)
>> +             cr |= FTIIC010_CR_NAK;
>> +
>> +     iowrite32(cr, ftiic010->base + FTIIC010_OFFSET_CR);
>> +}
>> +
>> +static int ftiic010_tx_byte(struct ftiic010 *ftiic010, __u8 data, int start,
>> +             int stop)
>> +{
>> +     struct i2c_adapter *adapter = &ftiic010->adapter;
>> +     int i;
>> +
>> +     iowrite32(data, ftiic010->base + FTIIC010_OFFSET_DR);
>> +     ftiic010_set_cr(ftiic010, start, stop, 0);
>> +
>> +     for (i = 0; i < MAX_RETRY; i++) {
>> +             unsigned int status;
>> +
>> +             status = ioread32(ftiic010->base + FTIIC010_OFFSET_SR);
>> +             if (status & FTIIC010_SR_DT)
>> +                     return 0;
>> +
>> +             udelay(1);
>> +     }
>> +
>> +     dev_err(&adapter->dev, "Failed to transmit\n");
>> +     ftiic010_reset(ftiic010);
>> +     return -EIO;
>> +}
>> +
>> +static int ftiic010_rx_byte(struct ftiic010 *ftiic010, int stop, int nak)
>> +{
>> +     struct i2c_adapter *adapter = &ftiic010->adapter;
>> +     int i;
>> +
>> +     ftiic010_set_cr(ftiic010, 0, stop, nak);
>> +
>> +     for (i = 0; i < MAX_RETRY; i++) {
>> +             unsigned int status;
>> +
>> +             status = ioread32(ftiic010->base + FTIIC010_OFFSET_SR);
>> +             if (status & FTIIC010_SR_DR) {
>> +                     return ioread32(ftiic010->base + FTIIC010_OFFSET_DR)
>> +                             & FTIIC010_DR_MASK;
>> +             }
>> +
>> +             udelay(1);
>> +     }
>> +
>> +     dev_err(&adapter->dev, "Failed to receive\n");
>> +     ftiic010_reset(ftiic010);
>> +     return -EIO;
>> +}
>> +
>> +static int ftiic010_tx_msg(struct ftiic010 *ftiic010,
>> +             struct i2c_msg *msg, int last)
>> +{
>> +     __u8 data;
>> +     int ret;
>> +     int i;
>> +
>> +     data = (msg->addr & 0x7f) << 1;
>> +     ret = ftiic010_tx_byte(ftiic010, data, 1, 0);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     for (i = 0; i < msg->len; i++) {
>> +             int stop = 0;
>> +
>> +             if (last && i + 1 == msg->len)
>> +                     stop = 1;
>> +
>> +             ret = ftiic010_tx_byte(ftiic010, msg->buf[i], 0, stop);
>> +             if (ret < 0)
>> +                     return ret;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int ftiic010_rx_msg(struct ftiic010 *ftiic010,
>> +             struct i2c_msg *msg, int last)
>> +{
>> +     __u8 data;
>> +     int ret;
>> +     int i;
>> +
>> +     data = (msg->addr & 0x7f) << 1 | 1;
>> +     ret = ftiic010_tx_byte(ftiic010, data, 1, 0);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     for (i = 0; i < msg->len; i++) {
>> +             int nak = 0;
>> +
>> +             if (i + 1 == msg->len)
>> +                     nak = 1;
>> +
>> +             ret = ftiic010_rx_byte(ftiic010, last, nak);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             msg->buf[i] = ret;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int ftiic010_do_msg(struct ftiic010 *ftiic010,
>> +             struct i2c_msg *msg, int last)
>> +{
>> +     if (msg->flags & I2C_M_RD)
>> +             return ftiic010_rx_msg(ftiic010, msg, last);
>> +     else
>> +             return ftiic010_tx_msg(ftiic010, msg, last);
>> +}
>
> maybe this could be merged into the parent.

Do you mean merge the content of this function into ftiic010_master_xfer?
Well, I prefer the current small function.

>
> is there any way of using the interrupt handler to do the
> actual transfers, this seems to involve a lot of busy-waiting
> for the hardware.

Originally I used interrupt-driven data transfer, but some users told me that
the latency of interrupt handling is too long for their application.
That's why I use polling now...

>
>> +/******************************************************************************
>> + * interrupt handler
>> + *****************************************************************************/
>> +static irqreturn_t ftiic010_interrupt(int irq, void *dev_id)
>> +{
>> +     struct ftiic010 *ftiic010 = dev_id;
>> +     struct i2c_adapter *adapter = &ftiic010->adapter;
>> +     int sr;
>> +
>> +     sr = ioread32(ftiic010->base + FTIIC010_OFFSET_SR);
>> +
>> +     if (sr & FTIIC010_SR_BERR) {
>> +             dev_err(&adapter->dev, "NAK!\n");
>> +             ftiic010_reset(ftiic010);
>> +     }
>> +
>> +     if (sr & FTIIC010_SR_AL) {
>> +             dev_err(&adapter->dev, "arbitration lost!\n");
>> +             ftiic010_reset(ftiic010);
>> +     }
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +/******************************************************************************
>> + * struct i2c_algorithm functions
>> + *****************************************************************************/
>> +static int ftiic010_master_xfer(struct i2c_adapter *adapter,
>> +             struct i2c_msg *msgs, int num)
>> +{
>> +     struct ftiic010 *ftiic010 = i2c_get_adapdata(adapter);
>> +     int i;
>> +
>> +     for (i = 0; i < num; i++) {
>> +             int last = 0;
>> +             int ret;
>> +
>> +             if (i == num - 1)
>> +                     last = 1;
>> +
>> +             ret = ftiic010_do_msg(ftiic010, &msgs[i], last);
>> +             if (ret)
>> +                     return ret;
>> +     }
>> +
>> +     return num;
>> +}
>> +
>> +static u32 ftiic010_functionality(struct i2c_adapter *adapter)
>> +{
>> +     return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
>> +}
>> +
>> +static struct i2c_algorithm ftiic010_algorithm = {
>> +     .master_xfer    = ftiic010_master_xfer,
>> +     .functionality  = ftiic010_functionality,
>> +};
>> +
>> +/******************************************************************************
>> + * struct platform_driver functions
>> + *****************************************************************************/
>> +static int ftiic010_probe(struct platform_device *pdev)
>> +{
>> +     struct ftiic010 *ftiic010;
>> +     struct resource *res;
>> +     struct clk *clk;
>> +     int irq;
>> +     int ret;
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!res)
>> +             return -ENXIO;
>
> error message, -ENXIO IIRC gets silently discarded by the bus
> layer.

OK, will add it.

>
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (irq < 0)
>> +             return irq;
>
> error print would be useful.

OK

>
>> +     ftiic010 = kzalloc(sizeof(*ftiic010), GFP_KERNEL);
>> +     if (!ftiic010) {
>> +             dev_err(&pdev->dev, "Could not allocate private data\n");
>> +             ret = -ENOMEM;
>> +             goto err_alloc;
>> +     }
>> +
>> +     ftiic010->res = request_mem_region(res->start, resource_size(res),
>> +                                        dev_name(&pdev->dev));
>> +     if (!ftiic010->res) {
>> +             dev_err(&pdev->dev, "Could not reserve memory region\n");
>> +             ret = -ENOMEM;
>> +             goto err_req_mem;
>> +     }
>> +
>> +     ftiic010->base = ioremap(res->start, resource_size(res));
>> +     if (!ftiic010->base) {
>> +             dev_err(&pdev->dev, "Failed to ioremap\n");
>> +             ret = -ENOMEM;
>> +             goto err_ioremap;
>> +     }
>> +
>> +     ret = request_irq(irq, ftiic010_interrupt, IRQF_SHARED, pdev->name,
>> +                       ftiic010);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "Failed to request irq %d\n", irq);
>> +             goto err_req_irq;
>> +     }
>> +
>> +     ftiic010->irq = irq;
>> +
>> +     clk = clk_get(NULL, "pclk");
>> +     if (!clk) {
>> +             dev_err(&pdev->dev, "Failed to get pclk\n");
>> +             goto err_clk;
>> +     }
>
> do you really need a named clock? sounds like the clk_ usage on
> this platform needs some work to it.

Let me think about this.

[snip]

Thanks for your review.
I will fix the mentioned issues and resubmit later.

Best regards,
Po-Yu Chuang
