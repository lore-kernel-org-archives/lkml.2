Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab2JKAeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:34:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41350 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933146Ab2JKAYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:24:16 -0400
X-Sasl-enc: wcxQqfVJU6UWAzK5hRKnJWa9CGyuD6MyJZFfThDfsq3n 1349915054
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: =?UTF-8?q?=5B=20080/122=5D=20drm/radeon=3A=20allow=20MIP=5FADDRESS=3D0=20for=20MSAA=20textures=20on=20Evergreen?=
Date: Thu, 11 Oct 2012 07:54:06 +0900
Message-Id: <20121010225352.484798642@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <maraeo@gmail.com>

commit 61051afd3540da71c1ac32f17ed663595a0f7ecb upstream.

MIP_ADDRESS should point to the resolved FMASK for an MSAA texture.
Setting MIP_ADDRESS to 0 means the FMASK pointer is invalid (the GPU
won't read the memory then).

The userspace has to set MIP_ADDRESS to 0 and *not* emit any relocation
for it.

Signed-off-by: Marek Olšák <maraeo@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_cs.c |   59 +++++++++++++++++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_drv.c   |    3 +
 2 files changed, 54 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -846,6 +846,16 @@ static int evergreen_cs_track_validate_t
 		return -EINVAL;
 	}
 
+	if (!mipmap) {
+		if (llevel) {
+			dev_warn(p->dev, "%s:%i got NULL MIP_ADDRESS relocation\n",
+				 __func__, __LINE__);
+			return -EINVAL;
+		} else {
+			return 0; /* everything's ok */
+		}
+	}
+
 	/* check mipmap size */
 	for (i = 1; i <= llevel; i++) {
 		unsigned w, h, d;
@@ -1081,6 +1091,27 @@ static int evergreen_cs_packet_next_relo
 }
 
 /**
+ * evergreen_cs_packet_next_is_pkt3_nop() - test if the next packet is NOP
+ * @p:		structure holding the parser context.
+ *
+ * Check if the next packet is a relocation packet3.
+ **/
+static bool evergreen_cs_packet_next_is_pkt3_nop(struct radeon_cs_parser *p)
+{
+	struct radeon_cs_packet p3reloc;
+	int r;
+
+	r = evergreen_cs_packet_parse(p, &p3reloc, p->idx);
+	if (r) {
+		return false;
+	}
+	if (p3reloc.type != PACKET_TYPE3 || p3reloc.opcode != PACKET3_NOP) {
+		return false;
+	}
+	return true;
+}
+
+/**
  * evergreen_cs_packet_next_vline() - parse userspace VLINE packet
  * @parser:		parser structure holding parsing context.
  *
@@ -2330,7 +2361,7 @@ static int evergreen_packet3_check(struc
 		for (i = 0; i < (pkt->count / 8); i++) {
 			struct radeon_bo *texture, *mipmap;
 			u32 toffset, moffset;
-			u32 size, offset;
+			u32 size, offset, mip_address, tex_dim;
 
 			switch (G__SQ_CONSTANT_TYPE(radeon_get_ib_value(p, idx+1+(i*8)+7))) {
 			case SQ_TEX_VTX_VALID_TEXTURE:
@@ -2359,14 +2390,28 @@ static int evergreen_packet3_check(struc
 				}
 				texture = reloc->robj;
 				toffset = (u32)((reloc->lobj.gpu_offset >> 8) & 0xffffffff);
+
 				/* tex mip base */
-				r = evergreen_cs_packet_next_reloc(p, &reloc);
-				if (r) {
-					DRM_ERROR("bad SET_RESOURCE (tex)\n");
-					return -EINVAL;
+				tex_dim = ib[idx+1+(i*8)+0] & 0x7;
+				mip_address = ib[idx+1+(i*8)+3];
+
+				if ((tex_dim == SQ_TEX_DIM_2D_MSAA || tex_dim == SQ_TEX_DIM_2D_ARRAY_MSAA) &&
+				    !mip_address &&
+				    !evergreen_cs_packet_next_is_pkt3_nop(p)) {
+					/* MIP_ADDRESS should point to FMASK for an MSAA texture.
+					 * It should be 0 if FMASK is disabled. */
+					moffset = 0;
+					mipmap = NULL;
+				} else {
+					r = evergreen_cs_packet_next_reloc(p, &reloc);
+					if (r) {
+						DRM_ERROR("bad SET_RESOURCE (tex)\n");
+						return -EINVAL;
+					}
+					moffset = (u32)((reloc->lobj.gpu_offset >> 8) & 0xffffffff);
+					mipmap = reloc->robj;
 				}
-				moffset = (u32)((reloc->lobj.gpu_offset >> 8) & 0xffffffff);
-				mipmap = reloc->robj;
+
 				r = evergreen_cs_track_validate_texture(p, texture, mipmap, idx+1+(i*8));
 				if (r)
 					return r;
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -65,9 +65,10 @@
  *   2.21.0 - r600-r700: FMASK and CMASK
  *   2.22.0 - r600 only: RESOLVE_BOX allowed
  *   2.23.0 - allow STRMOUT_BASE_UPDATE on RS780 and RS880
+ *   2.24.0 - eg only: allow MIP_ADDRESS=0 for MSAA textures
  */
 #define KMS_DRIVER_MAJOR	2
-#define KMS_DRIVER_MINOR	23
+#define KMS_DRIVER_MINOR	24
 #define KMS_DRIVER_PATCHLEVEL	0
 int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags);
 int radeon_driver_unload_kms(struct drm_device *dev);


