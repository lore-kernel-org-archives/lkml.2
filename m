Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2JCO4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:56:32 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:19753 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2JCO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:56:03 -0400
Message-ID: <1349276159.3192.4.camel@lorien2>
Subject: [PATCH v3] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        stern@rowland.harvard.edu, joerg.roedel@amd.com, bhelgaas@google.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Date: Wed, 03 Oct 2012 08:55:59 -0600
In-Reply-To: <1348621517.3091.6.camel@lorien2>
References: <1347843171.4370.13.camel@lorien2>
	 <1348621517.3091.6.camel@lorien2>
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

Patch v3: Addresses review and design comments from Patch v2.
Patch v2: Addressed design issues from Patch v1.

Enhance dma-debug infrastructure to track dma mapping, and unmapping errors.

map_errors: (system wide counter)
  Total number of dma mapping errors returned by the dma mapping interfaces,
  in response to mapping requests from all devices in the system.
map_errors_not_checked: (system wide counter)
  Total number of dma mapping errors devices failed to check before using
  the returned address.
unmap_errors: (system wide counter)
  Total number of times devices tried to unmap or free an invalid dma
  address.
map_err_type: (new field added to dma_debug_entry structure)
  New field to maintain dma mapping error check status. This error type
  is applicable to the dma map page and dma map single entries tracked by
  dma-debug api. This status indicates whether or not a good mapping is
  checked by the device before its use. dma_map_single() and dma_map_page()
  could fail to create a mapping in some cases, and drivers are expected to
  call dma_mapping_error() to check for errors. Please note that this is not
  counter.

Enhancements to dma-debug api are made to add new debugfs interfaces to
report total dma errors, dma errors that are not checked, and unmap errors
for the entire system. Please note that these are system wide counters for
all devices in the system.

The following new dma-debug interface is added:

debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
	Sets dma map error checked status for the dma map entry if one is
	found. Decrements the system wide dma_map_errors_not_checked counter
	that is incremented by debug_dma_map_page() when it checks for
	mapping error before adding it to the dma debug entry table.

New dma-debug internal interface:
check_mapping_error(struct device *dev, dma_addr_t dma_addr)
Calling dma_mapping_error() from dma-debug api will result in dma mapping
check when it shouldn't. This internal routine checks dma mapping error
without any debug checks. 

The following existing dma-debug api are changed to support this feature:
debug_dma_map_page()
	Increments dma_map_errors and dma_map_errors_not_checked errors totals
	for the system, dma-debug api keeps track of, when dma_addr is invalid.
	This routine now calls internal check_mapping_error() interface to
	avoid doing dma mapping debug checks from dma-debug internal mapping
	error checks.
check_unmap()
	This is an existing internal routines that checks for various mapping
	errors. Changed to increment system wide dma_unmap_errors, when a
	device requests an invalid address to be unmapped. This routine now
	calls internal check_mapping_error() interface to avoid doing dma
	mapping debug checks from dma-debug internal mapping error checks.

Changed arch/x86/include/asm/dma-mapping.h to call debug_dma_mapping_error()
to validate these new interfaces on x86_64. Other architectures will be
changed in a subsequent patch.

Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
        CONFIG_DMA_API_DEBUG enabled and disabled.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 Documentation/DMA-API.txt          |   13 ++++
 arch/x86/include/asm/dma-mapping.h |    1 +
 include/linux/dma-debug.h          |    7 ++
 lib/dma-debug.c                    |  128 ++++++++++++++++++++++++++++++++----
 4 files changed, 136 insertions(+), 13 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 66bd97a..886aaf9 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -638,6 +638,19 @@ this directory the following files can currently be found:
 	dma-api/error_count	This file is read-only and shows the total
 				numbers of errors found.
 
