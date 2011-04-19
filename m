Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1DSQD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:03:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55860 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1DSQD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:03:26 -0400
Date: Tue, 19 Apr 2011 18:03:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20110419160316.GA3377@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timer-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timer-fixes-for-linus

The posix clocks change fixes a pretty bad latency regression introduced in 
this cycle. (In hindsight this information should have been in the changelog)

 Thanks,

	Ingo

------------------>
Axel Lin (1):
      RTC: rtc-omap: Fix a leak of the IRQ during init failure

Richard Cochran (1):
      posix clocks: Replace mutex with reader/writer semaphore


 drivers/rtc/rtc-omap.c      |    2 +-
 include/linux/posix-clock.h |    5 +++--
 kernel/time/posix-clock.c   |   24 +++++++++---------------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index de0dd7b..bcae8dd 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -394,7 +394,7 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail2:
-	free_irq(omap_rtc_timer, NULL);
+	free_irq(omap_rtc_timer, rtc);
 fail1:
 	rtc_device_unregister(rtc);
 fail0:
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
