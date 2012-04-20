Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab2DTPxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:53:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57325 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab2DTPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:53:31 -0400
From: Emil Goode <emilgoode@gmail.com>
To: gregkh@linuxfoundation.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] drivers/tty: Use get_user instead of dereferencing user pointer
Date: Fri, 20 Apr 2012 17:52:34 +0200
Message-Id: <1334937154-23037-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use the get_user macro instead of dereferencing user
pointers directly.

This patch fixes the following sparse warning:
drivers/tty/n_tty.c:1648:51: warning:
	dereference of noderef expression

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
I'm a newbie so please review carefully.
Not sure if I should add error handling for the get_user call here.

 drivers/tty/n_tty.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 94b6eda..5ff63cc 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1630,6 +1630,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	int retval;
 	size_t n;
 	unsigned long flags;
+	unsigned char ch;
 
 	retval = 0;
 	spin_lock_irqsave(&tty->read_lock, flags);
@@ -1645,7 +1646,8 @@ static int copy_from_read_buf(struct tty_struct *tty,
 		tty->read_cnt -= n;
 		/* Turn single EOF into zero-length read */
 		if (L_EXTPROC(tty) && tty->icanon && n == 1) {
-			if (!tty->read_cnt && (*b)[n-1] == EOF_CHAR(tty))
+			get_user(ch, b[n-1]);
+			if (!tty->read_cnt && ch == EOF_CHAR(tty))
 				n--;
 		}
 		spin_unlock_irqrestore(&tty->read_lock, flags);
-- 
1.7.9.5

