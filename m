Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab2FUV6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:58:03 -0400
Received: from shelob.surriel.com ([74.92.59.67]:33292 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab2FUV6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:58:00 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH -mm v2 02/11] mm: rearrange vm_area_struct for fewer cache misses
Date: Thu, 21 Jun 2012 17:57:06 -0400
Message-Id: <1340315835-28571-3-git-send-email-riel@surriel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340315835-28571-1-git-send-email-riel@surriel.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel walks the VMA rbtree in various places, including
the page fault path.  However, the vm_rb node spanned two
cache lines, on 64 bit systems with 64 byte cache lines (most
x86 systems).

Rearrange vm_area_struct a little, so all the information we
need to do a VMA tree walk is in the first cache line.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/mm_types.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9fc0291..23bd1e2 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -199,7 +199,8 @@ struct vm_region {
  * library, the executable area etc).
  */
 struct vm_area_struct {
-	struct mm_struct * vm_mm;	/* The address space we belong to. */
+	/* The first cache line has the info for VMA tree walking. */
+
 	unsigned long vm_start;		/* Our start address within vm_mm. */
 	unsigned long vm_end;		/* The first byte after our end address
 					   within vm_mm. */
@@ -207,9 +208,6 @@ struct vm_area_struct {
 	/* linked list of VM areas per task, sorted by address */
 	struct vm_area_struct *vm_next, *vm_prev;
 
-	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long vm_flags;		/* Flags, see mm.h. */
-
 	struct rb_node vm_rb;
 
 	/*
@@ -220,6 +218,12 @@ struct vm_area_struct {
 	 */
 	unsigned long free_gap;
 
+	/* Second cache line starts here. */
+
+	struct mm_struct * vm_mm;	/* The address space we belong to. */
+	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
+	unsigned long vm_flags;		/* Flags, see mm.h. */
+
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap prio tree, or
-- 
1.7.7.6

