Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2HNGry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 02:47:54 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49652 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604Ab2HNGrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 02:47:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,764,1336341600"; 
   d="scan'208";a="169831631"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] drivers/tty/moxa.c: fix error return code
Date: Tue, 14 Aug 2012 08:47:35 +0200
Message-Id: <1344926858-1162-3-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/tty/moxa.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 89cc934..8b510c5 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -967,6 +967,7 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 	board->basemem = ioremap_nocache(pci_resource_start(pdev, 2), 0x4000);
 	if (board->basemem == NULL) {
 		dev_err(&pdev->dev, "can't remap io space 2\n");
+		retval = -ENOMEM;
 		goto err_reg;
 	}
 

