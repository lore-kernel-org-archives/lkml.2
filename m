Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2LZKIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 05:08:19 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46517 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2LZKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 05:08:16 -0500
Message-ID: <50DAC678.5060601@gmail.com>
Date: Wed, 26 Dec 2012 17:42:16 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: thierry.reding@avionic-design.de, airlied@linux.ie, dev@lynxeye.de,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Terje,

I applied your patches on top of upstream 1224 kernel. Then I read the
codes. So here is my review comments(I use "git diff" to print out,
check below). I admit it's easy for me to not need to find the
corresponding lines in your 8 patch mails, but I've no idea whether it
is ok for you. If this makes you not feeling good, I'll do this in old
ways. Basically, I think in this diff output, there are filename/line
number/function name, so it should not be a hard work for you to
understand my comments.

P.S: I haven't finished the review so here is what I found today.

diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index a936902..28954b3 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -247,6 +247,10 @@ static int __devinit gr2d_probe(struct
platform_device *dev)
 {
 	int err;
 	struct gr2d *gr2d = NULL;
+	/* Cause drm_device is created in host1x driver. So
+	   if host1x drivers loads after tegradrm, then in this
+	   gr2d_probe function, this "drm_device" will be NULL.
+	   How can we handle this? Defer driver probe? */
 	struct platform_device *drm_device =
 		host1x_drm_device(to_platform_device(dev->dev.parent));
 	struct tegradrm *tegradrm = platform_get_drvdata(drm_device);
@@ -273,6 +277,11 @@ static int __devinit gr2d_probe(struct
platform_device *dev)

 	gr2d->syncpt = host1x_syncpt_alloc(dev, 0);
 	if (!gr2d->syncpt) {
+		/* Do we really need this?
+		   After "host1x_channel_alloc", the refcount of this
+		   channel is 0. So calling host1x_channel_put here will
+		   make the refcount going to negative.
+		   I suppose we should call "host1x_free_channel" here. */
 		host1x_channel_put(gr2d->channel);
 		return -ENOMEM;
 	}
@@ -284,6 +293,7 @@ static int __devinit gr2d_probe(struct
platform_device *dev)

 	err = tegra_drm_register_client(tegradrm, &gr2d->client);
 	if (err)
+		/* Add "host1x_free_channel" */
 		return err;

 	platform_set_drvdata(dev, gr2d);
diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
index 3705cae..ed83b9e 100644
--- a/drivers/gpu/host1x/channel.c
+++ b/drivers/gpu/host1x/channel.c
@@ -95,6 +95,9 @@ struct host1x_channel *host1x_channel_alloc(struct
platform_device *pdev)
 	int max_channels = host1x->info.nb_channels;
 	int err;

+	/* Is it necessary to add mutex protection here?
+	   I'm just wondering in a smp system, multiple host1x clients
+	   may try to alloc their channels simultaneously... */
 	if (chindex > max_channels)
 		return NULL;

diff --git a/drivers/gpu/host1x/debug.c b/drivers/gpu/host1x/debug.c
index 86d5c70..f2bd5aa 100644
--- a/drivers/gpu/host1x/debug.c
+++ b/drivers/gpu/host1x/debug.c
@@ -164,6 +164,10 @@ static const struct file_operations
host1x_debug_fops = {

 void host1x_debug_init(struct host1x *host1x)
 {
+	/* I think it's better to set this directory name the same with
+	   the driver's name -- defined in dev.c:
+	   #define DRIVER_NAME	"tegra-host1x"
+	   */
 	struct dentry *de = debugfs_create_dir("tegra_host", NULL);

 	if (!de)
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 07e8813..01ed10d 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -38,6 +38,7 @@

 struct host1x *host1x;

+/* Called by drm unlocked ioctl function. So do we need a lock here? */
 void host1x_syncpt_incr_byid(u32 id)
 {
 	struct host1x_syncpt *sp = host1x->syncpt + id;
@@ -52,6 +53,7 @@ u32 host1x_syncpt_read_byid(u32 id)
 }
 EXPORT_SYMBOL(host1x_syncpt_read_byid);

+/* Called by drm unlocked ioctl function. So do we need a lock here? */
 int host1x_syncpt_wait_byid(u32 id, u32 thresh, long timeout, u32 *value)
 {
 	struct host1x_syncpt *sp = host1x->syncpt + id;
@@ -161,6 +163,8 @@ static int host1x_probe(struct platform_device *dev)

 	err = host1x_alloc_resources(host);
 	if (err) {
+		/* We don't have chip_ops right now, so here the
+		   error message is somewhat improper */
 		dev_err(&dev->dev, "failed to init chip support\n");
 		goto fail;
 	}
@@ -175,6 +179,14 @@ static int host1x_probe(struct platform_device *dev)
 	if (!host->syncpt)
 		goto fail;

+	/* I suggest create a dedicate function for initializing nop sp.
+	   First this "_host1x_syncpt_alloc" looks like an internal/static
+	   function.
+	   Then actually "host1x_syncpt_alloc" & "_host1x_syncpt_alloc" all
+	   serve host1x client(e.g: gr2d) so it's not suitable to use them
+	   for nop sp.
+	   Just create a wrapper function to call _host1x_syncpt_alloc is OK.
+	   This will make the code more readable. */
 	host->nop_sp = _host1x_syncpt_alloc(host, NULL, 0);
 	if (!host->nop_sp)
 		goto fail;
@@ -191,6 +203,7 @@ static int host1x_probe(struct platform_device *dev)
 	}

 	err = clk_prepare_enable(host->clk);
+	/* Add a dev_err here */
 	if (err < 0)
 		goto fail;

@@ -209,9 +222,12 @@ static int host1x_probe(struct platform_device *dev)
 	return 0;

 fail:
+	/* host1x->syncpt isn't released here... */
+	/* host1x->intr isn't release here... */
+	/* Remove debugfs stuffs? */
 	host1x_syncpt_free(host->nop_sp);
 	host1x_unregister_drm_device(host);
-	kfree(host);
+	kfree(host); /* not necessary*/
 	return err;
 }

@@ -222,6 +238,7 @@ static int __exit host1x_remove(struct
platform_device *dev)
 	host1x_syncpt_deinit(host);
 	host1x_unregister_drm_device(host);
 	clk_disable_unprepare(host->clk);
+	/* Remove debugfs stuffs? */
 	return 0;
 }

diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index 05f8544..58f4c71 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -36,6 +36,7 @@ struct platform_device;
 struct output;

 struct host1x_channel_ops {
+	/* Seems no one uses this member. Remove it. */
 	const char *soc_name;
 	int (*init)(struct host1x_channel *,
 		    struct host1x *,
@@ -125,12 +126,18 @@ struct host1x {
 	struct host1x_syncpt *syncpt;
 	struct host1x_intr intr;
 	struct platform_device *dev;
+
+	/* Seems no one uses this. Remove it. */
 	atomic_t clientid;
 	struct host1x_device_info info;
 	struct clk *clk;

+	/* Put some comments for this member.
+	   For guys who're not familiar with nop sp, I think they'll
+	   definitely get confused about this. */
 	struct host1x_syncpt *nop_sp;

+	/* Seems no one uses this member. Remove it. */
 	const char *soc_name;
 	struct host1x_channel_ops channel_op;
 	struct host1x_cdma_ops cdma_op;
@@ -140,6 +147,7 @@ struct host1x {
 	struct host1x_intr_ops intr_op;

 	struct host1x_channel chlist;
+
 	int allocated_channels;

 	struct dentry *debugfs;
diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
index efcb9be..e112001 100644
--- a/drivers/gpu/host1x/intr.c
+++ b/drivers/gpu/host1x/intr.c
@@ -329,8 +329,13 @@ void host1x_intr_deinit(struct host1x_intr *intr)
 void host1x_intr_start(struct host1x_intr *intr, u32 hz)
 {
 	struct host1x *host1x = intr_to_host1x(intr);
+
+	/* Why we need to lock here? Seems like this function is
+	   called by host1x's probe only. */
 	mutex_lock(&intr->mutex);

+	/* "init_host_sync" has already been called in function
+	   host1x_intr_init. Remove this line. */
 	host1x->intr_op.init_host_sync(intr);
 	host1x->intr_op.set_host_clocks_per_usec(intr,
 			DIV_ROUND_UP(hz, 1000000));
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 07cbca5..9a234ad 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -309,6 +309,8 @@ struct host1x_syncpt *host1x_syncpt_init(struct
host1x *host)
 	struct host1x_syncpt *syncpt, *sp;
 	int i;

+	/* Consider devm_kzalloc here. Then you can forget the release
+	   stuffs about this "syncpt". */
 	syncpt = sp = kzalloc(sizeof(struct host1x_syncpt) * host->info.nb_pts,
 		GFP_KERNEL);
 	if (!syncpt)

Mark
On 12/21/2012 07:39 PM, Terje Bergstrom wrote:
> This set of patches adds support for Tegra20 and Tegra30 host1x and
> 2D. It is based on linux-next-20121220.
> 
> The fourth version has only few changes compared to previous version:
>  * Fixed some sparse warnings
>  * Fixed host1x Makefile to allow building as module
>  * Fixed host1x module unload
>  * Fixed tegradrm unload sequence
>  * host1x creates DRM dummy device and tegradrm uses it for storing
>    DRM related data.
> 
> Some of the issues left open:
>  * Register definitions still use static inline. There has been a
>    debate about code style versus ability to use compiler type
>    checking and code coverage analysis. There was no conclusion, so
>    I left it as was.
>  * Uses still CMA helpers. IOMMU support will replace CMA with host1x
>    specific allocator.
> 
> host1x is the driver that controls host1x hardware. It supports
> host1x command channels, synchronization, and memory management. It
> is sectioned into logical driver under drivers/gpu/host1x and
> physical driver under drivers/host1x/hw. The physical driver is
> compiled with the hardware headers of the particular host1x version.
> 
> The hardware units are described (briefly) in the Tegra2 TRM. Wiki
> page https://gitorious.org/linux-tegra-drm/pages/Host1xIntroduction
> also contains a short description of the functionality.
> 
> The patch set removes responsibility of host1x from tegradrm. At the
> same time, it moves all drm related infrastructure in
> drivers/gpu/drm/tegra/host1x.c to drm.c. To replace the host1x
> central device, host1x creates a dummy device for tegradrm to hang
> global data to. This is a break in responsibility split of tegradrm
> taking care of DRM and host1x driver taking care of host1x and
> clients, but this structure was insisted. I've kept creation of dummy
> device as a separate patch to illustrate the alternatives. It can be
> later squashed into other patches.
> 
> The patch set adds 2D driver to tegradrm, which uses host1x for
> communicating with host1x to access sync points and channels. We
> expect to use the same infrastructure for other host1x clients, so
> we have kept host1x and tegradrm separate.
> 
> The patch set also adds user space API to tegradrm for accessing
> host1x and 2D.
> 
> Arto Merilainen (1):
>   drm: tegra: Remove redundant host1x
> 
> Terje Bergstrom (7):
>   gpu: host1x: Add host1x driver
>   gpu: host1x: Add syncpoint wait and interrupts
>   gpu: host1x: Add channel support
>   gpu: host1x: Add debug support
>   ARM: tegra: Add board data and 2D clocks
>   drm: tegra: Add gr2d device
>   gpu: host1x: Register DRM dummy device
> 
>  arch/arm/mach-tegra/board-dt-tegra20.c      |    1 +
>  arch/arm/mach-tegra/board-dt-tegra30.c      |    1 +
>  arch/arm/mach-tegra/tegra20_clocks_data.c   |    2 +-
>  arch/arm/mach-tegra/tegra30_clocks_data.c   |    1 +
>  drivers/gpu/Makefile                        |    1 +
>  drivers/gpu/drm/tegra/Kconfig               |    2 +-
>  drivers/gpu/drm/tegra/Makefile              |    2 +-
>  drivers/gpu/drm/tegra/dc.c                  |   26 +-
>  drivers/gpu/drm/tegra/drm.c                 |  433 ++++++++++++++++++-
>  drivers/gpu/drm/tegra/drm.h                 |   72 ++--
>  drivers/gpu/drm/tegra/fb.c                  |   17 +-
>  drivers/gpu/drm/tegra/gr2d.c                |  309 ++++++++++++++
>  drivers/gpu/drm/tegra/hdmi.c                |   30 +-
>  drivers/gpu/drm/tegra/host1x.c              |  325 --------------
>  drivers/gpu/host1x/Kconfig                  |   28 ++
>  drivers/gpu/host1x/Makefile                 |   17 +
>  drivers/gpu/host1x/cdma.c                   |  475 ++++++++++++++++++++
>  drivers/gpu/host1x/cdma.h                   |  107 +++++
>  drivers/gpu/host1x/channel.c                |  137 ++++++
>  drivers/gpu/host1x/channel.h                |   64 +++
>  drivers/gpu/host1x/cma.c                    |  117 +++++
>  drivers/gpu/host1x/cma.h                    |   43 ++
>  drivers/gpu/host1x/debug.c                  |  207 +++++++++
>  drivers/gpu/host1x/debug.h                  |   49 +++
>  drivers/gpu/host1x/dev.c                    |  242 +++++++++++
>  drivers/gpu/host1x/dev.h                    |  167 ++++++++
>  drivers/gpu/host1x/drm.c                    |   51 +++
>  drivers/gpu/host1x/drm.h                    |   25 ++
>  drivers/gpu/host1x/hw/Makefile              |    6 +
>  drivers/gpu/host1x/hw/cdma_hw.c             |  480 +++++++++++++++++++++
>  drivers/gpu/host1x/hw/cdma_hw.h             |   37 ++
>  drivers/gpu/host1x/hw/channel_hw.c          |  147 +++++++
>  drivers/gpu/host1x/hw/debug_hw.c            |  399 +++++++++++++++++
>  drivers/gpu/host1x/hw/host1x01.c            |   46 ++
>  drivers/gpu/host1x/hw/host1x01.h            |   25 ++
>  drivers/gpu/host1x/hw/host1x01_hardware.h   |  150 +++++++
>  drivers/gpu/host1x/hw/hw_host1x01_channel.h |   98 +++++
>  drivers/gpu/host1x/hw/hw_host1x01_sync.h    |  179 ++++++++
>  drivers/gpu/host1x/hw/hw_host1x01_uclass.h  |  130 ++++++
>  drivers/gpu/host1x/hw/intr_hw.c             |  178 ++++++++
>  drivers/gpu/host1x/hw/syncpt_hw.c           |  157 +++++++
>  drivers/gpu/host1x/intr.c                   |  377 ++++++++++++++++
>  drivers/gpu/host1x/intr.h                   |  106 +++++
>  drivers/gpu/host1x/job.c                    |  618 +++++++++++++++++++++++++++
>  drivers/gpu/host1x/memmgr.c                 |  174 ++++++++
>  drivers/gpu/host1x/memmgr.h                 |   53 +++
>  drivers/gpu/host1x/syncpt.c                 |  398 +++++++++++++++++
>  drivers/gpu/host1x/syncpt.h                 |  134 ++++++
>  drivers/video/Kconfig                       |    2 +
>  include/drm/tegra_drm.h                     |  131 ++++++
>  include/linux/host1x.h                      |  217 ++++++++++
>  include/trace/events/host1x.h               |  296 +++++++++++++
>  52 files changed, 7095 insertions(+), 394 deletions(-)
>  create mode 100644 drivers/gpu/drm/tegra/gr2d.c
>  delete mode 100644 drivers/gpu/drm/tegra/host1x.c
>  create mode 100644 drivers/gpu/host1x/Kconfig
>  create mode 100644 drivers/gpu/host1x/Makefile
>  create mode 100644 drivers/gpu/host1x/cdma.c
>  create mode 100644 drivers/gpu/host1x/cdma.h
>  create mode 100644 drivers/gpu/host1x/channel.c
>  create mode 100644 drivers/gpu/host1x/channel.h
>  create mode 100644 drivers/gpu/host1x/cma.c
>  create mode 100644 drivers/gpu/host1x/cma.h
>  create mode 100644 drivers/gpu/host1x/debug.c
>  create mode 100644 drivers/gpu/host1x/debug.h
>  create mode 100644 drivers/gpu/host1x/dev.c
>  create mode 100644 drivers/gpu/host1x/dev.h
>  create mode 100644 drivers/gpu/host1x/drm.c
>  create mode 100644 drivers/gpu/host1x/drm.h
>  create mode 100644 drivers/gpu/host1x/hw/Makefile
>  create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/cdma_hw.h
>  create mode 100644 drivers/gpu/host1x/hw/channel_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/debug_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/host1x01.c
>  create mode 100644 drivers/gpu/host1x/hw/host1x01.h
>  create mode 100644 drivers/gpu/host1x/hw/host1x01_hardware.h
>  create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_channel.h
>  create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_sync.h
>  create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_uclass.h
>  create mode 100644 drivers/gpu/host1x/hw/intr_hw.c
>  create mode 100644 drivers/gpu/host1x/hw/syncpt_hw.c
>  create mode 100644 drivers/gpu/host1x/intr.c
>  create mode 100644 drivers/gpu/host1x/intr.h
>  create mode 100644 drivers/gpu/host1x/job.c
>  create mode 100644 drivers/gpu/host1x/memmgr.c
>  create mode 100644 drivers/gpu/host1x/memmgr.h
>  create mode 100644 drivers/gpu/host1x/syncpt.c
>  create mode 100644 drivers/gpu/host1x/syncpt.h
>  create mode 100644 include/drm/tegra_drm.h
>  create mode 100644 include/linux/host1x.h
>  create mode 100644 include/trace/events/host1x.h
> 
