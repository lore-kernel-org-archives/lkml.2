Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1KIIPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:15:17 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:58270 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1KIIPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:15:14 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, annie.li@oracle.com
Subject: [PATCH 1/3] Introducing grant table V2 stucture
Date: Wed,  9 Nov 2011 16:14:50 +0800
Message-Id: <1320826490-29362-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EBA35D3.3020506@oracle.com>
References: <4EBA35D3.3020506@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4EBA3686.003E,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Annie Li <annie.li@oracle.com>

This patch introduces new structures of grant table V2, grant table V2 is an
extension from V1. Grant table is shared between guest and Xen, and Xen is
responsible to do corresponding work for grant operations, such as: figure
out guest's grant table version, perform different actions based on
different grant table version, etc. Although full-page structure of V2
is different from V1, it play the same role as V1.

This patch also changes existing grant table V1 interfaces into **_V1 style in
order to keep consistence with **_V2 interfaces.

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 arch/x86/xen/grant-table.c          |    7 +-
 drivers/xen/grant-table.c           |  181 ++++++++++++++++++++++++++++++-----
 include/xen/grant_table.h           |    4 +-
 include/xen/interface/grant_table.h |  167 +++++++++++++++++++++++++++++++-
 include/xen/interface/xen.h         |    2 +
 5 files changed, 326 insertions(+), 35 deletions(-)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 49ba9b5..65ce508 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -64,10 +64,10 @@ static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
 
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
-			   struct grant_entry **__shared)
+			   void **__shared)
 {
 	int rc;
-	struct grant_entry *shared = *__shared;
+	void *shared = *__shared;
 
 	if (shared == NULL) {
 		struct vm_struct *area =
@@ -83,8 +83,7 @@ int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 	return rc;
 }
 
-void arch_gnttab_unmap_shared(struct grant_entry *shared,
-			      unsigned long nr_gframes)
+void arch_gnttab_unmap_shared(void *shared, unsigned long nr_gframes)
 {
 	apply_to_page_range(&init_mm, (unsigned long)shared,
 			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4f44b34..0d481a9 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -53,7 +53,7 @@
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
 #define GNTTAB_LIST_END 0xffffffff
-#define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry))
+#define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry_v1))
 
 static grant_ref_t **gnttab_list;
 static unsigned int nr_grant_frames;
@@ -64,7 +64,72 @@ static DEFINE_SPINLOCK(gnttab_list_lock);
 unsigned long xen_hvm_resume_frames;
 EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);
 
-static struct grant_entry *shared;
+static union {
+	struct grant_entry_v1 *v1;
+	void *ring_addr;
+} shared;
+
+/*
+ * This function is null for grant table v1, adding it here in order to keep
+ * consistent with *_v2 interface.
+ */
+static int gnttab_map_status_v1(unsigned int nr_gframes);
+/*
+ * This function is null for grant table v1, adding it here in order to keep
+ * consistent with *_v2 interface.
+ */
+static void gnttab_unmap_status_v1(void);
+
+/*This is a structure of function pointers for grant table v1*/
+static struct {
+	/*
+	 * Mapping a list of frames for storing grant entry status, this
+	 * mechanism can allow better synchronization using barriers. Input
+	 * parameter is frame number, returning GNTST_okay means success and
+	 * negative value means failure.
+	 */
+	int (*_gnttab_map_status)(unsigned int);
+	/*
+	 * Release a list of frames which are mapped in _gnttab_map_status for
+	 * grant entry status.
+	 */
+	void (*_gnttab_unmap_status)(void);
+	/*
+	 * Introducing a valid entry into the grant table, granting the frame
+	 * of this grant entry to domain for accessing, or transfering, or
+	 * transitively accessing. First input parameter is reference of this
+	 * introduced grant entry, second one is domid of granted domain, third
+	 * one is the frame to be granted, and the last one is status of the
+	 * grant entry to be updated.
+	 */
+	void (*_update_grant_entry)(grant_ref_t, domid_t,
+		unsigned long, unsigned);
+	/*
+	 * Stop granting a grant entry to domain for accessing. First input
+	 * parameter is reference of a grant entry whose grant access will be
+	 * stopped, second one is not in use now. If the grant entry is
+	 * currently mapped for reading or writing, just return failure(==0)
+	 * directly and don't tear down the grant access. Otherwise, stop grant
+	 * access for this entry and return success(==1).
+	 */
+	int (*_gnttab_end_foreign_access_ref)(grant_ref_t, int);
+	/*
+	 * Stop granting a grant entry to domain for transfer. If tranfer has
+	 * not started, just reclaim the grant entry and return failure(==0).
+	 * Otherwise, wait for the transfer to complete and then return the
+	 * frame.
+	 */
+	unsigned long (*_gnttab_end_foreign_transfer_ref)(grant_ref_t);
+	/*
+	 * Query the status of a grant entry. Input parameter is reference of
+	 * queried grant entry, return value is the status of queried entry.
+	 * Detailed status(writing/reading) can be gotten from the return value
+	 * by bit operations.
+	 */
+	int (*_gnttab_query_foreign_access)(grant_ref_t);
+} gnttab_interface;
+
+static int grant_table_version;
 
 static struct gnttab_free_callback *gnttab_free_callback_list;
 
@@ -142,6 +207,15 @@ static void put_free_entry(grant_ref_t ref)
 	spin_unlock_irqrestore(&gnttab_list_lock, flags);
 }
 
+static void update_grant_entry_v1(grant_ref_t ref, domid_t domid,
+				  unsigned long frame, unsigned flags)
+{
+	shared.v1[ref].frame = frame;
+	shared.v1[ref].domid = domid;
+	wmb();
+	shared.v1[ref].flags = flags;
+}
+
 static void update_grant_entry(grant_ref_t ref, domid_t domid,
 			       unsigned long frame, unsigned flags)
 {
@@ -155,12 +229,10 @@ static void update_grant_entry(grant_ref_t ref, domid_t domid,
 	 *  3. Write memory barrier (WMB).
 	 *  4. Write ent->flags, inc. valid type.
 	 */
-	shared[ref].frame = frame;
-	shared[ref].domid = domid;
-	wmb();
-	shared[ref].flags = flags;
+	gnttab_interface._update_grant_entry(ref, domid, frame, flags);
 }
 
+
 /*
  * Public grant-issuing interface functions
  */
@@ -187,31 +259,40 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
-int gnttab_query_foreign_access(grant_ref_t ref)
+int gnttab_query_foreign_access_v1(grant_ref_t ref)
 {
-	u16 nflags;
-
-	nflags = shared[ref].flags;
+	return shared.v1[ref].flags & (GTF_reading|GTF_writing);
+}
 
-	return (nflags & (GTF_reading|GTF_writing));
+int gnttab_query_foreign_access(grant_ref_t ref)
+{
+	return gnttab_interface._gnttab_query_foreign_access(ref);
 }
 EXPORT_SYMBOL_GPL(gnttab_query_foreign_access);
 
-int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
+int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
 {
 	u16 flags, nflags;
+	u16 *pflags;
 
-	nflags = shared[ref].flags;
+	pflags = &shared.v1[ref].flags;
+	nflags = *pflags;
 	do {
 		flags = nflags;
 		if (flags & (GTF_reading|GTF_writing)) {
 			printk(KERN_ALERT "WARNING: g.e. still in use!\n");
 			return 0;
 		}
-	} while ((nflags = sync_cmpxchg(&shared[ref].flags, flags, 0)) != flags);
+	} while ((nflags = sync_cmpxchg(&shared.v1[ref].flags, flags, 0))
+			!= flags);
 
 	return 1;
 }
+
+int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
+{
+	return gnttab_interface._gnttab_end_foreign_access_ref(ref, readonly);
+}
 EXPORT_SYMBOL_GPL(gnttab_end_foreign_access_ref);
 
 void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
@@ -250,33 +331,41 @@ void gnttab_grant_foreign_transfer_ref(grant_ref_t ref, domid_t domid,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_transfer_ref);
 
-unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref)
+unsigned long gnttab_end_foreign_transfer_ref_v1(grant_ref_t ref)
 {
 	unsigned long frame;
 	u16           flags;
+	u16          *pflags;
+
+	pflags = &shared.v1[ref].flags;
 
 	/*
 	 * If a transfer is not even yet started, try to reclaim the grant
 	 * reference and return failure (== 0).
 	 */
-	while (!((flags = shared[ref].flags) & GTF_transfer_committed)) {
-		if (sync_cmpxchg(&shared[ref].flags, flags, 0) == flags)
+	while (!((flags = *pflags) & GTF_transfer_committed)) {
+		if (sync_cmpxchg(pflags, flags, 0) == flags)
 			return 0;
 		cpu_relax();
 	}
 
 	/* If a transfer is in progress then wait until it is completed. */
 	while (!(flags & GTF_transfer_completed)) {
-		flags = shared[ref].flags;
+		flags = *pflags;
 		cpu_relax();
 	}
 
 	rmb();	/* Read the frame number /after/ reading completion status. */
-	frame = shared[ref].frame;
+	frame = shared.v1[ref].frame;
 	BUG_ON(frame == 0);
 
 	return frame;
 }
+
+unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref)
+{
+	return gnttab_interface._gnttab_end_foreign_transfer_ref(ref);
+}
 EXPORT_SYMBOL_GPL(gnttab_end_foreign_transfer_ref);
 
 unsigned long gnttab_end_foreign_transfer(grant_ref_t ref)
