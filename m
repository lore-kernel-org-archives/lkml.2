Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab3AIUgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:41008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932725Ab3AIUgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 14/47] ALSA: usb-audio: Avoid autopm calls after disconnection
Date: Wed,  9 Jan 2013 12:35:09 -0800
Message-Id: <20130109201731.119234523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -115,6 +115,7 @@ struct snd_usb_midi {
 	struct list_head list;
 	struct timer_list error_timer;
 	spinlock_t disc_lock;
+	struct rw_semaphore disc_rwsem;
 	struct mutex mutex;
 	u32 usb_id;
 	int next_midi_device;
@@ -1021,6 +1022,12 @@ static void substream_open(struct snd_ra
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
@@ -1039,6 +1046,7 @@ static void substream_open(struct snd_ra
 		}
 	}
 	mutex_unlock(&umidi->mutex);
+	up_read(&umidi->disc_rwsem);
 }
 
 static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
@@ -1059,8 +1067,15 @@ static int snd_usbmidi_output_open(struc
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
@@ -1075,8 +1090,10 @@ static int snd_usbmidi_output_close(stru
 	struct usbmidi_out_port *port = substream->runtime->private_data;
 
 	substream_open(substream, 0);
-	if (port->autopm_reference)
+	down_read(&umidi->disc_rwsem);
+	if (!umidi->disconnected && port->autopm_reference)
 		usb_autopm_put_interface(umidi->iface);
+	up_read(&umidi->disc_rwsem);
 	return 0;
 }
 
@@ -1386,9 +1403,12 @@ void snd_usbmidi_disconnect(struct list_
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
@@ -2100,6 +2120,7 @@ int snd_usbmidi_create(struct snd_card *
 	umidi->usb_protocol_ops = &snd_usbmidi_standard_ops;
 	init_timer(&umidi->error_timer);
 	spin_lock_init(&umidi->disc_lock);
+	init_rwsem(&umidi->disc_rwsem);
 	mutex_init(&umidi->mutex);
 	umidi->usb_id = USB_ID(le16_to_cpu(umidi->dev->descriptor.idVendor),
 			       le16_to_cpu(umidi->dev->descriptor.idProduct));


