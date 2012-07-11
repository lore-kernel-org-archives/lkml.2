Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2GKGfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:35:06 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56953 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2GKGfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:35:05 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Chan <benchan@chromium.org>, Sage Ahn <syahn@gctsemi.com>,
        Paul Stewart <pstew@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] staging/gdm72xx: use kthread APIs
Date: Wed, 11 Jul 2012 12:19:44 +0545
Message-Id: <1341988484-23369-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the kthread usage in the gdm_usb code, and tries to
use the kthread APIs better.

Actually the task_struct is taken as global as the limitation of priv.
we run the kthread before we allocate the priv.

did only compilation test, but not the insmod, check ps ax for kthread and
rmmod and see the thread is killed kind of tests.

There were no checks while kthread_run may fail, returing some error which can be seen by using PTR_ERR.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/gdm72xx/gdm_usb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 89268c7..126150d 100644
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
@@ -720,7 +720,7 @@ static int k_mode_thread(void *arg)
 
 	daemonize("k_mode_wimax");
 
-	while (!k_mode_stop) {
+	while (!kthread_should_stop()) {
 
 		spin_lock_irqsave(&k_lock, flags2);
 		while (!list_empty(&k_list)) {
@@ -781,7 +781,11 @@ static struct usb_driver gdm_usb_driver = {
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
@@ -789,7 +793,8 @@ static int __init usb_gdm_wimax_init(void)
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
1.7.9.5

