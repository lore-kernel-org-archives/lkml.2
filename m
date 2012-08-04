Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2HDVmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 17:42:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42212 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab2HDVmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 17:42:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [BUGFIX 2/4] PCI/PM: Keep parent bridge active when probing device
Date: Sat, 4 Aug 2012 23:48:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org
References: <1343975435-25469-1-git-send-email-ying.huang@intel.com> <1343975435-25469-3-git-send-email-ying.huang@intel.com>
In-Reply-To: <1343975435-25469-3-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201208042348.08820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 03, 2012, Huang Ying wrote:
> This patch fixes the following bug:
> 
> http://marc.info/?l=linux-pci&m=134329923124234&w=2
> 
> The root cause of the bug is as follow.
> 
> If a device is not bound with the corresponding driver, the device
> runtime PM will be disabled and the device will be put into suspended
> state.  So that, the bridge/PCIe port connected to it may be put into
> suspended and low power state.  When do probing for the device later,
> because the bridge/PCIe port connected to it is in low power state,
> the IO access to device may fail.
> 
> To solve the issue, the bridge/PCIe port connected to the device is
> put into active state before probing.
> 
> Reported-by: Bjorn Mork <bjorn@mork.no>
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/pci/pci-driver.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -280,8 +280,12 @@ static long local_pci_probe(void *_ddi)
>  {
>  	struct drv_dev_and_id *ddi = _ddi;
>  	struct device *dev = &ddi->dev->dev;
> +	struct device *parent = dev->parent;
>  	int rc;
>  
> +	/* The parent bridge must be in active state when probing */
> +	if (parent)
> +		pm_runtime_get_sync(parent);
>  	/* Unbound PCI devices are always set to disabled and suspended.
>  	 * During probe, the device is set to enabled and active and the
>  	 * usage count is incremented.  If the driver supports runtime PM,
> @@ -298,6 +302,8 @@ static long local_pci_probe(void *_ddi)
>  		pm_runtime_set_suspended(dev);
>  		pm_runtime_put_noidle(dev);
>  	}
> +	if (parent)
> +		pm_runtime_put(parent);
>  	return rc;
>  }
>  
> 
> 

