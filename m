Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935550Ab1KJEi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:38:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857Ab1KJDfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:42 2011
Message-Id: <20111109213142.618409376@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:30:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [005/264] TTY: pty, release tty in all ptmx_open fail paths
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 1177c0efc04d032644895b8d757f55b433912596 upstream.

Mistakenly, commit 64ba3dc3143d (tty: never hold BTM while getting
tty_mutex) switched one fail path in ptmx_open to not free the newly
allocated tty.

Fix that by jumping to the appropriate place. And rename the labels so
that it's clear what is going on there.

Introduced-in: v2.6.36-rc2
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/pty.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -699,15 +699,15 @@ static int ptmx_open(struct inode *inode
 
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


