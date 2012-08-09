Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab2HIN5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:57:53 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52403 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2HIN5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:57:52 -0400
From: Marina Makienko <makienko@ispras.ru>
To: Tim Waugh <tim@cyberelk.net>
Cc: Marina Makienko <makienko@ispras.ru>,
        "Grant R. Guenther" <grant@torque.net>, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH 01/13] block/paride: Potential null pointer dereference in pd_special_command()
Date: Thu,  9 Aug 2012 17:54:05 +0400
Message-Id: <1344520446-13824-1-git-send-email-makienko@ispras.ru>
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
 drivers/block/paride/pd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 831e3ac..6e28910 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -723,6 +723,9 @@ static int pd_special_command(struct pd_unit *disk,
 
 	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
 
+	if (!rq)
+		return Fail;
+
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = func;
 
-- 
1.7.7

