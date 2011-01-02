Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1ABQs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:48:26 -0500
Received: from utm.netup.ru ([193.203.36.250]:57680 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab1ABQsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:48:25 -0500
X-Greylist: delayed 1787 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jan 2011 11:48:25 EST
Message-ID: <4D20A4CA.4020601@netup.ru>
Date: Sun, 02 Jan 2011 16:16:10 +0000
From: Abylay Ospan <aospan@netup.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5 v2] cx23885: Altera FPGA CI interface reworked.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It decreases I2C traffic.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
  drivers/media/video/cx23885/cx23885-dvb.c |   18 +++++++++---------
  1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c 
b/drivers/media/video/cx23885/cx23885-dvb.c
index 6c144f7..53c2b6d 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -620,29 +620,29 @@ int netup_altera_fpga_rw(void *device, int flag, 
int data, int read)
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

