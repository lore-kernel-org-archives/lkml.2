Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2J1XqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:46:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41905 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756553Ab2J1X1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:25 -0400
Message-Id: <20121028231602.732600498@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 083/105] USB: mct_u232: fix broken close
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
 
 


