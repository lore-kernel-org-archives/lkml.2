Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943Ab0JVIgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:36:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55343 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0JVIgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NT5eJ2atJ6cwETSjQ2SDG6xVaYbGQUEcMpTfceu58Txy7PAQjzp03hSjtpSDBACBQl
         Rl1+D4BMrsBG1MUWbCNvjH7IMMY03UnJYzHjwERMg6KEtgBAa/wafDivivmXYSpJ0N2o
         NAaA9Sgi+X3825lS8MiARYPtVgXjwJhRBL9Uc=
Subject: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain
Date: Fri, 22 Oct 2010 16:38:22 +0800
Message-Id: <1287736702.2996.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Singular Message is 16 bits:
        DEV_GRP[15:13] MT[12]  RES_ID[11:4]  RES_STATE[3:0]

Current implementation return immedially after sucessfuly write MSB part.
To properly set mode, we need to write the complete message ( MSB and LSB ).

In twl.h, now we have defines for PM Master module register offsets,
use it instead of hard coded 0x15/0x16.

Use "message & 0xff" to ensure we send correct value for LSB.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---

I don't have this hardware handy, I appreciate if someone who has the
hardware can test this patch.

Regards,
Axel

 drivers/regulator/twl-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 7e5892e..a57262a 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -219,12 +219,12 @@ static int twlreg_set_mode(struct regulator_dev *rdev, unsigned mode)
 		return -EACCES;
 
 	status = twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
-			message >> 8, 0x15 /* PB_WORD_MSB */ );
-	if (status >= 0)
+			message >> 8, TWL4030_PM_MASTER_PB_WORD_MSB);
+	if (status < 0)
 		return status;
 
 	return twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
-			message, 0x16 /* PB_WORD_LSB */ );
+			message & 0xff, TWL4030_PM_MASTER_PB_WORD_LSB);
 }
 
 /*----------------------------------------------------------------------*/
-- 
1.7.2



