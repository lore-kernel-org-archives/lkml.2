Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0GYIb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:31:56 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36047 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0GYI3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:29:55 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 15/15] writeback: cleanup bdi_register
Date: Sun, 25 Jul 2010 11:29:41 +0300
Message-Id: <1280046581-23623-16-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 08:29:48.0413 (UTC) FILETIME=[8B3A2AD0:01CB2BD3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch makes sure we first initialize everything and set the BDI_registered
flag, and only after this we add the bdi to 'bdi_list'. Current code adds the
bdi to the list too early, and as a result I the

WARN(!test_bit(BDI_registered, &bdi->state)

in bdi forker is triggered. Also, it is in general good practice to make things
visible only when they are fully initialized.

Also, this patch does few micro clean-ups:
1. Removes the 'exit' label which does not do anything, just returns. This
   allows to get rid of few braces and 'ret' variable and make the code smaller.
2. If 'kthread_run()' fails, remove the error code it returns, not hard-coded
   '-ENOMEM'. Theoretically, some day 'kthread_run()' can return something
   else. Also, in case of failure it is not necessary to set 'bdi->wb.task' to
   NULL.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b4d72d4..73d854b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -511,23 +511,16 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
 	va_list args;
-	int ret = 0;
 	struct device *dev;
 
 	if (bdi->dev)	/* The driver needs to use separate queues per device */
-		goto exit;
+		return 0;
 
 	va_start(args, fmt);
 	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);
-	if (IS_ERR(dev)) {
-		ret = PTR_ERR(dev);
-		goto exit;
-	}
-
-	spin_lock_bh(&bdi_lock);
-	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
 
 	bdi->dev = dev;
 
@@ -541,20 +534,19 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 		wb->task = kthread_run(bdi_forker_thread, wb, "bdi-%s",
 						dev_name(dev));
-		if (IS_ERR(wb->task)) {
-			wb->task = NULL;
-			ret = -ENOMEM;
-
-			bdi_remove_from_list(bdi);
-			goto exit;
-		}
+		if (IS_ERR(wb->task))
+			return PTR_ERR(wb->task);
 	}
 
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(BDI_registered, &bdi->state);
+
+	spin_lock_bh(&bdi_lock);
+	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
 	trace_writeback_bdi_register(bdi);
-exit:
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(bdi_register);
 
-- 
1.7.1.1

