Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab0LHBAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:25 -0500
Received: from kroah.org ([198.145.64.141]:48753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970Ab0LHBAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:18 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.856673661@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [085/289] drm/radeon/kms: fix handling of tex lookup disable in cs checker on r2xx
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 43b93fbffc2c080dba2e84df6fce8d7e6c0a2581 upstream.

There are cases when multiple texture units have to be enabled,
but not actually used to sample.  This patch checks to see if
the lookup_disable bit is set and if so, skips the texture check.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=25544

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r100.c       |    3 +++
 drivers/gpu/drm/radeon/r100_track.h |    1 +
 drivers/gpu/drm/radeon/r200.c       |    2 ++
 drivers/gpu/drm/radeon/radeon_reg.h |    1 +
 4 files changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3228,6 +3228,8 @@ static int r100_cs_track_texture_check(s
 	for (u = 0; u < track->num_texture; u++) {
 		if (!track->textures[u].enabled)
 			continue;
+		if (track->textures[u].lookup_disable)
+			continue;
 		robj = track->textures[u].robj;
 		if (robj == NULL) {
 			DRM_ERROR("No texture bound to unit %u\n", u);
@@ -3462,6 +3464,7 @@ void r100_cs_track_clear(struct radeon_d
 		track->textures[i].robj = NULL;
 		/* CS IB emission code makes sure texture unit are disabled */
 		track->textures[i].enabled = false;
+		track->textures[i].lookup_disable = false;
 		track->textures[i].roundup_w = true;
 		track->textures[i].roundup_h = true;
 		if (track->separate_cube)
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
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -447,6 +447,8 @@ int r200_packet0_check(struct radeon_cs_
 			track->textures[i].width = 1 << ((idx_value >> RADEON_TXFORMAT_WIDTH_SHIFT) & RADEON_TXFORMAT_WIDTH_MASK);
 			track->textures[i].height = 1 << ((idx_value >> RADEON_TXFORMAT_HEIGHT_SHIFT) & RADEON_TXFORMAT_HEIGHT_MASK);
 		}
+		if (idx_value & R200_TXFORMAT_LOOKUP_DISABLE)
+			track->textures[i].lookup_disable = true;
 		switch ((idx_value & RADEON_TXFORMAT_FORMAT_MASK)) {
 		case R200_TXFORMAT_I8:
 		case R200_TXFORMAT_RGB332:
--- a/drivers/gpu/drm/radeon/radeon_reg.h
+++ b/drivers/gpu/drm/radeon/radeon_reg.h
@@ -2836,6 +2836,7 @@
 #       define R200_TXFORMAT_ST_ROUTE_STQ5	(5 << 24)
 #       define R200_TXFORMAT_ST_ROUTE_MASK	(7 << 24)
 #       define R200_TXFORMAT_ST_ROUTE_SHIFT	24
+#       define R200_TXFORMAT_LOOKUP_DISABLE	(1 << 27)
 #       define R200_TXFORMAT_ALPHA_MASK_ENABLE	(1 << 28)
 #       define R200_TXFORMAT_CHROMA_KEY_ENABLE	(1 << 29)
 #       define R200_TXFORMAT_CUBIC_MAP_ENABLE		(1 << 30)


