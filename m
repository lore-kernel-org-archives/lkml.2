Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab1KPNtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:49:41 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:48210 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab1KPNti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:49:38 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        annie.li@oracle.com
Subject: [PATCH 2/3] xen/granttable: Grant tables V2 implementation
Date: Wed, 16 Nov 2011 21:49:32 +0800
Message-Id: <1321451372-13596-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EC3B62F.6080702@oracle.com>
References: <4EC3B62F.6080702@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4EC3BF6E.0002,ss=1,re=-2.300,fgs=0
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
 arch/x86/xen/grant-table.c |   37 +++++++++-
 drivers/xen/grant-table.c  |  187 +++++++++++++++++++++++++++++++++++++++++--
 include/xen/grant_table.h  |    6 +-
 3 files changed, 218 insertions(+), 12 deletions(-)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index c6ab2e7..510fca0 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -54,6 +54,20 @@ static int map_pte_fn(pte_t *pte, struct page *pmd_page,
 	return 0;
 }
 
+/*
+ * This function is used to map shared frames to store grant status. It is
+ * different from map_pte_fn above, the frames type here is uint64_t.
+ */
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
@@ -83,7 +97,28 @@ int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
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
+			alloc_vm_area(PAGE_SIZE * max_nr_gframes);
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
index 1bd9d5f..0b412ce 100644
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
 	void *addr;
 } gnttab_shared;
 
@@ -118,6 +123,9 @@ static struct {
 	int (*query_foreign_access)(grant_ref_t);
 } gnttab_interface;
 
+/*This reflects status of grant entries, so act as a global value*/
+static grant_status_t *grstatus;
+
 static int grant_table_version;
 
 static struct gnttab_free_callback *gnttab_free_callback_list;
@@ -125,6 +133,7 @@ static struct gnttab_free_callback *gnttab_free_callback_list;
 static int gnttab_expand(unsigned int req_entries);
 
 #define RPP (PAGE_SIZE / sizeof(grant_ref_t))
+#define SPP (PAGE_SIZE / sizeof(grant_status_t))
 
 static inline grant_ref_t *__gnttab_entry(grant_ref_t entry)
 {
@@ -197,6 +206,7 @@ static void put_free_entry(grant_ref_t ref)
 }
 
 /*
+ * Following comments apply to update_grant_entry_v1 and update_grant_entry_v2.
  * Introducing a valid entry into the grant table:
  *  1. Write ent->domid.
  *  2. Write ent->frame:
@@ -215,6 +225,15 @@ static void update_grant_entry_v1(grant_ref_t ref, domid_t domid,
 	gnttab_shared.v1[ref].flags = flags;
 }
 
+static void update_grant_entry_v2(grant_ref_t ref, domid_t domid,
+				  unsigned long frame, unsigned flags)
+{
+	gnttab_shared.v2[ref].hdr.domid = domid;
+	gnttab_shared.v2[ref].full_page.frame = frame;
+	wmb();
+	gnttab_shared.v2[ref].hdr.flags = GTF_permit_access | flags;
+}
+
 /*
  * Public grant-issuing interface functions
  */
@@ -246,6 +265,11 @@ static int gnttab_query_foreign_access_v1(grant_ref_t ref)
 	return gnttab_shared.v1[ref].flags & (GTF_reading|GTF_writing);
 }
 
+static int gnttab_query_foreign_access_v2(grant_ref_t ref)
+{
+	return grstatus[ref] & (GTF_reading|GTF_writing);
+}
+
 int gnttab_query_foreign_access(grant_ref_t ref)
 {
 	return gnttab_interface.query_foreign_access(ref);
@@ -271,6 +295,29 @@ static int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
 	return 1;
 }
 
+static int gnttab_end_foreign_access_ref_v2(grant_ref_t ref, int readonly)
+{
+	gnttab_shared.v2[ref].hdr.flags = 0;
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
 	return gnttab_interface.end_foreign_access_ref(ref, readonly);
@@ -344,6 +391,37 @@ static unsigned long gnttab_end_foreign_transfer_ref_v1(grant_ref_t ref)
 	return frame;
 }
 
+static unsigned long gnttab_end_foreign_transfer_ref_v2(grant_ref_t ref)
+{
+	unsigned long frame;
+	u16           flags;
+	u16          *pflags;
+
+	pflags = &gnttab_shared.v2[ref].hdr.flags;
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
+	frame = gnttab_shared.v2[ref].full_page.frame;
+	BUG_ON(frame == 0);
+
+	return frame;
+}
+
 unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref)
 {
 	return gnttab_interface.end_foreign_transfer_ref(ref);
@@ -591,6 +669,11 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 }
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
 
