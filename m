Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab0FAU7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:59:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab0FAUxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 14/31] vc: Locking clean up
Date: Tue,  1 Jun 2010 22:52:54 +0200
Message-Id: <1275425591-8803-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19F6lur1HjjWmYKcyAwwEDqk/nlZYeIYYaIlPP
 /tjctxGfRM6wniWGRSG359Cu//b/UhADstof7fbITGAfnpecbw
 5R3rS/zME0RRQ1wuGdwHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The virtual console layer uses the BKL for various things that don't really
need it. Clean them out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/selection.c |    4 ++++
 drivers/char/vt.c        |    7 ++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/selection.c b/drivers/char/selection.c
index f97b9e8..6e79340 100644
--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -26,6 +26,7 @@
 #include <linux/selection.h>
 #include <linux/tiocl.h>
 #include <linux/console.h>
+#include <linux/smp_lock.h>
 
 /* Don't take this from <ctype.h>: 011-015 on the screen aren't spaces */
 #define isspace(c)	((c) == ' ')
@@ -312,6 +313,8 @@ int paste_selection(struct tty_struct *tty)
 	struct  tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
 
+	lock_kernel();
+
 	acquire_console_sem();
 	poke_blanked_console();
 	release_console_sem();
@@ -335,5 +338,6 @@ int paste_selection(struct tty_struct *tty)
 	__set_current_state(TASK_RUNNING);
 
 	tty_ldisc_deref(ld);
+	unlock_kernel();
 	return 0;
 }
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7cdb6ee..9f42b1f 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -280,8 +280,12 @@ static inline unsigned short *screenpos(struct vc_data *vc, int offset, int view
 	return p;
 }
 
+/* Called  from the keyboard irq path.. */
 static inline void scrolldelta(int lines)
 {
+	/* FIXME */
+	/* scrolldelta needs some kind of consistency lock, but the BKL was
+	   and still is not protecting versus the scheduled back end */
 	scrollback_delta += lines;
 	schedule_console_callback();
 }
@@ -2604,8 +2608,6 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 		return -EFAULT;
 	ret = 0;
 
-	lock_kernel();
-
 	switch (type)
 	{
 		case TIOCL_SETSEL:
@@ -2680,7 +2682,6 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			ret = -EINVAL;
 			break;
 	}
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.7.0.4

