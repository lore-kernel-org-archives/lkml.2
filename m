Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1GOQl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:41:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35811 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1GOQl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:41:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/15] gma500: allow the creation of 'stolen' memory objects
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:33:08 +0100
Message-ID: <20110715163250.28759.30677.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

For things like cursors and many kinds of framebuffer set up we are actually
best using the stolen memory when possible.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/gem.c     |   24 ++++++++++++++++++++++++
 drivers/staging/gma500/psb_drm.h |    3 ++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/gem.c b/drivers/staging/gma500/gem.c
index d7b74b6..65fdd6b 100644
--- a/drivers/staging/gma500/gem.c
+++ b/drivers/staging/gma500/gem.c
@@ -251,6 +251,21 @@ fail:
 	}
 }
 
+static int psb_gem_create_stolen(struct drm_file *file, struct drm_device *dev,
+						int size, u32 *handle)
+{
+	struct gtt_range *gtt = psb_gtt_alloc_range(dev, size, "gem", 1);
+	if (gtt == NULL)
+		return -ENOMEM;
+	if (drm_gem_private_object_init(dev, &gtt->gem, size) != 0)
+		goto free_gtt;
+	if (drm_gem_handle_create(file, &gtt->gem, handle) == 0)
+		return 0;
+free_gtt:
+	psb_gtt_free_range(dev, gtt);
+	return -ENOMEM;
+}
+
 /*
  *	GEM interfaces for our specific client
  */
@@ -258,6 +273,15 @@ int psb_gem_create_ioctl(struct drm_device *dev, void *data,
 					struct drm_file *file)
 {
 	struct drm_psb_gem_create *args = data;
+	int ret;
+	if (args->flags & PSB_GEM_CREATE_STOLEN) {
+		ret = psb_gem_create_stolen(file, dev, args->size,
+							&args->handle);
+		if (ret == 0)
+			return 0;
+		/* Fall throguh */
+		args->flags &= ~PSB_GEM_CREATE_STOLEN;
+	}
 	return psb_gem_create(file, dev, args->size, &args->handle);
 }
 
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index 70115a9..0da8468 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -189,7 +189,8 @@ struct psb_drm_dpu_rect {
 struct drm_psb_gem_create {
 	__u64 size;
 	__u32 handle;
-	__u32 pad;
+	__u32 flags;
+#define PSB_GEM_CREATE_STOLEN		1	/* Stolen memory can be used */
 };
 
 #define PSB_2D_OP_BUFLEN		16

