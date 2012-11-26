Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2KZNQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:16:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3977 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2KZNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 Nov 2012 05:16:17 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Terje Bergstrom <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [RFC v2 8/8] drm: tegra: Add gr2d device
Date: Mon, 26 Nov 2012 15:19:14 +0200
Message-ID: <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add client driver for 2D device.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/tegra/Makefile |    2 +-
 drivers/gpu/drm/tegra/drm.c    |  231 +++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/tegra/drm.h    |   42 ++++++--
 drivers/gpu/drm/tegra/gr2d.c   |  224 ++++++++++++++++++++++++++++++++++++++
 include/drm/tegra_drm.h        |  129 ++++++++++++++++++++++
 5 files changed, 615 insertions(+), 13 deletions(-)
 create mode 100644 drivers/gpu/drm/tegra/gr2d.c
 create mode 100644 include/drm/tegra_drm.h

diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
index 53ea383..5e85042 100644
--- a/drivers/gpu/drm/tegra/Makefile
+++ b/drivers/gpu/drm/tegra/Makefile
@@ -1,7 +1,7 @@
 ccflags-y := -Iinclude/drm
 ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
-tegra-drm-y := drm.o fb.o dc.o
+tegra-drm-y := drm.o fb.o dc.o gr2d.o
 tegra-drm-y += output.o rgb.o hdmi.o tvo.o dsi.o
 tegra-drm-y += plane.o dmabuf.o
 
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index f78a31b..c35e547 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/nvhost.h>
 
 #include <mach/clk.h>
 #include <linux/dma-mapping.h>
@@ -55,10 +56,12 @@ static int tegra_drm_parse_dt(void)
 		"nvidia,tegra20-hdmi",
 		"nvidia,tegra20-tvo",
 		"nvidia,tegra20-dsi",
+		"nvidia,tegra20-gr2d",
 		"nvidia,tegra30-dc",
 		"nvidia,tegra30-hdmi",
 		"nvidia,tegra30-tvo",
-		"nvidia,tegra30-dsi"
+		"nvidia,tegra30-dsi",
+		"nvidia,tegra30-gr2d"
 	};
 	unsigned int i;
 	int err;
@@ -177,7 +180,17 @@ static int tegra_drm_unload(struct drm_device *drm)
 
 static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 {
-	return 0;
+	struct tegra_drm_fpriv *fpriv;
+	int err = 0;
+
+	fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
+	if (!fpriv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&fpriv->contexts);
+	filp->driver_priv = fpriv;
+
+	return err;
 }
 
 static void tegra_drm_lastclose(struct drm_device *drm)
@@ -207,8 +220,13 @@ static int __init tegra_drm_init(void)
 	if (err < 0)
 		goto unregister_tvo;
 
+	err = platform_driver_register(&tegra_gr2d_driver);
+	if (err < 0)
+		goto unregister_dsi;
 	return 0;
 
+unregister_dsi:
+	platform_driver_unregister(&tegra_dsi_driver);
 unregister_tvo:
 	platform_driver_unregister(&tegra_tvo_driver);
 unregister_hdmi:
