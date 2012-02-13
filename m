Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2BMJAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:00:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2BMJAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:00:15 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.56+drm33.22
Date: Mon, 13 Feb 2012 10:00:12 +0100
Message-Id: <1329123612-4141-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.56+drm33.22 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
or
  git://kernel.ubuntu.com/smb/linux-2.6.32.y-drm33.z.git

and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary
or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm: Fix authentication kernel crash
* Linux 2.6.32.56+drm33.22

 Makefile                   |    2 +-
 drivers/gpu/drm/drm_auth.c |    6 +++++-
 drivers/gpu/drm/drm_fops.c |    5 +++++
 include/drm/drmP.h         |    1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index d6115c0..72508a4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .56+drm33.21
+EXTRAVERSION = .56+drm33.22
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 932b5aa..d676d49 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -102,7 +102,7 @@ static int drm_add_magic(struct drm_master *master, struct drm_file *priv,
  * Searches and unlinks the entry in drm_device::magiclist with the magic
  * number hash key, while holding the drm_device::struct_mutex lock.
  */
-static int drm_remove_magic(struct drm_master *master, drm_magic_t magic)
+int drm_remove_magic(struct drm_master *master, drm_magic_t magic)
 {
 	struct drm_magic_entry *pt;
 	struct drm_hash_item *hash;
@@ -137,6 +137,8 @@ static int drm_remove_magic(struct drm_master *master, drm_magic_t magic)
  * If there is a magic number in drm_file::magic then use it, otherwise
  * searches an unique non-zero magic number and add it associating it with \p
  * file_priv.
+ * This ioctl needs protection by the drm_global_mutex, which protects
+ * struct drm_file::magic and struct drm_magic_entry::priv.
  */
 int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
@@ -174,6 +176,8 @@ int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *file_priv)
  * \return zero if authentication successed, or a negative number otherwise.
  *
  * Checks if \p file_priv is associated with the magic number passed in \arg.
+ * This ioctl needs protection by the drm_global_mutex, which protects
+ * struct drm_file::magic and struct drm_magic_entry::priv.
  */
 int drm_authmagic(struct drm_device *dev, void *data,
 		  struct drm_file *file_priv)
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 4804872..b63c643 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -488,6 +488,11 @@ int drm_release(struct inode *inode, struct file *filp)
 		  (long)old_encode_dev(file_priv->minor->device),
 		  dev->open_count);

+	/* Release any auth tokens that might point to this file_priv,
+	   (do that under the drm_global_mutex) */
+	if (file_priv->magic)
+		(void) drm_remove_magic(file_priv->master, file_priv->magic);
+
 	/* if the master has gone away we can't do anything with the lock */
 	if (file_priv->minor->master)
 		drm_master_release(dev, filp);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index c6c8eb9..147cb44 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1227,6 +1227,7 @@ extern int drm_getmagic(struct drm_device *dev, void *data,
 			struct drm_file *file_priv);
 extern int drm_authmagic(struct drm_device *dev, void *data,
 			 struct drm_file *file_priv);
+extern int drm_remove_magic(struct drm_master *master, drm_magic_t magic);

 /* Cache management (drm_cache.c) */
 void drm_clflush_pages(struct page *pages[], unsigned long num_pages);
