Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0KVIkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:40:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46653 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0KVIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:40:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gzQj237e1hm0AFJBzaG+2MiSI4K+YLe94lk6oAxM/75k3Q/31uAvZcRvV2ndGsC+qH
         thXBGspNtVi1nNjsK849dTncP8jrqN99fS2MlYd5tnShRpukq/Qat8W9Z3a0mqX6g8on
         8PFxBspYJ0up96tZc0sejh26YAK8jR62d5wM0=
Subject: [PATCH 2/4] [ARM] mvsdio: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
In-Reply-To: <1290415467.5471.7.camel@mola>
References: <1290415359.5471.4.camel@mola>  <1290415467.5471.7.camel@mola>
Content-Type: text/plain
Date: Mon, 22 Nov 2010 16:45:34 +0800
Message-Id: <1290415534.5471.8.camel@mola>
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
 drivers/mmc/host/mvsdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index a5bf60e..6a29972 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -825,7 +825,7 @@ out:
 			iounmap(host->base);
 	}
 	if (r)
-		release_resource(r);
+		release_mem_region(r->start, SZ_1K);
 	if (mmc)
 		mmc_free_host(mmc);
 
@@ -850,7 +850,7 @@ static int __exit mvsd_remove(struct platform_device *pdev)
 		del_timer_sync(&host->timer);
 		mvsd_power_down(host);
 		iounmap(host->base);
-		release_resource(host->res);
+		release_mem_region(host->res->start, SZ_1K);
 		mmc_free_host(mmc);
 	}
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.2



