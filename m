Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2HQM2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 08:28:07 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36289 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2HQM2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 08:28:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] TTY: check if tty->port is assigned
Date: Fri, 17 Aug 2012 14:27:52 +0200
Message-Id: <1345206472-6394-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.11.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And if not, complain loudly. None in-kernel module should trigger
that, but let us find out for sure. On the other hand, all the
out-of-tree modules will hit that. Give them some time (maybe one
release) to catch up.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 28c3e86..41e42f1 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1415,6 +1415,10 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 	if (!tty->port)
 		tty->port = driver->ports[idx];
 
+	WARN_RATELIMIT(!tty->port,
+			"%s: %s driver does not set tty->port. This will crash the kernel later. Fix the driver!\n",
+			__func__, tty->driver->name);
+
 	/*
 	 * Structures all installed ... call the ldisc open routines.
 	 * If we fail here just call release_tty to clean up.  No need
-- 
1.7.11.5


