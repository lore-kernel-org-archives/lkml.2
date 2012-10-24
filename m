Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab2JXU5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:57:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35377 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2JXU5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:57:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [BUGFIX 1/2] PCI/PM: Fix deadlock when unbind device if its parent in D3cold
Date: Wed, 24 Oct 2012 23:01:24 +0200
Message-ID: <6992627.n0xzVn15jf@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351061654-8339-1-git-send-email-ying.huang@intel.com>
References: <1351061654-8339-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 of October 2012 14:54:13 Huang Ying wrote:
> If a PCI device and its parents are put into D3cold, unbinding the
> device will trigger deadlock as follow:
> 
> - driver_unbind
>   - device_release_driver
>     - device_lock(dev)				<--- previous lock here
>     - __device_release_driver
>       - pm_runtime_get_sync
>         ...
>           - rpm_resume(dev)
>             - rpm_resume(dev->parent)
>               ...
>                 - pci_pm_runtime_resume
>                   ...
>                   - pci_set_power_state
>                     - __pci_start_power_transition
>                       - pci_wakeup_bus(dev->parent->subordinate)
>                         - pci_walk_bus
>                           - device_lock(dev)	<--- dead lock here
> 
> 
> If we do not do device_lock in pci_walk_bus, we can avoid dead lock.
> Device_lock in pci_walk_bus is introduced in commit:
> d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
> is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
> said device_lock is added to pci_walk_bus because:
> 
>   Some error handling functions call pci_walk_bus. For example, PCIe
>   aer. Here we lock the device, so the driver wouldn't detach from the
>   device, as the cb might call driver's callback function.
> 
> So I fixed the dead lock as follow:
> 
> - remove device_lock from pci_walk_bus
> - add device_lock into callback if callback will call driver's callback
> 
> I checked pci_walk_bus users one by one, and found only PCIe aer needs
> device lock.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Zhang Yanmin <yanmin.zhang@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/pci/bus.c                  |    3 ---
>  drivers/pci/pcie/aer/aerdrv_core.c |   20 ++++++++++++++++----
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -320,10 +320,7 @@ void pci_walk_bus(struct pci_bus *top, i
>  		} else
>  			next = dev->bus_list.next;
>  
> -		/* Run device routines with the device locked */
> -		device_lock(&dev->dev);
>  		retval = cb(dev, userdata);
> -		device_unlock(&dev->dev);
>  		if (retval)
>  			break;
>  	}
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -213,6 +213,7 @@ static int report_error_detected(struct
>  	struct aer_broadcast_data *result_data;
>  	result_data = (struct aer_broadcast_data *) data;
>  
> +	device_lock(&dev->dev);
>  	dev->error_state = result_data->state;
>  
>  	if (!dev->driver ||
> @@ -231,12 +232,14 @@ static int report_error_detected(struct
>  				   dev->driver ?
>  				   "no AER-aware driver" : "no driver");
>  		}
> -		return 0;
> +		goto out;
>  	}
>  
>  	err_handler = dev->driver->err_handler;
>  	vote = err_handler->error_detected(dev, result_data->state);
>  	result_data->result = merge_result(result_data->result, vote);
> +out:
> +	device_unlock(&dev->dev);
>  	return 0;
>  }
>  
> @@ -247,14 +250,17 @@ static int report_mmio_enabled(struct pc
>  	struct aer_broadcast_data *result_data;
>  	result_data = (struct aer_broadcast_data *) data;
>  
> +	device_lock(&dev->dev);
>  	if (!dev->driver ||
>  		!dev->driver->err_handler ||
>  		!dev->driver->err_handler->mmio_enabled)
> -		return 0;
> +		goto out;
>  
>  	err_handler = dev->driver->err_handler;
>  	vote = err_handler->mmio_enabled(dev);
>  	result_data->result = merge_result(result_data->result, vote);
> +out:
> +	device_unlock(&dev->dev);
>  	return 0;
>  }
>  
> @@ -265,14 +271,17 @@ static int report_slot_reset(struct pci_
>  	struct aer_broadcast_data *result_data;
>  	result_data = (struct aer_broadcast_data *) data;
>  
> +	device_lock(&dev->dev);
>  	if (!dev->driver ||
>  		!dev->driver->err_handler ||
>  		!dev->driver->err_handler->slot_reset)
> -		return 0;
> +		goto out;
>  
>  	err_handler = dev->driver->err_handler;
>  	vote = err_handler->slot_reset(dev);
>  	result_data->result = merge_result(result_data->result, vote);
> +out:
> +	device_unlock(&dev->dev);
>  	return 0;
>  }
>  
> @@ -280,15 +289,18 @@ static int report_resume(struct pci_dev
>  {
>  	const struct pci_error_handlers *err_handler;
>  
> +	device_lock(&dev->dev);
>  	dev->error_state = pci_channel_io_normal;
>  
>  	if (!dev->driver ||
>  		!dev->driver->err_handler ||
>  		!dev->driver->err_handler->resume)
> -		return 0;
> +		goto out;
>  
>  	err_handler = dev->driver->err_handler;
>  	err_handler->resume(dev);
> +out:
> +	device_unlock(&dev->dev);
>  	return 0;
>  }
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
