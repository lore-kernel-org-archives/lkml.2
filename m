Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769019Ab2K3TRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:17:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:59318 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992890Ab2K3TB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:01:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Colin Fletcher <colin.m.fletcher@googlemail.com>,
        Devin Venable <venable.devin@gmail.com>,
        Dr Nick Bailey <nicholas.bailey@glasgow.ac.uk>,
        Jannis Achstetter <jannis_achstetter@web.de>,
        Rui Nuno Capela <rncbc@rncbc.org>, Oliver Neukum <oliver@neukum.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [ 13/54] ALSA: ua101, usx2y: fix broken MIDI output
Date: Fri, 30 Nov 2012 10:55:44 -0800
Message-Id: <20121130185209.226298325@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit e99ddfde6ae0dd2662bb40435696002b590e4057 upstream.

Commit 88a8516a2128 (ALSA: usbaudio: implement USB autosuspend) added
autosuspend code to all files making up the snd-usb-audio driver.
However, midi.c is part of snd-usb-lib and is also used by other
drivers, not all of which support autosuspend.  Thus, calls to
usb_autopm_get_interface() could fail, and this unexpected error would
result in the MIDI output being completely unusable.

Make it work by ignoring the error that is expected with drivers that do
not support autosuspend.

Reported-by: Colin Fletcher <colin.m.fletcher@googlemail.com>
Reported-by: Devin Venable <venable.devin@gmail.com>
Reported-by: Dr Nick Bailey <nicholas.bailey@glasgow.ac.uk>
Reported-by: Jannis Achstetter <jannis_achstetter@web.de>
Reported-by: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/midi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -148,6 +148,7 @@ struct snd_usb_midi_out_endpoint {
 		struct snd_usb_midi_out_endpoint* ep;
 		struct snd_rawmidi_substream *substream;
 		int active;
+		bool autopm_reference;
 		uint8_t cable;		/* cable number << 4 */
 		uint8_t state;
 #define STATE_UNKNOWN	0
@@ -1076,7 +1077,8 @@ static int snd_usbmidi_output_open(struc
 		return -ENXIO;
 	}
 	err = usb_autopm_get_interface(umidi->iface);
-	if (err < 0)
+	port->autopm_reference = err >= 0;
+	if (err < 0 && err != -EACCES)
 		return -EIO;
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;
@@ -1087,9 +1089,11 @@ static int snd_usbmidi_output_open(struc
 static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substream)
 {
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
+	struct usbmidi_out_port *port = substream->runtime->private_data;
 
 	substream_open(substream, 0);
-	usb_autopm_put_interface(umidi->iface);
+	if (port->autopm_reference)
+		usb_autopm_put_interface(umidi->iface);
 	return 0;
 }
 


