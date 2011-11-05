Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1KEOiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 10:38:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48105 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1KEOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 10:38:21 -0400
Message-ID: <1320503897.2428.8.camel@discretia>
Subject: [PATCH] mm: migrate: One less atomic operation
From: Jacobo Giralt <jacobo.giralt@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mgorman@suse.de, minchan.kim@gmail.com,
        hughd@google.com, hannes@cmpxchg.org, npiggin@suse.de
Date: Sat, 05 Nov 2011 15:38:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3754c8617ef4377ce2ca2e3b28bdc28f8de1aa0d Mon Sep 17 00:00:00 2001
From: Jacobo Giralt <jacobo.giralt@gmail.com>
Date: Sat, 5 Nov 2011 13:12:50 +0100
Subject: [PATCH] mm: migrate: One less atomic operation

migrate_page_move_mapping drops a reference from the
old page after unfreezing its counter. Both operations
can be merged into a single atomic operation by
directly unfreezing to one less reference.

The same applies to migrate_huge_page_move_mapping.

Signed-off-by: Jacobo Giralt <jacobo.giralt@gmail.com>
---
 mm/migrate.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 33358f8..46d04a0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -269,12 +269,12 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 
 	radix_tree_replace_slot(pslot, newpage);
 
-	page_unfreeze_refs(page, expected_count);
 	/*
-	 * Drop cache reference from old page.
+	 * Drop cache reference from old page by unfreezing
+	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	__put_page(page);
+	page_unfreeze_refs(page, expected_count - 1);
 
 	/*
 	 * If moved to a different zone then also account
@@ -334,9 +334,7 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 	radix_tree_replace_slot(pslot, newpage);
 
-	page_unfreeze_refs(page, expected_count);
-
-	__put_page(page);
+	page_unfreeze_refs(page, expected_count - 1);
 
 	spin_unlock_irq(&mapping->tree_lock);
 	return 0;
-- 
1.7.5.4



