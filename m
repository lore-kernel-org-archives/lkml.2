Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab2C0KBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:01:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44433 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab2C0KBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:01:36 -0400
Date: Tue, 27 Mar 2012 18:01:36 +0800
From: Wang YanQing <udknight@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        spock@gentoo.org
Subject: [PATCH] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120327100136.GA3829@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok! I try to check pcibios_enabled first, but get some opposition by Alan Cox,
but I want to make thing work and fix the oops, so I choice the simple way to
check the (__supported_pte_mask & _PAGE_NX) instead of to check this variable plus
pci kernel boot parameter, pci mmconfig works or not, and more, and more. It is not
the best method, but it works and maybe all will feel happy.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/uvesafb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 260cca7..26e83d7 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -815,8 +815,15 @@ static int __devinit uvesafb_vbe_init(struct fb_info *info)
 	par->pmi_setpal = pmi_setpal;
 	par->ypan = ypan;
 
-	if (par->pmi_setpal || par->ypan)
-		uvesafb_vbe_getpmi(task, par);
+	if (par->pmi_setpal || par->ypan) {
+		if (__supported_pte_mask & _PAGE_NX) {
+			par->pmi_setpal = par->ypan = 0;
+			printk(KERN_WARNING "uvesafb: NX protection is actively."
+				"We have better not to use the PMI.\n");
+		} else {
+			uvesafb_vbe_getpmi(task, par);
+		}
+	}
 #else
 	/* The protected mode interface is not available on non-x86. */
 	par->pmi_setpal = par->ypan = 0;
-- 
1.7.9.2.315.g25a78
