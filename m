Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab2IRMIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:08:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63603 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab2IRMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:16 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux@arm.linux.org.uk
Cc: FlorianSchandinat@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 08/10] drivers/video/cyber2000fb.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:58 +0200
Message-Id: <1347970080-25175-8-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
References: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

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

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/video/cyber2000fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
index c1527f5..e40125c 100644
--- a/drivers/video/cyber2000fb.c
+++ b/drivers/video/cyber2000fb.c
@@ -1804,8 +1804,10 @@ cyberpro_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	cfb->irq = dev->irq;
 	cfb->region = pci_ioremap_bar(dev, 0);
-	if (!cfb->region)
+	if (!cfb->region) {
+		err = -ENOMEM;
 		goto failed_ioremap;
+	}
 
 	cfb->regs = cfb->region + MMIO_OFFSET;
 	cfb->fb.device = &dev->dev;
-- 
1.7.11.4

