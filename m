Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0CVMLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:11:23 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52919 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab0CVMLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=OpVol2GpiYLKExSEIzDIgnRaeyb+r9XS+yh/lxYIloA43SbpvjILUe+XBkSwgqwhEK
         Ce1k29oFnvseXc5jnyj3Alk+bwwmhc93ZK+iBDnzwObJITN20MU7zdUkzMvBzxgA99L0
         Ns5l6dH4x3Vss+PeiUdhlZGgb3Qr9AeyVOnKw=
Date: Mon, 22 Mar 2010 15:11:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: netdev@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, Joe Perches <joe@perches.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch] stmmac: use resource_size()
Message-ID: <20100322121111.GJ21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size calculation is not correct.  It should be end - start + 1.
Use resource_size() to calculate it instead.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index a673361..92bef30 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -1685,8 +1685,7 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
 	}
 	pr_info("done!\n");
 
-	if (!request_mem_region(res->start, (res->end - res->start),
-				pdev->name)) {
+	if (!request_mem_region(res->start, resource_size(res),	pdev->name)) {
 		pr_err("%s: ERROR: memory allocation failed"
 		       "cannot get the I/O addr 0x%x\n",
 		       __func__, (unsigned int)res->start);
@@ -1694,9 +1693,9 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	addr = ioremap(res->start, (res->end - res->start));
+	addr = ioremap(res->start, resource_size(res));
 	if (!addr) {
-		pr_err("%s: ERROR: memory mapping failed \n", __func__);
+		pr_err("%s: ERROR: memory mapping failed\n", __func__);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1774,7 +1773,7 @@ static int stmmac_dvr_probe(struct platform_device *pdev)
 out:
 	if (ret < 0) {
 		platform_set_drvdata(pdev, NULL);
-		release_mem_region(res->start, (res->end - res->start));
+		release_mem_region(res->start, resource_size(res));
 		if (addr != NULL)
 			iounmap(addr);
 	}
@@ -1812,7 +1811,7 @@ static int stmmac_dvr_remove(struct platform_device *pdev)
 
 	iounmap((void *)ndev->base_addr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, (res->end - res->start));
+	release_mem_region(res->start, resource_size(res));
 
 	free_netdev(ndev);
 
