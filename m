Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1HUW7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:59:04 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:53743 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756136Ab1HUW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:58:57 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] [media] bt8xx: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:48 -0700
Message-Id: <430b716fb0227a8a1915aa0da9fb9dc7c1bad736.1313966089.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts some messages that were emitted at
KERN_INFO to KERN_DEBUG.  All of these messages
were guarded by bttv_debug tests.

Add pr_fmt.
Convert printks to pr_<level>
Convert printks without KERN_<level> to appropriate pr_<level>.
Removed embedded prefixes when pr_fmt was added.
Whitespace cleanups when around other conversions.
Macros coded with if statements should be do { if... } while (0)
so the macros can be used in other if tests.
Use ##__VA_ARGS__ for variadic macro as well.
Coalesce format strings.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/bt8xx/bttv-cards.c  |  242 ++++++++++++-------------
 drivers/media/video/bt8xx/bttv-driver.c |  294 ++++++++++++++++---------------
 drivers/media/video/bt8xx/bttv-gpio.c   |    4 +-
 drivers/media/video/bt8xx/bttv-i2c.c    |   56 ++++---
 drivers/media/video/bt8xx/bttv-input.c  |   37 ++--
 drivers/media/video/bt8xx/bttv-risc.c   |   25 ++--
 drivers/media/video/bt8xx/bttv-vbi.c    |    9 +-
 drivers/media/video/bt8xx/bttvp.h       |   18 ++-
 8 files changed, 355 insertions(+), 330 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 5b15f63..5939021 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -25,6 +25,8 @@
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
@@ -2905,19 +2907,17 @@ void __devinit bttv_idcard(struct bttv *btv)
 
 		if (type != -1) {
 			/* found it */
-			printk(KERN_INFO "bttv%d: detected: %s [card=%d], "
-			       "PCI subsystem ID is %04x:%04x\n",
-			       btv->c.nr,cards[type].name,cards[type].cardnr,
-			       btv->cardid & 0xffff,
-			       (btv->cardid >> 16) & 0xffff);
+			pr_info("%d: detected: %s [card=%d], PCI subsystem ID is %04x:%04x\n",
+				btv->c.nr, cards[type].name, cards[type].cardnr,
+				btv->cardid & 0xffff,
+				(btv->cardid >> 16) & 0xffff);
 			btv->c.type = cards[type].cardnr;
 		} else {
 			/* 404 */
-			printk(KERN_INFO "bttv%d: subsystem: %04x:%04x (UNKNOWN)\n",
-			       btv->c.nr, btv->cardid & 0xffff,
-			       (btv->cardid >> 16) & 0xffff);
-			printk(KERN_DEBUG "please mail id, board name and "
-			       "the correct card= insmod option to linux-media@vger.kernel.org\n");
+			pr_info("%d: subsystem: %04x:%04x (UNKNOWN)\n",
+				btv->c.nr, btv->cardid & 0xffff,
+				(btv->cardid >> 16) & 0xffff);
+			pr_debug("please mail id, board name and the correct card= insmod option to linux-media@vger.kernel.org\n");
 		}
 	}
 
@@ -2926,10 +2926,10 @@ void __devinit bttv_idcard(struct bttv *btv)
 		btv->c.type=card[btv->c.nr];
 
 	/* print which card config we are using */
-	printk(KERN_INFO "bttv%d: using: %s [card=%d,%s]\n",btv->c.nr,
-	       bttv_tvcards[btv->c.type].name, btv->c.type,
-	       card[btv->c.nr] < bttv_num_tvcards
-	       ? "insmod option" : "autodetected");
+	pr_info("%d: using: %s [card=%d,%s]\n",
+		btv->c.nr, bttv_tvcards[btv->c.type].name, btv->c.type,
+		card[btv->c.nr] < bttv_num_tvcards
+		? "insmod option" : "autodetected");
 
 	/* overwrite gpio stuff ?? */
 	if (UNSET == audioall && UNSET == audiomux[0])
@@ -2948,12 +2948,13 @@ void __devinit bttv_idcard(struct bttv *btv)
 		}
 	}
 	bttv_tvcards[btv->c.type].gpiomask = (UNSET != gpiomask) ? gpiomask : gpiobits;
-	printk(KERN_INFO "bttv%d: gpio config override: mask=0x%x, mux=",
-	       btv->c.nr,bttv_tvcards[btv->c.type].gpiomask);
+	pr_info("%d: gpio config override: mask=0x%x, mux=",
+		btv->c.nr, bttv_tvcards[btv->c.type].gpiomask);
 	for (i = 0; i < ARRAY_SIZE(bttv_tvcards->gpiomux); i++) {
-		printk("%s0x%x", i ? "," : "", bttv_tvcards[btv->c.type].gpiomux[i]);
+		pr_cont("%s0x%x",
+			i ? "," : "", bttv_tvcards[btv->c.type].gpiomux[i]);
 	}
-	printk("\n");
+	pr_cont("\n");
 }
 
 /*
@@ -2974,8 +2975,8 @@ static void identify_by_eeprom(struct bttv *btv, unsigned char eeprom_data[256])
 
 	if (-1 != type) {
 		btv->c.type = type;
-		printk("bttv%d: detected by eeprom: %s [card=%d]\n",
-		       btv->c.nr, bttv_tvcards[btv->c.type].name, btv->c.type);
+		pr_info("%d: detected by eeprom: %s [card=%d]\n",
+			btv->c.nr, bttv_tvcards[btv->c.type].name, btv->c.type);
 	}
 }
 
@@ -3019,7 +3020,7 @@ static void flyvideo_gpio(struct bttv *btv)
 		tuner_type = 3;  /* Philips SECAM(+PAL) FQ1216ME or FI1216MF */
 		break;
 	default:
-		printk(KERN_INFO "bttv%d: FlyVideo_gpio: unknown tuner type.\n", btv->c.nr);
+		pr_info("%d: FlyVideo_gpio: unknown tuner type\n", btv->c.nr);
 		break;
 	}
 
@@ -3036,13 +3037,13 @@ static void flyvideo_gpio(struct bttv *btv)
 	if (is_capture_only)
 		tuner_type = TUNER_ABSENT; /* No tuner present */
 
-	printk(KERN_INFO "bttv%d: FlyVideo Radio=%s RemoteControl=%s Tuner=%d gpio=0x%06x\n",
-		btv->c.nr, has_radio ? "yes" : "no ",
-		has_remote ? "yes" : "no ", tuner_type, gpio);
-	printk(KERN_INFO "bttv%d: FlyVideo  LR90=%s tda9821/tda9820=%s capture_only=%s\n",
-		btv->c.nr, is_lr90 ? "yes" : "no ",
-		has_tda9820_tda9821 ? "yes" : "no ",
-		is_capture_only ? "yes" : "no ");
+	pr_info("%d: FlyVideo Radio=%s RemoteControl=%s Tuner=%d gpio=0x%06x\n",
+		btv->c.nr, has_radio ? "yes" : "no",
+		has_remote ? "yes" : "no", tuner_type, gpio);
+	pr_info("%d: FlyVideo  LR90=%s tda9821/tda9820=%s capture_only=%s\n",
+		btv->c.nr, is_lr90 ? "yes" : "no",
+		has_tda9820_tda9821 ? "yes" : "no",
+		is_capture_only ? "yes" : "no");
 
 	if (tuner_type != UNSET) /* only set if known tuner autodetected, else let insmod option through */
 		btv->tuner_type = tuner_type;
@@ -3091,12 +3092,11 @@ static void miro_pinnacle_gpio(struct bttv *btv)
 			if (btv->c.type == BTTV_BOARD_PINNACLE)
 				btv->c.type = BTTV_BOARD_PINNACLEPRO;
 		}
-		printk(KERN_INFO
-		       "bttv%d: miro: id=%d tuner=%d radio=%s stereo=%s\n",
-		       btv->c.nr, id+1, btv->tuner_type,
-		       !btv->has_radio ? "no" :
-		       (btv->has_matchbox ? "matchbox" : "fmtuner"),
-		       (-1 == msp) ? "no" : "yes");
+		pr_info("%d: miro: id=%d tuner=%d radio=%s stereo=%s\n",
+			btv->c.nr, id+1, btv->tuner_type,
+			!btv->has_radio ? "no" :
+			(btv->has_matchbox ? "matchbox" : "fmtuner"),
+			(-1 == msp) ? "no" : "yes");
 	} else {
 		/* new cards with microtune tuner */
 		id = 63 - id;
@@ -3138,9 +3138,8 @@ static void miro_pinnacle_gpio(struct bttv *btv)
 		}
 		if (-1 != msp)
 			btv->c.type = BTTV_BOARD_PINNACLEPRO;
-		printk(KERN_INFO
-		       "bttv%d: pinnacle/mt: id=%d info=\"%s\" radio=%s\n",
-		       btv->c.nr, id, info, btv->has_radio ? "yes" : "no");
+		pr_info("%d: pinnacle/mt: id=%d info=\"%s\" radio=%s\n",
+			btv->c.nr, id, info, btv->has_radio ? "yes" : "no");
 		btv->tuner_type = TUNER_MT2032;
 	}
 }
