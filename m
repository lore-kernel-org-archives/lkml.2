Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2B0BEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 20:04:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2B0BEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 20:04:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of udknight@gmail.com designates 10.50.34.202 as permitted sender) smtp.mail=udknight@gmail.com; dkim=pass header.i=udknight@gmail.com
Date: Mon, 27 Feb 2012 09:04:29 +0800
From: Wang YanQing <udknight@gmail.com>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        x86@kernel.org, hpa@linux.intel.com
Subject: [PATCH 2/2] video:uvesafb: Fix oops when uvesafb try to execute
 NX-protected page
Message-ID: <20120227010429.GC4019@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>, spock@gentoo.org,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	x86@kernel.org, hpa@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 5bd5a452662bc37c54fb6828db1a3faf87e6511c add NX protection for kernel
data. So on many machine (like my machine Aspire 4741 and other three machines I
have tested) this commit will make the BIOS NX,  then when uvesafb use PMI and
try to execute NX-protected page, Oops!
This patch try to resolve it!
(I have try to let uvesafb_pan_display use v86d to do pan, but it works very
very bad, so I give it up)

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/uvesafb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index e7f69ef..f7e326f 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -23,6 +23,7 @@
 #include <video/uvesafb.h>
 #ifdef CONFIG_X86
 #include <video/vga.h>
+#include <linux/pci.h>
 #endif
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
@@ -812,11 +813,16 @@ static int __devinit uvesafb_vbe_init(struct fb_info *info)
 
 	par->nocrtc = nocrtc;
 #ifdef CONFIG_X86_32
+	if (check_pcibios_enabled()) {
 	par->pmi_setpal = pmi_setpal;
 	par->ypan = ypan;
 
 	if (par->pmi_setpal || par->ypan)
 		uvesafb_vbe_getpmi(task, par);
+	} else {
+		par->pmi_setpal = par->ypan = 0;
+		printk(KERN_WARNING "uvesafb: PCI BIOS is NX, can't use PMI. Use redraw instead\n");
+	}
 #else
 	/* The protected mode interface is not available on non-x86. */
 	par->pmi_setpal = par->ypan = 0;
-- 
1.7.3.4

