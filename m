Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab1KRQqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:46:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32628 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab1KRQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:43:24 -0500
Date: Fri, 18 Nov 2011 17:43:08 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 01/11] mm: page_alloc: handle MIGRATE_ISOLATE in
 free_pcppages_bulk()
In-reply-to: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Message-id: <1321634598-16859-2-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

If page is on PCP list while pageblock it belongs to gets isolated,
the page's private still holds the old migrate type.  This means
that free_pcppages_bulk() will put the page on a freelist of the
old migrate type instead of MIGRATE_ISOLATE.

This commit changes that by explicitly checking whether page's
pageblock's migrate type is MIGRATE_ISOLATE and if it is, overwrites
page's private data.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/page_alloc.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9dd443d..58d1a2e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -628,6 +628,18 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
+
+			/*
+			 * When page is isolated in set_migratetype_isolate()
+			 * function it's page_private is not changed since the
+			 * function has no way of knowing if it can touch it.
+			 * This means that when a page is on PCP list, it's
+			 * page_private no longer matches the desired migrate
+			 * type.
+			 */
+			if (get_pageblock_migratetype(page) == MIGRATE_ISOLATE)
+				set_page_private(page, MIGRATE_ISOLATE);
+
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, page_private(page));
 			trace_mm_page_pcpu_drain(page, 0, page_private(page));
-- 
1.7.1.569.g6f426

