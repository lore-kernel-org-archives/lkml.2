Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1AAJbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 04:31:38 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61142 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1AAJbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 04:31:37 -0500
Message-ID: <4d1ef477.017b0e0a.28f5.0d41@mx.google.com>
From: Abylay Ospan <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 08/18] cx23885: Altera FPGA CI interface reworked.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It decreases I2C traffic.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/cx23885-dvb.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 6c144f7..53c2b6d 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -620,29 +620,29 @@ int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)device;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1);
-	int mem = 0;
+	uint32_t mem = 0;
 
-	cx_set(MC417_RWD, ALT_RD | ALT_WR | ALT_CS);
+	mem = cx_read(MC417_RWD);
 	if (read)
 		cx_set(MC417_OEN, ALT_DATA);
 	else {
 		cx_clear(MC417_OEN, ALT_DATA);/* D0-D7 out */
-		mem = cx_read(MC417_RWD);
 		mem &= ~ALT_DATA;
 		mem |= (data & ALT_DATA);
-		cx_write(MC417_RWD, mem);
 	}
 
 	if (flag)
-		cx_set(MC417_RWD, ALT_AD_RG);/* ADDR */
+		mem |= ALT_AD_RG;
 	else
-		cx_clear(MC417_RWD, ALT_AD_RG);/* VAL */
+		mem &= ~ALT_AD_RG;
 
-	cx_clear(MC417_RWD, ALT_CS);/* ~CS */
+	mem &= ~ALT_CS;
 	if (read)
-		cx_clear(MC417_RWD, ALT_RD);
+		mem = (mem & ~ALT_RD) | ALT_WR;
 	else
-		cx_clear(MC417_RWD, ALT_WR);
+		mem = (mem & ~ALT_WR) | ALT_RD;
+
+	cx_write(MC417_RWD, mem);  /* start RW cycle */
 
 	for (;;) {
 		mem = cx_read(MC417_RWD);
-- 
1.7.1

