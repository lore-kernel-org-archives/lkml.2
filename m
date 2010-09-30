Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0I3Duo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0I3Dum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eM/pBhuGwiTuVvJ6XJX6Lzj6IxqK6gdedT4rhN+LeQLuMDrYjsjz6VJaKLTpCClZZb
         1AAaqWukhtdLUE5isK5zGY8xvo5MU/ZtxR0ctIM8JoWknJrF7tlWETGUiLx5jAIj5c1K
         2frLno4/+BW8rPztUVTbcd7mpmfpOexHnlMNE=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] mm: wrap follow_pte() using __cond_lock()
Date: Thu, 30 Sep 2010 12:50:14 +0900
Message-Id: <1285818621-29890-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follow_pte() conditionally grabs *@ptlp in case of returning 0.
Rename and wrap it using __cond_lock() removes following warnings:

 mm/memory.c:2337:9: warning: context imbalance in 'do_wp_page' - unexpected unlock
 mm/memory.c:3142:19: warning: context imbalance in 'handle_mm_fault' - different lock contexts for basic block

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/memory.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 76fa60e..6892fe8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3344,7 +3344,7 @@ int in_gate_area_no_task(unsigned long addr)
 
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
-static int follow_pte(struct mm_struct *mm, unsigned long address,
+static int __follow_pte(struct mm_struct *mm, unsigned long address,
 		pte_t **ptepp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
@@ -3381,6 +3381,17 @@ out:
 	return -EINVAL;
 }
 
+static inline int follow_pte(struct mm_struct *mm, unsigned long address,
+			     pte_t **ptepp, spinlock_t **ptlp)
+{
+	int res;
+
+	/* (void) is needed to make gcc happy */
+	(void) __cond_lock(*ptlp,
+			   !(res = __follow_pte(mm, address, ptepp, ptlp)));
+	return res;
+}
+
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
-- 
1.7.2.2

