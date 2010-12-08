Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0LHArI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:08 -0500
Received: from kroah.org ([198.145.64.141]:46021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab0LHArA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:00 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:27 2010
Message-Id: <20101208004427.822781810@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: [035/127] viafb: use proper register for colour when doing fill ops
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/video/via/accel.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -277,11 +277,12 @@ static int hw_bitblt_2(void __iomem *eng
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


