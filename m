Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2GIVg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2GIVgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:36:25 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 1/8] PCI: Restructure 'pci_do_fixups()'
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 15:36:02 -0600
Message-ID: <20120709213602.8975.58935.stgit@amt.stowe>
In-Reply-To: <20120709213554.8975.60552.stgit@amt.stowe>
References: <20120709213554.8975.60552.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a bit ugly that we have two possible call sites for the quirk: either
inside do_one_fixup_debug() or directly in pci_do_fixups().

This patch restructures pci_do_fixups()'s quirk invocations in the style
of initcall_debug_start() and initcall_debug_report().

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/quirks.c |   46 ++++++++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 194b243..0f5ca86 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2879,20 +2879,34 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f9, quirk_intel_mc_errata);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65fa, quirk_intel_mc_errata);
 
 
-static void do_one_fixup_debug(void (*fn)(struct pci_dev *dev), struct pci_dev *dev)
+static ktime_t fixup_debug_start(struct pci_dev *dev,
+				 void (*fn)(struct pci_dev *dev))
 {
-	ktime_t calltime, delta, rettime;
+	ktime_t calltime = ktime_set(0, 0);
+
+	dev_dbg(&dev->dev, "calling %pF\n", fn);
+	if (initcall_debug) {
+		pr_debug("calling  %pF @ %i for %s\n",
+			 fn, task_pid_nr(current), dev_name(&dev->dev));
+		calltime = ktime_get();
+	}
+
+	return calltime;
+}
+
+static void fixup_debug_report(struct pci_dev *dev, ktime_t calltime,
+			       void (*fn)(struct pci_dev *dev))
+{
+	ktime_t delta, rettime;
 	unsigned long long duration;
 
-	printk(KERN_DEBUG "calling  %pF @ %i for %s\n",
-			fn, task_pid_nr(current), dev_name(&dev->dev));
-	calltime = ktime_get();
-	fn(dev);
-	rettime = ktime_get();
-	delta = ktime_sub(rettime, calltime);
-	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-	printk(KERN_DEBUG "pci fixup %pF returned after %lld usecs for %s\n",
-			fn, duration, dev_name(&dev->dev));
+	if (initcall_debug) {
+		rettime = ktime_get();
+		delta = ktime_sub(rettime, calltime);
+		duration = (unsigned long long) ktime_to_ns(delta) >> 10;
+		pr_debug("pci fixup %pF returned after %lld usecs for %s\n",
+			 fn, duration, dev_name(&dev->dev));
+	}
 }
 
 /*
@@ -2958,6 +2972,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1c2d, asus_ehci_no_d3);
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
+	ktime_t calltime;
+
 	for (; f < end; f++)
 		if ((f->class == (u32) (dev->class >> f->class_shift) ||
 		     f->class == (u32) PCI_ANY_ID) &&
@@ -2965,11 +2981,9 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 		     f->vendor == (u16) PCI_ANY_ID) &&
 		    (f->device == dev->device ||
 		     f->device == (u16) PCI_ANY_ID)) {
-			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
-			if (initcall_debug)
-				do_one_fixup_debug(f->hook, dev);
-			else
-				f->hook(dev);
+			calltime = fixup_debug_start(dev, f->hook);
+			f->hook(dev);
+			fixup_debug_report(dev, calltime, f->hook);
 		}
 }
 

