Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2GZL77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:59:59 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:47085 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab2GZL74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:59:56 -0400
X-Greylist: delayed 1144 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2012 07:59:56 EDT
From: Pavel Andrianov <andrianov@ispras.ru>
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: Pavel Andrianov <andrianov@ispras.ru>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] scsi_megaraid: addition spin_lock in megaraid_abort()
Date: Thu, 26 Jul 2012 15:40:15 +0400
Message-Id: <1343302815-13064-1-git-send-email-andrianov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function megaraid_abort() there are calls to megaraid_abort_and_reset()
and mega_rundoneq() which access shared data (like pending_list) without
synchronization.In function megaraid_reset() the same calls were done with
spin_lock held. So, the patch adds spin_lock_irq and spin_unlock_irq to
megaraid_abort().

Found by Linux Driver Verification project (linuxtesting.org)

Signed-off-by: Pavel Andrianov <andrianov@ispras.ru>
---
 drivers/scsi/megaraid.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4d39a9f..7572d86 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1898,6 +1898,8 @@ megaraid_abort(Scsi_Cmnd *cmd)
 
 	adapter = (adapter_t *)cmd->device->host->hostdata;
 
+	spin_lock_irq(&adapter->lock);
+
 	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_ABORT);
 
 	/*
@@ -1905,6 +1907,7 @@ megaraid_abort(Scsi_Cmnd *cmd)
 	 * to be communicated over to the mid layer.
 	 */
 	mega_rundoneq(adapter);
+	spin_unlock_irq(&adapter->lock);
 
 	return rval;
 }
-- 
1.7.4.1

