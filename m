Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408Ab0EDWeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:34:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0EDWeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:34:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 07/13] tty: give up BTM in acquire_console_sem
Date: Wed,  5 May 2010 00:33:46 +0200
Message-Id: <1273012433-6125-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+tHUX5N25ByU1Kl3XwVOi5uFBs+HJTzSwLkM+
 Gcm4UbKmx/kUsEJYqOovWYGNWJYOAKmfXq/G/frMJnw0+oS/YP
 HIK5Z/jJWd3knI00u5BIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was not caught in the initial sweep through
the TTY layer, nor by lockdep, which does not know
about classic semaphores.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/printk.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 75077ad..30669a3 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -970,7 +970,16 @@ void resume_console(void)
 void acquire_console_sem(void)
 {
 	BUG_ON(in_interrupt());
-	down(&console_sem);
+	if (down_trylock(&console_sem)) {
+		/*
+		 * we may get called here with the BTM held.
+		 * it's not clear whether we get the BTM while
+		 * holding console_sem, need to check.
+		 */
+		release_tty_lock(current);
+		down(&console_sem);
+		reacquire_tty_lock(current);
+	}
 	if (console_suspended)
 		return;
 	console_locked = 1;
-- 
1.7.0.4

