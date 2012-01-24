Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2AXSep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:34:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59191 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757375Ab2AXSem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:34:42 -0500
Date: Tue, 24 Jan 2012 13:34:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        <linux-input@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-pcmcia@lists.infradead.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] Dynamic ID addition doesn't need get_driver()
Message-ID: <Pine.LNX.4.44L0.1201241310400.1200-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the removal of get_driver()/put_driver(), this patch
(as1511) changes all the places that add dynamic IDs for drivers.
Since these additions are done by writing to the drivers' sysfs
attribute files, and the attributes are removed when the drivers are
unregistered, there is no reason to take an extra reference to the
drivers.

The one exception is the pci-stub driver, which calls pci_add_dynid()
as part of its registration.  But again, there's no reason to take an
extra reference here, because the driver can't be unloaded while it is
being registered.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Dominik Brodowski <linux@dominikbrodowski.net>

---

 drivers/hid/hid-core.c    |    6 +-----
 drivers/pci/pci-driver.c  |    2 --
 drivers/pcmcia/ds.c       |    5 +----
 drivers/usb/core/driver.c |    5 +----
 4 files changed, 3 insertions(+), 15 deletions(-)

Index: usb-3.3/drivers/hid/hid-core.c
===================================================================
--- usb-3.3.orig/drivers/hid/hid-core.c
+++ usb-3.3/drivers/hid/hid-core.c
@@ -1619,11 +1619,7 @@ static ssize_t store_new_id(struct devic
 	list_add_tail(&dynid->list, &hdrv->dyn_list);
 	spin_unlock(&hdrv->dyn_lock);
 
-	ret = 0;
-	if (get_driver(&hdrv->driver)) {
-		ret = driver_attach(&hdrv->driver);
-		put_driver(&hdrv->driver);
-	}
+	ret = driver_attach(&hdrv->driver);
 
 	return ret ? : count;
 }
Index: usb-3.3/drivers/pci/pci-driver.c
===================================================================
--- usb-3.3.orig/drivers/pci/pci-driver.c
+++ usb-3.3/drivers/pci/pci-driver.c
@@ -72,9 +72,7 @@ int pci_add_dynid(struct pci_driver *drv
 	list_add_tail(&dynid->node, &drv->dynids.list);
 	spin_unlock(&drv->dynids.lock);
 
-	get_driver(&drv->driver);
 	retval = driver_attach(&drv->driver);
-	put_driver(&drv->driver);
 
 	return retval;
 }
Index: usb-3.3/drivers/pcmcia/ds.c
===================================================================
--- usb-3.3.orig/drivers/pcmcia/ds.c
+++ usb-3.3/drivers/pcmcia/ds.c
@@ -127,10 +127,7 @@ pcmcia_store_new_id(struct device_driver
 	list_add_tail(&dynid->node, &pdrv->dynids.list);
 	mutex_unlock(&pdrv->dynids.lock);
 
-	if (get_driver(&pdrv->drv)) {
-		retval = driver_attach(&pdrv->drv);
-		put_driver(&pdrv->drv);
-	}
+	retval = driver_attach(&pdrv->drv);
 
 	if (retval)
 		return retval;
Index: usb-3.3/drivers/usb/core/driver.c
===================================================================
--- usb-3.3.orig/drivers/usb/core/driver.c
+++ usb-3.3/drivers/usb/core/driver.c
@@ -71,10 +71,7 @@ ssize_t usb_store_new_id(struct usb_dyni
 	list_add_tail(&dynid->node, &dynids->list);
 	spin_unlock(&dynids->lock);
 
-	if (get_driver(driver)) {
-		retval = driver_attach(driver);
-		put_driver(driver);
-	}
+	retval = driver_attach(driver);
 
 	if (retval)
 		return retval;

