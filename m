Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2DQQHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:07:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:53509 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2DQQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:07:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, Jiri Slaby <jslaby@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH] s390: fix build failure in con3215.c tty wakeup tasklet
Date: Tue, 17 Apr 2012 12:07:09 -0400
Message-Id: <1334678829-30823-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334135699-30180-3-git-send-email-jslaby@suse.cz>
References: <1334135699-30180-3-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 86b26007a37d81e7aca242bb5b649473f8f81297 (tty-next)

    "TTY: con3215, use tty from tty_port"

removed the tty struct from the raw struct, causing:

  CC      drivers/s390/char/con3215.o
drivers/s390/char/con3215.c: In function 'raw3215_wakeup':
drivers/s390/char/con3215.c:339:16: error: 'struct raw3215_info' has no member named 'tty'
make[2]: *** [drivers/s390/char/con3215.o] Error 1

We can't simply add a tty to the args of raw3215_wakeup since
it is registered as a tasklet.  The flow is:

	raw3215_irq
		--> tty_port_tty_get
			--> raw3215_next_io
				--> tasklet_schedule
		--> tty_kref_put

so it seems we'll need to do a get/put in the raw3215_wakeup
tasklet as well.

Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index e928e04..759c43c 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -336,7 +336,13 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
 static void raw3215_wakeup(unsigned long data)
 {
 	struct raw3215_info *raw = (struct raw3215_info *) data;
-	tty_wakeup(raw->tty);
+	struct tty_struct *tty = tty_port_tty_get(&raw->port);
+
+	if (tty == NULL)
+		return;
+
+	tty_wakeup(tty);
+	tty_kref_put(tty);
 }
 
 /*
-- 
1.7.9.1

