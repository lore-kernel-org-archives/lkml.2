Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2I0ODL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:03:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42481 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2I0ODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:03:09 -0400
Date: Thu, 27 Sep 2012 15:03:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in
	lost probes
Message-ID: <20120927140300.GF14358@n2100.arm.linux.org.uk>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk> <CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com> <20120916082510.GN12245@n2100.arm.linux.org.uk> <CACVXFVOZ=4HFAy38q_8ZUjOPffcv_mMTi7KCdh3HcX=MCLw5SQ@mail.gmail.com> <20120926200833.GA14340@kroah.com> <20120926202321.GD30938@n2100.arm.linux.org.uk> <CACVXFVPnpQ6yHiDaoo_CPG7oSEq+ZzxpmTgQv55-tRRyaavDfA@mail.gmail.com> <20120927135809.GE14358@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927135809.GE14358@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 02:58:09PM +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 27, 2012 at 07:47:46AM +0800, Ming Lei wrote:
> > On Thu, Sep 27, 2012 at 4:23 AM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > To be honest, I've not bothered to test the above patch, and now when I
> > > look at it, I notice it's broken - in that on error it will corrupt the
> > > driver list.  Take a look at the error path.
> > >
> > > priv is drv->p.  We add priv->knode_bus to the driver list.  If
> > > driver_attach() returns an error, then we go to out_unregister, which
> > 
> > In fact, driver_attach() always returns zero, so it does __not__ affect
> > your test.
> 
> It may not affect my test, but the fact is, that patch lays down the
> foundations for bugs to be introduced.  Now, while I can test it (and
> have done) I don't think it's suitable for mainline because of _that_.
> 
> If driver_attach() always returns zero, there's no point in it returning
> a value - it might as well return void and stop leading people to
> believe that it might return an error.  So I suggest this alternative
> patch instead, which gets rid of what is effectively dead code, and
> probably a few warnings about not checking the return value from a
> __must_check function (see usb-serial.c).
> 
> With this patch, no one is lead into a false sense of security that,
> after your patch, if driver_attach() ever returns an error, proper
> cleanup will happen - it's blatently obvious to anyone modifying it
> that if they do want it to return an error, they have to audit all the
> users of it, which IMHO is a good thing.

Sorry, old version of that patch.  Here's the right one.

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 2bcef65..39b3ef4 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -714,12 +714,10 @@ int bus_add_driver(struct device_driver *drv)
 	if (error)
 		goto out_unregister;
 
-	if (drv->bus->p->drivers_autoprobe) {
-		error = driver_attach(drv);
-		if (error)
-			goto out_unregister;
-	}
 	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
+	if (drv->bus->p->drivers_autoprobe)
+		driver_attach(drv);
+
 	module_add_driver(drv->owner, drv);
 
 	error = driver_create_file(drv, &driver_attr_uevent);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 4b01ab3..77e2412 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -456,9 +456,9 @@ static int __driver_attach(struct device *dev, void *data)
  * returns 0 and the @dev->driver is set, we've found a
  * compatible pair.
  */
-int driver_attach(struct device_driver *drv)
+void driver_attach(struct device_driver *drv)
 {
-	return bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);
+	bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);
 }
 EXPORT_SYMBOL_GPL(driver_attach);
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 444f8b6..4c16681 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -785,10 +785,12 @@ int __init agp_amd64_init(void)
 
 		/* Look for any AGP bridge */
 		agp_amd64_pci_driver.id_table = agp_amd64_pci_promisc_table;
