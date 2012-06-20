Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2FTSWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2FTSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:44 -0400
Message-Id: <20120620173023.934663546@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>
Subject: [ 35/61] USB: mct_u232: Fix incorrect TIOCMSET return
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 1aa3c63cf0a79153ee13c8f82e4eb6c40b66a161 upstream.

The low level helper returns 1 on success. The ioctl should however return
0. As this is the only user of the helper return, make the helper return 0 or
an error code.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=43009
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mct_u232.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -317,13 +317,16 @@ static int mct_u232_set_modem_ctrl(struc
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


