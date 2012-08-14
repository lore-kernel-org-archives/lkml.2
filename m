Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2HNNAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:00:03 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:48478 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997Ab2HNM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:58:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,766,1336341600"; 
   d="scan'208";a="169863666"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/cdrom/gdrom.c: fix error return code
Date: Tue, 14 Aug 2012 14:58:31 +0200
Message-Id: <1344949115-13266-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/cdrom/gdrom.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 3ceaf00..f05863b 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -808,16 +808,20 @@ static int __devinit probe_gdrom(struct platform_device *devptr)
 	if (err)
 		goto probe_fail_cmdirq_register;
 	gd.gdrom_rq = blk_init_queue(gdrom_request, &gdrom_lock);
-	if (!gd.gdrom_rq)
+	if (!gd.gdrom_rq) {
+		err = -ENOMEM;
 		goto probe_fail_requestq;
+	}
 
 	err = probe_gdrom_setupqueue();
 	if (err)
 		goto probe_fail_toc;
 
 	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
-	if (!gd.toc)
+	if (!gd.toc) {
+		err = -ENOMEM;
 		goto probe_fail_toc;
+	}
 	add_disk(gd.disk);
 	return 0;
 

