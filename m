Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448Ab1ETAgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:36:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64215 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab1ETAgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=g9/DJ1Qy2a7bRiD0SrVGH1LTL4d7RzhBoxAllVq1IzIuyQJcidYdDiW+Z68uX6a9hc
         K7ioYS8B5qYh3ini3SI/g8pxsO2ZHUxuMx6iKp6V7PguDLISKjLk6s6qlV/0gysEU5y5
         UarYlxcmh+PidL0qAge2j00h23EIt/SAzWdNw=
Subject: [PATCH v2] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 08:36:06 +0800
Message-ID: <1305851766.2244.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of get_voltage callback is NULL, current implementation in
_regulator_get_voltage will return -EINVAL.

Also returns proper error if ret is negative value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: remove unneeded goto.

 drivers/regulator/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9493f61..f11b0ba 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1886,13 +1886,13 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
 		if (sel < 0)
 			return sel;
 		ret = rdev->desc->ops->list_voltage(rdev, sel);
-	}
-	if (rdev->desc->ops->get_voltage)
+	} else if (rdev->desc->ops->get_voltage) {
 		ret = rdev->desc->ops->get_voltage(rdev);
-	else
+	} else {
 		return -EINVAL;
+	}
 
-	return ret - rdev->constraints->uV_offset;
+	return ret < 0 ? ret : ret - rdev->constraints->uV_offset;
 }
 
 /**
-- 
1.7.1



