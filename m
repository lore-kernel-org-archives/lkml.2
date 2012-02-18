Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2BRRcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 12:32:12 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:17705 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2BRRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 12:32:09 -0500
Date: Sat, 18 Feb 2012 18:31:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v4] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <20120218183158.47dfc0b6@endymion.delvare>
In-Reply-To: <f493506b-2223-4c1d-8572-d8f7f06961b6@zimbra>
References: <c68928fc-816e-4738-9108-ee3dfbf6427b@zimbra>
 <f493506b-2223-4c1d-8572-d8f7f06961b6@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

On Fri, 17 Feb 2012 17:28:23 -0600 (CST), Aaron Sierra wrote:
> This driver currently creates resources for use by a forthcoming ICH
> chipset GPIO driver. It could be expanded to created the resources for
> converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
> drivers to use the mfd model.
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Sorry I have some more comments. You resent the patch series yesterday
faster than I could review v3.

> ---
>  drivers/mfd/Kconfig         |    9 +
>  drivers/mfd/Makefile        |    1 +
>  drivers/mfd/lpc_ich.c       |  525 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/lpc_ich.h |   32 +++
>  4 files changed, 567 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/lpc_ich.c
>  create mode 100644 include/linux/mfd/lpc_ich.h
> 
> (...)
> +static struct mfd_cell lpc_ich_cells[] = {
> +	[LPC_GPIO] = {
> +		.name = "gpio_ich",
> +		.num_resources = ARRAY_SIZE(gpio_ich_res),
> +		.resources = gpio_ich_res,

I think you should set ignore_resource_conflicts here too. Your code is
already checking for ACPI resource conflicts, so there is no point in
having mfd-core check again. This is not only redundant, this also
makes the kernel log harder to read as the warnings are printed
multiple times.

> (...)
> +static void lpc_ich_restore_config_space(struct pci_dev *dev)
> +{
> +	if (lpc_ich_acpi_save >= 0)
> +		pci_write_config_byte(dev, ACPICTRL, lpc_ich_acpi_save);
> +	if (lpc_ich_gpio_save >= 0)
> +		pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save);
> +
> +	lpc_ich_acpi_save = -1;
> +	lpc_ich_gpio_save = -1;
> +}

A minor optimization is possible here, by including the "save = -1"
statements inside their respective conditional.

> +
> +static void lpc_ich_finalize_cell(struct mfd_cell *cell,
> +					const struct pci_device_id *id)

Called from a __devinit function so could be made __devinit too.

> +{
> +	cell->id = id->driver_data;
> +	cell->platform_data = &lpc_chipset_info[id->driver_data];
> +	cell->pdata_size = sizeof(struct lpc_ich_info);
> +}
> +
> +static int __devinit lpc_ich_probe(struct pci_dev *dev,
> +				const struct pci_device_id *id)
> +{
> +	u32 base_addr_cfg;
> +	u32 base_addr;
> +	u8 reg_save;
> +	int ret;
> +	bool cell_added = false;
> +	bool acpi_conflict = false;
> +
> +	/* Setup power management base register */
> +	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
> +	base_addr = base_addr_cfg & 0x0000ff80;
> +	if (!base_addr) {
> +		dev_err(&dev->dev, "I/O space for ACPI uninitialized\n");
> +		goto pm_done;
> +	}
> +
> +	gpio_ich_res[ICH_RES_GPE0].start = base_addr + ACPIBASE_GPE_OFF;
> +	gpio_ich_res[ICH_RES_GPE0].end = base_addr + ACPIBASE_GPE_END;
> +	ret = acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPE0]);
> +	if (ret) {
> +		/* this isn't necessarily fatal for the GPIO */
> +		gpio_ich_res[ICH_RES_GPE0].start = 0;
> +		gpio_ich_res[ICH_RES_GPE0].end = 0;

Is it really sufficient to disable the resource? I see that you handle
this case properly in the gpio-ich driver, however there's also the
platform subsystem which needs to be considered. The above will cause
platform_device_add_resources (called by mfd_add_device) to register an
I/O resource at address 0, size 1. I can see it in /proc/ioports:

0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
    0000-0000 : gpio_ich.32	<-- HERE
  0020-0021 : pic1

This is not clean and could cause a conflict on its own. So I don't
think this is the right approach. See below for a possible solution.

> +		acpi_conflict = true;

Don't you want to jump to pm_done here? There's no point in enabling
the LPC ACPI space if you are never going to access it. Not that it
should really make a difference in practice, I presume that if ACPI is
using the resource, the LPC ACPI space is already enabled...

> +	}
> +
> +	/* Enable LPC ACPI space */
> +	pci_read_config_byte(dev, ACPICTRL, &reg_save);
> +	pci_write_config_byte(dev, ACPICTRL, reg_save | 0x10);
> +	lpc_ich_acpi_save = reg_save;
> +
> +pm_done:
> +	/* Setup GPIO base register */
> +	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
> +	base_addr = base_addr_cfg & 0x0000ff80;
> +	if (!base_addr) {
> +		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
> +		/* GPIO in power-management space may still be available */
> +		goto gpio_reg;
> +	}
> +
> +	gpio_ich_res[ICH_RES_GPIO].start = base_addr;
> +	gpio_ich_res[ICH_RES_GPIO].end = base_addr + GPIOBASE_IO_SIZE - 1;
> +	ret = acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPIO]);
> +	if (ret) {
> +		/* this isn't necessarily fatal for the GPIO */
> +		gpio_ich_res[ICH_RES_GPIO].start = 0;
> +		gpio_ich_res[ICH_RES_GPIO].end = 0;

I don't quite get how this can be non-fatal, given that the gpio-ich
driver's probe function will return -ENODEV in this case. So if this
resource is mandatory, let's make it exactly that. This means that
resource 0 is mandatory and resource 1 is optional. All you have to do
then is:
* Don't register the mfd device at all if GPIO resource is unavailable.
* If ACPI resource is unavailable, set num_resources to 1.

That should work, and this solves the ghost resource problem I
mentioned earlier.

Yet a completely different approach would be to delegate the ACPI
resource conflict checking to the gpio-ich subdriver. I suspect we may
end up doing that anyway, as requesting the whole I/O range when we
only need subsets thereof is likely to cause ACPI resource conflicts on
too many systems for the driver to be useful in practice. This is a
bigger change though and I would understand if you are reluctant to do
it as this point of the review cycle. This can be changed later and I
volunteer to take care of it (I need it for my Asus Z8NA-D6 board.)

> +		acpi_conflict = true;
> +		goto gpio_reg;
> +	}
> +
> +	/* Enable LPC GPIO space */
> +	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
> +	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
> +	lpc_ich_gpio_save = reg_save;
> +
> +gpio_reg:

Shouldn't this label be named gpio_done for consistency? Probably a
moot point given my remark above anyway.

> +	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
> +	ret = mfd_add_devices(&dev->dev, 0, &lpc_ich_cells[LPC_GPIO],
> +				1, NULL, 0);
> +	if (!ret)
> +		cell_added = true;
> +
> +	if (acpi_conflict)
> +		dev_info(&dev->dev, "ACPI resource conflicts found; "
> +				"consider using acpi_enforce_resources=lax?\n");

I'm not sure if it really makes sense to report this. ACPI resource
conflicts are already reported quite loudly by the acpi core. And
passing acpi_enforce_resources=lax blindly isn't quite recommended, so
I'm not sure if we really want to mention it here, it might do more
harm than help.

> +
> +	/*
> +	 * We only care if at least one or none of the cells registered
> +	 * successfully.
> +	 */
> +	if (!cell_added) {
> +		lpc_ich_restore_config_space(dev);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}

-- 
Jean Delvare
