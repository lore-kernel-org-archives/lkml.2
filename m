Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0IRTSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:18:14 -0400
Received: from kroah.org ([198.145.64.141]:43939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267Ab0IRTQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:31 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.580169899@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [120/129] drm/radeon/kms/evergreen: fix backend setup
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit b741be82cf2079f71553af595610f17a3a3a752a upstream.

This patch fixes rendering errors on some evergreen boards.
Hardcoding the backend map is not an optimal solution, but
a better fix is being worked on.

Similar to the fix for rv740
(6271901d828b34b27607314026deaf417f9f9b75).

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=29986

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1143,14 +1143,25 @@ static void evergreen_gpu_init(struct ra
 									EVERGREEN_MAX_BACKENDS_MASK));
 			break;
 		}
-	} else
-		gb_backend_map =
-			evergreen_get_tile_pipe_to_backend_map(rdev,
-							       rdev->config.evergreen.max_tile_pipes,
-							       rdev->config.evergreen.max_backends,
-							       ((EVERGREEN_MAX_BACKENDS_MASK <<
-								 rdev->config.evergreen.max_backends) &
-								EVERGREEN_MAX_BACKENDS_MASK));
+	} else {
+		switch (rdev->family) {
+		case CHIP_CYPRESS:
+		case CHIP_HEMLOCK:
+			gb_backend_map = 0x66442200;
+			break;
+		case CHIP_JUNIPER:
+			gb_backend_map = 0x00006420;
+			break;
+		default:
+			gb_backend_map =
+				evergreen_get_tile_pipe_to_backend_map(rdev,
+								       rdev->config.evergreen.max_tile_pipes,
+								       rdev->config.evergreen.max_backends,
+								       ((EVERGREEN_MAX_BACKENDS_MASK <<
+									 rdev->config.evergreen.max_backends) &
+									EVERGREEN_MAX_BACKENDS_MASK));
+		}
+	}
 
 	WREG32(GB_BACKEND_MAP, gb_backend_map);
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);


