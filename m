Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2HEJyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 05:54:31 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:9388 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab2HEJwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 05:52:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,715,1336341600"; 
   d="scan'208";a="152465603"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: kernel-janitors@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/6] drivers/edac/i7core_edac.c: fix error return code
Date: Sun,  5 Aug 2012 11:52:31 +0200
Message-Id: <1344160356-387-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

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

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/edac/i7core_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 3672101..64dcc98 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1177,7 +1177,7 @@ static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
 
 	pvt->addrmatch_dev = kzalloc(sizeof(*pvt->addrmatch_dev), GFP_KERNEL);
 	if (!pvt->addrmatch_dev)
-		return rc;
+		return -ENOMEM;
 
 	pvt->addrmatch_dev->type = &addrmatch_type;
 	pvt->addrmatch_dev->bus = mci->dev.bus;
@@ -1198,7 +1198,7 @@ static int i7core_create_sysfs_devices(struct mem_ctl_info *mci)
 		if (!pvt->chancounts_dev) {
 			put_device(pvt->addrmatch_dev);
 			device_del(pvt->addrmatch_dev);
-			return rc;
+			return -ENOMEM;
 		}
 
 		pvt->chancounts_dev->type = &all_channel_counts_type;

