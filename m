Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab2EWSJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760655Ab2EWSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:09:51 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, matt.fleming@intel.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] x86: Expand EFI GOP handle search
Date: Wed, 23 May 2012 14:08:44 -0400
Message-Id: <1337796526-3649-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some UEFI implementations provide multiple GOP handles, with one acting
as a splitter device to handle the case of multiple outputs being present.
The downside of this approach is that the console splitter device may
report an inaccurate stride value. We currently get around this by looking
for a device that implements the PCI IO protocol. However, this fails on
some devices - the GOP may be attached to the display device rather than
the GPU. We can handle that scenario by looking for a handle with an EDID
protocol attached to it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c |   27 ++++++++++++++++-----------
 include/linux/efi.h              |    3 +++
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 0cdfc0d..781d9f5 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -257,7 +257,8 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	for (i = 0; i < nr_gops; i++) {
 		struct efi_graphics_output_mode_info *info;
 		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
-		void *pciio;
+		efi_guid_t edid_proto = EFI_EDID_DISCOVERED_GUID;
+		void *pciio, *edid;
 		void *h = gop_handle[i];
 
 		status = efi_call_phys3(sys_table->boottime->handle_protocol,
@@ -268,16 +269,20 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		efi_call_phys3(sys_table->boottime->handle_protocol,
 			       h, &pciio_proto, &pciio);
 
+		efi_call_phys3(sys_table->boottime->handle_protocol,
+			       h, &edid_proto, &edid);
+
 		status = efi_call_phys4(gop->query_mode, gop,
 					gop->mode->mode, &size, &info);
-		if (status == EFI_SUCCESS && (!first_gop || pciio)) {
+		if (status == EFI_SUCCESS && (!first_gop || pciio || edid)) {
 			/*
-			 * Apple provide GOPs that are not backed by
-			 * real hardware (they're used to handle
-			 * multiple displays). The workaround is to
-			 * search for a GOP implementing the PCIIO
-			 * protocol, and if one isn't found, to just
-			 * fallback to the first GOP.
+			 * Some vendors provide GOPs that are not
+			 * backed by real hardware (they're used to
+			 * handle multiple displays). The workaround
+			 * is to search for a GOP implementing the
+			 * PCIIO or EDID discovered protocol, and if
+			 * one isn't found, to just fallback to the
+			 * first GOP.
 			 */
 			width = info->horizontal_resolution;
 			height = info->vertical_resolution;
@@ -288,10 +293,10 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 			pixels_per_scan_line = info->pixels_per_scan_line;
 
 			/*
-			 * Once we've found a GOP supporting PCIIO,
-			 * don't bother looking any further.
+			 * Once we've found a GOP supporting PCIIO or
+			 * EDID, don't bother looking any further.
 			 */
-			if (pciio)
+			if (pciio || edid)
 				break;
 
 			first_gop = gop;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec45ccd..f6fd2ff 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -312,6 +312,9 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define EFI_FILE_SYSTEM_GUID \
     EFI_GUID(  0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
 
+#define EFI_EDID_DISCOVERED_GUID \
+    EFI_GUID(  0x1c0c34f6, 0xd380, 0x41fa, 0xa0, 0x49, 0x8a, 0xd0, 0x6c, 0x1a, 0x66, 0xaa )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
-- 
1.7.10.2

