Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2DJGRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:17:43 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:50770 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248Ab2DJGRl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:17:41 -0400
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@ispras.ru" <ldv-project@ispras.ru>
Date: Tue, 10 Apr 2012 11:47:34 +0530
Subject: RE: [PATCH] [SCSI] mpt2sas: fix double mutex lock in NON_BLOCKING
 state
Thread-Topic: [PATCH] [SCSI] mpt2sas: fix double mutex lock in NON_BLOCKING
 state
Thread-Index: Ac0S30GNeK6Vx8NzR7SqzENu1QevcAEAlZ/A
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E7E4096@inbmail02.lsi.com>
References: <1333597805-22540-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1333597805-22540-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Regards,
Nagalakshmi


-----Original Message-----
From: Alexey Khoroshilov [mailto:khoroshilov@ispras.ru] 
Sent: Thursday, April 05, 2012 9:20 AM
To: Nandigama, Nagalakshmi; James E.J. Bottomley
Cc: Alexey Khoroshilov; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; ldv-project@ispras.ru
Subject: [PATCH] [SCSI] mpt2sas: fix double mutex lock in NON_BLOCKING state

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

