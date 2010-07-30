Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab0G3Ssr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:48:47 -0400
Received: from kroah.org ([198.145.64.141]:35746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab0G3Rem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:42 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:07 2010
Message-Id: <20100730173107.494639376@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        sroland@vmware.com, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [053/140] drm/radeon/r100/r200: fix calculation of compressed cube maps
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Scheidegger <sroland@vmware.com>

commit 37cf6b03f9f28c62dafb0b9ce5f1ba29c8baffa9 upstream.

This needs similar handling to other compressed textures.
Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=26428

Signed-off-by: sroland@vmware.com
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r100.c |   58 ++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2750,33 +2750,6 @@ static inline void r100_cs_track_texture
 	DRM_ERROR("compress format            %d\n", t->compress_format);
 }
 
-static int r100_cs_track_cube(struct radeon_device *rdev,
-			      struct r100_cs_track *track, unsigned idx)
-{
-	unsigned face, w, h;
-	struct radeon_bo *cube_robj;
-	unsigned long size;
-
-	for (face = 0; face < 5; face++) {
-		cube_robj = track->textures[idx].cube_info[face].robj;
-		w = track->textures[idx].cube_info[face].width;
-		h = track->textures[idx].cube_info[face].height;
-
-		size = w * h;
-		size *= track->textures[idx].cpp;
-
-		size += track->textures[idx].cube_info[face].offset;
-
-		if (size > radeon_bo_size(cube_robj)) {
-			DRM_ERROR("Cube texture offset greater than object size %lu %lu\n",
-				  size, radeon_bo_size(cube_robj));
-			r100_cs_track_texture_print(&track->textures[idx]);
-			return -1;
-		}
-	}
-	return 0;
-}
-
 static int r100_track_compress_size(int compress_format, int w, int h)
 {
 	int block_width, block_height, block_bytes;
@@ -2807,6 +2780,37 @@ static int r100_track_compress_size(int
 	return sz;
 }
 
+static int r100_cs_track_cube(struct radeon_device *rdev,
+			      struct r100_cs_track *track, unsigned idx)
+{
+	unsigned face, w, h;
+	struct radeon_bo *cube_robj;
+	unsigned long size;
+	unsigned compress_format = track->textures[idx].compress_format;
+
+	for (face = 0; face < 5; face++) {
+		cube_robj = track->textures[idx].cube_info[face].robj;
+		w = track->textures[idx].cube_info[face].width;
+		h = track->textures[idx].cube_info[face].height;
+
+		if (compress_format) {
+			size = r100_track_compress_size(compress_format, w, h);
+		} else
+			size = w * h;
+		size *= track->textures[idx].cpp;
+
+		size += track->textures[idx].cube_info[face].offset;
+
+		if (size > radeon_bo_size(cube_robj)) {
+			DRM_ERROR("Cube texture offset greater than object size %lu %lu\n",
+				  size, radeon_bo_size(cube_robj));
+			r100_cs_track_texture_print(&track->textures[idx]);
+			return -1;
+		}
+	}
+	return 0;
+}
+
 static int r100_cs_track_texture_check(struct radeon_device *rdev,
 				       struct r100_cs_track *track)
 {


