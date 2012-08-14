Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2HNM6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:58:44 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:41708 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276Ab2HNM6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:58:41 -0400
X-IronPort-AV: E=Sophos;i="4.77,766,1336341600"; 
   d="scan'208";a="169863667"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Vinod Koul <vinod.koul@intel.com>
Cc: kernel-janitors@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/dma/amba-pl08x.c: fix error return code
Date: Tue, 14 Aug 2012 14:58:32 +0200
Message-Id: <1344949115-13266-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344949115-13266-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344949115-13266-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a 0 error return code to a negative one, as returned elsewhere in the
function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret;
expression e,e1,e2,e3,e4,x;
@@

(
if (\(ret != 0\|ret < 0\) || ...) { ... return ...; }
|
ret = 0
)
... when != ret = e1
*x = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\|ioremap\|ioremap_nocache\|devm_ioremap\|devm_ioremap_nocache\)(...);
... when != x = e2
    when != ret = e3
*if (x == NULL || ...)
{
  ... when != ret = e4
*  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/dma/amba-pl08x.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6fbeebb..d1cc579 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1892,6 +1892,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	pl08x->pd = dev_get_platdata(&adev->dev);
 	if (!pl08x->pd) {
 		dev_err(&adev->dev, "no platform data supplied\n");
+		ret = -EINVAL;
 		goto out_no_platdata;
 	}
 
@@ -1943,6 +1944,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		dev_err(&adev->dev, "%s failed to allocate "
 			"physical channel holders\n",
 			__func__);
+		ret = -ENOMEM;
 		goto out_no_phychans;
 	}
 

