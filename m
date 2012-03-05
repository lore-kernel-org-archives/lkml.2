Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046Ab2CEOE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:04:27 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34701 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2CENxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 09/68] TTY: tty_driver, document tty->ops->shutdown limitation
Date: Mon,  5 Mar 2012 14:51:56 +0100
Message-Id: <1330955575-26641-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that tty->ops->shutdown is called from whatever context the user
drops the last tty reference from. E.g. if one takes a reference in
an ISR, tty close happens on other CPU and the final tty put is from
the ISR, tty->ops->shutdown will be called from that hard irq context.

We would have a problem in vt if we start using tty refcounting from
other contexts than user there. It is because vt's shutdown uses
mutexes. This is yet to be fixed.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/tty_driver.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index e064f17..6e6dbb7 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -50,6 +50,8 @@
  *	Note that tty_shutdown() is not called if ops->shutdown is defined.
  *	This means one is responsible to take care of calling ops->remove (e.g.
  *	via tty_driver_remove_tty) and releasing tty->termios.
+ *	Note that this hook may be called from *all* the contexts where one
+ *	uses tty refcounting (e.g. tty_port_tty_get).
  *
  *
  * void (*cleanup)(struct tty_struct * tty);
-- 
1.7.9.2


