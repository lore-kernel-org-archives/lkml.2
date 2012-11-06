Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2KFIcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:32:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:42524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab2KFIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:32:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="213978348"
Subject: [PATCH 6/7] mx3fb: Fix the usage of wait_for_completion_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: FlorianSchandinat@gmx.de
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1352223097.15558.1599.camel@cliu38-desktop-build>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
	 <1352222480.15558.1587.camel@cliu38-desktop-build>
	 <1352222555.15558.1589.camel@cliu38-desktop-build>
	 <1352222894.15558.1595.camel@cliu38-desktop-build>
	 <1352223097.15558.1599.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 01:33:14 +0800
Message-ID: <1352223194.15558.1601.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The return value of wait_for_completion_timeout() is always
>= 0 with unsigned int type.

So the condition "ret < 0" or "ret >= 0" is pointless.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/video/mx3fb.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index ce1d452..88bf368 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -1110,12 +1110,11 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 	enable_irq(mx3_fbi->idmac_channel->eof_irq);
 
 	ret = wait_for_completion_timeout(&mx3_fbi->flip_cmpl, HZ / 10);
-	if (ret <= 0) {
+	if (ret == 0) {
 		mutex_unlock(&mx3_fbi->mutex);
-		dev_info(fbi->device, "Panning failed due to %s\n", ret < 0 ?
-			 "user interrupt" : "timeout");
+		dev_info(fbi->device, "Panning failed due to timeout\n");
 		disable_irq(mx3_fbi->idmac_channel->eof_irq);
-		return ret ? : -ETIMEDOUT;
+		return -ETIMEDOUT;
 	}
 
 	mx3_fbi->cur_ipu_buf = !mx3_fbi->cur_ipu_buf;
-- 
1.7.0.4



