Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0GWFzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:55:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57042 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0GWFyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=poVQfhHmPJxC8qnVs4Q85QlD5XtjD2D1hTAPYGJVpSGXGZTVU5DjsyB66vNoDTo4Rn
         fUzM0T9ZZZIaSuR4KMUY9R2xl5y3GqVab1T3euZjXkhW/Qm0TYvKhE+jNZwJuzDA6eNG
         +gHUoFAoZNZ9k6RttuzZOjYDeR9Qi7t5Zjgzg=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 07/12] wm8940: fix a memory leak if wm8940_register return error
Date: Fri, 23 Jul 2010 05:53:49 +0000
Message-Id: <1279864434-8010-8-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for wm8940_register return value,
and does kfree(wm8940) if wm8940_register() fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8940.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index e3c4bbf..f0c1113 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -845,6 +845,7 @@ static void wm8940_unregister(struct wm8940_priv *wm8940)
 static int wm8940_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
+	int ret;
 	struct wm8940_priv *wm8940;
 	struct snd_soc_codec *codec;
 
@@ -858,7 +859,11 @@ static int wm8940_i2c_probe(struct i2c_client *i2c,
 	codec->control_data = i2c;
 	codec->dev = &i2c->dev;
 
-	return wm8940_register(wm8940, SND_SOC_I2C);
+	ret = wm8940_register(wm8940, SND_SOC_I2C);
+	if (ret < 0)
+		kfree(wm8940);
+
+	return ret;
 }
 
 static int __devexit wm8940_i2c_remove(struct i2c_client *client)
-- 
1.7.0.4

