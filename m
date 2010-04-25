Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0DYNoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:44:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58800 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0DYNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=qdtrQITsl+eIkYWjw/FGK2wVJVvGKm6MlE0Tab6HR6zRuq1LPxbqBxpciseVah2CeM
         8F954aIAhWBzPrICFaLxCubSmeva2x5FhHzP7AQXFhRCU6fRWFAHHHbBqadYqFakmWIi
         AJyDXwNuXWbesmTx0CzW8YhorGIB1wqpQMJNI=
Date: Sun, 25 Apr 2010 22:24:47 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] staging: crystalhd: clean up
 crystalhd_setup_cmd_context() return code
Message-Id: <20100425222447.bbd0b45f.yuasa@linux-mips.org>
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
 drivers/staging/crystalhd/crystalhd_cmds.c |    9 +++++----
 drivers/staging/crystalhd/crystalhd_cmds.h |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c  |    7 +++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index 26145a8..516e825 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -948,14 +948,14 @@ BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user
  *
  * Called at the time of driver load.
  */
-BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
-				    struct crystalhd_adp *adp)
+int __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
+					  struct crystalhd_adp *adp)
 {
 	int i = 0;
 
 	if (!ctx || !adp) {
 		BCMLOG_ERR("Invalid arg!!\n");
-		return BC_STS_INV_ARG;
+		return -EINVAL;
 	}
 
 	if (ctx->adp)
@@ -971,7 +971,8 @@ BC_STATUS __devinit crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 	/*Open and Close the Hardware to put it in to sleep state*/
 	crystalhd_hw_open(&ctx->hw_ctx, ctx->adp);
 	crystalhd_hw_close(&ctx->hw_ctx);
-	return BC_STS_SUCCESS;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.h b/drivers/staging/crystalhd/crystalhd_cmds.h
index 6b290ae..90b4467 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.h
+++ b/drivers/staging/crystalhd/crystalhd_cmds.h
@@ -81,7 +81,7 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cm
 				      struct crystalhd_user *uc);
 BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx, struct crystalhd_user **user_ctx);
 BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx, struct crystalhd_user *uc);
-BC_STATUS crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx, struct crystalhd_adp *adp);
+int crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx, struct crystalhd_adp *adp);
 BC_STATUS crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx);
 bool crystalhd_cmd_interrupt(struct crystalhd_cmd *ctx);
 
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index a68b5ff..490d2e0 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -542,7 +542,6 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 {
 	struct crystalhd_adp *pinfo;
 	int rc;
-	BC_STATUS sts = BC_STS_SUCCESS;
 
 	BCMLOG(BCMLOG_DBG, "PCI_INFO: Vendor:0x%04x Device:0x%04x "
 	       "s_vendor:0x%04x s_device: 0x%04x\n",
@@ -602,9 +601,9 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	sts = crystalhd_setup_cmd_context(&pinfo->cmds, pinfo);
-	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd setup :%d \n", sts);
+	rc = crystalhd_setup_cmd_context(&pinfo->cmds, pinfo);
+	if (rc) {
+		BCMLOG_ERR("cmd setup :%d \n", rc);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
-- 
1.7.1

