Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab2I1S4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:56:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab2I1S40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 055/262] ALSA: usb-audio: Fix bogus error messages for delay accounting
Date: Fri, 28 Sep 2012 11:49:44 -0700
Message-Id: <20120928183004.411329222@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1213a205f9ed27d97de3d5bed28fb085ef4853e2 upstream.

The recent fix for the missing fine delayed time adjustment gives
strange error messages at each start of the playback stream, such as
  delay: estimated 0, actual 352
  delay: estimated 353, actual 705

These come from the sanity check in retire_playback_urb().  Before the
stream is activated via start_endpoints(), a few silent packets have
been already sent.  And at this point the delay account is still in
the state as if the new packets are just queued, so the driver gets
confused and spews the bogus error messages.

For fixing the issue, we just need to check whether the received
packet is valid, whether it's zero sized or not.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1140,6 +1140,12 @@ static void retire_playback_urb(struct s
 	int processed = urb->transfer_buffer_length / stride;
 	int est_delay;
 
+	/* ignore the delay accounting when procssed=0 is given, i.e.
+	 * silent payloads are procssed before handling the actual data
+	 */
+	if (!processed)
+		return;
+
 	spin_lock_irqsave(&subs->lock, flags);
 	est_delay = snd_usb_pcm_delay(subs, runtime->rate);
 	/* update delay with exact number of samples played */


