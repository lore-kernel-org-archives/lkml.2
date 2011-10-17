Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1JQS5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:57:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52338 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JQS5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:57:49 -0400
Subject: [PATCH] drivers, vmw_balloon.c: Increment alloc and sleep_alloc
 only when page allocation succeeds.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, Dmitry Torokhov <dtor@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 00:57:31 +0600
Message-ID: <1318877852.10091.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 While doing allocation statistics in vmballoon_reserve_page function, alloc and sleep_alloc has been incremented even if allocation fails. But, b->stats.alloc and b->stats.sleep_alloc supposed to increment only when they succeed. This patch makes sure that, alloc and sleep_alloc gets incremented when page allocation succeeds.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 053d36c..d2c25c9 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -414,11 +414,6 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
 	bool locked = false;
 
 	do {
-		if (!can_sleep)
-			STATS_INC(b->stats.alloc);
-		else
-			STATS_INC(b->stats.sleep_alloc);
-
 		flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
 		page = alloc_page(flags);
 		if (!page) {
@@ -427,6 +422,11 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
 			else
 				STATS_INC(b->stats.sleep_alloc_fail);
 			return -ENOMEM;
+		} else {
+			if (!can_sleep)
+				STATS_INC(b->stats.alloc);
+			else
+				STATS_INC(b->stats.sleep_alloc);
 		}
 
 		/* inform monitor */


