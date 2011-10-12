Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1JLJij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:38:39 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:54117 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1JLJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:38:38 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Oct 2011 05:38:38 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>, Alan Cox <alan@redhat.com>
Subject: [PATCH 4/4] TTY: call tty_driver_lookup_tty unconditionally
Date: Wed, 12 Oct 2011 11:32:45 +0200
Message-Id: <1318411965-23917-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318411965-23917-1-git-send-email-jslaby@suse.cz>
References: <4E8C6836.1090601@suse.cz>
 <1318411965-23917-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4a2b5fddd5 (Move tty lookup/reopen to caller) made the call to
tty_driver_lookup_tty conditional in tty_open. It doesn't look like it
was an intention. Or if it was, it was not documented in the changelog
and the code now looks weird. For example there would be no need to
remember the tty driver and tty index. Further the condition depends
on a tty which we drop a reference of already.

If I'm looking correctly, this should not matter thanks to the locking
currently done there. Thus, tty_driver->ttys[idx] cannot change under
our hands. But anyway, it makes sense to change that to the old
behaviour.

Introduced-in: v2.6.28-rc2
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Alan Cox <alan@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1a890e2..3283d0a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1820,7 +1820,7 @@ int tty_release(struct inode *inode, struct file *filp)
 
 static int tty_open(struct inode *inode, struct file *filp)
 {
-	struct tty_struct *tty = NULL;
+	struct tty_struct *tty;
 	int noctty, retval;
 	struct tty_driver *driver;
 	int index;
@@ -1891,17 +1891,14 @@ retry_open:
 		return -ENODEV;
 	}
 got_driver:
-	if (!tty) {
-		/* check whether we're reopening an existing tty */
-		tty = tty_driver_lookup_tty(driver, inode, index);
-
-		if (IS_ERR(tty)) {
-			tty_unlock();
-			mutex_unlock(&tty_mutex);
-			tty_driver_kref_put(driver);
-			tty_free_file(filp);
-			return PTR_ERR(tty);
-		}
+	/* check whether we're reopening an existing tty */
+	tty = tty_driver_lookup_tty(driver, inode, index);
+	if (IS_ERR(tty)) {
+		tty_unlock();
+		mutex_unlock(&tty_mutex);
+		tty_driver_kref_put(driver);
+		tty_free_file(filp);
+		return PTR_ERR(tty);
 	}
 
 	if (tty) {
-- 
1.7.7


