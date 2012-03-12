Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2CLNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:25:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:45533 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab2CLNZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:25:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127786416"
Message-ID: <4F5DF945.3010204@intel.com>
Date: Mon, 12 Mar 2012 15:25:25 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Mansoor, Illyas" <illyas.mansoor@intel.com>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: mmc: sdhci-pci: why no .shutdown() implemented
References: <810586B7581CC8469141DADEBC3719120AECF8@BGSMSX102.gar.corp.intel.com>
In-Reply-To: <810586B7581CC8469141DADEBC3719120AECF8@BGSMSX102.gar.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/12 10:15, Mansoor, Illyas wrote:
> Hi All,
> 
> I'm not sure if this is the right mailing list to discuss this question, but
> anyways I'll ask:
> 
> On our platform we implemented a BUG in pci_set_power_state callback when the
> shutdown
> Is in progress, and we caught sdci-pci doing pci_set_power_state(D0) when
> shutdown was
> Already in progress.
> 
> My question, why doesn't sdhci-pci.c implement a .shutdown() callback and close
> the device
> After doing sys_sync()?
> 
> Is there some reason behind it not doing a graceful shutdown.

In general, the kernel does not know how to do a graceful shutdown.  There
may be any number of housekeeping activities that userspace wishes to do
before shutting down.

If file systems are not getting sync'd that is a userspace problem, not a
kernel problem.

> 
> I think it could cause corruption, since there is no guarantee when the system
> will power-off/reboot/halt
> 
> I just implemented a patch to fix this, if it's a good fix I'll submit.
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index f5fe05c..e0818c9 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -23,6 +23,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/async.h>
> +#include <linux/syscalls.h>
> 
>  #include <asm/scatterlist.h>
>  #include <asm/io.h>
> @@ -1342,6 +1343,34 @@ err:
>         return ret;
>  }
> 
> +static void sdhci_pci_shutdown(struct pci_dev *pdev)
> +{
> +       int i;
> +       struct sdhci_pci_chip *chip;
> +
> +       printk(KERN_INFO "%s: Syncing filesystems ... ", __func__);
> +       sys_sync();
> +       printk("done.\n");
> +
> +       pm_runtime_get_sync(&pdev->dev);
> +
> +       chip = pci_get_drvdata(pdev);
> +
> +       if (chip) {
> +               for (i = 0;i < chip->num_slots; i++)
> +                       sdhci_pci_remove_slot(chip->slots[i]);
> +
> +               pci_set_drvdata(pdev, NULL);
> +               kfree(chip);
> +       }
> +
> +       pci_disable_device(pdev);
> +
> +       pm_runtime_put_noidle(&pdev->dev);
> +       pm_runtime_forbid(&pdev->dev);
> +       pm_runtime_disable(&pdev->dev);
> +}
> +
>  static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
>  {
>         int i;
> @@ -1473,6 +1502,7 @@ static struct pci_driver sdhci_driver = {
>         .id_table =     pci_ids,
>         .probe =        sdhci_pci_probe,
>         .remove =       __devexit_p(sdhci_pci_remove),
> +       .shutdown =     sdhci_pci_shutdown,
> 
> 
> -Illyas

