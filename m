Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3AFLSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:18:11 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11371 "EHLO
	smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3AFLSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:18:08 -0500
X-IronPort-AV: E=Sophos;i="4.84,419,1355097600"; 
   d="scan'208";a="1098007638"
From: Matt Wilson <msw@amazon.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <stable@vger.kernel.org>, Matt Wilson <msw@amazon.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, Annie Li <annie.li@oracle.com>,
        <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] xen/grant-table: correctly initialize grant table version 1
Date: Sun, 6 Jan 2013 11:14:42 +0000
Message-ID: <1357470882-17345-1-git-send-email-msw@amazon.com>
X-Mailer: git-send-email 1.7.4.5
In-Reply-To: <Message-ID: <1355997710.26722.12.camel@zakaz.uk.xensource.com>
References: <Message-ID: <1355997710.26722.12.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85ff6acb075a484780b3d763fdf41596d8fc0970 (xen/granttable: Grant
tables V2 implementation) changed the GREFS_PER_GRANT_FRAME macro from
a constant to a conditional expression. The expression depends on
grant_table_version being appropriately set. Unfortunately, at init
time grant_table_version will be 0. The GREFS_PER_GRANT_FRAME
conditional expression checks for "grant_table_version == 1", and
therefore returns the number of grant references per frame for v2.

This causes gnttab_init() to allocate fewer pages for gnttab_list, as
a frame can old half the number of v2 entries than v1 entries. After
gnttab_resume() is called, grant_table_version is appropriately
set. nr_init_grefs will then be miscalculated and gnttab_free_count
will hold a value larger than the actual number of free gref entries.

If a guest is heavily utilizing improperly initialized v1 grant
tables, memory corruption can occur. One common manifestation is
corruption of the vmalloc list, resulting in a poisoned pointer
derefrence when accessing /proc/meminfo or /proc/vmallocinfo:

