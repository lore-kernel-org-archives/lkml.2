Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab0KHFb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:31:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57328 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0KHFb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:31:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vFiq7xb1XZVFTNxxARdgEJrfiWo70s9RvLuDsT3774R5FcFowehBwghyiHE5LQemF1
         jblytERaLXTuye5tyunYl+/YUla0sBn9TFu+TFvguzbD1cCq2ejSdyn1rXDlXfXYvdhy
         /BC3bnePyF1QrsoNzDYF1XknHQjC9+Xg91r8M=
Subject: [PATCH] rtc: rtc-sh - fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain
Date: Mon, 08 Nov 2010 13:35:10 +0800
Message-Id: <1289194510.682.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_mem_region() will call kzalloc to allocate memory for struct resource.
release_resource() unregisters the resource but does not free the allocated
memory, thus use release_mem_region() instead to fix the memory leak.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-sh.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 5efbd59..06e41ed 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -761,7 +761,7 @@ err_unmap:
 	clk_put(rtc->clk);
 	iounmap(rtc->regbase);
 err_badmap:
-	release_resource(rtc->res);
+	release_mem_region(rtc->res->start, rtc->regsize);
 err_badres:
 	kfree(rtc);
 
@@ -786,7 +786,7 @@ static int __exit sh_rtc_remove(struct platform_device *pdev)
 	}
 
 	iounmap(rtc->regbase);
-	release_resource(rtc->res);
+	release_mem_region(rtc->res->start, rtc->regsize);
 
 	clk_disable(rtc->clk);
 	clk_put(rtc->clk);
-- 
1.7.2



