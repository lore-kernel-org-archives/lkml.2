Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512Ab0HFPfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:35:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761450Ab0HFPf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:35:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix init ordering of /dev/console vs callers of modprobe
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 06 Aug 2010 16:34:43 +0100
Message-ID: <20100806153443.26610.87253.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make /dev/console get initialised before any initialisation routine that
invokes modprobe because if modprobe fails, it's going to want to open
/dev/console, presumably to write an error message to.

The problem with that is that if the /dev/console driver is not yet
initialised, the chardev handler will call request_module() to invoke modprobe,
which will fail, because we never compile /dev/console as a module.

This will lead to a modprobe loop, showing the following in the kernel log:

	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1

This can happen, for example, when the built in md5 module can't find the built
in cryptomgr module (because the latter fails to initialise).  The md5 module
comes before the call to tty_init(), presumably because 'crypto' comes before
'drivers' alphabetically.

Fix this by calling tty_init() from chrdev_init().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/mem.c    |    2 +-
 drivers/char/tty_io.c |    4 ++--
 fs/char_dev.c         |    1 +
 include/linux/tty.h   |    3 +++
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f54dab8..a398ecd 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -916,7 +916,7 @@ static int __init chr_dev_init(void)
 			      NULL, devlist[minor].name);
 	}
 
-	return 0;
+	return tty_init();
 }
 
 fs_initcall(chr_dev_init);
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d71f0fc..507441a 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3128,7 +3128,7 @@ static struct cdev tty_cdev, console_cdev;
  * Ok, now we can initialize the rest of the tty devices and can count
  * on memory allocations, interrupts etc..
  */
-static int __init tty_init(void)
+int __init tty_init(void)
 {
 	cdev_init(&tty_cdev, &tty_fops);
 	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
@@ -3149,4 +3149,4 @@ static int __init tty_init(void)
 #endif
 	return 0;
 }
-module_init(tty_init);
+
diff --git a/fs/char_dev.c b/fs/char_dev.c
index d6db933..f80a4f2 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -20,6 +20,7 @@
 #include <linux/cdev.h>
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
+#include <linux/tty.h>
 
 #include "internal.h"
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 931078b..7802a24 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -552,6 +552,9 @@ static inline void tty_audit_push_task(struct task_struct *tsk,
 }
 #endif
 
+/* tty_io.c */
+extern int __init tty_init(void);
+
 /* tty_ioctl.c */
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);

