Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2ILXeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:34:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2ILXeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:34:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 059/108] ALSA: usb-audio: Fix scheduling-while-atomic bug in PCM capture stream
Date: Wed, 12 Sep 2012 16:28:57 -0700
Message-Id: <20120912232456.729849839@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit e9ba389c5ffc4dd29dfe17e00e48877302111135 upstream.

A PCM capture stream on usb-audio causes a scheduling-while-atomic
BUG, as reported in the bugzilla entry below.  It's because
snd_usb_endpoint_start() is called at first at trigger START for a
capture stream, and this function contains the left-over EP
deactivation codes.  The problem doesn't happen for a playback stream
because the function is called at PCM prepare time, which can sleep.

This patch fixes the BUG by moving the EP deactivation code into the
PCM prepare callback.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=46011
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/endpoint.c |    4 ----
 sound/usb/pcm.c      |    3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -821,10 +821,6 @@ int snd_usb_endpoint_start(struct snd_us
 	if (++ep->use_count != 1)
 		return 0;
 
-	/* just to be sure */
-	deactivate_urbs(ep, 0, 1);
-	wait_clear_urbs(ep);
-
 	ep->active_mask = 0;
 	ep->unlink_mask = 0;
 	ep->phase = 0;
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -544,6 +544,9 @@ static int snd_usb_pcm_prepare(struct sn
 	subs->last_frame_number = 0;
 	runtime->delay = 0;
 
+	/* clear the pending deactivation on the target EPs */
+	deactivate_endpoints(subs);
+
 	/* for playback, submit the URBs now; otherwise, the first hwptr_done
 	 * updates for all URBs would happen at the same time when starting */
 	if (subs->direction == SNDRV_PCM_STREAM_PLAYBACK)


