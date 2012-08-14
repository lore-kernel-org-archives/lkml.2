Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2HNGrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 02:47:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49644 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab2HNGrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 02:47:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,764,1336341600"; 
   d="scan'208";a="169831630"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/usb/gadget/s3c-hsotg.c: fix error return code
Date: Tue, 14 Aug 2012 08:47:34 +0200
Message-Id: <1344926858-1162-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344926858-1162-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344926858-1162-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/usb/gadget/s3c-hsotg.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index b13e0bb..0bb617e 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3599,6 +3599,7 @@ static int __devinit s3c_hsotg_probe(struct platform_device *pdev)
 
 	if (hsotg->num_of_eps == 0) {
 		dev_err(dev, "wrong number of EPs (zero)\n");
+		ret = -EINVAL;
 		goto err_supplies;
 	}
 
@@ -3606,6 +3607,7 @@ static int __devinit s3c_hsotg_probe(struct platform_device *pdev)
 		      GFP_KERNEL);
 	if (!eps) {
 		dev_err(dev, "cannot get memory\n");
+		ret = -ENOMEM;
 		goto err_supplies;
 	}
 
@@ -3622,6 +3624,7 @@ static int __devinit s3c_hsotg_probe(struct platform_device *pdev)
 						     GFP_KERNEL);
 	if (!hsotg->ctrl_req) {
 		dev_err(dev, "failed to allocate ctrl req\n");
+		ret = -ENOMEM;
 		goto err_ep_mem;
 	}
 

