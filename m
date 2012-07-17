Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2GQMe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:34:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2GQMey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:34:54 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 1/4 v2] mm: correct return value of migrate_pages() and migrate_huge_pages()
Date: Tue, 17 Jul 2012 21:33:32 +0900
Message-Id: <1342528415-2291-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migrate_pages() should return number of pages not migrated or error code.
When unmap_and_move return -EAGAIN, outer loop is re-execution without
initialising nr_failed. This makes nr_failed over-counted.

So this patch correct it by initialising nr_failed in outer loop.

migrate_huge_pages() is identical case as migrate_pages()

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index be26d5c..f495c58 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -982,6 +982,7 @@ int migrate_pages(struct list_head *from,
 
 	for(pass = 0; pass < 10 && retry; pass++) {
 		retry = 0;
+		nr_failed = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
 			cond_resched();
@@ -1029,6 +1030,7 @@ int migrate_huge_pages(struct list_head *from,
 
 	for (pass = 0; pass < 10 && retry; pass++) {
 		retry = 0;
+		nr_failed = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
 			cond_resched();
-- 
1.7.9.5

