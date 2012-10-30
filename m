Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2J3PJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:09:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65215 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2J3PJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:09:51 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@infradead.org
Cc: crope@iki.fi, remi.schwartz@gmail.com, kyle@kyle.strickland.name,
        pinusdtv@hotmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] drivers/media/pci/saa7134/saa7134-dvb.c: Test if videobuf_dvb_get_frontend return NULL
Date: Tue, 30 Oct 2012 16:09:41 +0100
Message-Id: <1351609781-16148-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on commit: e66131cee501ee720b7b58a4b87073b8fbaaaba6

Not testing videobuf_dvb_get_frontend output may cause OOPS if it return
NULL. This patch fixes this issue.

The semantic patch that found this issue is(http://coccinelle.lip6.fr/):
// <smpl>
@@
identifier i,a,b;
statement S, S2;
@@
i = videobuf_dvb_get_frontend(...);
... when != if (!i) S
* if (i->a.b)
S2
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/pci/saa7134/saa7134-dvb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index b209de4..27915e5 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -607,6 +607,9 @@ static int configure_tda827x_fe(struct saa7134_dev *dev,
 	/* Get the first frontend */
 	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
 
+	if (!fe0)
+		return -EINVAL;
+
 	fe0->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
 	if (fe0->dvb.frontend) {
 		if (cdec_conf->i2c_gate)
-- 
1.7.11.7

