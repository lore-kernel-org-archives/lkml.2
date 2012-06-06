Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2FFKy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45499 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2FFKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:24 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 03/11] mm: frontswap: split out __frontswap_curr_pages
Date: Wed,  6 Jun 2012 12:55:07 +0200
Message-Id: <1338980115-2394-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code was duplicated in two functions, clean it up.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 844d6a6..52b9dab 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -195,6 +195,20 @@ void __frontswap_invalidate_area(unsigned type)
 }
 EXPORT_SYMBOL(__frontswap_invalidate_area);
 
+static unsigned long __frontswap_curr_pages(void)
+{
+	int type;
+	unsigned long totalpages = 0;
+	struct swap_info_struct *si = NULL;
+
+	lockdep_assert_held(&swap_lock);
+	for (type = swap_list.head; type >= 0; type = si->next) {
+		si = swap_info[type];
+		totalpages += atomic_read(&si->frontswap_pages);
+	}
+	return totalpages;
+}
+
 /*
  * Frontswap, like a true swap device, may unnecessarily retain pages
  * under certain circumstances; "shrink" frontswap is essentially a
@@ -219,11 +233,7 @@ void frontswap_shrink(unsigned long target_pages)
 	 */
 	spin_lock(&swap_lock);
 	locked = true;
-	total_pages = 0;
-	for (type = swap_list.head; type >= 0; type = si->next) {
-		si = swap_info[type];
-		total_pages += atomic_read(&si->frontswap_pages);
-	}
+	total_pages = __frontswap_curr_pages();
 	if (total_pages <= target_pages)
 		goto out;
 	total_pages_to_unuse = total_pages - target_pages;
@@ -261,16 +271,12 @@ EXPORT_SYMBOL(frontswap_shrink);
  */
 unsigned long frontswap_curr_pages(void)
 {
-	int type;
 	unsigned long totalpages = 0;
-	struct swap_info_struct *si = NULL;
 
 	spin_lock(&swap_lock);
-	for (type = swap_list.head; type >= 0; type = si->next) {
-		si = swap_info[type];
-		totalpages += atomic_read(&si->frontswap_pages);
-	}
+	totalpages = __frontswap_curr_pages();
 	spin_unlock(&swap_lock);
+
 	return totalpages;
 }
 EXPORT_SYMBOL(frontswap_curr_pages);
-- 
1.7.8.6

