Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0G2KuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:50:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51982 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0G2KuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V0Qc0+uXRruTbIfkup4L8BEgqlNA9zu9V3WydQ3e2uVmTCYFPSSZ5SFrP3hc/orkq7
         Frq9FUFeGOhL+/FoLl0UFdESx2YE4hR8f/0M8bZC+sl2VinR6ppPvYOLoV38NIJeQwVD
         K6Xuu4n9aDHTq68E/4Lv/pcqNcHirTF3C7XRY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Veliath <andrewtv@usa.net>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10 v2] oss: msnd: check request_region() return value
Date: Thu, 29 Jul 2010 14:48:16 +0400
Message-Id: <1280400496-21921-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_region() may fail, if so return -EBUSY.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/oss/msnd_pinnacle.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index bfaac5f..cd70b9a 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -1400,9 +1400,13 @@ static int __init attach_multisound(void)
 		printk(KERN_ERR LOGNAME ": Couldn't grab IRQ %d\n", dev.irq);
 		return err;
 	}
-	request_region(dev.io, dev.numio, dev.name);
+	if (request_region(dev.io, dev.numio, dev.name) == NULL) {
+		free_irq(dev.irq, &dev);
+		return -EBUSY;
+	}
 
-        if ((err = dsp_full_reset()) < 0) {
+	err = dsp_full_reset();
+	if (err < 0) {
 		release_region(dev.io, dev.numio);
 		free_irq(dev.irq, &dev);
 		return err;
-- 
1.7.0.4

