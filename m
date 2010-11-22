Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0KVIlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:41:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45964 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0KVIlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OjuoyYUOO3zU3c+eWGv4BYwdd0zwZFNreyglOgKm987frKgcN/Piy1qtNMi9j0qNg6
         uM1bLbEopgd7so0SyOtkCok4c5WG8O/ec2w20zWszCOZqJ+OucMHr34vSd3+z+GDXLrs
         +V6RRyAd13wag4rMO60f7/kYBKAy4AETZBTxc=
Subject: [PATCH 3/4] [ARM] pxamci: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Eric Miao <eric.y.miao@gmail.com>, linux-mmc@vger.kernel.org
In-Reply-To: <1290415534.5471.8.camel@mola>
References: <1290415359.5471.4.camel@mola>  <1290415467.5471.7.camel@mola>
	 <1290415534.5471.8.camel@mola>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 16:46:36 +0800
Message-Id: <1290415596.5471.10.camel@mola>
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
 drivers/mmc/host/pxamci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 7257738..d98e647 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -774,7 +774,7 @@ err_gpio_ro:
 	}
 	if (mmc)
 		mmc_free_host(mmc);
-	release_resource(r);
+	release_mem_region(r->start, SZ_4K);
 	return ret;
 }
 
@@ -824,7 +824,7 @@ static int pxamci_remove(struct platform_device *pdev)
 
 		clk_put(host->clk);
 
-		release_resource(host->res);
+		release_mem_region(host->res->start, SZ_4K);
 
 		mmc_free_host(mmc);
 	}
-- 
1.7.2



