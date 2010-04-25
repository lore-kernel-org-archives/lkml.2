Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0DYNoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:44:19 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:37511 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0DYNoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ov9nl0pI2LuaPdawtoma7T6YQIPMFeO/m8Hoi9U37C2SfApkWlUJTq5YQZC0Zb8hz4
         QQ4lupOFOpSvqzTocH1Kqzqjh6Vj8Vg68WLnap1s6uOYVt9Dy8CsOsycKpFOlJcOoy1q
         J0j9xy/3uiLRdCOO001bOSVn7+4EWZw5DJalE=
Date: Sun, 25 Apr 2010 22:41:43 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] staging: crystalhd: clean up crystalhd_user_open()
 return code
Message-Id: <20100425224143.31584a1d.yuasa@linux-mips.org>
In-Reply-To: <20100425221851.223dc284.yuasa@linux-mips.org>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/staging/crystalhd/crystalhd_cmds.c |   10 +++++-----
 drivers/staging/crystalhd/crystalhd_cmds.h |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c  |    9 ++++-----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index d341876..1286ed9 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -875,20 +875,20 @@ BC_STATUS crystalhd_resume(struct crystalhd_cmd *ctx)
  * application specific resources. HW layer initialization
  * is done for the first open request.
  */
-BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
-			    struct crystalhd_user **user_ctx)
+int crystalhd_user_open(struct crystalhd_cmd *ctx,
+			struct crystalhd_user **user_ctx)
 {
 	struct crystalhd_user *uc;
 
 	if (!ctx || !user_ctx) {
 		BCMLOG_ERR("Invalid arg..\n");
-		return BC_STS_INV_ARG;
+		return -EINVAL;
 	}
 
 	uc = bc_cproc_get_uid(ctx);
 	if (!uc) {
 		BCMLOG(BCMLOG_INFO, "No free user context...\n");
-		return BC_STS_BUSY;
+		return -EBUSY;
 	}
 
 	BCMLOG(BCMLOG_INFO, "Opening new user[%x] handle\n", uc->uid);
@@ -899,7 +899,7 @@ BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
 
 	*user_ctx = uc;
 
-	return BC_STS_SUCCESS;
+	return 0;
 }
 
 /**
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.h b/drivers/staging/crystalhd/crystalhd_cmds.h
index 026a07e..8e15bf2 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.h
+++ b/drivers/staging/crystalhd/crystalhd_cmds.h
@@ -79,7 +79,7 @@ BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx, crystalhd_ioctl_data *ida
 BC_STATUS crystalhd_resume(struct crystalhd_cmd *ctx);
 crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cmd,
 				      struct crystalhd_user *uc);
-BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx, struct crystalhd_user **user_ctx);
+int crystalhd_user_open(struct crystalhd_cmd *ctx, struct crystalhd_user **user_ctx);
 void crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user *uc);
 int crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx, struct crystalhd_adp *adp);
 void crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx);
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 19769df..6f3c7a0 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -294,8 +294,7 @@ static int chd_dec_ioctl(struct inode *in, struct file *fd,
 static int chd_dec_open(struct inode *in, struct file *fd)
 {
 	struct crystalhd_adp *adp = chd_get_adp();
-	int rc = 0;
-	BC_STATUS sts = BC_STS_SUCCESS;
+	int rc;
 	struct crystalhd_user *uc = NULL;
 
 	BCMLOG_ENTER;
@@ -309,9 +308,9 @@ static int chd_dec_open(struct inode *in, struct file *fd)
 		return -EBUSY;
 	}
 
-	sts = crystalhd_user_open(&adp->cmds, &uc);
-	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd_user_open - %d \n", sts);
+	rc = crystalhd_user_open(&adp->cmds, &uc);
+	if (rc) {
+		BCMLOG_ERR("cmd_user_open - %d \n", rc);
 		rc = -EBUSY;
 	}
 
-- 
1.7.1

