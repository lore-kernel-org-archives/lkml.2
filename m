Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0GHNMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:12:54 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:59148 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0GHNMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:12:53 -0400
X-IronPort-AV: E=Sophos;i="4.53,558,1272844800"; 
   d="scan'208";a="799965"
Date: Thu, 8 Jul 2010 14:13:17 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Don Dutile <ddutile@redhat.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "stefano@stabellini.net" <stefano@stabellini.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [PATCH 12/13] Unplug emulated disks and nics
In-Reply-To: <4C34DD1B.3010601@redhat.com>
Message-ID: <alpine.DEB.2.00.1007081246440.21432@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <1277136847-13266-12-git-send-email-stefano@stabellini.net> <4C2CEF56.4050008@redhat.com> <alpine.DEB.2.00.1007051255310.29110@kaball-desktop> <4C34DD1B.3010601@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010, Don Dutile wrote:
> Stefano Stabellini wrote:
> > On Thu, 1 Jul 2010, Don Dutile wrote:
> >> The problem with this check/enable is that if you run
> >> this on an older qemu-xen that doesn't have unplug support,
> >> it fails pv-hvm configuration.
> >>
> >> But, all that means is that you can't use an xvd as the boot device,
> >> and you have to use an emulated IDE device as boot device.
> >> There are a couple ways to configure the vnif correctly (in guest
> >> or in xen guest config file).
> >>
> >> So, on an older (say, rhel5) xen, I don't have this check;
> >> the boot device is required to be spec'd as hda, not vda, and
> >> xen-blkfront is not allowed to configure blk major nums
> >> for IDE (& SCSI) (to avoid 2 drivers twiddling w/same phys backend... not good!).
> >>
> > 
> > Who is requiring that the boot device is spec'd as hda and not xvda?
> > I don't think there is such limitation in xend or libxl at the moment.
> > 
> 
> If you take a previous xen HVM guest spec & just run it on a guest
> that has pv-hvm added to it, then one has hda spec'd as boot device (by default,
> by not editing the guest config spec/file).
> 
> Ideally, both config specs should/would work.
 
I wouldn't want to cause data corruptions by default to people that
specified xvda in their HVM config files by mistake (for example because
they copied and pasted from a PV guest config file).
But I agree that we should be able to do the right thing in your case
scenario too.

I propose the appended patch (to be merge with "Unplug emulated disks
and nics"): if the user specifies xen_emul_unplug=ignore and the unplug
protocol is not supported (old xen installations like rhel5), we
continue with the PV on HVM initialization and we make sure that
blkfront doesn't hook any IDE or SCSI device.

Don, Jeremy, what do you think about it?


---


diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
index 72a3da6..2f7f3fb 100644
--- a/arch/x86/xen/platform-pci-unplug.c
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -29,9 +29,9 @@
 #define XEN_PLATFORM_ERR_PROTOCOL -2
 #define XEN_PLATFORM_ERR_BLACKLIST -3
 
-/* boolean to signal that the platform pci device can be used */
-bool xen_platform_pci_enabled;
-EXPORT_SYMBOL_GPL(xen_platform_pci_enabled);
+/* store the value of xen_emul_unplug after the unplug is done */
+int xen_platform_pci_unplug;
+EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 static int xen_emul_unplug;
 
 static int __init check_platform_magic(void)
@@ -76,13 +76,13 @@ void __init xen_unplug_emulated_devices(void)
 	/* If the version matches enable the Xen platform PCI driver.
 	 * Also enable the Xen platform PCI driver if the version is really old
 	 * and the user told us to ignore it. */
-	if (!r || (r == XEN_PLATFORM_ERR_MAGIC &&
-				(xen_emul_unplug & XEN_UNPLUG_IGNORE)))
-		xen_platform_pci_enabled = 1;
+	if (r && !(r == XEN_PLATFORM_ERR_MAGIC &&
+			(xen_emul_unplug & XEN_UNPLUG_IGNORE)))
+		return;
 	/* Set the default value of xen_emul_unplug depending on whether or
 	 * not the Xen PV frontends and the Xen platform PCI driver have
 	 * been compiled for this kernel (modules or built-in are both OK). */
-	if (xen_platform_pci_enabled && !xen_emul_unplug) {
+	if (!xen_emul_unplug) {
 		if (xen_must_unplug_nics()) {
 			printk(KERN_INFO "Netfront and the Xen platform PCI driver have "
 					"been compiled for this kernel: unplug emulated NICs.\n");
@@ -98,8 +98,9 @@ void __init xen_unplug_emulated_devices(void)
 		}
 	}
 	/* Now unplug the emulated devices */
-	if (xen_platform_pci_enabled && !(xen_emul_unplug & XEN_UNPLUG_IGNORE))
+	if (!(xen_emul_unplug & XEN_UNPLUG_IGNORE))
 		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
+	xen_platform_pci_unplug = xen_emul_unplug;
 }
 
 static int __init parse_xen_emul_unplug(char *arg)
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 82ed403..6eb2989 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -48,6 +48,7 @@
 #include <xen/grant_table.h>
 #include <xen/events.h>
 #include <xen/page.h>
+#include <xen/platform_pci.h>
 
 #include <xen/interface/grant_table.h>
 #include <xen/interface/io/blkif.h>
@@ -737,6 +738,22 @@ static int blkfront_probe(struct xenbus_device *dev,
 		}
 	}
 
+	/* no unplug has been done: do not hook devices != xen vbds */
+	if (xen_hvm_domain() && (xen_platform_pci_unplug & XEN_UNPLUG_IGNORE)) {
+		int major;
+
+		if (!VDEV_IS_EXTENDED(vdevice))
+			major = BLKIF_MAJOR(vdevice);
+		else
+			major = XENVBD_MAJOR;
+
+		if (major != XENVBD_MAJOR) {
+			printk(KERN_INFO
+					"%s: HVM does not support vbd %d as xen block device\n",
+					__FUNCTION__, vdevice);
+			return -ENODEV;
+		}
+	}
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index be8b4f3..c01b5dd 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -196,7 +196,9 @@ static struct pci_driver platform_driver = {
 
 static int __init platform_pci_module_init(void)
 {
-	if (!xen_platform_pci_enabled)
+	/* no unplug has been done, IGNORE hasn't been specified: just
+	 * return now */
+	if (!xen_platform_pci_unplug)
 		return -ENODEV;
 
 	return pci_register_driver(&platform_driver);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 243279a..34287da 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -978,7 +978,7 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 #ifndef MODULE
 static int __init boot_wait_for_devices(void)
 {
-	if (xen_hvm_domain() && !xen_platform_pci_enabled)
+	if (xen_hvm_domain() && !xen_platform_pci_unplug)
 		return -ENODEV;
 
 	ready_to_wait_for_devices = 1;
diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
index afa8855..ce9d671 100644
--- a/include/xen/platform_pci.h
+++ b/include/xen/platform_pci.h
@@ -44,6 +44,6 @@ static inline int xen_must_unplug_disks(void) {
 #endif
 }
 
-extern bool xen_platform_pci_enabled;
+extern int xen_platform_pci_unplug;
 
 #endif /* _XEN_PLATFORM_PCI_H */
