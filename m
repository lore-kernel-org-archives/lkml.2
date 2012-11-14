Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2KNF4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:56:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55248 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756419Ab2KNFvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:05 -0500
Message-Id: <20121114053938.872047013@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 36/82] xen/gntdev: dont leak memory from IOCTL_GNTDEV_MAP_GRANT_REF
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit a67baeb77375199bbd842fa308cb565164dd1f19 upstream.

map->kmap_ops allocated in gntdev_alloc_map() wasn't freed by
gntdev_put_map().

Add a gntdev_free_map() helper function to free everything allocated
by gntdev_alloc_map().

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 
@@ -196,17 +206,9 @@ static void gntdev_put_map(struct grant_
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT)
 		notify_remote_via_evtchn(map->notify.event);
 
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


