Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1EMNwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:52:19 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38807 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab1EMNwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:52:16 -0400
From: Julia Lawall <julia@diku.dk>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drivers/gpu/drm/drm_bufs.c: Avoid leaving freed data in a list
Date: Fri, 13 May 2011 15:52:11 +0200
Message-Id: <1305294731-12127-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the call to drm_map_handle fails, list is freed, but not removed from
&dev->maplist.  &dev->maplist is not used by drm_map_handle, so the
list_add is moved after the call.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E1,E2;
identifier l;
@@

*list_add(&E->l,E1);
... when != E1
    when != list_del(&E->l)
    when != list_del_init(&E->l)
    when != E = E2
*kfree(E);// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
I have only verified that the list is not accessed by drm_map_handle by
inspecting the code.  If this analysis is not correct, the other solution
would be to leave the list_add where it is and delete the element from the
list explicitly.

 drivers/gpu/drm/drm_bufs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 3e257a5..16cd5c4 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -338,7 +338,6 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 	list->map = map;
 
 	mutex_lock(&dev->struct_mutex);
-	list_add(&list->head, &dev->maplist);
 
 	/* Assign a 32-bit handle */
 	/* We do it here so that dev->struct_mutex protects the increment */
@@ -355,6 +354,7 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 		return ret;
 	}
 
+	list_add(&list->head, &dev->maplist);
 	list->user_token = list->hash.key << PAGE_SHIFT;
 	mutex_unlock(&dev->struct_mutex);
 

