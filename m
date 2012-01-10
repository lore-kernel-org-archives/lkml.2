Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469Ab2AJXDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:03:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934448Ab2AJXDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:03:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:02 2012
Message-Id: <20120110215601.962315108@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [05/49] offb: Fix setting of the pseudo-palette for >8bpp
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 1bb0b7d21584b3f878e2bc880db62351ddee5185 upstream.

When using a >8bpp framebuffer, offb advertises truecolor, not directcolor,
and doesn't touch the color map even if it has a corresponding access method
for the real hardware.

Thus it needs to set the pseudo-palette with all 3 components of the color,
like other truecolor framebuffers, not with copies of the color index like
a directcolor framebuffer would do.

This went unnoticed for a long time because it's pretty hard to get offb
to kick in with anything but 8bpp (old BootX under MacOS will do that and
qemu does it).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/offb.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -100,36 +100,32 @@ static int offb_setcolreg(u_int regno, u
 			  u_int transp, struct fb_info *info)
 {
 	struct offb_par *par = (struct offb_par *) info->par;
-	int i, depth;
-	u32 *pal = info->pseudo_palette;
 
-	depth = info->var.bits_per_pixel;
-	if (depth == 16)
-		depth = (info->var.green.length == 5) ? 15 : 16;
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR) {
+		u32 *pal = info->pseudo_palette;
+		u32 cr = red >> (16 - info->var.red.length);
+		u32 cg = green >> (16 - info->var.green.length);
+		u32 cb = blue >> (16 - info->var.blue.length);
+		u32 value;
 
-	if (regno > 255 ||
-	    (depth == 16 && regno > 63) ||
-	    (depth == 15 && regno > 31))
-		return 1;
+		if (regno >= 16)
+			return -EINVAL;
 
-	if (regno < 16) {
-		switch (depth) {
-		case 15:
-			pal[regno] = (regno << 10) | (regno << 5) | regno;
-			break;
-		case 16:
-			pal[regno] = (regno << 11) | (regno << 5) | regno;
-			break;
-		case 24:
-			pal[regno] = (regno << 16) | (regno << 8) | regno;
-			break;
-		case 32:
-			i = (regno << 8) | regno;
-			pal[regno] = (i << 16) | i;
-			break;
+		value = (cr << info->var.red.offset) |
+			(cg << info->var.green.offset) |
+			(cb << info->var.blue.offset);
+		if (info->var.transp.length > 0) {
+			u32 mask = (1 << info->var.transp.length) - 1;
+			mask <<= info->var.transp.offset;
+			value |= mask;
 		}
+		pal[regno] = value;
+		return 0;
 	}
 
+	if (regno > 255)
+		return -EINVAL;
+
 	red >>= 8;
 	green >>= 8;
 	blue >>= 8;


