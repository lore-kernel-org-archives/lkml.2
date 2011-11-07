Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1KGHn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 02:43:27 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60681 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1KGHnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 02:43:25 -0500
X-Nat-Received: from [202.181.97.72]:61849 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1320651567.26266
Message-Id: <201111070739.pA77dQeJ048259@www262.sakura.ne.jp>
Subject: [2.6.27-stable] HID: Mutex/spinlock error.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Nov 2011 16:39:26 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17102011 #5502725, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed below warning when compiling VineLinux 5's 2.6.27 kernel:

  drivers/hid/hidraw.c: In function ‘hidraw_release’:
  drivers/hid/hidraw.c:201: warning: passing argument 1 of ‘mutex_lock’ from incompatible pointer type
  drivers/hid/hidraw.c:220: warning: passing argument 1 of ‘mutex_unlock’ from incompatible pointer type

Looking at the source code, minors_lock in 2.6.27 is defined as

  static DEFINE_SPINLOCK(minors_lock);

whereas it is defined as

  static DEFINE_MUTEX(minors_lock);

since 2.6.28.

This bug was introduced in 2.6.27.58 and exists as of 2.6.27.59.
(I can't find commit id because
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.27.y
has stopped at 2.6.27.57.)

Code from patch-2.6.27.59.bz2 is attached below.

Regards.
----------------------------------------
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index c40f040..b88f6b3 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -113,7 +113,7 @@ static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t
        if (!dev->hid_output_raw_report)
                return -ENODEV;

-       if (count > HID_MIN_BUFFER_SIZE) {
+       if (count > HID_MAX_BUFFER_SIZE) {
                printk(KERN_WARNING "hidraw: pid %d passed too large report\n",
                                task_pid_nr(current));
                return -EINVAL;
@@ -196,11 +196,14 @@ static int hidraw_release(struct inode * inode, struct file * file)
        unsigned int minor = iminor(inode);
        struct hidraw *dev;
        struct hidraw_list *list = file->private_data;
+       int ret;

+       mutex_lock(&minors_lock);
        if (!hidraw_table[minor]) {
                printk(KERN_EMERG "hidraw device with minor %d doesn't exist\n",
                                minor);
-               return -ENODEV;
+               ret = -ENODEV;
+               goto unlock;
        }

        list_del(&list->node);
@@ -211,10 +214,12 @@ static int hidraw_release(struct inode * inode, struct file * file)
                else
                        kfree(list->hidraw);
        }
-
        kfree(list);
+       ret = 0;
+unlock:
+       mutex_unlock(&minors_lock);

-       return 0;
+       return ret;
 }

 static long hidraw_ioctl(struct file *file, unsigned int cmd,
