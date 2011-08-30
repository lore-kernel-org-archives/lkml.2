Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab1H3V5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:57:18 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:54842 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1H3V5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:57:17 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>, Mark Allyn <mark.a.allyn@intel.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: sep: call to sep_ioctl() may leave driver in unusable state
Date: Wed, 31 Aug 2011 01:57:10 +0400
Message-Id: <1314741430-5947-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sep_ioctl() is called from a process that does not own
current transaction, it unlocks unheld sep->ioctl_mutex and
returns -EACCES leaving sep->sep_mutex acquired.

The patch fixes the mutex lock-unlock mismatch.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/sep/sep_driver.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index bf7286e..8ac3fae 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2420,11 +2420,12 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				(sep->pid_doing_transaction != 0)) {
 		dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
 		error = -EACCES;
-		goto end_function;
 	}
-
 	mutex_unlock(&sep->sep_mutex);
 
+	if (error)
+		return error;
+
 	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
 		return -ENOTTY;
 
@@ -2461,7 +2462,6 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-end_function:
 	mutex_unlock(&sep->ioctl_mutex);
 	return error;
 }
-- 
1.7.4.1

