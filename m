Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2JMWn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 18:43:59 -0400
Received: from tryphon.debian.net ([109.190.112.8]:54284 "EHLO
	tryphon.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2JMWn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 18:43:57 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2012 18:43:57 EDT
Date: Sun, 14 Oct 2012 00:29:24 +0200
From: Nicolas Boullis <nboullis@debian.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: acm: fix the computation of the number of data bits
Message-ID: <20121013222923.GA1984@tryphon.debian.net>
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
 
