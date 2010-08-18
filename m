Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0HRNmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:42:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50467 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0HRNmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F3GpiQGoTwA4tlUVZ87dIsqiKys/OLEf3bwSR4CDip7zND4spv/iMUepuQyu8b00Zc
         9lfasYeQXlbJiri90WVAVj2Z1NuqLQYzZcPVPnV9GOOpFq/Zr4zp9hi5SFdfw6aBXppM
         3eb1XvZQA2FvfIiC5F+THjW0huTsxqjPO/QQg=
Date: Wed, 18 Aug 2010 17:42:37 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dwmw2@infradead.org, felipe.balbi@nokia.com, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, roger.quadros@nokia.com
Subject: Re: [PATCH] power_supply: add isp1704 charger detection driver
Message-ID: <20100818134237.GA4799@oksana.dev.rtsoft.ru>
References: <1282136465-1748-1-git-send-email-ext-heikki.krogerus@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1282136465-1748-1-git-send-email-ext-heikki.krogerus@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 04:01:05PM +0300, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
> 
> NXP ISP1704 is Battery Charging Specification 1.0 compliant USB
> transceiver. This adds a power supply driver for ISP1704 and
> ISP1707 USB transceivers.
> 
> Signed-off-by: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
> ---

I like this driver (very). A few, mostly cosmetic comments down
below.

[...]
> +config CHARGER_ISP1704
> +     tristate "ISP1704 USB Charger Detection"
> +     select NOP_USB_XCEIV if ! MACH_NOKIA_RX51
> +     help

"! MACH_NOKIA_RX51" looks wrong here. You probably don't actually
need this if you fix platform device registration issue (see the
very bottom of this email).

