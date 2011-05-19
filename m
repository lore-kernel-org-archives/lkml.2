Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912Ab1ESVlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:41:53 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:52683 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1ESVlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CtCBcPLirr74Ixx2aCfzo9G1IAdZ3ZUaeLe4mZyZb4RfS+xir1k+1QvuOg6bnb9GTk
         aAyC3fice4K/hHyi3+LRpUk9EC76riGd6w3c/yOKn82IQQ2NuHD5VIsn36Ehov46aEJD
         jlfv7/PISCCbsKATgPTixiFXYXwd/mA8FcOOI=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 04/23] use register_chrdev_ids in drivers/tty/
Date: Thu, 19 May 2011 15:33:07 -0600
Message-Id: <1305840792-25877-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: Greg Kroah-Hartman <gregkh@suse.de>

Convert register_chrdev_region(MKDEV(x,y)...) uses.
This patch brought to you by coccinelle-spatch.

Some manual post-work was needed; rules insert multiple dev_t
declarations if 2 different MKDEV()s are found.

@ rcr_md @
identifier f;
expression major, minor;
expression ct, name;
@@

 f(...) {
++	dev_t devt;			// ++ gives multiple inserts
++	devt = MKDEV(major,minor);	// fresh identifier may help

<+...
-	register_chrdev_region
+	register_chrdev_ids
	(
-	MKDEV(major,minor),
+	&devt,
	ct, name)
...+>
 }

@ all_md depends on rcr_md @	// where above changes made, also do
identifier f;
expression major, minor;
@@

	f(...) {
	dev_t devt;
	devt = MKDEV(major,minor);

<+...
-	MKDEV(major,minor)
+	devt
...+>
	}

 # Please enter the commit message for your
changes. Lines starting # with '#' will be ignored, and an empty
message aborts the commit.  # Not currently on any branch.  # Changes
to be committed: # (use "git reset HEAD^1 <file>..." to unstage) # #
modified: drivers/tty/pty.c # modified: drivers/tty/tty_io.c #
modified: drivers/tty/vt/vt.c # # Untracked files: # (use "git add
<file>..." to include in what will be committed) # # bar # boo # buc #
bum # buz # chrdev-inline.cocci # chrdev.cocci-expr #
chrdev.cocci-inline # foo # joe # joebob # junk # list # mkdev.cocci #
newconf # newconfig # spam.cocci

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/tty/pty.c    |    8 +++++---
 drivers/tty/tty_io.c |   23 +++++++++++++----------
 drivers/tty/vt/vt.c  |    8 +++++---
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 2107747..07034f2 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -703,6 +703,8 @@ static struct file_operations ptmx_fops;
 
 static void __init unix98_pty_init(void)
 {
+	dev_t devt = MKDEV(TTYAUX_MAJOR, 2);
+
 	ptm_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
 	if (!ptm_driver)
 		panic("Couldn't allocate Unix98 ptm driver");
@@ -757,10 +759,10 @@ static void __init unix98_pty_init(void)
 	ptmx_fops.open = ptmx_open;
 
 	cdev_init(&ptmx_cdev, &ptmx_fops);
-	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
-	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
+	if (cdev_add(&ptmx_cdev, devt, 1) ||
+	    register_chrdev_ids(&devt, 1, "/dev/ptmx") < 0)
 		panic("Couldn't register /dev/ptmx driver\n");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
+	device_create(tty_class, NULL, devt, NULL, "ptmx");
 }
 
 #else
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index d7d50b4..efbb5e0 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3051,15 +3051,14 @@ int tty_register_driver(struct tty_driver *driver)
 	}
 
 	if (!driver->major) {
-		error = alloc_chrdev_region(&dev, driver->minor_start,
-						driver->num, driver->name);
+		error = register_chrdev_ids(&dev, driver->num, driver->name);
 		if (!error) {
 			driver->major = MAJOR(dev);
 			driver->minor_start = MINOR(dev);
 		}
 	} else {
 		dev = MKDEV(driver->major, driver->minor_start);
-		error = register_chrdev_region(dev, driver->num, driver->name);
+		error = register_chrdev_ids(&dev, driver->num, driver->name);
 	}
 	if (error < 0) {
 		kfree(p);
@@ -3294,18 +3293,22 @@ void console_sysfs_notify(void)
  */
 int __init tty_init(void)
 {
+	dev_t devt;
+
+	devt = MKDEV(TTYAUX_MAJOR, 0);
 	cdev_init(&tty_cdev, &tty_fops);
-	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
-	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
+	if (cdev_add(&tty_cdev, devt, 1) ||
+	    register_chrdev_ids(&devt, 1, "/dev/tty") < 0)
 		panic("Couldn't register /dev/tty driver\n");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL, "tty");
+	device_create(tty_class, NULL, devt, NULL, "tty");
 
+	devt = MKDEV(TTYAUX_MAJOR, 1);
 	cdev_init(&console_cdev, &console_fops);
-	if (cdev_add(&console_cdev, MKDEV(TTYAUX_MAJOR, 1), 1) ||
-	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 1), 1, "/dev/console") < 0)
+	if (cdev_add(&console_cdev, devt, 1) ||
+	    register_chrdev_ids(&devt, 1, "/dev/console") < 0)
 		panic("Couldn't register /dev/console driver\n");
-	consdev = device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 1), NULL,
-			      "console");
+	consdev = device_create(tty_class, NULL, devt, NULL, "console");
+
 	if (IS_ERR(consdev))
 		consdev = NULL;
 	else
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 4bea1ef..819b31c 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2973,11 +2973,13 @@ static DEVICE_ATTR(active, S_IRUGO, show_tty_active, NULL);
 
 int __init vty_init(const struct file_operations *console_fops)
 {
+	dev_t devt = MKDEV(TTY_MAJOR, 0);
+
 	cdev_init(&vc0_cdev, console_fops);
-	if (cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1) ||
-	    register_chrdev_region(MKDEV(TTY_MAJOR, 0), 1, "/dev/vc/0") < 0)
+	if (cdev_add(&vc0_cdev, devt, 1) ||
+	    register_chrdev_ids(&devt, 1, "/dev/vc/0") < 0)
 		panic("Couldn't register /dev/tty0 driver\n");
-	tty0dev = device_create(tty_class, NULL, MKDEV(TTY_MAJOR, 0), NULL, "tty0");
+	tty0dev = device_create(tty_class, NULL, devt, NULL, "tty0");
 	if (IS_ERR(tty0dev))
 		tty0dev = NULL;
 	else
-- 
1.7.4.4

