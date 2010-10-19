Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0JSQyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:54:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42520 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0JSQyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=nT72PWc57QX7PL+p5nPvaLwNIETqwxo7gJSs1wdn3RMxadSWb8nPwQWioALTA+vBzo
         Px8X8uzZgGBM/G5SCOfu+qlMj3Lf/ZvtfbIArLNcc0YzRB9UV9F0IdMWQtAYaMxk9t/l
         pR5OgCtKGnrCcKh7tSCKEvdqTPkRuJujTK/PA=
Subject: [PATCH] ATI FB driver: fix variable size warnings
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: Paul Mackerras <paulus@samba.org>, grant.likely@secretlab.ca,
        alex.kern@gmx.de, benh@kernel.crashing.org, mpatocka@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 13:53:52 -0300
Message-ID: <1287507232.2133.12.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATI FB driver: fix variable size warnings and get rid of two unused variables.

Basically revert the order of the for-loop and get rid of the ARRAY_SIZE()-1 bit, which causes the warning. The iterations produce the exact same result: exit if the PCI id is found. Otherwise (if no device is found, then 'i' should be the same value of the size of the amount of elements in the array).
My current randconfig showed the following:

drivers/video/aty/atyfb_base.c: In function ‘correct_chipset’:
drivers/video/aty/atyfb_base.c:441: warning: overflow in implicit constant conversion

This is compile-tested only.

PS: Not sure who deals with this, so please include CC if you know.

Thanks.
Davidlohr

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/video/aty/atyfb_base.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index f8d69ad..7771142 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -436,13 +436,13 @@ static int __devinit correct_chipset(struct atyfb_par *par)
 	u16 type;
 	u32 chip_id;
 	const char *name;
-	int i;
-
-	for (i = ARRAY_SIZE(aty_chips) - 1; i >= 0; i--)
+	int i, arrsize = ARRAY_SIZE(aty_chips);
+	
+	for (i = 0; i < arrsize; i++)
 		if (par->pci_id == aty_chips[i].pci_id)
 			break;
 
-	if (i < 0)
+	if (i == arrsize)
 		return -ENODEV;
 
 	name = aty_chips[i].name;
@@ -535,8 +535,6 @@ static int __devinit correct_chipset(struct atyfb_par *par)
 	return 0;
 }
 
-static char ram_dram[] __devinitdata = "DRAM";
-static char ram_resv[] __devinitdata = "RESV";
 #ifdef CONFIG_FB_ATY_GX
 static char ram_vram[] __devinitdata = "VRAM";
 #endif /* CONFIG_FB_ATY_GX */
-- 
1.7.0.4