[...]
> +/*
> + * ISP1704 detects PS/2 adapters as charger. To make sure the detected charger
> + * is actually a dedicated charger, the following steps need to be taken.
> + */
> +static inline int isp1704_charger_verify(struct isp1704_charger *isp)
> +{
> +	u8 r, ret = 0;

Please put variable declarations on separate lines, plus,
'ret' should probably be int, i.e.

	int ret;
	u8 r;

> +
> +	/* Reset the transceiver */
> +	r = otg_io_read(isp->otg, ULPI_FUNC_CTRL);
> +	r |= ULPI_FUNC_CTRL_RESET;
> +	otg_io_write(isp->otg, ULPI_FUNC_CTRL, r);
> +	usleep_range(1000, 2000);
> +
> +	/* Set normal mode */
> +	r &= ~(ULPI_FUNC_CTRL_RESET | ULPI_FUNC_CTRL_OPMODE_MASK);
> +	otg_io_write(isp->otg, ULPI_FUNC_CTRL, r);
> +
> +	/* Clear the DP and DM pull-down bits */
> +	r = ULPI_OTG_CTRL_DP_PULLDOWN | ULPI_OTG_CTRL_DM_PULLDOWN;
> +	otg_io_write(isp->otg, ULPI_CLR(ULPI_OTG_CTRL), r);
> +
> +	/* Enable strong pull-up on DP (1.5K) and reset */
> +	r = ULPI_FUNC_CTRL_TERMSELECT | ULPI_FUNC_CTRL_RESET;
> +	otg_io_write(isp->otg, ULPI_SET(ULPI_FUNC_CTRL), r);
> +	usleep_range(1000, 2000);
> +
> +	/* Read the line state */
> +	if (otg_io_read(isp->otg, ULPI_DEBUG)) {
> +		/* Is it a charger or PS/2 connection */
> +
> +		/* Enable weak pull-up resistor on DP */
> +		otg_io_write(isp->otg, ULPI_SET(ISP1704_PWR_CTRL),
> +				ISP1704_PWR_CTRL_DP_WKPU_EN);
> +
> +		/* Disable strong pull-up on DP (1.5K) */
> +		otg_io_write(isp->otg, ULPI_CLR(ULPI_FUNC_CTRL),
> +				ULPI_FUNC_CTRL_TERMSELECT);
> +
> +		/* Enable weak pull-down resistor on DM */
> +		otg_io_write(isp->otg, ULPI_SET(ULPI_OTG_CTRL),
> +				ULPI_OTG_CTRL_DM_PULLDOWN);
> +
> +		/* It's a charger if the line states are clear */
> +		if (!(otg_io_read(isp->otg, ULPI_DEBUG)))
> +			ret = 1;
> +
> +		/* Disable weak pull-up resistor on DP */
> +		otg_io_write(isp->otg, ULPI_CLR(ISP1704_PWR_CTRL),
> +				ISP1704_PWR_CTRL_DP_WKPU_EN);
> +	} else {
> +		ret = 1;
> +
> +		/* Disable strong pull-up on DP (1.5K) */
> +		otg_io_write(isp->otg, ULPI_CLR(ULPI_FUNC_CTRL),
> +				ULPI_FUNC_CTRL_TERMSELECT);
> +	}

How about

if (!otg_io_read(isp->otg, ULPI_DEBUG)) {
	/* Disable strong pull-up on DP (1.5K) */
	otg_io_write(isp->otg, ULPI_CLR(ULPI_FUNC_CTRL),
			ULPI_FUNC_CTRL_TERMSELECT);
	return 1;
}

<the rest>

Saves indentation level.

> +	return ret;
> +}
> +
> +static inline int isp1704_charger_detect(struct isp1704_charger *isp)
> +{
> +	unsigned long	timeout;
> +	u8		r;
> +	int		vdat;
> +
> +	/* set SW control bit in PWR_CTRL register */
> +	otg_io_write(isp->otg, ISP1704_PWR_CTRL,
> +			ISP1704_PWR_CTRL_SWCTRL);
> +
> +	/* enable manual charger detection */
> +	r = (ISP1704_PWR_CTRL_SWCTRL | ISP1704_PWR_CTRL_DPVSRC_EN);
> +	otg_io_write(isp->otg, ULPI_SET(ISP1704_PWR_CTRL), r);
> +	usleep_range(1000, 2000);
> +
> +	timeout = jiffies + msecs_to_jiffies(300);
> +	while (!time_after(jiffies, timeout)) {

I guess it is possible that vdat might become uninitialized
if the code never hits the loop. The time between
	timeout = jiffies + msecs_to_jiffies(300);
and
	while (!time_after(jiffies, timeout)) {
is undefined.

> +		/* Check if there is a charger */
> +		vdat = !!(otg_io_read(isp->otg, ISP1704_PWR_CTRL)
> +				& ISP1704_PWR_CTRL_VDAT_DET);

Technically, there is no need for "!!".

> +		if (vdat)
> +			break;
> +	}
> +	return vdat;
> +}
> +
> +static void isp1704_charger_work(struct work_struct *data)
> +{
> +	struct isp1704_charger	*isp =
> +		container_of(data, struct isp1704_charger, work);
> +
> +	/* FIXME Only supporting dedicated chargers even though isp1704 can
> +	 * detect HUB and HOST chargers. If the device has already been
> +	 * enumerated, the detection will break the connection.
> +	 */
> +	if (isp->otg->state != OTG_STATE_B_IDLE)
> +		return;
> +
> +	/* disable data pullups */
> +	if (isp->otg->gadget)
> +		usb_gadget_disconnect(isp->otg->gadget);
> +
> +	/* detect charger */

shouldn't be there 'isp->present = 0;'?..

> +	if (isp1704_charger_detect(isp))
> +		isp->present = isp1704_charger_verify(isp);

i.e. it's kinda weird to see conditional isp->present update...

> +
> +	/* enable data pullups */
> +	if (isp->otg->gadget)
> +		usb_gadget_connect(isp->otg->gadget);
> +
> +	if (isp->present)

...and then unconditional checking of isp->present.

I guess the code is OK, and somewhere else the logic handles
this... but still an odd-looking function.

> +		power_supply_changed(&isp->psy);
> +}
> +
> +static int isp1707_notifier_call(struct notifier_block *nb,
> +		unsigned long event, void *unused)
> +{
> +	struct isp1704_charger *isp =
> +		container_of(nb, struct isp1704_charger, nb);
> +
> +	switch (event) {
> +	case USB_EVENT_VBUS:
> +		schedule_work(&isp->work);
> +		break;
> +	case USB_EVENT_NONE:
> +		isp->present = 0;

Probably this makes the code above work. But why don't we
call schedule_work(&isp->work)?

[...]
> +static inline int isp1704_test_ulpi(struct isp1704_charger *isp)
> +{
> +	int			vendor, product, i;

int vendor;
int product;
int i;

> +	int			ret = -ENODEV;
> +
> +	/* Test ULPI interface */
> +	ret = otg_io_write(isp->otg, ULPI_SCRATCH, 0xaa);
> +	if (ret < 0)
> +		return ret;

By adding empty line here you'll make the code prettier.

> +	ret = otg_io_read(isp->otg, ULPI_SCRATCH);
> +	if (ret < 0)
> +		return ret;

Ditto.

> +	if (ret != 0xaa)
> +		return -ENODEV;

Ditto.

> +	/* Verify the product and vendor id matches */
> +	vendor = otg_io_read(isp->otg, ULPI_VENDOR_ID_LOW);
> +	vendor |= otg_io_read(isp->otg, ULPI_VENDOR_ID_HIGH) << 8;
> +	if (vendor != NXP_VENDOR_ID)
> +		return -ENODEV;

Ditto.

> +	for (i = 0; i < ARRAY_SIZE(isp170x_id); i++) {
> +		product = otg_io_read(isp->otg, ULPI_PRODUCT_ID_LOW);
> +		product |= otg_io_read(isp->otg, ULPI_PRODUCT_ID_HIGH) << 8;
> +		if (product == isp170x_id[i]) {
> +			sprintf(isp->model, "isp%x", product);
> +			return product;
> +		}
> +	}
> +
> +	dev_err(isp->dev, "product id %x not matching known ids", product);
> +
> +	return -ENODEV;
> +}
> +
> +static int __devinit isp1704_charger_probe(struct platform_device *pdev)
> +{
> +	struct isp1704_charger	*isp;
> +	int			ret = -ENODEV;
> +
> +	isp = kzalloc(sizeof *isp, GFP_KERNEL);
> +	if (!isp)
> +		return -ENOMEM;
> +
> +	isp->otg = otg_get_transceiver();
> +	if (!isp->otg) {
> +		kfree(isp);
> +		return ret;

goto failX instead?

> +	}
> +
> +	ret = isp1704_test_ulpi(isp);
> +	if (ret < 0)
> +		goto fail;
> +
> +	isp->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, isp);
> +
> +	isp->psy.name		= "isp1704";
> +	isp->psy.type		= POWER_SUPPLY_TYPE_USB;
> +	isp->psy.properties	= power_props;
> +	isp->psy.num_properties	= ARRAY_SIZE(power_props);
> +	isp->psy.get_property	= isp1704_charger_get_property;
> +
> +	ret = power_supply_register(isp->dev, &isp->psy);
> +	if (ret)
> +		goto fail;
> +
> +	/* REVISIT: using work in order to allow the otg notifications to be
> +	 * made atomically in the future.
> +	 */
> +	INIT_WORK(&isp->work, isp1704_charger_work);
> +
> +	isp->nb.notifier_call = isp1707_notifier_call;

Add an empty line here?

> +	ret = otg_register_notifier(isp->otg, &isp->nb);
> +	if (ret)
> +		goto fail2;
> +
> +	dev_info(isp->dev, "registered with product id %s\n", isp->model);
> +
> +	return 0;
> +fail2:
> +	power_supply_unregister(&isp->psy);
> +fail:
> +	otg_put_transceiver(isp->otg);
> +	kfree(isp);
> +
> +	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
> +
> +	return ret;
> +}
[...]
> +static int __init isp1704_charger_init(void)
> +{
> +	int ret = 0;
> +
> +	ret = platform_driver_register(&isp1704_charger_driver);
> +	if (ret)
> +		return ret;
> +
> +	isp1704_device = platform_device_register_simple("isp1704_charger",
> +							0, NULL, 0);

This is wrong. Please move this into either isp1704 generic
or usb driver (if any), or platform (board) code.

That way you also won't need "! MACH_NOKIA_RX51" in the Kconfig.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
