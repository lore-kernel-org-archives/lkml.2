Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab0FRUXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:23:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab0FRUXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:23:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@redhat.com>
Subject: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze phase of hibernation
Date: Fri, 18 Jun 2010 22:21:57 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       "dri-devel" <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ondrej Zary <linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006182221.57333.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

I have recently noticed a 55 sec. delay during the "device freeze"
phase of hibernation on my test-bed HP nx6325.  Due to the 100%
reproducibility of it I was able to narrow it down to
radeon_suspend_kms() and then it turned out that the delay occured
somewhere in radeon_bo_evict_vram().  However, it doesn't seem really
necessary or even very useful to me to evict VRAM at this particular
point, because we're going to create an image and bring the device
back to the fully functional state in a little while.  Thus, I think
the VRAM evicition can be skipped for state.event == PM_EVENT_FREEZE,
which makes the delay go away.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/gpu/drm/radeon/radeon_device.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/gpu/drm/radeon/radeon_device.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/radeon/radeon_device.c
+++ linux-2.6/drivers/gpu/drm/radeon/radeon_device.c
@@ -750,8 +750,11 @@ int radeon_suspend_kms(struct drm_device
 			}
 		}
 	}
-	/* evict vram memory */
-	radeon_bo_evict_vram(rdev);
+
+	if (state.event != PM_EVENT_FREEZE) {
+		/* evict vram memory */
+		radeon_bo_evict_vram(rdev);
+	}
 	/* wait for gpu to finish processing current batch */
 	radeon_fence_wait_last(rdev);
 
