Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030350Ab2HIOBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:01:47 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52417 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964873Ab2HIN7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:59:14 -0400
From: Marina Makienko <makienko@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Marina Makienko <makienko@ispras.ru>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 06/13] ide: Potential null pointer dereference in generic_ide_resume()
Date: Thu,  9 Aug 2012 17:55:23 +0400
Message-Id: <1344520529-19164-4-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
References: <1344520529-19164-1-git-send-email-makienko@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

he function blk_get_request() can return NULL in some cases. There are
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
 drivers/ide/ide-pm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 9240609..4412f24 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -19,6 +19,10 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+
+	if (!rq)
+		return -EIO;
+
 	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
@@ -59,6 +63,8 @@ int generic_ide_resume(struct device *dev)
 
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	if (!rq)
+		return -EIO;
 	rq->cmd_type = REQ_TYPE_PM_RESUME;
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->special = &rqpm;
-- 
1.7.7

