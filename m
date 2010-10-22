Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab0JVTHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:07:44 -0400
Received: from kroah.org ([198.145.64.141]:34295 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759303Ab0JVS4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.552275590@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [069/103] drm/radeon/kms: fix potential segfault in r600_ioctl_wait_idle
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit e488459a0e131acc9e14df093cfee740bc431953 upstream.

radeon_gem_wait_idle_ioctl can apparently get called prior to
the vram page being set up or even if accel if false, so make
sure it's valid before using it.

Should fix:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=597636
https://bugs.freedesktop.org/show_bug.cgi?id=29834

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3522,7 +3522,8 @@ void r600_ioctl_wait_idle(struct radeon_
 	/* r7xx hw bug.  write to HDP_DEBUG1 followed by fb read
 	 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
 	 */
-	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740)) {
+	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740) &&
+	    rdev->vram_scratch.ptr) {
 		void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
 		u32 tmp;
 


