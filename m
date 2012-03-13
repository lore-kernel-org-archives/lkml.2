Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab2CMDlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:41:03 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33282 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759578Ab2CMDk7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:40:59 -0400
MIME-Version: 1.0
In-Reply-To: <1331362837-10740-35-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org> <1331362837-10740-35-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Mar 2012 21:40:38 -0600
Message-ID: <CAErSpo5nz0QN4y6P0AoWvKMUUQOQpKgGijwUFEmqPc6NewGW_Q@mail.gmail.com>
Subject: Re: [PATCH v2 34/37] x86, PCI: Add arch version pci_root_rescan()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> It will call acpi version pci_root_rescan and legacy pci_root_rescan.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/pci/common.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 2ebdc231..0ec860f 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -10,6 +10,7 @@
>  #include <linux/init.h>
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
> +#include <linux/pci-acpi.h>
>
>  #include <asm/acpi.h>
>  #include <asm/segment.h>
> @@ -661,6 +662,12 @@ struct pci_bus * __devinit pci_scan_bus_with_sysdata(int busno)
>        return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
>  }
>
> +void arch_pci_root_rescan(void)
> +{
> +       acpi_pci_root_rescan();
> +       pcibios_root_rescan();

I don't think we need this either.

We don't need pcibios_root_rescan() because there's no way to add or
remove buses except via the normal ACPI hotplug mechanisms.  (Well,
you did add sysfs ways to do it, but I don't like those either, and
they certainly don't work for any kind of normal hotplug users might
do.)

We don't need acpi_pci_root_rescan(), because for actual host bridge
add/remove, we will get ACPI notify events, and we can use the normal
ways of handling those events.  For debug purposes, we can have a
sysfs interface that kicks things off the same way a notify event
would.

> +}
> +
>  /*
>  * NUMA info for PCI busses
>  *
> --
> 1.7.7
>
