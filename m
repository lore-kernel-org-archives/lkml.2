Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1KCBxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:53:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934551Ab1KCBlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:42 2011
Message-Id: <20111102222742.620534792@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michal Sroczynski <msroczyn@gmail.com>
Subject: [032/101] USB: PL2303: correctly handle baudrates above 115200
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Sroczynski <msroczyn@gmail.com>

commit 8d48fdf689fed2c73c493e5146d1463689246442 upstream.

PL2303: correctly handle baudrates above 115200

Signed-off-by: Michal Sroczynski <msroczyn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/pl2303.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -616,10 +616,28 @@ static void pl2303_set_termios(struct tt
 				baud = 6000000;
 		}
 		dbg("%s - baud set = %d", __func__, baud);
-		buf[0] = baud & 0xff;
-		buf[1] = (baud >> 8) & 0xff;
-		buf[2] = (baud >> 16) & 0xff;
-		buf[3] = (baud >> 24) & 0xff;
+		if (baud <= 115200) {
+			buf[0] = baud & 0xff;
+			buf[1] = (baud >> 8) & 0xff;
+			buf[2] = (baud >> 16) & 0xff;
+			buf[3] = (baud >> 24) & 0xff;
+		} else {
+			/* apparently the formula for higher speeds is:
+			 * baudrate = 12M * 32 / (2^buf[1]) / buf[0]
+			 */
+			unsigned tmp = 12*1000*1000*32 / baud;
+			buf[3] = 0x80;
+			buf[2] = 0;
+			buf[1] = (tmp >= 256);
+			while (tmp >= 256) {
+				tmp >>= 2;
+				buf[1] <<= 1;
+			}
+			if (tmp > 256) {
+				tmp %= 256;
+			}
+			buf[0] = tmp;
+		}
 	}
 
 	/* For reference buf[4]=0 is 1 stop bits */


