Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab2FOUWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:22:53 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:43734 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757373Ab2FOUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:22:52 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH] snd-opti9xx: fixes for MED3931 card (opti931)
Date: Fri, 15 Jun 2012 20:55:54 +0200
User-Agent: KMail/1.9.10
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201206152055.58181.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MED3931 card did not work (failed with "OPTI chip not found") because
snd-opti9xx gets mc_indir_index from pnp by adding 2 to the pnp-reported port.
It probably works for some cards but not for this one. Datasheet says that
the port is always at 0xe?e so just force the lowest nibble to be 0xe.

Also this card powers up with (ugly) 3D sound enabled. As there's no mixer
control for this, just disable it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -135,7 +135,6 @@ struct snd_opti9xx {
 	unsigned long mc_base_size;
 #ifdef OPTi93X
 	unsigned long mc_indir_index;
-	unsigned long mc_indir_size;
 	struct resource *res_mc_indir;
 	struct snd_wss *codec;
 #endif	/* OPTi93X */
@@ -245,10 +244,8 @@ static int __devinit snd_opti9xx_init(struct snd_opti9xx *chip,
 	case OPTi9XX_HW_82C931:
 	case OPTi9XX_HW_82C933:
 		chip->mc_base = (hardware == OPTi9XX_HW_82C930) ? 0xf8f : 0xf8d;
-		if (!chip->mc_indir_index) {
+		if (!chip->mc_indir_index)
 			chip->mc_indir_index = 0xe0e;
-			chip->mc_indir_size = 2;
-		}
 		chip->password = 0xe4;
 		chip->pwd_reg = 0;
 		break;
@@ -403,7 +400,9 @@ static int __devinit snd_opti9xx_configure(struct snd_opti9xx *chip,
 
 #else	/* OPTi93X */
 	case OPTi9XX_HW_82C931:
-	case OPTi9XX_HW_82C933:
+		/* disable 3D sound (set GPIO1 as output, low) */
+		snd_opti9xx_write_mask(chip, OPTi9XX_MC_REG(20), 0x04, 0x0c);
+	case OPTi9XX_HW_82C933: /* FALL THROUGH */
 		/*
 		 * The BTC 1817DW has QS1000 wavetable which is connected
 		 * to the serial digital input of the OPTI931.
@@ -696,8 +695,7 @@ static int __devinit snd_opti9xx_read_check(struct snd_opti9xx *chip)
 		if (value == snd_opti9xx_read(chip, OPTi9XX_MC_REG(1)))
 			return 0;
 #else	/* OPTi93X */
-	chip->res_mc_indir = request_region(chip->mc_indir_index,
-					    chip->mc_indir_size,
+	chip->res_mc_indir = request_region(chip->mc_indir_index, 2,
 					    "OPTi93x MC");
 	if (chip->res_mc_indir == NULL)
 		return -EBUSY;
@@ -770,8 +768,9 @@ static int __devinit snd_card_opti9xx_pnp(struct snd_opti9xx *chip,
 #ifdef OPTi93X
 	port = pnp_port_start(pdev, 0) - 4;
 	fm_port = pnp_port_start(pdev, 1) + 8;
-	chip->mc_indir_index = pnp_port_start(pdev, 3) + 2;
-	chip->mc_indir_size = pnp_port_len(pdev, 3) - 2;
+	/* adjust mc_indir_index - some cards report it at 0xe?d,
+	   other at 0xe?c but it really is always at 0xe?e */
+	chip->mc_indir_index = (pnp_port_start(pdev, 3) & ~0xf) | 0xe;
 #else
 	devmc = pnp_request_card_device(card, pid->devs[2].id, NULL);
 	if (devmc == NULL)

-- 
Ondrej Zary
