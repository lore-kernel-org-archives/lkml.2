Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672Ab2E0BPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:15:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965653Ab2E0BPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:15:39 -0400
Message-Id: <20120527002512.048281778@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:30 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Bukovsky <bukovsky.peter@gmail.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 24/91] HID: wiimote: Fix IR data parser
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@googlemail.com>

commit 74b89e8a3625c17c7452532dfb997ac4f1a38751 upstream.

We incorrectly parse incoming IR data. The extra byte contains the upper
bits and not the lower bits of the x/y coordinates. User-space expects
absolute position data from us so this patch does not break existing
applications. On the contrary, it extends the virtual view and fixes
garbage reports for margin areas of the virtual screen.

Reported-by: Peter Bukovsky <bukovsky.peter@gmail.com>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-wiimote-core.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/hid/hid-wiimote-core.c
+++ b/drivers/hid/hid-wiimote-core.c
@@ -769,7 +769,7 @@ static void __ir_to_input(struct wiimote
 
 	/*
 	 * Basic IR data is encoded into 3 bytes. The first two bytes are the
-	 * upper 8 bit of the X/Y data, the 3rd byte contains the lower 2 bits
+	 * lower 8 bit of the X/Y data, the 3rd byte contains the upper 2 bits
 	 * of both.
 	 * If data is packed, then the 3rd byte is put first and slightly
 	 * reordered. This allows to interleave packed and non-packed data to
@@ -778,17 +778,11 @@ static void __ir_to_input(struct wiimote
 	 */
 
 	if (packed) {
-		x = ir[1] << 2;
-		y = ir[2] << 2;
-
-		x |= ir[0] & 0x3;
-		y |= (ir[0] >> 2) & 0x3;
+		x = ir[1] | ((ir[0] & 0x03) << 8);
+		y = ir[2] | ((ir[0] & 0x0c) << 6);
 	} else {
-		x = ir[0] << 2;
-		y = ir[1] << 2;
-
-		x |= (ir[2] >> 4) & 0x3;
-		y |= (ir[2] >> 6) & 0x3;
+		x = ir[0] | ((ir[2] & 0x30) << 4);
+		y = ir[1] | ((ir[2] & 0xc0) << 2);
 	}
 
 	input_report_abs(wdata->ir, xid, x);


