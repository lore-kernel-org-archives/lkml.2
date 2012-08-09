Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299Ab2HIN7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:59:36 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52436 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030259Ab2HIN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:59:33 -0400
From: Marina Makienko <makienko@ispras.ru>
To: Mike Anderson <andmike@us.ibm.com>
Cc: Marina Makienko <makienko@ispras.ru>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH 13/13] scsi: Potential null pointer dereference in scsi_eh_lock_door()
Date: Thu,  9 Aug 2012 17:55:50 +0400
Message-Id: <1344520550-21134-1-git-send-email-makienko@ispras.ru>
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
 drivers/scsi/scsi_error.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4a6381c..7dd67d4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1624,6 +1624,9 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
 
+	if (!req)
+		return;
+
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
 	req->cmd[1] = 0;
 	req->cmd[2] = 0;
-- 
1.7.7

