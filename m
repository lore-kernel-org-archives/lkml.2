Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab2IEGdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:33:23 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36884 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2IEGdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:33:22 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 14:33:21 +0800
Message-ID: <CAPgLHd_1T4S9pngzO=GXthvMD6Ke6xA3t_ZTbvLYRG+TS+2j=w@mail.gmail.com>
Subject: [PATCH] ALSA: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: clemens@ladisch.de, perex@perex.cz, tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/drivers/opl4/opl4_synth.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/drivers/opl4/opl4_synth.c b/sound/drivers/opl4/opl4_synth.c
index 49b9e24..4b91adc 100644
--- a/sound/drivers/opl4/opl4_synth.c
+++ b/sound/drivers/opl4/opl4_synth.c
@@ -504,8 +504,7 @@ void snd_opl4_note_on(void *private_data, int note, int vel, struct snd_midi_cha
 	spin_lock_irqsave(&opl4->reg_lock, flags);
 	for (i = 0; i < voices; i++) {
 		voice[i] = snd_opl4_get_voice(opl4);
-		list_del(&voice[i]->list);
-		list_add_tail(&voice[i]->list, &opl4->on_voices);
+		list_move_tail(&voice[i]->list, &opl4->on_voices);
 		voice[i]->chan = chan;
 		voice[i]->note = note;
 		voice[i]->velocity = vel & 0x7f;
@@ -555,8 +554,7 @@ void snd_opl4_note_on(void *private_data, int note, int vel, struct snd_midi_cha
 
 static void snd_opl4_voice_off(struct snd_opl4 *opl4, struct opl4_voice *voice)
 {
-	list_del(&voice->list);
-	list_add_tail(&voice->list, &opl4->off_voices);
+	list_move_tail(&voice->list, &opl4->off_voices);
 
 	voice->reg_misc &= ~OPL4_KEY_ON_BIT;
 	snd_opl4_write(opl4, OPL4_REG_MISC + voice->number, voice->reg_misc);
@@ -571,8 +569,7 @@ void snd_opl4_note_off(void *private_data, int note, int vel, struct snd_midi_ch
 
 static void snd_opl4_terminate_voice(struct snd_opl4 *opl4, struct opl4_voice *voice)
 {
-	list_del(&voice->list);
-	list_add_tail(&voice->list, &opl4->off_voices);
+	list_move_tail(&voice->list, &opl4->off_voices);
 
 	voice->reg_misc = (voice->reg_misc & ~OPL4_KEY_ON_BIT) | OPL4_DAMP_BIT;
 	snd_opl4_write(opl4, OPL4_REG_MISC + voice->number, voice->reg_misc);

