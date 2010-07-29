Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0G2Pqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:46:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390Ab0G2Pqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:46:33 -0400
Date: Thu, 29 Jul 2010 11:35:35 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: sfr@canb.auug.org.au, lirc-list@lists.sourceforge.net,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@redhat.com
Subject: [PATCH] staging/lirc: fix non-CONFIG_MODULES build horkage
Message-ID: <20100729153535.GB7507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728101358.e0dcd54d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix when CONFIG_MODULES is not enabled:

drivers/staging/lirc/lirc_parallel.c:243: error: implicit declaration of function 'module_refcount'
drivers/staging/lirc/lirc_it87.c:150: error: implicit declaration of function 'module_refcount'
drivers/built-in.o: In function `it87_probe':
lirc_it87.c:(.text+0x4079b0): undefined reference to `init_chrdev'
lirc_it87.c:(.text+0x4079cc): undefined reference to `drop_chrdev'
drivers/built-in.o: In function `lirc_it87_exit':
lirc_it87.c:(.exit.text+0x38a5): undefined reference to `drop_chrdev'

Its a quick hack and untested beyond building, since I don't have the
hardware, but it should do the trick.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/lirc/lirc_it87.c     |    9 ++++++---
 drivers/staging/lirc/lirc_parallel.c |    4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lirc/lirc_it87.c b/drivers/staging/lirc/lirc_it87.c
index 781abc3..72f07f1 100644
--- a/drivers/staging/lirc/lirc_it87.c
+++ b/drivers/staging/lirc/lirc_it87.c
@@ -109,6 +109,7 @@ static DECLARE_WAIT_QUEUE_HEAD(lirc_read_queue);
 
 static DEFINE_SPINLOCK(hardware_lock);
 static DEFINE_SPINLOCK(dev_lock);
+static bool device_open;
 
 static int rx_buf[RBUF_LEN];
 unsigned int rx_tail, rx_head;
@@ -147,10 +148,11 @@ static void drop_port(void);
 static int lirc_open(struct inode *inode, struct file *file)
 {
 	spin_lock(&dev_lock);
-	if (module_refcount(THIS_MODULE)) {
+	if (device_open) {
 		spin_unlock(&dev_lock);
 		return -EBUSY;
 	}
+	device_open = true;
 	spin_unlock(&dev_lock);
 	return 0;
 }
@@ -158,6 +160,9 @@ static int lirc_open(struct inode *inode, struct file *file)
 
 static int lirc_close(struct inode *inode, struct file *file)
 {
+	spin_lock(&dev_lock);
+	device_open = false;
+	spin_unlock(&dev_lock);
 	return 0;
 }
 
@@ -363,7 +368,6 @@ static struct lirc_driver driver = {
 };
 
 
-#ifdef MODULE
 static int init_chrdev(void)
 {
 	driver.minor = lirc_register_driver(&driver);
@@ -380,7 +384,6 @@ static void drop_chrdev(void)
 {
 	lirc_unregister_driver(driver.minor);
 }
-#endif
 
 
 /* SECTION: Hardware */
diff --git a/drivers/staging/lirc/lirc_parallel.c b/drivers/staging/lirc/lirc_parallel.c
index df12e7b..04ce97713 100644
--- a/drivers/staging/lirc/lirc_parallel.c
+++ b/drivers/staging/lirc/lirc_parallel.c
@@ -240,7 +240,7 @@ static void irq_handler(void *blah)
 	unsigned int level, newlevel;
 	unsigned int timeout;
 
-	if (!module_refcount(THIS_MODULE))
+	if (!is_open)
 		return;
 
 	if (!is_claimed)
@@ -515,7 +515,7 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 static int lirc_open(struct inode *node, struct file *filep)
 {
-	if (module_refcount(THIS_MODULE) || !lirc_claim())
+	if (is_open || !lirc_claim())
 		return -EBUSY;
 
 	parport_enable_irq(pport);


-- 
Jarod Wilson
jarod@redhat.com

