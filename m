Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab1J1X7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:59:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42345 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1J1X66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:58:58 -0400
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/media/video/davinci/vpbe_display.c: eliminate a null pointer dereference
Date: Sat, 29 Oct 2011 01:58:17 +0200
Message-Id: <1319846297-2985-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the original code, probe_out could be reached when res was null and then
when the irq had not yet been requested.  In those cases, the call to
free_irq is not needed, so move probe_out down and introduce a new label
for the case where calling free_irq is useful.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

if (E == NULL)
{
  ... when != if (E == NULL || ...) S1 else S2
      when != E = E1
*E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/davinci/vpbe_display.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index 8588a86..d98da4b 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -1746,15 +1746,16 @@ static __devinit int vpbe_display_probe(struct platform_device *pdev)
 	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
 		if (register_device(disp_dev->dev[i], disp_dev, pdev)) {
 			err = -ENODEV;
-			goto probe_out;
+			goto probe_out_irq;
 		}
 	}
 
 	printk(KERN_DEBUG "Successfully completed the probing of vpbe v4l2 device\n");
 	return 0;
 
-probe_out:
+probe_out_irq:
 	free_irq(res->start, disp_dev);
+probe_out:
 	for (k = 0; k < VPBE_DISPLAY_MAX_DEVICES; k++) {
 		/* Get the pointer to the layer object */
 		vpbe_display_layer = disp_dev->dev[k];
