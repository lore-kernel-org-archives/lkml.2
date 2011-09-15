Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643Ab1IOMlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:41:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27875 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622Ab1IOMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:59 -0400
X-IronPort-AV: E=Sophos;i="4.68,387,1312171200"; 
   d="scan'208";a="163268221"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 6/6] mm: remove vmalloc_sync_all() from alloc_vm_area()
Date: Thu, 15 Sep 2011 13:40:11 +0100
Message-ID: <1316090411-22608-7-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

The address space allocated by the remaining user of alloc_vm_area()
is not accessed during a hypercall.  Therefore, the normal mechanism
of populating the vmalloc page tables during a fault works so the
vmalloc_sync_all() is not required and it can be removed.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/vmalloc.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5016f19..b0b4550 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2117,9 +2117,7 @@ static int f(pte_t *pte, pgtable_t table, unsigned long addr, void *data)
  *
  *	This function reserves a range of kernel address space, and
  *	allocates pagetables to map that range.  No actual mappings
- *	are created.  If the kernel address space is not shared
- *	between processes, it syncs the pagetable across all
- *	processes.
+ *	are created.
  */
 struct vm_struct *alloc_vm_area(size_t size)
 {
@@ -2140,14 +2138,6 @@ struct vm_struct *alloc_vm_area(size_t size)
 		return NULL;
 	}
 
-	/*
-	 * If the allocated address space is passed to a hypercall
-	 * before being used then we cannot rely on a page fault to
-	 * trigger an update of the page tables.  So sync all the page
-	 * tables here.
-	 */
-	vmalloc_sync_all();
-
 	return area;
 }
 EXPORT_SYMBOL_GPL(alloc_vm_area);
-- 
1.7.2.5

