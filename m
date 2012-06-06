Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2FFK4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:56:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56671 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab2FFKy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:26 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 04/11] mm: frontswap: split out __frontswap_unuse_pages
Date: Wed,  6 Jun 2012 12:55:08 +0200
Message-Id: <1338980115-2394-4-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An attempt at making frontswap_shrink shorter and more readable. This patch
splits out walking through the swap list to find an entry with enough
pages to unuse.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |   59 +++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 52b9dab..a9b76cb 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -209,6 +209,41 @@ static unsigned long __frontswap_curr_pages(void)
 	return totalpages;
 }
 
+static int __frontswap_unuse_pages(unsigned long total, unsigned long *unused,
+					int *swapid)
+{
+	int ret = -EINVAL;
+	struct swap_info_struct *si = NULL;
+	int si_frontswap_pages;
+	unsigned long total_pages_to_unuse = total;
+	unsigned long pages = 0, pages_to_unuse = 0;
+	int type;
+
+	lockdep_assert_held(&swap_lock);
+	for (type = swap_list.head; type >= 0; type = si->next) {
+		si = swap_info[type];
+		si_frontswap_pages = atomic_read(&si->frontswap_pages);
+		if (total_pages_to_unuse < si_frontswap_pages) {
+			pages = pages_to_unuse = total_pages_to_unuse;
+		} else {
+			pages = si_frontswap_pages;
+			pages_to_unuse = 0; /* unuse all */
+		}
+		/* ensure there is enough RAM to fetch pages from frontswap */
+		if (security_vm_enough_memory_mm(current->mm, pages)) {
+			ret = -ENOMEM;
+			continue;
+		}
+		vm_unacct_memory(pages);
+		*unused = pages_to_unuse;
+		*swapid = type;
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
 /*
  * Frontswap, like a true swap device, may unnecessarily retain pages
  * under certain circumstances; "shrink" frontswap is essentially a
@@ -219,11 +254,9 @@ static unsigned long __frontswap_curr_pages(void)
  */
 void frontswap_shrink(unsigned long target_pages)
 {
-	struct swap_info_struct *si = NULL;
-	int si_frontswap_pages;
 	unsigned long total_pages = 0, total_pages_to_unuse;
-	unsigned long pages = 0, pages_to_unuse = 0;
-	int type;
+	unsigned long pages_to_unuse = 0;
+	int type, ret;
 	bool locked = false;
 
 	/*
@@ -237,22 +270,8 @@ void frontswap_shrink(unsigned long target_pages)
 	if (total_pages <= target_pages)
 		goto out;
 	total_pages_to_unuse = total_pages - target_pages;
-	for (type = swap_list.head; type >= 0; type = si->next) {
-		si = swap_info[type];
-		si_frontswap_pages = atomic_read(&si->frontswap_pages);
-		if (total_pages_to_unuse < si_frontswap_pages) {
-			pages = pages_to_unuse = total_pages_to_unuse;
-		} else {
-			pages = si_frontswap_pages;
-			pages_to_unuse = 0; /* unuse all */
-		}
-		/* ensure there is enough RAM to fetch pages from frontswap */
-		if (security_vm_enough_memory_mm(current->mm, pages))
-			continue;
-		vm_unacct_memory(pages);
-		break;
-	}
-	if (type < 0)
+	ret = __frontswap_unuse_pages(total_pages_to_unuse, &pages_to_unuse, &type);
+	if (ret < 0)
 		goto out;
 	locked = false;
 	spin_unlock(&swap_lock);
-- 
1.7.8.6

