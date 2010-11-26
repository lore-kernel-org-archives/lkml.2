Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0KZGtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 01:49:22 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53159 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0KZGtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 01:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LE84nDzYdanFWrbrcMzs9sPzl4mZVp1AITqqZMhNNKwiUSaMJLUP6RtfbVxkMP8E/n
         21YA5CKy/h+QMj5ZGnkZV5EiKPQSgibwNsOrAi9KAb5YaNXMH5Aiwbac2OSkdrR5N3sG
         osMxLNDV0Ytr3qoZLEYpS/Vpcftvs78wmfdxg=
Subject: [PATCH 4/4] ASoC: Fix resource leask in smdk_spdif.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Seungwhan Youn <sw.youn@samsung.com>, Jassi Brar <jassi.brar@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290754245.25125.1.camel@mola>
References: <1290754245.25125.1.camel@mola>
Content-Type: text/plain
Date: Fri, 26 Nov 2010 14:54:42 +0800
Message-Id: <1290754482.25125.9.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly free allocated resources in smdk_init() error path.
Add missing platform_device_unregister() in smdk_exit().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/smdk_spdif.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/soc/samsung/smdk_spdif.c b/sound/soc/samsung/smdk_spdif.c
index fe43eaf..82d17dc 100644
--- a/sound/soc/samsung/smdk_spdif.c
+++ b/sound/soc/samsung/smdk_spdif.c
@@ -183,7 +183,7 @@ static int __init smdk_init(void)
 
 	ret = platform_device_add(smdk_snd_spdif_dit_device);
 	if (ret)
-		goto err2;
+		goto err1;
 
 	smdk_snd_spdif_device = platform_device_alloc("soc-audio", -1);
 	if (!smdk_snd_spdif_device) {
@@ -195,17 +195,21 @@ static int __init smdk_init(void)
 
 	ret = platform_device_add(smdk_snd_spdif_device);
 	if (ret)
-		goto err1;
+		goto err3;
 
 	/* Set audio clock hierarchy manually */
 	ret = set_audio_clock_heirachy(smdk_snd_spdif_device);
 	if (ret)
-		goto err1;
+		goto err4;
 
 	return 0;
-err1:
+err4:
+	platform_device_del(smdk_snd_spdif_device);
+err3:
 	platform_device_put(smdk_snd_spdif_device);
 err2:
+	platform_device_del(smdk_snd_spdif_dit_device);
+err1:
 	platform_device_put(smdk_snd_spdif_dit_device);
 	return ret;
 }
@@ -213,6 +217,7 @@ err2:
 static void __exit smdk_exit(void)
 {
 	platform_device_unregister(smdk_snd_spdif_device);
+	platform_device_unregister(smdk_snd_spdif_dit_device);
 }
 
 module_init(smdk_init);
-- 
1.7.2



