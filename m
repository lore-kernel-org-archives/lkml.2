Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab0G3LJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:09:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59880 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab0G3LJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Cjm1PQtmY70y1IS3AL9ghUVhUPCw6adivEoQyQ8vTP0tfwKR5tuWGMdvM5XBl8xGsJ
         2TayA3IEHeGQrrr1VMruPrkc2+iyD5YhFJCaLCEVBOkldah+5DXvEUX/J9DVhROgCuqT
         9Wt/SzCqCPWcdKPKsxst0smndW4OFewslJk3A=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
        Peter Huewe <peterhuewe@gmx.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] staging: panel: check put_user() return value
Date: Fri, 30 Jul 2010 15:08:42 +0400
Message-Id: <1280488123-20859-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() may fail, if so return -EFAULT and do not update driver
pointers.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/panel/panel.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index f58da32..57f4946 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1589,25 +1589,30 @@ void lcd_init(void)
 static ssize_t keypad_read(struct file *file,
 			   char *buf, size_t count, loff_t *ppos)
 {
-
+	int buflen = keypad_buflen;
 	unsigned i = *ppos;
 	char *tmp = buf;
+	int start = keypad_start;
 
-	if (keypad_buflen == 0) {
+	if (buflen == 0) {
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
 		interruptible_sleep_on(&keypad_read_wait);
 		if (signal_pending(current))
 			return -EINTR;
+		buflen = keypad_buflen;
 	}
 
-	for (; count-- > 0 && (keypad_buflen > 0);
-	     ++i, ++tmp, --keypad_buflen) {
-		put_user(keypad_buffer[keypad_start], tmp);
-		keypad_start = (keypad_start + 1) % KEYPAD_BUFFER;
+	for (; count-- > 0 && (buflen > 0);
+	     ++i, ++tmp, --buflen) {
+		if (put_user(keypad_buffer[start], tmp))
+			return -EFAULT;
+		start = (start + 1) % KEYPAD_BUFFER;
 	}
 	*ppos = i;
+	keypad_buflen = buflen;
+	keypad_start = start;
 
 	return tmp - buf;
 }
-- 
1.7.0.4

