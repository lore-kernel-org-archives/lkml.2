Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab2EWGgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:36:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34493 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab2EWGe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:34:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/11] resource: make find_resource could return just fit resource
Date: Tue, 22 May 2012 23:34:32 -0700
Message-Id: <1337754877-19759-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find all suitable empty slots and pick one just fit, so we could spare the big
slot for needed ones later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/resource.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 41d7050..45ab24d 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -435,7 +435,7 @@ static int __find_resource(struct resource *root, struct resource *old,
 			alloc.end = alloc.start + size - 1;
 			if (resource_contains(&avail, &alloc)) {
 				new->start = alloc.start;
-				new->end = alloc.end;
+				new->end = !old ? avail.end : alloc.end;
 				return 0;
 			}
 		}
@@ -450,14 +450,66 @@ next:		if (!this || this->end == root->end)
 	return -EBUSY;
 }
 
+struct avail_resource {
+	struct list_head list;
+	struct resource res;
+};
 /*
  * Find empty slot in the resource tree given range and alignment.
  */
 static int find_resource(struct resource *root, struct resource *new,
 			resource_size_t size,
-			struct resource_constraint  *constraint)
+			struct resource_constraint *constraint, bool fit)
 {
-	return  __find_resource(root, NULL, new, size, constraint);
+	int ret = -1;
+	LIST_HEAD(head);
+	struct avail_resource *avail, *tmp;
+	resource_size_t avail_start = 0, avail_size = -1ULL;
+
+	if (!fit) {
+		ret = __find_resource(root, NULL, new, size, constraint);
+		if (!ret)
+			new->end = new->start + size - 1;
+		return ret;
+	}
+
+again:
+	/* find all suitable ones */
+	avail = kzalloc(sizeof(*avail), GFP_KERNEL);
+	if (!avail)
+		goto out;
+
+	avail->res.start = new->start;
+	avail->res.end = new->end;
+	avail->res.flags = new->flags;
+	ret = __find_resource(root, NULL, &avail->res, size, constraint);
+	if (ret || __request_resource(root, &avail->res)) {
+		ret = -EBUSY;
+		kfree(avail);
+		goto out;
+	}
+	/* add to the list */
+	list_add(&avail->list, &head);
+	goto again;
+
+out:
+	/* pick up the smallest one and delete the list */
+	list_for_each_entry_safe(avail, tmp, &head, list) {
+		if (resource_size(&avail->res) < avail_size) {
+			avail_size = resource_size(&avail->res);
+			avail_start = avail->res.start;
+			ret = 0;
+		}
+		list_del(&avail->list);
+		__release_resource(&avail->res);
+		kfree(avail);
+	}
+
+	if (!ret) {
+		new->start = avail_start;
+		new->end = new->start + size - 1;
+	}
+	return ret;
 }
 
 /**
@@ -550,7 +602,7 @@ static int __allocate_resource(struct resource *root, struct resource *new,
 
 	if (lock)
 		write_lock(&resource_lock);
-	err = find_resource(root, new, size, &constraint);
+	err = find_resource(root, new, size, &constraint, false);
 	if (err >= 0 && __request_resource(root, new))
 		err = -EBUSY;
 	if (lock)
-- 
1.7.7

