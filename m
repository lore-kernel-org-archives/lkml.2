Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1C3QGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:06:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35002 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab1C3QGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:06:13 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>
Cc: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Dann Frazier <dannf@debian.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 1/2] drm/radeon/kms: check AA resolve registers on r300" has been added to staging queue
Date: Wed, 30 Mar 2011 18:06:03 +0200
Message-Id: <1301501163-11019-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 1/2] drm/radeon/kms: check AA resolve registers on r300

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 4da0f674f76daed057f05d5926ac4756c938414c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>
Date: Tue, 29 Mar 2011 15:23:30 -0600
Subject: [PATCH 1/2] drm/radeon/kms: check AA resolve registers on r300
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is an important security fix because we allowed arbitrary values
to be passed to AARESOLVE_OFFSET. This also puts the right buffer address
in the register.

Signed-off-by: Marek Olšák <maraeo@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>

(backported from commit fff1ce4dc6113b6fdc4e3a815ca5fd229408f8ef upstream)
Signed-off-by: Dann Frazier <dannf@debian.org>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r100.c         |   24 ++++++++++++++++++++++++
 drivers/gpu/drm/radeon/r100_track.h   |    3 +++
 drivers/gpu/drm/radeon/r300.c         |   21 +++++++++++++++++++++
 drivers/gpu/drm/radeon/r300_reg.h     |    2 ++
 drivers/gpu/drm/radeon/reg_srcs/r300  |    3 ---
 drivers/gpu/drm/radeon/reg_srcs/r420  |    3 ---
 drivers/gpu/drm/radeon/reg_srcs/rs600 |    3 ---
 drivers/gpu/drm/radeon/reg_srcs/rv515 |    3 ---
 8 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 3ecd236..2cfb39f 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2934,6 +2934,27 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 			return -EINVAL;
 		}
 	}
