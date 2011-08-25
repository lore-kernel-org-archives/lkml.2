Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1HYUgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:36:33 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:51239 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab1HYUgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:36:32 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, DL-MPTFusionLinux@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] [SCSI] mpt2sas: Fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock
Date: Fri, 26 Aug 2011 00:36:23 +0400
Message-Id: <1314304583-19856-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ioc->pci_error_recovery is set, goto out in mpt2sas_base_hard_reset_handler()
leads to unlock unheld ioc->reset_in_progress_mutex.

The patch fixes the issue by jumping afer mutex_unlock() call.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 83035bd..906c63a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4130,7 +4130,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 		printk(MPT2SAS_ERR_FMT "%s: pci error recovery reset\n",
 		    ioc->name, __func__);
 		r = 0;
-		goto out;
+		goto out_unlocked;
 	}
 
 	if (mpt2sas_fwfault_debug)
@@ -4186,6 +4186,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	mutex_unlock(&ioc->reset_in_progress_mutex);
 
+ out_unlocked:
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 	    __func__));
 	return r;
-- 
1.7.4.1

