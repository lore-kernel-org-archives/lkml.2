Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2HNM7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:59:16 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:60068 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368Ab2HNM6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:58:42 -0400
X-IronPort-AV: E=Sophos;i="4.77,766,1336341600"; 
   d="scan'208";a="169863671"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mike Marciniszyn <infinipath@intel.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/infiniband/hw/qib/qib_iba7322.c: fix error return code
Date: Tue, 14 Aug 2012 14:58:35 +0200
Message-Id: <1344949115-13266-6-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/infiniband/hw/qib/qib_iba7322.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 0d7280a..3f6b21e 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6346,8 +6346,10 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 			dd->piobcnt4k * dd->align4k;
 		dd->piovl15base	= ioremap_nocache(vl15off,
 						  NUM_VL15_BUFS * dd->align4k);
-		if (!dd->piovl15base)
+		if (!dd->piovl15base) {
+			ret = -ENOMEM;
 			goto bail;
+		}
 	}
 	qib_7322_set_baseaddrs(dd); /* set chip access pointers now */
 

