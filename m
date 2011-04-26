Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1DZMau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:30:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57191 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1DZM0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:25 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 04/21] drm/radeon/kms: fix handling of tex lookup disable in cs checker on r2xx" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:23 +0200
Message-Id: <1303820783-3488-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 04/21] drm/radeon/kms: fix handling of tex lookup disable in cs checker on r2xx

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 96715ff2c9b628f959983b5734591846711df391 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 27 Oct 2010 01:02:35 -0400
Subject: [PATCH 04/21] drm/radeon/kms: fix handling of tex lookup disable in cs checker on r2xx

commit 43b93fbffc2c080dba2e84df6fce8d7e6c0a2581 upstream.

There are cases when multiple texture units have to be enabled,
but not actually used to sample.  This patch checks to see if
the lookup_disable bit is set and if so, skips the texture check.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=25544

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r100.c       |    3 +++
 drivers/gpu/drm/radeon/r100_track.h |    1 +
 drivers/gpu/drm/radeon/r200.c       |    2 ++
 drivers/gpu/drm/radeon/radeon_reg.h |    1 +
 4 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index b969b7d..6021e91 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2828,6 +2828,8 @@ static int r100_cs_track_texture_check(struct radeon_device *rdev,
 	for (u = 0; u < track->num_texture; u++) {
 		if (!track->textures[u].enabled)
 			continue;
+		if (track->textures[u].lookup_disable)
+			continue;
 		robj = track->textures[u].robj;
 		if (robj == NULL) {
 			DRM_ERROR("No texture bound to unit %u\n", u);
@@ -3076,6 +3078,7 @@ void r100_cs_track_clear(struct radeon_device *rdev, struct r100_cs_track *track
 		track->textures[i].robj = NULL;
 		/* CS IB emission code makes sure texture unit are disabled */
 		track->textures[i].enabled = false;
+		track->textures[i].lookup_disable = false;
 		track->textures[i].roundup_w = true;
 		track->textures[i].roundup_h = true;
 		if (track->separate_cube)
diff --git a/drivers/gpu/drm/radeon/r100_track.h b/drivers/gpu/drm/radeon/r100_track.h
index a2fada0..e19ef4a 100644
--- a/drivers/gpu/drm/radeon/r100_track.h
+++ b/drivers/gpu/drm/radeon/r100_track.h
@@ -46,6 +46,7 @@ struct r100_cs_track_texture {
 	unsigned		height_11;
 	bool			use_pitch;
 	bool			enabled;
+	bool                    lookup_disable;
 	bool			roundup_w;
 	bool			roundup_h;
 	unsigned                compress_format;
diff --git a/drivers/gpu/drm/radeon/r200.c b/drivers/gpu/drm/radeon/r200.c
index f890fd3..7ebd2ba 100644
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -400,6 +400,8 @@ int r200_packet0_check(struct radeon_cs_parser *p,
 			track->textures[i].width = 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
 			track->textures[i].height = 1 << ((idx_value >> RADEON_TXFORMAT_HEIGHT_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
 		}
+		if (idx_value & R200_TXFORMAT_LOOKUP_DISABLE)
+			track->textures[i].lookup_disable = true;
 		switch ((idx_value & RADEON_TXFORMAT_FORMAT_MASK)) {
 		case R200_TXFORMAT_I8:
 		case R200_TXFORMAT_RGB332:
diff --git a/drivers/gpu/drm/radeon/radeon_reg.h b/drivers/gpu/drm/radeon/radeon_reg.h
index 6d0a009..57bcc8e 100644
--- a/drivers/gpu/drm/radeon/radeon_reg.h
+++ b/drivers/gpu/drm/radeon/radeon_reg.h
@@ -2827,6 +2827,7 @@
 #       define R200_TXFORMAT_ST_ROUTE_STQ5	(5 << 24)
 #       define R200_TXFORMAT_ST_ROUTE_MASK	(7 << 24)
 #       define R200_TXFORMAT_ST_ROUTE_SHIFT	24
+#       define R200_TXFORMAT_LOOKUP_DISABLE	(1 << 27)
 #       define R200_TXFORMAT_ALPHA_MASK_ENABLE	(1 << 28)
 #       define R200_TXFORMAT_CHROMA_KEY_ENABLE	(1 << 29)
 #       define R200_TXFORMAT_CUBIC_MAP_ENABLE		(1 << 30)
--
1.7.0.4

