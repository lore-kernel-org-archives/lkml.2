Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2JHRgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:36:13 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:30583 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753010Ab2JHRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:36:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+UZ6dAhfwPXhfRFbtOifDO
Subject: [PATCH 1/2] ARM: OMAP: Trivial driver changes to remove include
 plat/cpu.h
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Deepak Saxena <dsaxena@plexity.net>, Chris Ball <cjb@laptop.org>,
        Matt Mackall <mpm@selenic.com>, Venkatraman S <svenkatr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-crypto@vger.kernel.org
Date: Mon, 08 Oct 2012 10:35:57 -0700
Message-ID: <20121008173557.10603.18539.stgit@muffinssi>
In-Reply-To: <20121008173452.10603.53886.stgit@muffinssi>
References: <20121008173452.10603.53886.stgit@muffinssi>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should not use cpu_is_omap or cpu_class_is_omap macros,
they should be private to the platform init code. And we'll be
removing plat/cpu.h and only have a private soc.h for the
arch/arm/*omap* code.

This patch is intended as preparation for the core omap changes
and removes the need to include plat/cpu.h from several drivers.
This is needed for the ARM common zImage support.

These changes are OK to do because:

- omap-rng.c and hsmmc.c don't need plat/cpu.h

- omap-aes.c and omap-sham.c get the proper platform_data
  passed to them so they don't need extra checks in the driver

- omap-dma.c and omap-pcm.c can test the arch locally as
  omap1 and omap2 cannot be compiled together because of
  conflicting compiler flags

Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Venkatraman S <svenkatr@ti.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/char/hw_random/omap-rng.c |    2 --
 drivers/crypto/omap-aes.c         |    6 ------
 drivers/crypto/omap-sham.c        |    8 --------
 drivers/dma/omap-dma.c            |    9 +++++++--
 drivers/mmc/host/omap_hsmmc.c     |    1 -
 sound/soc/omap/omap-pcm.c         |    9 +++++++--
 6 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index a5effd8..45e467d 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -27,8 +27,6 @@
 
 #include <asm/io.h>
 
-#include <plat/cpu.h>
-
 #define RNG_OUT_REG		0x00		/* Output register */
 #define RNG_STAT_REG		0x04		/* Status register
 							[0] = STAT_BUSY */
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 3e61feb..649a146 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -29,7 +29,6 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
 
-#include <plat/cpu.h>
 #include <plat-omap/dma-omap.h>
 
 /* OMAP TRM gives bitfields as start:end, where start is the higher bit
@@ -941,11 +940,6 @@ static int __init omap_aes_mod_init(void)
 {
 	pr_info("loading %s driver\n", "omap-aes");
 
-	if (!cpu_class_is_omap2() || omap_type() != OMAP2_DEVICE_TYPE_SEC) {
-		pr_err("Unsupported cpu\n");
-		return -ENODEV;
-	}
-
 	return  platform_driver_register(&omap_aes_driver);
 }
 
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6d79695..d76fe06 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -37,7 +37,6 @@
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 
-#include <plat/cpu.h>
 #include <plat-omap/dma-omap.h>
 #include <mach/irqs.h>
 
@@ -1289,13 +1288,6 @@ static int __init omap_sham_mod_init(void)
 {
 	pr_info("loading %s driver\n", "omap-sham");
 
-	if (!cpu_class_is_omap2() ||
-		(omap_type() != OMAP2_DEVICE_TYPE_SEC &&
-			omap_type() != OMAP2_DEVICE_TYPE_EMU)) {
-		pr_err("Unsupported cpu\n");
-		return -ENODEV;
-	}
-
 	return platform_driver_register(&omap_sham_driver);
 }
 
diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 0b4fa50..56d9253 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -19,9 +19,14 @@
 
 #include "virt-dma.h"
 
-#include <plat/cpu.h>
 #include <plat-omap/dma-omap.h>
 
+#ifdef CONFIG_ARCH_OMAP2PLUS
+#define dma_omap2plus()	1
+#else
+#define dma_omap2plus()	0
+#endif
+
 struct omap_dmadev {
 	struct dma_device ddev;
 	spinlock_t lock;
@@ -438,7 +443,7 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
 		omap_disable_dma_irq(c->dma_ch, OMAP_DMA_BLOCK_IRQ);
 	}
 
-	if (!cpu_class_is_omap1()) {
+	if (dma_omap2plus()) {
 		omap_set_dma_src_burst_mode(c->dma_ch, OMAP_DMA_DATA_BURST_16);
 		omap_set_dma_dest_burst_mode(c->dma_ch, OMAP_DMA_DATA_BURST_16);
 	}
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 85b164e..24df035 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -40,7 +40,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/mmc-omap.h>
 #include <mach/hardware.h>
-#include <plat/cpu.h>
 
 /* OMAP HSMMC Host Controller Registers */
 #define OMAP_HSMMC_SYSSTATUS	0x0014
diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index 340874e..52977aa 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -32,9 +32,14 @@
 #include <sound/dmaengine_pcm.h>
 #include <sound/soc.h>
 
-#include <plat/cpu.h>
 #include "omap-pcm.h"
 
+#ifdef CONFIG_ARCH_OMAP1
+#define pcm_omap1510()	cpu_is_omap1510()
+#else
+#define pcm_omap1510()	0
+#endif
+
 static const struct snd_pcm_hardware omap_pcm_hardware = {
 	.info			= SNDRV_PCM_INFO_MMAP |
 				  SNDRV_PCM_INFO_MMAP_VALID |
@@ -159,7 +164,7 @@ static snd_pcm_uframes_t omap_pcm_pointer(struct snd_pcm_substream *substream)
 {
 	snd_pcm_uframes_t offset;
 
-	if (cpu_is_omap1510())
+	if (pcm_omap1510())
 		offset = snd_dmaengine_pcm_pointer_no_residue(substream);
 	else
 		offset = snd_dmaengine_pcm_pointer(substream);

