Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2CLP6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:58:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38332 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2CLP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:58:22 -0400
Message-ID: <4F5E1D11.8050101@gmail.com>
Date: Mon, 12 Mar 2012 23:58:09 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 19/37] PCI: Add pci_stop_and_remove_bus()
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org> <1331362837-10740-20-git-send-email-yinghai@kernel.org>
In-Reply-To: <1331362837-10740-20-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 03:00 PM, Yinghai Lu wrote:
> It supports both pci root bus and pci bus under pci bridge.
> 
> -v2: clear pci_bridge's subordinate.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/remove.c |   32 ++++++++++++++++++++++++++++++++
>  include/linux/pci.h  |    1 +
>  2 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index d4fdf7b..9ffc071 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -170,6 +170,38 @@ void pci_stop_bus_device(struct pci_dev *dev)
>  	pci_stop_dev(dev);
>  }
>  
> +static void pci_stop_host_bridge(struct pci_host_bridge *bridge)
> +{
> +	device_unregister(&bridge->dev);
> +}
> +/*
> + * it will support pci root bus too, in that case we need
> + *  stop and remove host bridge
> + */
> +void pci_stop_and_remove_bus(struct pci_bus *bus)
> +{
> +	struct pci_host_bridge *host_bridge = NULL;
> +	struct pci_dev *pci_bridge = NULL;
> +
> +	pci_stop_bus_devices(bus);
> +
> +	if (pci_is_root_bus(bus)) {
> +		host_bridge = to_pci_host_bridge(bus->bridge);
> +		pci_stop_host_bridge(host_bridge);
> +	} else
> +		pci_bridge = bus->self;
> +
> +	__pci_remove_bus_devices(bus);
> +
> +	pci_remove_bus(bus);
> +
It seems that the bus and host_bridge structures may have already been freed here,
so should not access host_bridge structure any more.
> +	if (host_bridge)
> +		host_bridge->bus = NULL;
> +
> +	if (pci_bridge)
> +		pci_bridge->subordinate = NULL;
> +}
> +
>  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
>  EXPORT_SYMBOL(pci_stop_and_remove_behind_bridge);
>  EXPORT_SYMBOL_GPL(pci_stop_bus_device);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 860091f..8874b90 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -702,6 +702,7 @@ extern void pci_dev_put(struct pci_dev *dev);
>  extern void pci_remove_bus(struct pci_bus *b);
>  extern void __pci_remove_bus_device(struct pci_dev *dev);
>  extern void pci_stop_and_remove_bus_device(struct pci_dev *dev);
> +void pci_stop_and_remove_bus(struct pci_bus *bus);
>  extern void pci_stop_bus_device(struct pci_dev *dev);
>  void pci_setup_cardbus(struct pci_bus *bus);
>  extern void pci_sort_breadthfirst(void);

