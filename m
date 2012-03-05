Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab2CENzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:55:39 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34891 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab2CENxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH 19/68] XTENSA: iss/console, fix potential deadlock
Date: Mon,  5 Mar 2012 14:52:06 +0100
Message-Id: <1330955575-26641-20-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the timer ticks while we are holding the spinlock, the system
deadlocks. It is due to synchronous del_timer.

So to fix that, use spinlocks that properly disable bottom halves.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/platforms/iss/console.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 01842e4..94ab8ec 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -91,11 +91,10 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
  */
 static void rs_close(struct tty_struct *tty, struct file * filp)
 {
-	spin_lock(&timer_lock);
+	spin_lock_bh(&timer_lock);
 	if (tty->count == 1)
-		/* this will cause a deadlock if the timer ticks right now */
 		del_timer_sync(&serial_timer);
-	spin_unlock(&timer_lock);
+	spin_unlock_bh(&timer_lock);
 }
 
 
-- 
1.7.9.2


