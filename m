Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab2CGEb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:31:28 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58041 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2CGEb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <1331018040-30725-20-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-20-git-send-email-yinghai@kernel.org>
Date: Tue, 6 Mar 2012 21:31:24 -0700
Message-ID: <CABhMZUX_pv2Wx4u+kqwcyCOpUnZ3yi68cVpV9TAzsqx2DF5DRQ@mail.gmail.com>
Subject: Re: [PATCH 19/23] PCI: add /sys/bus/pci/rescan_root
From: Bjorn Helgaas <bjorn.helgaas@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> It will be used to rediscover removed pci root buses.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |    9 +++++++++
>  drivers/pci/pci-sysfs.c                 |   21 +++++++++++++++++++++
>  2 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci
> b/Documentation/ABI/testing/sysfs-bus-pci
> index 22392de..eb826bd 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -66,6 +66,15 @@ Description:
>                re-discover previously removed devices.
>                Depends on CONFIG_HOTPLUG.
>
> +What:          /sys/bus/pci/rescan_root
> +Date:          March 2012
> +Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
> +Description:
> +               Writing a non-zero value to this attribute will
> +               cause a rescan of all PCI root buses in the system, and
> +               re-discover previously removed PCI root buses.

This seems sort of backwards to me.  Architecture-specific code
enumerated the host bridges/root buses in the first place, not the PCI
core.  Now we're asking the PCI core (/sys/bus/pci) to re-enumerate
them.

But maybe it's still the right answer, I dunno.

> +               Depends on CONFIG_HOTPLUG.
> +
>  What:          /sys/bus/pci/devices/.../msi_irqs/
>  Date:          September, 2011
>  Contact:       Neil Horman <nhorman@tuxdriver.com>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index f855b4b..d6221e5 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -302,8 +302,29 @@ static ssize_t bus_rescan_store(struct bus_type *bus,
> const char *buf,
>        return count;
>  }
>
> +void __weak acpi_pci_root_rescan(void) { }
> +void __weak pcibios_root_rescan(void) { }
> +
> +static ssize_t bus_rescan_root_store(struct bus_type *bus, const char
> *buf,
> +                               size_t count)
> +{
> +       unsigned long val;
> +
> +       if (strict_strtoul(buf, 0, &val) < 0)
> +               return -EINVAL;
> +
> +       if (val) {
> +               mutex_lock(&pci_remove_rescan_mutex);
> +               acpi_pci_root_rescan();

This architecture-dependent function name should not be here.  How
will we make this work for powerpc, sparc, etc.?

> +               pcibios_root_rescan();
> +               mutex_unlock(&pci_remove_rescan_mutex);
> +       }
> +       return count;
> +}
> +
>  struct bus_attribute pci_bus_attrs[] = {
>        __ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, bus_rescan_store),
> +       __ATTR(rescan_root, (S_IWUSR|S_IWGRP), NULL,
> bus_rescan_root_store),
>        __ATTR_NULL
>  };
>
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
