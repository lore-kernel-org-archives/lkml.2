Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2HGT5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:57:12 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49898 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2HGT5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:57:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 01/41] TTY: pty, stop passing NULL to free_tty_struct
Date: Tue,  7 Aug 2012 21:47:26 +0200
Message-Id: <1344368886-24033-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case alloc_tty_struct fails in pty_common_install, we pass NULL to
free_tty_struct. This is invalid as the function is not ready to cope
with that. And even if it was, it is not nice to do that anyway.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/tty/pty.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d6579a9..b726c8b 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -302,9 +302,11 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	int retval = -ENOMEM;
 
 	o_tty = alloc_tty_struct();
+	if (!o_tty)
+		goto err;
 	ports[0] = kmalloc(sizeof **ports, GFP_KERNEL);
 	ports[1] = kmalloc(sizeof **ports, GFP_KERNEL);
-	if (!o_tty || !ports[0] || !ports[1])
+	if (!ports[0] || !ports[1])
 		goto err_free_tty;
 	if (!try_module_get(driver->other->owner)) {
 		/* This cannot in fact currently happen */
@@ -359,6 +361,7 @@ err_free_tty:
 	kfree(ports[0]);
 	kfree(ports[1]);
 	free_tty_struct(o_tty);
+err:
 	return retval;
 }
 
-- 
1.7.10.4


