Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2DIIQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:16:41 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46603 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab2DIIQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:16:39 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Andrew Veliath <andrewtv@usa.net>
Cc: kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound/oss/msnd_pinnacle.c: add vfrees
Date: Mon,  9 Apr 2012 10:16:32 +0200
Message-Id: <1333959392-18933-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

At the point of this error-handling code, HAVE_DSPCODEH may be undefined,
so free INITCODE and PERMCODE as done elsewhere.  A jump and label are
introduced to avoid code duplication.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/oss/msnd_pinnacle.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index 2c79d60..536c4c0 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -1294,6 +1294,8 @@ static int __init calibrate_adc(WORD srate)
 
 static int upload_dsp_code(void)
 {
+	int ret = 0;
+
 	msnd_outb(HPBLKSEL_0, dev.io + HP_BLKS);
 #ifndef HAVE_DSPCODEH
 	INITCODESIZE = mod_firmware_load(INITCODEFILE, &INITCODE);
@@ -1312,7 +1314,8 @@ static int upload_dsp_code(void)
 	memcpy_toio(dev.base, PERMCODE, PERMCODESIZE);
 	if (msnd_upload_host(&dev, INITCODE, INITCODESIZE) < 0) {
 		printk(KERN_WARNING LOGNAME ": Error uploading to DSP\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 #ifdef HAVE_DSPCODEH
 	printk(KERN_INFO LOGNAME ": DSP firmware uploaded (resident)\n");
@@ -1320,12 +1323,13 @@ static int upload_dsp_code(void)
 	printk(KERN_INFO LOGNAME ": DSP firmware uploaded\n");
 #endif
 
+out:
 #ifndef HAVE_DSPCODEH
 	vfree(INITCODE);
 	vfree(PERMCODE);
 #endif
 
-	return 0;
+	return ret;
 }
 
 #ifdef MSND_CLASSIC

