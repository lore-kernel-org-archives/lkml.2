Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2KVSeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:34:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:49016 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab2KVSd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: [ 006/171] PCI/PM: Fix deadlock when unbinding device if parent in D3cold
Date: Wed, 21 Nov 2012 16:39:12 -0800
Message-Id: <20121122004033.949092835@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Ying <ying.huang@intel.com>

commit 90b5c1d7c45eeb622302680ff96ed30c1a2b6f0e upstream.

If a PCI device and its parents are put into D3cold, unbinding the
device will trigger deadlock as follow:

- driver_unbind
  - device_release_driver
    - device_lock(dev)				<--- previous lock here
    - __device_release_driver
      - pm_runtime_get_sync
        ...
          - rpm_resume(dev)
            - rpm_resume(dev->parent)
              ...
                - pci_pm_runtime_resume
                  ...
                  - pci_set_power_state
                    - __pci_start_power_transition
                      - pci_wakeup_bus(dev->parent->subordinate)
                        - pci_walk_bus
                          - device_lock(dev)	<--- deadlock here


If we do not do device_lock in pci_walk_bus, we can avoid deadlock.
Device_lock in pci_walk_bus is introduced in commit:
d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
said device_lock is added to pci_walk_bus because:

  Some error handling functions call pci_walk_bus. For example, PCIe
  aer. Here we lock the device, so the driver wouldn't detach from the
  device, as the cb might call driver's callback function.

So I fixed the deadlock as follows:

- remove device_lock from pci_walk_bus
- add device_lock into callback if callback will call driver's callback

I checked pci_walk_bus users one by one, and found only PCIe aer needs
device lock.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
CC: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/bus.c                  |    3 ---
 drivers/pci/pcie/aer/aerdrv_core.c |   20 ++++++++++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -314,10 +314,7 @@ void pci_walk_bus(struct pci_bus *top, i
 		} else
 			next = dev->bus_list.next;
 
-		/* Run device routines with the device locked */
-		device_lock(&dev->dev);
 		retval = cb(dev, userdata);
-		device_unlock(&dev->dev);
 		if (retval)
 			break;
 	}
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -244,6 +244,7 @@ static int report_error_detected(struct
 	struct aer_broadcast_data *result_data;
 	result_data = (struct aer_broadcast_data *) data;
 
+	device_lock(&dev->dev);
 	dev->error_state = result_data->state;
 
 	if (!dev->driver ||
@@ -262,12 +263,14 @@ static int report_error_detected(struct
 				   dev->driver ?
 				   "no AER-aware driver" : "no driver");
 		}
-		return 0;
+		goto out;
 	}
 
 	err_handler = dev->driver->err_handler;
 	vote = err_handler->error_detected(dev, result_data->state);
 	result_data->result = merge_result(result_data->result, vote);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -278,14 +281,17 @@ static int report_mmio_enabled(struct pc
 	struct aer_broadcast_data *result_data;
 	result_data = (struct aer_broadcast_data *) data;
 
+	device_lock(&dev->dev);
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->mmio_enabled)
-		return 0;
+		goto out;
 
 	err_handler = dev->driver->err_handler;
 	vote = err_handler->mmio_enabled(dev);
 	result_data->result = merge_result(result_data->result, vote);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -296,14 +302,17 @@ static int report_slot_reset(struct pci_
 	struct aer_broadcast_data *result_data;
 	result_data = (struct aer_broadcast_data *) data;
 
+	device_lock(&dev->dev);
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->slot_reset)
-		return 0;
+		goto out;
 
 	err_handler = dev->driver->err_handler;
 	vote = err_handler->slot_reset(dev);
 	result_data->result = merge_result(result_data->result, vote);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -311,15 +320,18 @@ static int report_resume(struct pci_dev
 {
 	struct pci_error_handlers *err_handler;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_normal;
 
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->resume)
-		return 0;
+		goto out;
 
 	err_handler = dev->driver->err_handler;
 	err_handler->resume(dev);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 


