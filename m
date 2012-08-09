Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2HIJgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:36:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16903 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2HIJgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:36:43 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-04-502384aa5c98
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com, t.stanislaws@samsung.com,
        kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
        sumit.semwal@linaro.org, inki.dae@samsung.com, daniel.vetter@ffwll.ch,
        rob@ti.com, pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        dan.j.williams@intel.com, linux-doc@vger.kernel.org
Subject: [PATCH v2 1/2] dma-buf: add reference counting for exporter module
Date: Thu, 09 Aug 2012 11:36:21 +0200
Message-id: <1344504982-30415-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
References: <1344504982-30415-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t9jAd1VLcoBBn+/iVgsbFvCYnF51xw2
	i54NW1kdmD0+b5ILYIzisklJzcksSy3St0vgymiYf4ap4IlERf/vAywNjDNEuhg5OSQETCQu
	fn3MBGGLSVy4t56ti5GLQ0hgEaPE3daHrBBOF5PEuyn32ECq2IA6ji35zAhiiwg4SJy+O4sZ
	pIhZYCezxNFba4AcDg5hAW+JY42SICaLgKpE1x4/kHJeAQ+Jn61T2CGWyUs8vd8HNpJTwFNi
	8erXzCC2EFDNrb4rTBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA6CZ1I7GFc2
	WBxiFOBgVOLh1digFCDEmlhWXJl7iFGCg1lJhPdWuXKAEG9KYmVValF+fFFpTmrxIUZpDhYl
	cV5j76/+QgLpiSWp2ampBalFMFkmDk6pBsZTu77U9TxQO5Me/K9+w2SbqI2hVxK7krJ3rdBu
	Viv53a3wvFry4amlLYLhM2O7GX5rPmI+2bspUvB2y5rngTmzZl+5EV9+m6e95fXhKzzzdgix
	P719bXpjddqswqr7Qj05h76eEcuTdJp83/HD/8tVxp2bdqQueebx4pvPsg9Hwz5JzdrZ1rBA
	iaU4I9FQi7moOBEABsViev4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reference counting on a module that exported dma-buf and
implements its operations. This prevents the module from being unloaded while
DMABUF file is in use.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: linux-doc@vger.kernel.org
---
 Documentation/dma-buf-sharing.txt |    3 ++-
 drivers/base/dma-buf.c            |    9 ++++++++-
 include/linux/dma-buf.h           |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index ad86fb8..2613057 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -49,7 +49,8 @@ The dma_buf buffer sharing API usage contains the following steps:
    The buffer exporter announces its wish to export a buffer. In this, it
    connects its own private buffer data, provides implementation for operations
    that can be performed on the exported dma_buf, and flags for the file
-   associated with this buffer.
+   associated with this buffer. The operations structure has owner field.
+   You should initialize this to THIS_MODULE in most cases.
 
    Interface:
       struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index c30f3e1..a1d9cab 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -27,6 +27,7 @@
 #include <linux/dma-buf.h>
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
+#include <linux/module.h>
 
 static inline int is_dma_buf_file(struct file *);
 
@@ -40,6 +41,7 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	dmabuf = file->private_data;
 
 	dmabuf->ops->release(dmabuf);
+	module_put(dmabuf->ops->owner);
 	kfree(dmabuf);
 	return 0;
 }
@@ -105,9 +107,14 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (!try_module_get(ops->owner))
+		return ERR_PTR(-ENOENT);
+
 	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
-	if (dmabuf == NULL)
+	if (dmabuf == NULL) {
+		module_put(ops->owner);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	dmabuf->priv = priv;
 	dmabuf->ops = ops;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index eb48f38..22953de 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -37,6 +37,7 @@ struct dma_buf_attachment;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
+ * @owner: the module that implements dma_buf operations
  * @attach: [optional] allows different devices to 'attach' themselves to the
  *	    given buffer. It might return -EBUSY to signal that backing storage
  *	    is already allocated and incompatible with the requirements
@@ -70,6 +71,7 @@ struct dma_buf_attachment;
  * @vunmap: [optional] unmaps a vmap from the buffer
  */
 struct dma_buf_ops {
+	struct module *owner;
 	int (*attach)(struct dma_buf *, struct device *,
 			struct dma_buf_attachment *);
 
-- 
1.7.9.5

