Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1F1WG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:06:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40981 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1F1WGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:06:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/29] gma500: GEM glue
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:06:26 +0100
Message-ID: <20110628220622.898.39097.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Add this temporarily so we can keep making progress and also bundle all the
GEM bits we need together in our staging driver while we get them into GEM
itself.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile   |    3 ++
 drivers/staging/gma500/gem_glue.c |   47 +++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/gem_glue.h |    4 +++
 3 files changed, 53 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/gma500/gem_glue.c
 create mode 100644 drivers/staging/gma500/gem_glue.h


diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index db73ec6..01aaa28 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -3,7 +3,8 @@
 #
 ccflags-y += -Iinclude/drm
 
-psb_gfx-y += psb_bl.o \
+psb_gfx-y += gem_glue.o \
+	  psb_bl.o \
 	  psb_drv.o \
 	  psb_gem.o \
 	  psb_fb.o \
diff --git a/drivers/staging/gma500/gem_glue.c b/drivers/staging/gma500/gem_glue.c
new file mode 100644
index 0000000..0817497
--- /dev/null
+++ b/drivers/staging/gma500/gem_glue.c
@@ -0,0 +1,47 @@
+/**************************************************************************
+ * Copyright (c) 2011, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+
+/**
+ * Initialize an already allocated GEM object of the specified size with
+ * no GEM provided backing store. Instead the caller is responsible for
+ * backing the object and handling it.
+ */
+int drm_gem_private_object_init(struct drm_device *dev,
+			struct drm_gem_object *obj, size_t size)
+{
+	BUG_ON((size & (PAGE_SIZE - 1)) != 0);
+
+	obj->dev = dev;
+	obj->filp = NULL;
+
+	kref_init(&obj->refcount);
+	atomic_set(&obj->handle_count, 0);
+	obj->size = size;
+
+	return 0;
+}
+
+void drm_gem_object_release_wrap(struct drm_gem_object *obj)
+{
+	if (obj->filp)
+		drm_gem_object_release(obj);
+}
diff --git a/drivers/staging/gma500/gem_glue.h b/drivers/staging/gma500/gem_glue.h
new file mode 100644
index 0000000..c38285b
--- /dev/null
+++ b/drivers/staging/gma500/gem_glue.h
@@ -0,0 +1,4 @@
+extern void drm_gem_object_release_wrap(struct drm_gem_object *obj);
+extern int drm_gem_private_object_init(struct drm_device *dev,
+			struct drm_gem_object *obj, size_t size);
+

