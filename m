Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2IQAxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:53:00 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35208 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab2IQAw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:52:56 -0400
Message-ID: <1347843171.4370.13.camel@lorien2>
Subject: [PATCH] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: konrad.wilk@oracle.com, joerg.roedel@amd.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, shuahkhan@gmail.com, x86@kernel.org
Date: Sun, 16 Sep 2012 18:52:51 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent dma mapping error analysis effort showed that a large percentage
of dma_map_single() and dma_map_page() returns are not checked for mapping
errors.

Reference:
http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis

Adding support for tracking dma mapping and unmapping errors to help assess
the following:

When do dma mapping errors get detected?
How often do these errors occur?
Why don't we see failures related to missing dma mapping error checks?
Are they silent failures?

Four new fields are added to struct device when CONFIG_DMA_API_DEBUG is
enabled, to track the following:

dma_map_errors:
  Total number of dma mapping errors returned by the dma mapping interfaces,
  in response to mapping requests from this device.
dma_map_errors_not_checked:
  Total number of dma mapping errors the device failed to check before using
  the returned address.
dma_unmap_errors:
  Total number of times the device tried to unmap or free an invalid dma
  address.
iotlb_overflow_cnt:
  Tracks how many times a swiotlb overflow buffer is returned to this device
  when regular iotlb is full.

Enhancements to dma-debug api are made to add new debugfs interfaces to
report total dma errors, dma errors that are not checked, and unmap errors
for the entire system. Please note that these are counts for all devices in
the system.

The following new dma-debug interfaces are added:

debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr):
	Tracks dma mapping errors checked by the device. It decrements
	the dma_map_errors_not_checked counter that was incremented by
	debug_dma_map_page() when it checked for errors.
debug_dma_dump_map_errors(struct device *dev, int all):
	Allows dump of dma mapping error summary or just the errors if any.

The following existing dma-debug api are changed to support this feature:
debug_dma_map_page():
	Increments dma_map_errors and dma_map_errors_not_checked errors for
	the current device as well as totals for the system, dma-debug api
	keeps track of, when dma_addr is invalid. Please note that this
	routine can no longer call dma_mapping_error(), because of the newly
	added debug_dma_mapping_error() interface. Calling this routine at the
	time dma error unchecked state is registered, will not help if state
	gets changed right away.
check_unmap():
	This is an existing internal routines that checks for unmap errors,
	changed to increment dma_unmap_errors for the current device, as well
	as the dma_unmap_errors counter for the system, dma-debug api keeps
	track of, when a device requests an invalid address to be unmapped.
	Please note that this routine can no longer call dma_mapping_error(),
	because of the newly added debug_dma_mapping_error() interface. Calling
	dma_mapping_error() from this routine will decrement
	dma_map_errors_not_checked counter incorrectly.

The following new swiotlb interface is changed:
swiotlb_map_page():
	Increments iotlb_overflow_cnt for the device when iotlb overflow
	buffer is returned when swiotlb is full.

Changed arch/x86/include/asm/dma-mapping.h to call debug_dma_mapping_error()
to validate these new interfaces on x86_64. Other architectures will be
changed in a subsequent patch.

The current dma-debug infrastructure is designed to track dma mappings, and
debug entries are added only for correctly mapped addresses and not when
mapping fails. Enhancing the current infrastructure to track failed mappings
will result in unnecessary complexity. The approach to add counters to
struct device eliminates the need for maintaining failed mappings in dma-debug
infrastructure and is cleaner and simpler without impacting the existing
dma-debug infrastructure.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 Documentation/DMA-API.txt          |   13 +++++
 arch/x86/include/asm/dma-mapping.h |    1 +
 include/linux/device.h             |    6 ++
 include/linux/dma-debug.h          |   13 +++++
 lib/dma-debug.c                    |  106 ++++++++++++++++++++++++++++++++++--
 lib/swiotlb.c                      |    3 +
 6 files changed, 136 insertions(+), 6 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 66bd97a..59d58b9 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -638,6 +638,19 @@ this directory the following files can currently be found:
 	dma-api/error_count	This file is read-only and shows the total
 				numbers of errors found.
 
