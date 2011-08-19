Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1HSHs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:48:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45654 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1HSHsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:48:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=CRiQQZBME84WYfKVC2rYv7SASRlKeS12kdfZzN4yeEKzEAUHRJl+RHpqbGPr8XDon
	A0/CnQHfYAzNHavgimB4A==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 1/9] mm: rcu read lock for getting reference on pages in migration_entry_wait()
Date: Fri, 19 Aug 2011 00:48:23 -0700
Message-Id: <1313740111-27446-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313740111-27446-1-git-send-email-walken@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migration_entry_wait() needs to take the rcu read lock so that page counts
can be guaranteed to be stable after one rcu grace period.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 mm/migrate.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 666e4e6..6f3b5db 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -193,6 +193,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 	struct page *page;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	rcu_read_lock();
 	pte = *ptep;
 	if (!is_swap_pte(pte))
 		goto out;
@@ -212,11 +213,13 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 	 */
 	if (!get_page_unless_zero(page))
 		goto out;
+	rcu_read_unlock();
 	pte_unmap_unlock(ptep, ptl);
 	wait_on_page_locked(page);
 	put_page(page);
 	return;
 out:
+	rcu_read_unlock();
 	pte_unmap_unlock(ptep, ptl);
 }
 
-- 
1.7.3.1

