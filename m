Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab2AFRi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:38:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58843 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab2AFRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:38:55 -0500
Subject: [PATCH 2/3] mm: postpone migrated page mapping reset
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Fri, 06 Jan 2012 21:38:51 +0400
Message-ID: <20120106173850.11700.42919.stgit@zurg>
In-Reply-To: <20120106173827.11700.74305.stgit@zurg>
References: <20120106173827.11700.74305.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Postpone resetting page->mapping till final remove_migration_ptes(),
otherwise expression PageAnon(migration_entry_to_page(entry)) does not work.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 177aca4..f59cd76 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -386,7 +386,6 @@ void migrate_page_copy(struct page *newpage, struct page *page)
 	ClearPageSwapCache(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	page->mapping = NULL;
 
 	/*
 	 * If any waiters have accumulated on the new page then
@@ -614,6 +613,7 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 	} else {
 		if (remap_swapcache)
 			remove_migration_ptes(page, newpage);
+		page->mapping = NULL;
 	}
 
 	unlock_page(newpage);

