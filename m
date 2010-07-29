Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab0G2Kpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:45:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56220 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0G2Kpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LWqXuOQiajvzEosloQy6zIaz6ItTC3ALGgM25Al00jTaPlMO8GizDvcT8pWwb+1iZU
         ItU3LfPsDAUhEUzfHzdzQFiZCWz/riTH3S03TZTOWCQqOhFXxyZhWhzgPqjOr4MrYWm8
         slIy858H+zzsoI1pKyPS8j+ZZXTAUE0z65gQQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10 v2] ALSA: msnd: check request_region() return value
Date: Thu, 29 Jul 2010 14:45:24 +0400
Message-Id: <1280400325-9405-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_region() may fail, if so return -EBUSY.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/isa/msnd/msnd_pinnacle.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 60b6abd..ed42f8e 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -549,7 +549,10 @@ static int __devinit snd_msnd_attach(struct snd_card *card)
 		printk(KERN_ERR LOGNAME ": Couldn't grab IRQ %d\n", chip->irq);
 		return err;
 	}
-	request_region(chip->io, DSP_NUMIO, card->shortname);
+	if (request_region(chip->io, DSP_NUMIO, card->shortname) == NULL) {
+		free_irq(chip->irq, chip);
+		return -EBUSY;
+	}
 
 	if (!request_mem_region(chip->base, BUFFSIZE, card->shortname)) {
 		printk(KERN_ERR LOGNAME
-- 
1.7.0.4

