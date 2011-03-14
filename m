Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1CNReG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:34:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36079 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1CNReE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oaXs5+NjO7IrTLNG0TOG+XdC+Xzk9xjY5JXpjcH8BU3gLqrXosVzc6LmOBxmJ5EmeX
         u2UEwaiQOQ8Rthmf7JRCYJFuLSnIWdJEV9cnU3YggygHpPa/VnDviupNGYjIeaAXiCHo
         fXgUbGu8IHzBBIyzjJHkwxuVNfBbAte4Xzdqc=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 17:34:03 +0000
Message-ID: <AANLkTimp6xeoCJYh-xXqKv9qytYU3dMK8MjUQ90-am0W@mail.gmail.com>
Subject: [RFC][PATCH v2 04/23] (cris) __vmalloc: add gfp flags variant of pte
 and pmd allocation
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: Prasad Joshi <prasadjoshi124@gmail.com>,
        Anand Mitra <mitra@kqinfotech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__vmalloc: propagating GFP allocation flag.

- adds functions to allow caller to pass the GFP flag for memory allocation
- helps in fixing the Bug 30702 (__vmalloc(GFP_NOFS) can callback
		  file system evict_inode).

Signed-off-by: Anand Mitra <mitra@kqinfotech.com>
Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
---
Chnagelog:
arch/cris/include/asm/pgalloc.h |   10 ++++++++--
1 files changed, 8 insertions(+), 2 deletions(-)
---
diff --git a/arch/cris/include/asm/pgalloc.h b/arch/cris/include/asm/pgalloc.h
index 6da975d..20254ee 100644
--- a/arch/cris/include/asm/pgalloc.h
+++ b/arch/cris/include/asm/pgalloc.h
@@ -22,10 +22,16 @@ static inline void pgd_free(struct mm_struct *mm,
pgd_t *pgd)
 	free_page((unsigned long)pgd);
 }

+static inline pte_t *
+__pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address,
+	gfp_t gfp_mask)
+{
+  	return (pte_t *) __get_free_page(gfp_mask | __GFP_ZERO);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
unsigned long address)
 {
-  	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
- 	return pte;
+	return __pte_alloc_one_kernel(mm, address, GFP_KERNEL | __GFP_REPEAT);
 }

 static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned
long address)
