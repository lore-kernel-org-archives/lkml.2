Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2DZSNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:13:08 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:35584 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab2DZSNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:13:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Howard Chu <hyc@symas.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] TTY: n_tty, do not dereference user buffer
Date: Thu, 26 Apr 2012 20:13:00 +0200
Message-Id: <1335463980-14735-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_from_read_buf currently copies data to a user buffer and then
checks if the data is single EOF. But it checks it by accessing the
user buffer. First, the buffer may be changed by other threads of the
user program already. Second, it accesses the buffer without any
checks. It might be write-only for example.

Fix this by inspecting contents of the tty (kernel) buffer instead.
Note that "n == 1" is necessary, but not sufficient. But we check
later that there is nothing left by "!tty->read_cnt" condition.

There is still an issue with the current code that EOF being wrapped
to the start of the circular buffer will result in an inappropriate
losing of the EOF character. But this is not intended to be fixed by
this patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Emil Goode <emilgoode@gmail.com>
Cc: Howard Chu <hyc@symas.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/tty/n_tty.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 94b6eda..ee1c268 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1630,6 +1630,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	int retval;
 	size_t n;
 	unsigned long flags;
+	bool is_eof;
 
 	retval = 0;
 	spin_lock_irqsave(&tty->read_lock, flags);
@@ -1639,15 +1640,15 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	if (n) {
 		retval = copy_to_user(*b, &tty->read_buf[tty->read_tail], n);
 		n -= retval;
+		is_eof = n == 1 &&
+			tty->read_buf[tty->read_tail] == EOF_CHAR(tty);
 		tty_audit_add_data(tty, &tty->read_buf[tty->read_tail], n);
 		spin_lock_irqsave(&tty->read_lock, flags);
 		tty->read_tail = (tty->read_tail + n) & (N_TTY_BUF_SIZE-1);
 		tty->read_cnt -= n;
 		/* Turn single EOF into zero-length read */
-		if (L_EXTPROC(tty) && tty->icanon && n == 1) {
-			if (!tty->read_cnt && (*b)[n-1] == EOF_CHAR(tty))
-				n--;
-		}
+		if (L_EXTPROC(tty) && tty->icanon && is_eof && !tty->read_cnt)
+			n = 0;
 		spin_unlock_irqrestore(&tty->read_lock, flags);
 		*b += n;
 		*nr -= n;
-- 
1.7.9.2


