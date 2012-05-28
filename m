Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2E1DmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:42:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab2E1D3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:36 -0400
Message-Id: <20120528031209.794305308@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Herrmann <dh.herrmann@googlemail.com>,
        Peter Bukovsky <bukovsky.peter@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 050/117] HID: wiimote: Fix IR data parser
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-wiimote.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/hid/hid-wiimote.c
+++ b/drivers/hid/hid-wiimote.c
@@ -829,7 +829,7 @@
 
 	/*
 	 * Basic IR data is encoded into 3 bytes. The first two bytes are the
-	 * upper 8 bit of the X/Y data, the 3rd byte contains the lower 2 bits
+	 * lower 8 bit of the X/Y data, the 3rd byte contains the upper 2 bits
 	 * of both.
 	 * If data is packed, then the 3rd byte is put first and slightly
 	 * reordered. This allows to interleave packed and non-packed data to
@@ -838,17 +838,11 @@
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


