Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2IHVGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 17:06:51 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:50205 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2IHVGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 17:06:48 -0400
Date: Sat, 8 Sep 2012 15:06:45 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: Use local parameter pci_device_id for
 pci_get_subsys/class()
Message-ID: <20120908210645.GA8678@google.com>
References: <20120801004319.GA7043@localhost>
 <20120822025008.GA8066@localhost>
 <20120822154908.2e6ef3c0@feng-i7>
 <CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
 <20120823154503.15a45b14@feng-i7>
 <CAE9FiQVXj6sLEs0GiBnVsKAbms-Bnt06xYeT01MBtSjNqaqypA@mail.gmail.com>
 <CAE9FiQU2sqXLyMg2KbdKQBaX8WDeagd=OmZ5ELhYgkUQ4b6jZA@mail.gmail.com>
 <20120908134220.GA24831@localhost>
 <20120908233455.0d0527b3@feng-i7>
 <CAE9FiQU1MxyRvYapi35j5_N7Ob7rnPTYNcvDbMYcSy9VNmaz=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU1MxyRvYapi35j5_N7Ob7rnPTYNcvDbMYcSy9VNmaz=g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 11:40:52AM -0700, Yinghai Lu wrote:
> On Sat, Sep 8, 2012 at 8:34 AM, Feng Tang <feng.tang@intel.com> wrote:
> >> This makes lspci work again on my side. The caveat is, kzalloc() will
> >> zero out all data while the new local variable leaves some data
> >> uninitialized.
> >
> > Yes, thanks for the quick root cause and fix to the bug in my code.
> 
> Can you resubmit your patch with two extra "memset" line?

I updated the patch as follows and rebased my "next" branch to include it:

commit e664f5bd55247bba3a6ebd61f83d6c9cd87ce0de
Author: Feng Tang <feng.tang@intel.com>
Date:   Thu Aug 23 15:45:03 2012 +0800

    PCI: Use pci_device_id on stack for pci_get_subsys/class() to avoid kmalloc
    
    This fixes a kernel warning https://lkml.org/lkml/2012/7/31/682
    
    pci_get_subsys() may get called in late system reboot stage, using
    a sleepable kmalloc() sounds fragile and will cause a kernel warning
    with my recent commmit 55c844a "x86/reboot: Fix a warning message
    triggered by stop_other_cpus()" which disable local interrupt in
    late system shutdown/reboot phase. Using a local parameter instead
    will fix it and make it eligible for calling forom atomic context.
    
    Do the same change for the pci_get_class() as suggested by Bjorn Helgaas
    
    [bhelgaas: changelog, clear pci_device_id on stack with memset()]
    Bisected-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 993d4a0..e0a0310 100644
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
@@ -257,18 +256,13 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
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
+	memset(&id, 0, sizeof(id));
+	id.vendor = vendor;
+	id.device = device;
+	id.subvendor = ss_vendor;
+	id.subdevice = ss_device;
 
-	return pdev;
+	return pci_get_dev_by_id(&id, from);
 }
 
 /**
@@ -307,19 +301,14 @@ pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)
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
+	memset(&id, 0, sizeof(id));
+	id.vendor = id.device = id.subvendor = id.subdevice = PCI_ANY_ID;
+	id.class_mask = PCI_ANY_ID;
+	id.class = class;
 
-	dev = pci_get_dev_by_id(id, from);
-	kfree(id);
-	return dev;
+	return pci_get_dev_by_id(&id, from);
 }
 
 /**
