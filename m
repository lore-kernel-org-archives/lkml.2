Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab0FDRql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:46:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46509 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0FDRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 13:46:40 -0400
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: greg@kroah.com
Cc: usbip-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: usbip_common: kill rx thread on tx thread creation error.
Date: Fri,  4 Jun 2010 23:16:27 +0530
Message-Id: <1275673587-1660-1-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is an updated patch after rebasing my branch to recently updated master.

Himanshu

Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>

---
 drivers/staging/usbip/usbip_common.c |   46 ++++++++++++++++++++++++---------
 1 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 5240816..cd20d2b 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -378,47 +378,67 @@ int usbip_thread(void *param)
 	complete_and_exit(&ut->thread_done, 0);
 }
 
+static void stop_rx_thread(struct usbip_device *ud)
+{
+	if (ud->tcp_rx.thread != NULL) {
+		send_sig(SIGKILL, ud->tcp_rx.thread, 1);
+		wait_for_completion(&ud->tcp_rx.thread_done);
+		usbip_udbg("rx_thread for ud %p has finished\n", ud);
+	}
+}
+
+static void stop_tx_thread(struct usbip_device *ud)
+{
+	if (ud->tcp_tx.thread != NULL) {
+		send_sig(SIGKILL, ud->tcp_tx.thread, 1);
+		wait_for_completion(&ud->tcp_tx.thread_done);
+		usbip_udbg("tx_thread for ud %p has finished\n", ud);
+	}
+}
+
 int usbip_start_threads(struct usbip_device *ud)
 {
 	/*
 	 * threads are invoked per one device (per one connection).
 	 */
 	struct task_struct *th;
+	int err = 0;
 
 	th = kthread_run(usbip_thread, (void *)&ud->tcp_rx, "usbip");
 	if (IS_ERR(th)) {
 		printk(KERN_WARNING
 			"Unable to start control thread\n");
-		return PTR_ERR(th);
+		err = PTR_ERR(th);
+		goto ust_exit;
 	}
+
 	th = kthread_run(usbip_thread, (void *)&ud->tcp_tx, "usbip");
 	if (IS_ERR(th)) {
 		printk(KERN_WARNING
 			"Unable to start control thread\n");
-		return PTR_ERR(th);
+		err = PTR_ERR(th);
+		goto tx_thread_err;
 	}
 
 	/* confirm threads are starting */
 	wait_for_completion(&ud->tcp_rx.thread_done);
 	wait_for_completion(&ud->tcp_tx.thread_done);
+	
 	return 0;
+
+tx_thread_err:
+	stop_rx_thread(ud);
+
+ust_exit:
+	return err;
 }
 EXPORT_SYMBOL_GPL(usbip_start_threads);
 
 void usbip_stop_threads(struct usbip_device *ud)
 {
 	/* kill threads related to this sdev, if v.c. exists */
-	if (ud->tcp_rx.thread != NULL) {
-		send_sig(SIGKILL, ud->tcp_rx.thread, 1);
-		wait_for_completion(&ud->tcp_rx.thread_done);
-		usbip_udbg("rx_thread for ud %p has finished\n", ud);
-	}
-
-	if (ud->tcp_tx.thread != NULL) {
-		send_sig(SIGKILL, ud->tcp_tx.thread, 1);
-		wait_for_completion(&ud->tcp_tx.thread_done);
-		usbip_udbg("tx_thread for ud %p has finished\n", ud);
-	}
+	stop_rx_thread(ud);
+	stop_tx_thread(ud);
 }
 EXPORT_SYMBOL_GPL(usbip_stop_threads);
 
-- 
1.7.0.4

