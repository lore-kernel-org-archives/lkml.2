Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1BVWhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:37:08 -0500
Received: from kroah.org ([198.145.64.141]:46571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1BVWVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:37 2011
Message-Id: <20110222221837.854084672@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [08/70] drm/radeon/kms: improve 6xx/7xx CS error output
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit c2049b3d29f47ed3750226dc51251a3404c85876 upstream.

Makes debugging CS rejections much easier.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600_cs.c |   46 ++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -295,17 +295,18 @@ static inline int r600_cs_track_validate
 	}
 
 	if (!IS_ALIGNED(pitch, pitch_align)) {
-		dev_warn(p->dev, "%s:%d cb pitch (%d) invalid\n",
-			 __func__, __LINE__, pitch);
+		dev_warn(p->dev, "%s:%d cb pitch (%d, 0x%x, %d) invalid\n",
+			 __func__, __LINE__, pitch, pitch_align, array_mode);
 		return -EINVAL;
 	}
 	if (!IS_ALIGNED(height, height_align)) {
-		dev_warn(p->dev, "%s:%d cb height (%d) invalid\n",
-			 __func__, __LINE__, height);
+		dev_warn(p->dev, "%s:%d cb height (%d, 0x%x, %d) invalid\n",
+			 __func__, __LINE__, height, height_align, array_mode);
 		return -EINVAL;
 	}
 	if (!IS_ALIGNED(base_offset, base_align)) {
-		dev_warn(p->dev, "%s offset[%d] 0x%llx not aligned\n", __func__, i, base_offset);
+		dev_warn(p->dev, "%s offset[%d] 0x%llx 0x%llx, %d not aligned\n", __func__, i,
+			 base_offset, base_align, array_mode);
 		return -EINVAL;
 	}
 
@@ -320,7 +321,10 @@ static inline int r600_cs_track_validate
 			 * broken userspace.
 			 */
 		} else {
-			dev_warn(p->dev, "%s offset[%d] %d %d %lu too big\n", __func__, i, track->cb_color_bo_offset[i], tmp, radeon_bo_size(track->cb_color_bo[i]));
+			dev_warn(p->dev, "%s offset[%d] %d %d %d %lu too big\n", __func__, i,
+				 array_mode,
+				 track->cb_color_bo_offset[i], tmp,
+				 radeon_bo_size(track->cb_color_bo[i]));
 			return -EINVAL;
 		}
 	}
@@ -455,17 +459,18 @@ static int r600_cs_track_check(struct ra
 			}
 
 			if (!IS_ALIGNED(pitch, pitch_align)) {
-				dev_warn(p->dev, "%s:%d db pitch (%d) invalid\n",
-					 __func__, __LINE__, pitch);
+				dev_warn(p->dev, "%s:%d db pitch (%d, 0x%x, %d) invalid\n",
+					 __func__, __LINE__, pitch, pitch_align, array_mode);
 				return -EINVAL;
 			}
 			if (!IS_ALIGNED(height, height_align)) {
-				dev_warn(p->dev, "%s:%d db height (%d) invalid\n",
-					 __func__, __LINE__, height);
+				dev_warn(p->dev, "%s:%d db height (%d, 0x%x, %d) invalid\n",
+					 __func__, __LINE__, height, height_align, array_mode);
 				return -EINVAL;
 			}
 			if (!IS_ALIGNED(base_offset, base_align)) {
-				dev_warn(p->dev, "%s offset[%d] 0x%llx not aligned\n", __func__, i, base_offset);
+				dev_warn(p->dev, "%s offset[%d] 0x%llx, 0x%llx, %d not aligned\n", __func__, i,
+					 base_offset, base_align, array_mode);
 				return -EINVAL;
 			}
 
@@ -473,9 +478,10 @@ static int r600_cs_track_check(struct ra
 			nviews = G_028004_SLICE_MAX(track->db_depth_view) + 1;
 			tmp = ntiles * bpe * 64 * nviews;
 			if ((tmp + track->db_offset) > radeon_bo_size(track->db_bo)) {
-				dev_warn(p->dev, "z/stencil buffer too small (0x%08X %d %d %d -> %u have %lu)\n",
-						track->db_depth_size, ntiles, nviews, bpe, tmp + track->db_offset,
-						radeon_bo_size(track->db_bo));
+				dev_warn(p->dev, "z/stencil buffer (%d) too small (0x%08X %d %d %d -> %u have %lu)\n",
+					 array_mode,
+					 track->db_depth_size, ntiles, nviews, bpe, tmp + track->db_offset,
+					 radeon_bo_size(track->db_bo));
 				return -EINVAL;
 			}
 		}
@@ -1227,18 +1233,18 @@ static inline int r600_check_texture_res
 	/* XXX check height as well... */
 
 	if (!IS_ALIGNED(pitch, pitch_align)) {
-		dev_warn(p->dev, "%s:%d tex pitch (%d) invalid\n",
-			 __func__, __LINE__, pitch);
+		dev_warn(p->dev, "%s:%d tex pitch (%d, 0x%x, %d) invalid\n",
+			 __func__, __LINE__, pitch, pitch_align, G_038000_TILE_MODE(word0));
 		return -EINVAL;
 	}
 	if (!IS_ALIGNED(base_offset, base_align)) {
-		dev_warn(p->dev, "%s:%d tex base offset (0x%llx) invalid\n",
-			 __func__, __LINE__, base_offset);
+		dev_warn(p->dev, "%s:%d tex base offset (0x%llx, 0x%llx, %d) invalid\n",
+			 __func__, __LINE__, base_offset, base_align, G_038000_TILE_MODE(word0));
 		return -EINVAL;
 	}
 	if (!IS_ALIGNED(mip_offset, base_align)) {
-		dev_warn(p->dev, "%s:%d tex mip offset (0x%llx) invalid\n",
-			 __func__, __LINE__, mip_offset);
+		dev_warn(p->dev, "%s:%d tex mip offset (0x%llx, 0x%llx, %d) invalid\n",
+			 __func__, __LINE__, mip_offset, base_align, G_038000_TILE_MODE(word0));
 		return -EINVAL;
 	}
 


