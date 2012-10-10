Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab2JKA07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:26:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36598 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933508Ab2JKA0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:26:01 -0400
X-Sasl-enc: ZBaHVLuRwFZx2ARyYQKaQKZPbz9Ku+KvTSyNvF5BQgm7 1349915160
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dylan Reid <dgreid@chromium.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 109/122] ALSA: hda - Fix hang caused by race during suspend.
Date: Thu, 11 Oct 2012 07:54:35 +0900
Message-Id: <20121010225357.626114246@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit d17344b3547669f5b6ee4fda993d03737a141bd6 upstream.

There was a race condition when the system suspends while hda_power_work
is running in the work queue.  If system suspend (snd_hda_suspend)
happens after the work queue releases power_lock but before it calls
hda_call_codec_suspend,  codec_suspend runs with power_on=0, causing the
codec to power up for register reads, and hanging when it calls
cancel_delayed_work_sync from the running work queue.

The call chain from the work queue will look like this:
hda_power_work <<- power_on = 1, unlock, then power_on cleard by suspend
  hda_call_codec_suspend
    hda_set_power_state
      snd_hda_codec_read
        codec_exec_verb
          snd_hda_power_up
	    snd_hda_power_save
	      __snd_hda_power_up
	        cancel_delayed_work_sync <<-- cancelling executing wq

Fix this by waiting for the work queue to finish before starting suspend
if suspend is not happening on the work queue.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3580,7 +3580,7 @@ static inline void hda_exec_init_verbs(s
 /*
  * call suspend and power-down; used both from PM and power-save
  */
-static void hda_call_codec_suspend(struct hda_codec *codec)
+static void hda_call_codec_suspend(struct hda_codec *codec, bool in_wq)
 {
 	if (codec->patch_ops.suspend)
 		codec->patch_ops.suspend(codec);
@@ -3589,7 +3589,9 @@ static void hda_call_codec_suspend(struc
 			    codec->afg ? codec->afg : codec->mfg,
 			    AC_PWRST_D3);
 #ifdef CONFIG_SND_HDA_POWER_SAVE
-	cancel_delayed_work(&codec->power_work);
+	/* Cancel delayed work if we aren't currently running from it. */
+	if (!in_wq)
+		cancel_delayed_work_sync(&codec->power_work);
 	spin_lock(&codec->power_lock);
 	snd_hda_update_power_acct(codec);
 	trace_hda_power_down(codec);
@@ -4410,7 +4412,7 @@ static void hda_power_work(struct work_s
 	}
 	spin_unlock(&codec->power_lock);
 
-	hda_call_codec_suspend(codec);
+	hda_call_codec_suspend(codec, true);
 	if (bus->ops.pm_notify)
 		bus->ops.pm_notify(bus);
 }
@@ -5076,7 +5078,7 @@ int snd_hda_suspend(struct hda_bus *bus)
 
 	list_for_each_entry(codec, &bus->codec_list, list) {
 		if (hda_codec_is_power_on(codec))
-			hda_call_codec_suspend(codec);
+			hda_call_codec_suspend(codec, false);
 	}
 	return 0;
 }