@@ -3202,7 +3201,7 @@ static void gvc1100_muxsel(struct bttv *btv, unsigned int input)
 
 static void init_lmlbt4x(struct bttv *btv)
 {
-	printk(KERN_DEBUG "LMLBT4x init\n");
+	pr_debug("LMLBT4x init\n");
 	btwrite(0x000000, BT848_GPIO_REG_INP);
 	gpio_inout(0xffffff, 0x0006C0);
 	gpio_write(0x000000);
@@ -3246,7 +3245,7 @@ static void bttv_reset_audio(struct bttv *btv)
 		return;
 
 	if (bttv_debug)
-		printk("bttv%d: BT878A ARESET\n",btv->c.nr);
+		pr_debug("%d: BT878A ARESET\n", btv->c.nr);
 	btwrite((1<<7), 0x058);
 	udelay(10);
 	btwrite(     0, 0x058);
@@ -3349,7 +3348,8 @@ void __devinit bttv_init_card2(struct bttv *btv)
 	case BTTV_BOARD_MAGICTVIEW061:
 		if (btv->cardid == 0x3002144f) {
 			btv->has_radio=1;
-			printk("bttv%d: radio detected by subsystem id (CPH05x)\n",btv->c.nr);
+			pr_info("%d: radio detected by subsystem id (CPH05x)\n",
+				btv->c.nr);
 		}
 		break;
 	case BTTV_BOARD_STB2:
@@ -3438,17 +3438,16 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		btv->tuner_type = tuner[btv->c.nr];
 
 	if (btv->tuner_type == TUNER_ABSENT)
-		printk(KERN_INFO "bttv%d: tuner absent\n", btv->c.nr);
-	else if(btv->tuner_type == UNSET)
-		printk(KERN_WARNING "bttv%d: tuner type unset\n", btv->c.nr);
+		pr_info("%d: tuner absent\n", btv->c.nr);
+	else if (btv->tuner_type == UNSET)
+		pr_warn("%d: tuner type unset\n", btv->c.nr);
 	else
-		printk(KERN_INFO "bttv%d: tuner type=%d\n", btv->c.nr,
-		       btv->tuner_type);
+		pr_info("%d: tuner type=%d\n", btv->c.nr, btv->tuner_type);
 
 	if (autoload != UNSET) {
-		printk(KERN_WARNING "bttv%d: the autoload option is obsolete.\n", btv->c.nr);
-		printk(KERN_WARNING "bttv%d: use option msp3400, tda7432 or tvaudio to\n", btv->c.nr);
-		printk(KERN_WARNING "bttv%d: override which audio module should be used.\n", btv->c.nr);
+		pr_warn("%d: the autoload option is obsolete\n", btv->c.nr);
+		pr_warn("%d: use option msp3400, tda7432 or tvaudio to override which audio module should be used\n",
+			btv->c.nr);
 	}
 
 	if (UNSET == btv->tuner_type)
@@ -3541,8 +3540,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 	}
 
 	default:
-		printk(KERN_WARNING "bttv%d: unknown audiodev value!\n",
-			btv->c.nr);
+		pr_warn("%d: unknown audiodev value!\n", btv->c.nr);
 		return;
 	}
 
@@ -3585,8 +3583,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		return;
 
 no_audio:
-	printk(KERN_WARNING "bttv%d: audio absent, no audio device found!\n",
-			btv->c.nr);
+	pr_warn("%d: audio absent, no audio device found!\n", btv->c.nr);
 }
 
 
@@ -3639,19 +3636,19 @@ static void modtec_eeprom(struct bttv *btv)
 {
 	if( strncmp(&(eeprom_data[0x1e]),"Temic 4066 FY5",14) ==0) {
 		btv->tuner_type=TUNER_TEMIC_4066FY5_PAL_I;
-		printk("bttv%d: Modtec: Tuner autodetected by eeprom: %s\n",
-		       btv->c.nr,&eeprom_data[0x1e]);
+		pr_info("%d: Modtec: Tuner autodetected by eeprom: %s\n",
+			btv->c.nr, &eeprom_data[0x1e]);
 	} else if (strncmp(&(eeprom_data[0x1e]),"Alps TSBB5",10) ==0) {
 		btv->tuner_type=TUNER_ALPS_TSBB5_PAL_I;
-		printk("bttv%d: Modtec: Tuner autodetected by eeprom: %s\n",
-		       btv->c.nr,&eeprom_data[0x1e]);
+		pr_info("%d: Modtec: Tuner autodetected by eeprom: %s\n",
+			btv->c.nr, &eeprom_data[0x1e]);
 	} else if (strncmp(&(eeprom_data[0x1e]),"Philips FM1246",14) ==0) {
 		btv->tuner_type=TUNER_PHILIPS_NTSC;
-		printk("bttv%d: Modtec: Tuner autodetected by eeprom: %s\n",
-		       btv->c.nr,&eeprom_data[0x1e]);
+		pr_info("%d: Modtec: Tuner autodetected by eeprom: %s\n",
+			btv->c.nr, &eeprom_data[0x1e]);
 	} else {
-		printk("bttv%d: Modtec: Unknown TunerString: %s\n",
-		       btv->c.nr,&eeprom_data[0x1e]);
+		pr_info("%d: Modtec: Unknown TunerString: %s\n",
+			btv->c.nr, &eeprom_data[0x1e]);
 	}
 }
 
@@ -3663,7 +3660,7 @@ static void __devinit hauppauge_eeprom(struct bttv *btv)
 	btv->tuner_type = tv.tuner_type;
 	btv->has_radio  = tv.has_radio;
 
-	printk("bttv%d: Hauppauge eeprom indicates model#%d\n",
+	pr_info("%d: Hauppauge eeprom indicates model#%d\n",
 		btv->c.nr, tv.model);
 
 	/*
@@ -3671,7 +3668,7 @@ static void __devinit hauppauge_eeprom(struct bttv *btv)
 	 * type based on model #.
 	 */
 	if(tv.model == 64900) {
-		printk("bttv%d: Switching board type from %s to %s\n",
+		pr_info("%d: Switching board type from %s to %s\n",
 			btv->c.nr,
 			bttv_tvcards[btv->c.type].name,
 			bttv_tvcards[BTTV_BOARD_HAUPPAUGE_IMPACTVCB].name);
@@ -3698,8 +3695,7 @@ static int terratec_active_radio_upgrade(struct bttv *btv)
 	freq=88000/62.5;
 	tea5757_write(btv, 5 * freq + 0x358); /* write 0x1ed8 */
 	if (0x1ed8 == tea5757_read(btv)) {
-		printk("bttv%d: Terratec Active Radio Upgrade found.\n",
-		       btv->c.nr);
+		pr_info("%d: Terratec Active Radio Upgrade found\n", btv->c.nr);
 		btv->has_radio    = 1;
 		btv->has_saa6588  = 1;
 		btv->has_matchbox = 1;
@@ -3771,13 +3767,12 @@ static int __devinit pvr_boot(struct bttv *btv)
 
 	rc = request_firmware(&fw_entry, "hcwamc.rbf", &btv->c.pci->dev);
 	if (rc != 0) {
-		printk(KERN_WARNING "bttv%d: no altera firmware [via hotplug]\n",
-		       btv->c.nr);
+		pr_warn("%d: no altera firmware [via hotplug]\n", btv->c.nr);
 		return rc;
 	}
 	rc = pvr_altera_load(btv, fw_entry->data, fw_entry->size);
-	printk(KERN_INFO "bttv%d: altera firmware upload %s\n",
-	       btv->c.nr, (rc < 0) ? "failed" : "ok");
+	pr_info("%d: altera firmware upload %s\n",
+		btv->c.nr, (rc < 0) ? "failed" : "ok");
 	release_firmware(fw_entry);
 	return rc;
 }
@@ -3873,29 +3868,27 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
 			break;
 		default:
 			/* unknown...leave generic, but get serial # */
-			printk(KERN_INFO "bttv%d: "
-			       "osprey eeprom: unknown card type 0x%04x\n",
-			       btv->c.nr, type);
+			pr_info("%d: osprey eeprom: unknown card type 0x%04x\n",
+				btv->c.nr, type);
 			break;
 		}
 		serial = get_unaligned_be32((__be32 *)(ee+6));
 	}
 
-	printk(KERN_INFO "bttv%d: osprey eeprom: card=%d '%s' serial=%u\n",
-	       btv->c.nr, cardid,
-	       cardid>0 ? bttv_tvcards[cardid].name : "Unknown", serial);
+	pr_info("%d: osprey eeprom: card=%d '%s' serial=%u\n",
+		btv->c.nr, cardid,
+		cardid > 0 ? bttv_tvcards[cardid].name : "Unknown", serial);
 
 	if (cardid<0 || btv->c.type == cardid)
 		return;
 
 	/* card type isn't set correctly */
 	if (card[btv->c.nr] < bttv_num_tvcards) {
-		printk(KERN_WARNING "bttv%d: osprey eeprom: "
-		       "Not overriding user specified card type\n", btv->c.nr);
+		pr_warn("%d: osprey eeprom: Not overriding user specified card type\n",
+			btv->c.nr);
 	} else {
-		printk(KERN_INFO "bttv%d: osprey eeprom: "
-		       "Changing card type from %d to %d\n", btv->c.nr,
-		       btv->c.type, cardid);
+		pr_info("%d: osprey eeprom: Changing card type from %d to %d\n",
+			btv->c.nr, btv->c.type, cardid);
 		btv->c.type = cardid;
 	}
 }
@@ -3938,14 +3931,14 @@ static void __devinit avermedia_eeprom(struct bttv *btv)
 		if (tuner_format == 0x09)
 			tuner_type = TUNER_LG_NTSC_NEW_TAPC; /* TAPC-G702P */
 
-	printk(KERN_INFO "bttv%d: Avermedia eeprom[0x%02x%02x]: tuner=",
+	pr_info("%d: Avermedia eeprom[0x%02x%02x]: tuner=",
 		btv->c.nr, eeprom_data[0x41], eeprom_data[0x42]);
 	if (tuner_type) {
 		btv->tuner_type = tuner_type;
-		printk(KERN_CONT "%d", tuner_type);
+		pr_cont("%d", tuner_type);
 	} else
-		printk(KERN_CONT "Unknown type");
-	printk(KERN_CONT " radio:%s remote control:%s\n",
+		pr_cont("Unknown type");
+	pr_cont(" radio:%s remote control:%s\n",
 	       tuner_tv_fm     ? "yes" : "no",
 	       btv->has_remote ? "yes" : "no");
 }
@@ -3993,8 +3986,8 @@ static void __devinit boot_msp34xx(struct bttv *btv, int pin)
 	if (bttv_gpio)
 		bttv_gpio_tracking(btv,"msp34xx");
 	if (bttv_verbose)
-		printk(KERN_INFO "bttv%d: Hauppauge/Voodoo msp34xx: reset line "
-		       "init [%d]\n", btv->c.nr, pin);
+		pr_info("%d: Hauppauge/Voodoo msp34xx: reset line init [%d]\n",
+			btv->c.nr, pin);
 }
 
 /* ----------------------------------------------------------------------- */
@@ -4034,7 +4027,7 @@ static void __devinit init_PXC200(struct bttv *btv)
 	btwrite(BT848_ADC_RESERVED|BT848_ADC_AGC_EN, BT848_ADC);
 
 	/*	Initialise MAX517 DAC */
-	printk(KERN_INFO "Setting DAC reference voltage level ...\n");
+	pr_info("Setting DAC reference voltage level ...\n");
 	bttv_I2CWrite(btv,0x5E,0,0x80,1);
 
 	/*	Initialise 12C508 PIC */
@@ -4043,7 +4036,7 @@ static void __devinit init_PXC200(struct bttv *btv)
 	 *	argument so the numbers are different */
 
 
