Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab2CENxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:18 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34612 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab2CENxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 11/68] ALPHA: srmcons, fix racy singleton structure
Date: Mon,  5 Mar 2012 14:51:58 +0100
Message-Id: <1330955575-26641-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test and the assignment were racy. Make it really a singleton.
This is achieved by one global variable initialized at the module
init.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/kernel/srmcons.c |   40 +++++-----------------------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index f1fdf17..2c89ce5c 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -33,7 +33,7 @@ struct srmcons_private {
 	struct tty_struct *tty;
 	struct timer_list timer;
 	spinlock_t lock;
-};
+} srmcons_singleton;
 
 typedef union _srmcons_result {
 	struct {
@@ -154,43 +154,10 @@ srmcons_chars_in_buffer(struct tty_struct *tty)
 }
 
 static int
-srmcons_get_private_struct(struct srmcons_private **ps)
-{
-	static struct srmcons_private *srmconsp = NULL;
-	static DEFINE_SPINLOCK(srmconsp_lock);
-	unsigned long flags;
-	int retval = 0;
-
-	if (srmconsp == NULL) {
-		srmconsp = kmalloc(sizeof(*srmconsp), GFP_KERNEL);
-		spin_lock_irqsave(&srmconsp_lock, flags);
-
-		if (srmconsp == NULL)
-			retval = -ENOMEM;
-		else {
-			srmconsp->tty = NULL;
-			spin_lock_init(&srmconsp->lock);
-			setup_timer(&srmconsp->timer, srmcons_receive_chars,
-					(unsigned long)srmconsp);
-		}
-
-		spin_unlock_irqrestore(&srmconsp_lock, flags);
-	}
-
-	*ps = srmconsp;
-	return retval;
-}
-
-static int
 srmcons_open(struct tty_struct *tty, struct file *filp)
 {
-	struct srmcons_private *srmconsp;
+	struct srmcons_private *srmconsp = &srmcons_singleton;
 	unsigned long flags;
-	int retval;
-
-	retval = srmcons_get_private_struct(&srmconsp);
-	if (retval)
-		return retval;
 
 	spin_lock_irqsave(&srmconsp->lock, flags);
 
@@ -236,6 +203,9 @@ static const struct tty_operations srmcons_ops = {
 static int __init
 srmcons_init(void)
 {
+	spin_lock_init(&srmcons_singleton.lock);
+	setup_timer(&srmcons_singleton.timer, srmcons_receive_chars,
+			(unsigned long)&srmcons_singleton);
 	if (srm_is_registered_console) {
 		struct tty_driver *driver;
 		int err;
-- 
1.7.9.2


