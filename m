Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab0GAVvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:51:08 -0400
Received: from kroah.org ([198.145.64.141]:60912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758985Ab0GAVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:49 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.825748331@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [076/200] drm/radeon/kms: release AGP bridge at suspend
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 10b06122afcc78468bd1d009633cb71e528acdc5 upstream.

I think it's good to release the AGP bridge at suspend
and reacquire it at resume. Also fix :
https://bugzilla.kernel.org/show_bug.cgi?id=15969

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon.h        |    1 +
 drivers/gpu/drm/radeon/radeon_agp.c    |    5 +++++
 drivers/gpu/drm/radeon/radeon_device.c |    2 ++
 3 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -566,6 +566,7 @@ typedef int (*radeon_packet3_check_t)(st
  */
 int radeon_agp_init(struct radeon_device *rdev);
 void radeon_agp_resume(struct radeon_device *rdev);
+void radeon_agp_suspend(struct radeon_device *rdev);
 void radeon_agp_fini(struct radeon_device *rdev);
 
 
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -270,3 +270,8 @@ void radeon_agp_fini(struct radeon_devic
 	}
 #endif
 }
+
+void radeon_agp_suspend(struct radeon_device *rdev)
+{
+	radeon_agp_fini(rdev);
+}
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -748,6 +748,8 @@ int radeon_suspend_kms(struct drm_device
 	/* evict remaining vram memory */
 	radeon_bo_evict_vram(rdev);
 
+	radeon_agp_suspend(rdev);
+
 	pci_save_state(dev->pdev);
 	if (state.event == PM_EVENT_SUSPEND) {
 		/* Shut down the device */


