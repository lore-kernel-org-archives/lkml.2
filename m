Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2BQVWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:22:10 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:29112 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2BQVWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:22:09 -0500
Date: Fri, 17 Feb 2012 22:21:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120217222155.435195d2@endymion.delvare>
In-Reply-To: <cd679d99-46c9-4f8a-8f03-474637e013a8@zimbra>
References: <0080ec60-4f91-4642-bf3b-42ab667b3b13@zimbra>
	<cd679d99-46c9-4f8a-8f03-474637e013a8@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

On Fri, 17 Feb 2012 12:18:18 -0600 (CST), Aaron Sierra wrote:
> This driver currently creates resources for use by a forthcoming ICH
> chipset GPIO driver. It could be expanded to created the resources for
> converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
> drivers to use the mfd model.
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Tested-by: Jean Delvare <khali@linux-fr.org>

> ---
>  drivers/mfd/Kconfig         |    9 +
>  drivers/mfd/Makefile        |    1 +
>  drivers/mfd/lpc_ich.c       |  513 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/lpc_ich.h |   32 +++
>  4 files changed, 555 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/lpc_ich.c
>  create mode 100644 include/linux/mfd/lpc_ich.h

Looks alright this time, except:

> +static void __devexit lpc_ich_remove(struct pci_dev *dev)
> +{
> +	mfd_remove_devices(&dev->dev);
> +
> +	if (lpc_ich_gpio_save > 0)
> +		pci_write_config_byte(dev, GPIOCTRL, (u8)lpc_ich_gpio_save);
> +	if (lpc_ich_acpi_save > 0)
> +		pci_write_config_byte(dev, ACPICTRL, (u8)lpc_ich_acpi_save);

I think you really mean >= 0 above. And the casts aren't needed. You
should also reset lpc_ich_gpio_save and lpc_ich_acpi_save to -1 after
restoring the values, it matters if the device is removed and re-added
through sysfs.

This cleanup is missing from the error path in lpc_ich_probe, BTW. You
may want to move it to a separate function so that you can call it from
both lpc_ich_probe and lpc_ich_remove.

-- 
Jean Delvare