-		err = driver_attach(&agp_amd64_pci_driver.driver);
-		if (err == 0 && agp_bridges_found == 0) {
+		driver_attach(&agp_amd64_pci_driver.driver);
+		if (agp_bridges_found == 0) {
 			pci_unregister_driver(&agp_amd64_pci_driver);
 			err = -ENODEV;
+		} else {
+			err = 0;
 		}
 	}
 	return err;
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index bb0608c..d2a8de5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1722,9 +1722,9 @@ static ssize_t store_new_id(struct device_driver *drv, const char *buf,
 	list_add_tail(&dynid->list, &hdrv->dyn_list);
 	spin_unlock(&hdrv->dyn_lock);
 
-	ret = driver_attach(&hdrv->driver);
+	driver_attach(&hdrv->driver);
 
-	return ret ? : count;
+	return count;
 }
 static DRIVER_ATTR(new_id, S_IWUSR, NULL, store_new_id);
 
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index da739d9..84f9878 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -670,12 +670,7 @@ static int gameport_driver_remove(struct device *dev)
 
 static void gameport_attach_driver(struct gameport_driver *drv)
 {
-	int error;
-
-	error = driver_attach(&drv->driver);
-	if (error)
-		pr_err("driver_attach() failed for %s, error: %d\n",
-			drv->driver.name, error);
+	driver_attach(&drv->driver);
 }
 
 int __gameport_register_driver(struct gameport_driver *drv, struct module *owner,
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index d0f7533..83f4eeb 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -802,12 +802,7 @@ static void serio_shutdown(struct device *dev)
 
 static void serio_attach_driver(struct serio_driver *drv)
 {
-	int error;
-
-	error = driver_attach(&drv->driver);
-	if (error)
-		pr_warning("driver_attach() failed for %s with error %d\n",
-			   drv->driver.name, error);
+	driver_attach(&drv->driver);
 }
 
 int __serio_register_driver(struct serio_driver *drv, struct module *owner, const char *mod_name)
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 099f46c..07b7ece 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -72,9 +72,9 @@ int pci_add_dynid(struct pci_driver *drv,
 	list_add_tail(&dynid->node, &drv->dynids.list);
 	spin_unlock(&drv->dynids.lock);
 
-	retval = driver_attach(&drv->driver);
+	driver_attach(&drv->driver);
 
-	return retval;
+	return 0;
 }
 
 static void pci_free_dynids(struct pci_driver *drv)
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 079629b..ee631c9 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -103,7 +103,6 @@ pcmcia_store_new_id(struct device_driver *driver, const char *buf, size_t count)
 	__u8 func_id, function, device_no;
 	__u32 prod_id_hash[4] = {0, 0, 0, 0};
 	int fields = 0;
-	int retval = 0;
 
 	fields = sscanf(buf, "%hx %hx %hx %hhx %hhx %hhx %x %x %x %x",
 			&match_flags, &manf_id, &card_id, &func_id, &function, &device_no,
@@ -127,10 +126,8 @@ pcmcia_store_new_id(struct device_driver *driver, const char *buf, size_t count)
 	list_add_tail(&dynid->node, &pdrv->dynids.list);
 	mutex_unlock(&pdrv->dynids.lock);
 
-	retval = driver_attach(&pdrv->drv);
+	driver_attach(&pdrv->drv);
 
-	if (retval)
-		return retval;
 	return count;
 }
 static DRIVER_ATTR(new_id, S_IWUSR, NULL, pcmcia_store_new_id);
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index f536aeb..473c4fd 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -71,10 +71,8 @@ ssize_t usb_store_new_id(struct usb_dynids *dynids,
 	list_add_tail(&dynid->node, &dynids->list);
 	spin_unlock(&dynids->lock);
 
-	retval = driver_attach(driver);
+	driver_attach(driver);
 
-	if (retval)
-		return retval;
 	return count;
 }
 EXPORT_SYMBOL_GPL(usb_store_new_id);
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 27483f9..c48ba9a 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1444,7 +1444,7 @@ int usb_serial_register_drivers(struct usb_serial_driver *const serial_drivers[]
 
 	/* Now set udriver's id_table and look for matches */
 	udriver->id_table = id_table;
-	rc = driver_attach(&udriver->drvwrap.driver);
+	driver_attach(&udriver->drvwrap.driver);
 	return 0;
 
  failed:
diff --git a/include/linux/device.h b/include/linux/device.h
index 6de9415..ab2440d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -829,7 +829,7 @@ static inline void *dev_get_platdata(const struct device *dev)
 extern int __must_check device_bind_driver(struct device *dev);
 extern void device_release_driver(struct device *dev);
 extern int  __must_check device_attach(struct device *dev);
-extern int __must_check driver_attach(struct device_driver *drv);
+extern void driver_attach(struct device_driver *drv);
 extern int __must_check device_reprobe(struct device *dev);
 
 /*

