Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab2EUVTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2EUVSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:47 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] dlm: NULL dereference on failure in kmem_cache_create()
Date: Mon, 21 May 2012 16:18:40 -0500
Message-Id: <1337635120-19969-9-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

We aren't allowed to pass NULL pointers to kmem_cache_destroy() so if
both allocations fail, it leads to a NULL dereference.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index da64df7..7cd24bc 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -21,21 +21,19 @@ static struct kmem_cache *rsb_cache;
 
 int __init dlm_memory_init(void)
 {
-	int ret = 0;
-
 	lkb_cache = kmem_cache_create("dlm_lkb", sizeof(struct dlm_lkb),
 				__alignof__(struct dlm_lkb), 0, NULL);
 	if (!lkb_cache)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	rsb_cache = kmem_cache_create("dlm_rsb", sizeof(struct dlm_rsb),
 				__alignof__(struct dlm_rsb), 0, NULL);
 	if (!rsb_cache) {
 		kmem_cache_destroy(lkb_cache);
-		ret = -ENOMEM;
+		return -ENOMEM;
 	}
 
-	return ret;
+	return 0;
 }
 
 void dlm_memory_exit(void)
-- 
1.7.10.1.362.g242cab3

