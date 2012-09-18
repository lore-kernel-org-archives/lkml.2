Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab2IRMKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:10:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60548 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab2IRMIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:08:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 04/10] drivers/video/sunxvr500.c: fix error return code
Date: Tue, 18 Sep 2012 14:07:54 +0200
Message-Id: <1347970080-25175-4-git-send-email-peter.senna@gmail.com>
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
 drivers/video/sunxvr500.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/video/sunxvr500.c b/drivers/video/sunxvr500.c
index eb931b8..6c71b1b 100644
--- a/drivers/video/sunxvr500.c
+++ b/drivers/video/sunxvr500.c
@@ -298,8 +298,10 @@ static int __devinit e3d_pci_register(struct pci_dev *pdev,
 		goto err_release_fb;
 	}
 	ep->ramdac = ioremap(ep->regs_base_phys + 0x8000, 0x1000);
-	if (!ep->ramdac)
+	if (!ep->ramdac) {
+		err = -ENOMEM;
 		goto err_release_pci1;
+	}
 
 	ep->fb8_0_off = readl(ep->ramdac + RAMDAC_VID_8FB_0);
 	ep->fb8_0_off -= ep->fb_base_reg;
@@ -343,8 +345,10 @@ static int __devinit e3d_pci_register(struct pci_dev *pdev,
 	ep->fb_size = info->fix.line_length * ep->height;
 
 	ep->fb_base = ioremap(ep->fb_base_phys, ep->fb_size);
-	if (!ep->fb_base)
+	if (!ep->fb_base) {
+		err = -ENOMEM;
 		goto err_release_pci0;
+	}
 
 	err = e3d_set_fbinfo(ep);
 	if (err)
-- 
1.7.11.4

