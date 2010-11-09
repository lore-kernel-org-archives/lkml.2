Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0KIVv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:51:26 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58970 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab0KIVvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:51:22 -0500
From: Julia Lawall <julia@diku.dk>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de
Subject: [PATCH] sound/pci/ctxfi/ctpcm.c: Remove potential for use after free
Date: Tue,  9 Nov 2010 23:00:41 +0100
Message-Id: <1289340041-15433-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In each function, the value apcm is stored in the private_data field of
runtime.  At the same time the function ct_atc_pcm_free_substream is stored
in the private_free field of the same structure.  ct_atc_pcm_free_substream
dereferences and ultimately frees the value in the private_data field.  But
each function can exit in an error case with apcm having been freed, in
which case a subsequent call to the private_free function would perform a
dereference after free.  On the other hand, if the private_free field is
not initialized, it is NULL, and not invoked (see snd_pcm_detach_substream
in sound/core/pcm.c).  To avoid the introduction of a dangling pointer, the
initializations of the private_data and private_free fields are moved to
the end of the function, past any possible free of apcm.  This is safe
because the previous calls to snd_pcm_hw_constraint_integer and
snd_pcm_hw_constraint_minmax, which take runtime as an argument, do not
refer to either of these fields.

In each function, there is one error case where apcm needs to be freed, and
a call to kfree is added.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1,e2,e3;
identifier f,free1,free2;
expression a;
@@

*e->f = a
... when != e->f = e1
    when any
if (...) {
  ... when != free1(...,e,...)
      when != e->f = e2
* kfree(a)
  ... when != free2(...,e,...)
      when != e->f = e3
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/pci/ctxfi/ctpcm.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/pci/ctxfi/ctpcm.c b/sound/pci/ctxfi/ctpcm.c
index 85ab43e..457d211 100644
--- a/sound/pci/ctxfi/ctpcm.c
+++ b/sound/pci/ctxfi/ctpcm.c
@@ -129,8 +129,6 @@ static int ct_pcm_playback_open(struct snd_pcm_substream *substream)
 
 	apcm->substream = substream;
 	apcm->interrupt = ct_atc_pcm_interrupt;
-	runtime->private_data = apcm;
-	runtime->private_free = ct_atc_pcm_free_substream;
 	if (IEC958 == substream->pcm->device) {
 		runtime->hw = ct_spdif_passthru_playback_hw;
 		atc->spdif_out_passthru(atc, 1);
@@ -155,8 +153,12 @@ static int ct_pcm_playback_open(struct snd_pcm_substream *substream)
 	}
 
 	apcm->timer = ct_timer_instance_new(atc->timer, apcm);
-	if (!apcm->timer)
+	if (!apcm->timer) {
+		kfree(apcm);
 		return -ENOMEM;
+	}
+	runtime->private_data = apcm;
+	runtime->private_free = ct_atc_pcm_free_substream;
 
 	return 0;
 }
@@ -278,8 +280,6 @@ static int ct_pcm_capture_open(struct snd_pcm_substream *substream)
 	apcm->started = 0;
 	apcm->substream = substream;
 	apcm->interrupt = ct_atc_pcm_interrupt;
-	runtime->private_data = apcm;
-	runtime->private_free = ct_atc_pcm_free_substream;
 	runtime->hw = ct_pcm_capture_hw;
 	runtime->hw.rate_max = atc->rsr * atc->msr;
 
@@ -298,8 +298,12 @@ static int ct_pcm_capture_open(struct snd_pcm_substream *substream)
 	}
 
 	apcm->timer = ct_timer_instance_new(atc->timer, apcm);
-	if (!apcm->timer)
+	if (!apcm->timer) {
+		kfree(apcm);
 		return -ENOMEM;
+	}
+	runtime->private_data = apcm;
+	runtime->private_free = ct_atc_pcm_free_substream;
 
 	return 0;
 }

