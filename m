Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1GAGBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 02:01:45 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:25357 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1GAGBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 02:01:43 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzHuK6Qd0Q=
X-RZG-CLASS-ID: mo00
Message-ID: <4E0D62BD.5070405@hartkopp.net>
Date: Fri, 01 Jul 2011 08:01:33 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, bhutchings@solarflare.com, bhelgaas@google.com,
        linux@dominikbrodowski.net
Subject: Re: [PATCH 3/5 v2] PCI: make SRIOV resources optional
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com> <1309477662-18680-4-git-send-email-linuxram@us.ibm.com>
In-Reply-To: <1309477662-18680-4-git-send-email-linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.07.2011 01:47, Ram Pai wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> From: Yinghai Lu <yinghai@kernel.org>
> 
> Allocate resources to SRIOV BARs only after all other required
> resource-requests are satisfied. Dont retry if resource allocation for SRIOV
> BARs fail.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

I applied the whole patchset and it looks very similar to the dmsg output
before the problematic commit that caused the regression.

Tnx!

Oliver


> ---
>  drivers/pci/setup-bus.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 9f2f15f..a0555cb 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -669,6 +669,16 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  			if (r->parent || (r->flags & mask) != type)
>  				continue;
>  			r_size = resource_size(r);
> +#ifdef CONFIG_PCI_IOV
> +			/* put SRIOV requested res to the optional list */
> +			if (add_head && i >= PCI_IOV_RESOURCES &&
> +					i <= PCI_IOV_RESOURCE_END) {
> +				r->end = r->start - 1;
> +				add_to_list(add_head, dev, r, r_size, 1);
> +				children_add_size += r_size;
> +				continue;
> +			}
> +#endif
>  			/* For bridges size != alignment */
>  			align = pci_resource_alignment(dev, r);
>  			order = __ffs(align) - 20;

