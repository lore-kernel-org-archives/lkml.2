Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1JLJm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:42:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56999 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1JLJm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:42:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, stable@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/4] TTY: pty, release tty in all ptmx_open fail paths
Date: Wed, 12 Oct 2011 11:32:44 +0200
Message-Id: <1318411965-23917-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318411965-23917-1-git-send-email-jslaby@suse.cz>
References: <4E8C6836.1090601@suse.cz>
 <1318411965-23917-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mistakenly, commit 64ba3dc3143d (tty: never hold BTM while getting
tty_mutex) switched one fail path in ptmx_open to not free the newly
allocated tty.

Fix that by jumping to the appropriate place. And rename the labels so
that it's clear what is going on there.

Introduced-in: v2.6.36-rc2
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/pty.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 696e851..e18604b 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -699,15 +699,15 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	retval = devpts_pty_new(inode, tty->link);
 	if (retval)
-		goto out1;
+		goto err_release;
 
 	retval = ptm_driver->ops->open(tty, filp);
 	if (retval)
-		goto out2;
-out1:
+		goto err_release;
+
 	tty_unlock();
-	return retval;
-out2:
+	return 0;
+err_release:
 	tty_unlock();
 	tty_release(inode, filp);
 	return retval;
-- 
1.7.7


