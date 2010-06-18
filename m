Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab0FRUks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:40:48 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:22565 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751000Ab0FRUkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:40:47 -0400
Message-ID: <4C1BD9CC.5060300@athenacr.com>
Date: Fri, 18 Jun 2010 16:40:44 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jbarnes@virtuousgeek.org, rjw@sisk.pl, mikpe@it.uu.se,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       maciej.rutecki@gmail.com, achiang@canonical.com
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create duplicate
 filename ... XVR-600 related?
References: <19475.45707.157935.788004@pilspetsen.it.uu.se>	<201006122052.25204.rjw@sisk.pl>	<20100618131049.462ca7ce@virtuousgeek.org> <20100618.132655.260090086.davem@davemloft.net>
In-Reply-To: <20100618.132655.260090086.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 04:26 PM, David Miller wrote:
> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date: Fri, 18 Jun 2010 13:10:49 -0700
> 
>> I reverted the symlink patch that was causing the trouble.  The root
>> cause is elsewhere though; it seems some firmwares report duplicate PCI
>> slot numbers...
> 
> Instead of postulating, you can confirm or deny such a theory
> by taking a look at the repository of sparc openfirmware tree
> dumps maintained at:
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/davem/prtconfs.git

(Adding Alex Chiang to the cc list)

I was actually under the impression that it was just an 
issue with the reverted patch, not an actual problem with
hardware.

In the patch, 2 individual code paths were trying to
create the same symlinks:
pci-sysfs.c:pci_create_slot_links(struct pci_dev *dev)
and
slot.c:create_sysfs_files(struct pci_slot *slot).
I think some archs managed to call those both during
initialization, and some not.

commit 75568f8094eb0333e9c2109b23cbc8b82d318a3c
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Mar 8 10:24:29 2010 -0700

    PCI: create function symlinks in /sys/bus/pci/slots/N/
    
    Create convenience symlinks in sysfs, linking slots to device
    functions, and vice versa. These links make it easier for users to
    figure out which devices actually live in what slots.
    
    For example:
    
    sapphire:/sys/bus/pci/slots # ls
    1  10  2  3  4  5  6  7  8  9
    
    sapphire:/sys/bus/pci/slots # ls -l 3
    total 0
    -r--r--r-- 1 root root 65536 Aug 18 14:10 address
    lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 ->
    ../../../../devices/pci0000:23/0000:23:01.0
    lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 ->
    ../../../../devices/pci0000:23/0000:23:01.1
    
    sapphire:/sys/bus/pci/slots # ls -l 3/function0/slot
    lrwxrwxrwx 1 root root 0 Aug 18 14:13 3/function0/slot ->
    ../../../bus/pci/slots/3
    
    The original form of this patch was written by Matthew Wilcox,
    and was enhanced to include links from the sysfs slots/ directory
    pointing back at the device functions.
    
    Cc: willy@linux.intel.com
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 25be325..428676c 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -133,6 +133,46 @@ Description:
 		The symbolic link points to the PCI device sysfs entry of the
 		Physical Function this device associates with.
 
+
+What:		/sys/bus/pci/slots/...
+Date:		April 2005 (possibly older)
+KernelVersion:	2.6.12 (possibly older)
+Contact:	linux-pci@vger.kernel.org
+Description:
+		When the appropriate driver is loaded, it will create a
+		directory per claimed physical PCI slot in
+		/sys/bus/pci/slots/.  The names of these directories are
+		specific to the driver, which in turn, are specific to the
+		platform, but in general, should match the label on the
+		machine's physical chassis.
+
+		The drivers that can create slot directories include the
+		PCI hotplug drivers, and as of 2.6.27, the pci_slot driver.
+
+		The slot directories contain, at a minimum, a file named
+		'address' which contains the PCI bus:device:function tuple.
+		Other files may appear as well, but are specific to the
+		driver.
+
+What:		/sys/bus/pci/slots/.../function[0-7]
+Date:		March 2010
+KernelVersion:	2.6.35
+Contact:	linux-pci@vger.kernel.org
+Description:
+		If PCI slot directories (as described above) are created,
+		and the physical slot is actually populated with a device,
+		symbolic links in the slot directory pointing to the
+		device's PCI functions are created as well.
+
+What:		/sys/bus/pci/devices/.../slot
+Date:		March 2010
+KernelVersion:	2.6.35
+Contact:	linux-pci@vger.kernel.org
+Description:
+		If PCI slot directories (as described above) are created,
+		a symbolic link pointing to the slot directory will be
+		created as well.
+
 What:		/sys/bus/pci/slots/.../module
 Date:		June 2009
 Contact:	linux-pci@vger.kernel.org
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fad9398..941e939 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1011,6 +1011,39 @@ error:
 	return retval;
 }
 
