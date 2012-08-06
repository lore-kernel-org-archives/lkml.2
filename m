Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2HFPoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:44:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43335 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab2HFPod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:44:33 -0400
Message-ID: <1344267859.9376.3.camel@phoenix>
Subject: [PATCH] regulator: core: Fix cast to pointer from integer of
 different size warning
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Aug 2012 23:44:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to address the following warning during compilation time: (Compile on x86_64)

  CC      drivers/regulator/core.o
drivers/regulator/core.c: In function '_regulator_do_set_voltage':
drivers/regulator/core.c:2183:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

This patch adds a temporary variable to avoid double cast.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b28221a..5f22210 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2179,9 +2179,12 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		}
 	}
 
-	if (ret == 0 && best_val >= 0)
+	if (ret == 0 && best_val >= 0) {
+		unsigned long data = best_val;
+
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
-				     (void *)best_val);
+				     (void *)data);
+	}
 
 	trace_regulator_set_voltage_complete(rdev_get_name(rdev), best_val);
 
-- 
1.7.9.5



