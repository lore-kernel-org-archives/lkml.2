Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab2HWHuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:50:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:26527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab2HWHue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,299,1344236400"; 
   d="scan'208,223";a="212788215"
Date: Thu, 23 Aug 2012 15:45:03 +0800
From: Feng Tang <feng.tang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, <linux-pci@vger.kernel.org>
Subject: [PATCH 1/2] PCI: Use local parameter pci_device_id for
 pci_get_subsys/class()
Message-ID: <20120823154503.15a45b14@feng-i7>
In-Reply-To: <CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
References: <5017D19B.5080806@redhat.com>
	<1343738627.27983.30.camel@gandalf.stny.rr.com>
	<5017D4AB.3090107@redhat.com>
	<1343740419.27983.33.camel@gandalf.stny.rr.com>
	<20120731234336.GA5526@localhost>
	<1343778699.27983.70.camel@gandalf.stny.rr.com>
	<20120731235705.GW2422@linux.vnet.ibm.com>
	<1343779778.27983.73.camel@gandalf.stny.rr.com>
	<20120801001811.GX2422@linux.vnet.ibm.com>
	<20120801004319.GA7043@localhost>
	<20120822025008.GA8066@localhost>
	<20120822154908.2e6ef3c0@feng-i7>
	<CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 57a28ee5e7662ca28ba4c793aa037d64bd082dee Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Wed, 22 Aug 2012 15:41:51 +0800
Subject: [PATCH 1/2] PCI: Use local parameter pci_device_id for pci_get_subsys/class()

This fixes a kernel warning https://lkml.org/lkml/2012/7/31/682

pci_get_subsys() may get called in late system reboot stage, using
a sleepable kmalloc() sounds fragile and will casue a kernel warning
with my recent commmit 55c844a "x86/reboot: Fix a warning message
triggered by stop_other_cpus()" which disable local interrupt in
late system shutdown/reboot phase. Using a local parameter instead
will fix it and make it eligible for calling forom atomic context.

Do the same change for the pci_get_class() as suggeted by Bjorn Helgaas

Bisected-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/pci/search.c |   35 +++++++++++------------------------
 1 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 993d4a0..78a08b1 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -245,8 +245,7 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 			       unsigned int ss_vendor, unsigned int ss_device,
 			       struct pci_dev *from)
 {
-	struct pci_dev *pdev;
-	struct pci_device_id *id;
+	struct pci_device_id id;
 
 	/*
 	 * pci_find_subsys() can be called on the ide_setup() path,
@@ -257,18 +256,12 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 	if (unlikely(no_pci_devices()))
 		return NULL;
 
-	id = kzalloc(sizeof(*id), GFP_KERNEL);
-	if (!id)
-		return NULL;
-	id->vendor = vendor;
-	id->device = device;
-	id->subvendor = ss_vendor;
-	id->subdevice = ss_device;
-
-	pdev = pci_get_dev_by_id(id, from);
-	kfree(id);
+	id.vendor = vendor;
+	id.device = device;
+	id.subvendor = ss_vendor;
+	id.subdevice = ss_device;
 
-	return pdev;
+	return pci_get_dev_by_id(&id, from);
 }
 
 /**
@@ -307,19 +300,13 @@ pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)
  */
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from)
 {
-	struct pci_dev *dev;
-	struct pci_device_id *id;
+	struct pci_device_id id;
 
-	id = kzalloc(sizeof(*id), GFP_KERNEL);
-	if (!id)
-		return NULL;
-	id->vendor = id->device = id->subvendor = id->subdevice = PCI_ANY_ID;
-	id->class_mask = PCI_ANY_ID;
-	id->class = class;
+	id.vendor = id.device = id.subvendor = id.subdevice = PCI_ANY_ID;
+	id.class_mask = PCI_ANY_ID;
+	id.class = class;
 
-	dev = pci_get_dev_by_id(id, from);
-	kfree(id);
-	return dev;
+	return pci_get_dev_by_id(&id, from);
 }
 
 /**
-- 
1.7.1
