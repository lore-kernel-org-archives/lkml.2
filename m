Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731Ab0EEKlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:41:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54806 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934715Ab0EEKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:41:25 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 14/20] vc: Locking clean up
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Date: Wed, 05 May 2010 11:02:59 +0100
Message-ID: <20100505100259.3595.90970.stgit@localhost.localdomain>
In-Reply-To: <20100505100144.3595.65633.stgit@localhost.localdomain>
References: <20100505100144.3595.65633.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index bd1d116..c5e30e3 100644
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
 

