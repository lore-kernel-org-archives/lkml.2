Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1BAWlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:41:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40417 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1BAWlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aATEEmLpZUxaS4eoalGIyhsc+vjv+wPY3/2i8Ew63hI2pg7kVBiQ9jQwS3joXEz9DG
         hjM4x4bz7n2w2iU3v28YoZxIlq5BcIg+Ubm5JGDq20rEayHF/DdohMYDsVLIyKTfPRxH
         rSReao63gHUxSIQ2nWO4FcJc205Ms7C11s/U8=
Date: Wed, 2 Feb 2011 00:41:47 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com
Subject: 2.6.38-rc3: nouveau nv50 screen freeze
Message-ID: <20110201224147.GA4739@p183.telecom.by>
References: <AANLkTik4Ko==G5s3WR8HT3ALW_Yf6ybmC78=VgrS91G6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik4Ko==G5s3WR8HT3ALW_Yf6ybmC78=VgrS91G6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nv50 (GeForce 8800 GTX) is broken.
No switching to high-resolution fbcon occurs, screen freezes
with 80x25 mode right before the switch (PCI bridge info in my case).

Otherwise, box boots normally, allowing blind reboot.

6d86951a45013ac5b060c5e6307b11b7c685c76f is the first bad commit
commit 6d86951a45013ac5b060c5e6307b11b7c685c76f
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Dec 8 11:19:30 2010 +1000

    drm/nvc0: initial support for tiled buffer objects
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 5dc639e..74d0ef4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -120,9 +120,6 @@ nouveau_bo_new(struct drm_device *dev, struct nouveau_channel *chan,
 	align >>= PAGE_SHIFT;
 
 	if (!nvbo->no_vm && dev_priv->chan_vm) {
-		if (dev_priv->card_type == NV_C0)
-			page_shift = 12;
-
 		ret = nouveau_vm_get(dev_priv->chan_vm, size, page_shift,
 				     NV_MEM_ACCESS_RW, &nvbo->vma);
 		if (ret) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_dma.h b/drivers/gpu/drm/nouveau/nouveau_dma.h
index c118a33..c36f176 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dma.h
+++ b/drivers/gpu/drm/nouveau/nouveau_dma.h
@@ -77,7 +77,8 @@ enum {
 	/* G80+ display objects */
 	NvEvoVRAM	= 0x01000000,
 	NvEvoFB16	= 0x01000001,
-	NvEvoFB32	= 0x01000002
+	NvEvoFB32	= 0x01000002,
+	NvEvoVRAM_LP	= 0x01000003
 };
 
 #define NV_MEMORY_TO_MEMORY_FORMAT                                    0x00000039
diff --git a/drivers/gpu/drm/nouveau/nv50_crtc.c b/drivers/gpu/drm/nouveau/nv50_crtc.c
index 2c346f7..9023c4d 100644
--- a/drivers/gpu/drm/nouveau/nv50_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv50_crtc.c
@@ -115,15 +115,16 @@ nv50_crtc_blank(struct nouveau_crtc *nv_crtc, bool blanked)
 		OUT_RING(evo, 0);
 		BEGIN_RING(evo, 0, NV50_EVO_CRTC(index, FB_DMA), 1);
 		if (dev_priv->chipset != 0x50)
-			if (nv_crtc->fb.tile_flags == 0x7a00)
+			if (nv_crtc->fb.tile_flags == 0x7a00 ||
+			    nv_crtc->fb.tile_flags == 0xfe00)
 				OUT_RING(evo, NvEvoFB32);
 			else
 			if (nv_crtc->fb.tile_flags == 0x7000)
 				OUT_RING(evo, NvEvoFB16);
 			else
-				OUT_RING(evo, NvEvoVRAM);
+				OUT_RING(evo, NvEvoVRAM_LP);
 		else
-			OUT_RING(evo, NvEvoVRAM);
+			OUT_RING(evo, NvEvoVRAM_LP);
 	}
 
 	nv_crtc->fb.blanked = blanked;
@@ -555,13 +556,14 @@ nv50_crtc_do_mode_set_base(struct drm_crtc *crtc,
 			return ret;
 
 		BEGIN_RING(evo, 0, NV50_EVO_CRTC(nv_crtc->index, FB_DMA), 1);
-		if (nv_crtc->fb.tile_flags == 0x7a00)
+		if (nv_crtc->fb.tile_flags == 0x7a00 ||
+		    nv_crtc->fb.tile_flags == 0xfe00)
 			OUT_RING(evo, NvEvoFB32);
 		else
 		if (nv_crtc->fb.tile_flags == 0x7000)
 			OUT_RING(evo, NvEvoFB16);
 		else
-			OUT_RING(evo, NvEvoVRAM);
+			OUT_RING(evo, NvEvoVRAM_LP);
 	}
 
 	ret = RING_SPACE(evo, 12);
@@ -575,8 +577,10 @@ nv50_crtc_do_mode_set_base(struct drm_crtc *crtc,
 	if (!nv_crtc->fb.tile_flags) {
 		OUT_RING(evo, drm_fb->pitch | (1 << 20));
 	} else {
-		OUT_RING(evo, ((drm_fb->pitch / 4) << 4) |
-				  fb->nvbo->tile_mode);
+		u32 tile_mode = fb->nvbo->tile_mode;
+		if (dev_priv->card_type >= NV_C0)
+			tile_mode >>= 4;
+		OUT_RING(evo, ((drm_fb->pitch / 4) << 4) | tile_mode);
 	}
 	if (dev_priv->chipset == 0x50)
 		OUT_RING(evo, (nv_crtc->fb.tile_flags << 8) | format);
diff --git a/drivers/gpu/drm/nouveau/nv50_evo.c b/drivers/gpu/drm/nouveau/nv50_evo.c
index 887b2a9..14e24e9 100644
--- a/drivers/gpu/drm/nouveau/nv50_evo.c
+++ b/drivers/gpu/drm/nouveau/nv50_evo.c
@@ -53,7 +53,8 @@ nv50_evo_channel_del(struct nouveau_channel **pevo)
 
 int
 nv50_evo_dmaobj_new(struct nouveau_channel *evo, u32 class, u32 name,
-		    u32 tile_flags, u32 magic_flags, u32 offset, u32 limit)
+		    u32 tile_flags, u32 magic_flags, u32 offset, u32 limit,
+		    u32 flags5)
 {
 	struct drm_nouveau_private *dev_priv = evo->dev->dev_private;
 	struct drm_device *dev = evo->dev;
@@ -70,10 +71,7 @@ nv50_evo_dmaobj_new(struct nouveau_channel *evo, u32 class, u32 name,
 	nv_wo32(obj,  8, offset);
 	nv_wo32(obj, 12, 0x00000000);
 	nv_wo32(obj, 16, 0x00000000);
-	if (dev_priv->card_type < NV_C0)
-		nv_wo32(obj, 20, 0x00010000);
-	else
-		nv_wo32(obj, 20, 0x00020000);
+	nv_wo32(obj, 20, flags5);
 	dev_priv->engine.instmem.flush(dev);
 
 	ret = nouveau_ramht_insert(evo, name, obj);
@@ -264,9 +262,31 @@ nv50_evo_create(struct drm_device *dev)
 	}
 
 	/* create some default objects for the scanout memtypes we support */
+	if (dev_priv->card_type >= NV_C0) {
+		ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoFB32, 0xfe, 0x19,
+					  0, 0xffffffff, 0x00000000);
+		if (ret) {
+			nv50_evo_channel_del(&dev_priv->evo);
+			return ret;
+		}
+
+		ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoVRAM, 0, 0x19,
+					  0, dev_priv->vram_size, 0x00020000);
+		if (ret) {
+			nv50_evo_channel_del(&dev_priv->evo);
+			return ret;
+		}
+
+		ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoVRAM_LP, 0, 0x19,
+					  0, dev_priv->vram_size, 0x00000000);
+		if (ret) {
+			nv50_evo_channel_del(&dev_priv->evo);
+			return ret;
+		}
+	} else
 	if (dev_priv->chipset != 0x50) {
 		ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoFB16, 0x70, 0x19,
-					  0, 0xffffffff);
+					  0, 0xffffffff, 0x00010000);
 		if (ret) {
 			nv50_evo_channel_del(&dev_priv->evo);
 			return ret;
@@ -274,18 +294,25 @@ nv50_evo_create(struct drm_device *dev)
 
 
 		ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoFB32, 0x7a, 0x19,
-					  0, 0xffffffff);
+					  0, 0xffffffff, 0x00010000);
 		if (ret) {
 			nv50_evo_channel_del(&dev_priv->evo);
 			return ret;
 		}
