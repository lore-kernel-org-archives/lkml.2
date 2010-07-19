Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936214Ab0GSPqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:46:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936124Ab0GSPqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:46:19 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2] pci: Allow read/write access to sysfs I/O port resources
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        chrisw@redhat.com, ddutile@redhat.com, bjorn.helgaas@hp.com,
        eike-kernel@sf-tec.de
Date: Mon, 19 Jul 2010 09:45:34 -0600
Message-ID: <20100719154321.11535.39055.stgit@localhost6.localdomain6>
In-Reply-To: <20100719031148.13524.25354.stgit@localhost6.localdomain6>
References: <20100719031148.13524.25354.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI sysfs resource files currently only allow mmap'ing.  On x86 this
works fine for memory backed BARs, but doesn't work at all for I/O
port backed BARs.  Add read/write to I/O port PCI sysfs resource
files to allow userspace access to these device regions.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 v2: hopefully better commit log, remove unneeded cast, use bool

 Documentation/filesystems/sysfs-pci.txt |    7 ++-
 drivers/pci/pci-sysfs.c                 |   68 +++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/sysfs-pci.txt b/Documentation/filesystems/sysfs-pci.txt
index 85354b3..74eaac2 100644
--- a/Documentation/filesystems/sysfs-pci.txt
+++ b/Documentation/filesystems/sysfs-pci.txt
@@ -39,7 +39,7 @@ files, each with their own function.
        local_cpus	   nearby CPU mask (cpumask, ro)
        remove		   remove device from kernel's list (ascii, wo)
        resource		   PCI resource host addresses (ascii, ro)
-       resource0..N	   PCI resource N, if present (binary, mmap)
+       resource0..N	   PCI resource N, if present (binary, mmap, rw[1])
        resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
        rom		   PCI ROM resource, if present (binary, ro)
        subsystem_device	   PCI subsystem device (ascii, ro)
@@ -54,13 +54,16 @@ files, each with their own function.
   binary - file contains binary data
   cpumask - file contains a cpumask type
 
+[1] rw for RESOURCE_IO (I/O port) regions only
+
 The read only files are informational, writes to them will be ignored, with
 the exception of the 'rom' file.  Writable files can be used to perform
 actions on the device (e.g. changing config space, detaching a device).
 mmapable files are available via an mmap of the file at offset 0 and can be
 used to do actual device programming from userspace.  Note that some platforms
 don't support mmapping of certain resources, so be sure to check the return
-value from any attempted mmap.
+value from any attempted mmap.  The most notable of these are I/O port
+resources, which also provide read/write access.
 
 The 'enable' file provides a counter that indicates how many times the device 
 has been enabled.  If the 'enable' file currently returns '4', and a '1' is
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5935b85..f7692dc 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -778,6 +778,70 @@ pci_mmap_resource_wc(struct file *filp, struct kobject *kobj,
 	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
+static ssize_t
+pci_resource_io(struct file *filp, struct kobject *kobj,
+		struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count, bool write)
+{
+	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
+						       struct device, kobj));
+	struct resource *res = attr->private;
+	unsigned long port = off;
+	int i;
+
+	for (i = 0; i < PCI_ROM_RESOURCE; i++)
+		if (res == &pdev->resource[i])
+			break;
+	if (i >= PCI_ROM_RESOURCE)
+		return -ENODEV;
+
+	port += pci_resource_start(pdev, i);
+
+	if (port > pci_resource_end(pdev, i))
+		return 0;
+
+	if (port + count - 1 > pci_resource_end(pdev, i))
+		return -EINVAL;
+
+	switch (count) {
+	case 1:
+		if (write)
+			outb(*(u8 *)buf, port);
+		else
+			*(u8 *)buf = inb(port);
+		return 1;
+	case 2:
+		if (write)
+			outw(*(u16 *)buf, port);
+		else
+			*(u16 *)buf = inw(port);
+		return 2;
+	case 4:
+		if (write)
+			outl(*(u32 *)buf, port);
+		else
+			*(u32 *)buf = inl(port);
+		return 4;
+	}
+	return -EINVAL;
+}
+
+static ssize_t
+pci_read_resource_io(struct file *filp, struct kobject *kobj,
+		     struct bin_attribute *attr, char *buf,
+		     loff_t off, size_t count)
+{
+	return pci_resource_io(filp, kobj, attr, buf, off, count, false);
+}
+
+static ssize_t
+pci_write_resource_io(struct file *filp, struct kobject *kobj,
+		      struct bin_attribute *attr, char *buf,
+		      loff_t off, size_t count)
+{
+	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
+}
+
 /**
  * pci_remove_resource_files - cleanup resource files
  * @pdev: dev to cleanup
@@ -828,6 +892,10 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 			sprintf(res_attr_name, "resource%d", num);
 			res_attr->mmap = pci_mmap_resource_uc;
 		}
+		if (pci_resource_flags(pdev, num) & IORESOURCE_IO) {
+			res_attr->read = pci_read_resource_io;
+			res_attr->write = pci_write_resource_io;
+		}
 		res_attr->attr.name = res_attr_name;
 		res_attr->attr.mode = S_IRUSR | S_IWUSR;
 		res_attr->size = pci_resource_len(pdev, num);

