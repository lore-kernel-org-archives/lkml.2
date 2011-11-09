Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1KIIPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:15:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:54295 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1KIIPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:15:46 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, annie.li@oracle.com
Subject: [PATCH 2/3] Grant tables v2 implementation.
Date: Wed,  9 Nov 2011 16:15:41 +0800
Message-Id: <1320826541-29398-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EBA35D3.3020506@oracle.com>
References: <4EBA35D3.3020506@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EBA36AD.0069,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Annie Li <annie.li@oracle.com>

Receiver-side copying of packets is based on this implementation, it gives
better performance and better CPU accounting. It totally supports three types:
full-page, sub-page and transitive grants.

However this patch does not cover sub-page and transitive grants, it mainly
focus on Full-page part and implements grant table V2 interfaces corresponding
to what already exists in grant table V1, such as: grant table V2
initialization, mapping, releasing and exported interfaces.

Each guest can only supports one type of grant table type, every entry in grant
table should be the same version. It is necessary to set V1 or V2 version before
initializing the grant table.

Grant table exported interfaces of V2 are same with those of V1, Xen is
responsible to judge what grant table version guests are using in every grant
operation.

V2 fulfills the same role of V1, and it is totally backwards compitable with V1.
If dom0 support grant table V2, the guests runing on it can run with either V1
or V2.

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 arch/x86/xen/grant-table.c |   34 ++++++++-
 drivers/xen/grant-table.c  |  194 +++++++++++++++++++++++++++++++++++++++++---
 include/xen/grant_table.h  |    6 +-
 3 files changed, 220 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 65ce508..3e9f936 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -54,6 +54,17 @@ static int map_pte_fn(pte_t *pte, struct page *pmd_page,
 	return 0;
 }
 
+/*32bits is not enough since Xen supports sparse physical memory*/
+static int map_pte_fn_status(pte_t *pte, struct page *pmd_page,
+			     unsigned long addr, void *data)
+{
+	uint64_t **frames = (uint64_t **)data;
+
+	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
+	(*frames)++;
+	return 0;
+}
+
 static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
 			unsigned long addr, void *data)
 {
@@ -83,7 +94,28 @@ int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 	return rc;
 }
 
