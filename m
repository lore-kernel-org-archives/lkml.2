Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2HSIsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:48:23 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:40050 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab2HSIor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:47 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216899"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/14] drivers/video/sunxvr2500.c: fix error return code
Date: Sun, 19 Aug 2012 10:44:24 +0200
Message-Id: <1345365870-29831-9-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/video/sunxvr2500.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/sunxvr2500.c b/drivers/video/sunxvr2500.c
index 5848436..7fbcba8 100644
--- a/drivers/video/sunxvr2500.c
+++ b/drivers/video/sunxvr2500.c
@@ -181,8 +181,10 @@ static int __devinit s3d_pci_register(struct pci_dev *pdev,
 	sp->fb_size = info->fix.line_length * sp->height;
 
 	sp->fb_base = ioremap(sp->fb_base_phys, sp->fb_size);
-	if (!sp->fb_base)
+	if (!sp->fb_base) {
+		err = -ENOMEM;
 		goto err_release_pci;
+	}
 
 	err = s3d_set_fbinfo(sp);
 	if (err)

