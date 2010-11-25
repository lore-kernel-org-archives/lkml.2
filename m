Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0KYHFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:05:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50227 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0KYHFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V6fFRm6VTIYlk0a09ruEqM45cSoMLySIDIQtJBBDaw18TGDwxc+/boHkuj0ATcMhXY
         3Lm9MGeqgfeb5STxOf9raSFt/wPFm5AfVSRYg+hnkloOZULYNtXV4lCjZMW1X91XUFuw
         7B2ecBunolkcTHAWE0oGmcnLjjR2Nu7kc4mwA=
Subject: [PATCH 4/8] ASoC: sam9g20_wm8731: fix resource leak in
	at91sam9g20ek_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Sedji Gaouaou <sedji.gaouaou@atmel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:11:03 +0800
Message-Id: <1290669063.30158.14.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error path to properly free allocated resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/atmel/sam9g20_wm8731.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 1c9de19..af3c730 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -240,6 +240,7 @@ static int __init at91sam9g20ek_init(void)
 	if (!at91sam9g20ek_snd_device) {
 		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
 		ret = -ENOMEM;
+		goto err_mclk;
 	}
 
 	platform_set_drvdata(at91sam9g20ek_snd_device,
@@ -248,11 +249,13 @@ static int __init at91sam9g20ek_init(void)
 	ret = platform_device_add(at91sam9g20ek_snd_device);
 	if (ret) {
 		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
-		platform_device_put(at91sam9g20ek_snd_device);
+		goto err_device_add;
 	}
 
 	return ret;
 
+err_device_add:
+	platform_device_put(at91sam9g20ek_snd_device);
 err_mclk:
 	clk_put(mclk);
 	mclk = NULL;
-- 
1.7.2