-void arch_gnttab_unmap_shared(void *shared, unsigned long nr_gframes)
+int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   grant_status_t **__shared)
+{
+	int rc;
+	grant_status_t *shared = *__shared;
+
+	if (shared == NULL) {
+		struct vm_struct *area =
+			xen_alloc_vm_area(PAGE_SIZE * max_nr_gframes);
+		BUG_ON(area == NULL);
+		shared = area->addr;
+		*__shared = shared;
+	}
+
+	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
+				 PAGE_SIZE * nr_gframes,
+				 map_pte_fn_status, &frames);
+	return rc;
+}
+
+void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
 {
 	apply_to_page_range(&init_mm, (unsigned long)shared,
 			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 0d481a9..a3294a26 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -44,6 +44,7 @@
 #include <xen/page.h>
 #include <xen/grant_table.h>
 #include <xen/interface/memory.h>
+#include <xen/hvc-console.h>
 #include <asm/xen/hypercall.h>
 
 #include <asm/pgtable.h>
@@ -53,7 +54,10 @@
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
 #define GNTTAB_LIST_END 0xffffffff
-#define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry_v1))
+#define GREFS_PER_GRANT_FRAME \
+(grant_table_version == 1 ?                      \
+ (PAGE_SIZE / sizeof(struct grant_entry_v1)) :   \
+ (PAGE_SIZE / sizeof(union grant_entry_v2)))
 
 static grant_ref_t **gnttab_list;
 static unsigned int nr_grant_frames;
@@ -66,6 +70,7 @@ EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
 
 static union {
 	struct grant_entry_v1 *v1;
+	union grant_entry_v2 *v2;
 	void *ring_addr;
 } shared;
 
@@ -75,12 +80,25 @@ static union {
  */
 static int gnttab_map_status_v1(unsigned int nr_gframes);
 /*
+ * Mapping grant entry status into a list of frames, returning GNTST_okay means
+ * success and negative value means failure.
+ */
+static int gnttab_map_status_v2(unsigned int nr_gframes);
+/*
  * This function is null for grant table v1, adding it here in order to keep
  * consistent with *_v2 interface.
  */
 static void gnttab_unmap_status_v1(void);
+/*
+ * Release a list of frames mapped in gnttab_map_status_** for grant entry
+ * status.
+ */
+static void gnttab_unmap_status_v2(void);
 
-/*This is a structure of function pointers for grant table v1*/
+/*
+ * This is a structure of function pointers which allows v1 and v2 to use
+ * identical interface.
+ */
 static struct {
 	/*
 	 * Mapping a list of frames for storing grant entry status, this
@@ -129,6 +147,9 @@ static struct {
 	int (*_gnttab_query_foreign_access)(grant_ref_t);
 } gnttab_interface;
 
+/*This reflects status of grant entries, so act as a global value*/
+static grant_status_t *grstatus;
+
 static int grant_table_version;
 
 static struct gnttab_free_callback *gnttab_free_callback_list;
@@ -136,6 +157,7 @@ static struct gnttab_free_callback *gnttab_free_callback_list;
 static int gnttab_expand(unsigned int req_entries);
 
 #define RPP (PAGE_SIZE / sizeof(grant_ref_t))
+#define SPP (PAGE_SIZE / sizeof(grant_status_t))
 
 static inline grant_ref_t *__gnttab_entry(grant_ref_t entry)
 {
@@ -216,6 +238,15 @@ static void update_grant_entry_v1(grant_ref_t ref, domid_t domid,
 	shared.v1[ref].flags = flags;
 }
 
+static void update_grant_entry_v2(grant_ref_t ref, domid_t domid,
+				  unsigned long frame, unsigned flags)
+{
+	shared.v2[ref].full_page.frame = frame;
+	shared.v2[ref].hdr.domid = domid;
+	wmb();
+	shared.v2[ref].hdr.flags = GTF_permit_access | flags;
+}
+
 static void update_grant_entry(grant_ref_t ref, domid_t domid,
 			       unsigned long frame, unsigned flags)
 {
@@ -264,6 +295,11 @@ int gnttab_query_foreign_access_v1(grant_ref_t ref)
 	return shared.v1[ref].flags & (GTF_reading|GTF_writing);
 }
 
+int gnttab_query_foreign_access_v2(grant_ref_t ref)
+{
+	return grstatus[ref] & (GTF_reading|GTF_writing);
+}
+
 int gnttab_query_foreign_access(grant_ref_t ref)
 {
 	return gnttab_interface._gnttab_query_foreign_access(ref);
@@ -289,6 +325,29 @@ int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
 	return 1;
 }
 
+int gnttab_end_foreign_access_ref_v2(grant_ref_t ref, int readonly)
+{
+	shared.v2[ref].hdr.flags = 0;
+	mb();
+	if (grstatus[ref] & (GTF_reading|GTF_writing)) {
+		return 0;
+	} else {
+		/* The read of grstatus needs to have acquire
+		semantics.  On x86, reads already have
+		that, and we just need to protect against
+		compiler reorderings.  On other
+		architectures we may need a full
+		barrier. */
+#ifdef CONFIG_X86
+		barrier();
+#else
+		mb();
+#endif
+		}
+
+	return 1;
+}
+
 int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
 {
 	return gnttab_interface._gnttab_end_foreign_access_ref(ref, readonly);
@@ -362,6 +421,37 @@ unsigned long gnttab_end_foreign_transfer_ref_v1(grant_ref_t ref)
 	return frame;
 }
 
+unsigned long gnttab_end_foreign_transfer_ref_v2(grant_ref_t ref)
+{
+	unsigned long frame;
+	u16           flags;
+	u16          *pflags;
+
+	pflags = &shared.v2[ref].hdr.flags;
+
+	/*
+	 * If a transfer is not even yet started, try to reclaim the grant
+	 * reference and return failure (== 0).
+	 */
+	while (!((flags = *pflags) & GTF_transfer_committed)) {
+		if (sync_cmpxchg(pflags, flags, 0) == flags)
+			return 0;
+		cpu_relax();
+	}
+
+	/* If a transfer is in progress then wait until it is completed. */
+	while (!(flags & GTF_transfer_completed)) {
+		flags = *pflags;
+		cpu_relax();
+	}
+
+	rmb();  /* Read the frame number /after/ reading completion status. */
+	frame = shared.v2[ref].full_page.frame;
+	BUG_ON(frame == 0);
+
+	return frame;
+}
+
 unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref)
 {
 	return gnttab_interface._gnttab_end_foreign_transfer_ref(ref);
@@ -588,7 +678,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		struct page **pages, unsigned int count)
+		      struct page **pages, unsigned int count)
 {
 	int i, ret;
 
@@ -609,18 +699,54 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 }
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
 
+static unsigned nr_status_frames(unsigned nr_grant_frames)
+{
+	return (nr_grant_frames * GREFS_PER_GRANT_FRAME + SPP - 1) / SPP;
+}
+
 static void gnttab_request_version(void)
 {
-	grant_table_version = 1;
-	gnttab_interface._gnttab_map_status = gnttab_map_status_v1;
-	gnttab_interface._gnttab_unmap_status = gnttab_unmap_status_v1;
-	gnttab_interface._update_grant_entry = update_grant_entry_v1;
-	gnttab_interface._gnttab_end_foreign_access_ref =
+	int rc;
+	struct gnttab_set_version gsv;
+	const char *str = "we need grant tables version 2, but only version 1 is available\n";
+
+	gsv.version = 2;
+	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
+	if (rc == 0) {
+		grant_table_version = 2;
+		gnttab_interface._gnttab_map_status = gnttab_map_status_v2;
+		gnttab_interface._gnttab_unmap_status = gnttab_unmap_status_v2;
+		gnttab_interface._update_grant_entry = update_grant_entry_v2;
+		gnttab_interface._gnttab_end_foreign_access_ref =
+					gnttab_end_foreign_access_ref_v2;
+		gnttab_interface._gnttab_end_foreign_transfer_ref =
+					gnttab_end_foreign_transfer_ref_v2;
+		gnttab_interface._gnttab_query_foreign_access =
+					gnttab_query_foreign_access_v2;
+	} else {
+		if (grant_table_version == 2) {
+			/*
+			 * If we've already used version 2 features,
+			 * but then suddenly discover that they're not
+			 * available (e.g. migrating to an older
+			 * version of Xen), almost unbounded badness
+			 * can happen.
+			 */
+			xen_raw_printk(str);
+			panic(str);
+		}
+		grant_table_version = 1;
+		gnttab_interface._gnttab_map_status = gnttab_map_status_v1;
+		gnttab_interface._gnttab_unmap_status = gnttab_unmap_status_v1;
+		gnttab_interface._update_grant_entry = update_grant_entry_v1;
+		gnttab_interface._gnttab_end_foreign_access_ref =
 					gnttab_end_foreign_access_ref_v1;
-	gnttab_interface._gnttab_end_foreign_transfer_ref =
+		gnttab_interface._gnttab_end_foreign_transfer_ref =
 					gnttab_end_foreign_transfer_ref_v1;
-	gnttab_interface._gnttab_query_foreign_access =
+		gnttab_interface._gnttab_query_foreign_access =
 					gnttab_query_foreign_access_v1;
+
+	}
 	printk(KERN_INFO "Grant tables using version %d layout.\n",
 		grant_table_version);
 }
@@ -630,6 +756,44 @@ static int gnttab_map_status_v1(unsigned int nr_gframes)
 	return 0;
 }
 
+static int gnttab_map_status_v2(unsigned int nr_gframes)
+{
+	uint64_t *sframes;
+	unsigned int nr_sframes;
+	struct gnttab_get_status_frames getframes;
+	int rc;
+
+	nr_sframes = nr_status_frames(nr_gframes);
+
+	/* No need for kzalloc as it is initialized in following hyercall
+	 * GNTTABOP_get_status_frames.
+	 */
+	sframes = kmalloc(nr_sframes  * sizeof(uint64_t), GFP_ATOMIC);
+	if (!sframes)
+		return -ENOMEM;
+
+	getframes.dom        = DOMID_SELF;
+	getframes.nr_frames  = nr_sframes;
+	set_xen_guest_handle(getframes.frame_list, sframes);
+
+	rc = HYPERVISOR_grant_table_op(GNTTABOP_get_status_frames,
+				       &getframes, 1);
+	if (rc == -ENOSYS) {
+		kfree(sframes);
+		return -ENOSYS;
+	}
+
+	BUG_ON(rc || getframes.status);
+
+	rc = arch_gnttab_map_status(sframes, nr_sframes,
+				    nr_status_frames(gnttab_max_grant_frames()),
+				    &grstatus);
+	BUG_ON(rc);
+	kfree(sframes);
+
+	return 0;
+}
+
 static int gnttab_map_status(unsigned int nr_gframes)
 {
 	return gnttab_interface._gnttab_map_status(nr_gframes);
@@ -666,6 +830,9 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 		return rc;
 	}
 
+	/* No need for kzalloc as it is initialized in following hyercall
+	 * GNTTABOP_setup_table.
+	 */
 	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
 	if (!frames)
 		return -ENOMEM;
@@ -728,6 +895,11 @@ static void gnttab_unmap_status_v1(void)
 {
 }
 
+static void gnttab_unmap_status_v2(void)
+{
+	arch_gnttab_unmap(grstatus, nr_status_frames(nr_grant_frames));
+}
+
 void gnttab_unmap_status(void)
 {
 	return gnttab_interface._gnttab_unmap_status();
@@ -735,7 +907,7 @@ void gnttab_unmap_status(void)
 
 int gnttab_suspend(void)
 {
-	arch_gnttab_unmap_shared(shared.ring_addr, nr_grant_frames);
+	arch_gnttab_unmap(shared.ring_addr, nr_grant_frames);
 	gnttab_interface._gnttab_unmap_status();
 	return 0;
 }
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 405879d..4568498 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -147,8 +147,10 @@ gnttab_set_unmap_op(struct gnttab_unmap_grant_ref *unmap, phys_addr_t addr,
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
 			   void **__shared);
-void arch_gnttab_unmap_shared(void *shared,
-			      unsigned long nr_gframes);
+int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   grant_status_t **__shared);
+void arch_gnttab_unmap(void *shared, unsigned long nr_gframes);
 
 extern unsigned long xen_hvm_resume_frames;
 unsigned int gnttab_max_grant_frames(void);
-- 
1.7.6

