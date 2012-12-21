Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2LUBKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:10:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:25108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2LUBKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:10:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,327,1355126400"; 
   d="scan'208";a="237272373"
Subject: [PATCH] ASoC: core: giving WARN when device starting from non-off
 bias with idle_bias_off
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@ti.com, perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1355913397.17896.10.camel@cliu38-desktop-build>
References: <1355913397.17896.10.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Dec 2012 18:17:12 +0800
Message-ID: <1356085032.1839.14.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just found some cases that some codec drivers set the bias to _STANDBY and
set idle_bias_off to 1 during probing.
It will cause unpaired runtime_get_sync/put() issue. Also as Mark suggested,
there is no reason to start from _STANDBY bias with idle_bias_off == 1.

So here giving one warning when detected (dapm.idle_bias_off == 1) and
(dapm.bias_level != SND_SOC_BIAS_OFF) just after driver->probe().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 sound/soc/soc-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9c768bc..d7ec007 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1107,6 +1107,10 @@ static int soc_probe_codec(struct snd_soc_card *card,
 				"ASoC: failed to probe CODEC %d\n", ret);
 			goto err_probe;
 		}
+		WARN(codec->dapm.idle_bias_off &&
+			codec->dapm.bias_level != SND_SOC_BIAS_OFF,
+			"codec %s can not start from non-off bias"
+			" with idle_bias_off==1\n", codec->name);
 	}
 
 	/* If the driver didn't set I/O up try regmap */
-- 
1.7.0.4



