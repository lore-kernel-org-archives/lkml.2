Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1IWI7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:59:47 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47002 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1IWI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:59:44 -0400
MIME-Version: 1.0
Date: Fri, 23 Sep 2011 10:59:43 +0200
Message-ID: <CAJnFFh3XRFEC49yFvjstreqqkeraA9GA1_AL-s9rj87HksdgBg@mail.gmail.com>
Subject: [PATCH] tty/n_gsm: fix bug in tiocmset
From: Nikola Diklic-Perin <diklic.perin.nikola@gmail.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: diklic.perin.nikola@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikola Diklic-Perin <diklic.perin.nikola@gmail.com>

Clear bitmask was not inverted before masking modem_tx.

Calling ioctl(fd, TIOCMBIC, TIOCM_RTS) results in:

[  197.430000] pre_modem_tx:	0x00000006
[  197.430000] clear:			0x00000004
[  197.430000] set:			0x00000000
[  197.440000] post_modem_tx:	0x00000004

which is wrong.

Signed-off-by: Nikola Diklic-Perin <diklic.perin.nikola@gmail.com>
---
--- a/drivers/tty/n_gsm.c	2011-09-22 18:19:16.592480805 +0200
+++ b/drivers/tty/n_gsm.c	2011-09-21 16:15:29.506800052 +0200
@@ -2982,7 +2982,7 @@ static int gsmtty_tiocmset(struct tty_st
 	struct gsm_dlci *dlci = tty->driver_data;
 	unsigned int modem_tx = dlci->modem_tx;

-	modem_tx &= clear;
+	modem_tx &= ~clear;
 	modem_tx |= set;

 	if (modem_tx != dlci->modem_tx) {
