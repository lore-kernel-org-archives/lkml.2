Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0LLXqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36015 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0LLXq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, dsd@laptop.org,
        jon.nettleton@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [86/223] viafb: use proper register for colour when doing fill ops
Message-Id: <20101212234625.B0E3AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

commit efd4f6398dc92b5bf392670df862f42a19f34cf2 upstream.

The colour was written to a wrong register for fillrect operations.
This sometimes caused empty console space (for example after 'clear')
to have a different colour than desired. Fix this by writing to the
correct register.
Many thanks to Daniel Drake and Jon Nettleton for pointing out this
issue and pointing me in the right direction for the fix.

Fixes http://dev.laptop.org/ticket/9323

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/video/via/accel.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/video/via/accel.c
===================================================================
--- linux.orig/drivers/video/via/accel.c
+++ linux/drivers/video/via/accel.c
@@ -283,11 +283,12 @@ static int hw_bitblt_2(void __iomem *eng
 		writel(tmp, engine + 0x1C);
 	}
 
-	if (op != VIA_BITBLT_COLOR)
+	if (op == VIA_BITBLT_FILL) {
+		writel(fg_color, engine + 0x58);
+	} else if (op == VIA_BITBLT_MONO) {
 		writel(fg_color, engine + 0x4C);
-
-	if (op == VIA_BITBLT_MONO)
 		writel(bg_color, engine + 0x50);
+	}
 
 	if (op == VIA_BITBLT_FILL)
 		ge_cmd |= fill_rop << 24 | 0x00002000 | 0x00000001;
