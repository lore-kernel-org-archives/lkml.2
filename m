Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1KIPr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:47:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab1KIPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:47:25 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 3/3] mn10300: remove irqsave pgd_lock locking
Date: Wed,  9 Nov 2011 16:47:19 +0100
Message-Id: <1320853639-18048-3-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
References: <1320853639-18048-1-git-send-email-mhocko@suse.cz>
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
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
Cc: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/mn10300/mm/pgtable.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/mn10300/mm/pgtable.c b/arch/mn10300/mm/pgtable.c
index 450f7ba..8e5e10d 100644
--- a/arch/mn10300/mm/pgtable.c
+++ b/arch/mn10300/mm/pgtable.c
@@ -123,10 +123,8 @@ static inline void pgd_list_del(pgd_t *pgd)
 
 void pgd_ctor(void *pgd)
 {
-	unsigned long flags;
-
 	if (PTRS_PER_PMD == 1)
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 
 	memcpy((pgd_t *)pgd + USER_PTRS_PER_PGD,
 			swapper_pg_dir + USER_PTRS_PER_PGD,
@@ -136,18 +134,16 @@ void pgd_ctor(void *pgd)
 		return;
 
 	pgd_list_add(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 	memset(pgd, 0, USER_PTRS_PER_PGD * sizeof(pgd_t));
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

