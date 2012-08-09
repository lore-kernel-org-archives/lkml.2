Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab2HIN7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:59:17 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52415 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab2HIN7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:59:13 -0400
From: Marina Makienko <makienko@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Marina Makienko <makienko@ispras.ru>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 05/13] ide: Potential null pointer dereference in ide_raw_taskfile()
Date: Thu,  9 Aug 2012 17:55:22 +0400
Message-Id: <1344520529-19164-3-git-send-email-makienko@ispras.ru>
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
 drivers/ide/ide-taskfile.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 729428e..655d894 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -432,6 +432,10 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	int rw = !(cmd->tf_flags & IDE_TFLAG_WRITE) ? READ : WRITE;
 
 	rq = blk_get_request(drive->queue, rw, __GFP_WAIT);
+
+	if (!rq)
+		return -EIO;
+
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	/*
-- 
1.7.7

