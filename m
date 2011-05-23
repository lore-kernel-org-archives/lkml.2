Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1EWMKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:10:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35349 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab1EWMKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Wrcsl32TDI5nkWKw5gCQSENzAK5pwAFONyi7n1dQ5dKlrZP+eog6lZq5zAlUx6nE8K
         GyHV7jMJPfKgxWCMniB0uYyZKUifPoCnjZZHANtPusDO8wmu6SBuVIEQ0C5iogTFID4z
         ZMVoOoy67XPqfvSCiOjrgBqU3lqf5g1x9HDaY=
Subject: [PATCH v3] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 20:08:10 +0800
Message-ID: <1306152491.2968.9.camel@phoenix>
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
 drivers/regulator/core.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9493f61..d3e3879 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1886,12 +1886,14 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
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
 
+	if (ret < 0)
+		return ret;
 	return ret - rdev->constraints->uV_offset;
 }
 
-- 
1.7.1



