Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2ICKCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 06:02:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49205 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2ICKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 06:02:23 -0400
MIME-Version: 1.0
Date: Mon, 3 Sep 2012 18:02:23 +0800
Message-ID: <CAPgLHd9HKqsyBydFpCHpcWmY4n2b_2kmZYKPsGfHFKNkiQJLAg@mail.gmail.com>
Subject: [PATCH] Staging: bcm: fix possible memory leak in bcm_char_ioctl()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

psFwInfo has been allocated in this function and should be
freed before leaving from the error handling cases.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/bcm/Bcmchar.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index cf411d1..3d02c2e 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -820,6 +820,7 @@ cntrlEnd:
 
 		if (copy_from_user(psFwInfo, IoBuffer.InputBuffer, IoBuffer.InputLength)) {
 			up(&Adapter->fw_download_sema);
+			kfree(psFwInfo);
 			return -EFAULT;
 		}
 
@@ -829,6 +830,7 @@ cntrlEnd:
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Something else is wrong %lu\n",
 					psFwInfo->u32FirmwareLength);
 			up(&Adapter->fw_download_sema);
+			kfree(psFwInfo);
 			Status = -EINVAL;
 			return Status;
 		}


