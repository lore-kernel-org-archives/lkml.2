Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0I3DwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:52:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0I3Duh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uWsEsMjNxtDLNi6jmnqHG47vbA5t0aIJRPCE7GYAMOZqVwLgT8vzQjxM6sXrbe4pj6
         iQ+WtgkMfj1htnGOp7KgLOgkYAaYzo/4Id7wBDLLjmWIC2uLBAUYsvg4WXcz1JJoeHUl
         2Ds5D93q2UtWzOEeXiDOCRS/+7kzhNOgzRc08=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] mm: wrap get_locked_pte() using __cond_lock()
Date: Thu, 30 Sep 2010 12:50:12 +0900
Message-Id: <1285818621-29890-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_locked_pte() conditionally grabs 'ptl' in case of returning
non-NULL. This leads sparse to complain about context imbalance.
Rename and wrap it using __cond_lock() to make sparse happy.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/mm.h |   10 +++++++++-
 mm/memory.c        |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 74949fb..e48616d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1023,7 +1023,15 @@ extern void unregister_shrinker(struct shrinker *);
 
 int vma_wants_writenotify(struct vm_area_struct *vma);
 
-extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);
+extern pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
+			       spinlock_t **ptl);
+static inline pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+				    spinlock_t **ptl)
+{
+	pte_t *ptep;
+	__cond_lock(*ptl, ptep = __get_locked_pte(mm, addr, ptl));
+	return ptep;
+}
 
 #ifdef __PAGETABLE_PUD_FOLDED
 static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
diff --git a/mm/memory.c b/mm/memory.c
index 0e18b4d..219b50a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1590,7 +1590,7 @@ struct page *get_dump_page(unsigned long addr)
 }
 #endif /* CONFIG_ELF_CORE */
 
-pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			spinlock_t **ptl)
 {
 	pgd_t * pgd = pgd_offset(mm, addr);
-- 
1.7.2.2

