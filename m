Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab2IMAZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:25:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab2ILXfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:35:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 073/108] ALSA: snd-usb: Fix URB cancellation at stream start
Date: Wed, 12 Sep 2012 16:29:11 -0700
Message-Id: <20120912232458.173297527@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 015618b902ae8e28705b7af9b4668615fea48ddd upstream.

Commit e9ba389c5 ("ALSA: usb-audio: Fix scheduling-while-atomic bug in
PCM capture stream") fixed a scheduling-while-atomic bug that happened
when snd_usb_endpoint_start was called from the trigger callback, which
is an atmic context. However, the patch breaks the idea of the endpoints
reference counting, which is the reason why the driver has been
refactored lately.

Revert that commit and let snd_usb_endpoint_start() take care of the URB
cancellation again. As this function is called from both atomic and
non-atomic context, add a flag to denote whether the function may sleep.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/endpoint.c |   11 +++++++++--
 sound/usb/endpoint.h |    2 +-
 sound/usb/pcm.c      |   13 +++++--------
 3 files changed, 15 insertions(+), 11 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -799,7 +799,9 @@ int snd_usb_endpoint_set_params(struct s
 /**
  * snd_usb_endpoint_start: start an snd_usb_endpoint
  *
- * @ep: the endpoint to start
+ * @ep:		the endpoint to start
+ * @can_sleep:	flag indicating whether the operation is executed in
+ * 		non-atomic context
  *
  * A call to this function will increment the use count of the endpoint.
  * In case it is not already running, the URBs for this endpoint will be
@@ -809,7 +811,7 @@ int snd_usb_endpoint_set_params(struct s
  *
  * Returns an error if the URB submission failed, 0 in all other cases.
  */
-int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_start(struct snd_usb_endpoint *ep, int can_sleep)
 {
 	int err;
 	unsigned int i;
@@ -821,6 +823,11 @@ int snd_usb_endpoint_start(struct snd_us
 	if (++ep->use_count != 1)
 		return 0;
 
+	/* just to be sure */
+	deactivate_urbs(ep, 0, can_sleep);
+	if (can_sleep)
+		wait_clear_urbs(ep);
+
 	ep->active_mask = 0;
 	ep->unlink_mask = 0;
 	ep->phase = 0;
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -13,7 +13,7 @@ int snd_usb_endpoint_set_params(struct s
 				struct audioformat *fmt,
 				struct snd_usb_endpoint *sync_ep);
 
-int  snd_usb_endpoint_start(struct snd_usb_endpoint *ep);
+int  snd_usb_endpoint_start(struct snd_usb_endpoint *ep, int can_sleep);
 void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep,
 			   int force, int can_sleep, int wait);
 int  snd_usb_endpoint_activate(struct snd_usb_endpoint *ep);
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -212,7 +212,7 @@ int snd_usb_init_pitch(struct snd_usb_au
 	}
 }
 
-static int start_endpoints(struct snd_usb_substream *subs)
+static int start_endpoints(struct snd_usb_substream *subs, int can_sleep)
 {
 	int err;
 
@@ -225,7 +225,7 @@ static int start_endpoints(struct snd_us
 		snd_printdd(KERN_DEBUG "Starting data EP @%p\n", ep);
 
 		ep->data_subs = subs;
-		err = snd_usb_endpoint_start(ep);
+		err = snd_usb_endpoint_start(ep, can_sleep);
 		if (err < 0) {
 			clear_bit(SUBSTREAM_FLAG_DATA_EP_STARTED, &subs->flags);
 			return err;
@@ -239,7 +239,7 @@ static int start_endpoints(struct snd_us
 		snd_printdd(KERN_DEBUG "Starting sync EP @%p\n", ep);
 
 		ep->sync_slave = subs->data_endpoint;
-		err = snd_usb_endpoint_start(ep);
+		err = snd_usb_endpoint_start(ep, can_sleep);
 		if (err < 0) {
 			clear_bit(SUBSTREAM_FLAG_SYNC_EP_STARTED, &subs->flags);
 			return err;
@@ -544,13 +544,10 @@ static int snd_usb_pcm_prepare(struct sn
 	subs->last_frame_number = 0;
 	runtime->delay = 0;
 
-	/* clear the pending deactivation on the target EPs */
-	deactivate_endpoints(subs);
-
 	/* for playback, submit the URBs now; otherwise, the first hwptr_done
 	 * updates for all URBs would happen at the same time when starting */
 	if (subs->direction == SNDRV_PCM_STREAM_PLAYBACK)
-		return start_endpoints(subs);
+		return start_endpoints(subs, 1);
 
 	return 0;
 }
@@ -1175,7 +1172,7 @@ static int snd_usb_substream_capture_tri
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-		err = start_endpoints(subs);
+		err = start_endpoints(subs, 0);
 		if (err < 0)
 			return err;
 


