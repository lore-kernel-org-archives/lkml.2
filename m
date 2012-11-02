Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab2KBQvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:51:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64162 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab2KBQvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <1351061654-8339-1-git-send-email-ying.huang@intel.com>
References: <1351061654-8339-1-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Nov 2012 10:50:50 -0600
Message-ID: <CAErSpo7hiFQOC+OPZretkyp5EcL84zEWCAiQgEE5Ewq--gUziQ@mail.gmail.com>
Subject: Re: [BUGFIX 1/2] PCI/PM: Fix deadlock when unbind device if its
 parent in D3cold
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:54 AM, Huang Ying <ying.huang@intel.com> wrote:
> If a PCI device and its parents are put into D3cold, unbinding the
> device will trigger deadlock as follow:
>
> - driver_unbind
>   - device_release_driver
>     - device_lock(dev)                          <--- previous lock here
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
>                           - device_lock(dev)    <--- dead lock here
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

Is there a problem report or bugzilla for this issue?

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Zhang Yanmin <yanmin.zhang@intel.com>

Should this go to stable as well?  The D3cold support appeared in
v3.6, so my guess is that this fix could go to v3.6.x.

> ---
>  drivers/pci/bus.c                  |    3 ---
>  drivers/pci/pcie/aer/aerdrv_core.c |   20 ++++++++++++++++----
>  2 files changed, 16 insertions(+), 7 deletions(-)
>
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -320,10 +320,7 @@ void pci_walk_bus(struct pci_bus *top, i
>                 } else
>                         next = dev->bus_list.next;
>
> -               /* Run device routines with the device locked */
> -               device_lock(&dev->dev);
>                 retval = cb(dev, userdata);
> -               device_unlock(&dev->dev);
>                 if (retval)
>                         break;
>         }
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -213,6 +213,7 @@ static int report_error_detected(struct
>         struct aer_broadcast_data *result_data;
>         result_data = (struct aer_broadcast_data *) data;
>
> +       device_lock(&dev->dev);
>         dev->error_state = result_data->state;
>
>         if (!dev->driver ||
> @@ -231,12 +232,14 @@ static int report_error_detected(struct
>                                    dev->driver ?
>                                    "no AER-aware driver" : "no driver");
>                 }
> -               return 0;
> +               goto out;
>         }
>
>         err_handler = dev->driver->err_handler;
>         vote = err_handler->error_detected(dev, result_data->state);
>         result_data->result = merge_result(result_data->result, vote);
> +out:
> +       device_unlock(&dev->dev);
>         return 0;
>  }
>
> @@ -247,14 +250,17 @@ static int report_mmio_enabled(struct pc
>         struct aer_broadcast_data *result_data;
>         result_data = (struct aer_broadcast_data *) data;
>
> +       device_lock(&dev->dev);
>         if (!dev->driver ||
>                 !dev->driver->err_handler ||
>                 !dev->driver->err_handler->mmio_enabled)
> -               return 0;
> +               goto out;
>
>         err_handler = dev->driver->err_handler;
>         vote = err_handler->mmio_enabled(dev);
>         result_data->result = merge_result(result_data->result, vote);
> +out:
> +       device_unlock(&dev->dev);
>         return 0;
>  }
>
> @@ -265,14 +271,17 @@ static int report_slot_reset(struct pci_
>         struct aer_broadcast_data *result_data;
>         result_data = (struct aer_broadcast_data *) data;
>
> +       device_lock(&dev->dev);
>         if (!dev->driver ||
>                 !dev->driver->err_handler ||
>                 !dev->driver->err_handler->slot_reset)
> -               return 0;
> +               goto out;
>
>         err_handler = dev->driver->err_handler;
>         vote = err_handler->slot_reset(dev);
>         result_data->result = merge_result(result_data->result, vote);
> +out:
> +       device_unlock(&dev->dev);
>         return 0;
>  }
>
> @@ -280,15 +289,18 @@ static int report_resume(struct pci_dev
>  {
>         const struct pci_error_handlers *err_handler;
>
> +       device_lock(&dev->dev);
>         dev->error_state = pci_channel_io_normal;
>
>         if (!dev->driver ||
>                 !dev->driver->err_handler ||
>                 !dev->driver->err_handler->resume)
> -               return 0;
> +               goto out;
>
>         err_handler = dev->driver->err_handler;
>         err_handler->resume(dev);
> +out:
> +       device_unlock(&dev->dev);
>         return 0;
>  }
>
