Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0KCBSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:18:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:10921 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0KCBSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,286,1286175600"; 
   d="scan'208";a="569805722"
Subject: Re: [PATCH] Add Intel GMA500(Poulsbo) Stub Driver
From: Zhang Rui <rui.zhang@intel.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "gregkh@suse.de" <gregkh@suse.de>, "trenn@suse.de" <trenn@suse.de>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "Dennis.Jansen@web.de" <Dennis.Jansen@web.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "eric@anholt.net" <eric@anholt.net>,
        "alexdeucher@gmail.com" <alexdeucher@gmail.com>,
        "bskeggs@redhat.com" <bskeggs@redhat.com>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "Lee, Chun-Yi" <jlee@novell.com>
In-Reply-To: <1287553879-25897-1-git-send-email-jlee@novell.com>
References: <1287553879-25897-1-git-send-email-jlee@novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 09:19:02 +0800
Message-ID: <1288747142.2234.238.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lee,

Sorry I missed this thread.

On Wed, 2010-10-20 at 13:51 +0800, Lee, Chun-Yi wrote:
> Currently, there have no GMA500(Poulsbo) native video driver to support
> intel opregion. So, use this stub driver to enable the acpi backlight
> control sysfs entry files by requrest acpi_video_register.
> 
If you want the acpi backlight control, why not set CONFIG_ACPI_VIDEO
driver directly?
The reason why i915 driver selects ACPI_VIDEO is that it needs some
cooperation between these two drivers during initialization, or else the
system may hang.

thanks,
rui

> Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
> ---
>  drivers/gpu/Makefile       |    2 +-
>  drivers/gpu/stub/Kconfig   |   13 +++++++++
>  drivers/gpu/stub/Makefile  |    1 +
>  drivers/gpu/stub/poulsbo.c |   63 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/video/Kconfig      |    2 +
>  5 files changed, 80 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/gpu/stub/Kconfig
>  create mode 100644 drivers/gpu/stub/Makefile
>  create mode 100644 drivers/gpu/stub/poulsbo.c
> 
> diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
> index 30879df..cc92778 100644
> --- a/drivers/gpu/Makefile
> +++ b/drivers/gpu/Makefile
> @@ -1 +1 @@
> -obj-y			+= drm/ vga/
> +obj-y			+= drm/ vga/ stub/
> diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
> new file mode 100644
> index 0000000..8f5a540
> --- /dev/null
> +++ b/drivers/gpu/stub/Kconfig
> @@ -0,0 +1,13 @@
> +config STUB_POULSBO
> +	tristate "Intel GMA500 Stub Driver"
> +	depends on PCI
> +        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
> +        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
> +        select ACPI_VIDEO if ACPI
> +	help
> +	  Choose this option if you have a system that has Intel GMA500
> +	  (Poulsbo) integrated graphics. If M is selected, the module will
> +	  be called Poulsbo. This driver is a stub driver for Poulsbo that
> +	  will call poulsbo.ko to enable the acpi backlight control sysfs
> +	  entry file because there have no poulsbo native driver can support
> +	  intel opregion.
> diff --git a/drivers/gpu/stub/Makefile b/drivers/gpu/stub/Makefile
> new file mode 100644
> index 0000000..cd940cc
> --- /dev/null
> +++ b/drivers/gpu/stub/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_STUB_POULSBO) += poulsbo.o
> diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
> new file mode 100644
> index 0000000..d8aa636
> --- /dev/null
> +++ b/drivers/gpu/stub/poulsbo.c
> @@ -0,0 +1,63 @@
> +/*
> + * Intel Poulsbo Stub driver
> + *
> + * Copyright (C) 2010 Novell <jlee@novell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <acpi/video.h>
> +
> +#define DRIVER_NAME "poulsbo"
> +
> +enum {
> +	CHIP_PSB_8108 = 0,
> +	CHIP_PSB_8109 = 1,
> +};
> +
> +static struct pci_device_id pciidlist[] = {
> +	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
> +	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
> +	{0, 0, 0}
> +};
> +
> +static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	return acpi_video_register();
> +}
> +
> +static void poulsbo_remove(struct pci_dev *pdev)
> +{
> +	acpi_video_unregister();
> +}
> +
> +static struct pci_driver poulsbo_driver = {
> +	.name = DRIVER_NAME,
> +	.id_table = pciidlist,
> +	.probe = poulsbo_probe,
> +	.remove = poulsbo_remove,
> +};
> +
> +static int __init poulsbo_init(void)
> +{
> +	return pci_register_driver(&poulsbo_driver);
> +}
> +
> +static void __exit poulsbo_exit(void)
> +{
> +	pci_unregister_driver(&poulsbo_driver);
> +}
> +
> +module_init(poulsbo_init);
> +module_exit(poulsbo_exit);
> +
> +MODULE_AUTHOR("Lee, Chun-Yi <jlee@novell.com>");
> +MODULE_DESCRIPTION("Poulsbo Stub Driver");
> +MODULE_LICENSE("GPL");
> +
> +MODULE_DEVICE_TABLE(pci, pciidlist);
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 8b31fdf..8807ae5 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -17,6 +17,8 @@ source "drivers/gpu/vga/Kconfig"
>  
>  source "drivers/gpu/drm/Kconfig"
>  
> +source "drivers/gpu/stub/Kconfig"
> +
>  config VGASTATE
>         tristate
>         default n


