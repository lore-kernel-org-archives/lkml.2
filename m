Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2IYHPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:15:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2IYHPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:15:18 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] pinctrl: Fix potential memory leak in pinctrl_register_one_pin()
Date: Tue, 25 Sep 2012 12:41:40 +0530
Message-Id: <1348557100-16972-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'pindesc' was not freed when returning from an error induced
exit path.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index dc5c126..0f1ec9e 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -230,8 +230,10 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 		pindesc->name = name;
 	} else {
 		pindesc->name = kasprintf(GFP_KERNEL, "PIN%u", number);
-		if (pindesc->name == NULL)
+		if (pindesc->name == NULL) {
+			kfree(pindesc);
 			return -ENOMEM;
+		}
 		pindesc->dynamic_name = true;
 	}
 
-- 
1.7.4.1

