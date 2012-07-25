Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab2GYPMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227Ab2GYPMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:12:18 -0400
Message-ID: <50100CC4.8010706@redhat.com>
Date: Wed, 25 Jul 2012 11:12:04 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yijing Wang <wangyijing@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/32] PCI: add pcie_flags_reg into struct pci_dev
 to cache PCIe capabilities register
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com> <1343147504-25891-2-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343147504-25891-2-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resending since i did a reply vs reply-all last time...

On 07/24/2012 12:31 PM, Jiang Liu wrote:
> From: Yijing Wang<wangyijing@huawei.com>
>
> From: Yijing Wang<wangyijing@huawei.com>
>
> Since PCI Express Capabilities Register is read only, cache its value
> into struct pci_dev to avoid repeatedly calling pci_read_config_*().
>
> Signed-off-by: Yijing Wang<wangyijing@huawei.com>
> Signed-off-by: Jiang Liu<liuj97@gmail.com>
> ---
>   drivers/pci/probe.c |    1 +
>   include/linux/pci.h |   10 ++++++++++
>   2 files changed, 11 insertions(+)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 6c143b4..6fd58df 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -929,6 +929,7 @@ void set_pcie_port_type(struct pci_dev *pdev)
>   	pdev->is_pcie = 1;
>   	pdev->pcie_cap = pos;
>   	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS,&reg16);
> +	pdev->pcie_flags_reg = reg16;
>   	pdev->pcie_type = (reg16&  PCI_EXP_FLAGS_TYPE)>>  4;
So, given the patch below, shouldn't the above line be ?
     pdev->pcie_type = pci_pcie_type(pdev);

Missed part of patch ?

>   	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP,&reg16);
>   	pdev->pcie_mpss = reg16&  PCI_EXP_DEVCAP_PAYLOAD;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5faa831..95662b2 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -258,6 +258,7 @@ struct pci_dev {
>   	u8		pcie_mpss:3;	/* PCI-E Max Payload Size Supported */
>   	u8		rom_base_reg;	/* which config register controls the ROM */
>   	u8		pin;  		/* which interrupt pin this device uses */
> +	u16		pcie_flags_reg;	/* cached PCI-E Capabilities Register */
>
>   	struct pci_driver *driver;	/* which driver has allocated this device */
>   	u64		dma_mask;	/* Mask of the bits of bus address this
> @@ -1650,6 +1651,15 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
>   	return !!pci_pcie_cap(dev);
>   }
>
> +/**
> + * pci_pcie_type - get the PCIe device/port type
> + * @dev: PCI device
> + */
> +static inline int pci_pcie_type(const struct pci_dev *dev)
> +{
> +	return (dev->pcie_flags_reg&  PCI_EXP_FLAGS_TYPE)>>  4;
> +}
> +
>   void pci_request_acs(void);
>   bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
>   bool pci_acs_path_enabled(struct pci_dev *start,

