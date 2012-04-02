Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2DBLzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:50 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48058 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 47/69] TTY: ipwireless, use synchronous hangup
Date: Mon,  2 Apr 2012 13:54:31 +0200
Message-Id: <1333367693-3244-48-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not touch internal workqueue. Call tty_vhangup instead.

Note that finished hangup does not necessarily mean that all processes
are dead. Especially when the tty is a console. The code assumes that
right now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
---
 drivers/tty/ipwireless/tty.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 4daf962..e539621 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -565,11 +565,11 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 			ttyj->closing = 1;
 			if (ttyj->linux_tty != NULL) {
 				mutex_unlock(&ttyj->ipw_tty_mutex);
-				tty_hangup(ttyj->linux_tty);
-				/* Wait till the tty_hangup has completed */
-				flush_work_sync(&ttyj->linux_tty->hangup_work);
+				tty_vhangup(ttyj->linux_tty);
 				/* FIXME: Exactly how is the tty object locked here
 				   against a parallel ioctl etc */
+				/* FIXME2: hangup does not mean all processes
+				 * are gone */
 				mutex_lock(&ttyj->ipw_tty_mutex);
 			}
 			while (ttyj->open_count)
-- 
1.7.9.2


