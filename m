Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2IBOKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 10:10:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54003 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2IBOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 10:10:28 -0400
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 22:10:27 +0800
Message-ID: <CAPgLHd8PAEMY8zan8v+DTrPpyid4Lbnr4LsNvWoZqi4r5opTaw@mail.gmail.com>
Subject: [PATCH] ALSA: fix possible memory leak in snd_mixer_oss_build_input()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: perex@perex.cz, tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

uinfo has been allocated in this function and should be
freed before leaving from the error handling cases.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/core/oss/mixer_oss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 18297f7..29f6ded 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1046,6 +1046,7 @@ static int snd_mixer_oss_build_input(struct snd_mixer_oss *mixer, struct snd_mix
 			
 		if (kctl->info(kctl, uinfo)) {
 			up_read(&mixer->card->controls_rwsem);
+			kfree(uinfo);
 			return 0;
 		}
 		strcpy(str, ptr->name);
@@ -1061,6 +1062,7 @@ static int snd_mixer_oss_build_input(struct snd_mixer_oss *mixer, struct snd_mix
 				uinfo->value.enumerated.item = slot.capture_item;
 				if (kctl->info(kctl, uinfo)) {
 					up_read(&mixer->card->controls_rwsem);
+					kfree(uinfo);
 					return 0;
 				}
 				if (!strcmp(uinfo->value.enumerated.name, str)) {


