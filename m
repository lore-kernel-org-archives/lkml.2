Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2KNGJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:09:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54930 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab2KNFt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:59 -0500
Message-Id: <20121114053934.780894499@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>,
        Matthieu CASTET <matthieu.castet@parrot.com>
Subject: [ 07/82] ALSA: PCM: Fix some races at disconnection
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9b0573c07f278e9888c352aa9724035c75784ea0 upstream.

Fix races at PCM disconnection:
- while a PCM device is being opened or closed
- while the PCM state is being changed without lock in prepare,
  hw_params, hw_free ops

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/pcm.c        |  7 ++++++-
 sound/core/pcm_native.c | 16 ++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 8928ca87..86440e4 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1046,11 +1046,15 @@ static int snd_pcm_dev_disconnect(struct snd_device *device)
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
@@ -1066,6 +1070,7 @@ static int snd_pcm_dev_disconnect(struct snd_device *device)
 		}
 		snd_unregister_device(devtype, pcm->card, pcm->device);
 	}
+	mutex_unlock(&pcm->open_mutex);
  unlock:
 	mutex_unlock(&register_mutex);
 	return 0;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 25ed9fe..e62da93 100644
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


