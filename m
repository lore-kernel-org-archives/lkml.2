Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1AFQjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:39:22 -0500
Received: from mtxmxout6.matrox.com ([138.11.2.96]:54513 "EHLO
	mtxmxout6.matrox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1AFQjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:39:19 -0500
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 11:39:19 EST
X-Virus-MTX-Scanned: by Matrox Virus scanner at mars.matrox.com
Message-ID: <4D25E992.3070006@matrox.com>
Date: Thu, 06 Jan 2011 11:10:58 -0500
From: Yannick Heneault <yannick_heneault@matrox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org
CC: airlied@redhat.com, hpa@zytor.com
Subject: [PATCH] vgacon: checking for efi machine
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems there is a small problem of VGA palette corruption on EFI machine. When the kernel initializes the architecture, it checks if themachine is a EFI machine and assumes that a VGA console can exist. When it initialize the console in vgacon_startup it checks if itcan really use the VGA console. I think this is where a check ismissing. Currently, the function can fail if a VESA boot mode isdetected but not if a EFI boot mode was used. Thus, the function vgacon_startup doesn't fail and initialize thevideo card for a real VGA mode. This function change the first 16entries of the VGA palette. When the efifb driver kick-in, the paletteis not restored to default ramp value, thus the 16 first entry remain ina modified state. The following patch prevent this corruption.

Signed-off-by: Yannick Heneault<yheneaul@matrox.com>
---
diff -Nur linux-2.6.37-ori/drivers/video/console/vgacon.c linux-2.6.37/drivers/video/console/vgacon.c
--- linux-2.6.37-ori/drivers/video/console/vgacon.c	2011-01-04 19:50:19.000000000 -0500
+++ linux-2.6.37/drivers/video/console/vgacon.c	2011-01-06 10:38:24.713590593 -0500
@@ -375,7 +375,8 @@
  	u16 saved1, saved2;
  	volatile u16 *p;

-	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB) {
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB ||
+	    screen_info.orig_video_isVGA == VIDEO_TYPE_EFI) {
  	      no_vga:
  #ifdef CONFIG_DUMMY_CONSOLE
  		conswitchp =&dummy_con;



