Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1BNQ5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:57:41 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57274 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab1BNQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:57:39 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/6] hci_ath: Fix the mess in this driver
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Feb 2011 16:28:18 +0000
Message-ID: <20110214162803.10571.55396.stgit@bob.linux.org.uk>
In-Reply-To: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
References: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Was this exploitable - who knows, but it was certainly totally broken

Signed-of-by: Alan Cox <alan@linux.intel.com>
---

 drivers/bluetooth/hci_ath.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/drivers/bluetooth/hci_ath.c b/drivers/bluetooth/hci_ath.c
index 6a160c1..bd34406 100644
--- a/drivers/bluetooth/hci_ath.c
+++ b/drivers/bluetooth/hci_ath.c
@@ -51,32 +51,32 @@ struct ath_struct {
 
 static int ath_wakeup_ar3k(struct tty_struct *tty)
 {
-	struct termios settings;
-	int status = tty->driver->ops->tiocmget(tty, NULL);
+	struct ktermios ktermios;
+	int status = tty->driver->ops->tiocmget(tty);
 
 	if (status & TIOCM_CTS)
 		return status;
 
 	/* Disable Automatic RTSCTS */
-	n_tty_ioctl_helper(tty, NULL, TCGETS, (unsigned long)&settings);
-	settings.c_cflag &= ~CRTSCTS;
-	n_tty_ioctl_helper(tty, NULL, TCSETS, (unsigned long)&settings);
+	memcpy(&ktermios, tty->termios, sizeof(ktermios));
+	ktermios.c_cflag &= ~CRTSCTS;
+	tty_set_termios(tty, &ktermios);
 
 	/* Clear RTS first */
-	status = tty->driver->ops->tiocmget(tty, NULL);
-	tty->driver->ops->tiocmset(tty, NULL, 0x00, TIOCM_RTS);
+	status = tty->driver->ops->tiocmget(tty);
+	tty->driver->ops->tiocmset(tty, 0x00, TIOCM_RTS);
 	mdelay(20);
 
 	/* Set RTS, wake up board */
-	status = tty->driver->ops->tiocmget(tty, NULL);
-	tty->driver->ops->tiocmset(tty, NULL, TIOCM_RTS, 0x00);
+	status = tty->driver->ops->tiocmget(tty);
+	tty->driver->ops->tiocmset(tty, TIOCM_RTS, 0x00);
 	mdelay(20);
 
-	status = tty->driver->ops->tiocmget(tty, NULL);
+	status = tty->driver->ops->tiocmget(tty);
 
-	n_tty_ioctl_helper(tty, NULL, TCGETS, (unsigned long)&settings);
-	settings.c_cflag |= CRTSCTS;
-	n_tty_ioctl_helper(tty, NULL, TCSETS, (unsigned long)&settings);
+	/* Disable Automatic RTSCTS */
+	ktermios.c_cflag |= CRTSCTS;
+	status = tty_set_termios(tty, &ktermios);
 
 	return status;
 }

