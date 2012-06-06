Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2FFKyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45499 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2FFKy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:28 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 05/11] mm: frontswap: split frontswap_shrink further to eliminate locking games
Date: Wed,  6 Jun 2012 12:55:09 +0200
Message-Id: <1338980115-2394-5-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split frontswap_shrink to eliminate the locking issues in the original code.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index a9b76cb..618ef91 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -244,6 +244,24 @@ static int __frontswap_unuse_pages(unsigned long total, unsigned long *unused,
 	return ret;
 }
 
+static int __frontswap_shrink(unsigned long target_pages,
+				unsigned long *pages_to_unuse,
+				int *type)
+{
+	unsigned long total_pages = 0, total_pages_to_unuse;
+
+	lockdep_assert_held(&swap_lock);
+
+	total_pages = __frontswap_curr_pages();
+	if (total_pages <= target_pages) {
+		/* Nothing to do */
+		*pages_to_unuse = 0;
+		return 0;
+	}
+	total_pages_to_unuse = total_pages - target_pages;
+	return __frontswap_unuse_pages(total_pages_to_unuse, pages_to_unuse, type);
+}
+
 /*
  * Frontswap, like a true swap device, may unnecessarily retain pages
  * under certain circumstances; "shrink" frontswap is essentially a
@@ -254,10 +272,8 @@ static int __frontswap_unuse_pages(unsigned long total, unsigned long *unused,
  */
 void frontswap_shrink(unsigned long target_pages)
 {
-	unsigned long total_pages = 0, total_pages_to_unuse;
 	unsigned long pages_to_unuse = 0;
 	int type, ret;
-	bool locked = false;
 
 	/*
 	 * we don't want to hold swap_lock while doing a very
@@ -265,20 +281,10 @@ void frontswap_shrink(unsigned long target_pages)
 	 * so restart scan from swap_list.head each time
 	 */
 	spin_lock(&swap_lock);
-	locked = true;
-	total_pages = __frontswap_curr_pages();
-	if (total_pages <= target_pages)
-		goto out;
-	total_pages_to_unuse = total_pages - target_pages;
-	ret = __frontswap_unuse_pages(total_pages_to_unuse, &pages_to_unuse, &type);
-	if (ret < 0)
-		goto out;
-	locked = false;
+	ret = __frontswap_shrink(target_pages, &pages_to_unuse, &type);
 	spin_unlock(&swap_lock);
-	try_to_unuse(type, true, pages_to_unuse);
-out:
-	if (locked)
-		spin_unlock(&swap_lock);
+	if (ret == 0 && pages_to_unuse)
+		try_to_unuse(type, true, pages_to_unuse);
 	return;
 }
 EXPORT_SYMBOL(frontswap_shrink);
-- 
1.7.8.6

