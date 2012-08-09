Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab2HIN7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:59:37 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52434 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab2HIN7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:59:19 -0400
From: Marina Makienko <makienko@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Marina Makienko <makienko@ispras.ru>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 12/13] ide: Potential null pointer dereference in issue_park_cmd()
Date: Thu,  9 Aug 2012 17:55:29 +0400
Message-Id: <1344520529-19164-10-git-send-email-makienko@ispras.ru>
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
 drivers/ide/ide-park.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 6ab9ab2..4d178bd 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -32,6 +32,8 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	spin_unlock_irq(&hwif->lock);
 
 	rq = blk_get_request(q, READ, __GFP_WAIT);
+	if (!rq)
+		goto out;
 	rq->cmd[0] = REQ_PARK_HEADS;
 	rq->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-- 
1.7.7

