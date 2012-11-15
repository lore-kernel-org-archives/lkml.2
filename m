Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993175Ab2KOEej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:34:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:49120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399Ab2KOELb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 35/66] drm: set dev_mapping before calling drm_open_helper
Date: Wed, 14 Nov 2012 20:10:40 -0800
Message-Id: <20121115040941.535703655@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ilijahadzic@gmail.com>

commit fdb40a08ef7bc970899c3a1f471165f9c22763a1 upstream.

Some drivers (specifically vmwgfx) look at dev_mapping
in their open hook, so we have to set dev->dev_mapping
earlier in the process.

Reference:
http://lists.freedesktop.org/archives/dri-devel/2012-October/029420.html

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Reported-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_fops.c |   47 ++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -121,6 +121,8 @@ int drm_open(struct inode *inode, struct
 	int minor_id = iminor(inode);
 	struct drm_minor *minor;
 	int retcode = 0;
+	int need_setup = 0;
+	struct address_space *old_mapping;
 
 	minor = idr_find(&drm_minors_idr, minor_id);
 	if (!minor)
@@ -132,26 +134,37 @@ int drm_open(struct inode *inode, struct
 	if (drm_device_is_unplugged(dev))
 		return -ENODEV;
 
+	if (!dev->open_count++)
+		need_setup = 1;
+	mutex_lock(&dev->struct_mutex);
+	old_mapping = dev->dev_mapping;
+	if (old_mapping == NULL)
+		dev->dev_mapping = &inode->i_data;
+	/* ihold ensures nobody can remove inode with our i_data */
+	ihold(container_of(dev->dev_mapping, struct inode, i_data));
+	inode->i_mapping = dev->dev_mapping;
+	filp->f_mapping = dev->dev_mapping;
+	mutex_unlock(&dev->struct_mutex);
+
 	retcode = drm_open_helper(inode, filp, dev);
-	if (!retcode) {
-		atomic_inc(&dev->counts[_DRM_STAT_OPENS]);
-		if (!dev->open_count++) {
-			retcode = drm_setup(dev);
-			if (retcode)
-				dev->open_count--;
-		}
-	}
-	if (!retcode) {
-		mutex_lock(&dev->struct_mutex);
-		if (dev->dev_mapping == NULL)
-			dev->dev_mapping = &inode->i_data;
-		/* ihold ensures nobody can remove inode with our i_data */
-		ihold(container_of(dev->dev_mapping, struct inode, i_data));
-		inode->i_mapping = dev->dev_mapping;
-		filp->f_mapping = dev->dev_mapping;
-		mutex_unlock(&dev->struct_mutex);
+	if (retcode)
+		goto err_undo;
+	atomic_inc(&dev->counts[_DRM_STAT_OPENS]);
+	if (need_setup) {
+		retcode = drm_setup(dev);
+		if (retcode)
+			goto err_undo;
 	}
+	return 0;
 
+err_undo:
+	mutex_lock(&dev->struct_mutex);
+	filp->f_mapping = old_mapping;
+	inode->i_mapping = old_mapping;
+	iput(container_of(dev->dev_mapping, struct inode, i_data));
+	dev->dev_mapping = old_mapping;
+	mutex_unlock(&dev->struct_mutex);
+	dev->open_count--;
 	return retcode;
 }
 EXPORT_SYMBOL(drm_open);


