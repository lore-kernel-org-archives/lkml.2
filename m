Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2LMPIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:08:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab2LMOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 021/241] ALSA: PCM: Fix some races at disconnection
Date: Thu, 13 Dec 2012 11:56:26 -0200
Message-Id: <1355407206-17100-22-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9b0573c07f278e9888c352aa9724035c75784ea0 upstream.

Fix races at PCM disconnection:
- while a PCM device is being opened or closed
- while the PCM state is being changed without lock in prepare,
  hw_params, hw_free ops

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/core/pcm.c        |    7 ++++++-
 sound/core/pcm_native.c |   16 ++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 1a3070b..099f3fd 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1086,11 +1086,15 @@ static int snd_pcm_dev_disconnect(struct snd_device *device)
 	if (list_empty(&pcm->list))
 		goto unlock;
 
+	mutex_lock(&pcm->open_mutex);
 	list_del_init(&pcm->list);
 	for (cidx = 0; cidx < 2; cidx++)
-		for (substream = pcm->streams[cidx].substream; substream; substream = substream->next)
+		for (substream = pcm->streams[cidx].substream; substream; substream = substream->next) {
+			snd_pcm_stream_lock_irq(substream);
 			if (substream->runtime)
 				substream->runtime->status->state = SNDRV_PCM_STATE_DISCONNECTED;
+			snd_pcm_stream_unlock_irq(substream);
+		}
 	list_for_each_entry(notify, &snd_pcm_notify_list, list) {
 		notify->n_disconnect(pcm);
 	}
@@ -1106,6 +1110,7 @@ static int snd_pcm_dev_disconnect(struct snd_device *device)
 		}
 		snd_unregister_device(devtype, pcm->card, pcm->device);
 	}
+	mutex_unlock(&pcm->open_mutex);
  unlock:
 	mutex_unlock(&register_mutex);
 	return 0;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 53b5ada..f030643 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -369,6 +369,14 @@ static int period_to_usecs(struct snd_pcm_runtime *runtime)
 	return usecs;
 }
 
+static void snd_pcm_set_state(struct snd_pcm_substream *substream, int state)
+{
+	snd_pcm_stream_lock_irq(substream);
+	if (substream->runtime->status->state != SNDRV_PCM_STATE_DISCONNECTED)
+		substream->runtime->status->state = state;
+	snd_pcm_stream_unlock_irq(substream);
+}
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
@@ -452,7 +460,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 		runtime->boundary *= 2;
 
 	snd_pcm_timer_resolution_change(substream);
-	runtime->status->state = SNDRV_PCM_STATE_SETUP;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_SETUP);
 
 	if (pm_qos_request_active(&substream->latency_pm_qos_req))
 		pm_qos_remove_request(&substream->latency_pm_qos_req);
@@ -464,7 +472,7 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	/* hardware might be unusable from this time,
 	   so we force application to retry to set
 	   the correct hardware parameter settings */
-	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	if (substream->ops->hw_free != NULL)
 		substream->ops->hw_free(substream);
 	return err;
@@ -512,7 +520,7 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 		return -EBADFD;
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
-	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
 	return result;
 }
@@ -1320,7 +1328,7 @@ static void snd_pcm_post_prepare(struct snd_pcm_substream *substream, int state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	runtime->control->appl_ptr = runtime->status->hw_ptr;
-	runtime->status->state = SNDRV_PCM_STATE_PREPARED;
+	snd_pcm_set_state(substream, SNDRV_PCM_STATE_PREPARED);
 }
 
 static struct action_ops snd_pcm_action_prepare = {
-- 
1.7.9.5

