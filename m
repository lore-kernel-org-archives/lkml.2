Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab0HEWpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:45:05 -0400
Received: from kroah.org ([198.145.64.141]:37621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081Ab0HEWYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/67] tty: Fix the digi acceleport driver NULL checks
Date: Thu,  5 Aug 2010 15:22:49 -0700
Message-Id: <1281047014-23429-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This now refcounts but doesn't actually check the reference was obtained in
all the places it should.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/digi_acceleport.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index fd35f73..b92070c 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -609,8 +609,10 @@ static void digi_wakeup_write_lock(struct work_struct *work)
 static void digi_wakeup_write(struct usb_serial_port *port)
 {
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	tty_wakeup(tty);
-	tty_kref_put(tty);
+	if (tty) {
+		tty_wakeup(tty);
+		tty_kref_put(tty);
+	}
 }
 
 
@@ -1682,7 +1684,7 @@ static int digi_read_inb_callback(struct urb *urb)
 		priv->dp_throttle_restart = 1;
 
 	/* receive data */
-	if (opcode == DIGI_CMD_RECEIVE_DATA) {
+	if (tty && opcode == DIGI_CMD_RECEIVE_DATA) {
 		/* get flag from port_status */
 		flag = 0;
 
@@ -1763,10 +1765,12 @@ static int digi_read_oob_callback(struct urb *urb)
 			return -1;
 
 		tty = tty_port_tty_get(&port->port);
+
 		rts = 0;
-		rts = tty->termios->c_cflag & CRTSCTS;
+		if (tty)
+			rts = tty->termios->c_cflag & CRTSCTS;
 		
-		if (opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
+		if (tty && opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
 			spin_lock(&priv->dp_port_lock);
 			/* convert from digi flags to termiox flags */
 			if (val & DIGI_READ_INPUT_SIGNALS_CTS) {
-- 
1.7.2

