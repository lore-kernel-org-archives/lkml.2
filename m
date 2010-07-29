Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0G2Krc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:47:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59468 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab0G2Kra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qbg/UgOAVj2WAq6E5cxsLS4Bl2BzydOQwaF33Y/yy74MHHsKcU+3TDPjb5PU3iMvzq
         nKwTlrg6PRCJu1F1A7LDvpkevgqSucDlfVsTSzDLhvlvFVIT+OsDk9P4g2Nix6t8CCWn
         PZ7DvY53ZiZIB3iAaxm14PHgyZ5cOKkkpM58w=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Veliath <andrewtv@usa.net>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10 v2] oss: msnd: check request_region() return value
Date: Thu, 29 Jul 2010 14:45:50 +0400
Message-Id: <1280400351-11652-1-git-send-email-segooon@gmail.com>
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