+	dma-api/map_errors	This file is read-only and shows the total
+				number of dma mapping errors detected.
+
+	dma-api/map_errors_not_checked
+				This file is read-only and shows the total
+				number of dma mapping errors, device drivers
+				failed to check prior to using the returned
+				address.
+
+	dma-api/unmap_errors
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
 
diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 171ad8a..fc0e34c 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -39,6 +39,8 @@ extern void debug_dma_map_page(struct device *dev, struct page *page,
 			       int direction, dma_addr_t dma_addr,
 			       bool map_single);
 
+extern void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
+
 extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 				 size_t size, int direction, bool map_single);
 
@@ -105,6 +107,11 @@ static inline void debug_dma_map_page(struct device *dev, struct page *page,
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
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 66ce414..1708a10 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -45,18 +45,25 @@ enum {
 	dma_debug_coherent,
 };
 
+enum map_err_types {
+	MAP_ERR_CHECK_NOT_APPLICABLE,
+	MAP_ERR_NOT_CHECKED,
+	MAP_ERR_CHECKED,
+};
+
 #define DMA_DEBUG_STACKTRACE_ENTRIES 5
 
 struct dma_debug_entry {
-	struct list_head list;
-	struct device    *dev;
-	int              type;
-	phys_addr_t      paddr;
-	u64              dev_addr;
-	u64              size;
-	int              direction;
-	int		 sg_call_ents;
-	int		 sg_mapped_ents;
+	struct list_head    list;
+	struct device       *dev;
+	int                 type;
+	phys_addr_t         paddr;
+	u64                 dev_addr;
+	u64                 size;
+	int                 direction;
+	int		    sg_call_ents;
+	int		    sg_mapped_ents;
+	enum map_err_types  map_err_type;
 #ifdef CONFIG_STACKTRACE
 	struct		 stack_trace stacktrace;
 	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
@@ -83,6 +90,11 @@ static u32 global_disable __read_mostly;
 /* Global error count */
 static u32 error_count;
 
+/* dma mapping error counts */
+static u32 map_errors;
+static u32 map_errors_not_checked;
+static u32 unmap_errors;
+
 /* Global error show enable*/
 static u32 show_all_errors __read_mostly;
 /* Number of errors to show */
@@ -104,6 +116,9 @@ static struct dentry *show_num_errors_dent  __read_mostly;
 static struct dentry *num_free_entries_dent __read_mostly;
 static struct dentry *min_free_entries_dent __read_mostly;
 static struct dentry *filter_dent           __read_mostly;
+static struct dentry *map_errors_dent   __read_mostly;
+static struct dentry *map_errors_not_checked_dent   __read_mostly;
+static struct dentry *unmap_errors_dent __read_mostly;
 
 /* per-driver filter related state */
 
@@ -114,6 +129,12 @@ static struct device_driver *current_driver                    __read_mostly;
 
 static DEFINE_RWLOCK(driver_name_lock);
 
+static const char *const maperr2str[] = {
+	[MAP_ERR_CHECK_NOT_APPLICABLE] = "dma map error check not applicable",
+	[MAP_ERR_NOT_CHECKED] = "dma map error not checked",
+	[MAP_ERR_CHECKED] = "dma map error checked",
+};
+
 static const char *type2name[4] = { "single", "page",
 				    "scather-gather", "coherent" };
 
@@ -381,11 +402,12 @@ void debug_dma_dump_mappings(struct device *dev)
 		list_for_each_entry(entry, &bucket->list, list) {
 			if (!dev || dev == entry->dev) {
 				dev_info(entry->dev,
-					 "%s idx %d P=%Lx D=%Lx L=%Lx %s\n",
+					 "%s idx %d P=%Lx D=%Lx L=%Lx %s %s\n",
 					 type2name[entry->type], idx,
 					 (unsigned long long)entry->paddr,
 					 entry->dev_addr, entry->size,
-					 dir2name[entry->direction]);
+					 dir2name[entry->direction],
+					 maperr2str[entry->map_err_type]);
 			}
 		}
 
@@ -695,6 +717,28 @@ static int dma_debug_fs_init(void)
 	if (!filter_dent)
 		goto out_err;
 
+	map_errors_dent = debugfs_create_u32("map_errors", 0444,
+			dma_debug_dent,
+			&map_errors);
+
+	if (!map_errors_dent)
+		goto out_err;
+
+	map_errors_not_checked_dent = debugfs_create_u32(
+			"map_errors_not_checked",
+			0444,
+			dma_debug_dent,
+			&map_errors_not_checked);
+
+	if (!map_errors_not_checked_dent)
+		goto out_err;
+
+	unmap_errors_dent = debugfs_create_u32("unmap_errors", 0444,
+			dma_debug_dent,
+			&unmap_errors);
+	if (!unmap_errors_dent)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -843,13 +887,29 @@ static __init int dma_debug_entries_cmdline(char *str)
 __setup("dma_debug=", dma_debug_cmdline);
 __setup("dma_debug_entries=", dma_debug_entries_cmdline);
 
+/* Calling dma_mapping_error() from dma-debug api will result in calling
+   debug_dma_mapping_error() - need internal mapping error routine to
+   avoid debug checks */
+#ifndef DMA_ERROR_CODE
+#define DMA_ERROR_CODE 0
+#endif
+static inline int check_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	if (ops->mapping_error)
+		return ops->mapping_error(dev, dma_addr);
+
+	return (dma_addr == DMA_ERROR_CODE);
+}
+
 static void check_unmap(struct dma_debug_entry *ref)
 {
 	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+	if (unlikely(check_mapping_error(ref->dev, ref->dev_addr))) {
+		unmap_errors += 1;
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free an invalid DMA memory address\n");
 		return;
@@ -915,6 +975,15 @@ static void check_unmap(struct dma_debug_entry *ref)
 			   dir2name[ref->direction]);
 	}
 