+static unsigned nr_status_frames(unsigned nr_grant_frames)
+{
+	return (nr_grant_frames * GREFS_PER_GRANT_FRAME + SPP - 1) / SPP;
+}
+
 static int gnttab_map_frames_v1(unsigned long *frames, unsigned int nr_gframes)
 {
 	int rc;
@@ -605,7 +688,56 @@ static int gnttab_map_frames_v1(unsigned long *frames, unsigned int nr_gframes)
 
 static void gnttab_unmap_frames_v1(void)
 {
-	arch_gnttab_unmap_shared(gnttab_shared.addr, nr_grant_frames);
+	arch_gnttab_unmap(gnttab_shared.addr, nr_grant_frames);
+}
+
+static int gnttab_map_frames_v2(unsigned long *frames, unsigned int nr_gframes)
+{
+	uint64_t *sframes;
+	unsigned int nr_sframes;
+	struct gnttab_get_status_frames getframes;
+	int rc;
+
+	nr_sframes = nr_status_frames(nr_gframes);
+
+	/* No need for kzalloc as it is initialized in following hypercall
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
+	rc = arch_gnttab_map_shared(frames, nr_gframes,
+				    gnttab_max_grant_frames(),
+				    &gnttab_shared.addr);
+	BUG_ON(rc);
+
+	return 0;
+}
+
+static void gnttab_unmap_frames_v2(void)
+{
+	arch_gnttab_unmap(gnttab_shared.addr, nr_grant_frames);
+	arch_gnttab_unmap(grstatus, nr_status_frames(nr_grant_frames));
 }
 
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
@@ -639,6 +771,9 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 		return rc;
 	}
 
+	/* No need for kzalloc as it is initialized in following hypercall
+	 * GNTTABOP_setup_table.
+	 */
 	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
 	if (!frames)
 		return -ENOMEM;
@@ -659,20 +794,54 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 	kfree(frames);
 
+	if (rc < 0)
+		return rc;
 	return 0;
 }
 
 static void gnttab_request_version(void)
 {
-	grant_table_version = 1;
-	gnttab_interface.map_frames = gnttab_map_frames_v1;
-	gnttab_interface.unmap_frames = gnttab_unmap_frames_v1;
-	gnttab_interface.update_entry = update_grant_entry_v1;
-	gnttab_interface.end_foreign_access_ref =
+	int rc;
+	struct gnttab_set_version gsv;
+	const char *str = "we need grant tables version 2, but only version 1 is available\n";
+
+	gsv.version = 2;
+	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
+	if (rc == 0) {
+		grant_table_version = 2;
+		gnttab_interface.map_frames = gnttab_map_frames_v2;
+		gnttab_interface.unmap_frames = gnttab_unmap_frames_v2;
+		gnttab_interface.update_entry = update_grant_entry_v2;
+		gnttab_interface.end_foreign_access_ref =
+					gnttab_end_foreign_access_ref_v2;
+		gnttab_interface.end_foreign_transfer_ref =
+					gnttab_end_foreign_transfer_ref_v2;
+		gnttab_interface.query_foreign_access =
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
+		gnttab_interface.map_frames = gnttab_map_frames_v1;
+		gnttab_interface.unmap_frames = gnttab_unmap_frames_v1;
+		gnttab_interface.update_entry = update_grant_entry_v1;
+		gnttab_interface.end_foreign_access_ref =
 					gnttab_end_foreign_access_ref_v1;
-	gnttab_interface.end_foreign_transfer_ref =
+		gnttab_interface.end_foreign_transfer_ref =
 					gnttab_end_foreign_transfer_ref_v1;
-	gnttab_interface.query_foreign_access = gnttab_query_foreign_access_v1;
+		gnttab_interface.query_foreign_access =
+					gnttab_query_foreign_access_v1;
+
+	}
 	printk(KERN_INFO "Grant tables using version %d layout.\n",
 		grant_table_version);
 }
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index c7a40f8..5494c40 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -146,8 +146,10 @@ gnttab_set_unmap_op(struct gnttab_unmap_grant_ref *unmap, phys_addr_t addr,
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
1.7.6.4

