Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1LTKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:16:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:11472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab1LTKQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:16:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89453348"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Date: Tue, 20 Dec 2011 18:15:42 +0800
Subject: RE: [PATCH] PCI: Enable ATS at the device state restore 
Thread-Topic: [PATCH] PCI: Enable ATS at the device state restore 
Thread-Index: Acy8vYBdrOPLkdxfSSiIqKHdDEFTLQCQnXuA
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E28904877DA@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jesse
Do you have any comments for this fix patch?

Thanks,
-Xudong

> -----Original Message-----
> From: Hao, Xudong
> Sent: Saturday, December 17, 2011 9:25 PM
> To: 'jbarnes@virtuousgeek.org'; 'linux-pci@vger.kernel.org'
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Zhang, Xiantao
> Subject: [PATCH] PCI: Enable ATS at the device state restore
> 
> When system go to S3 or S4 sleep and then return, some register of PCI device
> does not be restored correctly, such as ATS capability. The same problem
> happen on pci reset function.
> 
> This patch enables ATS at the device state restore if PCI device has ATS
> capability.
> 
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
> ---
>  drivers/pci/ats.c |   17 +++++++++++++++++
>  drivers/pci/pci.c |    1 +
>  drivers/pci/pci.h |    8 ++++++++
>  3 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c index 7ec56fb..a6c2b35 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -127,6 +127,23 @@ void pci_disable_ats(struct pci_dev *dev)  }
> EXPORT_SYMBOL_GPL(pci_disable_ats);
> 
> +void pci_restore_ats_state(struct pci_dev *dev) {
> +	u16 ctrl;
> +
> +	if (!pci_ats_enabled(dev))
> +		return;
> +	if (!pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS))
> +		BUG();
> +
> +	ctrl = PCI_ATS_CTRL_ENABLE;
> +	if (!dev->is_virtfn)
> +		ctrl |= PCI_ATS_CTRL_STU(dev->ats->stu - PCI_ATS_MIN_STU);
> +
> +	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl); }
> +EXPORT_SYMBOL_GPL(pci_restore_ats_state);
> +
>  /**
>   * pci_ats_queue_depth - query the ATS Invalidate Queue Depth
>   * @dev: the PCI device
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c index 6f45a73..6dafc1d 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -956,6 +956,7 @@ void pci_restore_state(struct pci_dev *dev)
> 
>  	/* PCI Express register must be restored first */
>  	pci_restore_pcie_state(dev);
> +	pci_restore_ats_state(dev);
> 
>  	/*
>  	 * The Base Address register should be programmed before the command
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h index b74084e..a4f3140 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -249,6 +249,14 @@ struct pci_sriov {
>  	u8 __iomem *mstate;	/* VF Migration State Array */
>  };
> 
> +#ifdef CONFIG_PCI_ATS
> +extern void pci_restore_ats_state(struct pci_dev *dev); #else static
> +inline void pci_restore_ats_state(struct pci_dev *dev) { } #endif /*
> +CONFIG_PCI_ATS */
> +
>  #ifdef CONFIG_PCI_IOV
>  extern int pci_iov_init(struct pci_dev *dev);  extern void
> pci_iov_release(struct pci_dev *dev);
