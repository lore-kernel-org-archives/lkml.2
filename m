Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2B2ACI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:02:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63837 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2B2ACD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:02:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.14.230 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1330466863-28469-13-git-send-email-yinghai@kernel.org>
References: <1330466863-28469-1-git-send-email-yinghai@kernel.org> <1330466863-28469-13-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 Feb 2012 17:01:42 -0700
Message-ID: <CAErSpo66PD3+E3ZFqp73XHabL+8GavpX97pUkd28T6KWTBH-aA@mail.gmail.com>
Subject: Re: [PATCH 12/24] PCI, ia64: Register busn_res for root buses
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 3:07 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: linux-ia64@vger.kernel.org
> ---
>  arch/ia64/include/asm/pci.h |    1 +
>  arch/ia64/pci/pci.c         |    5 +++++
>  2 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
> index b22e5f5..6e54220 100644
> --- a/arch/ia64/include/asm/pci.h
> +++ b/arch/ia64/include/asm/pci.h
> @@ -94,6 +94,7 @@ struct pci_controller {
>
>        unsigned int windows;
>        struct pci_window *window;
> +       struct resource busn;

Why do you add a new struct resource here?  Can't you just use the one
passed in from acpi_pci_root_add()?

>
>        void *platform_data;
>  };
> diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
> index d1ce320..b250f0f 100644
> --- a/arch/ia64/pci/pci.c
> +++ b/arch/ia64/pci/pci.c
> @@ -332,6 +332,7 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
>        struct acpi_device *device = root->device;
>        int domain = root->segment;
>        int bus = root->secondary.start;
> +       int busmax = root->secondary.end;
>        struct pci_controller *controller;
>        unsigned int windows = 0;
>        struct pci_root_info info;
> @@ -372,6 +373,10 @@ pci_acpi_scan_root(struct acpi_pci_root *root)
>                acpi_walk_resources(device->handle, METHOD_NAME__CRS,
>                        add_window, &info);
>        }
> +       controller->busn.start = bus;
> +       controller->busn.end = busmax;
> +       conttoller->busn.flags = IORESOURCE_BUS;

Typo here - "conttoller" should be "controller".

> +       pci_add_resource(&info.resources, &controller->busn);
>        /*
>         * See arch/x86/pci/acpi.c.
>         * The desired pci bus might already be scanned in a quirk. We
> --
> 1.7.7
>
