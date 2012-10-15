Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2JOWG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:06:29 -0400
Received: from tryphon.debian.net ([109.190.112.8]:52204 "EHLO
	tryphon.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab2JOWG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:06:27 -0400
Date: Tue, 16 Oct 2012 00:06:23 +0200
From: Nicolas Boullis <nboullis@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: acm: fix the computation of the number of data bits
Message-ID: <20121015220622.GD1985@tryphon.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Boullis <nboullis@debian.org>

The current code assumes that CSIZE is 0000060, which appears to be 
wrong on some arches (such as powerpc).

Signed-off-by: Nicolas Boullis <nboullis@debian.org>
Acked-by: Oliver Neukum <oneukum@suse.de>
---
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 981f213..194fa8b 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -817,10 +817,6 @@ static const __u32 acm_tty_speed[] = {
 	2500000, 3000000, 3500000, 4000000
 };
 
-static const __u8 acm_tty_size[] = {
-	5, 6, 7, 8
-};
-
 static void acm_tty_set_termios(struct tty_struct *tty,
 						struct ktermios *termios_old)
 {
@@ -834,7 +830,21 @@ static void acm_tty_set_termios(struct tty_struct *tty,
 	newline.bParityType = termios->c_cflag & PARENB ?
 				(termios->c_cflag & PARODD ? 1 : 2) +
 				(termios->c_cflag & CMSPAR ? 2 : 0) : 0;
-	newline.bDataBits = acm_tty_size[(termios->c_cflag & CSIZE) >> 4];
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		newline.bDataBits = 5;
+		break;
+	case CS6:
+		newline.bDataBits = 6;
+		break;
+	case CS7:
+		newline.bDataBits = 7;
+		break;
+	case CS8:
+	default:
+		newline.bDataBits = 8;
+		break;
+	}
 	/* FIXME: Needs to clear unsupported bits in the termios */
 	acm->clocal = ((termios->c_cflag & CLOCAL) != 0);
 