-	printk(KERN_INFO "Initialising 12C508 PIC chip ...\n");
+	pr_info("Initialising 12C508 PIC chip ...\n");
 
 	/* First of all, enable the clock line. This is used in the PXC200-F */
 	val = btread(BT848_GPIO_DMA_CTL);
@@ -4062,13 +4055,12 @@ static void __devinit init_PXC200(struct bttv *btv)
 	for (i = 0; i < ARRAY_SIZE(vals); i++) {
 		tmp=bttv_I2CWrite(btv,0x1E,0,vals[i],1);
 		if (tmp != -1) {
-			printk(KERN_INFO
-			       "I2C Write(%2.2x) = %i\nI2C Read () = %2.2x\n\n",
+			pr_info("I2C Write(%2.2x) = %i\nI2C Read () = %2.2x\n\n",
 			       vals[i],tmp,bttv_I2CRead(btv,0x1F,NULL));
 		}
 	}
 
-	printk(KERN_INFO "PXC200 Initialised.\n");
+	pr_info("PXC200 Initialised\n");
 }
 
 
@@ -4107,8 +4099,7 @@ init_RTV24 (struct bttv *btv)
 	uint32_t dataRead = 0;
 	long watchdog_value = 0x0E;
 
-	printk (KERN_INFO
-		"bttv%d: Adlink RTV-24 initialisation in progress ...\n",
+	pr_info("%d: Adlink RTV-24 initialisation in progress ...\n",
 		btv->c.nr);
 
 	btwrite (0x00c3feff, BT848_GPIO_OUT_EN);
@@ -4122,8 +4113,7 @@ init_RTV24 (struct bttv *btv)
 	dataRead = btread (BT848_GPIO_DATA);
 
 	if ((((dataRead >> 18) & 0x01) != 0) || (((dataRead >> 19) & 0x01) != 1)) {
-		printk (KERN_INFO
-			"bttv%d: Adlink RTV-24 initialisation(1) ERROR_CPLD_Check_Failed (read %d)\n",
+		pr_info("%d: Adlink RTV-24 initialisation(1) ERROR_CPLD_Check_Failed (read %d)\n",
 			btv->c.nr, dataRead);
 	}
 
@@ -4136,15 +4126,13 @@ init_RTV24 (struct bttv *btv)
 	dataRead = btread (BT848_GPIO_DATA);
 
 	if ((((dataRead >> 18) & 0x01) != 0) || (((dataRead >> 19) & 0x01) != 0)) {
-		printk (KERN_INFO
-			"bttv%d: Adlink RTV-24 initialisation(2) ERROR_CPLD_Check_Failed (read %d)\n",
+		pr_info("%d: Adlink RTV-24 initialisation(2) ERROR_CPLD_Check_Failed (read %d)\n",
 			btv->c.nr, dataRead);
 
 		return;
 	}
 
-	printk (KERN_INFO
-		"bttv%d: Adlink RTV-24 initialisation complete.\n", btv->c.nr);
+	pr_info("%d: Adlink RTV-24 initialisation complete\n", btv->c.nr);
 }
 
 
@@ -4261,22 +4249,25 @@ static int tea5757_read(struct bttv *btv)
 	while (bus_in(btv,btv->mbox_data) && time_before(jiffies, timeout))
 		schedule();
 	if (bus_in(btv,btv->mbox_data)) {
-		printk(KERN_WARNING "bttv%d: tea5757: read timeout\n",btv->c.nr);
+		pr_warn("%d: tea5757: read timeout\n", btv->c.nr);
 		return -1;
 	}
 
-	dprintk("bttv%d: tea5757:",btv->c.nr);
+	dprintk("%d: tea5757:", btv->c.nr);
 	for (i = 0; i < 24; i++) {
 		udelay(5);
 		bus_high(btv,btv->mbox_clk);
 		udelay(5);
-		dprintk("%c",(bus_in(btv,btv->mbox_most) == 0)?'T':'-');
+		dprintk_cont("%c",
+			     bus_in(btv, btv->mbox_most) == 0 ? 'T' : '-');
 		bus_low(btv,btv->mbox_clk);
 		value <<= 1;
 		value |= (bus_in(btv,btv->mbox_data) == 0)?0:1;  /* MSB first */
-		dprintk("%c", (bus_in(btv,btv->mbox_most) == 0)?'S':'M');
+		dprintk_cont("%c",
+			     bus_in(btv, btv->mbox_most) == 0 ? 'S' : 'M');
 	}
-	dprintk("\nbttv%d: tea5757: read 0x%X\n", btv->c.nr, value);
+	dprintk_cont("\n");
+	dprintk("%d: tea5757: read 0x%X\n", btv->c.nr, value);
 	return value;
 }
 
@@ -4295,7 +4286,7 @@ static int tea5757_write(struct bttv *btv, int value)
 	if (bttv_gpio)
 		bttv_gpio_tracking(btv,"tea5757 write");
 
-	dprintk("bttv%d: tea5757: write 0x%X\n", btv->c.nr, value);
+	dprintk("%d: tea5757: write 0x%X\n", btv->c.nr, value);
 	bus_low(btv,btv->mbox_clk);
 	bus_high(btv,btv->mbox_we);
 	for (i = 0; i < 25; i++) {
@@ -4547,7 +4538,7 @@ static void picolo_tetra_init(struct bttv *btv)
 static void picolo_tetra_muxsel (struct bttv* btv, unsigned int input)
 {
 
-	dprintk (KERN_DEBUG "bttv%d : picolo_tetra_muxsel =>  input = %d\n",btv->c.nr,input);
+	dprintk("%d : picolo_tetra_muxsel =>  input = %d\n", btv->c.nr, input);
 	/*Just set the right path in the analog multiplexers : channel 1 -> 4 ==> Analog Mux ==> MUX0*/
 	/*GPIO[20]&GPIO[21] used to choose the right input*/
 	btwrite (input<<20,BT848_GPIO_DATA);
@@ -4592,7 +4583,7 @@ static void ivc120_muxsel(struct bttv *btv, unsigned int input)
 	int key = input % 4;
 	int matrix = input / 4;
 
-	dprintk("bttv%d: ivc120_muxsel: Input - %02d | TDA - %02d | In - %02d\n",
+	dprintk("%d: ivc120_muxsel: Input - %02d | TDA - %02d | In - %02d\n",
 		btv->c.nr, input, matrix, key);
 
 	/* Handles the input selection on the TDA8540's */
@@ -4649,15 +4640,17 @@ static void PXC200_muxsel(struct bttv *btv, unsigned int input)
 	buf[1]=0;
 	rc=bttv_I2CWrite(btv,(PX_I2C_PIC<<1),buf[0],buf[1],1);
 	if (rc) {
-	  printk(KERN_DEBUG "bttv%d: PXC200_muxsel: pic cfg write failed:%d\n", btv->c.nr,rc);
+		pr_debug("%d: PXC200_muxsel: pic cfg write failed:%d\n",
+			 btv->c.nr, rc);
 	  /* not PXC ? do nothing */
-	  return;
+		return;
 	}
 
 	rc=bttv_I2CRead(btv,(PX_I2C_PIC<<1),NULL);
 	if (!(rc & PX_CFG_PXC200F)) {
-	  printk(KERN_DEBUG "bttv%d: PXC200_muxsel: not PXC200F rc:%d \n", btv->c.nr,rc);
-	  return;
+		pr_debug("%d: PXC200_muxsel: not PXC200F rc:%d\n",
+			 btv->c.nr, rc);
+		return;
 	}
 
 
@@ -4696,7 +4689,7 @@ static void PXC200_muxsel(struct bttv *btv, unsigned int input)
 	else /* older device */
 	  btand(~BT848_IFORM_MUXSEL,BT848_IFORM);
 
-	printk(KERN_DEBUG "bttv%d: setting input channel to:%d\n", btv->c.nr,(int)mux);
+	pr_debug("%d: setting input channel to:%d\n", btv->c.nr, (int)mux);
 }
 
 static void phytec_muxsel(struct bttv *btv, unsigned int input)
@@ -4847,29 +4840,27 @@ void __init bttv_check_chipset(void)
 
 	/* print warnings about any quirks found */
 	if (triton1)
-		printk(KERN_INFO "bttv: Host bridge needs ETBF enabled.\n");
+		pr_info("Host bridge needs ETBF enabled\n");
 	if (vsfx)
-		printk(KERN_INFO "bttv: Host bridge needs VSFX enabled.\n");
+		pr_info("Host bridge needs VSFX enabled\n");
 	if (pcipci_fail) {
-		printk(KERN_INFO "bttv: bttv and your chipset may not work "
-							"together.\n");
+		pr_info("bttv and your chipset may not work together\n");
 		if (!no_overlay) {
-			printk(KERN_INFO "bttv: overlay will be disabled.\n");
+			pr_info("overlay will be disabled\n");
 			no_overlay = 1;
 		} else {
-			printk(KERN_INFO "bttv: overlay forced. Use this "
-						"option at your own risk.\n");
+			pr_info("overlay forced. Use this option at your own risk.\n");
 		}
 	}
 	if (UNSET != latency)
-		printk(KERN_INFO "bttv: pci latency fixup [%d]\n",latency);
+		pr_info("pci latency fixup [%d]\n", latency);
 	while ((dev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_82441, dev))) {
 		unsigned char b;
 		pci_read_config_byte(dev, 0x53, &b);
 		if (bttv_debug)
-			printk(KERN_INFO "bttv: Host bridge: 82441FX Natoma, "
-			       "bufcon=0x%02x\n",b);
+			pr_info("Host bridge: 82441FX Natoma, bufcon=0x%02x\n",
+				b);
 	}
 }
 
@@ -4882,12 +4873,13 @@ int __devinit bttv_handle_chipset(struct bttv *btv)
 
 	if (bttv_verbose) {
 		if (triton1)
-			printk(KERN_INFO "bttv%d: enabling ETBF (430FX/VP3 compatibilty)\n",btv->c.nr);
+			pr_info("%d: enabling ETBF (430FX/VP3 compatibility)\n",
+				btv->c.nr);
 		if (vsfx && btv->id >= 878)
-			printk(KERN_INFO "bttv%d: enabling VSFX\n",btv->c.nr);
+			pr_info("%d: enabling VSFX\n", btv->c.nr);
 		if (UNSET != latency)
-			printk(KERN_INFO "bttv%d: setting pci timer to %d\n",
-			       btv->c.nr,latency);
+			pr_info("%d: setting pci timer to %d\n",
+				btv->c.nr, latency);
 	}
 
 	if (btv->id < 878) {
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 14444de..3dd0660 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -34,6 +34,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -942,8 +944,8 @@ static
 void free_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bits)
 {
 	if ((fh->resources & bits) != bits) {
-		/* trying to free ressources not allocated by us ... */
-		printk("bttv: BUG! (btres)\n");
+		/* trying to free resources not allocated by us ... */
+		pr_err("BUG! (btres)\n");
 	}
 	fh->resources  &= ~bits;
 	btv->resources &= ~bits;
@@ -1000,7 +1002,7 @@ static void set_pll(struct bttv *btv)
 		return;
 
 	if (btv->pll.pll_ofreq == btv->pll.pll_current) {
-		dprintk("bttv%d: PLL: no change required\n",btv->c.nr);
+		dprintk("%d: PLL: no change required\n", btv->c.nr);
 		return;
 	}
 
@@ -1008,21 +1010,23 @@ static void set_pll(struct bttv *btv)
 		/* no PLL needed */
 		if (btv->pll.pll_current == 0)
 			return;
-		bttv_printk(KERN_INFO "bttv%d: PLL can sleep, using XTAL (%d).\n",
-			btv->c.nr,btv->pll.pll_ifreq);
+		if (bttv_verbose)
+			pr_info("%d: PLL can sleep, using XTAL (%d)\n",
+				btv->c.nr, btv->pll.pll_ifreq);
 		btwrite(0x00,BT848_TGCTRL);
 		btwrite(0x00,BT848_PLL_XCI);
 		btv->pll.pll_current = 0;
 		return;
 	}
 
-	bttv_printk(KERN_INFO "bttv%d: PLL: %d => %d ",btv->c.nr,
-		btv->pll.pll_ifreq, btv->pll.pll_ofreq);
+	if (bttv_verbose)
+		pr_info("%d: Setting PLL: %d => %d (needs up to 100ms)\n",
+			btv->c.nr,
+			btv->pll.pll_ifreq, btv->pll.pll_ofreq);
 	set_pll_freq(btv, btv->pll.pll_ifreq, btv->pll.pll_ofreq);
 
 	for (i=0; i<10; i++) {
 		/*  Let other people run while the PLL stabilizes */
-		bttv_printk(".");
 		msleep(10);
 
 		if (btread(BT848_DSTATUS) & BT848_DSTATUS_PLOCK) {
@@ -1030,12 +1034,14 @@ static void set_pll(struct bttv *btv)
 		} else {
 			btwrite(0x08,BT848_TGCTRL);
 			btv->pll.pll_current = btv->pll.pll_ofreq;
-			bttv_printk(" ok\n");
+			if (bttv_verbose)
+				pr_info("PLL set ok\n");
 			return;
 		}
 	}
 	btv->pll.pll_current = -1;
-	bttv_printk("failed\n");
+	if (bttv_verbose)
+		pr_info("Setting PLL failed\n");
 	return;
 }
 
