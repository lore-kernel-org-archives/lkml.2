Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194Ab0J1UCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:02:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45408 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab0J1UCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OeO/Wc72Mlmr7GA+3eTAA21GWEqcFiY/PW61YjIIyFQoGNueTQsd4nDBV5zPd5Kiir
         AAY51QVEcSUuthl3zBrCDXwbYcW3HiyLYBNeTaK0pHGr5dbDtdkKPLtsqQFYaKQa1DFd
         Xc/W/kNsPlqtKzXvGDrOUQjepJVd5+LdrfZp8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] staging: dream: fix information leak to userland
Date: Fri, 29 Oct 2010 00:01:56 +0400
Message-Id: <1288296117-19167-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure msm_audio_stats is copied to userland with some fields unitialized.
It leads to leaking of contents of kernel stack memory.
Also struct msm_audio_config has field "unused" of type array of 3 elements,
not 4.  Instead of this, initialize field "type".

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/dream/qdsp5/audio_mp3.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
index 409a19c..694f1dd 100644
--- a/drivers/staging/dream/qdsp5/audio_mp3.c
+++ b/drivers/staging/dream/qdsp5/audio_mp3.c
@@ -533,6 +533,7 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	if (cmd == AUDIO_GET_STATS) {
 		struct msm_audio_stats stats;
+		memset(&stats, 0, sizeof(stats));
 		stats.byte_count = audpp_avsync_byte_count(audio->dec_id);
 		stats.sample_count = audpp_avsync_sample_count(audio->dec_id);
 		if (copy_to_user((void *) arg, &stats, sizeof(stats)))
@@ -602,10 +603,10 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		} else {
 			config.channel_count = 2;
 		}
+		config.type = 0;
 		config.unused[0] = 0;
 		config.unused[1] = 0;
 		config.unused[2] = 0;
-		config.unused[3] = 0;
 		if (copy_to_user((void *) arg, &config, sizeof(config))) {
 			rc = -EFAULT;
 		} else {
-- 
1.7.0.4

