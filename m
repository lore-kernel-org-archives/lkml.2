Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab3AIUhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:41646 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab3AIUhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 018/123] ALSA: usb-audio: Avoid autopm calls after disconnection
Date: Wed,  9 Jan 2013 12:34:17 -0800
Message-Id: <20130109201500.863380063@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 59866da9e4ae54819e3c4e0a8f426bdb0c2ef993 upstream.

Add a similar protection against the disconnection race and the
invalid use of usb instance after disconnection, as well as we've done
for the USB audio PCM.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51201

Reviewd-by: Clemens Ladisch <clemens@ladisch.de>
Tested-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/midi.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -116,6 +116,7 @@ struct snd_usb_midi {
 	struct list_head list;
 	struct timer_list error_timer;
 	spinlock_t disc_lock;
+	struct rw_semaphore disc_rwsem;
 	struct mutex mutex;
 	u32 usb_id;
 	int next_midi_device;
@@ -1038,6 +1039,12 @@ static void substream_open(struct snd_ra
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct snd_kcontrol *ctl;
 
+	down_read(&umidi->disc_rwsem);
+	if (umidi->disconnected) {
+		up_read(&umidi->disc_rwsem);
+		return;
+	}
+
 	mutex_lock(&umidi->mutex);
 	if (open) {
 		if (umidi->opened++ == 0 && umidi->roland_load_ctl) {
@@ -1056,6 +1063,7 @@ static void substream_open(struct snd_ra
 		}
 	}
 	mutex_unlock(&umidi->mutex);
+	up_read(&umidi->disc_rwsem);
 }
 
 static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
@@ -1076,8 +1084,15 @@ static int snd_usbmidi_output_open(struc
 		snd_BUG();
 		return -ENXIO;
 	}
+
+	down_read(&umidi->disc_rwsem);
+	if (umidi->disconnected) {
+		up_read(&umidi->disc_rwsem);
+		return -ENODEV;
+	}
 	err = usb_autopm_get_interface(umidi->iface);
 	port->autopm_reference = err >= 0;
+	up_read(&umidi->disc_rwsem);
 	if (err < 0 && err != -EACCES)
 		return -EIO;
 	substream->runtime->private_data = port;
@@ -1092,8 +1107,10 @@ static int snd_usbmidi_output_close(stru
 	struct usbmidi_out_port *port = substream->runtime->private_data;
 
 	substream_open(substream, 0);
-	if (port->autopm_reference)
+	down_read(&umidi->disc_rwsem);
+	if (!umidi->disconnected && port->autopm_reference)
 		usb_autopm_put_interface(umidi->iface);
+	up_read(&umidi->disc_rwsem);
 	return 0;
 }
 
@@ -1403,9 +1420,12 @@ void snd_usbmidi_disconnect(struct list_
 	 * a timer may submit an URB. To reliably break the cycle
 	 * a flag under lock must be used
 	 */
+	down_write(&umidi->disc_rwsem);
 	spin_lock_irq(&umidi->disc_lock);
 	umidi->disconnected = 1;
 	spin_unlock_irq(&umidi->disc_lock);
+	up_write(&umidi->disc_rwsem);
+
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint* ep = &umidi->endpoints[i];
 		if (ep->out)
@@ -2117,6 +2137,7 @@ int snd_usbmidi_create(struct snd_card *
 	umidi->usb_protocol_ops = &snd_usbmidi_standard_ops;
 	init_timer(&umidi->error_timer);
 	spin_lock_init(&umidi->disc_lock);
+	init_rwsem(&umidi->disc_rwsem);
 	mutex_init(&umidi->mutex);
 	umidi->usb_id = USB_ID(le16_to_cpu(umidi->dev->descriptor.idVendor),
 			       le16_to_cpu(umidi->dev->descriptor.idProduct));


