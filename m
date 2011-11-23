Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab1KWAnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:43:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759517Ab1KWAnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:43:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:08 2011
Message-Id: <20111123002408.078949615@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bart Hartgers <bart.hartgers@gmail.com>
Subject: [37/53] USB: ark3116 initialisation fix
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Hartgers <bart.hartgers@gmail.com>

commit 583182ba5f02c8c9be82ea550f2051eaec15b975 upstream.

This patch for the usb serial ark3116 driver fixes an initialisation
ordering bug that gets triggered on hotplug when using at least recent
debian/ubuntu userspace. Without it, ark3116 serial cables don't work.

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
Tested-by: law_ence.dev@ntlworld.com
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ark3116.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -42,7 +42,7 @@ static int debug;
  * Version information
  */
 
-#define DRIVER_VERSION "v0.6"
+#define DRIVER_VERSION "v0.7"
 #define DRIVER_AUTHOR "Bart Hartgers <bart.hartgers+ark3116@gmail.com>"
 #define DRIVER_DESC "USB ARK3116 serial/IrDA driver"
 #define DRIVER_DEV_DESC "ARK3116 RS232/IrDA"
@@ -380,10 +380,6 @@ static int ark3116_open(struct tty_struc
 		goto err_out;
 	}
 
-	/* setup termios */
-	if (tty)
-		ark3116_set_termios(tty, port, NULL);
-
 	/* remove any data still left: also clears error state */
 	ark3116_read_reg(serial, UART_RX, buf);
 
@@ -406,6 +402,10 @@ static int ark3116_open(struct tty_struc
 	/* enable DMA */
 	ark3116_write_reg(port->serial, UART_FCR, UART_FCR_DMA_SELECT);
 
+	/* setup termios */
+	if (tty)
+		ark3116_set_termios(tty, port, NULL);
+
 err_out:
 	kfree(buf);
 	return result;


