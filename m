Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2LNHI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:08:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:7573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab2LNHI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:08:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,279,1355126400"; 
   d="scan'208";a="262031218"
Message-ID: <1355468932.24876.153.camel@yhuang-dev>
Subject: Re: [ 02/38] PCI/PM: Fix deadlock when unbinding device if parent
 in D3cold
From: Huang Ying <ying.huang@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Date: Fri, 14 Dec 2012 15:08:52 +0800
In-Reply-To: <20121211180812.GC25714@kroah.com>
References: <20121122003904.262382971@linuxfoundation.org>
	 <20121122003904.516735571@linuxfoundation.org>
	 <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
	 <1353640177.28789.21.camel@yhuang-dev>
	 <1353656862.28789.57.camel@yhuang-dev> <20121130020104.GJ13478@kroah.com>
	 <1354244049.29553.97.camel@yhuang-dev>
	 <1355213572.7216.140.camel@yhuang-dev> <20121211180812.GC25714@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 10:08 -0800, Greg Kroah-Hartman wrote:
> On Tue, Dec 11, 2012 at 04:12:52PM +0800, Huang Ying wrote:
[snip]
> > Which tree should I base the patch on?
> 
> 3.6.10 would be great.

Here is the patch for 3.6.10.

------------------------------------------------------------------------->
Subject: [PATCH] PCI/PM: Fix deadlock when unbind device if its parent in D3cold

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
                          - device_lock(dev)	<--- dead lock here


If we do not do device_lock in pci_walk_bus, we can avoid dead lock.
Device_lock in pci_walk_bus is introduced in commit:
d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
said device_lock is added to pci_walk_bus because:

  Some error handling functions call pci_walk_bus. For example, PCIe
  aer. Here we lock the device, so the driver wouldn't detach from the
  device, as the cb might call driver's callback function.

So I fixed the dead lock as follow:

- remove device_lock from pci_walk_bus
- add device_lock into callback if callback will call driver's callback

I checked pci_walk_bus users one by one, and found only PCIe aer needs
device lock.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Zhang Yanmin <yanmin.zhang@intel.com>
---
 arch/powerpc/platforms/pseries/eeh_driver.c |   35 ++++++++++++++++++++--------
 drivers/pci/bus.c                           |    3 --
 drivers/pci/pcie/aer/aerdrv_core.c          |   20 ++++++++++++----
 3 files changed, 41 insertions(+), 17 deletions(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -316,10 +316,7 @@ void pci_walk_bus(struct pci_bus *top, i
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
 
--- a/arch/powerpc/platforms/pseries/eeh_driver.c
+++ b/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -164,17 +164,18 @@ static int eeh_report_error(struct pci_d
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_frozen;
 
 	driver = eeh_pcid_get(dev);
-	if (!driver) return 0;
+	if (!driver) goto out;
 
 	eeh_disable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->error_detected) {
 		eeh_pcid_put(dev);
-		return 0;
+		goto out;
 	}
 
 	rc = driver->err_handler->error_detected(dev, pci_channel_io_frozen);
@@ -184,6 +185,8 @@ static int eeh_report_error(struct pci_d
 	if (*res == PCI_ERS_RESULT_NONE) *res = rc;
 
 	eeh_pcid_put(dev);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -201,13 +204,14 @@ static int eeh_report_mmio_enabled(struc
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	driver = eeh_pcid_get(dev);
-	if (!driver) return 0;
+	if (!driver) goto out;
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->mmio_enabled) {
 		eeh_pcid_put(dev);
-		return 0;
+		goto out;
 	}
 
 	rc = driver->err_handler->mmio_enabled(dev);
@@ -217,6 +221,8 @@ static int eeh_report_mmio_enabled(struc
 	if (*res == PCI_ERS_RESULT_NONE) *res = rc;
 
 	eeh_pcid_put(dev);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -235,17 +241,18 @@ static int eeh_report_reset(struct pci_d
 	enum pci_ers_result rc, *res = userdata;
 	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_normal;
 
 	driver = eeh_pcid_get(dev);
-	if (!driver) return 0;
+	if (!driver) goto out;
 
 	eeh_enable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->slot_reset) {
 		eeh_pcid_put(dev);
-		return 0;
+		goto out;
 	}
 
 	rc = driver->err_handler->slot_reset(dev);
@@ -255,6 +262,8 @@ static int eeh_report_reset(struct pci_d
 	     rc == PCI_ERS_RESULT_NEED_RESET) *res = rc;
 
 	eeh_pcid_put(dev);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -271,22 +280,25 @@ static int eeh_report_resume(struct pci_
 {
 	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_normal;
 
 	driver = eeh_pcid_get(dev);
-	if (!driver) return 0;
+	if (!driver) goto out;
 
 	eeh_enable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->resume) {
 		eeh_pcid_put(dev);
-		return 0;
+		goto out;
 	}
 
 	driver->err_handler->resume(dev);
 
 	eeh_pcid_put(dev);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -302,22 +314,25 @@ static int eeh_report_failure(struct pci
 {
 	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_perm_failure;
 
 	driver = eeh_pcid_get(dev);
-	if (!driver) return 0;
+	if (!driver) goto out;
 
 	eeh_disable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->error_detected) {
 		eeh_pcid_put(dev);
-		return 0;
+		goto out;
 	}
 
 	driver->err_handler->error_detected(dev, pci_channel_io_perm_failure);
 
 	eeh_pcid_put(dev);
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 


