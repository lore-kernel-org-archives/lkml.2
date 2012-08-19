Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2HSIqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:46:38 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:47863 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab2HSIoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:54 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216904"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] drivers/mtd/ubi/build.c: fix error return code
Date: Sun, 19 Aug 2012 10:44:29 +0200
Message-Id: <1345365870-29831-14-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize return variable before exiting on an error path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/ubi/build.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 7b6b5f9..afe9075 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1159,8 +1159,10 @@ static int __init ubi_init(void)
 	ubi_wl_entry_slab = kmem_cache_create("ubi_wl_entry_slab",
 					      sizeof(struct ubi_wl_entry),
 					      0, 0, NULL);
-	if (!ubi_wl_entry_slab)
+	if (!ubi_wl_entry_slab) {
+		err = -ENOMEM;
 		goto out_dev_unreg;
+	}
 
 	err = ubi_debugfs_init();
 	if (err)

