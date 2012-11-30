Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651Ab2K3St7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:49:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:57727 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161083Ab2K3Sty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: [ 32/37] USB: mct_u232: fix broken close
Date: Fri, 30 Nov 2012 10:46:19 -0800
Message-Id: <20121130183900.693163813@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mct_u232.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -577,12 +577,14 @@ static void mct_u232_close(struct usb_se
 {
 	dbg("%s port %d", __func__, port->number);
 
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
 
 


