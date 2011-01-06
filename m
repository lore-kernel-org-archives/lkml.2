Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1AFFDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 00:03:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46699 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab1AFFDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 00:03:15 -0500
Date: Thu, 6 Jan 2011 16:03:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (drm tree
 related)
Message-Id: <20110106160309.7c8e0d16.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpu/drm/radeon/radeon_device.c: In function 'radeon_device_init':
drivers/gpu/drm/radeon/radeon_device.c:783: error: too many arguments to function 'vga_switcheroo_register_client'

The i386 defconfig build also failed like this:

drivers/gpu/drm/i915/i915_dma.c: In function 'i915_load_modeset_init':
drivers/gpu/drm/i915/i915_dma.c:1239: error: too many arguments to function 'vga_switcheroo_register_client'

Caused by commit 8d608aa6295242fe4c4b6105b8c59c6a5b232d89
("vga_switcheroo: add reprobe hook for fbcon to recheck connected
outputs") which forgot to update the prototype of
vga_switcheroo_register_client() for the non CONFIG_VGA_SWITCHEROO case.

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Jan 2011 15:58:44 +1100
Subject: [PATCH] vga_switcheroo: fix prototype for non CONFIG_VGA_SWITCHEROO build

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/vga_switcheroo.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
index f80fa9d..4b9a7f5 100644
--- a/include/linux/vga_switcheroo.h
+++ b/include/linux/vga_switcheroo.h
@@ -49,6 +49,7 @@ int vga_switcheroo_process_delayed_switch(void);
 static inline void vga_switcheroo_unregister_client(struct pci_dev *dev) {}
 static inline int vga_switcheroo_register_client(struct pci_dev *dev,
 					  void (*set_gpu_state)(struct pci_dev *dev, enum vga_switcheroo_state),
+					  void (*reprobe)(struct pci_dev *dev),
 					  bool (*can_switch)(struct pci_dev *dev)) { return 0; }
 static inline void vga_switcheroo_client_fb_set(struct pci_dev *dev, struct fb_info *info) {}
 static inline int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler) { return 0; }
-- 
1.7.2.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
