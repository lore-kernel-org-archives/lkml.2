Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992892Ab2KOELJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:11:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:48766 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992858Ab2KOELA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 01/66] xen/gntdev: dont leak memory from IOCTL_GNTDEV_MAP_GRANT_REF
Date: Wed, 14 Nov 2012 20:10:06 -0800
Message-Id: <20121115040939.123152224@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit a67baeb77375199bbd842fa308cb565164dd1f19 upstream.

map->kmap_ops allocated in gntdev_alloc_map() wasn't freed by
gntdev_put_map().

Add a gntdev_free_map() helper function to free everything allocated
by gntdev_alloc_map().

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/gntdev.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -105,6 +105,21 @@ static void gntdev_print_maps(struct gnt
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
@@ -142,12 +157,7 @@ static struct grant_map *gntdev_alloc_ma
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
 
@@ -198,17 +208,9 @@ static void gntdev_put_map(struct grant_
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


