Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab0GWFy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:54:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56451 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab0GWFyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xVGT/TcjvEez0IpHDvXJNL0mLF83l4RyB4BPfbEnCBHiND3qwH2gOahDK5OPKKot5B
         8MLqIbqpMs2R5VwKKewDExwSScXbqx8v/uhMoVr/dfENxcEYi8OnENHAXkP7IxcvPYiM
         UNW4MYBT841dHq4SW38l2k7XvH7YuBQojX2Ys=
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Barry Song <21cnbao@gmail.com>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Arthur <linux@wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH v2 11/12] wm8978: fix a memory leak if a wm8978_register fail
Date: Fri, 23 Jul 2010 05:53:53 +0000
Message-Id: <1279864434-8010-12-git-send-email-axel.lin@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
References: <1279864434-8010-1-git-send-email-axel.lin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a memory leak found if wm8978_register() fail.
This patch moves the buffer allocate and release
at the same level to prevent the memory leak.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 sound/soc/codecs/wm8978.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 51d5f43..8a1ad77 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -1076,7 +1076,6 @@ static __devinit int wm8978_register(struct wm8978_priv *wm8978)
 err_codec:
 	snd_soc_unregister_codec(codec);
 err:
-	kfree(wm8978);
 	return ret;
 }
 
@@ -1085,13 +1084,13 @@ static __devexit void wm8978_unregister(struct wm8978_priv *wm8978)
 	wm8978_set_bias_level(&wm8978->codec, SND_SOC_BIAS_OFF);
 	snd_soc_unregister_dai(&wm8978_dai);
 	snd_soc_unregister_codec(&wm8978->codec);
-	kfree(wm8978);
 	wm8978_codec = NULL;
 }
 
 static __devinit int wm8978_i2c_probe(struct i2c_client *i2c,
 				      const struct i2c_device_id *id)
 {
+	int ret;
 	struct wm8978_priv *wm8978;
 	struct snd_soc_codec *codec;
 
@@ -1107,13 +1106,18 @@ static __devinit int wm8978_i2c_probe(struct i2c_client *i2c,
 
 	codec->dev = &i2c->dev;
 
-	return wm8978_register(wm8978);
+	ret = wm8978_register(wm8978);
+	if (ret < 0)
+		kfree(wm8978);
+
+	return ret;
 }
 
 static __devexit int wm8978_i2c_remove(struct i2c_client *client)
 {
 	struct wm8978_priv *wm8978 = i2c_get_clientdata(client);
 	wm8978_unregister(wm8978);
+	kfree(wm8978);
 	return 0;
 }
 
-- 
1.7.0.4

