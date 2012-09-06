Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab2IEP5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:57:07 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:41963 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab2IEP5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:57:05 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2012 11:57:05 EDT
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] Don't clobber access methods when !regmap
Date: Thu,  6 Sep 2012 16:45:32 +0300
Message-Id: <1346939132-20187-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A snd-soc driver that doesn't support regmap blow up horribly
when you assume that regmap is available. Fix it by marking
the driver as not supporting regmap & not clobbering the codec
access methods.

This is immediately noticeable on the beagleboard where we crash,
since we might have REGMAP enabled, but it doesn't mean that the
omap driver uses it.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

---
 sound/soc/soc-io.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index 29183ef..4e5b4ae 100644
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -117,9 +117,6 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 	int ret;
 
 	memset(&config, 0, sizeof(config));
-	codec->write = hw_write;
-	codec->read = hw_read;
-	codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
 
 	config.reg_bits = addr_bits;
 	config.val_bits = data_bits;
@@ -151,7 +148,9 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 			 * multiples */
 			if (ret > 0)
 				codec->val_bytes = ret;
-		}
+		} else
+			codec->using_regmap = false;
+
 		break;
 
 	default:
@@ -161,6 +160,13 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 	if (IS_ERR(codec->control_data))
 		return PTR_ERR(codec->control_data);
 
+	/* only when using regmap; don't modify unconditionally */
+	if (codec->using_regmap) {
+		codec->write = hw_write;
+		codec->read = hw_read;
+		codec->bulk_write_raw = snd_soc_hw_bulk_write_raw;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
-- 
1.7.12

