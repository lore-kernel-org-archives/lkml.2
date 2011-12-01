Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1LASPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:15:41 -0500
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14917 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1LASPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:15:10 -0500
Message-Id: <201112011815.pB1IF932004906@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Dec 2011 12:51:05 -0500
Subject: [PATCH] arch/tile: fix double-free bug in homecache_free_pages()
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 01 Dec 2011 18:15:09.0768 (UTC) FILETIME=[29402480:01CCB055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When freeing the page with this API, the page was "put" twice.
This was only discovered bringing up an MPT fusion controller, which
actually used the API; it hadn't been invoked previously, so the bug
had gone unnoticed.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/homecache.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index cbe6f4f..1cc6ae4 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -449,9 +449,12 @@ void homecache_free_pages(unsigned long addr, unsigned int order)
 	VM_BUG_ON(!virt_addr_valid((void *)addr));
 	page = virt_to_page((void *)addr);
 	if (put_page_testzero(page)) {
-		int pages = (1 << order);
 		homecache_change_page_home(page, order, initial_page_home());
-		while (pages--)
-			__free_page(page++);
+		if (order == 0) {
+			free_hot_cold_page(page, 0);
+		} else {
+			init_page_count(page);
+			__free_pages(page, order);
+		}
 	}
 }
-- 
1.6.5.2

