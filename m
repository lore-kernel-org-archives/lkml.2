Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2JCMlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:41:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37020 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2JCMlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:41:05 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Antonino Daplas <adaplas@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/video/savage/savagefb_driver.c: fix error return code
Date: Wed,  3 Oct 2012 14:40:43 +0200
Message-Id: <1349268044-32616-1-git-send-email-peter.senna@gmail.com>
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
 drivers/video/savage/savagefb_driver.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/savage/savagefb_driver.c
index 0d0f52c..f4f53b0 100644
--- a/drivers/video/savage/savagefb_driver.c
+++ b/drivers/video/savage/savagefb_driver.c
@@ -2266,8 +2266,10 @@ static int __devinit savagefb_probe(struct pci_dev* dev,
 	lpitch = info->var.xres_virtual*((info->var.bits_per_pixel + 7) >> 3);
 	info->var.yres_virtual = info->fix.smem_len/lpitch;
 
-	if (info->var.yres_virtual < info->var.yres)
+	if (info->var.yres_virtual < info->var.yres) {
+		err = -ENOMEM;
 		goto failed;
+	}
 
 #if defined(CONFIG_FB_SAVAGE_ACCEL)
 	/*

