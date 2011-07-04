Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1GDOMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:12:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35340 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1GDOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:11:51 -0400
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Devin Heitmueller <dheitmueller@hauppauge.com>,
        Sri Devi <Srinivasa.Deevi@conexant.com>,
        Jarod Wilson <jarod@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/media/video/cx231xx/cx231xx-cards.c: add missing kfree
Date: Mon,  4 Jul 2011 16:11:41 +0200
Message-Id: <1309788705-22278-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Clear the cx231xx_devused variable and free dev in the error handling code,
as done in the error handling code nearby.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier x;
@@

kfree(x)

@@
identifier r.x;
expression E1!=0,E2,E3,E4;
statement S;
@@

(
if (<+...x...+>) S
|
if (...) { ... when != kfree(x)
               when != if (...) { ... kfree(x); ... }
               when != x = E3
* return E1;
}
... when != x = E2
if (...) { ... when != x = E4
 kfree(x); ... return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/cx231xx/cx231xx-cards.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 2270381..c46dca9 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -1051,6 +1051,9 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	if (assoc_desc->bFirstInterface != ifnum) {
 		cx231xx_err(DRIVER_NAME ": Not found "
 			    "matching IAD interface\n");
+		cx231xx_devused &= ~(1 << nr);
+		kfree(dev);
+		dev = NULL;
 		return -ENODEV;
 	}
 

