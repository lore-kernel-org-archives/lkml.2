Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab0HKICN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:02:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36435 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab0HKICJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dfE/OBGz3NLK3lD3296/1TmVEjwA2r6xl3RKhtn1f+0BrK0M/sZkIZD6PboT0cu/7W
         tYZ3COJ31CFv15F1/Cu80o8zboIT6tD1FWljai64xSVRlUFFZ6qieGvLzbV01wzBqTM2
         iL7l7cLezT9LtdzVT5fKO8C0JpQhtZQGJI21U=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stefan Ringel <stefan.ringel@arcor.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        "Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: tm6000: fix memory leak
Date: Wed, 11 Aug 2010 12:01:19 +0400
Message-Id: <1281513681-5395-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original code doesn't call kfree(chip) on error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/tm6000/tm6000-alsa.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 087137d..6c09ef3 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -403,7 +403,7 @@ int tm6000_audio_init(struct tm6000_core *dev)
 
 	rc = snd_pcm_new(card, "TM6000 Audio", 0, 0, 1, &pcm);
 	if (rc < 0)
-		goto error;
+		goto error_chip;
 
 	pcm->info_flags = 0;
 	pcm->private_data = chip;
@@ -413,12 +413,15 @@ int tm6000_audio_init(struct tm6000_core *dev)
 
 	rc = snd_card_register(card);
 	if (rc < 0)
-		goto error;
+		goto error_chip;
 
 	dprintk(1,"Registered audio driver for %s\n", card->longname);
 
 	return 0;
 
+error_chip:
+	kfree(chip);
+	dev->adev = NULL;
 error:
 	snd_card_free(card);
 	return rc;
-- 
1.7.0.4

