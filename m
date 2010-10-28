Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166Ab0J1UCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:02:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47060 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574Ab0J1UCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OgihRVtJqW7qSyznSyElJ8rqfdTPTCGfOROSswF3eQ2HQ6Vy5u/cJA8sBwm8sNZvnu
         vI6F6brbCUkKHOIw3ijU0oIyd55Fjl6amlhwNVflbgODF1mUuQg4H6Qy2DzJanZP2Ybz
         zXNQ5N8+0E+sQGPZD4cjF8pb+RefEyHJ051yw=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] staging: dream: fix information leak to userland
Date: Fri, 29 Oct 2010 00:02:01 +0400
Message-Id: <1288296122-19212-1-git-send-email-segooon@gmail.com>
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
 drivers/staging/dream/qdsp5/audio_out.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
index d20e895..923818d 100644
--- a/drivers/staging/dream/qdsp5/audio_out.c
+++ b/drivers/staging/dream/qdsp5/audio_out.c
@@ -496,6 +496,7 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	if (cmd == AUDIO_GET_STATS) {
 		struct msm_audio_stats stats;
+		memset(&stats, 0, sizeof(stats));
 		stats.byte_count = atomic_read(&audio->out_bytes);
 		if (copy_to_user((void*) arg, &stats, sizeof(stats)))
 			return -EFAULT;
@@ -561,10 +562,10 @@ static long audio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		} else {
 			config.channel_count = 2;
 		}
+		config.type = 0;
 		config.unused[0] = 0;
 		config.unused[1] = 0;
 		config.unused[2] = 0;
-		config.unused[3] = 0;
 		if (copy_to_user((void*) arg, &config, sizeof(config))) {
 			rc = -EFAULT;
 		} else {
-- 
1.7.0.4

