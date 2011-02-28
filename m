Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1B1Sd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:33:26 -0500
Received: from www.tglx.de ([62.245.132.106]:32834 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1B1SdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:33:24 -0500
Date: Mon, 28 Feb 2011 19:33:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
In-Reply-To: <1298887229-7987-4-git-send-email-s.hauer@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1102281858240.2701@localhost6.localdomain6>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de> <1298887229-7987-4-git-send-email-s.hauer@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011, Sascha Hauer wrote:
> +
> +static int ipu_use_count;
> +
> +static struct ipu_channel channels[64];
> +
> +struct ipu_channel *ipu_idmac_get(unsigned num)
> +{
> +	struct ipu_channel *channel;
> +
> +	dev_dbg(ipu_dev, "%s %d\n", __func__, num);
> +
> +	if (num > 63)

  >= ARRAY_SIZE(channels) or a sensible define please

> +		return ERR_PTR(-ENODEV);
> +
> +	mutex_lock(&ipu_channel_lock);
> +
> +	channel = &channels[num];
> +
> +	if (channel->busy) {
> +		channel = ERR_PTR(-EBUSY);
> +		goto out;
> +	}
> +
> +	channel->busy = 1;
> +	channel->num = num;
> +
> +out:
> +	mutex_unlock(&ipu_channel_lock);
> +
> +	return channel;
> +}
> +EXPORT_SYMBOL(ipu_idmac_get);

EXPORT_SYMBOL_GPL all over the place

> +void ipu_idmac_put(struct ipu_channel *channel)
> +{
> +	dev_dbg(ipu_dev, "%s %d\n", __func__, channel->num);

Do we really need this debug stuff in all these functions ?

> +	mutex_lock(&ipu_channel_lock);
> +
> +	channel->busy = 0;
> +
> +	mutex_unlock(&ipu_channel_lock);
> +}
> +EXPORT_SYMBOL(ipu_idmac_put);
> +

Also exported functions want a proper kerneldoc comment.

> +void ipu_idmac_set_double_buffer(struct ipu_channel *channel, bool doublebuffer)

> +static LIST_HEAD(ipu_irq_handlers);
> +
> +static void ipu_irq_update_irq_mask(void)
> +{
> +	struct ipu_irq_handler *handler;
> +	int i;
> +
> +	DECLARE_IPU_IRQ_BITMAP(irqs);

Why the hell do we need this? It's a bog standard bitmap, right ?

> +	bitmap_zero(irqs, IPU_IRQ_COUNT);
> +
> +	list_for_each_entry(handler, &ipu_irq_handlers, list)
> +		bitmap_or(irqs, irqs, handler->ipu_irqs, IPU_IRQ_COUNT);
> +
> +	for (i = 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++)
> +		ipu_cm_write(irqs[i], IPU_INT_CTRL(i + 1));
> +}

> +static void ipu_completion_handler(unsigned long *bitmask, void *context)
> +{
> +	struct completion *completion = context;
> +
> +	complete(completion);
> +}
> +
> +int ipu_wait_for_interrupt(int interrupt, int timeout_ms)
> +{
> +	struct ipu_irq_handler handler;
> +	DECLARE_COMPLETION_ONSTACK(completion);
> +	int ret;
> +
> +	bitmap_zero(handler.ipu_irqs, IPU_IRQ_COUNT);
> +	bitmap_set(handler.ipu_irqs, interrupt, 1);
> +
> +	ipu_cm_write(1 << (interrupt % 32), IPU_INT_STAT(interrupt / 32 + 1));
> +
> +	handler.handler = ipu_completion_handler;
> +	handler.context = &completion;
> +	ipu_irq_add_handler(&handler);
> +
> +	ret = wait_for_completion_timeout(&completion,
> +			msecs_to_jiffies(timeout_ms));
> +
> +	ipu_irq_remove_handler(&handler);
> +
> +	if (ret > 0)
> +		ret = 0;
> +	else
> +		ret = -ETIMEDOUT;
> +
> +	return ret;

  return ret > 0 ? 0 : -ETIMEDOUT;

  perhaps ?


> +}
> +EXPORT_SYMBOL(ipu_wait_for_interrupt);
> +
> +static irqreturn_t ipu_irq_handler(int irq, void *desc)
> +{
> +	DECLARE_IPU_IRQ_BITMAP(status);
> +	struct ipu_irq_handler *handler;
> +	int i;
> +
> +	for (i = 0; i < BITS_TO_LONGS(IPU_IRQ_COUNT); i++) {
> +		status[i] = ipu_cm_read(IPU_INT_STAT(i + 1));
> +		ipu_cm_write(status[i], IPU_INT_STAT(i + 1));
> +	}
> +
> +	list_for_each_entry(handler, &ipu_irq_handlers, list) {
> +		DECLARE_IPU_IRQ_BITMAP(tmp);
> +		if (bitmap_and(tmp, status, handler->ipu_irqs, IPU_IRQ_COUNT))
> +			handler->handler(tmp, handler->context);
> +	}

And what protects the list walk? Just the fact that this is a UP
machine?

> +void ipu_put(void)
> +{
> +	mutex_lock(&ipu_channel_lock);
> +
> +	ipu_use_count--;
> +
> +	if (ipu_use_count == 0)
> +		clk_disable(ipu_clk);
> +
> +	if (ipu_use_count < 0) {
> +		dev_err(ipu_dev, "ipu use count < 0\n");

This wants to be a WARN_ON(ipu_use_count < 0) so you get some
information which code is calling this.

> +		ipu_use_count = 0;
> +	}
> +
> +	mutex_unlock(&ipu_channel_lock);
> +}

> +static int __devinit ipu_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	unsigned long ipu_base;
> +	int ret, irq1, irq2;
> +
> +	/* There can be only one */
> +	if (ipu_dev)
> +		return -EBUSY;
> +
> +	spin_lock_init(&ipu_lock);
> +
> +	ipu_dev = &pdev->dev;
> +
> +	irq1 = platform_get_irq(pdev, 0);
> +	irq2 = platform_get_irq(pdev, 1);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	if (!res || irq1 < 0 || irq2 < 0)
> +		return -ENODEV;
> +
> +	ipu_base = res->start;
> +
> +	ipu_cm_reg = ioremap(ipu_base + IPU_CM_REG_BASE, PAGE_SIZE);
> +	if (!ipu_cm_reg) {
> +		ret = -ENOMEM;
> +		goto failed_ioremap1;
> +	}
> +
> +	ipu_idmac_reg = ioremap(ipu_base + IPU_IDMAC_REG_BASE, PAGE_SIZE);
> +	if (!ipu_idmac_reg) {
> +		ret = -ENOMEM;
> +		goto failed_ioremap2;
> +	}
> +
> +	ipu_clk = clk_get(&pdev->dev, "ipu");
> +	if (IS_ERR(ipu_clk)) {
> +		ret = PTR_ERR(ipu_clk);
> +		dev_err(&pdev->dev, "clk_get failed with %d", ret);
> +		goto failed_clk_get;
> +	}
> +
> +	ipu_get();
> +
> +	ret = request_irq(irq1, ipu_irq_handler, IRQF_DISABLED, pdev->name,
> +			&pdev->dev);

s/IRQF_DISABLED/0/ We run all handlers with interrupts disabled
nowadays.

> +	ret = ipu_submodules_init(pdev, ipu_base, ipu_clk);
> +	if (ret)
> +		goto failed_submodules_init;
> +
> +	/* Set sync refresh channels as high priority */
> +	ipu_idmac_write(0x18800000, IDMAC_CHA_PRI(0));

Hmm, this random prio setting here is odd.

> +	ret = ipu_add_client_devices(pdev);
> +        if (ret) {
> +                dev_err(&pdev->dev, "adding client devices failed with %d\n", ret);
> +		goto failed_add_clients;
> +        }

White space damage.

> +	ret = ipu_wait_for_interrupt(irq, 50);
> +	if (ret)
> +		return;
> +
> +	/* Wait for DC triple buffer to empty */
> +	if (dc_channels[dc_chan].di == 0)
> +		while ((__raw_readl(DC_STAT) & 0x00000002)
> +			!= 0x00000002) {
> +			msleep(2);
> +			timeout -= 2;
> +			if (timeout <= 0)
> +				break;

So we poll stuff which is updated from some other function ?

> +		}
> +	else if (dc_channels[dc_chan].di == 1)
> +		while ((__raw_readl(DC_STAT) & 0x00000020)
> +			!= 0x00000020) {
> +			msleep(2);
> +			timeout -= 2;
> +			if (timeout <= 0)
> +				break;

Ditto

> +	}

Thanks,

	tglx
