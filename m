Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2AXDMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:12:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab2AXCmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:25 2012
Message-Id: <20120124023925.617041061@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [019/129] radeon: Fix disabling PCI bus mastering on big endian hosts.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1855
Lines: 58

From: Michel Dänzer <michel.daenzer@amd.com>

commit 3df96909b75835d487a9178761622b0cbd7310d4 upstream.

It would previously write basically random bits to PCI configuration space...
Not very surprising that the GPU tended to stop responding completely. The
resulting MCE even froze the whole machine sometimes.

Now resetting the GPU after a lockup has at least a fighting chance of
succeeding.

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r100.c  |    5 +++--
 drivers/gpu/drm/radeon/rs600.c |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2177,6 +2177,7 @@ bool r100_gpu_is_lockup(struct radeon_de
 void r100_bm_disable(struct radeon_device *rdev)
 {
 	u32 tmp;
+	u16 tmp16;
 
 	/* disable bus mastering */
 	tmp = RREG32(R_000030_BUS_CNTL);
@@ -2187,8 +2188,8 @@ void r100_bm_disable(struct radeon_devic
 	WREG32(R_000030_BUS_CNTL, (tmp & 0xFFFFFFFF) | 0x00000040);
 	tmp = RREG32(RADEON_BUS_CNTL);
 	mdelay(1);
-	pci_read_config_word(rdev->pdev, 0x4, (u16*)&tmp);
-	pci_write_config_word(rdev->pdev, 0x4, tmp & 0xFFFB);
+	pci_read_config_word(rdev->pdev, 0x4, &tmp16);
+	pci_write_config_word(rdev->pdev, 0x4, tmp16 & 0xFFFB);
 	mdelay(1);
 }
 
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -324,10 +324,10 @@ void rs600_hpd_fini(struct radeon_device
 
 void rs600_bm_disable(struct radeon_device *rdev)
 {
-	u32 tmp;
+	u16 tmp;
 
 	/* disable bus mastering */
-	pci_read_config_word(rdev->pdev, 0x4, (u16*)&tmp);
+	pci_read_config_word(rdev->pdev, 0x4, &tmp);
 	pci_write_config_word(rdev->pdev, 0x4, tmp & 0xFFFB);
 	mdelay(1);
 }


