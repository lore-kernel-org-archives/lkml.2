Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2JZAHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:07:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:53484 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab2JZAHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicolas Boullis <nboullis@debian.org>, Oliver Neukum <oneukum@suse.de>
Subject: [ 21/85] usb: acm: fix the computation of the number of data bits
Date: Thu, 25 Oct 2012 17:05:39 -0700
Message-Id: <20121026000033.246145177@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Boullis <nboullis@debian.org>

commit 301a29da6e891e7eb95c843af0ecdbe86d01f723 upstream.

The current code assumes that CSIZE is 0000060, which appears to be
wrong on some arches (such as powerpc).

Signed-off-by: Nicolas Boullis <nboullis@debian.org>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -818,10 +818,6 @@ static const __u32 acm_tty_speed[] = {
 	2500000, 3000000, 3500000, 4000000
 };
 
-static const __u8 acm_tty_size[] = {
-	5, 6, 7, 8
-};
-
 static void acm_tty_set_termios(struct tty_struct *tty,
 						struct ktermios *termios_old)
 {
@@ -835,7 +831,21 @@ static void acm_tty_set_termios(struct t
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
 


