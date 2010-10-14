Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab0JNSWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 14:22:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56900 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0JNSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 14:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ZF2Vwnj4Pq1iWDe6eH0hP3bYZH2E/j6KpTFiL7qHIQDqxq0Y7WpaIVVxLJBsnIllfI
         HQiGiMavnYaWpBjCgkBjFJJEYxHqdoLPIlOKZqqrOmRTqnfn+5+q3paNXsECvTFA22gy
         SMy1AH0V9zc7NRK94TyTxQst25Mqx+2Bjl5gQ=
Date: Thu, 14 Oct 2010 20:21:59 +0200
From: Dan Carpenter <error27@gmail.com>
To: Neela Syam Kolli <megaraidlinux@lsi.com>, bo yang <boyang1288@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -next] megaraid: unlock on error path
Message-ID: <20101014182159.GB6614@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Neela Syam Kolli <megaraidlinux@lsi.com>,
	bo yang <boyang1288@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to release the semaphore here before returning.

This was introduced in 39a985547cb: "[SCSI] megaraid_sas: Add Online
Controller Reset to MegaRAID SAS drive"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 55951f4..ab28bae 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -4436,11 +4436,13 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		printk(KERN_ERR "megaraid_sas: timed out while"
 			"waiting for HBA to recover\n");
 		error = -ENODEV;
-		goto out_kfree_ioc;
+		goto out_up;
 	}
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
+
+      out_up:
 	up(&instance->ioctl_sem);
 
       out_kfree_ioc:
