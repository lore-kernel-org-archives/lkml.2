Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2HNPv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:51:59 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:52609
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335Ab2HNPty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:49:54 -0400
X-IronPort-AV: E=Sophos;i="4.77,766,1336341600"; 
   d="scan'208";a="153065911"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/block/swim3.c: Remove potential NULL dereference
Date: Tue, 14 Aug 2012 17:49:44 +0200
Message-Id: <1344959388-19719-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If the NULL test is necessary, the initialization involving a dereference of
the tested value should be moved after the NULL test.

The sematic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/block/swim3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 89ddab1..ffecfef 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1090,10 +1090,11 @@ static const struct block_device_operations floppy_fops = {
 static void swim3_mb_event(struct macio_dev* mdev, int mb_state)
 {
 	struct floppy_state *fs = macio_get_drvdata(mdev);
-	struct swim3 __iomem *sw = fs->swim3;
+	struct swim3 __iomem *sw;
 
 	if (!fs)
 		return;
+	sw = fs->swim3;
 	if (mb_state != MB_FD)
 		return;
 

