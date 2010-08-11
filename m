Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab0HKX7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:41 -0400
Received: from kroah.org ([198.145.64.141]:43672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759074Ab0HKX7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:19 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:04 2010
Message-Id: <20100811235504.240678436@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [094/111] powerpc/eeh: Fix a bug when pci structure is null
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Breno Leitao <leitao@linux.vnet.ibm.com>

commit 8d3d50bf1913561ef3b1f5b53115c5a481ba9b1e upstream.

During a EEH recover, the pci_dev structure can be null, mainly if an
eeh event is detected during cpi config operation. In this case, the
pci_dev will not be known (and will be null) the kernel will crash
with the following message:

Unable to handle kernel paging request for data at address 0x000000a0
Faulting instruction address: 0xc00000000006b8b4
Oops: Kernel access of bad area, sig: 11 [#1]

NIP [c00000000006b8b4] .eeh_event_handler+0x10c/0x1a0
LR [c00000000006b8a8] .eeh_event_handler+0x100/0x1a0
Call Trace:
[c0000003a80dff00] [c00000000006b8a8] .eeh_event_handler+0x100/0x1a0
[c0000003a80dff90] [c000000000031f1c] .kernel_thread+0x54/0x70

The bug occurs because pci_name() tries to access a null pointer.
This patch just guarantee that pci_name() is not called on Null pointers.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: Linas Vepstas <linasvepstas@gmail.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/ppc-pci.h          |    5 +++++
 arch/powerpc/platforms/pseries/eeh.c        |    4 ++--
 arch/powerpc/platforms/pseries/eeh_driver.c |    4 ++--
 arch/powerpc/platforms/pseries/eeh_event.c  |    2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/ppc-pci.h
+++ b/arch/powerpc/include/asm/ppc-pci.h
@@ -137,6 +137,11 @@ struct device_node * find_device_pe(stru
 void eeh_sysfs_add_device(struct pci_dev *pdev);
 void eeh_sysfs_remove_device(struct pci_dev *pdev);
 
+static inline const char *eeh_pci_name(struct pci_dev *pdev)
+{
+	return pdev ? pci_name(pdev) : "<null>";
+}
+
 #endif /* CONFIG_EEH */
 
 #else /* CONFIG_PCI */
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -491,7 +491,7 @@ int eeh_dn_check_failure(struct device_n
 	    pdn->eeh_mode & EEH_MODE_NOCHECK) {
 		ignored_check++;
 		pr_debug("EEH: Ignored check (%x) for %s %s\n",
-			 pdn->eeh_mode, pci_name (dev), dn->full_name);
+			 pdn->eeh_mode, eeh_pci_name(dev), dn->full_name);
 		return 0;
 	}
 
@@ -515,7 +515,7 @@ int eeh_dn_check_failure(struct device_n
 			printk (KERN_ERR "EEH: %d reads ignored for recovering device at "
 				"location=%s driver=%s pci addr=%s\n",
 				pdn->eeh_check_count, location,
-				dev->driver->name, pci_name(dev));
+				dev->driver->name, eeh_pci_name(dev));
 			printk (KERN_ERR "EEH: Might be infinite loop in %s driver\n",
 				dev->driver->name);
 			dump_stack();
--- a/arch/powerpc/platforms/pseries/eeh_driver.c
+++ b/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -353,7 +353,7 @@ struct pci_dn * handle_eeh_events (struc
 		location = location ? location : "unknown";
 		printk(KERN_ERR "EEH: Error: Cannot find partition endpoint "
 		                "for location=%s pci addr=%s\n",
-		        location, pci_name(event->dev));
+		        location, eeh_pci_name(event->dev));
 		return NULL;
 	}
 
@@ -384,7 +384,7 @@ struct pci_dn * handle_eeh_events (struc
 		pci_str = pci_name (frozen_pdn->pcidev);
 		drv_str = pcid_name (frozen_pdn->pcidev);
 	} else {
-		pci_str = pci_name (event->dev);
+		pci_str = eeh_pci_name(event->dev);
 		drv_str = pcid_name (event->dev);
 	}
 	
--- a/arch/powerpc/platforms/pseries/eeh_event.c
+++ b/arch/powerpc/platforms/pseries/eeh_event.c
@@ -80,7 +80,7 @@ static int eeh_event_handler(void * dumm
 	eeh_mark_slot(event->dn, EEH_MODE_RECOVERING);
 
 	printk(KERN_INFO "EEH: Detected PCI bus error on device %s\n",
-	       pci_name(event->dev));
+	       eeh_pci_name(event->dev));
 
 	pdn = handle_eeh_events(event);
 