-	}
 
-	ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoVRAM, 0, 0x19,
-				  0, dev_priv->vram_size);
-	if (ret) {
-		nv50_evo_channel_del(&dev_priv->evo);
-		return ret;
+		ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoVRAM, 0, 0x19,
+					  0, dev_priv->vram_size, 0x00010000);
+		if (ret) {
+			nv50_evo_channel_del(&dev_priv->evo);
+			return ret;
+		}
+
+		ret = nv50_evo_dmaobj_new(evo, 0x3d, NvEvoVRAM_LP, 0, 0x19,
+					  0, dev_priv->vram_size, 0x00010000);
+		if (ret) {
+			nv50_evo_channel_del(&dev_priv->evo);
+			return ret;
+		}
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/nouveau/nvc0_vram.c b/drivers/gpu/drm/nouveau/nvc0_vram.c
index 41fcae5..858eda5 100644
--- a/drivers/gpu/drm/nouveau/nvc0_vram.c
+++ b/drivers/gpu/drm/nouveau/nvc0_vram.c
@@ -29,8 +29,16 @@
 bool
 nvc0_vram_flags_valid(struct drm_device *dev, u32 tile_flags)
 {
-	if (likely(!(tile_flags & NOUVEAU_GEM_TILE_LAYOUT_MASK)))
+	switch (tile_flags & NOUVEAU_GEM_TILE_LAYOUT_MASK) {
+	case 0x0000:
+	case 0xfe00:
+	case 0xdb00:
+	case 0x1100:
 		return true;
+	default:
+		break;
+	}
+
 	return false;
 }
 
