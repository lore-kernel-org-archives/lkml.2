Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab2CAIaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:30:14 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:52655 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab2CAIaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:30:12 -0500
Date: Thu, 1 Mar 2012 09:30:04 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.3-rc5
Message-ID: <20120301093004.4756e8bd@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12030108-1948-0000-0000-00000111FEBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Danny Kukawka (1):
      [S390] crash_dump: remove duplicate include

David Howells (1):
      [S390] KEYS: Enable the compat keyctl wrapper on s390x

Gerald Schaefer (1):
      [S390] memory hotplug: prevent memory zone interleave

 arch/s390/Kconfig             |    3 +++
 arch/s390/kernel/crash_dump.c |    1 -
 arch/s390/mm/init.c           |   30 ++++++++++++++++++++++++++----
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d172758..6d99a5f 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -227,6 +227,9 @@ config COMPAT
 config SYSVIPC_COMPAT
 	def_bool y if COMPAT && SYSVIPC
 
+config KEYS_COMPAT
+	def_bool y if COMPAT && KEYS
+
 config AUDIT_ARCH
 	def_bool y
 
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 39f8fd4..c383ce4 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/slab.h>
-#include <linux/crash_dump.h>
 #include <linux/bootmem.h>
 #include <linux/elf.h>
 #include <asm/ipl.h>
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 5d63301..5023661 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -223,16 +223,38 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size)
 {
-	struct pglist_data *pgdat;
+	unsigned long zone_start_pfn, zone_end_pfn, nr_pages;
+	unsigned long start_pfn = PFN_DOWN(start);
+	unsigned long size_pages = PFN_DOWN(size);
 	struct zone *zone;
 	int rc;
 
-	pgdat = NODE_DATA(nid);
-	zone = pgdat->node_zones + ZONE_MOVABLE;
 	rc = vmem_add_mapping(start, size);
 	if (rc)
 		return rc;
-	rc = __add_pages(nid, zone, PFN_DOWN(start), PFN_DOWN(size));
+	for_each_zone(zone) {
+		if (zone_idx(zone) != ZONE_MOVABLE) {
+			/* Add range within existing zone limits */
+			zone_start_pfn = zone->zone_start_pfn;
+			zone_end_pfn = zone->zone_start_pfn +
+				       zone->spanned_pages;
+		} else {
+			/* Add remaining range to ZONE_MOVABLE */
+			zone_start_pfn = start_pfn;
+			zone_end_pfn = start_pfn + size_pages;
+		}
+		if (start_pfn < zone_start_pfn || start_pfn >= zone_end_pfn)
+			continue;
+		nr_pages = (start_pfn + size_pages > zone_end_pfn) ?
+			   zone_end_pfn - start_pfn : size_pages;
+		rc = __add_pages(nid, zone, start_pfn, nr_pages);
+		if (rc)
+			break;
+		start_pfn += nr_pages;
+		size_pages -= nr_pages;
+		if (!size_pages)
+			break;
+	}
 	if (rc)
 		vmem_remove_mapping(start, size);
 	return rc;

