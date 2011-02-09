Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1BINVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 08:21:25 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43156 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1BINVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 08:21:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vfCgrC2wki0cGk5Fg3jORpsO5HS3AqHLi13lSvH3r7bUaPmENN/J8IHp5mips52xob
         jCOvCGk26NL2g3mQrgCP+q5KqPluMcG4RhaEzc71dssAPcSM6N/j8M5nW49Jyg5uZjE6
         QVaIi02WowUUkI9b5FFD/Mfc2Nzm9xvB3QfLs=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: batch-free pcp list if possible
Date: Wed,  9 Feb 2011 22:21:17 +0900
Message-Id: <1297257677-12287-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_pcppages_bulk() frees pages from pcp lists in a round-robin
fashion by keeping batch_free counter. But it doesn't need to spin
if there is only one non-empty list. This can be checked by
batch_free == MIGRATE_PCPTYPES.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/page_alloc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a873e61e312e..470fb42e303c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -614,6 +614,10 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
+		/* This is an only non-empty list. Free them all. */
+		if (batch_free == MIGRATE_PCPTYPES)
+			batch_free = to_free;
+
 		do {
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
-- 
1.7.3.4.600.g982838b0

