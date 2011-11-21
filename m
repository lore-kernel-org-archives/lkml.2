Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1KUIsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:48:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:7133 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab1KUIsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:48:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78304405"
Message-ID: <4ECA1054.6050805@intel.com>
Date: Mon, 21 Nov 2011 10:48:20 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Yunpeng Gao <yunpeng.gao@intel.com>
Subject: Re: [PATCH] sdhci-pci register legacy PCI PM or runtime PM not both
References: <20111120212951.GA4577@spacedout.fries.net>
In-Reply-To: <20111120212951.GA4577@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/11 23:29, David Fries wrote:
> From: David Fries <David@Fries.net>
> 
> pci_has_legacy_pm_support says to not register both legacy PM
> and runtime PM callbacks, modified ifdefs.

Hasn't this already been done in Chris mmc tree i.e.

commit f353f593fe449178a8cb01cefe559dba125ab8b1
Author: Manuel Lauss <manuel.lauss@googlemail.com>
Date:   Thu Nov 3 11:09:45 2011 +0100

    mmc: sdhci: remove "state" argument from sdhci_suspend_host

    Drop the "state" argument from sdhci_suspend_host.  Its only user is the
    PCI glue;  this allows to move all SDHCI glues to use dev_pm_ops instead.

    Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>
    Acked-by: Adrian Hunter <adrian.hunter@intel.com>
    Signed-off-by: Chris Ball <cjb@laptop.org>

 drivers/mmc/host/sdhci-cns3xxx.c   |    5 +----
 drivers/mmc/host/sdhci-dove.c      |    5 +----
 drivers/mmc/host/sdhci-esdhc-imx.c |    5 +----
 drivers/mmc/host/sdhci-of-esdhc.c  |    5 +----
 drivers/mmc/host/sdhci-of-hlwd.c   |    5 +----
 drivers/mmc/host/sdhci-pci.c       |   26 +++++++++++++-------------
 drivers/mmc/host/sdhci-pltfm.c     |   18 +++++++++++-------
 drivers/mmc/host/sdhci-pltfm.h     |    6 ++++--
 drivers/mmc/host/sdhci-pxav2.c     |    5 +----
 drivers/mmc/host/sdhci-pxav3.c     |    5 +----
 drivers/mmc/host/sdhci-s3c.c       |   21 ++++++++++++++-------
 drivers/mmc/host/sdhci-tegra.c     |    5 +----
 drivers/mmc/host/sdhci.c           |    2 +-
 drivers/mmc/host/sdhci.h           |    2 +-
 14 files changed, 52 insertions(+), 63 deletions(-)



> 
> Signed-off-by: David Fries <David@Fries.net>
> Cc: linux-mmc@vger.kernel.org
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Yunpeng Gao <yunpeng.gao@intel.com>
> ---
>  drivers/mmc/host/sdhci-pci.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index d833d9c..eca6e84 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -991,7 +991,8 @@ static struct sdhci_ops sdhci_pci_ops = {
>   *                                                                           *
>  \*****************************************************************************/
>  
> -#ifdef CONFIG_PM
> +/* Register legacy PM or PM runtime, not both. */
> +#if defined(CONFIG_PM) && !defined(CONFIG_PM_RUNTIME)
>  
>  static int sdhci_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
> @@ -1085,12 +1086,12 @@ static int sdhci_pci_resume(struct pci_dev *pdev)
>  	return 0;
>  }
>  
> -#else /* CONFIG_PM */
> +#else /* CONFIG_PM && !CONFIG_PM_RUNTIME */
>  
>  #define sdhci_pci_suspend NULL
>  #define sdhci_pci_resume NULL
>  
> -#endif /* CONFIG_PM */
> +#endif /* CONFIG_PM && !CONFIG_PM_RUNTIME */
>  
>  #ifdef CONFIG_PM_RUNTIME
>  

