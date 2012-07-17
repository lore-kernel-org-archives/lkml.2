Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2GQFbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:31:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37894 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2GQFbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:31:48 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Chan <benchan@chromium.org>,
        Devendra Naga <devendra.aaru@gmail.com>, Sage Ahn <syahn@gctsemi.com>,
        Paul Stewart <pstew@chromium.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH V2] staging/gdm72xx: use kthread APIs
Date: Tue, 17 Jul 2012 11:01:26 +0530
Message-Id: <1342503086-8271-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Devendra Naga <devendra.aaru@gmail.com>

This patch modifies the kthread usage in the gdm_usb code, and tries to
use the kthread APIs better.

Actually the task_struct is taken as global as the limitation of priv.
we run the kthread before we allocate the priv.

did only compilation test, but not the insmod, check ps ax for kthread and
rmmod and see the thread is killed kind of tests.

There were no checks while kthread_run may fail, returing some error which can be seen by using PTR_ERR.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---

Sorry Greg sir, i didn't actually used the checkpatch tool, mea maxima clupa :(.

  changes since V2:
		removed the following checkpatch error

        ./scripts/checkpatch.pl 0001-staging-gdm72xx-use-kthread-APIs.patch 
         ERROR: trailing whitespace
        #38: FILE: drivers/staging/gdm72xx/gdm_usb.c:57:
        +static struct task_struct *kthread; $

        NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
        scripts/cleanfile

		but didn't solved the below warning, as it needed a new patch to remove all
		printk's and convert them to pr_err, and this patch intended to do only one
		specific change.

		WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
        #58: FILE: drivers/staging/gdm72xx/gdm_usb.c:786:
        +		printk(KERN_ERR "%s: can't create kernel thread\n", __func__);


 drivers/staging/gdm72xx/gdm_usb.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index d48d49c..5aab7eb 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -46,7 +46,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 static DECLARE_WAIT_QUEUE_HEAD(k_wait);
 static LIST_HEAD(k_list);
 static DEFINE_SPINLOCK(k_lock);
-static int k_mode_stop;
 
 #define K_WAIT_TIME	(2 * HZ / 100)
 
@@ -55,6 +54,7 @@ static int k_mode_stop;
 static int init_usb(struct usbwm_dev *udev);
 static void release_usb(struct usbwm_dev *udev);
 
+static struct task_struct *kthread;
 /*#define DEBUG */
 #ifdef DEBUG
 static void hexdump(char *title, u8 *data, int len)
@@ -717,7 +717,7 @@ static int k_mode_thread(void *arg)
 
 	daemonize("k_mode_wimax");
 
-	while (!k_mode_stop) {
+	while (!kthread_should_stop()) {
 
 		spin_lock_irqsave(&k_lock, flags2);
 		while (!list_empty(&k_list)) {
@@ -778,7 +778,11 @@ static struct usb_driver gdm_usb_driver = {
 static int __init usb_gdm_wimax_init(void)
 {
 #ifdef CONFIG_WIMAX_GDM72XX_K_MODE
-	kthread_run(k_mode_thread, NULL, "WiMax_thread");
+	kthread = kthread_run(k_mode_thread, NULL, "WiMax_thread");
+	if (IS_ERR(kthread)) {
+		printk(KERN_ERR "%s: can't create kernel thread\n", __func__);
+		return PTR_ERR(kthread);
+	}
 #endif /* CONFIG_WIMAX_GDM72XX_K_MODE */
 	return usb_register(&gdm_usb_driver);
 }
@@ -786,7 +790,8 @@ static int __init usb_gdm_wimax_init(void)
 static void __exit usb_gdm_wimax_exit(void)
 {
 #ifdef CONFIG_WIMAX_GDM72XX_K_MODE
-	k_mode_stop = 1;
+	if (kthread)
+		kthread_stop(kthread);
 	wake_up(&k_wait);
 #endif
 	usb_deregister(&gdm_usb_driver);
-- 
1.7.0.4

