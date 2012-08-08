Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2HHV2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:28:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60365 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2HHV2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:28:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Bryan Wu <bryan.wu@canonical.com>,
        Magnus Damm <damm@opensource.se>
Subject: [PATCH 10/10] leds: renesas: fix error handling
Date: Wed,  8 Aug 2012 23:27:58 +0200
Message-Id: <1344461278-28245-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344461278-28245-1-git-send-email-arnd@arndb.de>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hvY4z4/xOwgaWQ46rzB4M5c4tk704IPNMqqJ68+eJgh
 +qtdefototO85SwJJeZZfZcwRSgIvySgOQC7o4JYaJKsZwPQ3t
 TcxEX4KWq3c/sYl9dcvHuvjTI7Rfh2COLlmJtxzUuHET96yErV
 ghT0N2rv+V6q6wvRXhmziuBBhWfbL1PoOBoHvdSjwKka74lcW8
 8wLFjgeI2lLhX9LO+TbQlXoQCbEAr3RHiweVo2uB4qIcvlkfKx
 P3eDM7L560+XjiC2L8w9zpjC7p+w9jzF589mEA/RlECewKf5+q
 M011trnYOgUkOnSmTOJw9lPyAT7kPFw8MottF6kmnGDDSXAezi
 qdTykJnMXMn4PZHXcmRw7w36Bo4HM9/Zca/KPt9nSVwzBs6eIt
 vIb16MvYjpYtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bfe4c041 "leds: convert Renesas TPU LED driver to devm_kzalloc() and
cleanup error exit path" introduced a possible case in which r_tpu_probe
calls iounmap on a wild pointer. This changes the one case that was
missed in the same way as the other error paths.

Without this patch, building kota2_defconfig results in:

drivers/leds/leds-renesas-tpu.c: In function 'r_tpu_probe':
drivers/leds/leds-renesas-tpu.c:246:6: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]
drivers/leds/leds-renesas-tpu.c:308:17: warning: 'p' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Magnus Damm <damm@opensource.se>

--- a/drivers/leds/leds-renesas-tpu.c
+++ b/drivers/leds/leds-renesas-tpu.c
@@ -247,7 +247,7 @@ static int __devinit r_tpu_probe(struct platform_device *pdev)

        if (!cfg) {
                dev_err(&pdev->dev, "missing platform data\n");
-               goto err0;
+               return -ENODEV;
        }

        p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
---
 drivers/leds/leds-renesas-tpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-renesas-tpu.c b/drivers/leds/leds-renesas-tpu.c
index 9ee12c2..771ea06 100644
--- a/drivers/leds/leds-renesas-tpu.c
+++ b/drivers/leds/leds-renesas-tpu.c
@@ -247,7 +247,7 @@ static int __devinit r_tpu_probe(struct platform_device *pdev)
 
 	if (!cfg) {
 		dev_err(&pdev->dev, "missing platform data\n");
-		goto err0;
+		return -ENODEV;
 	}
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
-- 
1.7.10

