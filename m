Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab1DZVjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:39:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:41551 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591Ab1DZVNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831560"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: clemens@ladisch.de, ak@linux.intel.com, mailtinoshomepage@gmx.net,
        tiwai@suse.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [13/106] ALSA: ens1371: fix Creative Ectiva support
Message-Id: <20110426211251.718C13E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 6ebb8a4a43e34f999ab36f27f972f3cd751cda4f upstream.

To make the EV1938 chip work, add a magic bit and an extra delay.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Tino Schmidt <mailtinoshomepage@gmx.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ens1370.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/sound/pci/ens1370.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/ens1370.c
+++ linux-2.6.35.y/sound/pci/ens1370.c
@@ -229,6 +229,7 @@ MODULE_PARM_DESC(lineio, "Line In to Rea
 #define ES_REG_1371_CODEC 0x14	/* W/R: Codec Read/Write register address */
 #define   ES_1371_CODEC_RDY	   (1<<31)	/* codec ready */
 #define   ES_1371_CODEC_WIP	   (1<<30)	/* codec register access in progress */
+#define   EV_1938_CODEC_MAGIC	   (1<<26)
 #define   ES_1371_CODEC_PIRD	   (1<<23)	/* codec read/write select register */
 #define   ES_1371_CODEC_WRITE(a,d) ((((a)&0x7f)<<16)|(((d)&0xffff)<<0))
 #define   ES_1371_CODEC_READS(a)   ((((a)&0x7f)<<16)|ES_1371_CODEC_PIRD)
@@ -603,12 +604,18 @@ static void snd_es1370_codec_write(struc
 
 #ifdef CHIP1371
 
+static inline bool is_ev1938(struct ensoniq *ensoniq)
+{
+	return ensoniq->pci->device == 0x8938;
+}
+
 static void snd_es1371_codec_write(struct snd_ac97 *ac97,
 				   unsigned short reg, unsigned short val)
 {
 	struct ensoniq *ensoniq = ac97->private_data;
-	unsigned int t, x;
+	unsigned int t, x, flag;
 
+	flag = is_ev1938(ensoniq) ? EV_1938_CODEC_MAGIC : 0;
 	mutex_lock(&ensoniq->src_mutex);
 	for (t = 0; t < POLL_COUNT; t++) {
 		if (!(inl(ES_REG(ensoniq, 1371_CODEC)) & ES_1371_CODEC_WIP)) {
@@ -630,7 +637,8 @@ static void snd_es1371_codec_write(struc
 				    0x00010000)
 					break;
 			}
-			outl(ES_1371_CODEC_WRITE(reg, val), ES_REG(ensoniq, 1371_CODEC));
+			outl(ES_1371_CODEC_WRITE(reg, val) | flag,
+			     ES_REG(ensoniq, 1371_CODEC));
 			/* restore SRC reg */
 			snd_es1371_wait_src_ready(ensoniq);
 			outl(x, ES_REG(ensoniq, 1371_SMPRATE));
@@ -647,8 +655,9 @@ static unsigned short snd_es1371_codec_r
 					    unsigned short reg)
 {
 	struct ensoniq *ensoniq = ac97->private_data;
-	unsigned int t, x, fail = 0;
+	unsigned int t, x, flag, fail = 0;
 
+	flag = is_ev1938(ensoniq) ? EV_1938_CODEC_MAGIC : 0;
       __again:
 	mutex_lock(&ensoniq->src_mutex);
 	for (t = 0; t < POLL_COUNT; t++) {
@@ -671,7 +680,8 @@ static unsigned short snd_es1371_codec_r
 				    0x00010000)
 					break;
 			}
-			outl(ES_1371_CODEC_READS(reg), ES_REG(ensoniq, 1371_CODEC));
+			outl(ES_1371_CODEC_READS(reg) | flag,
+			     ES_REG(ensoniq, 1371_CODEC));
 			/* restore SRC reg */
 			snd_es1371_wait_src_ready(ensoniq);
 			outl(x, ES_REG(ensoniq, 1371_SMPRATE));
@@ -683,6 +693,11 @@ static unsigned short snd_es1371_codec_r
 			/* now wait for the stinkin' data (RDY) */
 			for (t = 0; t < POLL_COUNT; t++) {
 				if ((x = inl(ES_REG(ensoniq, 1371_CODEC))) & ES_1371_CODEC_RDY) {
+					if (is_ev1938(ensoniq)) {
+						for (t = 0; t < 100; t++)
+							inl(ES_REG(ensoniq, CONTROL));
+						x = inl(ES_REG(ensoniq, 1371_CODEC));
+					}
 					mutex_unlock(&ensoniq->src_mutex);
 					return ES_1371_CODEC_READ(x);
 				}
