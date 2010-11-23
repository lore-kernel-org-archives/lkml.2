Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0KWVjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:39:16 -0500
Received: from mtxmxout7.matrox.com ([138.11.2.97]:37675 "EHLO
	mtxmxout7.matrox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0KWVjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:39:15 -0500
X-Greylist: delayed 824 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2010 16:39:15 EST
X-Virus-MTX-Scanned: by Matrox Virus scanner at mars.matrox.com
Message-ID: <4CEC3475.5030709@matrox.com>
Date: Tue, 23 Nov 2010 16:39:01 -0500
From: Yannick Heneault <yannick_heneault@matrox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [BUG] VGA palette corruption in vgacon.c for EFI machine
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems there is a small problem of VGA palette corruption on EFI 
machine. When the kernel initializes the architecture, it checks if the 
machine is a EFI machine and if the memory at 0xa0000 is not tagged as 
conventional memory, which should not be the case because this is VGA 
memory. In that case, the kernel assumes that a VGA console can exist. I 
would think that this assumption is correct.

When the kernel initialize the console in vgacon_startup it checks if it 
can really use the VGA console. I think this is where a check is 
missing. Currently, the function can fail if a VESA boot mode is 
detected but not if a EFI boot mode was used. I think the code should be 
modified like this :

--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -377,7 +377,8 @@ static const char *vgacon_startup(void)
         u16 saved1, saved2;
         volatile u16 *p;

-       if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB) {
+       if (screen_info.orig_video_isVGA == VIDEO_TYPE_VLFB ||
+           screen_info.orig_video_isVGA == VIDEO_TYPE_EFI) {
               no_vga:
  #ifdef CONFIG_DUMMY_CONSOLE
                 conswitchp = &dummy_con;


In that case, the VGA console will fail and a dummy console will be 
temporary used until the EFI driver get loaded. At that point the 
console will be mapped to the EFI driver and graphics (splash screen and 
penguins) will appear correctly.

Currently, the function vgacon_startup doesn't fail and initialize the 
video card for a real VGA mode. This function change the first 16 
entries of the VGA palette. When the efifb driver kick-in, the palette 
is not restored to default ramp value, thus the 16 first entry remain in 
a modified state.

Thanks,

Yannick Heneault
