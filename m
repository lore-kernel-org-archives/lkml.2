Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab0HXXDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:04 -0400
Received: from kroah.org ([198.145.64.141]:41241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549Ab0HXXDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:00 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:07 2010
Message-Id: <20100824224507.586522980@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>
Subject: [073/114] Fix init ordering of /dev/console vs callers of modprobe
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 31d1d48e199e99077fb30f6fb9a793be7bec756f upstream.

Make /dev/console get initialised before any initialisation routine that
invokes modprobe because if modprobe fails, it's going to want to open
/dev/console, presumably to write an error message to.

The problem with that is that if the /dev/console driver is not yet
initialised, the chardev handler will call request_module() to invoke
modprobe, which will fail, because we never compile /dev/console as a
module.

This will lead to a modprobe loop, showing the following in the kernel
log:

	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1
	request_module: runaway loop modprobe char-major-5-1

This can happen, for example, when the built in md5 module can't find
the built in cryptomgr module (because the latter fails to initialise).
The md5 module comes before the call to tty_init(), presumably because
'crypto' comes before 'drivers' alphabetically.

Fix this by calling tty_init() from chrdev_init().

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/mem.c    |    2 +-
 drivers/char/tty_io.c |    4 ++--
 fs/char_dev.c         |    1 +
 include/linux/tty.h   |    3 +++
 4 files changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -916,7 +916,7 @@ static int __init chr_dev_init(void)
 			      NULL, devlist[minor].name);
 	}
 
-	return 0;
+	return tty_init();
 }
 
 fs_initcall(chr_dev_init);
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3128,7 +3128,7 @@ static struct cdev tty_cdev, console_cde
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
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -20,6 +20,7 @@
 #include <linux/cdev.h>
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
+#include <linux/tty.h>
 
 #include "internal.h"
 
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -552,6 +552,9 @@ static inline void tty_audit_push_task(s
 }
 #endif
 
+/* tty_io.c */
+extern int __init tty_init(void);
+
 /* tty_ioctl.c */
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);


