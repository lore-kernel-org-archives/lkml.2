Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684Ab1KJDpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:45:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965669Ab1KJDp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:02 2011
Message-Id: <20111109213202.067105003@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [196/264] drm/radeon/kms: split MSI check into a separate function
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8f6c25c59b0c895c68cae59d1b34e9a7b36971bc upstream.

This makes it easier to add quirks for certain systems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -108,6 +108,27 @@ void radeon_driver_irq_uninstall_kms(str
 	radeon_irq_set(rdev);
 }
 
+static bool radeon_msi_ok(struct radeon_device *rdev)
+{
+	/* RV370/RV380 was first asic with MSI support */
+	if (rdev->family < CHIP_RV380)
+		return false;
+
+	/* MSIs don't work on AGP */
+	if (rdev->flags & RADEON_IS_AGP)
+		return false;
+
+	if (rdev->flags & RADEON_IS_IGP) {
+		/* APUs work fine with MSIs */
+		if (rdev->family >= CHIP_PALM)
+			return true;
+		/* lots of IGPs have problems with MSIs */
+		return false;
+	}
+
+	return true;
+}
+
 int radeon_irq_kms_init(struct radeon_device *rdev)
 {
 	int i;
@@ -124,12 +145,8 @@ int radeon_irq_kms_init(struct radeon_de
 	}
 	/* enable msi */
 	rdev->msi_enabled = 0;
-	/* MSIs don't seem to work reliably on all IGP
-	 * chips.  Disable MSI on them for now.
-	 */
-	if ((rdev->family >= CHIP_RV380) &&
-	    ((!(rdev->flags & RADEON_IS_IGP)) || (rdev->family >= CHIP_PALM)) &&
-	    (!(rdev->flags & RADEON_IS_AGP))) {
+
+	if (radeon_msi_ok(rdev)) {
 		int ret = pci_enable_msi(rdev->pdev);
 		if (!ret) {
 			rdev->msi_enabled = 1;


