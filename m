Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1EFOGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:06:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1EFOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:06:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
Date: Fri, 6 May 2011 16:05:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Michael =?utf-8?q?B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105061605.31625.arnd@arndb.de>
X-Provags-ID: V02:K0:IxIHwhbNY0Hlg0y2YQzRW4DlZ7C4zzveel3Anm39EEo
 dIO1XHnOZieTVJq2H11fbHVaw3MJMyjwuHXB7m05x5XVoDbxW6
 ujOWm0uLqbYfJ4sxne0HPRAOX2mVpNkhpWH9Q3IX8qgko9DsxY
 bBCzHa2K07ClOdu48yIVlJiV1VykA7Bguq0fR1s1JHcO2AZw4X
 AaRRCYBbljn3luRAF1f8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafał,

I haven't looked in detail, but since I'll be travelling for the next
two weeks, here is a really quick review. Overall, the bus driver
looks really nice, except for a few things that I guess should be
easy to resolve.

On Thursday 05 May 2011, Rafał Miłecki wrote:
> Cc: Greg KH <greg@kroah.com>
> Cc: Michael Büsch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: George Kashperko <george@znau.edu.ua>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andy Botting <andy@andybotting.com>
> Cc: linuxdriverproject <devel@linuxdriverproject.org>
> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

This really needs a changelog. You've probably written all of
it before, just explain above the Cc what bcma is, where it's
used, why you use a bus_type. This will be the place where
people look when they want to find out what it is, so try
to make a good description.

> new file mode 100644
> index 0000000..b52cd2b
> --- /dev/null
> +++ b/drivers/bcma/README
> @@ -0,0 +1,18 @@
> +Broadcom introduced new bus as replacement for older SSB. It is based on AMBA,
> +however from programming point of view there is nothing AMBA specific we use.
> +
> +Standard AMBA drivers are platform specific, have hardcoded addresses and use
> +AMBA standard fields like CID and PID.
> +
> +In case of Broadcom's cards every device consists of:
> +1) Broadcom specific AMBA device. It is put on AMBA bus, but can not be treated
> +   as standard AMBA device. Reading it's CID or PID can cause machine lockup.
> +2) AMBA standard devices called ports or wrappers. They have CIDs (AMBA_CID)
> +   and PIDs (0x103BB369), but we do not use that info for anything. One of that
> +   devices is used for managing Broadcom specific core.
> +
> +Addresses of AMBA devices are not hardcoded in driver and have to be read from
> +EPROM.
> +
> +In this situation we decided to introduce separated bus with devices identified
> +by Broadcom specific fields, read from EPROM.

This would be a good start for the changelog. You don't actually need the
readme in the code directory, it's better to put the information somewhere
in the Documentation/ directory.

> diff --git a/drivers/bcma/TODO b/drivers/bcma/TODO
> new file mode 100644
> index 0000000..45eadc9
> --- /dev/null
> +++ b/drivers/bcma/TODO
> @@ -0,0 +1,3 @@
> +- Interrupts
> +- Defines for PCI core driver
> +- Convert bcma_bus->cores into linked list

The last item doesn't make sense to me. Since you are using the regular
driver model, you can simply iterate over all child devices of any
dev.

> +static void bcma_core_disable(struct bcma_device *core, u32 flags)
> +{
> +	if (bcma_aread32(core, BCMA_RESET_CTL) & BCMA_RESET_CTL_RESET)
> +		return;
> +
> +	bcma_awrite32(core, BCMA_IOCTL, flags);
> +	bcma_aread32(core, BCMA_IOCTL);
> +	udelay(10);
> +
> +	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
> +	udelay(1);
> +}
> +
> +int bcma_core_enable(struct bcma_device *core, u32 flags)
> +{
> +	bcma_core_disable(core, flags);
> +
> +	bcma_awrite32(core, BCMA_IOCTL, (BCMA_IOCTL_CLK | BCMA_IOCTL_FGC | flags));
> +	bcma_aread32(core, BCMA_IOCTL);
> +
> +	bcma_awrite32(core, BCMA_RESET_CTL, 0);
> +	udelay(1);
> +
> +	bcma_awrite32(core, BCMA_IOCTL, (BCMA_IOCTL_CLK | flags));
> +	bcma_aread32(core, BCMA_IOCTL);
> +	udelay(1);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(bcma_core_enable);

I don't know if we discussed this before. Normally, you should not need such
udelay() calls, at least if you have the correct I/O barriers in place.

> +#include "bcma_private.h"
> +#include <linux/bcma/bcma.h>
> +
> +MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
> +MODULE_LICENSE("GPL");
> +
> +static int bcma_bus_match(struct device *dev, struct device_driver *drv);
> +static int bcma_device_probe(struct device *dev);
> +static int bcma_device_remove(struct device *dev);

Try to reorder your functions so you don't need any forward declarations.

> +const char *bcma_device_name(u16 coreid)
> +{
> +	switch (coreid) {
> +	case BCMA_CORE_OOB_ROUTER:
> +		return "OOB Router";
> +	case BCMA_CORE_INVALID:
> +		return "Invalid";
> +	case BCMA_CORE_CHIPCOMMON:
> +		return "ChipCommon";
> +	case BCMA_CORE_ILINE20:
> +		return "ILine 20";

It's better to make that a data structure than a switch() statement,
both from readability and efficiency aspects.

> +
> +/* 1) It is not allowed to put struct device statically in bcma_device
> + * 2) We can not just use pointer to struct device because we use container_of
> + * 3) We do not have pointer to struct bcma_device in struct device
> + * Solution: use such a dummy wrapper
> + */
> +struct __bcma_dev_wrapper {
> +	struct device dev;
> +	struct bcma_device *core;
> +};
> +
> +struct bcma_device {
> +	struct bcma_bus *bus;
> +	struct bcma_device_id id;
> +
> +	struct device *dev;
> +
> +	u8 core_index;
> +
> +	u32 addr;
> +	u32 wrap;
> +
> +	void *drvdata;
> +};

Something went wrong here, maybe you misunderstood the API, or I
misunderstood what you are trying to do. When you define your own bus
type, the private device (struct bcma_device) should definitely contain
a struct device as a member, and you allocate that structure dynamically
when probing the bus. I don't see any reason for that wrapper.

	Arnd
