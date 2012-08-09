Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab2HIN7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:59:14 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52411 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2HIN7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:59:12 -0400
From: Marina Makienko <makienko@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Marina Makienko <makienko@ispras.ru>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 03/13] ide: Potential null pointer dereference in ide_queue_pc_tail()
Date: Thu,  9 Aug 2012 17:55:20 +0400
Message-Id: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function blk_get_request() can return NULL in some cases. There are
checks on it if function is called with argumetns one of which is
GFP_ATOMIC/GFP_NOIO/etc. If system couldn't find request
blk_get_request() return NULL.

But if there is function call with argument __GFP_WAIT
the system will wait until get request or the queue becomes
dead. If something kills the queue, blk_get_request()
return NULL and next operations will lead to errors.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
 drivers/ide/ide-atapi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index fac3d9d..8bf4109 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -93,6 +93,12 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	int error;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+
+	if (!rq) {
+		printk(KERN_ERR PFX"ide_queue_pc_tail: blk_get_request() failed. \n");
+		return 1;
+	}
+
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = (char *)pc;
 
-- 
1.7.7

