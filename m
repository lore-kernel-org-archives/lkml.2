Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1DULoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:44:24 -0400
Received: from smtp.nokia.com ([147.243.1.48]:48338 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1DULoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:44:23 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: catalin.marinas@arm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        ext-phil.2.carmody@nokia.com
Subject: [PATCH] kmemleak: Never return a pointer you didn't 'get'
Date: Thu, 21 Apr 2011 14:39:32 +0300
Message-Id: <1303385972-2518-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old - If you don't get the last pointer that you looked at, then it will
still be put, as there's no way of knowing you didn't get it.

New - If you didn't get it, then it refers to something deleted, and
your work is done, so return NULL.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 mm/kmemleak.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8bf765c..3bf204d 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1350,17 +1350,21 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct kmemleak_object *prev_obj = v;
 	struct kmemleak_object *next_obj = NULL;
 	struct list_head *n = &prev_obj->object_list;
+	int found = 0;
 
 	++(*pos);
 
 	list_for_each_continue_rcu(n, &object_list) {
 		next_obj = list_entry(n, struct kmemleak_object, object_list);
-		if (get_object(next_obj))
+		if (get_object(next_obj)) {
+			found = 1;
 			break;
+		}
 	}
 
 	put_object(prev_obj);
-	return next_obj;
+
+	return found ? next_obj : NULL;
 }
 
 /*
-- 
1.7.2.rc1.37.gf8c40

