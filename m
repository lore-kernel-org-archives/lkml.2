Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0HKHnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:43:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38563 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0HKHnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=B0kmMnE/AaOKIQG1FczwUyhCUUZSHaLgjdsBFKuze0GtUaTYZMjxCumjfc16BGK6H4
         pasGZL1Ms5polV4onz0DFxVbMPGlysw1vGx0S00U4FCRwdNbSY5Urq9ss7DUgkNcSXwp
         P9tSmibgn3WhMNVm7KZ7becTH6vSisTc03UzQ=
Date: Wed, 11 Aug 2010 09:41:57 +0200
From: Dan Carpenter <error27@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Srinivas <satyasrinivasp@hcl.in>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2] mvsas: dereferencing before checking
Message-ID: <20100811074157.GB30429@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Jiri Slaby <jslaby@suse.cz>, Srinivas <satyasrinivasp@hcl.in>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "mvi_dev" is NULL then we have to test it at the start of the function
and return if it is null.  In the original code, we dereferenced "mvi_dev"
before the check to assign "mvi" and then we dereferenced "mvi" to take
the spin lock.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 406246c..a5c5aa5 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1379,19 +1379,21 @@ void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
-
-	spin_lock_irqsave(&mvi->lock, flags);
+	struct mvs_info *mvi;
 
-	if (mvi_dev) {
-		mv_dprintk("found dev[%d:%x] is gone.\n",
-			mvi_dev->device_id, mvi_dev->dev_type);
-		mvs_release_task(mvi, dev);
-		mvs_free_reg_set(mvi, mvi_dev);
-		mvs_free_dev(mvi_dev);
-	} else {
+	if (!mvi_dev) {
 		mv_dprintk("found dev has gone.\n");
+		return;
 	}
+
+	mvi = mvi_dev->mvi_info;
+	spin_lock_irqsave(&mvi->lock, flags);
+
+	mv_dprintk("found dev[%d:%x] is gone.\n",
+		mvi_dev->device_id, mvi_dev->dev_type);
+	mvs_release_task(mvi, dev);
+	mvs_free_reg_set(mvi, mvi_dev);
+	mvs_free_dev(mvi_dev);
 	dev->lldd_dev = NULL;
 
 	spin_unlock_irqrestore(&mvi->lock, flags);
