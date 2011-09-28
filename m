Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1I1X3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:29:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab1I1Wj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:30 2011
Message-Id: <20110928220130.740417354@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [052/244] drm/radeon/kms: make sure pci max read request size is valid on evergreen+ (v2)
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d054ac16eeb658bccadb06b12c39cee22243b10f upstream.

If the bios or OS sets the pci max read request size to 0 or an
invalid value (6,7), it can result in a hang or slowdown.  Check
and set it to something sane if it's invalid.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=42162

v2: use pci reg defines from include/linux/pci_regs.h

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |   27 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/ni.c        |    3 +++
 2 files changed, 30 insertions(+)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -41,6 +41,31 @@ static void evergreen_gpu_init(struct ra
 void evergreen_fini(struct radeon_device *rdev);
 static void evergreen_pcie_gen2_enable(struct radeon_device *rdev);
 
+void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
+{
+	u16 ctl, v;
+	int cap, err;
+
+	cap = pci_pcie_cap(rdev->pdev);
+	if (!cap)
+		return;
+
+	err = pci_read_config_word(rdev->pdev, cap + PCI_EXP_DEVCTL, &ctl);
+	if (err)
+		return;
+
+	v = (ctl & PCI_EXP_DEVCTL_READRQ) >> 12;
+
+	/* if bios or OS sets MAX_READ_REQUEST_SIZE to an invalid value, fix it
+	 * to avoid hangs or perfomance issues
+	 */
+	if ((v == 0) || (v == 6) || (v == 7)) {
+		ctl &= ~PCI_EXP_DEVCTL_READRQ;
+		ctl |= (2 << 12);
+		pci_write_config_word(rdev->pdev, cap + PCI_EXP_DEVCTL, ctl);
+	}
+}
+
 void evergreen_pre_page_flip(struct radeon_device *rdev, int crtc)
 {
 	/* enable the pflip int */
@@ -1866,6 +1891,8 @@ static void evergreen_gpu_init(struct ra
 
 	WREG32(GRBM_CNTL, GRBM_READ_TIMEOUT(0xff));
 
+	evergreen_fix_pci_max_read_req_size(rdev);
+
 	cc_gc_shader_pipe_config = RREG32(CC_GC_SHADER_PIPE_CONFIG) & ~2;
 
 	cc_gc_shader_pipe_config |=
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -39,6 +39,7 @@ extern int evergreen_mc_wait_for_idle(st
 extern void evergreen_mc_program(struct radeon_device *rdev);
 extern void evergreen_irq_suspend(struct radeon_device *rdev);
 extern int evergreen_mc_init(struct radeon_device *rdev);
+extern void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev);
 
 #define EVERGREEN_PFP_UCODE_SIZE 1120
 #define EVERGREEN_PM4_UCODE_SIZE 1376
@@ -669,6 +670,8 @@ static void cayman_gpu_init(struct radeo
 
 	WREG32(GRBM_CNTL, GRBM_READ_TIMEOUT(0xff));
 
+	evergreen_fix_pci_max_read_req_size(rdev);
+
 	mc_shared_chmap = RREG32(MC_SHARED_CHMAP);
 	mc_arb_ramcfg = RREG32(MC_ARB_RAMCFG);
 


