Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812Ab0HEWnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:43:53 -0400
Received: from kroah.org ([198.145.64.141]:37637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760483Ab0HEWYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/67] vc: Locking clean up
Date: Thu,  5 Aug 2010 15:22:54 -0700
Message-Id: <1281047014-23429-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
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
index a44ba81..321c928 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -281,8 +281,12 @@ static inline unsigned short *screenpos(struct vc_data *vc, int offset, int view
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
@@ -2609,8 +2613,6 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 		return -EFAULT;
 	ret = 0;
 
-	lock_kernel();
-
 	switch (type)
 	{
 		case TIOCL_SETSEL:
@@ -2685,7 +2687,6 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			ret = -EINVAL;
 			break;
 	}
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.7.2

