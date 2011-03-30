Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1C3NYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:24:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49491 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1C3NYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UspiNOE83rBHs4M5s/PwPCJtEa795Q9zBai27HwHwo3Q12My2Q0FNxhHVx8K4PCWnz
         sYECpko3dncUU0+3Ya961QtAkpcrTUHv0jTuUU72lfJckLiy2y98YbZ7tAORJdRbKXbC
         c3UYVtdWMBNjQFAbtnG0SMAL+o99nw4CvYNrk=
Date: Wed, 30 Mar 2011 15:24:21 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] posix clocks: replace mutex with reader/writer semaphore
Message-ID: <20110330132421.GA31771@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A dynamic posix clock is protected from asynchronous removal by a mutex.
However, using a mutex has the unwanted effect that a long running clock
operation in one process will unnecessarily block other processes.

For example, one process might call read() to get an external time stamp
coming in at one pulse per second. A second process calling clock_gettime
would have to wait for almost a whole second.

This patch fixes the issue by using a reader/writer semaphore instead of
a mutex.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/posix-clock.h |    5 +++--
 kernel/time/posix-clock.c   |   24 +++++++++---------------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index 369e19d..7f1183d 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -24,6 +24,7 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/posix-timers.h>
+#include <linux/rwsem.h>
 
 struct posix_clock;
 
@@ -104,7 +105,7 @@ struct posix_clock_operations {
  * @ops:     Functional interface to the clock
  * @cdev:    Character device instance for this clock
  * @kref:    Reference count.
- * @mutex:   Protects the 'zombie' field from concurrent access.
+ * @rwsem:   Protects the 'zombie' field from concurrent access.
  * @zombie:  If 'zombie' is true, then the hardware has disappeared.
  * @release: A function to free the structure when the reference count reaches
  *           zero. May be NULL if structure is statically allocated.
@@ -117,7 +118,7 @@ struct posix_clock {
 	struct posix_clock_operations ops;
 	struct cdev cdev;
 	struct kref kref;
-	struct mutex mutex;
+	struct rw_semaphore rwsem;
 	bool zombie;
 	void (*release)(struct posix_clock *clk);
 };
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 25028dd..c340ca6 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -19,7 +19,6 @@
  */
 #include <linux/device.h>
 #include <linux/file.h>
-#include <linux/mutex.h>
 #include <linux/posix-clock.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
@@ -34,19 +33,19 @@ static struct posix_clock *get_posix_clock(struct file *fp)
 {
 	struct posix_clock *clk = fp->private_data;
 
-	mutex_lock(&clk->mutex);
+	down_read(&clk->rwsem);
 
 	if (!clk->zombie)
 		return clk;
 
-	mutex_unlock(&clk->mutex);
+	up_read(&clk->rwsem);
 
 	return NULL;
 }
 
 static void put_posix_clock(struct posix_clock *clk)
 {
-	mutex_unlock(&clk->mutex);
+	up_read(&clk->rwsem);
 }
 
 static ssize_t posix_clock_read(struct file *fp, char __user *buf,
@@ -156,7 +155,7 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 	struct posix_clock *clk =
 		container_of(inode->i_cdev, struct posix_clock, cdev);
 
-	mutex_lock(&clk->mutex);
+	down_read(&clk->rwsem);
 
 	if (clk->zombie) {
 		err = -ENODEV;
@@ -172,7 +171,7 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 		fp->private_data = clk;
 	}
 out:
-	mutex_unlock(&clk->mutex);
+	up_read(&clk->rwsem);
 	return err;
 }
 
@@ -211,25 +210,20 @@ int posix_clock_register(struct posix_clock *clk, dev_t devid)
 	int err;
 
 	kref_init(&clk->kref);
-	mutex_init(&clk->mutex);
+	init_rwsem(&clk->rwsem);
 
 	cdev_init(&clk->cdev, &posix_clock_file_operations);
 	clk->cdev.owner = clk->ops.owner;
 	err = cdev_add(&clk->cdev, devid, 1);
-	if (err)
-		goto no_cdev;
 
 	return err;
-no_cdev:
-	mutex_destroy(&clk->mutex);
-	return err;
 }
 EXPORT_SYMBOL_GPL(posix_clock_register);
 
 static void delete_clock(struct kref *kref)
 {
 	struct posix_clock *clk = container_of(kref, struct posix_clock, kref);
-	mutex_destroy(&clk->mutex);
+
 	if (clk->release)
 		clk->release(clk);
 }
@@ -238,9 +232,9 @@ void posix_clock_unregister(struct posix_clock *clk)
 {
 	cdev_del(&clk->cdev);
 
-	mutex_lock(&clk->mutex);
+	down_write(&clk->rwsem);
 	clk->zombie = true;
-	mutex_unlock(&clk->mutex);
+	up_write(&clk->rwsem);
 
 	kref_put(&clk->kref, delete_clock);
 }
-- 
1.7.0.4

