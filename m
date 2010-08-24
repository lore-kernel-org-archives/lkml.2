Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab0HXXJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:09:15 -0400
Received: from kroah.org ([198.145.64.141]:32790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933646Ab0HXXD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:27 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:09 2010
Message-Id: <20100824224509.231124306@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [092/114] drm/radeon/kms/pm: bail early if nothings changing
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 4e186b2d6c878793587c35d7f06c94565d76e9b8 upstream.

If we aren't changing the power state, no need to take
locks and schedule fences, etc.

There seem to be lock ordering issues in the CP and
fence code in some cases; see bug 29140 below.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=29140
Possibly also:
https://bugzilla.kernel.org/show_bug.cgi?id=16581

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -224,6 +224,11 @@ static void radeon_pm_set_clocks(struct
 {
 	int i;
 
+	/* no need to take locks, etc. if nothing's going to change */
+	if ((rdev->pm.requested_clock_mode_index == rdev->pm.current_clock_mode_index) &&
+	    (rdev->pm.requested_power_state_index == rdev->pm.current_power_state_index))
+		return;
+
 	mutex_lock(&rdev->ddev->struct_mutex);
 	mutex_lock(&rdev->vram_mutex);
 	mutex_lock(&rdev->cp.mutex);


