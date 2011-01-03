Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1ACNuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:50:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1ACNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Ho/A0Y3Jo8kFGrt3VblAiZRqDmOauZCBJelCmNnMy8H0QrpxBj2muL2bsSrp5qV6DL
         7+j5UuxA+Me/ZEEMqj7Q7FiYroGbS6L9j/3AV/UtmOE93SCadvS2fzH8ngY6qQxFZiXS
         9aXYNilpLALCB0IH5xcIUGE6dLF4AOUZZMPDs=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 01/32] arm/omap: use system_wq in mailbox
Date: Mon,  3 Jan 2011 14:49:24 +0100
Message-Id: <1294062595-30097-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use a separate workqueue for mailbox.
Use the system_wq instead.  mbox->rxq->work is sync flushed in
omap_mbox_fini() to make sure it's not running on any cpu, which makes
sure that no mbox work is running when omap_mbox_exit() is entered.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 arch/arm/plat-omap/mailbox.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index d2fafb8..5bc4d7b 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -31,7 +31,6 @@
 
 #include <plat/mailbox.h>
 
-static struct workqueue_struct *mboxd;
 static struct omap_mbox **mboxes;
 static bool rq_full;
 
@@ -186,7 +185,7 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
 	/* no more messages in the fifo. clear IRQ source. */
 	ack_mbox_irq(mbox, IRQ_RX);
 nomem:
-	queue_work(mboxd, &mbox->rxq->work);
+	schedule_work(&mbox->rxq->work);
 }
 
 static irqreturn_t mbox_interrupt(int irq, void *p)
@@ -291,7 +290,7 @@ static void omap_mbox_fini(struct omap_mbox *mbox)
 {
 	free_irq(mbox->irq, mbox);
 	tasklet_kill(&mbox->txq->tasklet);
-	flush_work(&mbox->rxq->work);
+	flush_work_sync(&mbox->rxq->work);
 	mbox_queue_free(mbox->txq);
 	mbox_queue_free(mbox->rxq);
 
@@ -385,10 +384,6 @@ static int __init omap_mbox_init(void)
 	if (err)
 		return err;
 
-	mboxd = create_workqueue("mboxd");
-	if (!mboxd)
-		return -ENOMEM;
-
 	/* kfifo size sanity check: alignment and minimal size */
 	mbox_kfifo_size = ALIGN(mbox_kfifo_size, sizeof(mbox_msg_t));
 	mbox_kfifo_size = max_t(unsigned int, mbox_kfifo_size, sizeof(mbox_msg_t));
@@ -399,7 +394,6 @@ subsys_initcall(omap_mbox_init);
 
 static void __exit omap_mbox_exit(void)
 {
-	destroy_workqueue(mboxd);
 	class_unregister(&omap_mbox_class);
 }
 module_exit(omap_mbox_exit);
-- 
1.7.1

