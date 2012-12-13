Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2LMOCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:02:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2LMOCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 027/241] xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF
Date: Thu, 13 Dec 2012 11:56:32 -0200
Message-Id: <1355407206-17100-28-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit a67baeb77375199bbd842fa308cb565164dd1f19 upstream.

map->kmap_ops allocated in gntdev_alloc_map() wasn't freed by
gntdev_put_map().

Add a gntdev_free_map() helper function to free everything allocated
by gntdev_alloc_map().

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/xen/gntdev.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 7f12416..9a113b7 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -105,6 +105,21 @@ static void gntdev_print_maps(struct gntdev_priv *priv,
 #endif
 }
 
+static void gntdev_free_map(struct grant_map *map)
+{
+	if (map == NULL)
+		return;
+
+	if (map->pages)
+		free_xenballooned_pages(map->count, map->pages);
+	kfree(map->pages);
+	kfree(map->grants);
+	kfree(map->map_ops);
+	kfree(map->unmap_ops);
+	kfree(map->kmap_ops);
+	kfree(map);
+}
+
 static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 {
 	struct grant_map *add;
@@ -142,12 +157,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	return add;
 
 err:
-	kfree(add->pages);
-	kfree(add->grants);
-	kfree(add->map_ops);
-	kfree(add->unmap_ops);
-	kfree(add->kmap_ops);
-	kfree(add);
+	gntdev_free_map(add);
 	return NULL;
 }
 
@@ -198,17 +208,9 @@ static void gntdev_put_map(struct grant_map *map)
 		evtchn_put(map->notify.event);
 	}
 
-	if (map->pages) {
-		if (!use_ptemod)
-			unmap_grant_pages(map, 0, map->count);
-
-		free_xenballooned_pages(map->count, map->pages);
-	}
-	kfree(map->pages);
-	kfree(map->grants);
-	kfree(map->map_ops);
-	kfree(map->unmap_ops);
-	kfree(map);
+	if (map->pages && !use_ptemod)
+		unmap_grant_pages(map, 0, map->count);
+	gntdev_free_map(map);
 }
 
 /* ------------------------------------------------------------------ */
-- 
1.7.9.5