+
+	if (track->aa_dirty && track->aaresolve) {
+		if (track->aa.robj == NULL) {
+			DRM_ERROR("[drm] No buffer for AA resolve buffer %d !\n", i);
+			return -EINVAL;
+		}
+		/* I believe the format comes from colorbuffer0. */
+		size = track->aa.pitch * track->cb[0].cpp * track->maxy;
+		size += track->aa.offset;
+		if (size > radeon_bo_size(track->aa.robj)) {
+			DRM_ERROR("[drm] Buffer too small for AA resolve buffer %d "
+				  "(need %lu have %lu) !\n", i, size,
+				  radeon_bo_size(track->aa.robj));
+			DRM_ERROR("[drm] AA resolve buffer %d (%u %u %u %u)\n",
+				  i, track->aa.pitch, track->cb[0].cpp,
+				  track->aa.offset, track->maxy);
+			return -EINVAL;
+		}
+	}
+	track->aa_dirty = false;
+
 	prim_walk = (track->vap_vf_cntl >> 4) & 0x3;
 	nverts = (track->vap_vf_cntl >> 16) & 0xFFFF;
 	switch (prim_walk) {
@@ -2995,6 +3016,7 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 void r100_cs_track_clear(struct radeon_device *rdev, struct r100_cs_track *track)
 {
 	unsigned i, face;
+	track->aa_dirty = true;

 	if (rdev->family < CHIP_R300) {
 		track->num_cb = 1;
@@ -3009,6 +3031,8 @@ void r100_cs_track_clear(struct radeon_device *rdev, struct r100_cs_track *track
 		track->num_texture = 16;
 		track->maxy = 4096;
 		track->separate_cube = 0;
+		track->aaresolve = true;
+		track->aa.robj = NULL;
 	}

 	for (i = 0; i < track->num_cb; i++) {
diff --git a/drivers/gpu/drm/radeon/r100_track.h b/drivers/gpu/drm/radeon/r100_track.h
index b27a699..a2fada0 100644
--- a/drivers/gpu/drm/radeon/r100_track.h
+++ b/drivers/gpu/drm/radeon/r100_track.h
@@ -71,11 +71,14 @@ struct r100_cs_track {
 	struct r100_cs_track_array	arrays[11];
 	struct r100_cs_track_cb 	cb[R300_MAX_CB];
 	struct r100_cs_track_cb 	zb;
+	struct r100_cs_track_cb 	aa;
 	struct r100_cs_track_texture	textures[R300_TRACK_MAX_TEXTURE];
 	bool				z_enabled;
 	bool                            separate_cube;
 	bool				fastfill;
 	bool				blend_read_enable;
+	bool				aa_dirty;
+	bool				aaresolve;
 };

 int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track);
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 7e9868d..5b26131 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1044,6 +1044,27 @@ static int r300_packet0_check(struct radeon_cs_parser *p,
 		/* RB3D_BLENDCNTL */
 		track->blend_read_enable = !!(idx_value & (1 << 2));
 		break;
+	case R300_RB3D_AARESOLVE_OFFSET:
+		r = r100_cs_packet_next_reloc(p, &reloc);
+		if (r) {
+			DRM_ERROR("No reloc for ib[%d]=0x%04X\n",
+				  idx, reg);
+			r100_cs_dump_packet(p, pkt);
+			return r;
+		}
+		track->aa.robj = reloc->robj;
+		track->aa.offset = idx_value;
+		track->aa_dirty = true;
+		ib[idx] = idx_value + ((u32)reloc->lobj.gpu_offset);
+		break;
+	case R300_RB3D_AARESOLVE_PITCH:
+		track->aa.pitch = idx_value & 0x3FFE;
+		track->aa_dirty = true;
+		break;
+	case R300_RB3D_AARESOLVE_CTL:
+		track->aaresolve = idx_value & 0x1;
+		track->aa_dirty = true;
+		break;
 	case 0x4be8:
 		/* valid register only on RV530 */
 		if (p->rdev->family == CHIP_RV530)
diff --git a/drivers/gpu/drm/radeon/r300_reg.h b/drivers/gpu/drm/radeon/r300_reg.h
index 1735a2b..fb21053 100644
--- a/drivers/gpu/drm/radeon/r300_reg.h
+++ b/drivers/gpu/drm/radeon/r300_reg.h
@@ -1369,6 +1369,8 @@
 #define R300_RB3D_COLORPITCH2               0x4E40 /* GUESS */
 #define R300_RB3D_COLORPITCH3               0x4E44 /* GUESS */

+#define R300_RB3D_AARESOLVE_OFFSET          0x4E80
+#define R300_RB3D_AARESOLVE_PITCH           0x4E84
 #define R300_RB3D_AARESOLVE_CTL             0x4E88
 /* gap */

diff --git a/drivers/gpu/drm/radeon/reg_srcs/r300 b/drivers/gpu/drm/radeon/reg_srcs/r300
index 19c4663..e4c220f 100644
--- a/drivers/gpu/drm/radeon/reg_srcs/r300
+++ b/drivers/gpu/drm/radeon/reg_srcs/r300
@@ -705,9 +705,6 @@ r300 0x4f60
 0x4E74 RB3D_CMASK_WRINDEX
 0x4E78 RB3D_CMASK_DWORD
 0x4E7C RB3D_CMASK_RDINDEX
-0x4E80 RB3D_AARESOLVE_OFFSET
-0x4E84 RB3D_AARESOLVE_PITCH
-0x4E88 RB3D_AARESOLVE_CTL
 0x4EA0 RB3D_DISCARD_SRC_PIXEL_LTE_THRESHOLD
 0x4EA4 RB3D_DISCARD_SRC_PIXEL_GTE_THRESHOLD
 0x4F04 ZB_ZSTENCILCNTL
diff --git a/drivers/gpu/drm/radeon/reg_srcs/r420 b/drivers/gpu/drm/radeon/reg_srcs/r420
index 989f7a0..6b4035e 100644
--- a/drivers/gpu/drm/radeon/reg_srcs/r420
+++ b/drivers/gpu/drm/radeon/reg_srcs/r420
@@ -771,9 +771,6 @@ r420 0x4f60
 0x4E74 RB3D_CMASK_WRINDEX
 0x4E78 RB3D_CMASK_DWORD
 0x4E7C RB3D_CMASK_RDINDEX
-0x4E80 RB3D_AARESOLVE_OFFSET
-0x4E84 RB3D_AARESOLVE_PITCH
-0x4E88 RB3D_AARESOLVE_CTL
 0x4EA0 RB3D_DISCARD_SRC_PIXEL_LTE_THRESHOLD
 0x4EA4 RB3D_DISCARD_SRC_PIXEL_GTE_THRESHOLD
 0x4F04 ZB_ZSTENCILCNTL
diff --git a/drivers/gpu/drm/radeon/reg_srcs/rs600 b/drivers/gpu/drm/radeon/reg_srcs/rs600
index 6801b86..c0db1f9 100644
--- a/drivers/gpu/drm/radeon/reg_srcs/rs600
+++ b/drivers/gpu/drm/radeon/reg_srcs/rs600
@@ -771,9 +771,6 @@ rs600 0x6d40
 0x4E74 RB3D_CMASK_WRINDEX
 0x4E78 RB3D_CMASK_DWORD
 0x4E7C RB3D_CMASK_RDINDEX
-0x4E80 RB3D_AARESOLVE_OFFSET
-0x4E84 RB3D_AARESOLVE_PITCH
-0x4E88 RB3D_AARESOLVE_CTL
 0x4EA0 RB3D_DISCARD_SRC_PIXEL_LTE_THRESHOLD
 0x4EA4 RB3D_DISCARD_SRC_PIXEL_GTE_THRESHOLD
 0x4F04 ZB_ZSTENCILCNTL
diff --git a/drivers/gpu/drm/radeon/reg_srcs/rv515 b/drivers/gpu/drm/radeon/reg_srcs/rv515
index 38abf63..90a5e0a 100644
--- a/drivers/gpu/drm/radeon/reg_srcs/rv515
+++ b/drivers/gpu/drm/radeon/reg_srcs/rv515
@@ -465,9 +465,6 @@ rv515 0x6d40
 0x4E74 RB3D_CMASK_WRINDEX
 0x4E78 RB3D_CMASK_DWORD
 0x4E7C RB3D_CMASK_RDINDEX
-0x4E80 RB3D_AARESOLVE_OFFSET
-0x4E84 RB3D_AARESOLVE_PITCH
-0x4E88 RB3D_AARESOLVE_CTL
 0x4EA0 RB3D_DISCARD_SRC_PIXEL_LTE_THRESHOLD
 0x4EA4 RB3D_DISCARD_SRC_PIXEL_GTE_THRESHOLD
 0x4EF8 RB3D_CONSTANT_COLOR_AR
--
1.7.0.4

