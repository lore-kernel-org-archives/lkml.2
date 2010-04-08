Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0DHB2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 21:28:24 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:60089 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0DHB2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 21:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=ToydaWDr9RmTtd5g1/XeqBY9HTIGna3x8VrPCjEWIwIlR93LRaY7rfjB5+qwxEI8OF
         ZDIUMUNSbYcEBWgt3ha7OXy7xt1Ev9jW3UE150st8XM6eKxQsFMrdpDJHG4Bn3aH2N9Z
         Pu0NiNU1cCNMVqtKhLtQakqrEoTGGcnVS7rLE=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 8 Apr 2010 09:28:02 +0800
Message-ID: <p2z427d64721004071828w41cedeb5j1079ed4cdd04fbf2@mail.gmail.com>
Subject: [PATCH] stmmac: Fix incorrect resource calculation
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size calculation is not correct.  It should be end - start + 1.
Use resource_size for {request/release}_mem_region and ioremap.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/net/stmmac/stmmac_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index a214a16..f613a07 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -1686,7 +1686,7 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
        }
        pr_info("done!\n");

-       if (!request_mem_region(res->start, (res->end - res->start),
+       if (!request_mem_region(res->start, resource_size(res),
                                pdev->name)) {
                pr_err("%s: ERROR: memory allocation failed"
                       "cannot get the I/O addr 0x%x\n",
@@ -1695,7 +1695,7 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
                goto out;
        }

-       addr = ioremap(res->start, (res->end - res->start));
+       addr = ioremap(res->start, resource_size(res));
        if (!addr) {
                pr_err("%s: ERROR: memory mapping failed \n", __func__);
                ret = -ENOMEM;
@@ -1775,7 +1775,7 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
 out:
        if (ret < 0) {
                platform_set_drvdata(pdev, NULL);
-               release_mem_region(res->start, (res->end - res->start));
+               release_mem_region(res->start, resource_size(res));
                if (addr != NULL)
                        iounmap(addr);
        }
@@ -1813,7 +1813,7 @@ static int stmmac_dvr_remove(struct platform_device *pdev)

        iounmap((void *)ndev->base_addr);
        res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-       release_mem_region(res->start, (res->end - res->start));
+       release_mem_region(res->start, resource_size(res));

        free_netdev(ndev);

-- 
1.5.4.3
