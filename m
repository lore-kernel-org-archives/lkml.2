Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2GaFBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:01:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49059 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755755Ab2GaFBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 01:01:47 -0400
Message-Id: <20120731044322.420055362@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 69/73] drm/radeon: fix non revealent error message
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 8d1c702aa0b2c4b22b0742b72a1149d91690674b upstream.

We want to print link status query failed only if it's
an unexepected fail. If we query to see if we need
link training it might be because there is nothing
connected and thus link status query have the right
to fail in that case.

To avoid printing failure when it's expected, move the
failure message to proper place.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_dp.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 0355536..7712cf5 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -22,6 +22,7 @@
  *
  * Authors: Dave Airlie
  *          Alex Deucher
+ *          Jerome Glisse
  */
 #include "drmP.h"
 #include "radeon_drm.h"
@@ -654,7 +655,6 @@ static bool radeon_dp_get_link_status(struct radeon_connector *radeon_connector,
 	ret = radeon_dp_aux_native_read(radeon_connector, DP_LANE0_1_STATUS,
 					link_status, DP_LINK_STATUS_SIZE, 100);
 	if (ret <= 0) {
-		DRM_ERROR("displayport link status failed\n");
 		return false;
 	}
 
@@ -833,8 +833,10 @@ static int radeon_dp_link_train_cr(struct radeon_dp_link_train_info *dp_info)
 		else
 			mdelay(dp_info->rd_interval * 4);
 
-		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status))
+		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status)) {
+			DRM_ERROR("displayport link status failed\n");
 			break;
+		}
 
 		if (dp_clock_recovery_ok(dp_info->link_status, dp_info->dp_lane_count)) {
 			clock_recovery = true;
@@ -896,8 +898,10 @@ static int radeon_dp_link_train_ce(struct radeon_dp_link_train_info *dp_info)
 		else
 			mdelay(dp_info->rd_interval * 4);
 
-		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status))
+		if (!radeon_dp_get_link_status(dp_info->radeon_connector, dp_info->link_status)) {
+			DRM_ERROR("displayport link status failed\n");
 			break;
+		}
 
 		if (dp_channel_eq_ok(dp_info->link_status, dp_info->dp_lane_count)) {
 			channel_eq = true;