+	dma-api/dma_map_errors  This file is read-only and shows the total
+				number of dma mapping errors detected.
+
+	dma-api/dma_map_errors_not_checked
+				This file is read-only and shows the total
+				number of dma mapping errors, device drivers
+				failed to check prior to using the returned
+				address.
+
+	dma-api/dma_unmap_errors
+				This file is read-only and shows the total
+				number of invalid dma unmapping attempts.
+
 	dma-api/num_errors	The number in this file shows how many
 				warnings will be printed to the kernel log
 				before it stops. This number is initialized to
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index f7b4c79..808dae6 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -47,6 +47,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
+	debug_dma_mapping_error(dev, dma_addr);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index dd0d684..38d8917 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -693,6 +693,12 @@ struct device {
 
 	void	(*release)(struct device *dev);
 	struct iommu_group	*iommu_group;
+#ifdef CONFIG_DMA_API_DEBUG
+	int			dma_map_errors;
+	int			dma_map_errors_not_checked;
+	int			dma_unmap_errors;
+	int			iotlb_overflow_cnt;
+#endif
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)
diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 171ad8a..6bec75b 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -39,6 +39,8 @@ extern void debug_dma_map_page(struct device *dev, struct page *page,
 			       int direction, dma_addr_t dma_addr,
 			       bool map_single);
 
+extern void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
+
 extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 				 size_t size, int direction, bool map_single);
 
