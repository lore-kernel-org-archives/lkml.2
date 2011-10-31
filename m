Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497Ab1JaTJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:09:41 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44909 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742Ab1JaTFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:05:40 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: arnd@arndb.de, oleg@redhat.com, matthltc@us.ibm.com,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        wwang <wei_wang@realsil.com.cn>
Subject: [PATCH 02/17] freezer: don't unnecessarily set PF_NOFREEZE explicitly
Date: Mon, 31 Oct 2011 12:05:13 -0700
Message-Id: <1320087928-32307-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1320087928-32307-1-git-send-email-tj@kernel.org>
References: <1320087928-32307-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers set PF_NOFREEZE in their kthread functions which is
completely unnecessary and racy - some part of freezer code doesn't
consider cases where PF_NOFREEZE is set asynchronous to freezer
operations.

In general, there's no reason to allow setting PF_NOFREEZE explicitly.
Remove them and change the documentation to note that setting
PF_NOFREEZE directly isn't allowed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: "Gustavo F. Padovan" <padovan@profusion.mobi>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: wwang <wei_wang@realsil.com.cn>
---
 Documentation/power/freezing-of-tasks.txt |    2 +-
 drivers/bluetooth/btmrvl_main.c           |    2 --
 drivers/mfd/twl4030-irq.c                 |    3 ---
 drivers/mfd/twl6030-irq.c                 |    2 --
 drivers/staging/rts_pstor/rtsx.c          |    2 --
 5 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index 38b5724..710c965 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -67,7 +67,7 @@ III. Which kernel threads are freezable?
 
 Kernel threads are not freezable by default.  However, a kernel thread may clear
 PF_NOFREEZE for itself by calling set_freezable() (the resetting of PF_NOFREEZE
-directly is strongly discouraged).  From this point it is regarded as freezable
+directly is not allowed).  From this point it is regarded as freezable
 and must call try_to_freeze() in a suitable place.
 
 IV. Why do we do that?
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index 548d1d9..57312d4 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -473,8 +473,6 @@ static int btmrvl_service_main_thread(void *data)
 
 	init_waitqueue_entry(&wait, current);
 
-	current->flags |= PF_NOFREEZE;
-
 	for (;;) {
 		add_wait_queue(&thread->wait_q, &wait);
 
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 8a7ee31..6aae831 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -289,9 +289,6 @@ static int twl4030_irq_thread(void *data)
 	static unsigned i2c_errors;
 	static const unsigned max_i2c_errors = 100;
 
-
-	current->flags |= PF_NOFREEZE;
-
 	while (!kthread_should_stop()) {
 		int ret;
 		int module_irq;
diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index eb3b5f8..6fd7795 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -96,8 +96,6 @@ static int twl6030_irq_thread(void *data)
 	static const unsigned max_i2c_errors = 100;
 	int ret;
 
-	current->flags |= PF_NOFREEZE;
-
 	while (!kthread_should_stop()) {
 		int i;
 		union {
diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 480b0ed..8a7803c 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -466,8 +466,6 @@ static int rtsx_control_thread(void *__dev)
 	struct rtsx_chip *chip = dev->chip;
 	struct Scsi_Host *host = rtsx_to_host(dev);
 
-	current->flags |= PF_NOFREEZE;
-
 	for (;;) {
 		if (wait_for_completion_interruptible(&dev->cmnd_ready))
 			break;
-- 
1.7.3.1

