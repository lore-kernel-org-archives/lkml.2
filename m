Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab0GWF4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:56:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40683 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab0GWFyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LIsFuNRluVAnUC8gZePWrmIXsII3IgHmn8aWi7WjCiFTyjx3dM7DnyzyWhda4rUEOF
         rRQVdd0DaiMpTVOBao4AEtg4IYr6eoWLn4ttcM/dvEpR+O6JB5Hy/FmPy8PHIOCnCbUt
         Kwr1KFU3FDc42HKMAlMGuWcJ78sLFUpSiJhD8=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 03/12] da7210: fix a memory leak if failed to initialise da7210 audio codec
Date: Fri, 23 Jul 2010 05:53:45 +0000
Message-Id: <1279864434-8010-4-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da7210 should be kfreed if da7210_init() return error.
This patch also fixes the error handing in the case of snd_soc_register_dai()
fail by adding snd_soc_unregister_codec() in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/da7210.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 75af2d6..3b9a6cc 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -488,7 +488,7 @@ static int da7210_init(struct da7210_priv *da7210)
 	ret = snd_soc_register_dai(&da7210_dai);
 	if (ret) {
 		dev_err(codec->dev, "Failed to register DAI: %d\n", ret);
-		goto init_err;
+		goto codec_err;
 	}
 
 	/* FIXME
@@ -574,6 +574,8 @@ static int da7210_init(struct da7210_priv *da7210)
 
 	return ret;
 
+codec_err:
+	snd_soc_unregister_codec(codec);
 init_err:
 	kfree(codec->reg_cache);
 	codec->reg_cache = NULL;
@@ -601,8 +603,10 @@ static int __devinit da7210_i2c_probe(struct i2c_client *i2c,
 	codec->control_data = i2c;
 
 	ret = da7210_init(da7210);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("Failed to initialise da7210 audio codec\n");
+		kfree(da7210);
+	}
 
 	return ret;
 }
-- 
1.7.0.4

