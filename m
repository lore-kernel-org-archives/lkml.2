Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2GaEuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48732 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474Ab2GaEui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:38 -0400
Message-Id: <20120731044319.583795666@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 52/73] drm/radeon: Try harder to avoid HW cursor ending on a multiple of
 128 columns.
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <michel.daenzer@amd.com>

commit f60ec4c7df043df81e62891ac45383d012afe0da upstream.

This could previously fail if either of the enabled displays was using a
horizontal resolution that is a multiple of 128, and only the leftmost column
of the cursor was (supposed to be) visible at the right edge of that display.

The solution is to move the cursor one pixel to the left in that case.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=33183

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_cursor.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cursor.c b/drivers/gpu/drm/radeon/radeon_cursor.c
index 42acc64..711e95a 100644
--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -262,8 +262,14 @@ int radeon_crtc_cursor_move(struct drm_crtc *crtc,
 				if (!(cursor_end & 0x7f))
 					w--;
 			}
-			if (w <= 0)
+			if (w <= 0) {
 				w = 1;
+				cursor_end = x - xorigin + w;
+				if (!(cursor_end & 0x7f)) {
+					x--;
+					WARN_ON_ONCE(x < 0);
+				}
+			}
 		}
 	}
 


