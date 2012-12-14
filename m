Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab2LNXiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:38:46 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34213 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550Ab2LNXip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:38:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PCIe/PM: Do not suspend port if any subordinate device need PME polling
Date: Sat, 15 Dec 2012 00:43:51 +0100
Message-ID: <1488189.MmZvkLhUAM@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1355453531-23348-1-git-send-email-ying.huang@intel.com>
References: <1355453531-23348-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 14, 2012 10:52:11 AM Huang Ying wrote:
> In
> 
>   http://www.mail-archive.com/linux-usb@vger.kernel.org/msg07976.html
> 
> Ulrich reported that his USB3 cardreader does not work reliably when
> connected to the USB3 port.  It turns out that USB3 controller failed
> to be waken up when plugging in the USB3 cardreader.  Further
> experiment found that the USB3 host controller can only be waken up
> via polling, while not via PME interrupt.  But if the PCIe port that
> the USB3 host controller is connected is suspended, we can not poll
> the USB3 host controller because its config space is not accessible if
> the PCIe port is put into low power state.
> 
> To solve the issue, the PCIe port will not be suspended if any
> subordinate device need PME polling.
> 
> Reported-by: Ulrich Eckhardt <usb@uli-eckhardt.de>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Cc: stable@vger.kernel.org	# 3.6+
> ---
>  drivers/pci/pcie/portdrv_pci.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -134,10 +134,26 @@ static int pcie_port_runtime_resume(stru
>  	return 0;
>  }
>  
> +static int pci_dev_pme_poll(struct pci_dev *pdev, void *data)
> +{
> +	int *pme_poll = data;
> +	*pme_poll = *pme_poll || pdev->pme_poll;

I would write that as

	*pme_poll ||= pdev->pme_poll;

It is not a big deal, though.

> +	return 0;
> +}
> +
>  static int pcie_port_runtime_idle(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	int pme_poll = false;
> +
> +	/*
> +	 * If any subordinate device needs pme poll, we should keep
> +	 * the port in D0, because we need port in D0 to poll it.
> +	 */
> +	pci_walk_bus(pdev->subordinate, pci_dev_pme_poll, &pme_poll);
>  	/* Delay for a short while to prevent too frequent suspend/resume */
> -	pm_schedule_suspend(dev, 10);
> +	if (!pme_poll)
> +		pm_schedule_suspend(dev, 10);
>  	return -EBUSY;
>  }
>  #else

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
