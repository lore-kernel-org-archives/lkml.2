Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0HTB5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:57:03 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61702 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0HTB5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ligpAEPiN9AqLqzyvI01RKYToPbyGCk3FaClxRf8h8nAhhdCTP7W6qL1n59EN/O89k
         wrSUfnWzxmsals3585A5/DTZGCcuu8+oJbS3n8ONhrX7grkrPm4d7eDLnETIW6n9a9lw
         Zv7EKjvC0suxzvW9evlG5hXAkigAdpledlZuU=
Subject: [PATCH 2/4] regulator/wm831x-isink: fix potential NULL dereference
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <1282269518.31048.2.camel@mola>
References: <1282269518.31048.2.camel@mola>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 09:59:47 +0800
Message-Id: <1282269587.31048.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata is dereferenced earlier than tested for being NULL.
Thus move the dereference of "pdata" below the check for NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-isink.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 6c446cd..123d722 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -153,13 +153,16 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
 	struct wm831x_isink *isink;
-	int id = pdev->id % ARRAY_SIZE(pdata->isink);
 	struct resource *res;
-	int ret, irq;
+	int id, ret, irq;
 
+	if (pdata == NULL)
+		return -ENODEV;
+
+	id = pdev->id % ARRAY_SIZE(pdata->isink);
 	dev_dbg(&pdev->dev, "Probing ISINK%d\n", id + 1);
 
-	if (pdata == NULL || pdata->isink[id] == NULL)
+	if (pdata->isink[id] == NULL)
 		return -ENODEV;
 
 	isink = kzalloc(sizeof(struct wm831x_isink), GFP_KERNEL);
-- 
1.7.2



