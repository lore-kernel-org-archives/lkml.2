Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2CEOJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:09:55 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34628 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2CENxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 10/68] ALPHA: srmcons, use timer functions
Date: Mon,  5 Mar 2012 14:51:57 +0100
Message-Id: <1330955575-26641-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes the code more readable. We move the setup to the allocation
location because we need to initialize timers only once.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/kernel/srmcons.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 783f4e5..f1fdf17 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -79,10 +79,8 @@ srmcons_receive_chars(unsigned long data)
 	} 
 
 	spin_lock(&srmconsp->lock);
-	if (srmconsp->tty) {
-		srmconsp->timer.expires = jiffies + incr;
-		add_timer(&srmconsp->timer);
-	}
+	if (srmconsp->tty)
+		mod_timer(&srmconsp->timer, jiffies + incr);
 	spin_unlock(&srmconsp->lock);
 
 	local_irq_restore(flags);
@@ -172,7 +170,8 @@ srmcons_get_private_struct(struct srmcons_private **ps)
 		else {
 			srmconsp->tty = NULL;
 			spin_lock_init(&srmconsp->lock);
-			init_timer(&srmconsp->timer);
+			setup_timer(&srmconsp->timer, srmcons_receive_chars,
+					(unsigned long)srmconsp);
 		}
 
 		spin_unlock_irqrestore(&srmconsp_lock, flags);
@@ -199,10 +198,7 @@ srmcons_open(struct tty_struct *tty, struct file *filp)
 		tty->driver_data = srmconsp;
 
 		srmconsp->tty = tty;
-		srmconsp->timer.function = srmcons_receive_chars;
-		srmconsp->timer.data = (unsigned long)srmconsp;
-		srmconsp->timer.expires = jiffies + 10;
-		add_timer(&srmconsp->timer);
+		mod_timer(&srmconsp->timer, jiffies + 10);
 	}
 
 	spin_unlock_irqrestore(&srmconsp->lock, flags);
-- 
1.7.9.2


