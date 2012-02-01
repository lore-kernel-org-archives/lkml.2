Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2BAVbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:31:15 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43356 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932611Ab2BAVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:15 -0500
X-Sasl-enc: HuNpAbhgluzfWSHAo9TAKQEgeHErc+TW7CLFojVA4CuW 1328131154
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.130551019@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [14/89] ASoC: Disable register synchronisation for low frequency WM8996 SYSCLK
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit fed22007113cb857e917913ce016d9b539dc3a80 upstream.

With a low frequency SYSCLK and a fast I2C clock register synchronisation
may occasionally take too long to take effect, causing I/O issues. Disable
synchronisation in order to avoid any issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8996.c |    4 ++++
 sound/soc/codecs/wm8996.h |    4 ++++
 2 files changed, 8 insertions(+)

--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -1932,6 +1932,7 @@ static int wm8996_set_sysclk(struct snd_
 	struct wm8996_priv *wm8996 = snd_soc_codec_get_drvdata(codec);
 	int lfclk = 0;
 	int ratediv = 0;
+	int sync = WM8996_REG_SYNC;
 	int src;
 	int old;
 
@@ -1976,6 +1977,7 @@ static int wm8996_set_sysclk(struct snd_
 	case 32000:
 	case 32768:
 		lfclk = WM8996_LFCLK_ENA;
+		sync = 0;
 		break;
 	default:
 		dev_warn(codec->dev, "Unsupported clock rate %dHz\n",
@@ -1989,6 +1991,8 @@ static int wm8996_set_sysclk(struct snd_
 			    WM8996_SYSCLK_SRC_MASK | WM8996_SYSCLK_DIV_MASK,
 			    src << WM8996_SYSCLK_SRC_SHIFT | ratediv);
 	snd_soc_update_bits(codec, WM8996_CLOCKING_1, WM8996_LFCLK_ENA, lfclk);
+	snd_soc_update_bits(codec, WM8996_CONTROL_INTERFACE_1,
+			    WM8996_REG_SYNC, sync);
 	snd_soc_update_bits(codec, WM8996_AIF_CLOCKING_1,
 			    WM8996_SYSCLK_ENA, old);
 
--- a/sound/soc/codecs/wm8996.h
+++ b/sound/soc/codecs/wm8996.h
@@ -1567,6 +1567,10 @@ int wm8996_detect(struct snd_soc_codec *
 /*
  * R257 (0x101) - Control Interface (1)
  */
+#define WM8996_REG_SYNC                         0x8000  /* REG_SYNC */
+#define WM8996_REG_SYNC_MASK                    0x8000  /* REG_SYNC */
+#define WM8996_REG_SYNC_SHIFT                       15  /* REG_SYNC */
+#define WM8996_REG_SYNC_WIDTH                        1  /* REG_SYNC */
 #define WM8996_AUTO_INC                         0x0004  /* AUTO_INC */
 #define WM8996_AUTO_INC_MASK                    0x0004  /* AUTO_INC */
 #define WM8996_AUTO_INC_SHIFT                        2  /* AUTO_INC */


