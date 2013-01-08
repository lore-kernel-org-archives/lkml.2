Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3AHRFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:05:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328Ab3AHRFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:05:43 -0500
Message-ID: <50EC51E3.6070306@redhat.com>
Date: Tue, 08 Jan 2013 12:05:39 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: tadeusz.struk@intel.com
CC: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Make pci_find_upstream_pcie_bridge() handle non
 PCIE VFs well
References: <50ec2e19.EUrQfXEnsRJiPCTv%tadeusz.struk@intel.com>
In-Reply-To: <50ec2e19.EUrQfXEnsRJiPCTv%tadeusz.struk@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 09:32 AM, tadeusz.struk@intel.com wrote:
> pci_find_upstream_pcie_bridge() doesn't handle well non PCIE VFs
> that are part of a PCIE PF device.
>
> Signed-off-by: Tadeusz Struk<tadeusz.struk@intel.com>
> ---
>   drivers/pci/search.c |    6 ++++++
>   1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index bf969ba..8ecdab2 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -23,6 +23,8 @@ EXPORT_SYMBOL_GPL(pci_bus_sem);
>    * if the device isn't connected to a PCIe bridge (that is its parent is a
>    * legacy PCI bridge and the bridge is directly connected to bus 0), return its
>    * parent
> + * if the device is a VF that doesn't have PCIe cap,
> + * but the PF is a PCIE, return NULL
>    */
>   struct pci_dev *
>   pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
> @@ -31,6 +33,10 @@ pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
>
>   	if (pci_is_pcie(pdev))
>   		return NULL;
> +
> +	if (pdev->is_virtfn&&  pci_is_pcie(pdev->physfn))
> +		return NULL;
> +
>   	while (1) {
>   		if (pci_is_root_bus(pdev->bus))
>   			break;

The verbage/description is confusing, and
the comment doesn't match the code:
(a) no such thing as a non-PCIe VF -- all VFs
     are PCIe-based.
(b) code says to return null if VF doesn't have PCIe cap,
     but the code checks if pdev is VF and if PF is PCIe,
     which it must be! ...

nack until a better &/or matching explanation of what
the real problem is, and what the solution is trying to do.

- Don