+static void pci_remove_slot_links(struct pci_dev *dev)
+{
+	char func[10];
+	struct pci_slot *slot;
+
+	sysfs_remove_link(&dev->dev.kobj, "slot");
+	list_for_each_entry(slot, &dev->bus->slots, list) {
+		if (slot->number != PCI_SLOT(dev->devfn))
+			continue;
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		sysfs_remove_link(&slot->kobj, func);
+	}
+}
+
+static int pci_create_slot_links(struct pci_dev *dev)
+{
+	int result = 0;
+	char func[10];
+	struct pci_slot *slot;
+
+	list_for_each_entry(slot, &dev->bus->slots, list) {
+		if (slot->number != PCI_SLOT(dev->devfn))
+			continue;
+		result = sysfs_create_link(&dev->dev.kobj, &slot->kobj, "slot");
+		if (result)
+			goto out;
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		result = sysfs_create_link(&slot->kobj, &dev->dev.kobj, func);
+	}
+out:
+	return result;
+}
+
 int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 {
 	int retval;
@@ -1073,6 +1106,8 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 	if (retval)
 		goto err_vga_file;
 
+	pci_create_slot_links(pdev);
+
 	return 0;
 
 err_vga_file:
@@ -1122,6 +1157,8 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
 	if (!sysfs_initialized)
 		return;
 
+	pci_remove_slot_links(pdev);
+
 	pci_remove_capabilities_sysfs(pdev);
 
 	if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 659eaa0..e0189cf 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -97,6 +97,50 @@ static ssize_t cur_speed_read_file(struct pci_slot *slot, char *buf)
 	return bus_speed_read(slot->bus->cur_bus_speed, buf);
 }
 
+static void remove_sysfs_files(struct pci_slot *slot)
+{
+	char func[10];
+	struct list_head *tmp;
+
+	list_for_each(tmp, &slot->bus->devices) {
+		struct pci_dev *dev = pci_dev_b(tmp);
+		if (PCI_SLOT(dev->devfn) != slot->number)
+			continue;
+		sysfs_remove_link(&dev->dev.kobj, "slot");
+
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		sysfs_remove_link(&slot->kobj, func);
+	}
+}
+
+static int create_sysfs_files(struct pci_slot *slot)
+{
+	int result;
+	char func[10];
+	struct list_head *tmp;
+
+	list_for_each(tmp, &slot->bus->devices) {
+		struct pci_dev *dev = pci_dev_b(tmp);
+		if (PCI_SLOT(dev->devfn) != slot->number)
+			continue;
+
+		result = sysfs_create_link(&dev->dev.kobj, &slot->kobj, "slot");
+		if (result)
+			goto fail;
+
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		result = sysfs_create_link(&slot->kobj, &dev->dev.kobj, func);
+		if (result)
+			goto fail;
+	}
+
+	return 0;
+
+fail:
+	remove_sysfs_files(slot);
+	return result;
+}
+
 static void pci_slot_release(struct kobject *kobj)
 {
 	struct pci_dev *dev;
@@ -109,6 +153,8 @@ static void pci_slot_release(struct kobject *kobj)
 		if (PCI_SLOT(dev->devfn) == slot->number)
 			dev->slot = NULL;
 
+	remove_sysfs_files(slot);
+
 	list_del(&slot->list);
 
 	kfree(slot);
@@ -300,6 +346,8 @@ placeholder:
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
 
+	create_sysfs_files(slot);
+
 	list_for_each_entry(dev, &parent->devices, bus_list)
 		if (PCI_SLOT(dev->devfn) == slot_nr)
 			dev->slot = slot;
