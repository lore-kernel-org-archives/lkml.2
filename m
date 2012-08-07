Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2HGW21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:28:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2HGW2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:28:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dylan Reid <dgreid@chromium.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 026/122] ALSA: hda - Dont power up when not powered down.
Date: Tue,  7 Aug 2012 15:25:14 -0700
Message-Id: <20120807221950.574861686@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit b43d224767e426cf1a8b6622d1d172f2b2b0e857 upstream.

After cancel_delayed_work_sync returns, the power down work either never
started (power_on == 1) or finished (power_on == 0).  In the former case
there is no need to power up again.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4418,6 +4418,13 @@ static void __snd_hda_power_up(struct hd
 	cancel_delayed_work_sync(&codec->power_work);
 
 	spin_lock(&codec->power_lock);
+	/* If the power down delayed work was cancelled above before starting,
+	 * then there is no need to go through power up here.
+	 */
+	if (codec->power_on) {
+		spin_unlock(&codec->power_lock);
+		return;
+	}
 	trace_hda_power_up(codec);
 	snd_hda_update_power_acct(codec);
 	codec->power_on = 1;


