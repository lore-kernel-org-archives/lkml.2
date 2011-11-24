Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1KXNOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:14:21 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:35036
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719Ab1KXNOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:14:20 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 5/8] ASoC: Move SigmaDSP firmware loader to ASoC
Date: Thu, 24 Nov 2011 14:15:16 +0100
Message-ID: <1322140516-16183-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322138908-32127-5-git-send-email-lars@metafoo.de>
References: <1322138908-32127-5-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been pointed out previously, that the firmware subsystem is not the right
place for the SigmaDSP firmware loader. Furthermore the SigmaDSP is currently
only used in audio products and we are aiming for better integration into the
ASoC framework in the future, with support for ALSA controls for firmware
parameters and support dynamic power management as well. So the natural choice
for the SigmaDSP firmware loader is the ASoC subsystem.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
	* Fix last-minute renames
	* Generate patch with `git format-patch -M ...`
---
 MAINTAINERS                                        |    1 +
 drivers/firmware/Kconfig                           |   12 ------------
 drivers/firmware/Makefile                          |    1 -
 sound/soc/codecs/Kconfig                           |    6 +++++-
 sound/soc/codecs/Makefile                          |    2 ++
 sound/soc/codecs/adau1701.c                        |    2 +-
 .../sigma.c => sound/soc/codecs/sigmadsp.c         |    3 ++-
 .../linux/sigma.h => sound/soc/codecs/sigmadsp.h   |    0
 8 files changed, 11 insertions(+), 16 deletions(-)
 rename drivers/firmware/sigma.c => sound/soc/codecs/sigmadsp.c (99%)
 rename include/linux/sigma.h => sound/soc/codecs/sigmadsp.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd7e441..6a93a93 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -542,6 +542,7 @@ F:	sound/soc/codecs/adau*
 F:	sound/soc/codecs/adav*
 F:	sound/soc/codecs/ad1*
 F:	sound/soc/codecs/ssm*
+F:	sound/soc/codecs/sigmadsp.*
 
 ANALOG DEVICES INC ASOC DRIVERS
 L:	uclinux-dist-devel@blackfin.uclinux.org
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index efba163..9b00072 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -145,18 +145,6 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
-config SIGMA
-	tristate "SigmaStudio firmware loader"
-	depends on I2C
-	select CRC32
-	default n
-	help
-	  Enable helper functions for working with Analog Devices SigmaDSP
-	  parts and binary firmwares produced by Analog Devices SigmaStudio.
-
-	  If unsure, say N here.  Drivers that need these helpers will select
-	  this option automatically.
-
 source "drivers/firmware/google/Kconfig"
 
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 47338c9..5a7e273 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -12,6 +12,5 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
-obj-$(CONFIG_SIGMA)		+= sigma.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 686f45a..593174c 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -141,7 +141,7 @@ config SND_SOC_AD73311
 	tristate
 
 config SND_SOC_ADAU1701
-	select SIGMA
+	select SND_SOC_SIGMADSP
 	tristate
 
 config SND_SOC_ADAU1373
@@ -234,6 +234,10 @@ config SND_SOC_RT5631
 config SND_SOC_SGTL5000
 	tristate
 
+config SND_SOC_SIGMADSP
+	tristate
+	select CRC32
+
 config SND_SOC_SN95031
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 62b01e4..fa15006 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -33,6 +33,7 @@ snd-soc-rt5631-objs := rt5631.o
 snd-soc-sgtl5000-objs := sgtl5000.o
 snd-soc-alc5623-objs := alc5623.o
 snd-soc-alc5632-objs := alc5632.o
+snd-soc-sigmadsp-objs := sigmadsp.o
 snd-soc-sn95031-objs := sn95031.o
 snd-soc-spdif-objs := spdif_transciever.o
 snd-soc-ssm2602-objs := ssm2602.o
@@ -134,6 +135,7 @@ obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
 obj-$(CONFIG_SND_SOC_RT5631)	+= snd-soc-rt5631.o
 obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
+obj-$(CONFIG_SND_SOC_SIGMADSP)	+= snd-soc-sigmadsp.o
 obj-$(CONFIG_SND_SOC_SN95031)	+=snd-soc-sn95031.o
 obj-$(CONFIG_SND_SOC_SPDIF)	+= snd-soc-spdif.o
 obj-$(CONFIG_SND_SOC_SSM2602)	+= snd-soc-ssm2602.o
diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index 8b7e1c5..6a6af56 100644
--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -12,13 +12,13 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
-#include <linux/sigma.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 
+#include "sigmadsp.h"
 #include "adau1701.h"
 
 #define ADAU1701_DSPCTRL	0x1c
diff --git a/drivers/firmware/sigma.c b/sound/soc/codecs/sigmadsp.c
similarity index 99%
rename from drivers/firmware/sigma.c
rename to sound/soc/codecs/sigmadsp.c
index 749932c..01b69f4 100644
--- a/drivers/firmware/sigma.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -12,7 +12,8 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
-#include <linux/sigma.h>
+
+#include "sigmadsp.h"
 
 static size_t sigma_action_size(struct sigma_action *sa)
 {
diff --git a/include/linux/sigma.h b/sound/soc/codecs/sigmadsp.h
similarity index 100%
rename from include/linux/sigma.h
rename to sound/soc/codecs/sigmadsp.h
-- 
1.7.7.1