+	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
+		err_printk(ref->dev, entry,
+			   "DMA-API: device driver failed to check map error"
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped as %s]",
+			   ref->dev_addr, ref->size,
+			   type2name[entry->type]);
+	}
+
 	hash_bucket_del(entry);
 	dma_entry_free(entry);
 
@@ -1022,8 +1091,11 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	if (unlikely(global_disable))
 		return;
 
-	if (unlikely(dma_mapping_error(dev, dma_addr)))
+	if (unlikely(check_mapping_error(dev, dma_addr))) {
+		map_errors += 1;
+		map_errors_not_checked += 1;
 		return;
+	}
 
 	entry = dma_entry_alloc();
 	if (!entry)
@@ -1035,6 +1107,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	entry->dev_addr  = dma_addr;
 	entry->size      = size;
 	entry->direction = direction;
+	entry->map_err_type = MAP_ERR_NOT_CHECKED;
 
 	if (map_single)
 		entry->type = dma_debug_single;
@@ -1050,6 +1123,35 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 }
 EXPORT_SYMBOL(debug_dma_map_page);
 
+void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	struct dma_debug_entry ref;
+	struct dma_debug_entry *entry;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	if (unlikely(global_disable))
+		return;
+
+	ref.dev = dev;
+	ref.dev_addr = dma_addr;
+	bucket = get_hash_bucket(&ref, &flags);
+	entry = bucket_find_exact(bucket, &ref);
+
+	if (!entry) {
+		/* very likley dma-api didn't call debug_dma_map_page() or
+		   debug_dma_map_page() detected mapping error */
+		if (map_errors_not_checked)
+			map_errors_not_checked -= 1;
+		goto out;
+	}
+
+	entry->map_err_type = MAP_ERR_CHECKED;
+out:
+	put_hash_bucket(bucket, &flags);
+}
+EXPORT_SYMBOL(debug_dma_mapping_error);
+
 void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 			  size_t size, int direction, bool map_single)
 {
-- 
1.7.9.5



