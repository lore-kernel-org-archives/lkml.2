Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223Ab2HIN7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:59:16 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52413 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab2HIN7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:59:12 -0400
From: Marina Makienko <makienko@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Marina Makienko <makienko@ispras.ru>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 04/13] ide: Potential null pointer dereference in ide_cdrom_reset()
Date: Thu,  9 Aug 2012 17:55:21 +0400
Message-Id: <1344520529-19164-2-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
References: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
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
 drivers/ide/ide-cd_ioctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 02caa7d..e29588f 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -304,6 +304,10 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	int ret;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+
+	if (!rq)
+		return -EIO;
+
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_flags = REQ_QUIET;
 	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
-- 
1.7.7

