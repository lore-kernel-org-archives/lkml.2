Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab2GXVMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:12:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab2GXVMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:12:45 -0400
Message-ID: <500F0FBF.9080903@redhat.com>
Date: Tue, 24 Jul 2012 17:12:31 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/32] PCI: add PCIe capabilities access functions
 to hide differences among PCIe specs
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com> <1343147504-25891-5-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343147504-25891-5-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 12:31 PM, Jiang Liu wrote:
> From: Jiang Liu<jiang.liu@huawei.com>
>
> Introduce five configuration access functions for PCIe capabilities registers
> to hide differences among PCIe Base Spec versions.
>
> Function pci_pcie_capability_read_word/dword() stores the PCIe Capabilities
> register value by the passed parameter val. If related PCIe Capabilities
> register is not implemented on the PCIe device, the passed parameter val
> will be set 0.
>
> Function pci_pcie_capability_write_word/dowrd() writes the value to PCIe
> Capability register.
>
> Function pci_pcie_capability_reg_implemeneted() checks whether a Capabilities
> register is implemented by the PCIe device.
>
> Signed-off-by: Jiang Liu<liuj97@gmail.com>
> Signed-off-by: Yijing Wang<wangyijing@huawei.com>
> ---
>   drivers/pci/access.c     |  157 ++++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/pci.h      |    6 ++
>   include/linux/pci_regs.h |    2 +
>   3 files changed, 165 insertions(+)
>
> diff --git a/drivers/pci/access.c b/drivers/pci/access.c
> index ba91a7e..59409e8 100644
> --- a/drivers/pci/access.c
> +++ b/drivers/pci/access.c
> @@ -469,3 +469,160 @@ void pci_cfg_access_unlock(struct pci_dev *dev)
>   	raw_spin_unlock_irqrestore(&pci_lock, flags);
>   }
>   EXPORT_SYMBOL_GPL(pci_cfg_access_unlock);
> +
> +static inline int pci_pcie_cap_version(const struct pci_dev *dev)
> +{
> +	return dev->pcie_flags_reg&  PCI_EXP_FLAGS_VERS;
> +}
> +
> +static inline bool pci_pcie_cap_has_devctl(const struct pci_dev *dev)
> +{
> +	return true;
> +}
> +
> +static inline bool pci_pcie_cap_has_lnkctl(const struct pci_dev *dev)
> +{
> +	int type = pci_pcie_type(dev);
> +
> +	return pci_pcie_cap_version(dev)>  1 ||
> +	       type == PCI_EXP_TYPE_ROOT_PORT ||
> +	       type == PCI_EXP_TYPE_ENDPOINT ||
> +	       type == PCI_EXP_TYPE_LEG_END;
> +}
> +
> +static inline bool pci_pcie_cap_has_sltctl(const struct pci_dev *dev)
> +{
> +	int type = pci_pcie_type(dev);
> +
> +	return pci_pcie_cap_version(dev)>  1 ||
> +	       type == PCI_EXP_TYPE_ROOT_PORT ||
> +	       (type == PCI_EXP_TYPE_DOWNSTREAM&&
> +		dev->pcie_flags_reg&  PCI_EXP_FLAGS_SLOT);
> +}
> +
> +static inline bool pci_pcie_cap_has_rtctl(const struct pci_dev *dev)
> +{
> +	int type = pci_pcie_type(dev);
> +
> +	return pci_pcie_cap_version(dev)>  1 ||
> +	       type == PCI_EXP_TYPE_ROOT_PORT ||
> +	       type == PCI_EXP_TYPE_RC_EC;
> +}
> +
> +bool pci_pcie_capability_reg_implemented(struct pci_dev *dev, int pos)
> +{
> +	if (!pci_is_pcie(dev))
> +		return false;
> +
> +	switch (pos) {
> +	case PCI_EXP_FLAGS_TYPE:
> +		return true;
> +	case PCI_EXP_DEVCAP:
> +	case PCI_EXP_DEVCTL:
> +	case PCI_EXP_DEVSTA:
> +		return pci_pcie_cap_has_devctl(dev);
> +	case PCI_EXP_LNKCAP:
> +	case PCI_EXP_LNKCTL:
> +	case PCI_EXP_LNKSTA:
> +		return pci_pcie_cap_has_lnkctl(dev);
> +	case PCI_EXP_SLTCAP:
> +	case PCI_EXP_SLTCTL:
> +	case PCI_EXP_SLTSTA:
> +		return pci_pcie_cap_has_sltctl(dev);
> +	case PCI_EXP_RTCTL:
> +	case PCI_EXP_RTCAP:
> +	case PCI_EXP_RTSTA:
> +		return pci_pcie_cap_has_rtctl(dev);
> +	case PCI_EXP_DEVCAP2:
> +	case PCI_EXP_DEVCTL2:
> +	case PCI_EXP_LNKCAP2:
> +	case PCI_EXP_LNKCTL2:
> +	case PCI_EXP_LNKSTA2:
> +		return pci_pcie_cap_version(dev)>  1;
> +	default:
> +		return false;
> +	}
> +}
> +EXPORT_SYMBOL(pci_pcie_capability_reg_implemented);
> +
> +/*
> + * Quotation from PCIe Base Spec 3.0:
> + * For Functions that do not implement the Slot Capabilities,
> + * Slot Status, and Slot Control registers, these spaces must
> + * be hardwired to 0b, with the exception of the Presence Detect
> + * State bit in the Slot Status register of Downstream Ports,
> + * which must be hardwired to 1b.
> + */
> +int pci_pcie_capability_read_word(struct pci_dev *dev, int pos, u16 *val)
> +{
> +	int ret = 0;
> +
> +	*val = 0;
> +	if (pos&  1)
> +		return -EINVAL;
> +
> +	if (pci_pcie_capability_reg_implemented(dev, pos)) {
> +		ret = pci_read_config_word(dev, pci_pcie_cap(dev) + pos, val);
> +		/*
> +		 * Reset *val to 0 if pci_read_config_word() fails, it may
> +		 * have been written as 0xFFFF if hardware error happens
> +		 * during pci_read_config_word().
> +		 */
> +		if (ret)
> +			*val = 0;
> +	} else if (pos == PCI_EXP_SLTSTA&&
> +		 pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) {
> +		*val = PCI_EXP_SLTSTA_PDS;
> +	}
Don't you want the above if check done 1st, and not the
pci_pcie_capability_reg_implemented(dev, pos) check ?
Isn't PCI_EXP_SLTCTL an implemented register, looking at this snippet?:
> +	switch (pos) {
         <snip>
> +	case PCI_EXP_SLTCAP:
> +	case PCI_EXP_SLTCTL:
> +	case PCI_EXP_SLTSTA:
> +		return pci_pcie_cap_has_sltctl(dev);
   and the above function is:

> +static inline bool pci_pcie_cap_has_sltctl(const struct pci_dev *dev)
> +{
> +	int type = pci_pcie_type(dev);
> +
> +	return pci_pcie_cap_version(dev)>  1 ||
> +	       type == PCI_EXP_TYPE_ROOT_PORT ||
> +	       (type == PCI_EXP_TYPE_DOWNSTREAM&&
> +		dev->pcie_flags_reg&  PCI_EXP_FLAGS_SLOT);
> +}

or is PCI_EXP_FLAGS_SLOT not set when it should be, then the first condition
fails, and this function forces the val to 1b ?
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pci_pcie_capability_read_word);
> +
> +int pci_pcie_capability_read_dword(struct pci_dev *dev, int pos, u32 *val)
> +{
> +	int ret = 0;
> +
> +	*val = 0;
> +	if (pos&  3)
> +		return -EINVAL;
> +
> +	if (pci_pcie_capability_reg_implemented(dev, pos)) {
> +		ret = pci_read_config_dword(dev, pci_pcie_cap(dev) + pos, val);
> +		/*
> +		 * Reset *val to 0 if pci_read_config_dword() fails, it may
> +		 * have been written as 0xFFFFFFFF if hardware error happens
> +		 * during pci_read_config_dword().
> +		 */
> +		if (ret)
> +			*val = 0;
> +	} else if (pos == PCI_EXP_SLTCTL&&
> +		 pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) {
> +		*val = PCI_EXP_SLTSTA_PDS;
> +	}
ditto above...

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pci_pcie_capability_read_dword);
> +
> +int pci_pcie_capability_write_word(struct pci_dev *dev, int pos, u16 val)
> +{
> +	if (pos&  1)
> +		return -EINVAL;
> +	else if (!pci_pcie_capability_reg_implemented(dev, pos))
> +		return 0;
> +
> +	return pci_write_config_word(dev, pci_pcie_cap(dev) + pos, val);
> +}
> +EXPORT_SYMBOL(pci_pcie_capability_write_word);
> +
> +int pci_pcie_capability_write_dword(struct pci_dev *dev, int pos, u32 val)
> +{
> +	if (pos&  3)
> +		return -EINVAL;
> +	else if (!pci_pcie_capability_reg_implemented(dev, pos))
> +		return 0;
> +
> +	return pci_write_config_dword(dev, pci_pcie_cap(dev) + pos, val);
> +}
> +EXPORT_SYMBOL(pci_pcie_capability_write_dword);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9807da5..a9b7605 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -816,6 +816,12 @@ static inline int pci_write_config_dword(const struct pci_dev *dev, int where,
>   	return pci_bus_write_config_dword(dev->bus, dev->devfn, where, val);
>   }
>
> +int pci_pcie_capability_read_word(struct pci_dev *dev, int where, u16 *val);
> +int pci_pcie_capability_read_dword(struct pci_dev *dev, int where, u32 *val);
> +int pci_pcie_capability_write_word(struct pci_dev *dev, int where, u16 val);
> +int pci_pcie_capability_write_dword(struct pci_dev *dev, int where, u32 val);
> +bool pci_pcie_capability_reg_implemented(struct pci_dev *dev, int where);
> +
>   /* user-space driven config access */
>   int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
>   int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index 53274bf..5300fdf 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -543,7 +543,9 @@
>   #define  PCI_EXP_OBFF_MSGB_EN	0x4000	/* OBFF enable with Message type B */
>   #define  PCI_EXP_OBFF_WAKE_EN	0x6000	/* OBFF using WAKE# signaling */
>   #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	44	/* v2 endpoints end here */
> +#define PCI_EXP_LNKCAP2		44	/* Link Capabilities 2 */
>   #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
> +#define PCI_EXP_LNKSTA2		50	/* Link Status 2 */
>   #define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
>
>   /* Extended Capabilities (PCI-X 2.0 and Express) */

