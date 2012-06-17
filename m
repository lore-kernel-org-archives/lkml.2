Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab2FQShc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:37:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50204 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757926Ab2FQSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:37 -0400
Message-Id: <20120617175948.987692405@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 53/69] USB: mct_u232: Fix incorrect TIOCMSET return
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 1aa3c63cf0a79153ee13c8f82e4eb6c40b66a161 upstream.

The low level helper returns 1 on success. The ioctl should however return
0. As this is the only user of the helper return, make the helper return 0 or
an error code.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=43009
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mct_u232.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index d0ec1aa..a71fa0a 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -309,13 +309,16 @@ static int mct_u232_set_modem_ctrl(struct usb_serial *serial,
 			MCT_U232_SET_REQUEST_TYPE,
 			0, 0, buf, MCT_U232_SET_MODEM_CTRL_SIZE,
 			WDR_TIMEOUT);
-	if (rc < 0)
-		dev_err(&serial->dev->dev,
-			"Set MODEM CTRL 0x%x failed (error = %d)\n", mcr, rc);
+	kfree(buf);
+
 	dbg("set_modem_ctrl: state=0x%x ==> mcr=0x%x", control_state, mcr);
 
-	kfree(buf);
-	return rc;
+	if (rc < 0) {
+		dev_err(&serial->dev->dev,
+			"Set MODEM CTRL 0x%x failed (error = %d)\n", mcr, rc);
+		return rc;
+	}
+	return 0;
 } /* mct_u232_set_modem_ctrl */
 
 static int mct_u232_get_modem_stat(struct usb_serial *serial,


