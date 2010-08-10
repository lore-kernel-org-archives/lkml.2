Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab0HJWAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:00:25 -0400
Received: from kroah.org ([198.145.64.141]:44876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab0HJWAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/68] vc: Locking clean up
Date: Tue, 10 Aug 2010 14:58:49 -0700
Message-Id: <1281477570-18944-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The virtual console layer uses the BKL for various things that don't really
need it. Clean them out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
index 82f64ac..9f67ad9 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -287,8 +287,12 @@ static inline unsigned short *screenpos(struct vc_data *vc, int offset, int view
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
@@ -2616,8 +2620,6 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 		return -EFAULT;
 	ret = 0;
 
-	lock_kernel();
-
 	switch (type)
 	{
 		case TIOCL_SETSEL:
@@ -2692,7 +2694,6 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			ret = -EINVAL;
 			break;
 	}
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.7.2

