Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2ENU0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:26:36 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:39320 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab2ENU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:26:35 -0400
Subject: [PATCH] mm, x86, pat: Improve scaling of pat_pagerange_is_ram()
From: John Dykstra <jdykstra@cray.com>
To: <mingo@redhat.com>
CC: <suresh.b.siddha@intel.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 May 2012 15:26:32 -0500
Message-ID: <1337027192.1604.9.camel@redwood>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pat_pagerange_is_ram() scales poorly to large address ranges,
because it probes the resource tree for each page.  On a 2.6 GHz
Opteron, this function consumes 34 ms. for a 1 GB range.  It is called
twice during untrack_pfn_vma(), slowing process cleanup and handicapping
the OOM killer.

This replacement based on walk_system_ram_range() consumes less than 1
ms. under the same conditions.

Signed-off-by: John Dykstra <jdykstra@cray.com> on behalf of Cray Inc. 
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c      |   55 ++++++++++++++++++++++++++++++-----------------
 include/linux/ioport.h |    2 +
 kernel/resource.c      |    2 +-
 3 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f6ff57b..c119afb 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -160,29 +160,44 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 
 static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 {
-	int ram_page = 0, not_rampage = 0;
-	unsigned long page_nr;
+	struct resource res;
+	resource_size_t pg_end, after_ram;
+	int ram = 0, not_ram = 0;
 
-	for (page_nr = (start >> PAGE_SHIFT); page_nr < (end >> PAGE_SHIFT);
-	     ++page_nr) {
-		/*
-		 * For legacy reasons, physical address range in the legacy ISA
-		 * region is tracked as non-RAM. This will allow users of
-		 * /dev/mem to map portions of legacy ISA region, even when
-		 * some of those portions are listed(or not even listed) with
-		 * different e820 types(RAM/reserved/..)
-		 */
-		if (page_nr >= (ISA_END_ADDRESS >> PAGE_SHIFT) &&
-		    page_is_ram(page_nr))
-			ram_page = 1;
-		else
-			not_rampage = 1;
+	res.start = start & PHYSICAL_PAGE_MASK;
 
-		if (ram_page == not_rampage)
+	/*
+	 * For legacy reasons, physical address range in the legacy ISA
+	 * region is tracked as non-RAM. This will allow users of
+	 * /dev/mem to map portions of legacy ISA region, even when
+	 * some of those portions are listed(or not even listed) with
+	 * different e820 types(RAM/reserved/..)
+	 */
+	if (res.start < ISA_END_ADDRESS) {
+		not_ram = 1;
+		res.start = ISA_END_ADDRESS;
+	}
+
+	pg_end = (end + PAGE_SIZE - 1) & PHYSICAL_PAGE_MASK;
+	res.end = pg_end;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	after_ram = res.start;
+	while ((res.start < res.end) &&
+		(find_next_system_ram(&res, "System RAM") >= 0)) {
+		if (res.start > after_ram)
+			not_ram = 1;
+		if (res.end > res.start)
+			ram = 1;
+
+		if (ram && not_ram)
 			return -1;
+
+		after_ram = res.end + 1;
+		res.start = res.end + 1;
+		res.end = pg_end;
 	}
 
-	return ram_page;
+	return ram;
 }
 
 /*
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index e885ba2..273a725 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -223,5 +223,7 @@ extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 
+extern int find_next_system_ram(struct resource *res, char *name);
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 7e8ea66..dd8f553 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -283,7 +283,7 @@ EXPORT_SYMBOL(release_resource);
  * the caller must specify res->start, res->end, res->flags and "name".
  * If found, returns 0, res is overwritten, if not found, returns -1.
  */
-static int find_next_system_ram(struct resource *res, char *name)
+int find_next_system_ram(struct resource *res, char *name)
 {
 	resource_size_t start, end;
 	struct resource *p;
-- 
1.7.0.4





