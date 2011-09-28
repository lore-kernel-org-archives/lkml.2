Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1I1XH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:07:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951Ab1I1WqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:43 2011
Message-Id: <20110928220142.908367066@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Sroczynski <msroczyn@gmail.com>
Subject: [167/244] USB: PL2303: correctly handle baudrates above 115200
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -343,10 +343,28 @@ static void pl2303_set_termios(struct tt
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


