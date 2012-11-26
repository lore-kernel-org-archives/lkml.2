Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab2KZRKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535Ab2KZRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Boullis <nboullis@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 171/270] usb: acm: fix the computation of the number of data bits
Date: Mon, 26 Nov 2012 14:57:41 -0200
Message-Id: <1353949160-26803-172-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Boullis <nboullis@debian.org>

commit 301a29da6e891e7eb95c843af0ecdbe86d01f723 upstream.

The current code assumes that CSIZE is 0000060, which appears to be
wrong on some arches (such as powerpc).

Signed-off-by: Nicolas Boullis <nboullis@debian.org>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/class/cdc-acm.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f4593ee..780e0d0 100644
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
@@ -835,7 +831,21 @@ static void acm_tty_set_termios(struct tty_struct *tty,
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
 
-- 
1.7.9.5

