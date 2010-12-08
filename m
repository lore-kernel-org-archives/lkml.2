Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0LHArn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:43 -0500
Received: from kroah.org ([198.145.64.141]:58462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0LHAri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:38 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:31 2010
Message-Id: <20101208004431.794699465@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [075/127] USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 677aeafe19e88c282af74564048243ccabb1c590 upstream.

This reverts commit 6a1a82df91fa0eb1cc76069a9efe5714d087eccd.

RTS and DTR should not be modified based on CRTSCTS when calling
set_termios.

Modem control lines are raised at port open by the tty layer and should stay
raised regardless of whether hardware flow control is enabled or not.

This is in conformance with the way serial ports work today and many
applications depend on this behaviour to be able to talk to hardware
implementing hardware flow control (without the applications actually using
it).

Hardware which expects different behaviour on these lines can always
use TIOCMSET/TIOCMBI[SC] after port open to change them.

Reported-by: Daniel Mack <daniel@caiaq.de>
Reported-by: Dave Mielke <dave@mielke.cc>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2365,8 +2365,6 @@ static void ftdi_set_termios(struct tty_
 				"urb failed to set to rts/cts flow control\n");
 		}
 
-		/* raise DTR/RTS */
-		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	} else {
 		/*
 		 * Xon/Xoff code
@@ -2414,8 +2412,6 @@ static void ftdi_set_termios(struct tty_
 			}
 		}
 
-		/* lower DTR/RTS */
-		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	}
 	return;
 }


