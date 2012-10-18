Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2JRU07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:26:59 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56791 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 07/21] TTY: ldisc, wait for idle ldisc in release
Date: Thu, 18 Oct 2012 22:26:33 +0200
Message-Id: <1350592007-9216-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We reintroduced tty_ldisc_wait_idle in 100eeae2c5c (TTY: restore
tty_ldisc_wait_idle) and used in set_ldisc. Then we added it also to
the hangup path in 92f6fa09bd453 (TTY: ldisc, do not close until there
are readers). And we noted that there is one more path:
~   Before 65b770468e98 tty_ldisc_wait_idle was called also from
~   tty_ldisc_release. It is called from tty_release, so I don't think
~   we need to restore that one.

Well, I was wrong. There might still be holders of an ldisc
reference. Not from userspace, but drivers. If they take a reference
and a user closes the device immediately after that, we have a
problem. ldisc is halted and closed by TTY, but the driver still may
call some ldisc's operation and cause a crash.

So restore the tty_ldisc_wait_idle call also to the third location
where it was before 65b770468e98 (tty-ldisc: turn ldisc user count
into a proper refcount). Now we should be safe with respect to the
ldisc reference counting as all* tty_ldisc_close paths are safely
called with reference count of one.

* Not the one in tty_ldisc_setup's fail path. But that is called
  before the first open finishes. So userspace does not see it yet.
  Even thought the driver is given the TTY already via ->install, it
  should not take a reference to the ldisc yet. If some driver is to
  do this, we should put one tty_ldisc_wait_idle also in the setup.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_ldisc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 0f2a2c5..47e3968 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -897,6 +897,11 @@ int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty)
 
 static void tty_ldisc_kill(struct tty_struct *tty)
 {
+	/* There cannot be users from userspace now. But there still might be
+	 * drivers holding a reference via tty_ldisc_ref. Do not steal them the
+	 * ldisc until they are done. */
+	tty_ldisc_wait_idle(tty, MAX_SCHEDULE_TIMEOUT);
+
 	mutex_lock(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
-- 
1.7.12.3


