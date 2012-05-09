Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836Ab2EITch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:32:37 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:40604 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2EITcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:32:36 -0400
Message-ID: <4FAAC652.4060502@tilera.com>
Date: Wed, 9 May 2012 15:32:34 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 19/21] tile/PCI: Use pci_scan_root_bus instead pci_scan_bus
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org> <1336422606-4244-20-git-send-email-yinghai@kernel.org>
In-Reply-To: <1336422606-4244-20-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2012 4:30 PM, Yinghai Lu wrote:
> It will update busn_res accordingly, so we get that for last_busno.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/kernel/pci.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
> index 7aa2743..4a951b87 100644
> --- a/arch/tile/kernel/pci.c
> +++ b/arch/tile/kernel/pci.c
> @@ -310,6 +310,7 @@ int __devinit pcibios_init(void)
>  		if (pci_scan_flags[i] == 0 && controllers[i].ops != NULL) {
>  			struct pci_controller *controller = &controllers[i];
>  			struct pci_bus *bus;
> +			LIST_HEAD(resources);
>  
>  			if (tile_init_irqs(i, controller)) {
>  				pr_err("PCI: Could not initialize IRQs\n");
> @@ -327,7 +328,9 @@ int __devinit pcibios_init(void)
>  			 * This is inlined in linux/pci.h and calls into
>  			 * pci_scan_bus_parented() in probe.c.
>  			 */
> -			bus = pci_scan_bus(0, controller->ops, controller);
> +			pci_add_resource(&resources, &ioport_resource);
> +			pci_add_resource(&resources, &iomem_resource);
> +			bus = pci_scan_root_bus(NULL, 0, controller->ops, controller, &resources);
>  			controller->root_bus = bus;
>  			controller->last_busno = bus->busn_res.end;
>  		}

We don't want ioport_resource on tilepro, since we don't support accessing
I/O port space.

With that one line removed:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Or, I can queue this change to take through the tile tree when the merge
window opens.  Which would you prefer?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

