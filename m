Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2G0R5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:57:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62184 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2G0R5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:57:04 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: [RESEND PATCH 3/4 v3] mm: fix return value in __alloc_contig_migrate_range()
Date: Sat, 28 Jul 2012 02:55:02 +0900
Message-Id: <1343411703-2720-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343411703-2720-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1343411703-2720-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migrate_pages() can return positive value while at the same time emptying
the list of pages it was called with.  Such situation means that it went
through all the pages on the list some of which failed to be migrated.

If that happens, __alloc_contig_migrate_range()'s loop may finish without
"++tries == 5" never being checked.  This in turn means that at the end
of the function, ret may have a positive value, which should be treated
as an error.

This patch changes __alloc_contig_migrate_range() so that the return
statement converts positive ret value into -EBUSY error.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4403009..02d4519 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5673,7 +5673,6 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 			}
 			tries = 0;
 		} else if (++tries == 5) {
-			ret = ret < 0 ? ret : -EBUSY;
 			break;
 		}
 
@@ -5683,7 +5682,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 	}
 
 	putback_lru_pages(&cc.migratepages);
-	return ret > 0 ? 0 : ret;
+	return ret <= 0 ? ret : -EBUSY;
 }
 
 /*
-- 
1.7.9.5

