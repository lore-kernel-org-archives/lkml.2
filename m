Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1ARRYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:24:22 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:50194
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753020Ab1ARRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:24:20 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Correctly test for an initialised ring for dri1
Date: Tue, 18 Jan 2011 17:24:09 +0000
Message-Id: <1295371449-22979-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110118115701.GA11952@gondor.apana.org.au>
References: <20110118115701.GA11952@gondor.apana.org.au>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dri1 code was broken by the introduction of multiple ringbuffers in
that it failed to correctly check for the initialisation of those before
use. The result was OOPSes such as:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 10c441067 PUD 1185e5067 PMD 0
Oops: 0010 [#1] PREEMPT SMP
last sysfs file: /sys/class/dmi/id/chassis_asset_tag
CPU 3
Modules linked in: i915 drm_kms_helper drm fb fbdev i2c_algo_bit
cfbcopyarea video backlight output cfbimgblt cfbfillrect autofs4 ipv6
nfs lockd fscache nfs_acl auth_rpcgss sunrpc coretemp hwmon_vid mousedev
usbhid hid option usb_wwan snd_hda_codec_via asus_atk0110 atl1e
usbserial snd_hda_intel snd_hda_codec firmware_class snd_hwdep snd_pcm
snd_seq snd_timer snd_seq_device processor parport_pc thermal snd
thermal_sys parport 8250_pnp button rng_core rtc_cmos shpchp hwmon
rtc_core ehci_hcd pci_hotplug uhci_hcd soundcore tpm_tis i2c_i801
rtc_lib tpm serio_raw snd_page_alloc tpm_bios i2c_core usbcore psmouse
intel_agp sg pcspkr sr_mod evdev cdrom ext3 jbd mbcache dm_mod sd_mod
ata_piix libata scsi_mod unix
Jan 18 15:49:29 lithui kernel:
Pid: 3605, comm: Xorg Not tainted 2.6.36.2 #5 P5KPL-CM/System Product
Name
RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
RSP: 0018:ffff8801150d1d40  EFLAGS: 00010202
RAX: 000000000001ffff RBX: ffff88011a011b00 RCX: 000000000001a704
RDX: ffff880118566028 RSI: ffff880118566028 RDI: ffff880117876800
RBP: ffff8801150d1d48 R08: ffff8801195fe300 R09: 00000000c0086444
R10: 0000000000000001 R11: 0000000000003206 R12: ffff880117876800
R13: ffff880118566000 R14: ffff880117876820 R15: ffff8801150d1df8
FS:  00007f1038d456e0(0000) GS:ffff880001780000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001187e7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process Xorg (pid: 3605, threadinfo ffff8801150d0000, task
ffff88011b016e40)
Stack:
ffffffffa043b8e6 ffff8801150d1d98 ffffffffa041768b dead000000000000
<0> 0000000000000048 00007f1023f2a000 0000000000000044 0000000000000008
<0> ffff88010d26bd80 ffff880117876800 ffff8801150d1df8 ffff8801150d1ea8
Call Trace:
[<ffffffffa043b8e6>] ? intel_ring_advance+0x16/0x20 [i915]
[<ffffffffa041768b>] i915_irq_emit+0x15b/0x240 [i915]
[<ffffffffa03ea7b1>] drm_ioctl+0x1f1/0x460 [drm]
[<ffffffffa0417530>] ? i915_irq_emit+0x0/0x240 [i915]
[<ffffffff810dd8f1>] ? do_sync_read+0xd1/0x120
[<ffffffff81025b1f>] ? do_page_fault+0x1df/0x3d0
[<ffffffff810ed5c7>] do_vfs_ioctl+0x97/0x550
[<ffffffff8115c2ea>] ? security_file_permission+0x7a/0x90
[<ffffffff810edb19>] sys_ioctl+0x99/0xa0
[<ffffffff810024ab>] system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<(null)>] (null)
RSP <ffff8801150d1d40>
CR2: 0000000000000000

Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=29153
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=23172
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_dma.c |   20 ++++++++++++++++----
 drivers/gpu/drm/i915/i915_drv.h |   12 ------------
 drivers/gpu/drm/i915/i915_irq.c |    4 ++--
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 76f2df7..dff11ebe 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -583,7 +583,10 @@ static int i915_flush_ioctl(struct drm_device *dev, void *data,
 {
 	int ret;
 
-	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
+	if (LP_RING(dev->dev_private)->obj == NULL)
+		return -EINVAL;
+
+	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	mutex_lock(&dev->struct_mutex);
 	ret = i915_quiescent(dev);
@@ -603,6 +606,9 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 	int ret;
 	struct drm_clip_rect *cliprects = NULL;
 
+	if (LP_RING(dev->dev_private)->obj == NULL)
+		return -EINVAL;
+
 	if (!dev_priv->allow_batchbuffer) {
 		DRM_ERROR("Batchbuffer ioctl disabled\n");
 		return -EINVAL;
@@ -611,7 +617,7 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 	DRM_DEBUG_DRIVER("i915 batchbuffer, start %x used %d cliprects %d\n",
 			batch->start, batch->used, batch->num_cliprects);
 
-	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
+	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	if (batch->num_cliprects < 0)
 		return -EINVAL;
@@ -657,10 +663,13 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 	void *batch_data;
 	int ret;
 
+	if (LP_RING(dev->dev_private)->obj == NULL)
+		return -EINVAL;
+
 	DRM_DEBUG_DRIVER("i915 cmdbuffer, buf %p sz %d cliprects %d\n",
 			cmdbuf->buf, cmdbuf->sz, cmdbuf->num_cliprects);
 
-	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
+	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	if (cmdbuf->num_cliprects < 0)
 		return -EINVAL;
@@ -716,9 +725,12 @@ static int i915_flip_bufs(struct drm_device *dev, void *data,
 {
 	int ret;
 
+	if (LP_RING(dev->dev_private)->obj == NULL)
+		return -EINVAL;
+
 	DRM_DEBUG_DRIVER("%s\n", __func__);
 
-	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
+	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	mutex_lock(&dev->struct_mutex);
 	ret = i915_dispatch_flip(dev);
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 52ceae5..206e781 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1297,18 +1297,6 @@ extern void intel_display_print_error_state(struct seq_file *m,
 #define ADVANCE_LP_RING() \
 	intel_ring_advance(LP_RING(dev_priv))
 
-/**
- * Lock test for when it's just for synchronization of ring access.
- *
- * In that case, we don't need to do it when GEM is initialized as nobody else
- * has access to the ring.
- */
-#define RING_LOCK_TEST_WITH_RETURN(dev, file) do {			\
-	if (LP_RING(dev->dev_private)->obj == NULL)			\
-		LOCK_TEST_WITH_RETURN(dev, file);			\
-} while (0)
-
-
 #define __i915_read(x, y) \
 static inline u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
 	u##x val = read##y(dev_priv->regs + reg); \
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 46d649b..19a58bd 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1302,12 +1302,12 @@ int i915_irq_emit(struct drm_device *dev, void *data,
 	drm_i915_irq_emit_t *emit = data;
 	int result;
 
-	if (!dev_priv || !LP_RING(dev_priv)->virtual_start) {
+	if (!dev_priv || !LP_RING(dev_priv)->obj) {
 		DRM_ERROR("called with no initialization\n");
 		return -EINVAL;
 	}
 
-	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
+	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	mutex_lock(&dev->struct_mutex);
 	result = i915_emit_irq(dev);
-- 
1.7.2.3

