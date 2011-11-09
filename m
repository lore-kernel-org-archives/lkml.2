Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab1KIPrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:47:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab1KIPrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:47:24 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 1/3] frv: remove irqsave pgd_lock locking
Date: Wed,  9 Nov 2011 16:47:17 +0100
Message-Id: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a79e53d8: x86/mm: Fix pgd_lock deadlock dropped irqsave locking to fix a
deadlock. pgd_lock is not used from an irq context so we can drop
irqsave locking here as well.
The original patch was x86 only but the same applies here because both
pgd_ctor (aka mm_alloc_pgd) and pgd_dtor (aka mm_free_pgd) are not used
from an interrupt contexts.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/frv/mm/pgalloc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
index 4fb63a3..9df65c6 100644
--- a/arch/frv/mm/pgalloc.c
+++ b/arch/frv/mm/pgalloc.c
@@ -104,10 +104,8 @@ static inline void pgd_list_del(pgd_t *pgd)
 
 void pgd_ctor(void *pgd)
 {
-	unsigned long flags;
-
 	if (PTRS_PER_PMD == 1)
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 
 	memcpy((pgd_t *) pgd + USER_PGDS_IN_LAST_PML4,
 	       swapper_pg_dir + USER_PGDS_IN_LAST_PML4,
@@ -117,18 +115,16 @@ void pgd_ctor(void *pgd)
 		return;
 
 	pgd_list_add(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 	memset(pgd, 0, USER_PGDS_IN_LAST_PML4 * sizeof(pgd_t));
 }
 
 /* never called when PTRS_PER_PMD > 1 */
 void pgd_dtor(void *pgd)
 {
-	unsigned long flags; /* can be called from interrupt context */
-
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
-- 
1.7.7.1