@@ -520,6 +609,32 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 }
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
 
+static void gnttab_request_version(void)
+{
+	grant_table_version = 1;
+	gnttab_interface._gnttab_map_status = gnttab_map_status_v1;
+	gnttab_interface._gnttab_unmap_status = gnttab_unmap_status_v1;
+	gnttab_interface._update_grant_entry = update_grant_entry_v1;
+	gnttab_interface._gnttab_end_foreign_access_ref =
+					gnttab_end_foreign_access_ref_v1;
+	gnttab_interface._gnttab_end_foreign_transfer_ref =
+					gnttab_end_foreign_transfer_ref_v1;
+	gnttab_interface._gnttab_query_foreign_access =
+					gnttab_query_foreign_access_v1;
+	printk(KERN_INFO "Grant tables using version %d layout.\n",
+		grant_table_version);
+}
+
+static int gnttab_map_status_v1(unsigned int nr_gframes)
+{
+	return 0;
+}
+
+static int gnttab_map_status(unsigned int nr_gframes)
+{
+	return gnttab_interface._gnttab_map_status(nr_gframes);
+}
+
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
@@ -567,8 +682,14 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 	BUG_ON(rc || setup.status);
 
+	rc = gnttab_map_status(nr_gframes);
+	if (rc < 0) {
+		kfree(frames);
+		return rc;
+	}
+
 	rc = arch_gnttab_map_shared(frames, nr_gframes, gnttab_max_grant_frames(),
-				    &shared);
+				    &shared.ring_addr);
 	BUG_ON(rc);
 
 	kfree(frames);
