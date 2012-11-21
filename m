Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2KUIQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:16:04 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:47935 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2KUIQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:16:01 -0500
Date: Wed, 21 Nov 2012 17:02:47 +0900
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH] Add the values related to buddy system for filtering free
 pages
Message-Id: <20121121170247.6b57465f2fc1d7f91cd1cddf@mxc.nes.nec.co.jp>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the values related to buddy system to vmcoreinfo data
so that makedumpfile (dump filtering command) can filter out all free
pages with the new logic.
It's faster than the current logic because it can distinguish free page
by analyzing page structure at the same time as filtering for other
unnecessary pages (e.g. anonymous page).
OTOH, the current logic has to trace free_list to distinguish free 
pages while analyzing page structure to filter out other unnecessary
pages.

The new logic uses the fact that buddy page is marked by _mapcount == 
PAGE_BUDDY_MAPCOUNT_VALUE. The values below are required to distinguish
it.

Required values:
  - OFFSET(page._mapcount)
  - OFFSET(page.private)
  - SIZE(pageflags)
  - NUMBER(PG_slab)
  - NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE)
  
What's makedumpfile:
  makedumpfile creates a small dumpfile by excluding unnecessary pages
  for the analysis. To distinguish unnecessary pages, makedumpfile gets
  the vmcoreinfo data which has the minimum debugging information only
  for dump filtering.

Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
---
 include/linux/kexec.h | 3 +++
 kernel/kexec.c        | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d0b8458..a90b148 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -158,6 +158,9 @@ unsigned long paddr_vmcoreinfo_note(void);
 #define VMCOREINFO_STRUCT_SIZE(name) \
        vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
                              (unsigned long)sizeof(struct name))
+#define VMCOREINFO_ENUM_SIZE(name) \
+       vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+                             (unsigned long)sizeof(enum name))
 #define VMCOREINFO_OFFSET(name, field) \
        vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
                              (unsigned long)offsetof(struct name, field))
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..511151b 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1485,10 +1485,13 @@ static int __init crash_save_vmcoreinfo_init(void)
        VMCOREINFO_STRUCT_SIZE(zone);
        VMCOREINFO_STRUCT_SIZE(free_area);
        VMCOREINFO_STRUCT_SIZE(list_head);
+       VMCOREINFO_ENUM_SIZE(pageflags);
        VMCOREINFO_SIZE(nodemask_t);
        VMCOREINFO_OFFSET(page, flags);
        VMCOREINFO_OFFSET(page, _count);
        VMCOREINFO_OFFSET(page, mapping);
+       VMCOREINFO_OFFSET(page, _mapcount);
+       VMCOREINFO_OFFSET(page, private);
        VMCOREINFO_OFFSET(page, lru);
        VMCOREINFO_OFFSET(pglist_data, node_zones);
        VMCOREINFO_OFFSET(pglist_data, nr_zones);
@@ -1512,6 +1515,8 @@ static int __init crash_save_vmcoreinfo_init(void)
        VMCOREINFO_NUMBER(PG_lru);
        VMCOREINFO_NUMBER(PG_private);
        VMCOREINFO_NUMBER(PG_swapcache);
+       VMCOREINFO_NUMBER(PG_slab);
+       VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);

        arch_crash_save_vmcoreinfo();
        update_vmcoreinfo_note();
--
1.7.11
