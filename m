Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261Ab1GMKbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:31:35 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:37556 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965216Ab1GMKbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:31:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>,
        Andreas Bombe <aeb@debian.org>
Subject: [PATCH 1/2] TTY: ami_serial, remove BTM from wait_until_sent
Date: Wed, 13 Jul 2011 12:31:25 +0200
Message-Id: <1310553086-27427-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <201107122325.35013.arnd@arndb.de>
References: <201107122325.35013.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same as in "TTY: serial, remove BTM from wait_until_sent" we don't
need to take BTM in wait_until_sent of ami_serial. Exactly the same
as serial, ami_serial accesses some "info" members (xmit_fifo_size,
timeout), but their assignment on other places in the code is not
protected by BTM anyway.

So the BTM protects nothing here. This removal helps us to get rid of
tty_locked() and __big_tty_mutex_owner in the following patch. This
was suggested by Arnd.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Andreas Bombe <aeb@debian.org>
---
 drivers/tty/amiserial.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 2205795..6d43f55 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1529,7 +1529,6 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 {
 	struct async_struct * info = tty->driver_data;
 	unsigned long orig_jiffies, char_time;
-	int tty_was_locked = tty_locked();
 	int lsr;
 
 	if (serial_paranoia_check(info, tty->name, "rs_wait_until_sent"))
@@ -1541,12 +1540,6 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 	orig_jiffies = jiffies;
 
 	/*
-	 * tty_wait_until_sent is called from lots of places,
-	 * with or without the BTM.
-	 */
-	if (!tty_was_locked)
-		tty_lock();
-	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
 	 * interval should also be less than the timeout.
@@ -1586,8 +1579,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
-	if (!tty_was_locked)
-		tty_unlock();
+
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
-- 
1.7.6


