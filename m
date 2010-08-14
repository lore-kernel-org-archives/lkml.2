Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab0HNNaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:30:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50217 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab0HNNap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:30:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=UPDPLZqCRWE/SIy9u3lszHzWpL24PIZRN5LP1jyxUHy7AUknXwzI8IPgp/6pCUgHwk
         za/Xdh0xpaa8p4rJuZMIrXM6/Yn3D3f7GONsoEHTx4feD2cVdTSYwOqs7q3y9zm3puNy
         wOPMLctDUuAIxPNQ5C2TKVOtwyuVFMmhabSWw=
Subject: [PATCH] regulator: ab3100 - fix the logic to remove already
 registered regulators in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 21:31:01 +0800
Message-ID: <1281792661.2718.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, ab3100_regulators[0].rdev is not unregistered if
the error happen at i > 0.

This patch fixes the resource leak and also improves the readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I think this change is better ( in readability ) than simply change "while (i > 0)" to "while (i >= 0)".

 drivers/regulator/ab3100.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 1179099..b349266 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -634,12 +634,9 @@ static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 				"%s: failed to register regulator %s err %d\n",
 				__func__, ab3100_regulator_desc[i].name,
 				err);
-			i--;
 			/* remove the already registered regulators */
-			while (i > 0) {
+			while (--i >= 0)
 				regulator_unregister(ab3100_regulators[i].rdev);
-				i--;
-			}
 			return err;
 		}
 
-- 
1.7.0.4



