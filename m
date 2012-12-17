Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2LQVb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:31:28 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63852 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab2LQVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:31:26 -0500
Message-ID: <1355779884.1414.14.camel@x61.thuisdomein>
Subject: [PATCH] [RFC] drm/radeon: return 0 on successful gpu reset
From: Paul Bolle <pebolle@tiscali.nl>
To: David Airlie <airlied@linux.ie>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 22:31:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2012 21:31:24.0716 (UTC) FILETIME=[DD771EC0:01CDDC9D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an (outdated) laptop the radeon driver (almost always) prints, during
the first resume of each session:
    [drm] crtc 1 is connected to a TV

This message is a bit puzzling as, as far as I know, no TV has ever
been connected to this laptop. Anyhow, before v3.5, if that happened the
radeon driver then printed an error during all following resumes:
    [drm:radeon_cs_ioctl] *ERROR* Failed to parse relocation -35!

(-35 is -EDEADLK.) But the resume would succeed and the driver seemed to
run without too much trouble. From v3.5 onwards things changed. If the
(puzzling) message about crtc 1 was printed on first resume the laptop
would simply hang on second resume. Only a manual power off would then
be possible. In that case nothing of interest would be found in the
(truncated) logs.  And, most annoyingly, the hang would never happen if
the laptop was booted with, say, "console=ttyS0,115200n8" added to the
kernel command line.

I bisected the hang to commit 6c6f478370eccfbfafbdc6fc55c0def03e58f124
("drm/radeon: rework recursive gpu reset handling"), which was added in
the v3.5 release cycle. After discovering that and poking at the driver
it turned out that this hang is triggered by radeon_cs_handle_lockup()
returning -EAGAIN after successfully resetting the gpu. Simply returning
0 makes the hang disappear (and makes the drm error reappear).

Nothing in the code or the commit explanation clarifies why -EAGAIN
should be returned on successful gpu reset. So I suggest
radeon_cs_handle_lockup() simply returns what radeon_gpu_reset()
returns, eg 0 (on success) or a negative error code (on failure).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This exact patch is untested (but I run something comparable).

1) Sent as an RFC because I do not understand why this laptop (almost
always) prints the "crtc 1" message on first resume. Note that another
workaround for this hang is simply booting with "radeon.tv=0".

2) Also sent as an RFC because I have no idea whatsoever why returning
-EAGAIN will hang the machine. I guess it's returned to userland by
radeon_cs_ioctl(). What code uses that ioctl? And what does that code do
on -EAGAIN that hangs this laptop?

3) A third reason to send this as an RFC is that I also have no idea why
this hang doesn't happen when booting with "console=ttyS0,115200n8" or
even "console=tty0"! But I guess I'm now allowed to call this hang a
Heisenbug.

 drivers/gpu/drm/radeon/radeon_cs.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 41672cc..a302c00 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -486,11 +486,8 @@ out:
 
 static int radeon_cs_handle_lockup(struct radeon_device *rdev, int r)
 {
-	if (r == -EDEADLK) {
+	if (r == -EDEADLK)
 		r = radeon_gpu_reset(rdev);
-		if (!r)
-			r = -EAGAIN;
-	}
 	return r;
 }
 
-- 
1.7.7.6

