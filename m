Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309Ab1KJEIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:08:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965303Ab1KJDor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:44:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:57 2011
Message-Id: <20111109213157.813128185@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shubhrajyoti D <shubhrajyoti@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [155/264] OMAP: SPI: Fix the trying to free nonexistent resource error
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti D <shubhrajyoti@ti.com>

commit 1458d160de3f1862aeaac57447ba96e7857ac52b upstream.

Currently there is a request_mem_region(r->start, ..
followed by r->start += pdata->regs_offset;

And then in remove

   r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
   release_mem_region(r->start, resource_size(r));

Here the offset addition is not taken care. Fix the code for the
same.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/spi/spi-omap2-mcspi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1116,15 +1116,16 @@ static int __init omap2_mcspi_probe(stru
 		status = -ENODEV;
 		goto err1;
 	}
+
+	r->start += pdata->regs_offset;
+	r->end += pdata->regs_offset;
+	mcspi->phys = r->start;
 	if (!request_mem_region(r->start, resource_size(r),
 				dev_name(&pdev->dev))) {
 		status = -EBUSY;
 		goto err1;
 	}
 
-	r->start += pdata->regs_offset;
-	r->end += pdata->regs_offset;
-	mcspi->phys = r->start;
 	mcspi->base = ioremap(r->start, resource_size(r));
 	if (!mcspi->base) {
 		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");


