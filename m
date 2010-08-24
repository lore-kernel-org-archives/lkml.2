Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0HXFoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:44:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60317 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0HXFoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KSlxYbE/WzrPFj/bA3qgkai1qdBDkzNyBENl1SCy/M2nLBh4t/Jr3xS6dUIc2mSoSA
         3+5K72NdZAPtied5Jhy2Tn0kUx1W3I8yxQIzOHhZbviZL7y5x5u/Nvt9DiZ0AJGvNSt0
         eXfqh2Q8qBQuHz/0wbuUpKzXGlTSTN5mgP5t4=
Subject: [PATCH 3/3] mfd: tps6586x - fix tps6586x_add_subdevs error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <1282628645.6074.1.camel@mola>
References: <1282628645.6074.1.camel@mola>
Content-Type: text/plain
Date: Tue, 24 Aug 2010 13:47:22 +0800
Message-Id: <1282628842.6074.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. return -ENOMEM if platform_device_alloc() fail.
2. call platform_device_put() if platform_device_add() fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps6586x.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 4cde31e..1c91936 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -273,13 +273,19 @@ static int __devinit tps6586x_add_subdevs(struct tps6586x *tps6586x,
 		subdev = &pdata->subdevs[i];
 
 		pdev = platform_device_alloc(subdev->name, subdev->id);
+		if (!pdev) {
+			ret = -ENOMEM;
+			goto failed;
+		}
 
 		pdev->dev.parent = tps6586x->dev;
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



