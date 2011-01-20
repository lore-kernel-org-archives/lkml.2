Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1ATVg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:36:58 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:36167 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1ATVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:36:57 -0500
Message-ID: <4D38AAEB.7020308@wytron.com.tw>
Date: Fri, 21 Jan 2011 05:36:43 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v2] spi: add OpenCores tiny SPI driver
References: <1294800109-31603-1-git-send-email-thomas@wytron.com.tw> <1295249542-26743-1-git-send-email-thomas@wytron.com.tw> <20110120165430.GA24445@angua.secretlab.ca>
In-Reply-To: <20110120165430.GA24445@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thanks a lot for the review.

On 01/21/2011 12:54 AM, Grant Likely wrote:
>>   drivers/spi/oc_tiny_spi.c       |  422 +++++++++++++++++++++++++++++++++++++++
>
> Rename files to spi_oc_tiny.c

OK.

>> +#ifndef CONFIG_TINY_SPI_IDLE_VAL
>> +# define CONFIG_TINY_SPI_IDLE_VAL 0x00
>> +#endif
>
> Do you really want this as a Kconfig symbol?  Looks like something
> that should be configured in pdata or the device tree.

I will drop this def, as linux use 00 as default.

>> +		if (t->len>  1) {
>> +			writeb(CONFIG_TINY_SPI_IDLE_VAL,
>> +			       hw->base + TINY_SPI_TXDATA);
>> +			for (i = 2; i<  t->len; i++) {
>> +				while (!(readb(hw->base + TINY_SPI_STATUS)&
>> +					 TINY_SPI_STATUS_TXR))
>> +					cpu_relax();
>> +				writeb(CONFIG_TINY_SPI_IDLE_VAL,
>> +				       hw->base + TINY_SPI_TXDATA);
>> +			}
>> +		}
>> +		while (!(readb(hw->base + TINY_SPI_STATUS)&
>> +			 TINY_SPI_STATUS_TXE))
>> +			cpu_relax();
>
> I see a bunch of while loops in this function with no exit condition
> if something goes badly with the hardware.  Also, this driver is going
> to chew up *a lot* of cpu cycles when not using irqs.  Consider
> putting the polled work into a tasklet instead of blindly spinning.
> It will actually make the driver simpler because the irq and non-irq
> cases become very similar.

But bitbang driver already runs as a workqueue, do we still need to 
create a tasklet?

	bitbang->workqueue = create_singlethread_workqueue(
			dev_name(bitbang->master->dev.parent));

>> +	hw->bitbang.master->dev.of_node = pdev->dev.of_node;
>> +	val = of_get_property(pdev->dev.of_node, "baud-width", NULL);
>
> 'baud-width'?
>
> These properties need to be documented.  See below.

This is the width of baud rate divider. I will document it. Do you have 
suggestion on the naming?

>> +#ifdef CONFIG_OF
>> +static struct of_device_id oc_tiny_spi_match[] = {
>> +	{
>> +		.compatible = "opencores,oc_tiny_spi",
>
> If this is a soft core, then there should be a version number of some
> sort on the compatible value.  Also, please use dash '-' instead of
> underscore '_' in compatible values.  Also, for all of these new
> bindings, they need to be documented.  Please add documentation to
> Documentation/powerpc/dts-bindings (yes, I know, this is not
> for powerpc, but that is the established directory.  I'll move it to a
> better location soon).
>
> Finally, one nitpick.  For conciseness, most of_device_id tables are
> written in the form:
>
> static struct of_device_id oc_tiny_spi_match[] = {
> 	{ .compatible = "opencores,oc_tiny_spi", }, },
> 	{},
> }
>

Nice. I am working with Walter on the dts generator for our cores. We 
will add them to the listing.

>> +static int __init tiny_spi_init(void)
>> +{
>> +	return platform_driver_probe(&tiny_spidrv, tiny_spi_probe);
>> +}
>> +module_init(tiny_spi_init);
>
> Please use platform_driver_register, and put your probe function into
> the platform_driver structure.
>

OK. I will do the same for spi_altera.

Best regards,
Thomas
