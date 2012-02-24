Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2BXHr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:47:27 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38110 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2BXHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:47:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/11] PCI: Add class support in quirk handling
Date: Thu, 23 Feb 2012 23:46:49 -0800
Message-Id: <1330069619-14446-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
References: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F47408A.00A1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently there is new support to make quirk calling will report duration time.
That will boot log get more print out with initcall_debug is specified.

Found a lot of quirks are calling for not related devices.

Reason is quirk frame do not support class handling. So quirk code have to
use PCI_ANY_ID for vendor/device and let quirk code itself to check class
inside the func.

The patch add class and cls_shift into struct pci_fixup.
Also update related macro to accept the class and shift.

-v2: fix v1 that left over of sparated patch.
-v3: according to Jesse, change cls to class, cls_shift, to class_shift.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/quirks.c |   12 +++++----
 include/linux/pci.h  |   63 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index fb544d6..2b4b1ea 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2961,17 +2961,19 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
-	while (f < end) {
-		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
-		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
+	for (; f < end; f++)
+		if ((f->class == (u32) (dev->class >> f->class_shift) ||
+		     f->class == (u32) PCI_ANY_ID) &&
+		    (f->vendor == dev->vendor ||
+		     f->vendor == (u16) PCI_ANY_ID) &&
+		    (f->device == dev->device ||
+		     f->device == (u16) PCI_ANY_ID)) {
 			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
 			if (initcall_debug)
 				do_one_fixup_debug(f->hook, dev);
 			else
 				f->hook(dev);
 		}
-		f++;
-	}
 }
 
 extern struct pci_fixup __start_pci_fixups_early[];
diff --git a/include/linux/pci.h b/include/linux/pci.h
index bcaa51c..ec32328 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1364,7 +1364,10 @@ static inline void pci_resource_to_user(const struct pci_dev *dev, int bar,
  */
 
 struct pci_fixup {
-	u16 vendor, device;	/* You can use PCI_ANY_ID here of course */
+	u16 vendor;		/* You can use PCI_ANY_ID here of course */
+	u16 device;		/* You can use PCI_ANY_ID here of course */
+	u32 class;		/* You can use PCI_ANY_ID here too */
+	unsigned int class_shift;	/* should be 0, 8, 16 */
 	void (*hook)(struct pci_dev *dev);
 };
 
@@ -1379,30 +1382,68 @@ enum pci_fixup_pass {
 };
 
 /* Anonymous variables would be nice... */
-#define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, hook)	\
-	static const struct pci_fixup __pci_fixup_##name __used		\
-	__attribute__((__section__(#section))) = { vendor, device, hook };
+#define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,	\
+				  class_shift, hook)			\
+	static const struct pci_fixup const __pci_fixup_##name __used	\
+	__attribute__((__section__(#section), aligned((sizeof(void *)))))    \
+		= { vendor, device, class, class_shift, hook };
+
+#define DECLARE_PCI_FIXUP_CLASS_EARLY(vendor, device, class,		\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_early,			\
+		vendor##device##hook, vendor, device, class, class_shift, hook)
+#define DECLARE_PCI_FIXUP_CLASS_HEADER(vendor, device, class,		\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_header,			\
+		vendor##device##hook, vendor, device, class, class_shift, hook)
+#define DECLARE_PCI_FIXUP_CLASS_FINAL(vendor, device, class,		\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_final,			\
+		vendor##device##hook, vendor, device, class, class_shift, hook)
+#define DECLARE_PCI_FIXUP_CLASS_ENABLE(vendor, device, class,		\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_enable,			\
+		vendor##device##hook, vendor, device, class, class_shift, hook)
+#define DECLARE_PCI_FIXUP_CLASS_RESUME(vendor, device, class,		\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume,			\
+		resume##vendor##device##hook, vendor, device, class,	\
+		class_shift, hook)
+#define DECLARE_PCI_FIXUP_CLASS_RESUME_EARLY(vendor, device, class,	\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume_early,		\
+		resume_early##vendor##device##hook, vendor, device,	\
+		class, class_shift, hook)
+#define DECLARE_PCI_FIXUP_CLASS_SUSPEND(vendor, device, class,		\
+					 class_shift, hook)		\
+	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,			\
+		suspend##vendor##device##hook, vendor, device, class,	\
+		class_shift, hook)
+
 #define DECLARE_PCI_FIXUP_EARLY(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_early,			\
-			vendor##device##hook, vendor, device, hook)
+		vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
 #define DECLARE_PCI_FIXUP_HEADER(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_header,			\
-			vendor##device##hook, vendor, device, hook)
+		vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
 #define DECLARE_PCI_FIXUP_FINAL(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_final,			\
-			vendor##device##hook, vendor, device, hook)
+		vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
 #define DECLARE_PCI_FIXUP_ENABLE(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_enable,			\
-			vendor##device##hook, vendor, device, hook)
+		vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
 #define DECLARE_PCI_FIXUP_RESUME(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume,			\
-			resume##vendor##device##hook, vendor, device, hook)
+		resume##vendor##device##hook, vendor, device,		\
+		PCI_ANY_ID, 0, hook)
 #define DECLARE_PCI_FIXUP_RESUME_EARLY(vendor, device, hook)		\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume_early,		\
-			resume_early##vendor##device##hook, vendor, device, hook)
+		resume_early##vendor##device##hook, vendor, device,	\
+		PCI_ANY_ID, 0, hook)
 #define DECLARE_PCI_FIXUP_SUSPEND(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,			\
-			suspend##vendor##device##hook, vendor, device, hook)
+		suspend##vendor##device##hook, vendor, device,		\
+		PCI_ANY_ID, 0, hook)
 
 #ifdef CONFIG_PCI_QUIRKS
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
-- 
1.7.7