@@ -1047,7 +1053,7 @@ static void bt848A_set_timing(struct bttv *btv)
 	int fsc       = bttv_tvnorms[btv->tvnorm].Fsc;
 
 	if (btv->input == btv->dig) {
-		dprintk("bttv%d: load digital timing table (table_idx=%d)\n",
+		dprintk("%d: load digital timing table (table_idx=%d)\n",
 			btv->c.nr,table_idx);
 
 		/* timing change...reset timing generator address */
@@ -1076,7 +1082,7 @@ static void bt848_bright(struct bttv *btv, int bright)
 {
 	int value;
 
-	// printk("bttv: set bright: %d\n",bright); // DEBUG
+	// printk("set bright: %d\n", bright); // DEBUG
 	btv->bright = bright;
 
 	/* We want -128 to 127 we get 0-65535 */
@@ -1150,8 +1156,7 @@ video_mux(struct bttv *btv, unsigned int input)
 	}
 	mux = bttv_muxsel(btv, input);
 	btaor(mux<<5, ~(3<<5), BT848_IFORM);
-	dprintk(KERN_DEBUG "bttv%d: video mux: input=%d mux=%d\n",
-		btv->c.nr,input,mux);
+	dprintk("%d: video mux: input=%d mux=%d\n", btv->c.nr, input, mux);
 
 	/* card specific hook */
 	if(bttv_tvcards[btv->c.type].muxsel_hook)
@@ -1440,7 +1445,7 @@ static void bttv_reinit_bt848(struct bttv *btv)
 	unsigned long flags;
 
 	if (bttv_verbose)
-		printk(KERN_INFO "bttv%d: reset, reinitialize\n",btv->c.nr);
+		pr_info("%d: reset, reinitialize\n", btv->c.nr);
 	spin_lock_irqsave(&btv->s_lock,flags);
 	btv->errors=0;
 	bttv_set_dma(btv,0);
@@ -1622,8 +1627,8 @@ void bttv_gpio_tracking(struct bttv *btv, char *comment)
 	unsigned int outbits, data;
 	outbits = btread(BT848_GPIO_OUT_EN);
 	data    = btread(BT848_GPIO_DATA);
-	printk(KERN_DEBUG "bttv%d: gpio: en=%08x, out=%08x in=%08x [%s]\n",
-	       btv->c.nr,outbits,data & outbits, data & ~outbits, comment);
+	pr_debug("%d: gpio: en=%08x, out=%08x in=%08x [%s]\n",
+		 btv->c.nr, outbits, data & outbits, data & ~outbits, comment);
 }
 
 static void bttv_field_count(struct bttv *btv)
@@ -1668,7 +1673,7 @@ bttv_switch_overlay(struct bttv *btv, struct bttv_fh *fh,
 	unsigned long flags;
 	int retval = 0;
 
-	dprintk("switch_overlay: enter [new=%p]\n",new);
+	dprintk("switch_overlay: enter [new=%p]\n", new);
 	if (new)
 		new->vb.state = VIDEOBUF_DONE;
 	spin_lock_irqsave(&btv->s_lock,flags);
@@ -1678,7 +1683,8 @@ bttv_switch_overlay(struct bttv *btv, struct bttv_fh *fh,
 	bttv_set_dma(btv, 0x03);
 	spin_unlock_irqrestore(&btv->s_lock,flags);
 	if (NULL != old) {
-		dprintk("switch_overlay: old=%p state is %d\n",old,old->vb.state);
+		dprintk("switch_overlay: old=%p state is %d\n",
+			old, old->vb.state);
 		bttv_dma_free(&fh->cap,btv, old);
 		kfree(old);
 	}
@@ -2029,11 +2035,11 @@ static int bttv_log_status(struct file *file, void *f)
 	struct bttv_fh *fh  = f;
 	struct bttv *btv = fh->btv;
 
-	printk(KERN_INFO "bttv%d: ========  START STATUS CARD #%d  ========\n",
-			btv->c.nr, btv->c.nr);
+	pr_info("%d: ========  START STATUS CARD #%d  ========\n",
+		btv->c.nr, btv->c.nr);
 	bttv_call_all(btv, core, log_status);
-	printk(KERN_INFO "bttv%d: ========  END STATUS CARD   #%d  ========\n",
-			btv->c.nr, btv->c.nr);
+	pr_info("%d: ========  END STATUS CARD   #%d  ========\n",
+		btv->c.nr, btv->c.nr);
 	return 0;
 }
 
@@ -2598,7 +2604,7 @@ static int bttv_s_fmt_vid_overlay(struct file *file, void *priv,
 	struct bttv *btv = fh->btv;
 
 	if (no_overlay > 0) {
-		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
+		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
 
@@ -2673,7 +2679,7 @@ static int bttv_enum_fmt_vid_overlay(struct file *file, void  *priv,
 	int rc;
 
 	if (no_overlay > 0) {
-		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
+		pr_err("V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
 
@@ -2714,7 +2720,7 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
 			return -EINVAL;
 		}
 		if (unlikely(!fh->ov.setup_ok)) {
-			dprintk("bttv%d: overlay: !setup_ok\n", btv->c.nr);
+			dprintk("%d: overlay: !setup_ok\n", btv->c.nr);
 			retval = -EINVAL;
 		}
 		if (retval)
@@ -3091,8 +3097,8 @@ static ssize_t bttv_read(struct file *file, char __user *data,
 
 	if (fh->btv->errors)
 		bttv_reinit_bt848(fh->btv);
-	dprintk("bttv%d: read count=%d type=%s\n",
-		fh->btv->c.nr,(int)count,v4l2_type_names[fh->type]);
+	dprintk("%d: read count=%d type=%s\n",
+		fh->btv->c.nr, (int)count, v4l2_type_names[fh->type]);
 
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
@@ -3174,7 +3180,7 @@ static int bttv_open(struct file *file)
 	struct bttv_fh *fh;
 	enum v4l2_buf_type type = 0;
 
-	dprintk(KERN_DEBUG "bttv: open dev=%s\n", video_device_node_name(vdev));
+	dprintk("open dev=%s\n", video_device_node_name(vdev));
 
 	if (vdev->vfl_type == VFL_TYPE_GRABBER) {
 		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
@@ -3185,8 +3191,8 @@ static int bttv_open(struct file *file)
 		return -ENODEV;
 	}
 
-	dprintk(KERN_DEBUG "bttv%d: open called (type=%s)\n",
-		btv->c.nr,v4l2_type_names[type]);
+	dprintk("%d: open called (type=%s)\n",
+		btv->c.nr, v4l2_type_names[type]);
 
 	/* allocate per filehandle data */
 	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
@@ -3288,7 +3294,7 @@ bttv_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct bttv_fh *fh = file->private_data;
 
-	dprintk("bttv%d: mmap type=%s 0x%lx+%ld\n",
+	dprintk("%d: mmap type=%s 0x%lx+%ld\n",
 		fh->btv->c.nr, v4l2_type_names[fh->type],
 		vma->vm_start, vma->vm_end - vma->vm_start);
 	return videobuf_mmap_mapper(bttv_queue(fh),vma);
@@ -3370,9 +3376,9 @@ static int radio_open(struct file *file)
 	struct bttv *btv = video_drvdata(file);
 	struct bttv_fh *fh;
 
-	dprintk("bttv: open dev=%s\n", video_device_node_name(vdev));
+	dprintk("open dev=%s\n", video_device_node_name(vdev));
 
-	dprintk("bttv%d: open called (radio)\n",btv->c.nr);
+	dprintk("%d: open called (radio)\n", btv->c.nr);
 
 	/* allocate per filehandle data */
 	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
@@ -3616,12 +3622,12 @@ static int bttv_risc_decode(u32 risc)
 	};
 	int i;
 
-	printk("0x%08x [ %s", risc,
+	pr_cont("0x%08x [ %s", risc,
 	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
 	for (i = ARRAY_SIZE(bits)-1; i >= 0; i--)
 		if (risc & (1 << (i + 12)))
-			printk(" %s",bits[i]);
-	printk(" count=%d ]\n", risc & 0xfff);
+			pr_cont(" %s", bits[i]);
+	pr_cont(" count=%d ]\n", risc & 0xfff);
 	return incr[risc >> 28] ? incr[risc >> 28] : 1;
 }
 
@@ -3630,16 +3636,18 @@ static void bttv_risc_disasm(struct bttv *btv,
 {
 	unsigned int i,j,n;
 
-	printk("%s: risc disasm: %p [dma=0x%08lx]\n",
-	       btv->c.v4l2_dev.name, risc->cpu, (unsigned long)risc->dma);
+	pr_info("%s: risc disasm: %p [dma=0x%08lx]\n",
+		btv->c.v4l2_dev.name, risc->cpu, (unsigned long)risc->dma);
 	for (i = 0; i < (risc->size >> 2); i += n) {
-		printk("%s:   0x%lx: ", btv->c.v4l2_dev.name,
-		       (unsigned long)(risc->dma + (i<<2)));
+		pr_info("%s:   0x%lx: ",
+			btv->c.v4l2_dev.name,
+			(unsigned long)(risc->dma + (i<<2)));
 		n = bttv_risc_decode(le32_to_cpu(risc->cpu[i]));
 		for (j = 1; j < n; j++)
-			printk("%s:   0x%lx: 0x%08x [ arg #%d ]\n",
-			       btv->c.v4l2_dev.name, (unsigned long)(risc->dma + ((i+j)<<2)),
-			       risc->cpu[i+j], j);
+			pr_info("%s:   0x%lx: 0x%08x [ arg #%d ]\n",
+				btv->c.v4l2_dev.name,
+				(unsigned long)(risc->dma + ((i+j)<<2)),
+				risc->cpu[i+j], j);
 		if (0 == risc->cpu[i])
 			break;
 	}
@@ -3647,17 +3655,18 @@ static void bttv_risc_disasm(struct bttv *btv,
 
 static void bttv_print_riscaddr(struct bttv *btv)
 {
-	printk("  main: %08Lx\n",
-	       (unsigned long long)btv->main.dma);
-	printk("  vbi : o=%08Lx e=%08Lx\n",
-	       btv->cvbi ? (unsigned long long)btv->cvbi->top.dma : 0,
-	       btv->cvbi ? (unsigned long long)btv->cvbi->bottom.dma : 0);
-	printk("  cap : o=%08Lx e=%08Lx\n",
-	       btv->curr.top    ? (unsigned long long)btv->curr.top->top.dma : 0,
-	       btv->curr.bottom ? (unsigned long long)btv->curr.bottom->bottom.dma : 0);
-	printk("  scr : o=%08Lx e=%08Lx\n",
-	       btv->screen ? (unsigned long long)btv->screen->top.dma : 0,
-	       btv->screen ? (unsigned long long)btv->screen->bottom.dma : 0);
+	pr_info("  main: %08llx\n", (unsigned long long)btv->main.dma);
+	pr_info("  vbi : o=%08llx e=%08llx\n",
+		btv->cvbi ? (unsigned long long)btv->cvbi->top.dma : 0,
+		btv->cvbi ? (unsigned long long)btv->cvbi->bottom.dma : 0);
+	pr_info("  cap : o=%08llx e=%08llx\n",
+		btv->curr.top
+		? (unsigned long long)btv->curr.top->top.dma : 0,
+		btv->curr.bottom
+		? (unsigned long long)btv->curr.bottom->bottom.dma : 0);
+	pr_info("  scr : o=%08llx e=%08llx\n",
+		btv->screen ? (unsigned long long)btv->screen->top.dma : 0,
+		btv->screen ? (unsigned long long)btv->screen->bottom.dma : 0);
 	bttv_risc_disasm(btv, &btv->main);
 }
 
@@ -3690,34 +3699,34 @@ static void bttv_print_irqbits(u32 print, u32 mark)
 {
 	unsigned int i;
 
-	printk("bits:");
+	pr_cont("bits:");
 	for (i = 0; i < ARRAY_SIZE(irq_name); i++) {
 		if (print & (1 << i))
-			printk(" %s",irq_name[i]);
+			pr_cont(" %s", irq_name[i]);
 		if (mark & (1 << i))
-			printk("*");
+			pr_cont("*");
 	}
 }
 
 static void bttv_irq_debug_low_latency(struct bttv *btv, u32 rc)
 {
-	printk("bttv%d: irq: skipped frame [main=%lx,o_vbi=%lx,o_field=%lx,rc=%lx]\n",
-	       btv->c.nr,
-	       (unsigned long)btv->main.dma,
-	       (unsigned long)le32_to_cpu(btv->main.cpu[RISC_SLOT_O_VBI+1]),
-	       (unsigned long)le32_to_cpu(btv->main.cpu[RISC_SLOT_O_FIELD+1]),
-	       (unsigned long)rc);
+	pr_warn("%d: irq: skipped frame [main=%lx,o_vbi=%lx,o_field=%lx,rc=%lx]\n",
+		btv->c.nr,
+		(unsigned long)btv->main.dma,
+		(unsigned long)le32_to_cpu(btv->main.cpu[RISC_SLOT_O_VBI+1]),
+		(unsigned long)le32_to_cpu(btv->main.cpu[RISC_SLOT_O_FIELD+1]),
+		(unsigned long)rc);
 
 	if (0 == (btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC)) {
-		printk("bttv%d: Oh, there (temporarely?) is no input signal. "
-		       "Ok, then this is harmless, don't worry ;)\n",
-		       btv->c.nr);
+		pr_notice("%d: Oh, there (temporarily?) is no input signal. "
+			  "Ok, then this is harmless, don't worry ;)\n",
+			  btv->c.nr);
 		return;
 	}
-	printk("bttv%d: Uhm. Looks like we have unusual high IRQ latencies.\n",
-	       btv->c.nr);
-	printk("bttv%d: Lets try to catch the culpit red-handed ...\n",
-	       btv->c.nr);
+	pr_notice("%d: Uhm. Looks like we have unusual high IRQ latencies\n",
+		  btv->c.nr);
+	pr_notice("%d: Lets try to catch the culpit red-handed ...\n",
+		  btv->c.nr);
 	dump_stack();
 }
 
@@ -3798,9 +3807,9 @@ bttv_irq_next_video(struct bttv *btv, struct bttv_buffer_set *set)
 		}
 	}
 
-	dprintk("bttv%d: next set: top=%p bottom=%p [screen=%p,irq=%d,%d]\n",
-		btv->c.nr,set->top, set->bottom,
-		btv->screen,set->frame_irq,set->top_irq);
+	dprintk("%d: next set: top=%p bottom=%p [screen=%p,irq=%d,%d]\n",
+		btv->c.nr, set->top, set->bottom,
+		btv->screen, set->frame_irq, set->top_irq);
 	return 0;
 }
 
@@ -3815,7 +3824,8 @@ bttv_irq_wakeup_video(struct bttv *btv, struct bttv_buffer_set *wakeup,
 	if (wakeup->top == wakeup->bottom) {
 		if (NULL != wakeup->top && curr->top != wakeup->top) {
 			if (irq_debug > 1)
-				printk("bttv%d: wakeup: both=%p\n",btv->c.nr,wakeup->top);
+				pr_debug("%d: wakeup: both=%p\n",
+					 btv->c.nr, wakeup->top);
 			wakeup->top->vb.ts = ts;
 			wakeup->top->vb.field_count = btv->field_count;
 			wakeup->top->vb.state = state;
@@ -3824,7 +3834,8 @@ bttv_irq_wakeup_video(struct bttv *btv, struct bttv_buffer_set *wakeup,
 	} else {
 		if (NULL != wakeup->top && curr->top != wakeup->top) {
 			if (irq_debug > 1)
-				printk("bttv%d: wakeup: top=%p\n",btv->c.nr,wakeup->top);
+				pr_debug("%d: wakeup: top=%p\n",
+					 btv->c.nr, wakeup->top);
 			wakeup->top->vb.ts = ts;
 			wakeup->top->vb.field_count = btv->field_count;
 			wakeup->top->vb.state = state;
@@ -3832,7 +3843,8 @@ bttv_irq_wakeup_video(struct bttv *btv, struct bttv_buffer_set *wakeup,
 		}
 		if (NULL != wakeup->bottom && curr->bottom != wakeup->bottom) {
 			if (irq_debug > 1)
-				printk("bttv%d: wakeup: bottom=%p\n",btv->c.nr,wakeup->bottom);
+				pr_debug("%d: wakeup: bottom=%p\n",
+					 btv->c.nr, wakeup->bottom);
 			wakeup->bottom->vb.ts = ts;
 			wakeup->bottom->vb.field_count = btv->field_count;
 			wakeup->bottom->vb.state = state;
@@ -3866,11 +3878,11 @@ static void bttv_irq_timeout(unsigned long data)
 	unsigned long flags;
 
 	if (bttv_verbose) {
-		printk(KERN_INFO "bttv%d: timeout: drop=%d irq=%d/%d, risc=%08x, ",
-		       btv->c.nr, btv->framedrop, btv->irq_me, btv->irq_total,
-		       btread(BT848_RISC_COUNT));
+		pr_info("%d: timeout: drop=%d irq=%d/%d, risc=%08x, ",
+			btv->c.nr, btv->framedrop, btv->irq_me, btv->irq_total,
+			btread(BT848_RISC_COUNT));
 		bttv_print_irqbits(btread(BT848_INT_STAT),0);
-		printk("\n");
+		pr_cont("\n");
 	}
 
 	spin_lock_irqsave(&btv->s_lock,flags);
@@ -4033,21 +4045,23 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
 		dstat=btread(BT848_DSTATUS);
 
 		if (irq_debug) {
-			printk(KERN_DEBUG "bttv%d: irq loop=%d fc=%d "
-			       "riscs=%x, riscc=%08x, ",
-			       btv->c.nr, count, btv->field_count,
-			       stat>>28, btread(BT848_RISC_COUNT));
+			pr_debug("%d: irq loop=%d fc=%d riscs=%x, riscc=%08x, ",
+				 btv->c.nr, count, btv->field_count,
+				 stat>>28, btread(BT848_RISC_COUNT));
 			bttv_print_irqbits(stat,astat);
 			if (stat & BT848_INT_HLOCK)
-				printk("   HLOC => %s", (dstat & BT848_DSTATUS_HLOC)
-				       ? "yes" : "no");
+				pr_cont("   HLOC => %s",
+					dstat & BT848_DSTATUS_HLOC
+					? "yes" : "no");
 			if (stat & BT848_INT_VPRES)
-				printk("   PRES => %s", (dstat & BT848_DSTATUS_PRES)
-				       ? "yes" : "no");
+				pr_cont("   PRES => %s",
+					dstat & BT848_DSTATUS_PRES
+					? "yes" : "no");
 			if (stat & BT848_INT_FMTCHG)
-				printk("   NUML => %s", (dstat & BT848_DSTATUS_NUML)
-				       ? "625" : "525");
-			printk("\n");
+				pr_cont("   NUML => %s",
+					dstat & BT848_DSTATUS_NUML
+					? "625" : "525");
+			pr_cont("\n");
 		}
 
 		if (astat&BT848_INT_VSYNC)
@@ -4075,18 +4089,19 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
 			audio_mute(btv, btv->mute);  /* trigger automute */
 
 		if (astat & (BT848_INT_SCERR|BT848_INT_OCERR)) {
-			printk(KERN_INFO "bttv%d: %s%s @ %08x,",btv->c.nr,
-			       (astat & BT848_INT_SCERR) ? "SCERR" : "",
-			       (astat & BT848_INT_OCERR) ? "OCERR" : "",
-			       btread(BT848_RISC_COUNT));
+			pr_info("%d: %s%s @ %08x,",
+				btv->c.nr,
+				(astat & BT848_INT_SCERR) ? "SCERR" : "",
+				(astat & BT848_INT_OCERR) ? "OCERR" : "",
+				btread(BT848_RISC_COUNT));
 			bttv_print_irqbits(stat,astat);
-			printk("\n");
+			pr_cont("\n");
 			if (bttv_debug)
 				bttv_print_riscaddr(btv);
 		}
 		if (fdsr && astat & BT848_INT_FDSR) {
-			printk(KERN_INFO "bttv%d: FDSR @ %08x\n",
-			       btv->c.nr,btread(BT848_RISC_COUNT));
+			pr_info("%d: FDSR @ %08x\n",
+				btv->c.nr, btread(BT848_RISC_COUNT));
 			if (bttv_debug)
 				bttv_print_riscaddr(btv);
 		}
@@ -4097,11 +4112,11 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
 			if (count > 8 || !(astat & BT848_INT_GPINT)) {
 				btwrite(0, BT848_INT_MASK);
 
-				printk(KERN_ERR
-					   "bttv%d: IRQ lockup, cleared int mask [", btv->c.nr);
+				pr_err("%d: IRQ lockup, cleared int mask [",
+				       btv->c.nr);
 			} else {
-				printk(KERN_ERR
-					   "bttv%d: IRQ lockup, clearing GPINT from int mask [", btv->c.nr);
+				pr_err("%d: IRQ lockup, clearing GPINT from int mask [",
+				       btv->c.nr);
 
 				btwrite(btread(BT848_INT_MASK) & (-1 ^ BT848_INT_GPINT),
 						BT848_INT_MASK);
@@ -4109,7 +4124,7 @@ static irqreturn_t bttv_irq(int irq, void *dev_id)
 
 			bttv_print_irqbits(stat,astat);
 
-			printk("]\n");
+			pr_cont("]\n");
 		}
 	}
 	btv->irq_total++;
@@ -4171,7 +4186,7 @@ static void bttv_unregister_video(struct bttv *btv)
 static int __devinit bttv_register_video(struct bttv *btv)
 {
 	if (no_overlay > 0)
-		printk("bttv: Overlay support disabled.\n");
+		pr_notice("Overlay support disabled\n");
 
 	/* video */
 	btv->video_dev = vdev_init(btv, &bttv_video_template, "video");
@@ -4181,12 +4196,11 @@ static int __devinit bttv_register_video(struct bttv *btv)
 	if (video_register_device(btv->video_dev, VFL_TYPE_GRABBER,
 				  video_nr[btv->c.nr]) < 0)
 		goto err;
-	printk(KERN_INFO "bttv%d: registered device %s\n",
-	       btv->c.nr, video_device_node_name(btv->video_dev));
+	pr_info("%d: registered device %s\n",
+		btv->c.nr, video_device_node_name(btv->video_dev));
 	if (device_create_file(&btv->video_dev->dev,
 				     &dev_attr_card)<0) {
-		printk(KERN_ERR "bttv%d: device_create_file 'card' "
-		       "failed\n", btv->c.nr);
+		pr_err("%d: device_create_file 'card' failed\n", btv->c.nr);
 		goto err;
 	}
 
@@ -4198,8 +4212,8 @@ static int __devinit bttv_register_video(struct bttv *btv)
 	if (video_register_device(btv->vbi_dev, VFL_TYPE_VBI,
 				  vbi_nr[btv->c.nr]) < 0)
 		goto err;
-	printk(KERN_INFO "bttv%d: registered device %s\n",
-	       btv->c.nr, video_device_node_name(btv->vbi_dev));
+	pr_info("%d: registered device %s\n",
+		btv->c.nr, video_device_node_name(btv->vbi_dev));
 
 	if (!btv->has_radio)
 		return 0;
@@ -4210,8 +4224,8 @@ static int __devinit bttv_register_video(struct bttv *btv)
 	if (video_register_device(btv->radio_dev, VFL_TYPE_RADIO,
 				  radio_nr[btv->c.nr]) < 0)
 		goto err;
-	printk(KERN_INFO "bttv%d: registered device %s\n",
-	       btv->c.nr, video_device_node_name(btv->radio_dev));
+	pr_info("%d: registered device %s\n",
+		btv->c.nr, video_device_node_name(btv->radio_dev));
 
 	/* all done */
 	return 0;
@@ -4244,10 +4258,10 @@ static int __devinit bttv_probe(struct pci_dev *dev,
 
 	if (bttv_num == BTTV_MAX)
 		return -ENOMEM;
-	printk(KERN_INFO "bttv: Bt8xx card found (%d).\n", bttv_num);
+	pr_info("Bt8xx card found (%d)\n", bttv_num);
 	bttvs[bttv_num] = btv = kzalloc(sizeof(*btv), GFP_KERNEL);
 	if (btv == NULL) {
-		printk(KERN_ERR "bttv: out of memory.\n");
+		pr_err("out of memory\n");
 		return -ENOMEM;
 	}
 	btv->c.nr  = bttv_num;
@@ -4277,21 +4291,19 @@ static int __devinit bttv_probe(struct pci_dev *dev,
 	btv->c.pci = dev;
 	btv->id  = dev->device;
 	if (pci_enable_device(dev)) {
-		printk(KERN_WARNING "bttv%d: Can't enable device.\n",
-		       btv->c.nr);
+		pr_warn("%d: Can't enable device\n", btv->c.nr);
 		return -EIO;
 	}
 	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
-		printk(KERN_WARNING "bttv%d: No suitable DMA available.\n",
-		       btv->c.nr);
+		pr_warn("%d: No suitable DMA available\n", btv->c.nr);
 		return -EIO;
 	}
 	if (!request_mem_region(pci_resource_start(dev,0),
 				pci_resource_len(dev,0),
 				btv->c.v4l2_dev.name)) {
-		printk(KERN_WARNING "bttv%d: can't request iomem (0x%llx).\n",
-		       btv->c.nr,
-		       (unsigned long long)pci_resource_start(dev,0));
+		pr_warn("%d: can't request iomem (0x%llx)\n",
+			btv->c.nr,
+			(unsigned long long)pci_resource_start(dev, 0));
 		return -EBUSY;
 	}
 	pci_set_master(dev);
@@ -4299,22 +4311,21 @@ static int __devinit bttv_probe(struct pci_dev *dev,
 
 	result = v4l2_device_register(&dev->dev, &btv->c.v4l2_dev);
 	if (result < 0) {
-		printk(KERN_WARNING "bttv%d: v4l2_device_register() failed\n", btv->c.nr);
+		pr_warn("%d: v4l2_device_register() failed\n", btv->c.nr);
 		goto fail0;
 	}
 
 	btv->revision = dev->revision;
 	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
-	printk(KERN_INFO "bttv%d: Bt%d (rev %d) at %s, ",
-	       bttv_num,btv->id, btv->revision, pci_name(dev));
-	printk("irq: %d, latency: %d, mmio: 0x%llx\n",
-	       btv->c.pci->irq, lat,
-	       (unsigned long long)pci_resource_start(dev,0));
+	pr_info("%d: Bt%d (rev %d) at %s, irq: %d, latency: %d, mmio: 0x%llx\n",
+		bttv_num, btv->id, btv->revision, pci_name(dev),
+		btv->c.pci->irq, lat,
+		(unsigned long long)pci_resource_start(dev, 0));
 	schedule();
 
 	btv->bt848_mmio = ioremap(pci_resource_start(dev, 0), 0x1000);
 	if (NULL == btv->bt848_mmio) {
-		printk("bttv%d: ioremap() failed\n", btv->c.nr);
+		pr_err("%d: ioremap() failed\n", btv->c.nr);
 		result = -EIO;
 		goto fail1;
 	}
@@ -4327,8 +4338,8 @@ static int __devinit bttv_probe(struct pci_dev *dev,
 	result = request_irq(btv->c.pci->irq, bttv_irq,
 	    IRQF_SHARED | IRQF_DISABLED, btv->c.v4l2_dev.name, (void *)btv);
 	if (result < 0) {
-		printk(KERN_ERR "bttv%d: can't get IRQ %d\n",
-		       bttv_num,btv->c.pci->irq);
+		pr_err("%d: can't get IRQ %d\n",
+		       bttv_num, btv->c.pci->irq);
 		goto fail1;
 	}
 
@@ -4433,7 +4444,7 @@ static void __devexit bttv_remove(struct pci_dev *pci_dev)
 	struct bttv *btv = to_bttv(v4l2_dev);
 
 	if (bttv_verbose)
-		printk("bttv%d: unloading\n",btv->c.nr);
+		pr_info("%d: unloading\n", btv->c.nr);
 
 	if (bttv_tvcards[btv->c.type].has_dvb)
 		flush_request_modules(btv);
@@ -4481,7 +4492,7 @@ static int bttv_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	struct bttv_buffer_set idle;
 	unsigned long flags;
 
-	dprintk("bttv%d: suspend %d\n", btv->c.nr, state.event);
+	dprintk("%d: suspend %d\n", btv->c.nr, state.event);
 
 	/* stop dma + irqs */
 	spin_lock_irqsave(&btv->s_lock,flags);
@@ -4517,14 +4528,13 @@ static int bttv_resume(struct pci_dev *pci_dev)
 	unsigned long flags;
 	int err;
 
-	dprintk("bttv%d: resume\n", btv->c.nr);
+	dprintk("%d: resume\n", btv->c.nr);
 
 	/* restore pci state */
 	if (btv->state.disabled) {
 		err=pci_enable_device(pci_dev);
 		if (err) {
-			printk(KERN_WARNING "bttv%d: Can't enable device.\n",
-								btv->c.nr);
+			pr_warn("%d: Can't enable device\n", btv->c.nr);
 			return err;
 		}
 		btv->state.disabled = 0;
@@ -4532,8 +4542,7 @@ static int bttv_resume(struct pci_dev *pci_dev)
 	err=pci_set_power_state(pci_dev, PCI_D0);
 	if (err) {
 		pci_disable_device(pci_dev);
-		printk(KERN_WARNING "bttv%d: Can't enable device.\n",
-							btv->c.nr);
+		pr_warn("%d: Can't enable device\n", btv->c.nr);
 		btv->state.disabled = 1;
 		return err;
 	}
@@ -4585,22 +4594,21 @@ static int __init bttv_init_module(void)
 
 	bttv_num = 0;
 
-	printk(KERN_INFO "bttv: driver version %s loaded\n",
-	       BTTV_VERSION);
+	pr_info("driver version %s loaded\n", BTTV_VERSION);
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
 		gbuffers = 2;
 	if (gbufsize > BTTV_MAX_FBUF)
 		gbufsize = BTTV_MAX_FBUF;
 	gbufsize = (gbufsize + PAGE_SIZE - 1) & PAGE_MASK;
 	if (bttv_verbose)
-		printk(KERN_INFO "bttv: using %d buffers with %dk (%d pages) each for capture\n",
-		       gbuffers, gbufsize >> 10, gbufsize >> PAGE_SHIFT);
+		pr_info("using %d buffers with %dk (%d pages) each for capture\n",
+			gbuffers, gbufsize >> 10, gbufsize >> PAGE_SHIFT);
 
 	bttv_check_chipset();
 
 	ret = bus_register(&bttv_sub_bus_type);
 	if (ret < 0) {
-		printk(KERN_WARNING "bttv: bus_register error: %d\n", ret);
+		pr_warn("bus_register error: %d\n", ret);
 		return ret;
 	}
 	ret = pci_register_driver(&bttv_pci_driver);
diff --git a/drivers/media/video/bt8xx/bttv-gpio.c b/drivers/media/video/bt8xx/bttv-gpio.c
index 13ce72c..922e823 100644
--- a/drivers/media/video/bt8xx/bttv-gpio.c
+++ b/drivers/media/video/bt8xx/bttv-gpio.c
@@ -26,6 +26,8 @@
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -99,7 +101,7 @@ int bttv_sub_add_device(struct bttv_core *core, char *name)
 		kfree(sub);
 		return err;
 	}
-	printk("bttv%d: add subdevice \"%s\"\n", core->nr, dev_name(&sub->dev));
+	pr_info("%d: add subdevice \"%s\"\n", core->nr, dev_name(&sub->dev));
 	list_add_tail(&sub->list,&core->subs);
 	return 0;
 }
diff --git a/drivers/media/video/bt8xx/bttv-i2c.c b/drivers/media/video/bt8xx/bttv-i2c.c
index d49b675..e3952af 100644
--- a/drivers/media/video/bt8xx/bttv-i2c.c
+++ b/drivers/media/video/bt8xx/bttv-i2c.c
@@ -27,6 +27,8 @@
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -154,9 +156,7 @@ bttv_i2c_sendbytes(struct bttv *btv, const struct i2c_msg *msg, int last)
 	if (retval == 0)
 		goto eio;
 	if (i2c_debug) {
-		printk(" <W %02x %02x", msg->addr << 1, msg->buf[0]);
-		if (!(xmit & BT878_I2C_NOSTOP))
-			printk(" >\n");
+		pr_cont(" <W %02x %02x", msg->addr << 1, msg->buf[0]);
 	}
 
 	for (cnt = 1; cnt < msg->len; cnt++ ) {
@@ -170,19 +170,18 @@ bttv_i2c_sendbytes(struct bttv *btv, const struct i2c_msg *msg, int last)
 			goto err;
 		if (retval == 0)
 			goto eio;
-		if (i2c_debug) {
-			printk(" %02x", msg->buf[cnt]);
-			if (!(xmit & BT878_I2C_NOSTOP))
-				printk(" >\n");
-		}
+		if (i2c_debug)
+			pr_cont(" %02x", msg->buf[cnt]);
 	}
+	if (!(xmit & BT878_I2C_NOSTOP))
+		pr_cont(">\n");
 	return msg->len;
 
  eio:
 	retval = -EIO;
  err:
 	if (i2c_debug)
-		printk(" ERR: %d\n",retval);
+		pr_cont(" ERR: %d\n",retval);
 	return retval;
 }
 
@@ -193,7 +192,7 @@ bttv_i2c_readbytes(struct bttv *btv, const struct i2c_msg *msg, int last)
 	u32 cnt;
 	int retval;
 
-	for(cnt = 0; cnt < msg->len; cnt++) {
+	for (cnt = 0; cnt < msg->len; cnt++) {
 		xmit = (msg->addr << 25) | (1 << 24) | I2C_HW;
 		if (cnt < msg->len-1)
 			xmit |= BT848_I2C_W3B;
@@ -201,6 +200,12 @@ bttv_i2c_readbytes(struct bttv *btv, const struct i2c_msg *msg, int last)
 			xmit |= BT878_I2C_NOSTOP;
 		if (cnt)
 			xmit |= BT878_I2C_NOSTART;
+
+		if (i2c_debug) {
+			if (!(xmit & BT878_I2C_NOSTART))
+				pr_cont(" <R %02x", (msg->addr << 1) +1);
+		}
+
 		btwrite(xmit, BT848_I2C);
 		retval = bttv_i2c_wait_done(btv);
 		if (retval < 0)
@@ -209,20 +214,20 @@ bttv_i2c_readbytes(struct bttv *btv, const struct i2c_msg *msg, int last)
 			goto eio;
 		msg->buf[cnt] = ((u32)btread(BT848_I2C) >> 8) & 0xff;
 		if (i2c_debug) {
-			if (!(xmit & BT878_I2C_NOSTART))
-				printk(" <R %02x", (msg->addr << 1) +1);
-			printk(" =%02x", msg->buf[cnt]);
-			if (!(xmit & BT878_I2C_NOSTOP))
-				printk(" >\n");
+			pr_cont(" =%02x", msg->buf[cnt]);
 		}
+		if (i2c_debug && !(xmit & BT878_I2C_NOSTOP))
+			pr_cont(" >\n");
 	}
+
+
 	return msg->len;
 
  eio:
 	retval = -EIO;
  err:
 	if (i2c_debug)
-		printk(" ERR: %d\n",retval);
+		pr_cont(" ERR: %d\n",retval);
 	return retval;
 }
 
@@ -234,7 +239,8 @@ static int bttv_i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int
 	int i;
 
 	if (i2c_debug)
-		printk("bt-i2c:");
+		pr_debug("bt-i2c:");
+
 	btwrite(BT848_INT_I2CDONE|BT848_INT_RACK, BT848_INT_STAT);
 	for (i = 0 ; i < num; i++) {
 		if (msgs[i].flags & I2C_M_RD) {
@@ -271,20 +277,20 @@ int bttv_I2CRead(struct bttv *btv, unsigned char addr, char *probe_for)
 	if (0 != btv->i2c_rc)
 		return -1;
 	if (bttv_verbose && NULL != probe_for)
-		printk(KERN_INFO "bttv%d: i2c: checking for %s @ 0x%02x... ",
-		       btv->c.nr,probe_for,addr);
+		pr_info("%d: i2c: checking for %s @ 0x%02x... ",
+			btv->c.nr, probe_for, addr);
 	btv->i2c_client.addr = addr >> 1;
 	if (1 != i2c_master_recv(&btv->i2c_client, &buffer, 1)) {
 		if (NULL != probe_for) {
 			if (bttv_verbose)
-				printk("not found\n");
+				pr_cont("not found\n");
 		} else
-			printk(KERN_WARNING "bttv%d: i2c read 0x%x: error\n",
-			       btv->c.nr,addr);
+			pr_warn("%d: i2c read 0x%x: error\n",
+				btv->c.nr, addr);
 		return -1;
 	}
 	if (bttv_verbose && NULL != probe_for)
-		printk("found\n");
+		pr_cont("found\n");
 	return buffer;
 }
 
@@ -335,8 +341,8 @@ static void do_i2c_scan(char *name, struct i2c_client *c)
 		rc = i2c_master_recv(c,&buf,0);
 		if (rc < 0)
 			continue;
-		printk("%s: i2c scan: found device @ 0x%x  [%s]\n",
-		       name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
+		pr_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
+			name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 }
 
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 677d70c..ef4c7cd 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -36,9 +38,10 @@ static int ir_rc5_remote_gap = 885;
 module_param(ir_rc5_remote_gap, int, 0644);
 
 #undef dprintk
-#define dprintk(arg...) do {	\
-	if (ir_debug >= 1)	\
-		printk(arg);	\
+#define dprintk(fmt, ...)			\
+do {						\
+	if (ir_debug >= 1)			\
+		pr_info(fmt, ##__VA_ARGS__);	\
 } while (0)
 
 #define DEVNAME "bttv-input"
@@ -62,7 +65,7 @@ static void ir_handle_key(struct bttv *btv)
 
 	/* extract data */
 	data = ir_extract_bits(gpio, ir->mask_keycode);
-	dprintk(KERN_INFO DEVNAME ": irq gpio=0x%x code=%d | %s%s%s\n",
+	dprintk("irq gpio=0x%x code=%d | %s%s%s\n",
 		gpio, data,
 		ir->polling               ? "poll"  : "irq",
 		(gpio & ir->mask_keydown) ? " down" : "",
@@ -96,7 +99,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 	keyup = (gpio & ir->mask_keyup) ? 1 << 31 : 0;
 
 	if ((ir->last_gpio & 0x7f) != data) {
-		dprintk(KERN_INFO DEVNAME ": gpio=0x%x code=%d | %s\n",
+		dprintk("gpio=0x%x code=%d | %s\n",
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "up/down");
 
@@ -107,7 +110,7 @@ static void ir_enltv_handle_key(struct bttv *btv)
 		if ((ir->last_gpio & 1 << 31) == keyup)
 			return;
 
-		dprintk(KERN_INFO DEVNAME ":(cnt) gpio=0x%x code=%d | %s\n",
+		dprintk("(cnt) gpio=0x%x code=%d | %s\n",
 			gpio, data,
 			(gpio & ir->mask_keyup) ? " up" : "down");
 
@@ -177,13 +180,12 @@ static u32 bttv_rc5_decode(unsigned int code)
 			rc5 |= 1;
 		break;
 		case 3:
-			dprintk(KERN_INFO DEVNAME ":rc5_decode(%x) bad code\n",
+			dprintk("rc5_decode(%x) bad code\n",
 				org_code);
 			return 0;
 		}
 	}
-	dprintk(KERN_INFO DEVNAME ":"
-		"code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
+	dprintk("code=%x, rc5=%x, start=%x, toggle=%x, address=%x, "
 		"instr=%x\n", rc5, org_code, RC5_START(rc5),
 		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
 	return rc5;
@@ -212,20 +214,20 @@ static void bttv_rc5_timer_end(unsigned long data)
 
 	/* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
 	if (gap < 28000) {
-		dprintk(KERN_INFO DEVNAME ": spurious timer_end\n");
+		dprintk("spurious timer_end\n");
 		return;
 	}
 
 	if (ir->last_bit < 20) {
 		/* ignore spurious codes (caused by light/other remotes) */
-		dprintk(KERN_INFO DEVNAME ": short code: %x\n", ir->code);
+		dprintk("short code: %x\n", ir->code);
 	} else {
 		ir->code = (ir->code << ir->shift_by) | 1;
 		rc5 = bttv_rc5_decode(ir->code);
 
 		/* two start bits? */
 		if (RC5_START(rc5) != ir->start) {
-			printk(KERN_INFO DEVNAME ":"
+			pr_info(DEVNAME ":"
 			       " rc5 start bits invalid: %u\n", RC5_START(rc5));
 
 			/* right address? */
@@ -235,8 +237,7 @@ static void bttv_rc5_timer_end(unsigned long data)
 
 			/* Good code */
 			rc_keydown(ir->dev, instr, toggle);
-			dprintk(KERN_INFO DEVNAME ":"
-				" instruction %x, toggle %x\n",
+			dprintk("instruction %x, toggle %x\n",
 				instr, toggle);
 		}
 	}
@@ -265,7 +266,7 @@ static int bttv_rc5_irq(struct bttv *btv)
 		    tv.tv_usec - ir->base_time.tv_usec;
 	}
 
-	dprintk(KERN_INFO DEVNAME ": RC5 IRQ: gap %d us for %s\n",
+	dprintk("RC5 IRQ: gap %d us for %s\n",
 		gap, (gpio & 0x20) ? "mark" : "space");
 
 	/* remote IRQ? */
@@ -340,14 +341,14 @@ static int get_key_pv951(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 
 	/* poll IR chip */
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		dprintk(KERN_INFO DEVNAME ": read error\n");
+		dprintk("read error\n");
 		return -EIO;
 	}
 
 	/* ignore 0xaa */
 	if (b==0xaa)
 		return 0;
-	dprintk(KERN_INFO DEVNAME ": key %02x\n", b);
+	dprintk("key %02x\n", b);
 
 	/*
 	 * NOTE:
@@ -517,7 +518,7 @@ int bttv_input_init(struct bttv *btv)
 		break;
 	}
 	if (NULL == ir_codes) {
-		dprintk(KERN_INFO "Ooops: IR config error [card=%d]\n", btv->c.type);
+		dprintk("Ooops: IR config error [card=%d]\n", btv->c.type);
 		err = -ENODEV;
 		goto err_out_free;
 	}
diff --git a/drivers/media/video/bt8xx/bttv-risc.c b/drivers/media/video/bt8xx/bttv-risc.c
index 9b57d09..82cc47d 100644
--- a/drivers/media/video/bt8xx/bttv-risc.c
+++ b/drivers/media/video/bt8xx/bttv-risc.c
@@ -24,6 +24,8 @@
 
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -473,8 +475,7 @@ bttv_set_dma(struct bttv *btv, int override)
 	capctl |= (btv->cap_ctl & 0x0c) ? 0x0c : 0x00;  /* vbi data */
 	capctl |= override;
 
-	d2printk(KERN_DEBUG
-		 "bttv%d: capctl=%x lirq=%d top=%08Lx/%08Lx even=%08Lx/%08Lx\n",
+	d2printk("%d: capctl=%x lirq=%d top=%08llx/%08llx even=%08llx/%08llx\n",
 		 btv->c.nr,capctl,btv->loop_irq,
 		 btv->cvbi         ? (unsigned long long)btv->cvbi->top.dma            : 0,
 		 btv->curr.top     ? (unsigned long long)btv->curr.top->top.dma        : 0,
@@ -517,8 +518,8 @@ bttv_risc_init_main(struct bttv *btv)
 
 	if ((rc = btcx_riscmem_alloc(btv->c.pci,&btv->main,PAGE_SIZE)) < 0)
 		return rc;
-	dprintk(KERN_DEBUG "bttv%d: risc main @ %08Lx\n",
-		btv->c.nr,(unsigned long long)btv->main.dma);
+	dprintk("%d: risc main @ %08llx\n",
+		btv->c.nr, (unsigned long long)btv->main.dma);
 
 	btv->main.cpu[0] = cpu_to_le32(BT848_RISC_SYNC | BT848_RISC_RESYNC |
 				       BT848_FIFO_STATUS_VRE);
@@ -557,12 +558,12 @@ bttv_risc_hook(struct bttv *btv, int slot, struct btcx_riscmem *risc,
 	unsigned long next = btv->main.dma + ((slot+2) << 2);
 
 	if (NULL == risc) {
-		d2printk(KERN_DEBUG "bttv%d: risc=%p slot[%d]=NULL\n",
-			 btv->c.nr,risc,slot);
+		d2printk("%d: risc=%p slot[%d]=NULL\n", btv->c.nr, risc, slot);
 		btv->main.cpu[slot+1] = cpu_to_le32(next);
 	} else {
-		d2printk(KERN_DEBUG "bttv%d: risc=%p slot[%d]=%08Lx irq=%d\n",
-			 btv->c.nr,risc,slot,(unsigned long long)risc->dma,irqflags);
+		d2printk("%d: risc=%p slot[%d]=%08llx irq=%d\n",
+			 btv->c.nr, risc, slot,
+			 (unsigned long long)risc->dma, irqflags);
 		cmd = BT848_RISC_JUMP;
 		if (irqflags) {
 			cmd |= BT848_RISC_IRQ;
@@ -708,8 +709,7 @@ bttv_buffer_risc(struct bttv *btv, struct bttv_buffer *buf)
 	const struct bttv_tvnorm *tvnorm = bttv_tvnorms + buf->tvnorm;
 	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 
-	dprintk(KERN_DEBUG
-		"bttv%d: buffer field: %s  format: %s  size: %dx%d\n",
+	dprintk("%d: buffer field: %s  format: %s  size: %dx%d\n",
 		btv->c.nr, v4l2_field_names[buf->vb.field],
 		buf->fmt->name, buf->vb.width, buf->vb.height);
 
@@ -870,10 +870,9 @@ bttv_overlay_risc(struct bttv *btv,
 		  struct bttv_buffer *buf)
 {
 	/* check interleave, bottom+top fields */
-	dprintk(KERN_DEBUG
-		"bttv%d: overlay fields: %s format: %s  size: %dx%d\n",
+	dprintk("%d: overlay fields: %s format: %s  size: %dx%d\n",
 		btv->c.nr, v4l2_field_names[buf->vb.field],
-		fmt->name,ov->w.width,ov->w.height);
+		fmt->name, ov->w.width, ov->w.height);
 
 	/* calculate geometry */
 	bttv_calc_geo(btv,&buf->geo,ov->w.width,ov->w.height,
diff --git a/drivers/media/video/bt8xx/bttv-vbi.c b/drivers/media/video/bt8xx/bttv-vbi.c
index e79a402..b433267 100644
--- a/drivers/media/video/bt8xx/bttv-vbi.c
+++ b/drivers/media/video/bt8xx/bttv-vbi.c
@@ -23,6 +23,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -65,8 +67,11 @@ MODULE_PARM_DESC(vbi_debug,"vbi code debug messages, default is 0 (no)");
 #ifdef dprintk
 # undef dprintk
 #endif
-#define dprintk(fmt, arg...)	if (vbi_debug) \
-	printk(KERN_DEBUG "bttv%d/vbi: " fmt, btv->c.nr , ## arg)
+#define dprintk(fmt, ...)						\
+do {									\
+	if (vbi_debug)							\
+		pr_debug("%d: " fmt, btv->c.nr, ##__VA_ARGS__);		\
+} while (0)
 
 #define IMAGE_SIZE(fmt) \
 	(((fmt)->count[0] + (fmt)->count[1]) * (fmt)->samples_per_line)
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 318edf2..db943a8d 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -310,9 +310,21 @@ extern unsigned int bttv_gpio;
 extern void bttv_gpio_tracking(struct bttv *btv, char *comment);
 extern int init_bttv_i2c(struct bttv *btv);
 
-#define bttv_printk if (bttv_verbose) printk
-#define dprintk  if (bttv_debug >= 1) printk
-#define d2printk if (bttv_debug >= 2) printk
+#define dprintk(fmt, ...)			\
+do {						\
+	if (bttv_debug >= 1)			\
+		pr_debug(fmt, ##__VA_ARGS__);	\
+} while (0)
+#define dprintk_cont(fmt, ...)			\
+do {						\
+	if (bttv_debug >= 1)			\
+		pr_cont(fmt, ##__VA_ARGS__);	\
+} while (0)
+#define d2printk(fmt, ...)			\
+do {						\
+	if (bttv_debug >= 2)			\
+		printk(fmt, ##__VA_ARGS__);	\
+} while (0)
 
 #define BTTV_MAX_FBUF   0x208000
 #define BTTV_TIMEOUT    msecs_to_jiffies(500)    /* 0.5 seconds */
-- 
1.7.6.405.gc1be0

