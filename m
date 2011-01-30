Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1A3DQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 22:16:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:22257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab1A3DP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 22:15:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,398,1291622400"; 
   d="scan'208";a="597720043"
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
        Tony Luck <tony.luck@intel.com>, Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2 2/3] mm, Make __get_user_pages return -EHWPOISON for HWPOISON page optionally
Date: Sun, 30 Jan 2011 11:15:48 +0800
Message-Id: <1296357349-18022-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
References: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make __get_user_pages return -EHWPOISON for HWPOISON page only if
FOLL_HWPOISON is specified.  With this patch, the interested callers
can distinguish HWPOISON pages from general FAULT pages, while other
callers will still get -EFAULT for all these pages, so the user space
interface need not to be changed.

This feature is needed by KVM, where UCR MCE should be relayed to
guest for HWPOISON page, while instruction emulation and MMIO will be
tried for general FAULT page.

The idea comes from Andrew Morton.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/errno.h |    2 ++
 include/linux/mm.h          |    1 +
 mm/memory.c                 |   13 ++++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -108,4 +108,6 @@
 
 #define ERFKILL		132	/* Operation not possible due to RF-kill */
 
+#define EHWPOISON	133	/* Memory page has hardware error */
+
 #endif
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1534,6 +1534,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
+#define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1576,9 +1576,16 @@ int __get_user_pages(struct task_struct
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
 						return i ? i : -ENOMEM;
-					if (ret &
-					    (VM_FAULT_HWPOISON|VM_FAULT_HWPOISON_LARGE|
-					     VM_FAULT_SIGBUS))
+					if (ret & (VM_FAULT_HWPOISON |
+						   VM_FAULT_HWPOISON_LARGE)) {
+						if (i)
+							return i;
+						else if (gup_flags & FOLL_HWPOISON)
+							return -EHWPOISON;
+						else
+							return -EFAULT;
+					}
+					if (ret & VM_FAULT_SIGBUS)
 						return i ? i : -EFAULT;
 					BUG();
 				}
