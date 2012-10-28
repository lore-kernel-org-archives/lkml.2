Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2J1Xhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:37:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853Ab2J1X15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:57 -0400
Message-Id: <20121028231554.587226007@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:33 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicolas Boullis <nboullis@debian.org>, Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 057/105] usb: acm: fix the computation of the number of data bits
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Boullis <nboullis@debian.org>

commit 301a29da6e891e7eb95c843af0ecdbe86d01f723 upstream.

The current code assumes that CSIZE is 0000060, which appears to be
wrong on some arches (such as powerpc).

Signed-off-by: Nicolas Boullis <nboullis@debian.org>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 572f4e7..6e49ec6 100644
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
 


