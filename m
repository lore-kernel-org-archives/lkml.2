Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab2G0VVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2G0VVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:21:04 -0400
From: Matthew Garrett <mjg@redhat.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pjones@redhat.com, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] x86, EFI: Calculate the EFI framebuffer size instead of trusting the firmware
Date: Fri, 27 Jul 2012 17:20:49 -0400
Message-Id: <1343424049-7460-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee reported that his system was reporting that the EFI framebuffer
stretched from 0x90010000-0xb0010000 despite the GPU's BAR only covering
0x90000000-0x9ffffff. It's safer to calculate this value from the pixel
stride and screen height (values we already depend on) rather than face
potential problems with resource allocation later on.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
---
 arch/x86/boot/compressed/eboot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b329312..fc7da79 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -447,7 +447,6 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	si->lfb_width = width;
 	si->lfb_height = height;
 	si->lfb_base = fb_base;
-	si->lfb_size = fb_size;
 	si->pages = 1;
 
 	if (pixel_format == PIXEL_RGB_RESERVED_8BIT_PER_COLOR) {
@@ -495,6 +494,8 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		si->rsvd_pos = 0;
 	}
 
+	si->lfb_size = si->lfb_linelength * si->lfb_height;
+
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
 
 free_handle:
-- 
1.7.10.4

