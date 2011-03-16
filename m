Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1CPVKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:10:20 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:44640 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1CPVKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:10:14 -0400
Subject: [PATCH] drm: radeon: *_cs_packet_parse_vline() cleanup
From: Paul Bolle <pebolle@tiscali.nl>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Mar 2011 22:10:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-2.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1300309813.1954.15.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the way the return value is set a number of times (mostly on
error).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Should a patch like this go through the trivial tree?
Documentation/SubmittingPatches wasn't entirely clear on that.

 drivers/gpu/drm/radeon/evergreen_cs.c |   24 ++++++++----------------
 drivers/gpu/drm/radeon/r100.c         |   16 ++++++----------
 drivers/gpu/drm/radeon/r600_cs.c      |   25 +++++++++----------------
 3 files changed, 23 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 345a75a..d091e70 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -292,33 +292,28 @@ static int evergreen_cs_packet_parse_vline(struct radeon_cs_parser *p)
 	if (wait_reg_mem.type != PACKET_TYPE3 ||
 	    wait_reg_mem.opcode != PACKET3_WAIT_REG_MEM) {
 		DRM_ERROR("vline wait missing WAIT_REG_MEM segment\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	wait_reg_mem_info = radeon_get_ib_value(p, wait_reg_mem.idx + 1);
 	/* bit 4 is reg (0) or mem (1) */
 	if (wait_reg_mem_info & 0x10) {
 		DRM_ERROR("vline WAIT_REG_MEM waiting on MEM rather than REG\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 	/* waiting for value to be equal */
 	if ((wait_reg_mem_info & 0x7) != 0x3) {
 		DRM_ERROR("vline WAIT_REG_MEM function not equal\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 	if ((radeon_get_ib_value(p, wait_reg_mem.idx + 2) << 2) != EVERGREEN_VLINE_STATUS) {
 		DRM_ERROR("vline WAIT_REG_MEM bad reg\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	if (radeon_get_ib_value(p, wait_reg_mem.idx + 5) != EVERGREEN_VLINE_STAT) {
 		DRM_ERROR("vline WAIT_REG_MEM bad bit mask\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	/* jump over the NOP */
@@ -336,8 +331,7 @@ static int evergreen_cs_packet_parse_vline(struct radeon_cs_parser *p)
 	obj = drm_mode_object_find(p->rdev->ddev, crtc_id, DRM_MODE_OBJECT_CRTC);
 	if (!obj) {
 		DRM_ERROR("cannot find crtc %d\n", crtc_id);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 	crtc = obj_to_crtc(obj);
 	radeon_crtc = to_radeon_crtc(crtc);
@@ -362,12 +356,10 @@ static int evergreen_cs_packet_parse_vline(struct radeon_cs_parser *p)
 			break;
 		default:
 			DRM_ERROR("unknown crtc reloc\n");
-			r = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 	}
-out:
-	return r;
+	return 0;
 }
 
 static int evergreen_packet0_check(struct radeon_cs_parser *p,
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index e372f9e..fcc23e4 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1205,14 +1205,12 @@ int r100_cs_packet_parse_vline(struct radeon_cs_parser *p)
 	if (waitreloc.reg != RADEON_WAIT_UNTIL ||
 	    waitreloc.count != 0) {
 		DRM_ERROR("vline wait had illegal wait until segment\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	if (radeon_get_ib_value(p, waitreloc.idx + 1) != RADEON_WAIT_CRTC_VLINE) {
 		DRM_ERROR("vline wait had illegal wait until\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	/* jump over the NOP */
@@ -1230,8 +1228,7 @@ int r100_cs_packet_parse_vline(struct radeon_cs_parser *p)
 	obj = drm_mode_object_find(p->rdev->ddev, crtc_id, DRM_MODE_OBJECT_CRTC);
 	if (!obj) {
 		DRM_ERROR("cannot find crtc %d\n", crtc_id);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 	crtc = obj_to_crtc(obj);
 	radeon_crtc = to_radeon_crtc(crtc);
@@ -1253,14 +1250,13 @@ int r100_cs_packet_parse_vline(struct radeon_cs_parser *p)
 			break;
 		default:
 			DRM_ERROR("unknown crtc reloc\n");
-			r = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 		ib[h_idx] = header;
 		ib[h_idx + 3] |= RADEON_ENG_DISPLAY_SELECT_CRTC1;
 	}
-out:
-	return r;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 153095f..5bfed09 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -687,33 +687,28 @@ static int r600_cs_packet_parse_vline(struct radeon_cs_parser *p)
 	if (wait_reg_mem.type != PACKET_TYPE3 ||
 	    wait_reg_mem.opcode != PACKET3_WAIT_REG_MEM) {
 		DRM_ERROR("vline wait missing WAIT_REG_MEM segment\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	wait_reg_mem_info = radeon_get_ib_value(p, wait_reg_mem.idx + 1);
 	/* bit 4 is reg (0) or mem (1) */
 	if (wait_reg_mem_info & 0x10) {
 		DRM_ERROR("vline WAIT_REG_MEM waiting on MEM rather than REG\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 	/* waiting for value to be equal */
 	if ((wait_reg_mem_info & 0x7) != 0x3) {
 		DRM_ERROR("vline WAIT_REG_MEM function not equal\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 	if ((radeon_get_ib_value(p, wait_reg_mem.idx + 2) << 2) != AVIVO_D1MODE_VLINE_STATUS) {
 		DRM_ERROR("vline WAIT_REG_MEM bad reg\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	if (radeon_get_ib_value(p, wait_reg_mem.idx + 5) != AVIVO_D1MODE_VLINE_STAT) {
 		DRM_ERROR("vline WAIT_REG_MEM bad bit mask\n");
-		r = -EINVAL;
-		return r;
+		return -EINVAL;
 	}
 
 	/* jump over the NOP */
@@ -732,8 +727,7 @@ static int r600_cs_packet_parse_vline(struct radeon_cs_parser *p)
 	obj = drm_mode_object_find(p->rdev->ddev, crtc_id, DRM_MODE_OBJECT_CRTC);
 	if (!obj) {
 		DRM_ERROR("cannot find crtc %d\n", crtc_id);
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 	crtc = obj_to_crtc(obj);
 	radeon_crtc = to_radeon_crtc(crtc);
@@ -756,14 +750,13 @@ static int r600_cs_packet_parse_vline(struct radeon_cs_parser *p)
 			break;
 		default:
 			DRM_ERROR("unknown crtc reloc\n");
-			r = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 		ib[h_idx] = header;
 		ib[h_idx + 4] = AVIVO_D2MODE_VLINE_STATUS >> 2;
 	}
-out:
-	return r;
+
+	return 0;
 }
 
 static int r600_packet0_check(struct radeon_cs_parser *p,
-- 
1.7.4.1