@@ -221,6 +239,7 @@ module_init(tegra_drm_init);
 
 static void __exit tegra_drm_exit(void)
 {
+	platform_driver_unregister(&tegra_gr2d_driver);
 	platform_driver_unregister(&tegra_dsi_driver);
 	platform_driver_unregister(&tegra_tvo_driver);
 	platform_driver_unregister(&tegra_hdmi_driver);
@@ -232,7 +251,215 @@ MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
 MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
 MODULE_LICENSE("GPL");
 
+static int
+tegra_drm_ioctl_syncpt_read(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_syncpt_read_args *args = data;
+
+	dev_dbg(drm->dev, "> %s(drm=%p, id=%d)\n", __func__, drm, args->id);
+	args->value = host1x_syncpt_read(args->id);
+	dev_dbg(drm->dev, "< %s(value=%d)\n", __func__, args->value);
+	return 0;
+}
+
+static int
+tegra_drm_ioctl_syncpt_incr(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_syncpt_incr_args *args = data;
+	dev_dbg(drm->dev, "> %s(drm=%p, id=%d)\n", __func__, drm, args->id);
+	host1x_syncpt_incr(args->id);
+	dev_dbg(drm->dev, "< %s()\n", __func__);
+	return 0;
+}
+
+static int
+tegra_drm_ioctl_syncpt_wait(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_syncpt_wait_args *args = data;
+	int err;
+
+	dev_dbg(drm->dev, "> %s(drm=%p, id=%d, thresh=%d)\n", __func__, drm,
+			args->id, args->thresh);
+	err = host1x_syncpt_wait(args->id, args->thresh,
+			args->timeout, &args->value);
+	dev_dbg(drm->dev, "< %s() = %d\n", __func__, err);
+
+	return err;
+}
+
+static int
+tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_open_channel_args *args = data;
+	struct tegra_drm_client *client;
+	struct tegra_drm_context *context;
+	struct tegra_drm_fpriv *fpriv = tegra_drm_fpriv(file_priv);
+	int err = 0;
+
+	dev_dbg(drm->dev, "> %s(fpriv=%p, class=%x)\n", __func__,
+			fpriv, args->class);
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	list_for_each_entry(client, &tegra_drm_subdrv_list, list) {
+		if (client->class == args->class) {
+			dev_dbg(drm->dev, "opening client %x\n", args->class);
+			context->client = client;
+			err = client->ops->open_channel(client, context);
+			if (err)
+				goto out;
+
+			dev_dbg(drm->dev, "context %p\n", context);
+			list_add(&context->list, &fpriv->contexts);
+			args->context = context;
+			goto out;
+		}
+	}
+	err = -ENODEV;
+
+out:
+	if (err)
+		kfree(context);
+
+	dev_dbg(drm->dev, "< %s() = %d\n", __func__, err);
+	return err;
+}
+
+static int
+tegra_drm_ioctl_close_channel(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_open_channel_args *args = data;
+	struct tegra_drm_context *context;
+	struct tegra_drm_fpriv *fpriv = tegra_drm_fpriv(file_priv);
+	int err = 0;
+
+	dev_dbg(drm->dev, "> %s(fpriv=%p)\n", __func__, fpriv);
+	list_for_each_entry(context, &fpriv->contexts, list) {
+		if (context == args->context) {
+			context->client->ops->close_channel(context);
+			list_del(&context->list);
+			kfree(context);
+			goto out;
+		}
+	}
+	err = -EINVAL;
+
+out:
+	dev_dbg(drm->dev, "< %s() = %d\n", __func__, err);
+	return err;
+}
+
+static int
+tegra_drm_ioctl_get_syncpoints(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_get_channel_param_args *args = data;
+	struct tegra_drm_context *context;
+	struct tegra_drm_fpriv *fpriv = tegra_drm_fpriv(file_priv);
+	int err = 0;
+
+	list_for_each_entry(context, &fpriv->contexts, list) {
+		if (context == args->context) {
+			args->value =
+				context->client->ops->get_syncpoints(context);
+			goto out;
+		}
+	}
+	err = -ENODEV;
+
+out:
+	return err;
+}
+
+static int
+tegra_drm_ioctl_get_modmutexes(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_get_channel_param_args *args = data;
+	struct tegra_drm_context *context;
+	struct tegra_drm_fpriv *fpriv = tegra_drm_fpriv(file_priv);
+	int err = 0;
+
+	list_for_each_entry(context, &fpriv->contexts, list) {
+		if (context == args->context) {
+			args->value =
+				context->client->ops->get_modmutexes(context);
+			goto out;
+		}
+	}
+	err = -ENODEV;
+
+out:
+	return err;
+}
+
+static int
+tegra_drm_ioctl_submit(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_drm_submit_args *args = data;
+	struct tegra_drm_context *context;
+	struct tegra_drm_fpriv *fpriv = tegra_drm_fpriv(file_priv);
+	int err = 0;
+
+	list_for_each_entry(context, &fpriv->contexts, list) {
+		if (context == args->context) {
+			err = context->client->ops->submit(context, args);
+			goto out;
+		}
+	}
+	err = -ENODEV;
+
+out:
+	return err;
+
+}
+
+static int
+tegra_drm_create_ioctl(struct drm_device *drm, void *data,
+			 struct drm_file *file_priv)
+{
+	struct tegra_gem_create *args = data;
+	struct drm_gem_cma_object *cma_obj;
+	int ret;
+
+	cma_obj = drm_gem_cma_create(drm, args->size);
+	if (IS_ERR(cma_obj))
+		goto err_cma_create;
+
+	ret = drm_gem_handle_create(file_priv, &cma_obj->base, &args->handle);
+	if (ret)
+		goto err_handle_create;
+
+	drm_gem_object_unreference(&cma_obj->base);
+
+	return 0;
+
+err_handle_create:
+	drm_gem_cma_free_object(&cma_obj->base);
+err_cma_create:
+	return -ENOMEM;
+}
+
 static struct drm_ioctl_desc tegra_drm_ioctls[] = {
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_CREATE, tegra_drm_create_ioctl, DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_READ, tegra_drm_ioctl_syncpt_read, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_INCR, tegra_drm_ioctl_syncpt_incr, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SYNCPT_WAIT, tegra_drm_ioctl_syncpt_wait, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_OPEN_CHANNEL, tegra_drm_ioctl_open_channel, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_CLOSE_CHANNEL, tegra_drm_ioctl_close_channel, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GET_SYNCPOINTS, tegra_drm_ioctl_get_syncpoints, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_GET_MODMUTEXES, tegra_drm_ioctl_get_modmutexes, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_DRM_SUBMIT, tegra_drm_ioctl_submit, DRM_UNLOCKED),
 };
 
 static const struct file_operations tegra_drm_fops = {
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 1267a38..db197f6 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -20,6 +20,7 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fixed.h>
+#include <drm/tegra_drm.h>
 
 struct tegra_framebuffer {
 	struct drm_framebuffer base;
@@ -33,17 +34,44 @@ static inline struct tegra_framebuffer *to_tegra_fb(struct drm_framebuffer *fb)
 
 struct tegra_drm_client;
 
+struct tegra_drm_context {
+	struct tegra_drm_client *client;
+	struct nvhost_channel *channel;
+	struct list_head list;
+};
+
 struct tegra_drm_client_ops {
-	int (*drm_init)(struct tegra_drm_client *client,
-			struct drm_device *drm);
-	int (*drm_exit)(struct tegra_drm_client *client);
+	int (*drm_init)(struct tegra_drm_client *, struct drm_device *);
+	int (*drm_exit)(struct tegra_drm_client *);
+	int (*open_channel)(struct tegra_drm_client *,
+			struct tegra_drm_context *);
+	void (*close_channel)(struct tegra_drm_context *);
+	u32 (*get_syncpoints)(struct tegra_drm_context *);
+	u32 (*get_waitbases)(struct tegra_drm_context *);
+	u32 (*get_modmutexes)(struct tegra_drm_context *);
+	int (*submit)(struct tegra_drm_context *,
+			struct tegra_drm_submit_args *);
+};
+
+
+struct tegra_drm_fpriv {
+	struct list_head contexts;
 };
 
+static inline struct tegra_drm_fpriv *
+tegra_drm_fpriv(struct drm_file *file_priv)
+{
+	return file_priv ? file_priv->driver_priv : NULL;
+}
+
 struct tegra_drm_client {
 	struct device *dev;
 
 	const struct tegra_drm_client_ops *ops;
 
+	u32 class;
+	struct nvhost_channel *channel;
+
 	struct list_head list;
 
 };
@@ -116,13 +144,6 @@ struct tegra_output_ops {
 			  enum drm_mode_status *status);
 };
 
-enum tegra_output_type {
-	TEGRA_OUTPUT_RGB,
-	TEGRA_OUTPUT_HDMI,
-	TEGRA_OUTPUT_TVO,
-	TEGRA_OUTPUT_DSI,
-};
-
 struct tegra_output {
 	struct device_node *of_node;
 	struct device *dev;
@@ -225,6 +246,7 @@ extern struct platform_driver tegra_hdmi_driver;
 extern struct platform_driver tegra_tvo_driver;
 extern struct platform_driver tegra_dsi_driver;
 extern struct platform_driver tegra_dc_driver;
+extern struct platform_driver tegra_gr2d_driver;
 extern struct drm_driver tegra_drm_driver;
 
 /* from dmabuf.c */
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
new file mode 100644
index 0000000..51605af
--- /dev/null
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -0,0 +1,224 @@
+/*
+ * drivers/video/tegra/host/gr2d/gr2d.c
+ *
+ * Tegra Graphics 2D
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/export.h>
+#include <linux/of.h>
+#include <drm/tegra_drm.h>
+#include <linux/nvhost.h>
+#include "drm.h"
+
+static struct tegra_drm_client gr2d_client;
+
+static int gr2d_client_init(struct tegra_drm_client *client,
+		struct drm_device *drm)
+{
+	return 0;
+}
+
+static int gr2d_client_exit(struct tegra_drm_client *client)
+{
+	return 0;
+}
+
+static int gr2d_open_channel(struct tegra_drm_client *client,
+		struct tegra_drm_context *context)
+{
+	struct nvhost_device_data *pdata = dev_get_drvdata(client->dev);
+	context->channel = nvhost_getchannel(pdata->channel);
+
+	if (!context->channel)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void gr2d_close_channel(struct tegra_drm_context *context)
+{
+	nvhost_putchannel(context->channel);
+}
+
+static u32 gr2d_get_syncpoints(struct tegra_drm_context *context)
+{
+	struct nvhost_device_data *pdata =
+		dev_get_drvdata(context->client->dev);
+	return pdata->syncpts;
+}
+
+static u32 gr2d_get_modmutexes(struct tegra_drm_context *context)
+{
+	struct nvhost_device_data *pdata =
+		dev_get_drvdata(context->client->dev);
+	return pdata->modulemutexes;
+}
+
+static int gr2d_submit(struct tegra_drm_context *context,
+		struct tegra_drm_submit_args *args)
+{
+	struct nvhost_job *job;
+	int num_cmdbufs = args->num_cmdbufs;
+	int num_relocs = args->num_relocs;
+	int num_waitchks = args->num_waitchks;
+	struct tegra_drm_cmdbuf __user *cmdbufs = args->cmdbufs;
+	struct tegra_drm_reloc __user *relocs = args->relocs;
+	struct tegra_drm_waitchk __user *waitchks = args->waitchks;
+	struct tegra_drm_syncpt_incr syncpt_incr;
+	int err;
+
+	dev_dbg(context->client->dev, "> %s(context=%p, cmdbufs=%d, relocs=%d, waitchks=%d)\n",
+			__func__, context,
+			num_cmdbufs, num_relocs, num_waitchks);
+
+	/* We don't yet support other than one syncpt_incr struct per submit */
+	if (args->num_syncpt_incrs != 1)
+		return -EINVAL;
+
+	job = nvhost_job_alloc(context->channel,
+			args->num_cmdbufs,
+			args->num_relocs,
+			args->num_waitchks);
+	if (!job)
+		return -ENOMEM;
+
+	job->num_relocs = args->num_relocs;
+	job->num_waitchk = args->num_waitchks;
+	job->clientid = (u32)args->context;
+
+	while (num_cmdbufs) {
+		struct tegra_drm_cmdbuf cmdbuf;
+		err = copy_from_user(&cmdbuf, cmdbufs, sizeof(cmdbuf));
+		if (err)
+			goto fail;
+		dev_dbg(context->client->dev, "cmdbuf: mem=%08x, words=%d, offset=%d\n",
+			cmdbuf.mem, cmdbuf.words, cmdbuf.offset);
+		nvhost_job_add_gather(job,
+				cmdbuf.mem, cmdbuf.words, cmdbuf.offset);
+		num_cmdbufs--;
+		cmdbufs++;
+	}
+
+	err = copy_from_user(job->relocarray,
+			relocs, sizeof(*relocs) * num_relocs);
+	if (err)
+		goto fail;
+
+	err = copy_from_user(job->waitchk,
+			relocs, sizeof(*waitchks) * num_waitchks);
+	if (err)
+		goto fail;
+
+	err = nvhost_job_pin(job, to_platform_device(context->client->dev));
+	if (err)
+		goto fail;
+
+	err = copy_from_user(&syncpt_incr,
+			args->syncpt_incrs, sizeof(syncpt_incr));
+	if (err)
+		goto fail;
+
+	job->syncpt_id = syncpt_incr.syncpt_id;
+	job->syncpt_incrs = syncpt_incr.syncpt_incrs;
+	job->timeout = 10000;
+	if (args->timeout && args->timeout < 10000)
+		job->timeout = args->timeout;
+
+	err = nvhost_channel_submit(job);
+	if (err)
+		goto fail_submit;
+
+	args->fence = job->syncpt_end;
+
+	nvhost_job_put(job);
+	dev_dbg(context->client->dev, "< %s(context=%p)\n", __func__, context);
+	return 0;
+
+fail_submit:
+	nvhost_job_unpin(job);
+fail:
+	nvhost_job_put(job);
+	dev_dbg(context->client->dev,
+			"< %s(context=%p) = %d\n", __func__, context, err);
+	return err;
+}
+
+static struct tegra_drm_client_ops gr2d_client_ops = {
+	.drm_init = gr2d_client_init,
+	.drm_exit = gr2d_client_exit,
+	.open_channel = gr2d_open_channel,
+	.close_channel = gr2d_close_channel,
+	.get_syncpoints = gr2d_get_syncpoints,
+	.get_modmutexes = gr2d_get_modmutexes,
+	.submit = gr2d_submit,
+};
+
+static int __devinit gr2d_probe(struct platform_device *dev)
+{
+	int err;
+	struct nvhost_device_data *pdata =
+		(struct nvhost_device_data *)dev->dev.platform_data;
+	pdata->pdev = dev;
+	platform_set_drvdata(dev, pdata);
+	err = nvhost_client_device_init(dev);
+	if (err)
+		return err;
+
+	gr2d_client.ops = &gr2d_client_ops;
+	gr2d_client.dev = &dev->dev;
+	gr2d_client.class = NV_GRAPHICS_2D_CLASS_ID;
+	return tegra_drm_register_client(&gr2d_client);
+}
+
+static int __exit gr2d_remove(struct platform_device *dev)
+{
+	/* Add clean-up */
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int gr2d_suspend(struct platform_device *dev, pm_message_t state)
+{
+	return nvhost_client_device_suspend(dev);
+}
+
+static int gr2d_resume(struct platform_device *dev)
+{
+	dev_info(&dev->dev, "resuming\n");
+	return 0;
+}
+#endif
+
+static struct of_device_id gr2d_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra20-gr2d", },
+	{ .compatible = "nvidia,tegra30-gr2d", },
+	{ },
+};
+
+struct platform_driver tegra_gr2d_driver = {
+	.probe = gr2d_probe,
+	.remove = __exit_p(gr2d_remove),
+#ifdef CONFIG_PM
+	.suspend = gr2d_suspend,
+	.resume = gr2d_resume,
+#endif
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "tegra-gr2d",
+		.of_match_table = of_match_ptr(gr2d_match),
+	}
+};
diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
new file mode 100644
index 0000000..bfc54d8
--- /dev/null
+++ b/include/drm/tegra_drm.h
@@ -0,0 +1,129 @@
+/*
+ * Copyright (c) 2012, Avionic Design GmbH
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _TEGRA_DRM_H_
+#define _TEGRA_DRM_H_
+
+enum tegra_output_type {
+	TEGRA_OUTPUT_RGB,
+	TEGRA_OUTPUT_HDMI,
+	TEGRA_OUTPUT_TVO,
+	TEGRA_OUTPUT_DSI,
+};
+
+struct tegra_gem_create {
+	uint64_t size;
+	unsigned int flags;
+	unsigned int handle;
+};
+
+#define DRM_TEGRA_GEM_CREATE		0x00
+
+#define DRM_IOCTL_TEGRA_GEM_CREATE	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_TEGRA_GEM_CREATE, struct tegra_gem_create)
+
+struct tegra_drm_syncpt_read_args {
+	__u32 id;
+	__u32 value;
+};
+
+struct tegra_drm_syncpt_incr_args {
+	__u32 id;
+};
+
+struct tegra_drm_syncpt_wait_args {
+	__u32 id;
+	__u32 thresh;
+	__s32 timeout;
+	__u32 value;
+};
+
+#define DRM_TEGRA_NO_TIMEOUT	(-1)
+
+struct tegra_drm_open_channel_args {
+	__u32 class;
+	void *context;
+};
+
+struct tegra_drm_get_channel_param_args {
+	void *context;
+	__u32 value;
+};
+
+struct tegra_drm_syncpt_incr {
+	__u32 syncpt_id;
+	__u32 syncpt_incrs;
+};
+
+struct tegra_drm_cmdbuf {
+	__u32 mem;
+	__u32 offset;
+	__u32 words;
+};
+
+struct tegra_drm_reloc {
+	__u32 cmdbuf_mem;
+	__u32 cmdbuf_offset;
+	__u32 target;
+	__u32 target_offset;
+	__u32 shift;
+};
+
+struct tegra_drm_waitchk {
+	__u32 mem;
+	__u32 offset;
+	__u32 syncpt_id;
+	__u32 thresh;
+};
+
+struct tegra_drm_submit_args {
+	void *context;
+	__u32 num_syncpt_incrs;
+	__u32 num_cmdbufs;
+	__u32 num_relocs;
+	__u32 submit_version;
+	__u32 num_waitchks;
+	__u32 waitchk_mask;
+	__u32 timeout;
+	struct tegra_drm_syncpt_incrs *syncpt_incrs;
+	struct tegra_drm_cmdbuf *cmdbufs;
+	struct tegra_drm_reloc *relocs;
+	struct tegra_drm_waitchk *waitchks;
+
+	__u32 pad[5];		/* future expansion */
+	__u32 fence;		/* Return value */
+};
+
+#define DRM_TEGRA_DRM_SYNCPT_READ 0x01
+#define DRM_TEGRA_DRM_SYNCPT_INCR 0x02
+#define DRM_TEGRA_DRM_SYNCPT_WAIT 0x03
+#define DRM_TEGRA_DRM_OPEN_CHANNEL 0x04
+#define DRM_TEGRA_DRM_CLOSE_CHANNEL 0x05
+#define DRM_TEGRA_DRM_GET_SYNCPOINTS 0x06
+#define DRM_TEGRA_DRM_GET_MODMUTEXES 0x07
+#define DRM_TEGRA_DRM_SUBMIT 0x08
+
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_READ DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_READ, struct tegra_drm_syncpt_read_args)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_INCR DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_INCR, struct tegra_drm_syncpt_incr_args)
+#define DRM_IOCTL_TEGRA_DRM_SYNCPT_WAIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_WAIT, struct tegra_drm_syncpt_wait_args)
+#define DRM_IOCTL_TEGRA_DRM_OPEN_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_OPEN_CHANNEL, struct tegra_drm_open_channel_args)
+#define DRM_IOCTL_TEGRA_DRM_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_CLOSE_CHANNEL, struct tegra_drm_open_channel_args)
+#define DRM_IOCTL_TEGRA_DRM_GET_SYNCPOINTS DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GET_SYNCPOINTS, struct tegra_drm_get_channel_param_args)
+#define DRM_IOCTL_TEGRA_DRM_GET_MODMUTEXES DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GET_MODMUTEXES, struct tegra_drm_get_channel_param_args)
+#define DRM_IOCTL_TEGRA_DRM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SUBMIT, struct tegra_drm_submit_args)
+
+#endif
-- 
1.7.9.5

