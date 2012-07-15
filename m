Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab2GORox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 13:44:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58937 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2GORop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 13:44:45 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wwang <wei_wang@realsil.com.cn>,
        Gustavo Padovan <padovan@profusion.mobi>, Tejun Heo <tj@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] staging/rts_pstor: use kthread_run instead doing kthread_create and wake_up_process
Date: Sun, 15 Jul 2012 23:14:37 +0530
Message-Id: <1342374277-9008-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with kthread_create we need to call wake_up_process to run the thread,
this can be done using the macro kthread_run, which creates and if thread
creation is succeeded starts the thread by calling wake_up_process,

and also there are two more threads in the rts_pstor, which calls
kthread_run instead calling kthread_create and another call to the
wake_up_process, so with this change the creation of rtsx_scan_thread
will be in consistency with the other control and poll threads.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
   Compile tested only,.. didn't done ps ax to check whether this thread runs correctly.
   the thread functions are calling complete_and_exit, and not returning any value as the
   other drivers do.

 drivers/staging/rts_pstor/rtsx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 1dccd93..5fb05a2 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -1021,7 +1021,7 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 	}
 
 	/* Start up the thread for delayed SCSI-device scanning */
-	th = kthread_create(rtsx_scan_thread, dev, "rtsx-scan");
+	th = kthread_run(rtsx_scan_thread, dev, "rtsx-scan");
 	if (IS_ERR(th)) {
 		printk(KERN_ERR "Unable to start the device-scanning thread\n");
 		complete(&dev->scanning_done);
@@ -1030,8 +1030,6 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 		goto errout;
 	}
 
-	wake_up_process(th);
-
 	/* Start up the thread for polling thread */
 	th = kthread_run(rtsx_polling_thread, dev, "rtsx-polling");
 	if (IS_ERR(th)) {
-- 
1.7.0.4

