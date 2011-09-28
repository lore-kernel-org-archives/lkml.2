Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1I1Wsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322Ab1I1Wso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.400551210@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, Takashi Iwai <tiwai@suse.de>
Subject: [209/244] ALSA: fm801: Fix double free in case of error in tuner detection
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 2ba34e43ba0469086d1ff81c13a9aa9070c1a0e1 upstream.

Commit 9676001559fce06e37c7dc230ab275f605556176
("ALSA: fm801: add error handling if auto-detect fails") added
incorrect error handling.

Once we have successfully called snd_device_new(), the cleanup
function fm801_free() will automatically be called by snd_card_free()
and we must *not* also call fm801_free() directly.

Reported-by: Hor Jiun Shyong <jiunshyong@gmail.com>
References: http://bugs.debian.org/641946
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/fm801.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1236,7 +1236,6 @@ static int __devinit snd_fm801_create(st
 	    (tea575x_tuner & TUNER_TYPE_MASK) < 4) {
 		if (snd_tea575x_init(&chip->tea)) {
 			snd_printk(KERN_ERR "TEA575x radio not found\n");
-			snd_fm801_free(chip);
 			return -ENODEV;
 		}
 	} else if ((tea575x_tuner & TUNER_TYPE_MASK) == 0) {
@@ -1251,7 +1250,6 @@ static int __devinit snd_fm801_create(st
 		}
 		if (tea575x_tuner == 4) {
 			snd_printk(KERN_ERR "TEA575x radio not found\n");
-			snd_fm801_free(chip);
 			return -ENODEV;
 		}
 	}


