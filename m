Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1AJKgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:36:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36877 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1AJKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:57 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293800"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/12] xen gntdev: use gnttab_map_refs and gnttab_unmap_refs
Date: Mon, 10 Jan 2011 10:36:40 +0000
Message-Id: <1294655801-16230-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:56.0799 (UTC) FILETIME=[2A25F8F0:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Use gnttab_map_refs and gnttab_unmap_refs to map and unmap the grant
ref, so that we can have a corresponding struct page.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/gntdev.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index aba76d4..1e31cdc 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -71,6 +71,7 @@ struct grant_map {
 	struct ioctl_gntdev_grant_ref *grants;
 	struct gnttab_map_grant_ref   *map_ops;
 	struct gnttab_unmap_grant_ref *unmap_ops;
+	struct page **pages;
 };
 
 /* ------------------------------------------------------------------ */
@@ -94,6 +95,7 @@ static void gntdev_print_maps(struct gntdev_priv *priv,
 static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 {
 	struct grant_map *add;
+	int i;
 
 	add = kzalloc(sizeof(struct grant_map), GFP_KERNEL);
 	if (NULL == add)
@@ -102,11 +104,19 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	add->grants    = kzalloc(sizeof(add->grants[0])    * count, GFP_KERNEL);
 	add->map_ops   = kzalloc(sizeof(add->map_ops[0])   * count, GFP_KERNEL);
 	add->unmap_ops = kzalloc(sizeof(add->unmap_ops[0]) * count, GFP_KERNEL);
-	if (NULL == add->grants  ||
-	    NULL == add->map_ops ||
-	    NULL == add->unmap_ops)
+	add->pages     = kzalloc(sizeof(add->pages[0])     * count, GFP_KERNEL);
+	if (NULL == add->grants    ||
+	    NULL == add->map_ops   ||
+	    NULL == add->unmap_ops ||
+	    NULL == add->pages)
 		goto err;
 
+	for (i = 0; i < count; i++) {
+		add->pages[i] = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+		if (add->pages[i] == NULL)
+			goto err;
+	}
+
 	add->index = 0;
 	add->count = count;
 	add->priv  = priv;
@@ -117,6 +127,12 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	return add;
 
 err:
+	if (add->pages)
+		for (i = 0; i < count; i++) {
+			if (add->pages[i])
+				__free_page(add->pages[i]);
+		}
+	kfree(add->pages);
 	kfree(add->grants);
 	kfree(add->map_ops);
 	kfree(add->unmap_ops);
@@ -191,8 +207,17 @@ static int gntdev_del_map(struct grant_map *map)
 
 static void gntdev_free_map(struct grant_map *map)
 {
+	int i;
+
 	if (!map)
 		return;
+
+	if (map->pages)
+		for (i = 0; i < map->count; i++) {
+			if (map->pages[i])
+				__free_page(map->pages[i]);
+		}
+	kfree(map->pages);
 	kfree(map->grants);
 	kfree(map->map_ops);
 	kfree(map->unmap_ops);
@@ -226,8 +251,7 @@ static int map_grant_pages(struct grant_map *map)
 	int i, err = 0;
 
 	pr_debug("map %d+%d\n", map->index, map->count);
-	err = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref,
-					map->map_ops, map->count);
+	err = gnttab_map_refs(map->map_ops, map->pages, map->count);
 	if (err)
 		return err;
 
@@ -244,8 +268,7 @@ static int unmap_grant_pages(struct grant_map *map, int offset, int pages)
 	int i, err = 0;
 
 	pr_debug("map %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
-	err = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref,
-					map->unmap_ops + offset, pages);
+	err = gnttab_unmap_refs(map->unmap_ops + offset, map->pages, pages);
 	if (err)
 		return err;
 
-- 
1.5.6.5

