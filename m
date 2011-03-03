Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab1CCSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:00:22 -0500
Received: from mail.vyatta.com ([76.74.103.46]:40559 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab1CCSAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:00:19 -0500
Date: Thu, 3 Mar 2011 09:59:01 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video via: fix iomem access
Message-ID: <20110303095901.2a283be0@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is not respecting the iomem memory space restrictions
and does direct access. This works on x86 but is non-portable and
should not be done.  Converted memcpy() of 2 to readw.
Last post increment of romptr was unnecessary since pointer never
used after that.

Found by sparse, compile tested only.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
 drivers/video/via/lcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/via/lcd.c	2011-03-03 09:09:10.552604209 -0800
+++ b/drivers/video/via/lcd.c	2011-03-03 09:56:12.144398571 -0800
@@ -1064,34 +1064,33 @@ static struct display_timing lcd_centeri
 
 bool viafb_lcd_get_mobile_state(bool *mobile)
 {
-	unsigned char *romptr, *tableptr;
+	unsigned char __iomem *romptr, *tableptr, *biosptr;
 	u8 core_base;
-	unsigned char *biosptr;
 	/* Rom address */
-	u32 romaddr = 0x000C0000;
-	u16 start_pattern = 0;
+	const u32 romaddr = 0x000C0000;
+	u16 start_pattern;
 
 	biosptr = ioremap(romaddr, 0x10000);
+	start_pattern = readw(biosptr);
 
-	memcpy(&start_pattern, biosptr, 2);
 	/* Compare pattern */
 	if (start_pattern == 0xAA55) {
 		/* Get the start of Table */
 		/* 0x1B means BIOS offset position */
 		romptr = biosptr + 0x1B;
-		tableptr = biosptr + *((u16 *) romptr);
+		tableptr = biosptr + readw(romptr);
 
 		/* Get the start of biosver structure */
 		/* 18 means BIOS version position. */
 		romptr = tableptr + 18;
-		romptr = biosptr + *((u16 *) romptr);
+		romptr = biosptr + readw(romptr);
 
 		/* The offset should be 44, but the
 		   actual image is less three char. */
 		/* pRom += 44; */
 		romptr += 41;
 
-		core_base = *romptr++;
+		core_base = readb(romptr);
 
 		if (core_base & 0x8)
 			*mobile = false;
