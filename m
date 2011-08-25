Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1HYNMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:12:23 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49565 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1HYNMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:12:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3/5] TTY: define tty_wait_until_sent_from_close
Date: Thu, 25 Aug 2011 15:12:06 +0200
Message-Id: <1314277928-13388-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314277928-13388-1-git-send-email-jslaby@suse.cz>
References: <4E556CB7.2010102@suse.cz>
 <1314277928-13388-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this helper to fix system stalls. The issue is that the rest
of the system TTYs wait for us to finish waiting. This wasn't an issue
with BKL. BKL used to unlock implicitly.

This is based on the Arnd suggestion.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/tty.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index a7720a4..a0bf319 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -604,6 +604,24 @@ extern void __lockfunc tty_lock(void) __acquires(tty_lock);
 extern void __lockfunc tty_unlock(void) __releases(tty_lock);
 
 /*
+ * this shall be called only from where BTM is held (like close)
+ *
+ * We need this to ensure nobody waits for us to finish while we are waiting.
+ * Without this we were encountering system stalls.
+ *
+ * This should be indeed removed with BTM removal later.
+ *
+ * Locking: BTM required. Nobody is allowed to hold port->mutex.
+ */
+static inline void tty_wait_until_sent_from_close(struct tty_struct *tty,
+		long timeout)
+{
+	tty_unlock(); /* tty->ops->close holds the BTM, drop it while waiting */
+	tty_wait_until_sent(tty, timeout);
+	tty_lock();
+}
+
+/*
  * wait_event_interruptible_tty -- wait for a condition with the tty lock held
  *
  * The condition we are waiting for might take a long time to
-- 
1.7.6


