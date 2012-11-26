Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032Ab2KZRPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48213 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934106Ab2KZRPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 245/270] USB: mct_u232: fix broken close
Date: Mon, 26 Nov 2012 14:58:55 -0200
Message-Id: <1353949160-26803-246-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5260e458f5eff269a43e4f1e9c47186c57b88ddb upstream.

Make sure generic close is called at close.

The driver relies on the generic write implementation but did not call
generic close.

Note that the call to kill the read urb is not redundant, as mct_u232
uses an interrupt urb from the second port as the read urb and that
generic close therefore fails to kill it.

Compile-only tested.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/mct_u232.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index a71fa0a..d06130d 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -519,12 +519,14 @@ static void mct_u232_dtr_rts(struct usb_serial_port *port, int on)
 
 static void mct_u232_close(struct usb_serial_port *port)
 {
-	if (port->serial->dev) {
-		/* shutdown our urbs */
-		usb_kill_urb(port->write_urb);
-		usb_kill_urb(port->read_urb);
-		usb_kill_urb(port->interrupt_in_urb);
-	}
+	/*
+	 * Must kill the read urb as it is actually an interrupt urb, which
+	 * generic close thus fails to kill.
+	 */
+	usb_kill_urb(port->read_urb);
+	usb_kill_urb(port->interrupt_in_urb);
+
+	usb_serial_generic_close(port);
 } /* mct_u232_close */
 
 
-- 
1.7.9.5

