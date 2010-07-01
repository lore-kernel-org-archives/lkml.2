Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab0GASez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:34:55 -0400
Received: from kroah.org ([198.145.64.141]:40689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758062Ab0GASYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:01 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:15 2010
Message-Id: <20100701173215.575524532@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Mack <daniel@caiaq.de>, Johan Hovold <jhovold@gmail.com>,
       Alan Cox <alan@linux.intel.com>
Subject: [patch 104/149] USB: ftdi_sio: fix DTR/RTS line modes
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <daniel@caiaq.de>

commit 6a1a82df91fa0eb1cc76069a9efe5714d087eccd upstream.

Call set_mctrl() and clear_mctrl() according to the flow control mode
selected. This makes serial communication for FT232 connected devices
work when CRTSCTS is not set.

This fixes a regression introduced by 4175f3e31 ("tty_port: If we are
opened non blocking we still need to raise the carrier"). This patch
calls the low-level driver's dtr_rts() function which consequently sets
TIOCM_DTR | TIOCM_RTS. A later call to set_termios() without CRTSCTS in
cflags, however, does not reset these bits, and so data is not actually
sent out on the serial wire.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Johan Hovold <jhovold@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2306,6 +2306,8 @@ static void ftdi_set_termios(struct tty_
 				"urb failed to set to rts/cts flow control\n");
 		}
 
+		/* raise DTR/RTS */
+		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	} else {
 		/*
 		 * Xon/Xoff code
@@ -2353,6 +2355,8 @@ static void ftdi_set_termios(struct tty_
 			}
 		}
 
+		/* lower DTR/RTS */
+		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	}
 	return;
 }


