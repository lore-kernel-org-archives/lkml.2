Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0JSO0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:26:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60792 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0JSOZ7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 19 Oct 2010 10:25:59 -0400
Date: Tue, 19 Oct 2010 10:25:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org
Subject: swiotlb-xen tree + xen + linux-next
Message-ID: <20101019142539.GA5726@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen,

Jeremy and I fixed the mega failures you saw and last night Jeremy's
got pulled in while mine was silent. I am enabling my tree today, and while
the previous failure is gone when I do a merge of my tree against linux-next,
I keep on getting one that I am having trouble solving.

The issues is that my patchset touches drivers/pci/Makefile which
had been changed a bit by a): 350a55e9ff6005032407d3234af800f413b03af5
(PCI: use new ccflags variable in Makefile) which does this:
@@ -65,6 +65,4 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 
 obj-$(CONFIG_PCI_STUB) += pci-stub.o
 
-ifeq ($(CONFIG_PCI_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG

And then b) my patch (git commit 956a9202cd1220397933a07beda9f96b3df1fa24
xen-pcifront: Xen PCI frontend driver.) goes in and tries to add:

@@ -65,6 +65,8 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 
 obj-$(CONFIG_PCI_STUB) += pci-stub.o
 
+obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
+
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
 endif

I've tried to put a) patch in the branch and rebase my tree on top of that
and this way, the "ifeq ($(CONFIG_PCI_DEBUG_...)" is gone, but merge still
complains! The error is:

diff --cc drivers/pci/Makefile
index dcd7ace,39c7327..0000000
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@@ -65,4 -65,7 +65,10 @@@ obj-$(CONFIG_PCI_SYSCALL) += syscall.
  
  obj-$(CONFIG_PCI_STUB) += pci-stub.o
  
++<<<<<<< HEAD
++=======
+ # Xen PCI frontend driver
+ obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
+ 
++>>>>>>> stable/xen-pcifront-0.8.3
  ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG

[That branch with the a) patch is stable/xen-pcifront-0.8.3, which differs
from #linux-next (which is linked to stable/xen-pcifront-0.8.2) by just
having the patch a) in it. I am not going to use that for #linux-next as
it does not seem to make merging automatic].

Any ideas why it is doing this?

In the internim and so that the merge tonight won't be broken, I've
attached a merge conflict patch instead:

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index dcd7ace..f01e344 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -65,4 +65,6 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 
 obj-$(CONFIG_PCI_STUB) += pci-stub.o
 
+obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
+
 ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
