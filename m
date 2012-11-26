Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2KZRC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47247 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2KZRCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dylan Reid <dgreid@chromium.org>, Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 050/270] ALSA: hda - Fix hang caused by race during suspend.
Date: Mon, 26 Nov 2012 14:55:40 -0200
Message-Id: <1353949160-26803-51-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: backported to 3.5:
  * hda_call_codec_suspend doesn't return state
  * adjusted context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/hda_codec.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f1c6164..b1b6238 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3542,7 +3542,7 @@ static inline void hda_exec_init_verbs(struct hda_codec *codec) {}
 /*
  * call suspend and power-down; used both from PM and power-save
  */
-static void hda_call_codec_suspend(struct hda_codec *codec)
+static void hda_call_codec_suspend(struct hda_codec *codec, bool in_wq)
 {
 	if (codec->patch_ops.suspend)
 		codec->patch_ops.suspend(codec, PMSG_SUSPEND);
@@ -3551,7 +3551,9 @@ static void hda_call_codec_suspend(struct hda_codec *codec)
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
@@ -4372,7 +4374,7 @@ static void hda_power_work(struct work_struct *work)
 	}
 	spin_unlock(&codec->power_lock);
 
-	hda_call_codec_suspend(codec);
+	hda_call_codec_suspend(codec, true);
 	if (bus->ops.pm_notify)
 		bus->ops.pm_notify(bus);
 }
@@ -5038,7 +5040,7 @@ int snd_hda_suspend(struct hda_bus *bus)
 
 	list_for_each_entry(codec, &bus->codec_list, list) {
 		if (hda_codec_is_power_on(codec))
-			hda_call_codec_suspend(codec);
+			hda_call_codec_suspend(codec, false);
 	}
 	return 0;
 }
-- 
1.7.9.5

