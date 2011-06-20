Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab1FTQfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:35:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1FTQfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:35:14 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
Date: Tue, 21 Jun 2011 00:34:28 +0800
Message-Id: <1308587683-2555-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

transparent_hugepage=never should mean to disable THP completely,
otherwise we don't have a way to disable THP completely.
The design is broken.

Signed-off-by: WANG Cong <amwang@redhat.com>
---
 mm/huge_memory.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 81532f2..9c63c90 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -488,19 +488,26 @@ static struct attribute_group khugepaged_attr_group = {
 };
 #endif /* CONFIG_SYSFS */
 
+#define hugepage_enabled()	khugepaged_enabled()
+
 static int __init hugepage_init(void)
 {
-	int err;
+	int err = 0;
 #ifdef CONFIG_SYSFS
 	static struct kobject *hugepage_kobj;
 #endif
 
-	err = -EINVAL;
 	if (!has_transparent_hugepage()) {
+		err = -EINVAL;
 		transparent_hugepage_flags = 0;
 		goto out;
 	}
 
+	if (!hugepage_enabled()) {
+		printk(KERN_INFO "hugepage: totally disabled\n");
+		goto out;
+	}
+
 #ifdef CONFIG_SYSFS
 	err = -ENOMEM;
 	hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
-- 
1.7.4.4

