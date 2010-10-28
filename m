Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0J1W0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:26:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55906 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445Ab0J1W0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RsQTfCbfl8L5rK79x6R9ZznBQZku6o7iPIWt6CBmCqL700SV8YNcgMr4Jc2vablTjB
         MXixwFX0Y7emUAdu5AHaICX4/7C2D8/GSNxonWuvAyZGI7DZmeEUqgHai9XSz17eQElV
         IZjvkPk/a6IKuKnyfwF0/fwF+7P/BdeOeZ11k=
From: Grazvydas Ignotas <notasas@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [GIT PULL] battery-2.6.git (a last minute fix)
Date: Fri, 29 Oct 2010 01:26:11 +0300
Message-Id: <1288304771-27081-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20101028090953.GA28283@oksana.dev.rtsoft.ru>
References: <20101028090953.GA28283@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/power/twl4030_charger.c: In function 'twl4030_bci_probe':
> drivers/power/twl4030_charger.c:477: warning: overflow in implicit constant conversion
> drivers/power/twl4030_charger.c:485: warning: overflow in implicit constant conversion
> make[2]: *** [drivers/power/twl4030_charger.o] Error 1

Here is a fix for these warnings (only show up for 64bit so I missed
them, my fault again).

------------ cut -----------
From: Grazvydas Ignotas <notasas@gmail.com>
Date: Fri, 29 Oct 2010 00:51:32 +0300
Subject: [PATCH] power_supply: twl4030_charger: fix compilation warnings

Registers are 8bit, so use proper type, fixing following warnings:
twl4030_charger.c:477: warning: overflow in implicit constant conversion
twl4030_charger.c:485: warning: overflow in implicit constant conversion

These only show up when building for 64bit target, so I missed them
while building only for 32bit ARM.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/twl4030_charger.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index ff1f423..07236ae 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -414,7 +414,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 {
 	struct twl4030_bci *bci;
 	int ret;
-	int reg;
+	u8 reg;
 
 	bci = kzalloc(sizeof(*bci), GFP_KERNEL);
 	if (bci == NULL)
@@ -473,7 +473,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	}
 
 	/* Enable interrupts now. */
-	reg = ~(TWL4030_ICHGLOW | TWL4030_ICHGEOC | TWL4030_TBATOR2 |
+	reg = (u8) ~(TWL4030_ICHGLOW | TWL4030_ICHGEOC | TWL4030_TBATOR2 |
 		TWL4030_TBATOR1 | TWL4030_BATSTS);
 	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, reg,
 			       TWL4030_INTERRUPTS_BCIIMR1A);
@@ -482,7 +482,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 		goto fail_unmask_interrupts;
 	}
 
-	reg = ~(TWL4030_VBATOV | TWL4030_VBUSOV | TWL4030_ACCHGOV);
+	reg = (u8) ~(TWL4030_VBATOV | TWL4030_VBUSOV | TWL4030_ACCHGOV);
 	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, reg,
 			       TWL4030_INTERRUPTS_BCIIMR2A);
 	if (ret < 0)
-- 
1.6.3.3

