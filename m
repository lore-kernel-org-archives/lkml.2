Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2H1Oik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:38:40 -0400
Received: from mail.ispras.ru ([83.149.199.43]:47664 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2H1Oij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:38:39 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>,
        Sreekanth.Reddy@lsi.com, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH v2] [SCSI] mpt2sas: fix double mutex lock in NON_BLOCKING state
Date: Tue, 28 Aug 2012 18:38:02 +0400
Message-Id: <1346164683-9315-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If state is NON_BLOCKING and mutex_trylock is succeed,
the control flow goes to mutex_lock_interruptible() that is a deadlock.

The previous version of the patch becomes obsolete after 
code movement in commit 913809f6.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 49bdd2d..d29ea56 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2181,8 +2181,10 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 		return -EAGAIN;
 
 	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
-- 
1.7.9.5

