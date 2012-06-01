Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502Ab2FAWAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933654Ab2FAWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:00:51 -0400
Message-ID: <4FC93B90.1010907@redhat.com>
Date: Fri, 01 Jun 2012 18:00:48 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Myron Stowe <myron.stowe@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xudong.hao@linux.intel.com,
        yu.zhao@intel.com
Subject: Re: [PATCH 4/4] PCI: Remove redundant capabilities checking in pci_{save,
 restore}_pcie_state
References: <20120601211619.20328.36769.stgit@amt.stowe> <20120601211643.20328.26918.stgit@amt.stowe>
In-Reply-To: <20120601211643.20328.26918.stgit@amt.stowe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 05:16 PM, Myron Stowe wrote:
> Unlike PCI Express v1's Capabilities Structure, v2's requires the entire
> structure to be implemented.  In v2 structures, register fields that are
> not necessarly implemented, are present but hardwired to 0x0.  These may
> include: Link Capabilities, Status, and Control; Slot Capabilities,
> Status, and Control; Root Capabilities, Status, and Control; and all of
> the '2' (Device, Link, and Slot) Capabilities, Status, and Control
> registers.
>
> This patch removes the redundant capability checks corresponding to the
> Link 2's and Slot 2's, Capabilities, Status, and Control registers as they
> will be present if Device Capabilities 2's registers are (which explains
> why the macros for each of the three are identical).
>
> Signed-off-by: Myron Stowe<myron.stowe@redhat.com>
> ---
>
>   drivers/pci/pci.c |   10 ++++------
>   1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 26933ff..f9f8036 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -903,12 +903,11 @@ static int pci_save_pcie_state(struct pci_dev *dev)
>   		pci_read_config_word(dev, pos + PCI_EXP_SLTCTL,&cap[i++]);
>   	if (pcie_cap_has_rtctl(dev->pcie_type, flags))
>   		pci_read_config_word(dev, pos + PCI_EXP_RTCTL,&cap[i++]);
> -	if (pcie_cap_has_devctl2(dev->pcie_type, flags))
> +	if (pcie_cap_has_devctl2(dev->pcie_type, flags)) {
and why not use your new function:
+	pos = pci_pcie_cap2(bridge);
+	if (!pos)
instead of this devctl2-specific check, so it's obvious it's the whole cap-struct (additional regs)?
  
>   		pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2,&cap[i++]);
> -	if (pcie_cap_has_lnkctl2(dev->pcie_type, flags))
>   		pci_read_config_word(dev, pos + PCI_EXP_LNKCTL2,&cap[i++]);
> -	if (pcie_cap_has_sltctl2(dev->pcie_type, flags))
>   		pci_read_config_word(dev, pos + PCI_EXP_SLTCTL2,&cap[i++]);
> +	}
>
>   	return 0;
>   }
> @@ -936,12 +935,11 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>   		pci_write_config_word(dev, pos + PCI_EXP_SLTCTL, cap[i++]);
>   	if (pcie_cap_has_rtctl(dev->pcie_type, flags))
>   		pci_write_config_word(dev, pos + PCI_EXP_RTCTL, cap[i++]);
> -	if (pcie_cap_has_devctl2(dev->pcie_type, flags))
> +	if (pcie_cap_has_devctl2(dev->pcie_type, flags)) {
ditto.

>   		pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, cap[i++]);
> -	if (pcie_cap_has_lnkctl2(dev->pcie_type, flags))
>   		pci_write_config_word(dev, pos + PCI_EXP_LNKCTL2, cap[i++]);
> -	if (pcie_cap_has_sltctl2(dev->pcie_type, flags))
>   		pci_write_config_word(dev, pos + PCI_EXP_SLTCTL2, cap[i++]);
> +	}
>   }
>
>
>

