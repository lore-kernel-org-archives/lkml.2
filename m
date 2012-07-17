Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2GQMfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:35:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2GQMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:35:00 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 3/4 v2] mm: fix return value in __alloc_contig_migrate_range()
Date: Tue, 17 Jul 2012 21:33:34 +0900
Message-Id: <1342528415-2291-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342528415-2291-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1342528415-2291-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migrate_pages() would return positive value in some failure case,
so 'ret > 0 ? 0 : ret' may be wrong.
This fix it and remove one dead statement.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Christoph Lameter <cl@linux.com>

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

