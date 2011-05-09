Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1EIUia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:38:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49108 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1EIUi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vGdORVD1WXwY4DEWc4CUm7b0PHceZguGrtGmStqwsdMVyA9Jxx1EfOqrJl6t46h0G4
         PwW08mAHT0bS14gwJ+nBd3ZLmnt4UDB7vLdGFsmqAcgkMzYttqhyxXCR9skkZWtuLbeS
         dK1m/IlNxSFv4Mp0CuGLLkJEAXDDV+DNrgvSY=
Message-ID: <4DC85094.4050401@gmail.com>
Date: Mon, 09 May 2011 22:37:40 +0200
From: Vladimir Motyka <vladimir.motyka@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: cjb@laptop.org, kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mmc/card/block.c: fix potential null dereference
 'idata'
References: <4DC7F4AB.90607@gmail.com> <Pine.LNX.4.64.1105091631400.15483@pc-004.diku.dk> <4DC802C0.9040302@gmail.com> <Pine.LNX.4.64.1105091713080.15483@pc-004.diku.dk> <4DC8117C.7060200@gmail.com> <Pine.LNX.4.64.1105091811320.15483@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1105091811320.15483@pc-004.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocation of idata failed there was a null dereference. Also avoid
calling kfree where it is needn't.

---
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 407836d..126c7f4 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -237,24 +237,24 @@ static struct mmc_blk_ioc_data
*mmc_blk_ioctl_copy_from_user(
 	idata = kzalloc(sizeof(*idata), GFP_KERNEL);
 	if (!idata) {
 		err = -ENOMEM;
-		goto copy_err;
+		goto out;
 	}

 	if (copy_from_user(&idata->ic, user, sizeof(idata->ic))) {
 		err = -EFAULT;
-		goto copy_err;
+		goto idata_err;
 	}

 	idata->buf_bytes = (u64) idata->ic.blksz * idata->ic.blocks;
 	if (idata->buf_bytes > MMC_IOC_MAX_BYTES) {
 		err = -EOVERFLOW;
-		goto copy_err;
+		goto idata_err;
 	}

 	idata->buf = kzalloc(idata->buf_bytes, GFP_KERNEL);
 	if (!idata->buf) {
 		err = -ENOMEM;
-		goto copy_err;
+		goto idata_err;
 	}

 	if (copy_from_user(idata->buf, (void __user *)(unsigned long)
@@ -267,9 +267,10 @@ static struct mmc_blk_ioc_data
*mmc_blk_ioctl_copy_from_user(

 copy_err:
 	kfree(idata->buf);
+idata_err:
 	kfree(idata);
+out:
 	return ERR_PTR(err);
-
 }

 static int mmc_blk_ioctl_cmd(struct block_device *bdev,
