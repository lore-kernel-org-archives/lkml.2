Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2HTEA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:00:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2HTEAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: =?UTF-8?q?=5B=2020/46=5D=20drm/radeon/kms=3A=20allow=20=22invalid=22=20DB=20formats=20as=20a=20means=20to=20disable=20DB?=
Date: Sun, 19 Aug 2012 20:58:56 -0700
Message-Id: <20120820035835.081212934@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <maraeo@gmail.com>

commit 0f457e488c79922dfd646f94ed058764f7ba758c upstream.

Signed-off-by: Marek Olšák <maraeo@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_cs.c |    6 ++++--
 drivers/gpu/drm/radeon/evergreend.h   |    2 ++
 drivers/gpu/drm/radeon/r600_cs.c      |    6 ++++--
 drivers/gpu/drm/radeon/radeon_drv.c   |    3 ++-
 4 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -961,13 +961,15 @@ static int evergreen_cs_track_check(stru
 
 	if (track->db_dirty) {
 		/* Check stencil buffer */
-		if (G_028800_STENCIL_ENABLE(track->db_depth_control)) {
+		if (G_028044_FORMAT(track->db_s_info) != V_028044_STENCIL_INVALID &&
+		    G_028800_STENCIL_ENABLE(track->db_depth_control)) {
 			r = evergreen_cs_track_validate_stencil(p);
 			if (r)
 				return r;
 		}
 		/* Check depth buffer */
-		if (G_028800_Z_ENABLE(track->db_depth_control)) {
+		if (G_028040_FORMAT(track->db_z_info) != V_028040_Z_INVALID &&
+		    G_028800_Z_ENABLE(track->db_depth_control)) {
 			r = evergreen_cs_track_validate_depth(p);
 			if (r)
 				return r;
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -1273,6 +1273,8 @@
 #define   S_028044_FORMAT(x)                           (((x) & 0x1) << 0)
 #define   G_028044_FORMAT(x)                           (((x) >> 0) & 0x1)
 #define   C_028044_FORMAT                              0xFFFFFFFE
+#define	    V_028044_STENCIL_INVALID			0
+#define	    V_028044_STENCIL_8				1
 #define   G_028044_TILE_SPLIT(x)                       (((x) >> 8) & 0x7)
 #define DB_Z_READ_BASE					0x28048
 #define DB_STENCIL_READ_BASE				0x2804c
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -764,8 +764,10 @@ static int r600_cs_track_check(struct ra
 	}
 
 	/* Check depth buffer */
-	if (track->db_dirty && (G_028800_STENCIL_ENABLE(track->db_depth_control) ||
-		G_028800_Z_ENABLE(track->db_depth_control))) {
+	if (track->db_dirty &&
+	    G_028010_FORMAT(track->db_depth_info) != V_028010_DEPTH_INVALID &&
+	    (G_028800_STENCIL_ENABLE(track->db_depth_control) ||
+	     G_028800_Z_ENABLE(track->db_depth_control))) {
 		r = r600_cs_track_validate_db(p);
 		if (r)
 			return r;
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -59,9 +59,10 @@
  *   2.15.0 - add max_pipes query
  *   2.16.0 - fix evergreen 2D tiled surface calculation
  *   2.17.0 - add STRMOUT_BASE_UPDATE for r7xx
+ *   2.18.0 - r600-eg: allow "invalid" DB formats
  */
 #define KMS_DRIVER_MAJOR	2
-#define KMS_DRIVER_MINOR	17
+#define KMS_DRIVER_MINOR	18
 #define KMS_DRIVER_PATCHLEVEL	0
 int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags);
 int radeon_driver_unload_kms(struct drm_device *dev);


