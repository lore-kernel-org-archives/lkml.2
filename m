Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab1ERNCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:02:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41892 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab1ERNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vHakygHsKKys8MVEu8X2pvCH1+l38A4fYeka43GgRqLbtVVZTODbHCpXnzzpy2nLkb
         qnEwwSTKTKIK4Gtuc+5c+3Ekgp3ZICZlL8d3/p/6BSWlF4ZNGjeefGBqHYDH6/keJ+b9
         sUOkIvphO885q2meWteIHo3rdn3HEmsYCcZHo=
Subject: [RFC][PATCH] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 21:01:58 +0800
Message-ID: <1305723718.6172.6.camel@phoenix>
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
hi Mark,
I just found in commit 6b8e70 "regulator: Convert WM8400 to get_voltage_sel()",
you added get_voltage_sel callback and remove get_voltage callback.
I suspect you will hit this bug. Can you check it?

Thanks,
Axel

 drivers/regulator/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9493f61..2262474 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1886,13 +1886,15 @@ static int _regulator_get_voltage(struct regulator_dev *rdev)
 		if (sel < 0)
 			return sel;
 		ret = rdev->desc->ops->list_voltage(rdev, sel);
+		goto out;
 	}
 	if (rdev->desc->ops->get_voltage)
 		ret = rdev->desc->ops->get_voltage(rdev);
 	else
 		return -EINVAL;
 
-	return ret - rdev->constraints->uV_offset;
+out:
+	return ret < 0 ? ret : ret - rdev->constraints->uV_offset;
 }
 
 /**
-- 
1.7.1



