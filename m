Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab2BJXHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:07:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab2BJWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:20 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.549652276@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 62/86] ALSA: oxygen, virtuoso: fix exchanged L/R volumes of aux and CD inputs
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 2492250e4412c6411324c14ab289629360640b0a upstream.

The driver accidentally exchanged the left/right fields for stereo AC'97
mixer registers.  This affected only the aux and CD inputs because the
line input bypasses the AC'97 codec and the mic input is mono; cards
without AC'97 (Xonar DS/DG/HDAV Slim, HG2PCI, HiFier) were not affected.

Reported-and-tested-by: Abby Cedar <abbycedar@yahoo.com.au>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/oxygen/oxygen_mixer.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -618,9 +618,12 @@ static int ac97_volume_get(struct snd_kc
 	mutex_lock(&chip->mutex);
 	reg = oxygen_read_ac97(chip, codec, index);
 	mutex_unlock(&chip->mutex);
-	value->value.integer.value[0] = 31 - (reg & 0x1f);
-	if (stereo)
-		value->value.integer.value[1] = 31 - ((reg >> 8) & 0x1f);
+	if (!stereo) {
+		value->value.integer.value[0] = 31 - (reg & 0x1f);
+	} else {
+		value->value.integer.value[0] = 31 - ((reg >> 8) & 0x1f);
+		value->value.integer.value[1] = 31 - (reg & 0x1f);
+	}
 	return 0;
 }
 
@@ -636,14 +639,14 @@ static int ac97_volume_put(struct snd_kc
 
 	mutex_lock(&chip->mutex);
 	oldreg = oxygen_read_ac97(chip, codec, index);
-	newreg = oldreg;
-	newreg = (newreg & ~0x1f) |
-		(31 - (value->value.integer.value[0] & 0x1f));
-	if (stereo)
-		newreg = (newreg & ~0x1f00) |
-			((31 - (value->value.integer.value[1] & 0x1f)) << 8);
-	else
-		newreg = (newreg & ~0x1f00) | ((newreg & 0x1f) << 8);
+	if (!stereo) {
+		newreg = oldreg & ~0x1f;
+		newreg |= 31 - (value->value.integer.value[0] & 0x1f);
+	} else {
+		newreg = oldreg & ~0x1f1f;
+		newreg |= (31 - (value->value.integer.value[0] & 0x1f)) << 8;
+		newreg |= 31 - (value->value.integer.value[1] & 0x1f);
+	}
 	change = newreg != oldreg;
 	if (change)
 		oxygen_write_ac97(chip, codec, index, newreg);


