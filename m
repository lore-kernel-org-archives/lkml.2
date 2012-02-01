Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2BAVbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:31:55 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51977 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932574Ab2BAVTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:10 -0500
X-Sasl-enc: UWxQx58VDit8FGsMDwkql1KGG1yGsuw17miMmMCQxbfK 1328131149
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210044.849998349@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Hellstrom <thellstrom@vmware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [11/89] drm: Fix authentication kernel crash
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 598781d71119827b454fd75d46f84755bca6f0c6 upstream.

If the master tries to authenticate a client using drm_authmagic and
that client has already closed its drm file descriptor,
either wilfully or because it was terminated, the
call to drm_authmagic will dereference a stale pointer into kmalloc'ed memory
and corrupt it.

Typically this results in a hard system hang.

This patch fixes that problem by removing any authentication tokens
(struct drm_magic_entry) open for a file descriptor when that file
descriptor is closed.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_auth.c |    6 +++++-
 drivers/gpu/drm/drm_fops.c |    5 +++++
 include/drm/drmP.h         |    1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -101,7 +101,7 @@ static int drm_add_magic(struct drm_mast
  * Searches and unlinks the entry in drm_device::magiclist with the magic
  * number hash key, while holding the drm_device::struct_mutex lock.
  */
-static int drm_remove_magic(struct drm_master *master, drm_magic_t magic)
+int drm_remove_magic(struct drm_master *master, drm_magic_t magic)
 {
 	struct drm_magic_entry *pt;
 	struct drm_hash_item *hash;
@@ -136,6 +136,8 @@ static int drm_remove_magic(struct drm_m
  * If there is a magic number in drm_file::magic then use it, otherwise
  * searches an unique non-zero magic number and add it associating it with \p
  * file_priv.
+ * This ioctl needs protection by the drm_global_mutex, which protects
+ * struct drm_file::magic and struct drm_magic_entry::priv.
  */
 int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
@@ -173,6 +175,8 @@ int drm_getmagic(struct drm_device *dev,
  * \return zero if authentication successed, or a negative number otherwise.
  *
  * Checks if \p file_priv is associated with the magic number passed in \arg.
+ * This ioctl needs protection by the drm_global_mutex, which protects
+ * struct drm_file::magic and struct drm_magic_entry::priv.
  */
 int drm_authmagic(struct drm_device *dev, void *data,
 		  struct drm_file *file_priv)
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -487,6 +487,11 @@ int drm_release(struct inode *inode, str
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
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1328,6 +1328,7 @@ extern int drm_getmagic(struct drm_devic
 			struct drm_file *file_priv);
 extern int drm_authmagic(struct drm_device *dev, void *data,
 			 struct drm_file *file_priv);
+extern int drm_remove_magic(struct drm_master *master, drm_magic_t magic);
 
 /* Cache management (drm_cache.c) */
 void drm_clflush_pages(struct page *pages[], unsigned long num_pages);


