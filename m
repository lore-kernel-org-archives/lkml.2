Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1F3RFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:05:01 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:24981 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1F3RE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:04:59 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzHuK2TMg==
X-RZG-CLASS-ID: mo00
Message-ID: <4E0CACB7.7040709@hartkopp.net>
Date: Thu, 30 Jun 2011 19:04:55 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
In-Reply-To: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.06.2011 10:09, Ram Pai wrote:
> Multiple attempts to dynamically reallocate pci resources have unfortunately
> lead to regressions. Though we continue to fix the regressions and fine tune the
> dynamic-reallocation behavior, we have not reached a acceptable state yet.
> 
> This patch provides a interim solution. It disables dynamic-reallocation; by
> default, with the ability to enable it through pci=realloc kernel command line
> parameter.

What is the advantage of creating an 'interim' kernel parameter instead of
reverting the problematic commit and queue up a proper solution for 3.1 ?

A kernel parameter needs to be observed, documented and set appropriately.

I would prefer to have an automatic solution - if not in 3.0 then in 3.1 ...

Btw. why don't you post your fix "[PATCH 0/4 v2] PCI: fix cardbus and sriov
regressions" also on LKML that works great on my problematic laptop?

Regards,
Oliver

> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  Documentation/kernel-parameters.txt |    2 ++
>  arch/x86/pci/common.c               |    4 ++++
>  drivers/pci/setup-bus.c             |    7 +++++++
>  include/linux/pci.h                 |    2 ++
>  4 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index fd248a3..aa47be7 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2015,6 +2015,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  				the default.
>  				off: Turn ECRC off
>  				on: Turn ECRC on.
> +		realloc		reallocate PCI resources if allocations done by BIOS
> +				are erroneous.
>  
>  	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
>  			Management.
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 5fe7502..9645290 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -31,6 +31,7 @@ int noioapicreroute = 0;
>  int noioapicreroute = 1;
>  #endif
>  int pcibios_last_bus = -1;
> +int pci_realloc = 0;
>  unsigned long pirq_table_addr;
>  struct pci_bus *pci_root_bus;
>  struct pci_raw_ops *raw_pci_ops;
> @@ -602,6 +603,9 @@ char * __devinit  pcibios_setup(char *str)
>  		if (noioapicreroute != -1)
>  			noioapicreroute = 1;
>  		return NULL;
> +	} else if (!strcmp(str, "realloc")) {
> +		pci_realloc = 1;
> +		return NULL;
>  	}
>  	return str;
>  }
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 40e94d5..a65c2ad 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1135,6 +1135,13 @@ again:
>  	/* any device complain? */
>  	if (!head.next)
>  		goto enable_and_dump;
> +
> +	/* don't realloc if asked to do so */
> +	if (!pci_realloc) {
> +		free_list(resource_list_x, &head);
> +		goto enable_and_dump;
> +	}
> +
>  	failed_type = 0;
>  	for (list = head.next; list;) {
>  		failed_type |= list->flags;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index f39d894..08b9af0 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1427,6 +1427,8 @@ extern u8 pci_cache_line_size;
>  extern unsigned long pci_hotplug_io_size;
>  extern unsigned long pci_hotplug_mem_size;
>  
> +extern int pci_realloc;
> +
>  int pcibios_add_platform_entries(struct pci_dev *dev);
>  void pcibios_disable_device(struct pci_dev *dev);
>  int pcibios_set_pcie_reset_state(struct pci_dev *dev,

