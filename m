Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2HBBaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 21:30:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40655 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2HBBad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 21:30:33 -0400
From: "Kaneshige, Kenji" <kaneshige.kenji@jp.fujitsu.com>
To: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Don Dutile" <ddutile@redhat.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        "Izumi, Taku" <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v3 06/32] PCI/hotplug: use PCIe capabilities access
 functions to simplify implementation
Thread-Topic: [PATCH v3 06/32] PCI/hotplug: use PCIe capabilities access
 functions to simplify implementation
Thread-Index: AQHNb/4s0Qyt45RO+UmhftC/i+bv3JdFvFSA
Date: Thu, 2 Aug 2012 01:30:30 +0000
Message-ID: <4A338DB2991D2A44B9A44B8718AECF650A47B7AB@G01JPEXMBYT03>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <1343836477-7287-7-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343836477-7287-7-git-send-email-jiang.liu@huawei.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v1.7.4
x-originating-ip: [10.124.101.76]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Regards,
Kenji Kaneshige


> -----Original Message-----
> From: Jiang Liu [mailto:liuj97@gmail.com]
> Sent: Thursday, August 02, 2012 12:54 AM
> To: Bjorn Helgaas; Don Dutile
> Cc: Jiang Liu; Yinghai Lu; Izumi, Taku/泉 拓; Rafael J . Wysocki; Kaneshige,
> Kenji/金重 憲治; Yijing Wang; linux-kernel@vger.kernel.org;
> linux-pci@vger.kernel.org; Jiang Liu
> Subject: [PATCH v3 06/32] PCI/hotplug: use PCIe capabilities access
> functions to simplify implementation
> 
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Use PCIe capabilities access functions to simplify cpihp_slot.c.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/hotplug/pcihp_slot.c |   20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pcihp_slot.c
> b/drivers/pci/hotplug/pcihp_slot.c
> index 8c05a18..649dcc8 100644
> --- a/drivers/pci/hotplug/pcihp_slot.c
> +++ b/drivers/pci/hotplug/pcihp_slot.c
> @@ -96,17 +96,11 @@ static void program_hpp_type1(struct pci_dev *dev,
> struct hpp_type1 *hpp)
>  static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
>  {
>  	int pos;
> -	u16 reg16;
>  	u32 reg32;
> 
>  	if (!hpp)
>  		return;
> 
> -	/* Find PCI Express capability */
> -	pos = pci_pcie_cap(dev);
> -	if (!pos)
> -		return;
> -
>  	if (hpp->revision > 1) {
>  		dev_warn(&dev->dev, "PCIe settings rev %d not
> supported\n",
>  			 hpp->revision);
> @@ -114,17 +108,13 @@ static void program_hpp_type2(struct pci_dev *dev,
> struct hpp_type2 *hpp)
>  	}
> 
>  	/* Initialize Device Control Register */
> -	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &reg16);
> -	reg16 = (reg16 & hpp->pci_exp_devctl_and) |
> hpp->pci_exp_devctl_or;
> -	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, reg16);
> +	pci_pcie_capability_change_word(dev, PCI_EXP_DEVCTL,
> +			hpp->pci_exp_devctl_or,
> ~hpp->pci_exp_devctl_and);
> 
>  	/* Initialize Link Control Register */
> -	if (dev->subordinate) {
> -		pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &reg16);
> -		reg16 = (reg16 & hpp->pci_exp_lnkctl_and)
> -			| hpp->pci_exp_lnkctl_or;
> -		pci_write_config_word(dev, pos + PCI_EXP_LNKCTL, reg16);
> -	}
> +	if (dev->subordinate)
> +		pci_pcie_capability_change_word(dev, PCI_EXP_LNKCTL,
> +			hpp->pci_exp_lnkctl_or,
> ~hpp->pci_exp_lnkctl_and);
> 
>  	/* Find Advanced Error Reporting Enhanced Capability */
>  	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
> --
> 1.7.9.5