@@ -580,6 +701,7 @@ int gnttab_resume(void)
 {
 	unsigned int max_nr_gframes;
 
+	gnttab_request_version();
 	max_nr_gframes = gnttab_max_grant_frames();
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
@@ -587,9 +709,10 @@ int gnttab_resume(void)
 	if (xen_pv_domain())
 		return gnttab_map(0, nr_grant_frames - 1);
 
-	if (!shared) {
-		shared = ioremap(xen_hvm_resume_frames, PAGE_SIZE * max_nr_gframes);
-		if (shared == NULL) {
+	if (!shared.ring_addr) {
+		shared.ring_addr = ioremap(xen_hvm_resume_frames,
+						PAGE_SIZE * max_nr_gframes);
+		if (shared.ring_addr == NULL) {
 			printk(KERN_WARNING
 					"Failed to ioremap gnttab share frames!");
 			return -ENOMEM;
@@ -601,9 +724,19 @@ int gnttab_resume(void)
 	return 0;
 }
 
+static void gnttab_unmap_status_v1(void)
+{
+}
+
+void gnttab_unmap_status(void)
+{
+	return gnttab_interface._gnttab_unmap_status();
+}
+
 int gnttab_suspend(void)
 {
-	arch_gnttab_unmap_shared(shared, nr_grant_frames);
+	arch_gnttab_unmap_shared(shared.ring_addr, nr_grant_frames);
+	gnttab_interface._gnttab_unmap_status();
 	return 0;
 }
 
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index b1fab6b..405879d 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -146,8 +146,8 @@ gnttab_set_unmap_op(struct gnttab_unmap_grant_ref *unmap, phys_addr_t addr,
 
 int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
 			   unsigned long max_nr_gframes,
-			   struct grant_entry **__shared);
-void arch_gnttab_unmap_shared(struct grant_entry *shared,
+			   void **__shared);
+void arch_gnttab_unmap_shared(void *shared,
 			      unsigned long nr_gframes);
 
 extern unsigned long xen_hvm_resume_frames;
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index 39e5717..a17d844 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -85,12 +85,22 @@
  */
 
 /*
+ * Reference to a grant entry in a specified domain's grant table.
+ */
+typedef uint32_t grant_ref_t;
+
+/*
  * A grant table comprises a packed array of grant entries in one or more
  * page frames shared between Xen and a guest.
  * [XEN]: This field is written by Xen and read by the sharing guest.
  * [GST]: This field is written by the guest and read by Xen.
  */
-struct grant_entry {
+
+/*
+ * Version 1 of the grant table entry structure is maintained purely
+ * for backwards compatibility.  New guests should use version 2.
+ */
+struct grant_entry_v1 {
     /* GTF_xxx: various type and flag information.  [XEN,GST] */
     uint16_t flags;
     /* The domain being granted foreign privileges. [GST] */
@@ -108,10 +118,13 @@ struct grant_entry {
  *  GTF_permit_access: Allow @domid to map/access @frame.
  *  GTF_accept_transfer: Allow @domid to transfer ownership of one page frame
  *                       to this guest. Xen writes the page number to @frame.
+ *  GTF_transitive: Allow @domid to transitively access a subrange of
+ *                  @trans_grant in @trans_domid.  No mappings are allowed.
  */
 #define GTF_invalid         (0U<<0)
 #define GTF_permit_access   (1U<<0)
 #define GTF_accept_transfer (2U<<0)
+#define GTF_transitive      (3U<<0)
 #define GTF_type_mask       (3U<<0)
 
 /*
@@ -119,6 +132,9 @@ struct grant_entry {
  *  GTF_readonly: Restrict @domid to read-only mappings and accesses. [GST]
  *  GTF_reading: Grant entry is currently mapped for reading by @domid. [XEN]
  *  GTF_writing: Grant entry is currently mapped for writing by @domid. [XEN]
+ *  GTF_sub_page: Grant access to only a subrange of the page.  @domid
+ *                will only be allowed to copy from the grant, and not
+ *                map it. [GST]
  */
 #define _GTF_readonly       (2)
 #define GTF_readonly        (1U<<_GTF_readonly)
@@ -126,6 +142,8 @@ struct grant_entry {
 #define GTF_reading         (1U<<_GTF_reading)
 #define _GTF_writing        (4)
 #define GTF_writing         (1U<<_GTF_writing)
+#define _GTF_sub_page       (8)
+#define GTF_sub_page        (1U<<_GTF_sub_page)
 
 /*
  * Subflags for GTF_accept_transfer:
@@ -142,15 +160,81 @@ struct grant_entry {
 #define _GTF_transfer_completed (3)
 #define GTF_transfer_completed  (1U<<_GTF_transfer_completed)
 
+/*
+ * Version 2 grant table entries.  These fulfil the same role as
+ * version 1 entries, but can represent more complicated operations.
+ * Any given domain will have either a version 1 or a version 2 table,
+ * and every entry in the table will be the same version.
+ *
+ * The interface by which domains use grant references does not depend
+ * on the grant table version in use by the other domain.
+ */
 
-/***********************************
- * GRANT TABLE QUERIES AND USES
+/*
+ * Version 1 and version 2 grant entries share a common prefix.  The
+ * fields of the prefix are documented as part of struct
+ * grant_entry_v1.
  */
+struct grant_entry_header {
+    uint16_t flags;
+    domid_t  domid;
+};
 
 /*
- * Reference to a grant entry in a specified domain's grant table.
+ * Version 2 of the grant entry structure, here is an union because three
+ * different types are suppotted: full_page, sub_page and transitive.
+ */
+union grant_entry_v2 {
+    struct grant_entry_header hdr;
+
+    /*
+     * This member is used for V1-style full page grants, where either:
+     *
+     * -- hdr.type is GTF_accept_transfer, or
+     * -- hdr.type is GTF_permit_access and GTF_sub_page is not set.
+     *
+     * In that case, the frame field has the same semantics as the
+     * field of the same name in the V1 entry structure.
+     */
+    struct {
+	struct grant_entry_header hdr;
+	uint32_t pad0;
+	uint64_t frame;
+    } full_page;
+
+    /*
+     * If the grant type is GTF_grant_access and GTF_sub_page is set,
+     * @domid is allowed to access bytes [@page_off,@page_off+@length)
+     * in frame @frame.
+     */
+    struct {
+	struct grant_entry_header hdr;
+	uint16_t page_off;
+	uint16_t length;
+	uint64_t frame;
+    } sub_page;
+
+    /*
+     * If the grant is GTF_transitive, @domid is allowed to use the
+     * grant @gref in domain @trans_domid, as if it was the local
+     * domain.  Obviously, the transitive access must be compatible
+     * with the original grant.
+     */
+    struct {
+	struct grant_entry_header hdr;
+	domid_t trans_domid;
+	uint16_t pad0;
+	grant_ref_t gref;
+    } transitive;
+
+    uint32_t __spacer[4]; /* Pad to a power of two */
+};
+
+typedef uint16_t grant_status_t;
+
+/***********************************
+ * GRANT TABLE QUERIES AND USES
  */
-typedef uint32_t grant_ref_t;
 
 /*
  * Handle to track a mapping created via a grant reference.
@@ -322,6 +406,79 @@ struct gnttab_query_size {
 DEFINE_GUEST_HANDLE_STRUCT(gnttab_query_size);
 
 /*
+ * GNTTABOP_unmap_and_replace: Destroy one or more grant-reference mappings
+ * tracked by <handle> but atomically replace the page table entry with one
+ * pointing to the machine address under <new_addr>.  <new_addr> will be
+ * redirected to the null entry.
+ * NOTES:
+ *  1. The call may fail in an undefined manner if either mapping is not
+ *     tracked by <handle>.
+ *  2. After executing a batch of unmaps, it is guaranteed that no stale
+ *     mappings will remain in the device or host TLBs.
+ */
+#define GNTTABOP_unmap_and_replace    7
+struct gnttab_unmap_and_replace {
+    /* IN parameters. */
+    uint64_t host_addr;
+    uint64_t new_addr;
+    grant_handle_t handle;
+    /* OUT parameters. */
+    int16_t  status;              /* GNTST_* */
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_unmap_and_replace);
+
+/*
+ * GNTTABOP_set_version: Request a particular version of the grant
+ * table shared table structure.  This operation can only be performed
+ * once in any given domain.  It must be performed before any grants
+ * are activated; otherwise, the domain will be stuck with version 1.
+ * The only defined versions are 1 and 2.
+ */
+#define GNTTABOP_set_version          8
+struct gnttab_set_version {
+    /* IN parameters */
+    uint32_t version;
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_set_version);
+
+/*
+ * GNTTABOP_get_status_frames: Get the list of frames used to store grant
+ * status for <dom>. In grant format version 2, the status is separated
+ * from the other shared grant fields to allow more efficient synchronization
+ * using barriers instead of atomic cmpexch operations.
+ * <nr_frames> specify the size of vector <frame_list>.
+ * The frame addresses are returned in the <frame_list>.
+ * Only <nr_frames> addresses are returned, even if the table is larger.
+ * NOTES:
+ *  1. <dom> may be specified as DOMID_SELF.
+ *  2. Only a sufficiently-privileged domain may specify <dom> != DOMID_SELF.
+ */
+#define GNTTABOP_get_status_frames     9
+struct gnttab_get_status_frames {
+    /* IN parameters. */
+    uint32_t nr_frames;
+    domid_t  dom;
+    /* OUT parameters. */
+    int16_t  status;              /* GNTST_* */
+    GUEST_HANDLE(uint64_t) frame_list;
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_get_status_frames);
+
+/*
+ * GNTTABOP_get_version: Get the grant table version which is in
+ * effect for domain <dom>.
+ */
+#define GNTTABOP_get_version          10
+struct gnttab_get_version {
+    /* IN parameters */
+    domid_t dom;
+    uint16_t pad;
+    /* OUT parameters */
+    uint32_t version;
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_get_version);
+
+/*
  * Bitfield values for update_pin_status.flags.
  */
  /* Map the grant entry for access by I/O devices. */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 6acd9ce..9353bdf 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -522,6 +522,8 @@ struct tmem_op {
 	} u;
 };
 
+DEFINE_GUEST_HANDLE(uint64_t);
+
 #else /* __ASSEMBLY__ */
 
 /* In assembly code we cannot use C numeric constant suffixes. */
-- 
1.7.6