[   40.770064] BUG: unable to handle kernel paging request at 0000200200001407
[   40.770083] IP: [<ffffffff811a6fb0>] get_vmalloc_info+0x70/0x110
[   40.770102] PGD 0
[   40.770107] Oops: 0000 [#1] SMP
[   40.770114] CPU 10

This patch introduces a static variable, grefs_per_grant_frame, to
cache the calculated value. gnttab_init() now calls
gnttab_request_version() early so that grant_table_version and
grefs_per_grant_frame can be appropriately set. A few BUG_ON()s have
been added to prevent this type of bug from reoccurring in the future.

Signed-off-by: Matt Wilson <msw@amazon.com>
Reviewed-and-Tested-by: Steven Noonan <snoonan@amazon.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Annie Li <annie.li@oracle.com>
Cc: xen-devel@lists.xen.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # v3.3 and newer
---
Changes since v1:
* introduced a new gnttab_setup() function and moved all of the
  initialization code from gnttab_resume() there.
---
 drivers/xen/grant-table.c |   52 ++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 043bf07..53715de 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -55,10 +55,6 @@
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
 #define GNTTAB_LIST_END 0xffffffff
-#define GREFS_PER_GRANT_FRAME \
-(grant_table_version == 1 ?                      \
-(PAGE_SIZE / sizeof(struct grant_entry_v1)) :   \
-(PAGE_SIZE / sizeof(union grant_entry_v2)))
 
 static grant_ref_t **gnttab_list;
 static unsigned int nr_grant_frames;
@@ -153,6 +149,7 @@ static struct gnttab_ops *gnttab_interface;
 static grant_status_t *grstatus;
 
 static int grant_table_version;
+static int grefs_per_grant_frame;
 
 static struct gnttab_free_callback *gnttab_free_callback_list;
 
@@ -766,12 +763,14 @@ static int grow_gnttab_list(unsigned int more_frames)
 	unsigned int new_nr_grant_frames, extra_entries, i;
 	unsigned int nr_glist_frames, new_nr_glist_frames;
 
+	BUG_ON(grefs_per_grant_frame == 0);
+
 	new_nr_grant_frames = nr_grant_frames + more_frames;
-	extra_entries       = more_frames * GREFS_PER_GRANT_FRAME;
+	extra_entries       = more_frames * grefs_per_grant_frame;
 
-	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	nr_glist_frames = (nr_grant_frames * grefs_per_grant_frame + RPP - 1) / RPP;
 	new_nr_glist_frames =
-		(new_nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+		(new_nr_grant_frames * grefs_per_grant_frame + RPP - 1) / RPP;
 	for (i = nr_glist_frames; i < new_nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_ATOMIC);
 		if (!gnttab_list[i])
@@ -779,12 +778,12 @@ static int grow_gnttab_list(unsigned int more_frames)
 	}
 
 
-	for (i = GREFS_PER_GRANT_FRAME * nr_grant_frames;
-	     i < GREFS_PER_GRANT_FRAME * new_nr_grant_frames - 1; i++)
+	for (i = grefs_per_grant_frame * nr_grant_frames;
+	     i < grefs_per_grant_frame * new_nr_grant_frames - 1; i++)
 		gnttab_entry(i) = i + 1;
 
 	gnttab_entry(i) = gnttab_free_head;
-	gnttab_free_head = GREFS_PER_GRANT_FRAME * nr_grant_frames;
+	gnttab_free_head = grefs_per_grant_frame * nr_grant_frames;
 	gnttab_free_count += extra_entries;
 
 	nr_grant_frames = new_nr_grant_frames;
@@ -904,7 +903,8 @@ EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
 
 static unsigned nr_status_frames(unsigned nr_grant_frames)
 {
-	return (nr_grant_frames * GREFS_PER_GRANT_FRAME + SPP - 1) / SPP;
+	BUG_ON(grefs_per_grant_frame == 0);
+	return (nr_grant_frames * grefs_per_grant_frame + SPP - 1) / SPP;
 }
 
 static int gnttab_map_frames_v1(xen_pfn_t *frames, unsigned int nr_gframes)
@@ -1068,6 +1068,7 @@ static void gnttab_request_version(void)
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
 	if (rc == 0 && gsv.version == 2) {
 		grant_table_version = 2;
+		grefs_per_grant_frame = PAGE_SIZE / sizeof(union grant_entry_v2);
 		gnttab_interface = &gnttab_v2_ops;
 	} else if (grant_table_version == 2) {
 		/*
@@ -1080,18 +1081,18 @@ static void gnttab_request_version(void)
 		panic("we need grant tables version 2, but only version 1 is available");
 	} else {
 		grant_table_version = 1;
+		grefs_per_grant_frame = PAGE_SIZE / sizeof(struct grant_entry_v1);
 		gnttab_interface = &gnttab_v1_ops;
 	}
-	printk(KERN_INFO "Grant tables using version %d layout.\n",
-		grant_table_version);
 }
 
-int gnttab_resume(void)
+static int gnttab_setup(void)
 {
 	unsigned int max_nr_gframes;
 	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
 
-	gnttab_request_version();
+	printk(KERN_INFO "Grant tables using version %d layout.\n",
+		grant_table_version);
 	max_nr_gframes = gnttab_max_grant_frames();
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
@@ -1126,6 +1127,12 @@ int gnttab_resume(void)
 	return 0;
 }
 
+int gnttab_resume(void)
+{
+	gnttab_request_version();
+	return gnttab_setup();
+}
+
 int gnttab_suspend(void)
 {
 	gnttab_interface->unmap_frames();
@@ -1137,9 +1144,10 @@ static int gnttab_expand(unsigned int req_entries)
 	int rc;
 	unsigned int cur, extra;
 
+	BUG_ON(grefs_per_grant_frame == 0);
 	cur = nr_grant_frames;
-	extra = ((req_entries + (GREFS_PER_GRANT_FRAME-1)) /
-		 GREFS_PER_GRANT_FRAME);
+	extra = ((req_entries + (grefs_per_grant_frame-1)) /
+		 grefs_per_grant_frame);
 	if (cur + extra > gnttab_max_grant_frames())
 		return -ENOSPC;
 
@@ -1157,21 +1165,23 @@ int gnttab_init(void)
 	unsigned int nr_init_grefs;
 	int ret;
 
+	gnttab_request_version();
 	nr_grant_frames = 1;
 	boot_max_nr_grant_frames = __max_nr_grant_frames();
 
 	/* Determine the maximum number of frames required for the
 	 * grant reference free list on the current hypervisor.
 	 */
+	BUG_ON(grefs_per_grant_frame == 0);
 	max_nr_glist_frames = (boot_max_nr_grant_frames *
-			       GREFS_PER_GRANT_FRAME / RPP);
+			       grefs_per_grant_frame / RPP);
 
 	gnttab_list = kmalloc(max_nr_glist_frames * sizeof(grant_ref_t *),
 			      GFP_KERNEL);
 	if (gnttab_list == NULL)
 		return -ENOMEM;
 
-	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	nr_glist_frames = (nr_grant_frames * grefs_per_grant_frame + RPP - 1) / RPP;
 	for (i = 0; i < nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_KERNEL);
 		if (gnttab_list[i] == NULL) {
@@ -1180,12 +1190,12 @@ int gnttab_init(void)
 		}
 	}
 
-	if (gnttab_resume() < 0) {
+	if (gnttab_setup() < 0) {
 		ret = -ENODEV;
 		goto ini_nomem;
 	}
 
-	nr_init_grefs = nr_grant_frames * GREFS_PER_GRANT_FRAME;
+	nr_init_grefs = nr_grant_frames * grefs_per_grant_frame;
 
 	for (i = NR_RESERVED_ENTRIES; i < nr_init_grefs - 1; i++)
 		gnttab_entry(i) = i + 1;
-- 
1.7.4.5