@@ -83,6 +85,8 @@ extern void debug_dma_sync_sg_for_device(struct device *dev,
 
 extern void debug_dma_dump_mappings(struct device *dev);
 
+extern void debug_dma_dump_map_errors(struct device *dev, int all);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_add_bus(struct bus_type *bus)
@@ -105,6 +109,11 @@ static inline void debug_dma_map_page(struct device *dev, struct page *page,
 {
 }
 
+static inline void debug_dma_mapping_error(struct device *dev,
+					  dma_addr_t dma_addr)
+{
+}
+
 static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 					size_t size, int direction,
 					bool map_single)
@@ -176,6 +185,10 @@ static inline void debug_dma_dump_mappings(struct device *dev)
 {
 }
 
+static inline void debug_dma_dump_map_errors(struct device *dev, int all)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 66ce414..d44e283 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -83,6 +83,11 @@ static u32 global_disable __read_mostly;
 /* Global error count */
 static u32 error_count;
 
+/* dma mapping error counts */
+static u32 dma_map_errors;
+static u32 dma_map_errors_not_checked;
+static u32 dma_unmap_errors;
+
 /* Global error show enable*/
 static u32 show_all_errors __read_mostly;
 /* Number of errors to show */
@@ -104,6 +109,9 @@ static struct dentry *show_num_errors_dent  __read_mostly;
 static struct dentry *num_free_entries_dent __read_mostly;
 static struct dentry *min_free_entries_dent __read_mostly;
 static struct dentry *filter_dent           __read_mostly;
+static struct dentry *dma_map_errors_dent   __read_mostly;
+static struct dentry *dma_map_errors_not_checked_dent   __read_mostly;
+static struct dentry *dma_unmap_errors_dent __read_mostly;
 
 /* per-driver filter related state */
 
@@ -365,12 +373,57 @@ static void hash_bucket_del(struct dma_debug_entry *entry)
 }
 
 /*
+ * Dump map/unmap errors for debugging purposes
+ */
+void debug_dma_dump_map_errors(struct device *dev, int all)
+{
+	if (all) {
+		dev_info(dev,
+			 "DMA-API: DMA map error summary:\n"
+			 "DMA map errors returned = %d\n"
+			 "DMA map errors not checked = %d\n"
+			 "DMA unmap errors = %d\n"
+			 "SWIOTLB overflow triggers = %d\n",
+			 dev->dma_map_errors,
+			 dev->dma_map_errors_not_checked,
+			 dev->dma_unmap_errors,
+			 dev->iotlb_overflow_cnt);
+		return;
+	}
+
+	if (dev->dma_map_errors_not_checked) {
+		dev_err(dev,
+			"DMA-API: Driver failed to check\n"
+			"%d out of a total of %d DMA map errors returned\n"
+			"by DMA mapping interfaces\n",
+			dev->dma_map_errors_not_checked,
+			dev->dma_map_errors);
+	}
+
+	if (dev->dma_unmap_errors) {
+		dev_err(dev,
+			"DMA-API: Driver tried to free invalid\n"
+			"DMA addresses %d times\n",
+			dev->dma_unmap_errors);
+	}
+
+	if (dev->iotlb_overflow_cnt) {
+		dev_err(dev,
+			"DMA-API: SWIOTLB overflow buffer triggered %d times\n",
+			dev->iotlb_overflow_cnt);
+	}
+}
+EXPORT_SYMBOL(debug_dma_dump_map_errors);
+
+/*
  * Dump mapping entries for debugging purposes
  */
 void debug_dma_dump_mappings(struct device *dev)
 {
 	int idx;
 
+	debug_dma_dump_map_errors(dev, 1);
+
 	for (idx = 0; idx < HASH_SIZE; idx++) {
 		struct hash_bucket *bucket = &dma_entry_hash[idx];
 		struct dma_debug_entry *entry;
@@ -695,6 +748,28 @@ static int dma_debug_fs_init(void)
 	if (!filter_dent)
 		goto out_err;
 
+	dma_map_errors_dent = debugfs_create_u32("dma_map_errors", 0444,
+			dma_debug_dent,
+			&dma_map_errors);
+
+	if (!dma_map_errors_dent)
+		goto out_err;
+
+	dma_map_errors_not_checked_dent = debugfs_create_u32(
+			"dma_map_errors_not_checked",
+			0444,
+			dma_debug_dent,
+			&dma_map_errors_not_checked);
+
+	if (!dma_map_errors_not_checked_dent)
+		goto out_err;
+
+	dma_unmap_errors_dent = debugfs_create_u32("dma_unmap_errors", 0444,
+			dma_debug_dent,
+			&dma_unmap_errors);
+	if (!dma_unmap_errors_dent)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -843,13 +918,15 @@ static __init int dma_debug_entries_cmdline(char *str)
 __setup("dma_debug=", dma_debug_cmdline);
 __setup("dma_debug_entries=", dma_debug_entries_cmdline);
 
-static void check_unmap(struct dma_debug_entry *ref)
+static void check_unmap(struct device *dev, struct dma_debug_entry *ref)
 {
 	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+	if (ref->dev_addr == DMA_ERROR_CODE) {
+		dev->dma_unmap_errors += 1;
+		dma_unmap_errors += 1;
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free an invalid DMA memory address\n");
 		return;
@@ -1022,8 +1099,13 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	if (unlikely(global_disable))
 		return;
 
-	if (unlikely(dma_mapping_error(dev, dma_addr)))
+	if (dma_addr == DMA_ERROR_CODE) {
+		dma_map_errors += 1;
+		dev->dma_map_errors += 1;
+		dma_map_errors_not_checked += 1;
+		dev->dma_map_errors_not_checked += 1;
 		return;
+	}
 
 	entry = dma_entry_alloc();
 	if (!entry)
@@ -1050,6 +1132,18 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 }
 EXPORT_SYMBOL(debug_dma_map_page);
 
+void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	if (unlikely(global_disable))
+		return;
+
+	if (dma_addr == DMA_ERROR_CODE) {
+		dma_map_errors_not_checked -= 1;
+		dev->dma_map_errors_not_checked -= 1;
+	}
+}
+EXPORT_SYMBOL(debug_dma_mapping_error);
+
 void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 			  size_t size, int direction, bool map_single)
 {
@@ -1067,7 +1161,7 @@ void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 	if (map_single)
 		ref.type = dma_debug_single;
 
-	check_unmap(&ref);
+	check_unmap(dev, &ref);
 }
 EXPORT_SYMBOL(debug_dma_unmap_page);
 
@@ -1151,7 +1245,7 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		if (!i)
 			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
-		check_unmap(&ref);
+		check_unmap(dev, &ref);
 	}
 }
 EXPORT_SYMBOL(debug_dma_unmap_sg);
@@ -1197,7 +1291,7 @@ void debug_dma_free_coherent(struct device *dev, size_t size,
 	if (unlikely(global_disable))
 		return;
 
-	check_unmap(&ref);
+	check_unmap(dev, &ref);
 }
 EXPORT_SYMBOL(debug_dma_free_coherent);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 45bc1f8..ebf2d07 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -682,6 +682,9 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
+#ifdef CONFIG_DMA_API_DEBUG
+		dev->iotlb_overflow_cnt += 1;
+#endif
 	}
 
 	dev_addr = swiotlb_virt_to_bus(dev, map);
-- 
1.7.9.5



