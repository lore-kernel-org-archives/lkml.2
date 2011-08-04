Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1HDTCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 15:02:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:13190 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1HDTC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 15:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,318,1309762800"; 
   d="scan'208";a="4219472"
Subject: [GIT PULL] dmaengine fixes for 3.1-rc
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 04 Aug 2011 12:02:25 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312484545.867.5.camel@dwillia2-linux>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive the non-slave-dma portion of the dmaengine update.  Now that
Vinod is running the slave-dma tree the update has shrunk.  This minor update
primarily addresses support for new ioat device ids, the rest are random
cleanups and fixlets.

--
Dan

Andi Kleen (1):
      Avoid section type conflict in dma/ioat/dma_v3.c

Axel Lin (1):
      dmaengine: use DEFINE_IDR for static initialization

Dan Williams (1):
      ioat: fix xor_idx_to_desc

Dave Jiang (1):
      ioat: Adding PCI IDs for IOAT devices on SandyBridge platforms

 drivers/dma/dmaengine.c   |    4 +---
 drivers/dma/ioat/dma_v3.c |    8 ++++----
 drivers/dma/ioat/pci.c    |   11 +++++++++++
 include/linux/pci_ids.h   |   10 ++++++++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8bcb15f..bc11eeb 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -61,9 +61,9 @@
 #include <linux/slab.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
+static DEFINE_IDR(dma_idr);
 static LIST_HEAD(dma_device_list);
 static long dmaengine_ref_count;
-static struct idr dma_idr;
 
 /* --- sysfs implementation --- */
 
@@ -1049,8 +1049,6 @@ EXPORT_SYMBOL_GPL(dma_run_dependencies);
 
 static int __init dma_bus_init(void)
 {
-	idr_init(&dma_idr);
-	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
 arch_initcall(dma_bus_init);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index d845dc4..f519c93 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -73,10 +73,10 @@
 /* provide a lookup table for setting the source address in the base or
  * extended descriptor of an xor or pq descriptor
  */
-static const u8 xor_idx_to_desc __read_mostly = 0xd0;
-static const u8 xor_idx_to_field[] __read_mostly = { 1, 4, 5, 6, 7, 0, 1, 2 };
-static const u8 pq_idx_to_desc __read_mostly = 0xf8;
-static const u8 pq_idx_to_field[] __read_mostly = { 1, 4, 5, 0, 1, 2, 4, 5 };
+static const u8 xor_idx_to_desc = 0xe0;
+static const u8 xor_idx_to_field[] = { 1, 4, 5, 6, 7, 0, 1, 2 };
+static const u8 pq_idx_to_desc = 0xf8;
+static const u8 pq_idx_to_field[] = { 1, 4, 5, 0, 1, 2, 4, 5 };
 
 static dma_addr_t xor_get_src(struct ioat_raw_descriptor *descs[2], int idx)
 {
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index fab37d1..5e3a40f 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -72,6 +72,17 @@ static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF8) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_JSF9) },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB0) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB1) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB2) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB3) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB4) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB5) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB6) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB7) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB8) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB9) },
+
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f8910e1..a8571b3 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2699,6 +2699,16 @@
 #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN	0x3b00
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX	0x3b1f
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB0	0x3c20
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB1	0x3c21
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB2	0x3c22
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB3	0x3c23
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB4	0x3c24
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB5	0x3c25
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB6	0x3c26
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB7	0x3c27
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB8	0x3c2e
+#define PCI_DEVICE_ID_INTEL_IOAT_SNB9	0x3c2f
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
 #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
 #define PCI_DEVICE_ID_INTEL_5100_21	0x65f5

commit 21ef4b8b7a7d59a995bf44382de38c95587767d4
Author: Axel Lin <axel.lin@gmail.com>
Date:   Wed Jul 20 11:32:28 2011 +0800

    dmaengine: use DEFINE_IDR for static initialization
    
    We could use DEFINE_IDR for statically allocated idr
    that allow us to save a few lines of code.
    
    And also remove unneeded mutex_init() for dma_list_mutex, as
    dma_list_mutex is initialized automatically by DEFINE_MUTEX().
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d0b0c8c79b26a1f48e1e92a2c073655159e72b7c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 22 14:20:46 2011 -0700

    ioat: fix xor_idx_to_desc
    
    For versions of the device that implement operation-types 0x87, 0x88
    (IOAT_OP_XOR, IOAT_OP_XOR_VAL) this map determines whether a given
    source is located in the base or extended descriptor.  Source addresses
    6 through 8 require an extended descriptor, hence 0xe0, not 0xd0.  No
    shipping hardware currently implements these operation types.
    
    Reported-by: Evgueni Smogailov <evgueni.smogailov@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9b487ced8a903f1028fcfaef1e6406acc91fe0fa
Author: Andi Kleen <ak@linux.intel.com>
Date:   Tue Jun 7 15:26:33 2011 -0700

    Avoid section type conflict in dma/ioat/dma_v3.c
    
    const __read_mostly is not legal and causes section type conflicts.
    That's because the read.mostly section is not read only.
    Simply drop the __read_mostly designation.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    [drop __read_mostly instead of const]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3baef940f289f08e4aada1fd481ab9ee3f070144
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri Jul 22 14:04:56 2011 -0700

    ioat: Adding PCI IDs for IOAT devices on SandyBridge platforms
    
    Adding to pci_id.h and the device table for ioat.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


