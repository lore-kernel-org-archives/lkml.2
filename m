Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2BWJOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:14:45 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17080 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2BWJOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:14:42 -0500
From: Tang Liang <liang.tang@oracle.com>
To: mjg59@srcf.ucam.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad.wilk@oracle.com, JBeulich@suse.com
Cc: liang.tang@oracle.com
Subject: [PATCH 5/5V2] Xen vga: add the xen efi video mode support
Date: Thu, 23 Feb 2012 17:14:18 +0800
Message-Id: <1329988458-27038-1-git-send-email-liang.tang@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
References: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F460350.004B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to add xen efi video support, it is required to add xen-efi's new
video type(XEN_VGATYPE_EFI_LFB) case handler in the function xen_init_vga
and set the video type to VIDEO_TYPE_EFI to enable efi video mode.

Signed-off-by: Tang Liang <liang.tang@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/vga.c          |    7 +++++++
 include/xen/interface/xen.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/vga.c b/arch/x86/xen/vga.c
index 1cd7f4d..6722e37 100644
--- a/arch/x86/xen/vga.c
+++ b/arch/x86/xen/vga.c
@@ -35,6 +35,7 @@ void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
 			info->u.text_mode_3.font_height;
 		break;
 
+	case XEN_VGATYPE_EFI_LFB:
 	case XEN_VGATYPE_VESA_LFB:
 		if (size < offsetof(struct dom0_vga_console_info,
 				    u.vesa_lfb.gbl_caps))
@@ -54,6 +55,12 @@ void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
 		screen_info->blue_pos = info->u.vesa_lfb.blue_pos;
 		screen_info->rsvd_size = info->u.vesa_lfb.rsvd_size;
 		screen_info->rsvd_pos = info->u.vesa_lfb.rsvd_pos;
+
+		if (info->video_type == XEN_VGATYPE_EFI_LFB) {
+			screen_info->orig_video_isVGA = VIDEO_TYPE_EFI;
+			break;
+		}
+
 		if (size >= offsetof(struct dom0_vga_console_info,
 				     u.vesa_lfb.gbl_caps)
 		    + sizeof(info->u.vesa_lfb.gbl_caps))
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index a890804..c84ba71 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -454,6 +454,7 @@ struct dom0_vga_console_info {
 	uint8_t video_type;
 #define XEN_VGATYPE_TEXT_MODE_3 0x03
 #define XEN_VGATYPE_VESA_LFB    0x23
+#define XEN_VGATYPE_EFI_LFB     0x70
 
 	union {
 		struct {
-- 
1.7.7.5

