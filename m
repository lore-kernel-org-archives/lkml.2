Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2GYFvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 01:51:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56101 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2GYFvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 01:51:51 -0400
From: "Kaneshige, Kenji" <kaneshige.kenji@jp.fujitsu.com>
To: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Don Dutile" <ddutile@redhat.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        "Izumi, Taku" <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [RFC PATCH v2 07/32] PCI/portdrv: use PCIe capabilities access
 functions to simplify implementation
Thread-Topic: [RFC PATCH v2 07/32] PCI/portdrv: use PCIe capabilities access
 functions to simplify implementation
Thread-Index: AQHNabou38YYYJ9GwEiCac/HaootBJc5el7Q
Date: Wed, 25 Jul 2012 05:51:43 +0000
Message-ID: <4A338DB2991D2A44B9A44B8718AECF650A4586BC@G01JPEXMBYT03>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
 <1343147504-25891-8-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343147504-25891-8-git-send-email-jiang.liu@huawei.com>
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

> -----Original Message-----
> From: Jiang Liu [mailto:liuj97@gmail.com]
> Sent: Wednesday, July 25, 2012 1:31 AM
> To: Bjorn Helgaas; Don Dutile
> Cc: Jiang Liu; Yinghai Lu; Izumi, Taku/泉 拓; Rafael J . Wysocki; Kaneshige,
> Kenji/金重 憲治; Yijing Wang; linux-kernel@vger.kernel.org;
> linux-pci@vger.kernel.org; Jiang Liu
> Subject: [RFC PATCH v2 07/32] PCI/portdrv: use PCIe capabilities access
> functions to simplify implementation
> 
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Use PCIe capabilities access functions to simplify PCIe portdrv
> implementation.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/pci/pcie/portdrv_core.c |   20 ++++++++------------
>  drivers/pci/pcie/portdrv_pci.c  |    7 ++-----
>  2 files changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c
> b/drivers/pci/pcie/portdrv_core.c
> index bf320a9..37bff83 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -76,7 +76,6 @@ static int pcie_port_enable_msix(struct pci_dev *dev,
> int *vectors, int mask)
>  	struct msix_entry *msix_entries;
>  	int idx[PCIE_PORT_DEVICE_MAXSERVICES];
>  	int nr_entries, status, pos, i, nvec;
> -	u16 reg16;
>  	u32 reg32;
> 
>  	nr_entries = pci_msix_table_size(dev);
> @@ -120,9 +119,7 @@ static int pcie_port_enable_msix(struct pci_dev *dev,
> int *vectors, int mask)
>  		 * the value in this field indicates which MSI-X Table entry
> is
>  		 * used to generate the interrupt message."
>  		 */
> -		pos = pci_pcie_cap(dev);
> -		pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &reg16);
> -		entry = (reg16 & PCI_EXP_FLAGS_IRQ) >> 9;
> +		entry = (dev->pcie_flags_reg & PCI_EXP_FLAGS_IRQ) >> 9;
>  		if (entry >= nr_entries)
>  			goto Error;

I think we need to use pci_read_config_word() for MSI setup.

"Interrupt Message Number" in the PCIe capability register can vary depending
on whether MSI or MSI-x is enabled. Please see PCIe spec for details.

Could you double-check that?

Regards,
Kenji Kaneshige



> 
> @@ -246,7 +243,7 @@ static void cleanup_service_irqs(struct pci_dev *dev)
>   */
>  static int get_port_device_capability(struct pci_dev *dev)
>  {
> -	int services = 0, pos;
> +	int services = 0;
>  	u16 reg16;
>  	u32 reg32;
>  	int cap_mask = 0;
> @@ -265,11 +262,9 @@ static int get_port_device_capability(struct pci_dev
> *dev)
>  			return 0;
>  	}
> 
> -	pos = pci_pcie_cap(dev);
> -	pci_read_config_word(dev, pos + PCI_EXP_FLAGS, &reg16);
>  	/* Hot-Plug Capable */
> -	if ((cap_mask & PCIE_PORT_SERVICE_HP) && (reg16 &
> PCI_EXP_FLAGS_SLOT)) {
> -		pci_read_config_dword(dev, pos + PCI_EXP_SLTCAP,
> &reg32);
> +	if ((cap_mask & PCIE_PORT_SERVICE_HP)) {
> +		pci_pcie_capability_read_dword(dev, PCI_EXP_SLTCAP,
> &reg32);
>  		if (reg32 & PCI_EXP_SLTCAP_HPC) {
>  			services |= PCIE_PORT_SERVICE_HP;
>  			/*
> @@ -277,10 +272,11 @@ static int get_port_device_capability(struct pci_dev
> *dev)
>  			 * enabled by the BIOS and the hot-plug service
> driver
>  			 * is not loaded.
>  			 */
> -			pos += PCI_EXP_SLTCTL;
> -			pci_read_config_word(dev, pos, &reg16);
> +			pci_pcie_capability_read_word(dev,
> +						      PCI_EXP_SLTCTL,
> &reg16);
>  			reg16 &= ~(PCI_EXP_SLTCTL_CCIE |
> PCI_EXP_SLTCTL_HPIE);
> -			pci_write_config_word(dev, pos, reg16);
> +			pci_pcie_capability_write_word(dev,
> +						       PCI_EXP_SLTCTL,
> reg16);
>  		}
>  	}
>  	/* AER capable */
> diff --git a/drivers/pci/pcie/portdrv_pci.c
> b/drivers/pci/pcie/portdrv_pci.c
> index 24d1463..1b2b378 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -64,14 +64,11 @@ __setup("pcie_ports=", pcie_port_setup);
>   */
>  void pcie_clear_root_pme_status(struct pci_dev *dev)
>  {
> -	int rtsta_pos;
>  	u32 rtsta;
> 
> -	rtsta_pos = pci_pcie_cap(dev) + PCI_EXP_RTSTA;
> -
> -	pci_read_config_dword(dev, rtsta_pos, &rtsta);
> +	pci_pcie_capability_read_dword(dev, PCI_EXP_RTSTA, &rtsta);
>  	rtsta |= PCI_EXP_RTSTA_PME;
> -	pci_write_config_dword(dev, rtsta_pos, rtsta);
> +	pci_pcie_capability_write_dword(dev, PCI_EXP_RTSTA, rtsta);
>  }
> 
>  static int pcie_portdrv_restore_config(struct pci_dev *dev)
> --
> 1.7.9.5

