Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2DEDue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 23:50:34 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:48262 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab2DEDud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 23:50:33 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] [SCSI] mpt2sas: fix double mutex lock in NON_BLOCKING state
Date: Wed,  4 Apr 2012 20:50:05 -0700
Message-Id: <1333597805-22540-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If state is NON_BLOCKING and mutex_trylock is succeed, 
the control flow goes to mutex_lock_interruptible() that is a deadlock.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 1c6d2b4..9bd7ffc 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -648,8 +648,10 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 
 	issue_reset = 0;
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
@@ -1587,8 +1589,10 @@ _ctl_diag_register(void __user *arg, enum block_state state)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 	rc = _ctl_diag_register_2(ioc, &karg);
@@ -1932,8 +1936,10 @@ _ctl_diag_release(void __user *arg, enum block_state state)
 		return 0;
 	}
 
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
@@ -2033,8 +2039,10 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	}
 	/* Get a free request frame and save the message context.
 	*/
-	if (state == NON_BLOCKING && !mutex_trylock(&ioc->ctl_cmds.mutex))
-		return -EAGAIN;
+	if (state == NON_BLOCKING) {
+		if (!mutex_trylock(&ioc->ctl_cmds.mutex))
+			return -EAGAIN;
+	}
 	else if (mutex_lock_interruptible(&ioc->ctl_cmds.mutex))
 		return -ERESTARTSYS;
 
-- 
1.7.1

