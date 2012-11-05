Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab2KEWwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:52:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40367 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2KEWri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:47:38 -0500
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        William Irwin <wli@holomorphy.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, Rik van Riel <riel@surriel.com>
Subject: [PATCH 04/16] mm: rearrange vm_area_struct for fewer cache misses
Date: Mon,  5 Nov 2012 14:47:01 -0800
Message-Id: <1352155633-8648-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1352155633-8648-1-git-send-email-walken@google.com>
References: <1352155633-8648-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

The kernel walks the VMA rbtree in various places, including
the page fault path.  However, the vm_rb node spanned two
cache lines, on 64 bit systems with 64 byte cache lines (most
x86 systems).

Rearrange vm_area_struct a little, so all the information we
need to do a VMA tree walk is in the first cache line.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
 include/linux/mm_types.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 94fa52b28ee8..528da4abf8ee 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -224,7 +224,8 @@ struct vm_region {
  * library, the executable area etc).
  */
 struct vm_area_struct {
-	struct mm_struct * vm_mm;	/* The address space we belong to. */
+	/* The first cache line has the info for VMA tree walking. */
+
 	unsigned long vm_start;		/* Our start address within vm_mm. */
 	unsigned long vm_end;		/* The first byte after our end address
 					   within vm_mm. */
@@ -232,9 +233,6 @@ struct vm_area_struct {
 	/* linked list of VM areas per task, sorted by address */
 	struct vm_area_struct *vm_next, *vm_prev;
 
-	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
-	unsigned long vm_flags;		/* Flags, see mm.h. */
-
 	struct rb_node vm_rb;
 
 	/*
@@ -245,6 +243,12 @@ struct vm_area_struct {
 	 */
 	unsigned long rb_subtree_gap;
 
+	/* Second cache line starts here. */
+
+	struct mm_struct * vm_mm;	/* The address space we belong to. */
+	pgprot_t vm_page_prot;		/* Access permissions of this VMA. */
+	unsigned long vm_flags;		/* Flags, see mm.h. */
+
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree, or
-- 
1.7.7.3
