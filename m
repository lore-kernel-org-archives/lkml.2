Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab0HXFlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:41:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57460 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0HXFk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FQZ8ycjEQJt7kE5Q5ODh5Xe65rmelaWS3NDplmCpzi5ukgxB39ZALlnvMQqzZe55VN
         uGWyhcIgBr02WDsj6yoQDZKNyY2zpE1tRCHWL3ZlSoRHN2q1HIqHsMABllHFlh88jZVn
         AsJK3Jjh9+XZNfBehe/LZeZRWpimXAyqBjCKI=
Subject: [PATCH 1/3] mfd: da903x - fix da903x_add_subdevs error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>,
        eric miao <eric.y.miao@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Aug 2010 13:44:05 +0800
Message-Id: <1282628645.6074.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes da903x_add_subdevs error path:
1. return -ENOMEM if platform_device_alloc() fail.
2. call platform_device_put() if platform_device_add() fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/da903x.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index c07aece..2fadbae 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -470,13 +470,19 @@ static int __devinit da903x_add_subdevs(struct da903x_chip *chip,
 		subdev = &pdata->subdevs[i];
 
 		pdev = platform_device_alloc(subdev->name, subdev->id);
+		if (!pdev) {
+			ret = -ENOMEM;
+			goto failed;
+		}
 
 		pdev->dev.parent = chip->dev;
 		pdev->dev.platform_data = subdev->platform_data;
 
 		ret = platform_device_add(pdev);
-		if (ret)
+		if (ret) {
+			platform_device_put(pdev);
 			goto failed;
+		}
 	}
 	return 0;
 
-- 
1.7.2



