Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab0LHBDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:42 -0500
Received: from kroah.org ([198.145.64.141]:33759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759Ab0LHBDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:37 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:45 2010
Message-Id: <20101208005745.797971158@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Feng Tang <feng.tang@intel.com>
Subject: [244/289] serial: mfd: adjust the baud rate setting
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit a5880a9e5bb40fbae55de60051d69a29091053c3 upstream.

Previous baud rate setting code only has been tested with 3.5M/9600/
115200/230400/460800 bps, and recently we got a 3M bps device to test,
which needs to modify current MUL register setting, and with this
patch 2.5M/2M/1.5M/1M/0.5M should also work as they just use a MUL
value scale down from 3M's.

Also got some reference register setting from silicon guys for
different baud rates, which tries to keep the pre-scalar register value
to 16.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/mfd.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -892,8 +892,7 @@ serial_hsu_set_termios(struct uart_port
 	unsigned char cval, fcr = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
-	u32 mul = 0x3600;
-	u32 ps = 0x10;
+	u32 ps, mul;
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS5:
@@ -937,20 +936,19 @@ serial_hsu_set_termios(struct uart_port
 		ps = 0xC;
 		quot = 1;
 		break;
-	case 2500000:
-		mul = 0x2710;
-		ps = 0x10;
-		quot = 1;
-		break;
 	case 18432000:
 		mul = 0x2400;
 		ps = 0x10;
 		quot = 1;
 		break;
+	case 3000000:
+	case 2500000:
+	case 2000000:
 	case 1500000:
-		mul = 0x1D4C;
-		ps = 0xc;
-		quot = 1;
+ 	case 1000000:
+ 	case 500000:
+		/* mul/ps/quot = 0x9C4/0x10/0x1 will make a 500000 bps */
+		mul = baud / 500000 * 0x9C4;
 		break;
 	default:
 		;


