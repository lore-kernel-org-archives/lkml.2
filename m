Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235Ab2KWHrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:47:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:22773 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030181Ab2KWHrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:47:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,306,1352102400"; 
   d="scan'208";a="221344614"
Message-ID: <1353656862.28789.57.camel@yhuang-dev>
Subject: Re: [ 02/38] PCI/PM: Fix deadlock when unbinding device if parent
 in D3cold
From: Huang Ying <ying.huang@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Date: Fri, 23 Nov 2012 15:47:42 +0800
In-Reply-To: <1353640177.28789.21.camel@yhuang-dev>
References: <20121122003904.262382971@linuxfoundation.org>
	 <20121122003904.516735571@linuxfoundation.org>
	 <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
	 <1353640177.28789.21.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 11:09 +0800, Huang Ying wrote:
> On Fri, 2012-11-23 at 02:35 +0000, Ben Hutchings wrote:
> > On Wed, 2012-11-21 at 16:39 -0800, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Huang Ying <ying.huang@intel.com>
> > > 
> > > commit 90b5c1d7c45eeb622302680ff96ed30c1a2b6f0e upstream.
> > > 
> > > If a PCI device and its parents are put into D3cold, unbinding the
> > > device will trigger deadlock as follow:
> > > 
> > > - driver_unbind
> > >   - device_release_driver
> > >     - device_lock(dev)				<--- previous lock here
> > >     - __device_release_driver
> > >       - pm_runtime_get_sync
> > >         ...
> > >           - rpm_resume(dev)
> > >             - rpm_resume(dev->parent)
> > >               ...
> > >                 - pci_pm_runtime_resume
> > >                   ...
> > >                   - pci_set_power_state
> > >                     - __pci_start_power_transition
> > >                       - pci_wakeup_bus(dev->parent->subordinate)
> > >                         - pci_walk_bus
> > >                           - device_lock(dev)	<--- deadlock here
> > > 
> > > 
> > > If we do not do device_lock in pci_walk_bus, we can avoid deadlock.
> > > Device_lock in pci_walk_bus is introduced in commit:
> > > d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
> > > is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
> > > said device_lock is added to pci_walk_bus because:
> > > 
> > >   Some error handling functions call pci_walk_bus. For example, PCIe
> > >   aer. Here we lock the device, so the driver wouldn't detach from the
> > >   device, as the cb might call driver's callback function.
> > > 
> > > So I fixed the deadlock as follows:
> > > 
> > > - remove device_lock from pci_walk_bus
> > > - add device_lock into callback if callback will call driver's callback
> > > 
> > > I checked pci_walk_bus users one by one, and found only PCIe aer needs
> > > device lock.
> > [...]
> > 
> > What about eeh_report_error() in
> > arch/powerpc/platforms/pseries/eeh_driver.c?
> 
> En...  Because pci_walk_bus() invocation is removed in 3.7, so this
> patch is only valid for 3.7.  We need another version for 3.6.

Here is the patch for 3.6.  I have no powerpc machine, so build test
only.

Subject: [BUGFIX] PCI/PM: Fix deadlock when unbind device if its parent in D3cold

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
 arch/powerpc/platforms/pseries/eeh_driver.c |   51 ++++++++++++++++++----------
 drivers/pci/bus.c                           |    3 -
 drivers/pci/pcie/aer/aerdrv_core.c          |   20 ++++++++--
 3 files changed, 50 insertions(+), 24 deletions(-)

--- a/arch/powerpc/platforms/pseries/eeh_driver.c
+++ b/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -126,18 +126,19 @@ static void eeh_enable_irq(struct pci_de
 static int eeh_report_error(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
-	struct pci_driver *driver = dev->driver;
+	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_frozen;
-
+	driver = dev->driver;
 	if (!driver)
-		return 0;
+		goto out;
 
 	eeh_disable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->error_detected)
-		return 0;
+		goto out;
 
 	rc = driver->err_handler->error_detected(dev, pci_channel_io_frozen);
 
@@ -145,6 +146,8 @@ static int eeh_report_error(struct pci_d
 	if (rc == PCI_ERS_RESULT_NEED_RESET) *res = rc;
 	if (*res == PCI_ERS_RESULT_NONE) *res = rc;
 
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -160,12 +163,14 @@ static int eeh_report_error(struct pci_d
 static int eeh_report_mmio_enabled(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
-	struct pci_driver *driver = dev->driver;
+	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
+	driver = dev->driver;
 	if (!driver ||
 	    !driver->err_handler ||
 	    !driver->err_handler->mmio_enabled)
-		return 0;
+		goto out;
 
 	rc = driver->err_handler->mmio_enabled(dev);
 
@@ -173,6 +178,8 @@ static int eeh_report_mmio_enabled(struc
 	if (rc == PCI_ERS_RESULT_NEED_RESET) *res = rc;
 	if (*res == PCI_ERS_RESULT_NONE) *res = rc;
 
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -189,10 +196,12 @@ static int eeh_report_mmio_enabled(struc
 static int eeh_report_reset(struct pci_dev *dev, void *userdata)
 {
 	enum pci_ers_result rc, *res = userdata;
-	struct pci_driver *driver = dev->driver;
+	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
+	driver = dev->driver;
 	if (!driver)
-		return 0;
+		goto out;
 
 	dev->error_state = pci_channel_io_normal;
 
@@ -200,7 +209,7 @@ static int eeh_report_reset(struct pci_d
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->slot_reset)
-		return 0;
+		goto out;
 
 	rc = driver->err_handler->slot_reset(dev);
 	if ((*res == PCI_ERS_RESULT_NONE) ||
@@ -208,6 +217,8 @@ static int eeh_report_reset(struct pci_d
 	if (*res == PCI_ERS_RESULT_DISCONNECT &&
 	     rc == PCI_ERS_RESULT_NEED_RESET) *res = rc;
 
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -222,21 +233,24 @@ static int eeh_report_reset(struct pci_d
  */
 static int eeh_report_resume(struct pci_dev *dev, void *userdata)
 {
-	struct pci_driver *driver = dev->driver;
+	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_normal;
-
+	driver = dev->driver;
 	if (!driver)
-		return 0;
+		goto out;
 
 	eeh_enable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->resume)
-		return 0;
+		goto out;
 
 	driver->err_handler->resume(dev);
 
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
@@ -250,21 +264,24 @@ static int eeh_report_resume(struct pci_
  */
 static int eeh_report_failure(struct pci_dev *dev, void *userdata)
 {
-	struct pci_driver *driver = dev->driver;
+	struct pci_driver *driver;
 
+	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_perm_failure;
-
+	driver = dev->driver;
 	if (!driver)
-		return 0;
+		goto out;
 
 	eeh_disable_irq(dev);
 
 	if (!driver->err_handler ||
 	    !driver->err_handler->error_detected)
-		return 0;
+		goto out;
 
 	driver->err_handler->error_detected(dev, pci_channel_io_perm_failure);
 
+out:
+	device_unlock(&dev->dev);
 	return 0;
 }
 
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
 


