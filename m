Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0HXFmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:42:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42193 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0HXFmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WWPThpwaOm7CDMatEEY7sGw8UaxcwNnuvrjzpNu8daEW09ze7EVAKkJHoue7NVdCNK
         N+SkbQD4C8uOn64uBP8k1rsA1jcCWx7GVNSIILXw1v8xthh42g8hFgvzijM1KLyNWOVF
         Is4rjTgIJwoOvNVDSJiqtSYfNYHqSXCyeZqP8=
Subject: [PATCH 2/3] mfd: ezx-pcap - fix pcap_add_subdev error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Daniel Ribeiro <drwyrm@gmail.com>
In-Reply-To: <1282628645.6074.1.camel@mola>
References: <1282628645.6074.1.camel@mola>
Content-Type: text/plain
Date: Tue, 24 Aug 2010 13:45:49 +0800
Message-Id: <1282628749.6074.3.camel@mola>
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
 drivers/mfd/ezx-pcap.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 134c69a..d283d77 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -384,12 +384,20 @@ static int __devinit pcap_add_subdev(struct pcap_chip *pcap,
 						struct pcap_subdev *subdev)
 {
 	struct platform_device *pdev;
+	int ret;
 
 	pdev = platform_device_alloc(subdev->name, subdev->id);
+	if (!pdev)
+		return -ENOMEM;
+
 	pdev->dev.parent = &pcap->spi->dev;
 	pdev->dev.platform_data = subdev->platform_data;
 
-	return platform_device_add(pdev);
+	ret = platform_device_add(pdev);
+	if (ret)
+		platform_device_put(pdev);
+
+	return ret;
 }
 
 static int __devexit ezx_pcap_remove(struct spi_device *spi)
-- 
1.7.2



