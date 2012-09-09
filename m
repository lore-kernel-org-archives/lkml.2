Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2IIXQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51364 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756143Ab2IIXQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:44 -0400
Message-Id: <20120909224158.559984573@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Lamparter <equinox@diac24.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: [ 57/95] drm/radeon: implement ACPI VFCT vbios fetch (v3)
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lamparter <equinox@diac24.net>

commit 268ba0a99f89a84dc5eb312470896113d0709c74 upstream.

This is required for pure UEFI systems.  The vbios is stored
in ACPI rather than at the legacy vga location.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=26891

V2: fix #ifdefs as per Greg's comments
V3: fix it harder

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_bios.c |   60 ++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 501f488..a32232f 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -32,6 +32,7 @@
 
 #include <linux/vga_switcheroo.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
 /*
  * BIOS.
  */
@@ -476,6 +477,63 @@ static bool radeon_read_disabled_bios(struct radeon_device *rdev)
 		return legacy_read_disabled_bios(rdev);
 }
 
+#ifdef CONFIG_ACPI
+static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
+{
+	bool ret = false;
+	struct acpi_table_header *hdr;
+	/* acpi_get_table_with_size is not exported :( */
+	acpi_size tbl_size = 0x7fffffff;
+	UEFI_ACPI_VFCT *vfct;
+	GOP_VBIOS_CONTENT *vbios;
+	VFCT_IMAGE_HEADER *vhdr;
+
+	if (!ACPI_SUCCESS(acpi_get_table("VFCT", 1, &hdr)))
+		return false;
+	if (tbl_size < sizeof(UEFI_ACPI_VFCT)) {
+		DRM_ERROR("ACPI VFCT table present but broken (too short #1)\n");
+		goto out_unmap;
+	}
+
+	vfct = (UEFI_ACPI_VFCT *)hdr;
+	if (vfct->VBIOSImageOffset + sizeof(VFCT_IMAGE_HEADER) > tbl_size) {
+		DRM_ERROR("ACPI VFCT table present but broken (too short #2)\n");
+		goto out_unmap;
+	}
+
+	vbios = (GOP_VBIOS_CONTENT *)((char *)hdr + vfct->VBIOSImageOffset);
+	vhdr = &vbios->VbiosHeader;
+	DRM_INFO("ACPI VFCT contains a BIOS for %02x:%02x.%d %04x:%04x, size %d\n",
+			vhdr->PCIBus, vhdr->PCIDevice, vhdr->PCIFunction,
+			vhdr->VendorID, vhdr->DeviceID, vhdr->ImageLength);
+
+	if (vhdr->PCIBus != rdev->pdev->bus->number ||
+	    vhdr->PCIDevice != PCI_SLOT(rdev->pdev->devfn) ||
+	    vhdr->PCIFunction != PCI_FUNC(rdev->pdev->devfn) ||
+	    vhdr->VendorID != rdev->pdev->vendor ||
+	    vhdr->DeviceID != rdev->pdev->device) {
+		DRM_INFO("ACPI VFCT table is not for this card\n");
+		goto out_unmap;
+	};
+
+	if (vfct->VBIOSImageOffset + sizeof(VFCT_IMAGE_HEADER) + vhdr->ImageLength > tbl_size) {
+		DRM_ERROR("ACPI VFCT image truncated\n");
+		goto out_unmap;
+	}
+
+	rdev->bios = kmemdup(&vbios->VbiosContent, vhdr->ImageLength, GFP_KERNEL);
+	ret = !!rdev->bios;
+
+out_unmap:
+	/* uh, no idea what to do here... */
+	return ret;
+}
+#else
+static inline bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
+{
+	return false;
+}
+#endif
 
 bool radeon_get_bios(struct radeon_device *rdev)
 {
@@ -484,6 +542,8 @@ bool radeon_get_bios(struct radeon_device *rdev)
 
 	r = radeon_atrm_get_bios(rdev);
 	if (r == false)
+		r = radeon_acpi_vfct_bios(rdev);
+	if (r == false)
 		r = igp_read_bios_from_vram(rdev);
 	if (r == false)
 		r = radeon_read_bios(rdev);


