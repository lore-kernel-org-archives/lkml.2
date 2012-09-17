Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2IQRbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:31:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58500 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2IQRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:31:30 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] drivers/virtio/virtio_pci.c: fix error return code
Date: Mon, 17 Sep 2012 19:31:17 +0200
Message-Id: <1347903077-19906-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
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
 drivers/virtio/virtio_pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 42b2076..c33aea3 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -719,8 +719,10 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		goto out_enable_device;
 
 	vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
-	if (vp_dev->ioaddr == NULL)
+	if (vp_dev->ioaddr == NULL) {
+		err = -ENOMEM;
 		goto out_req_regions;
+	}
 
 	pci_set_drvdata(pci_dev, vp_dev);
 	pci_set_master(pci_dev);
-- 
1.7.11.4

