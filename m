Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1ASJx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:53:57 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:57022
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752954Ab1ASJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:53:55 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Initialise ring vfuncs for old DRI paths
Date: Wed, 19 Jan 2011 09:53:44 +0000
Message-Id: <1295430824-31213-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110119032449.GA20598@gondor.apana.org.au>
References: <20110119032449.GA20598@gondor.apana.org.au>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We weren't setting up the vfunc table when initialising the old DRI
ringbuffer, leading to such OOPSes as:

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
 drivers/gpu/drm/i915/i915_dma.c         |   25 +++++--------------
 drivers/gpu/drm/i915/intel_ringbuffer.c |   38 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.h |    3 ++
 3 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 76f2df7..2a45920 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -153,7 +153,7 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
-	struct intel_ring_buffer *ring = LP_RING(dev_priv);
+	int ret;
 
 	master_priv->sarea = drm_getsarea(dev);
 	if (master_priv->sarea) {
@@ -164,33 +164,22 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 	}
 
 	if (init->ring_size != 0) {
-		if (ring->obj != NULL) {
+		if (LP_RING(dev_priv)->obj != NULL) {
 			i915_dma_cleanup(dev);
 			DRM_ERROR("Client tried to initialize ringbuffer in "
 				  "GEM mode\n");
 			return -EINVAL;
 		}
 
-		ring->size = init->ring_size;
-
-		ring->map.offset = init->ring_start;
-		ring->map.size = init->ring_size;
-		ring->map.type = 0;
-		ring->map.flags = 0;
-		ring->map.mtrr = 0;
-
-		drm_core_ioremap_wc(&ring->map, dev);
-
-		if (ring->map.handle == NULL) {
+		ret = intel_render_ring_init_dri(dev,
+						 init->ring_start,
+						 init->ring_size);
+		if (ret) {
 			i915_dma_cleanup(dev);
-			DRM_ERROR("can not ioremap virtual address for"
-				  " ring buffer\n");
-			return -ENOMEM;
+			return ret;
 		}
 	}
 
-	ring->virtual_start = (void __force __iomem *)ring->map.handle;
-
 	dev_priv->cpp = init->cpp;
 	dev_priv->back_offset = init->back_offset;
 	dev_priv->front_offset = init->front_offset;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 03e3370..363f50b 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1291,6 +1291,44 @@ int intel_init_render_ring_buffer(struct drm_device *dev)
 	return intel_init_ring_buffer(dev, ring);
 }
 
+int intel_render_ring_init_dri(struct drm_device *dev, u64 start, u32 size)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_ring_buffer *ring = &dev_priv->ring[RCS];
+
+	*ring = render_ring;
+	if (INTEL_INFO(dev)->gen >= 6) {
+		ring->add_request = gen6_add_request;
+		ring->irq_get = gen6_render_ring_get_irq;
+		ring->irq_put = gen6_render_ring_put_irq;
+	} else if (IS_GEN5(dev)) {
+		ring->add_request = pc_render_add_request;
+		ring->get_seqno = pc_render_get_seqno;
+	}
+
+	ring->dev = dev;
+	ring->size = size;
+	ring->effective_size = ring->size;
+	if (IS_I830(ring->dev))
+		ring->effective_size -= 128;
+
+	ring->map.offset = start;
+	ring->map.size = size;
+	ring->map.type = 0;
+	ring->map.flags = 0;
+	ring->map.mtrr = 0;
+
+	drm_core_ioremap_wc(&ring->map, dev);
+	if (ring->map.handle == NULL) {
+		DRM_ERROR("can not ioremap virtual address for"
+			  " ring buffer\n");
+		return -ENOMEM;
+	}
+
+	ring->virtual_start = (void __force __iomem *)ring->map.handle;
+	return 0;
+}
+
 int intel_init_bsd_ring_buffer(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index d5911aa..525c04e 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -187,4 +187,7 @@ int intel_init_blt_ring_buffer(struct drm_device *dev);
 u32 intel_ring_get_active_head(struct intel_ring_buffer *ring);
 void intel_ring_setup_status_page(struct intel_ring_buffer *ring);
 
+/* DRI warts */
+int intel_render_ring_init_dri(struct drm_device *dev, u64 start, u32 size);
+
 #endif /* _INTEL_RINGBUFFER_H_ */
-- 
1.7.2.3

