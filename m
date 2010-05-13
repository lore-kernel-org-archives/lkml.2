Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0EMT7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:59:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50683 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759482Ab0EMT67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:58:59 -0400
Date: Thu, 13 May 2010 21:58:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/20] drivers/gpu/drm: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132158390.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/drm/drm_auth.c          |    3 +--
 drivers/gpu/drm/drm_dma.c           |    4 +---
 drivers/gpu/drm/drm_fops.c          |    3 +--
 drivers/gpu/drm/savage/savage_bci.c |    3 +--
 4 files changed, 4 insertions(+), 9 deletions(-)

diff -u -p a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -79,10 +79,9 @@ static int drm_add_magic(struct drm_mast
 	struct drm_device *dev = master->minor->dev;
 	DRM_DEBUG("%d\n", magic);
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-	memset(entry, 0, sizeof(*entry));
 	entry->priv = priv;
 	entry->hash_item.key = (unsigned long)magic;
 	mutex_lock(&dev->struct_mutex);
diff -u -p a/drivers/gpu/drm/drm_dma.c b/drivers/gpu/drm/drm_dma.c
--- a/drivers/gpu/drm/drm_dma.c
+++ b/drivers/gpu/drm/drm_dma.c
@@ -47,12 +47,10 @@ int drm_dma_setup(struct drm_device *dev
 {
 	int i;
 
-	dev->dma = kmalloc(sizeof(*dev->dma), GFP_KERNEL);
+	dev->dma = kzalloc(sizeof(*dev->dma), GFP_KERNEL);
 	if (!dev->dma)
 		return -ENOMEM;
 
-	memset(dev->dma, 0, sizeof(*dev->dma));
-
 	for (i = 0; i <= DRM_MAX_ORDER; i++)
 		memset(&dev->dma->bufs[i], 0, sizeof(dev->dma->bufs[0]));
 
diff -u -p a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -243,11 +243,10 @@ static int drm_open_helper(struct inode 
 
 	DRM_DEBUG("pid = %d, minor = %d\n", task_pid_nr(current), minor_id);
 
-	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	memset(priv, 0, sizeof(*priv));
 	filp->private_data = priv;
 	priv->filp = filp;
 	priv->uid = current_euid();
diff -u -p a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -539,11 +539,10 @@ int savage_driver_load(struct drm_device
 {
 	drm_savage_private_t *dev_priv;
 
-	dev_priv = kmalloc(sizeof(drm_savage_private_t), GFP_KERNEL);
+	dev_priv = kzalloc(sizeof(drm_savage_private_t), GFP_KERNEL);
 	if (dev_priv == NULL)
 		return -ENOMEM;
 
-	memset(dev_priv, 0, sizeof(drm_savage_private_t));
 	dev->dev_private = (void *)dev_priv;
 
 	dev_priv->chipset = (enum savage_family)chipset;
