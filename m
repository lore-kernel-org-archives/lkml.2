Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0EOVVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:21:53 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51440 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab0EOVVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:21:48 -0400
Date: Sat, 15 May 2010 23:21:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 28/37] drivers/staging: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152321190.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/comedi/drivers/usbdux.c                 |    3 +--
 drivers/staging/comedi/drivers/usbduxfast.c             |    3 +--
 drivers/staging/cx25821/cx25821-audio-upstream.c        |   11 ++++-------
 drivers/staging/cx25821/cx25821-video-upstream-ch2.c    |   12 ++++--------
 drivers/staging/cx25821/cx25821-video-upstream.c        |   10 ++++------
 drivers/staging/go7007/go7007-driver.c                  |    3 +--
 drivers/staging/hv/vmbus.c                              |    3 +--
 drivers/staging/line6/dumprequest.c                     |    3 +--
 drivers/staging/line6/pod.c                             |    6 ++----
 drivers/staging/line6/variax.c                          |    5 ++---
 drivers/staging/pohmelfs/config.c                       |   16 ++++++----------
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    4 ++--
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c      |    3 +--
 drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c  |    4 ++--
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c       |    3 +--
 drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c |    4 ++--
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c      |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c  |    7 +++----
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c       |    3 +--
 drivers/staging/usbip/stub_rx.c                         |    4 ++--
 20 files changed, 42 insertions(+), 68 deletions(-)

diff -u -p a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -840,13 +840,12 @@ static int firmwareUpload(struct usbduxs
 	}
 
 	/* we generate a local buffer for the firmware */
-	fwBuf = kzalloc(sizeFirmware, GFP_KERNEL);
+	fwBuf = kmemdup(firmwareBinary, sizeFirmware, GFP_KERNEL);
 	if (!fwBuf) {
 		dev_err(&usbduxsub->interface->dev,
 			"comedi_: mem alloc for firmware failed\n");
 		return -ENOMEM;
 	}
-	memcpy(fwBuf, firmwareBinary, sizeFirmware);
 
 	ret = usbduxsub_stop(usbduxsub);
 	if (ret < 0) {
diff -u -p a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1368,13 +1368,12 @@ static int firmwareUpload(struct usbduxf
 	}
 
 	/* we generate a local buffer for the firmware */
-	fwBuf = kzalloc(sizeFirmware, GFP_KERNEL);
+	fwBuf = kmemdup(firmwareBinary, sizeFirmware, GFP_KERNEL);
 	if (!fwBuf) {
 		dev_err(&usbduxfastsub->interface->dev,
 			"comedi_: mem alloc for firmware failed\n");
 		return -ENOMEM;
 	}
-	memcpy(fwBuf, firmwareBinary, sizeFirmware);
 
 	ret = usbduxfastsub_stop(usbduxfastsub);
 	if (ret < 0) {
diff -u -p a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -753,26 +753,23 @@ int cx25821_audio_upstream_init(struct c
 
 	if (dev->input_audiofilename) {
 		str_length = strlen(dev->input_audiofilename);
-		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_audiofilename = kmemdup(dev->input_audiofilename,
+					      str_length + 1, GFP_KERNEL);
 
 		if (!dev->_audiofilename)
 			goto error;
 
-		memcpy(dev->_audiofilename, dev->input_audiofilename,
-		       str_length + 1);
-
 		/* Default if filename is empty string */
 		if (strcmp(dev->input_audiofilename, "") == 0) {
 			dev->_audiofilename = "/root/audioGOOD.wav";
 		}
 	} else {
 		str_length = strlen(_defaultAudioName);
-		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_audiofilename = kmemdup(_defaultAudioName,
+					      str_length + 1, GFP_KERNEL);
 
 		if (!dev->_audiofilename)
 			goto error;
-
-		memcpy(dev->_audiofilename, _defaultAudioName, str_length + 1);
 	}
 
 	retval =
diff -u -p a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -769,22 +769,18 @@ int cx25821_vidupstream_init_ch2(struct 
 
 	if (dev->input_filename_ch2) {
 		str_length = strlen(dev->input_filename_ch2);
-		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename_ch2 = kmemdup(dev->input_filename_ch2,
+					     str_length + 1, GFP_KERNEL);
 
 		if (!dev->_filename_ch2)
 			goto error;
-
-		memcpy(dev->_filename_ch2, dev->input_filename_ch2,
-		       str_length + 1);
 	} else {
 		str_length = strlen(dev->_defaultname_ch2);
-		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename_ch2 = kmemdup(dev->_defaultname_ch2,
+					     str_length + 1, GFP_KERNEL);
 
 		if (!dev->_filename_ch2)
 			goto error;
-
-		memcpy(dev->_filename_ch2, dev->_defaultname_ch2,
-		       str_length + 1);
 	}
 
 	//Default if filename is empty string
diff -u -p a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -831,20 +831,18 @@ int cx25821_vidupstream_init_ch1(struct 
 
 	if (dev->input_filename) {
 		str_length = strlen(dev->input_filename);
-		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename = kmemdup(dev->input_filename, str_length + 1,
+					 GFP_KERNEL);
 
 		if (!dev->_filename)
 			goto error;
-
-		memcpy(dev->_filename, dev->input_filename, str_length + 1);
 	} else {
 		str_length = strlen(dev->_defaultname);
-		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
+		dev->_filename = kmemdup(dev->_defaultname, str_length + 1,
+					 GFP_KERNEL);
 
 		if (!dev->_filename)
 			goto error;
-
-		memcpy(dev->_filename, dev->_defaultname, str_length + 1);
 	}
 
 	/* Default if filename is empty string */
diff -u -p a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -109,14 +109,13 @@ static int go7007_load_encoder(struct go
 		return -1;
 	}
 	fw_len = fw_entry->size - 16;
-	bounce = kmalloc(fw_len, GFP_KERNEL);
+	bounce = kmemdup(fw_entry->data + 16, fw_len, GFP_KERNEL);
 	if (bounce == NULL) {
 		v4l2_err(go, "unable to allocate %d bytes for "
 				"firmware transfer\n", fw_len);
 		release_firmware(fw_entry);
 		return -1;
 	}
-	memcpy(bounce, fw_entry->data + 16, fw_len);
 	release_firmware(fw_entry);
 	if (go7007_interface_reset(go) < 0 ||
 			go7007_send_firmware(go, bounce, fw_len) < 0 ||
diff -u -p a/drivers/staging/hv/vmbus.c b/drivers/staging/hv/vmbus.c
--- a/drivers/staging/hv/vmbus.c
+++ b/drivers/staging/hv/vmbus.c
@@ -185,11 +185,10 @@ static void VmbusOnMsgDPC(struct hv_driv
 			/* no msg */
 			break;
 		} else {
-			copied = kmalloc(sizeof(*copied), GFP_ATOMIC);
+			copied = kmemdup(msg, sizeof(*copied), GFP_ATOMIC);
 			if (copied == NULL)
 				continue;
 
-			memcpy(copied, msg, sizeof(*copied));
 			osd_schedule_callback(gVmbusConnection.WorkQueue,
 					      VmbusOnChannelMessage,
 					      (void *)copied);
diff -u -p a/drivers/staging/line6/dumprequest.c b/drivers/staging/line6/dumprequest.c
--- a/drivers/staging/line6/dumprequest.c
+++ b/drivers/staging/line6/dumprequest.c
@@ -105,10 +105,9 @@ int line6_wait_dump(struct line6_dump_re
 int line6_dumpreq_initbuf(struct line6_dump_request *l6dr, const void *buf,
 			  size_t len, int num)
 {
-	l6dr->reqbufs[num].buffer = kmalloc(len, GFP_KERNEL);
+	l6dr->reqbufs[num].buffer = kmemdup(buf, len, GFP_KERNEL);
 	if (l6dr->reqbufs[num].buffer == NULL)
 		return -ENOMEM;
-	memcpy(l6dr->reqbufs[num].buffer, buf, len);
 	l6dr->reqbufs[num].length = len;
 	return 0;
 }
diff -u -p a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -1074,7 +1074,8 @@ int pod_init(struct usb_interface *inter
 		return -ENOMEM;
 	}
 
-	pod->buffer_versionreq = kmalloc(sizeof(pod_request_version),
+	pod->buffer_versionreq = kmemdup(pod_request_version,
+					 sizeof(pod_request_version),
 					 GFP_KERNEL);
 
 	if (pod->buffer_versionreq == NULL) {
@@ -1083,9 +1084,6 @@ int pod_init(struct usb_interface *inter
 		return -ENOMEM;
 	}
 
-	memcpy(pod->buffer_versionreq, pod_request_version,
-	       sizeof(pod_request_version));
-
 	/* create sysfs entries: */
 	err = pod_create_files2(&interface->dev);
 	if (err < 0) {
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -2667,11 +2667,11 @@ static int ieee80211_wpa_set_wpa_ie(stru
 		return -EINVAL;
 
 	if (param->u.wpa_ie.len) {
-		buf = kmalloc(param->u.wpa_ie.len, GFP_KERNEL);
+		buf = kmemdup(param->u.wpa_ie.data, param->u.wpa_ie.len,
+			      GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
 
-		memcpy(buf, param->u.wpa_ie.data, param->u.wpa_ie.len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = param->u.wpa_ie.len;
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -728,10 +728,9 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
-		buf = kmalloc(len, GFP_KERNEL);
+		buf = kmemdup(ie, len, GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
-		memcpy(buf, ie, len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = len;
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -3256,11 +3256,11 @@ static int ieee80211_wpa_set_wpa_ie(stru
 		return -EINVAL;
 
 	if (param->u.wpa_ie.len) {
-		buf = kmalloc(param->u.wpa_ie.len, GFP_KERNEL);
+		buf = kmemdup(param->u.wpa_ie.data, param->u.wpa_ie.len,
+			      GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
 
-		memcpy(buf, param->u.wpa_ie.data, param->u.wpa_ie.len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = param->u.wpa_ie.len;
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -980,10 +980,9 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
-		buf = kmalloc(len, GFP_KERNEL);
+		buf = kmemdup(ie, len, GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
-		memcpy(buf, ie, len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = len;
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
@@ -2845,11 +2845,11 @@ static int ieee80211_wpa_set_wpa_ie(stru
 		return -EINVAL;
 
 	if (param->u.wpa_ie.len) {
-		buf = kmalloc(param->u.wpa_ie.len, GFP_KERNEL);
+		buf = kmemdup(param->u.wpa_ie.data, param->u.wpa_ie.len,
+			      GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
 
-		memcpy(buf, param->u.wpa_ie.data, param->u.wpa_ie.len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = param->u.wpa_ie.len;
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
@@ -768,10 +768,9 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 			printk("len: %Zd, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
-		buf = kmalloc(len, GFP_KERNEL);
+		buf = kmemdup(ie, len, GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
-		memcpy(buf, ie, len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = len;
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1579,10 +1579,9 @@ static inline u16 auth_parse(struct sk_b
 
 		if(*(t++) == MFIE_TYPE_CHALLENGE){
 			*chlen = *(t++);
-			*challenge = kmalloc(*chlen, GFP_ATOMIC);
+			*challenge = kmemdup(t, *chlen, GFP_ATOMIC);
 			if (!*challenge)
 				return -ENOMEM;
-			memcpy(*challenge, t, *chlen);
 		}
 	}
 
@@ -2871,11 +2870,11 @@ static int ieee80211_wpa_set_wpa_ie(stru
 		return -EINVAL;
 
 	if (param->u.wpa_ie.len) {
-		buf = kmalloc(param->u.wpa_ie.len, GFP_KERNEL);
+		buf = kmemdup(param->u.wpa_ie.data, param->u.wpa_ie.len,
+			      GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
 
-		memcpy(buf, param->u.wpa_ie.data, param->u.wpa_ie.len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = param->u.wpa_ie.len;
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -848,10 +848,9 @@ int ieee80211_wx_set_gen_ie(struct ieee8
 			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
-		buf = kmalloc(len, GFP_KERNEL);
+		buf = kmemdup(ie, len, GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
-		memcpy(buf, ie, len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = len;
diff -u -p a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -486,7 +486,8 @@ int variax_init(struct usb_interface *in
 		return err;
 	}
 
-	variax->buffer_activate = kmalloc(sizeof(variax_activate), GFP_KERNEL);
+	variax->buffer_activate = kmemdup(variax_activate,
+					  sizeof(variax_activate), GFP_KERNEL);
 
 	if (variax->buffer_activate == NULL) {
 		dev_err(&interface->dev, "Out of memory\n");
@@ -494,8 +495,6 @@ int variax_init(struct usb_interface *in
 		return -ENOMEM;
 	}
 
-	memcpy(variax->buffer_activate, variax_activate,
-	       sizeof(variax_activate));
 	init_timer(&variax->activate_timer);
 
 	/* create sysfs entries: */
diff -u -p a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -204,18 +204,18 @@ int pohmelfs_copy_crypto(struct pohmelfs
 	}
 
 	if (g->hash_keysize) {
-		psb->hash_key = kmalloc(g->hash_keysize, GFP_KERNEL);
+		psb->hash_key = kmemdup(g->hash_key, g->hash_keysize,
+					GFP_KERNEL);
 		if (!psb->hash_key)
 			goto err_out_free_cipher_string;
-		memcpy(psb->hash_key, g->hash_key, g->hash_keysize);
 		psb->hash_keysize = g->hash_keysize;
 	}
 
 	if (g->cipher_keysize) {
-		psb->cipher_key = kmalloc(g->cipher_keysize, GFP_KERNEL);
+		psb->cipher_key = kmemdup(g->cipher_key, g->cipher_keysize,
+					  GFP_KERNEL);
 		if (!psb->cipher_key)
 			goto err_out_free_hash;
-		memcpy(psb->cipher_key, g->cipher_key, g->cipher_keysize);
 		psb->cipher_keysize = g->cipher_keysize;
 	}
 
@@ -455,14 +455,12 @@ static int pohmelfs_crypto_hash_init(str
 	g->hash_strlen = c->strlen;
 	g->hash_keysize = c->keysize;
 
-	g->hash_key = kmalloc(c->keysize, GFP_KERNEL);
+	g->hash_key = kmemdup(key, c->keysize, GFP_KERNEL);
 	if (!g->hash_key) {
 		kfree(g->hash_string);
 		return -ENOMEM;
 	}
 
-	memcpy(g->hash_key, key, c->keysize);
-
 	return 0;
 }
 
@@ -480,14 +478,12 @@ static int pohmelfs_crypto_cipher_init(s
 	g->cipher_strlen = c->strlen;
 	g->cipher_keysize = c->keysize;
 
-	g->cipher_key = kmalloc(c->keysize, GFP_KERNEL);
+	g->cipher_key = kmemdup(key, c->keysize, GFP_KERNEL);
 	if (!g->cipher_key) {
 		kfree(g->cipher_string);
 		return -ENOMEM;
 	}
 
-	memcpy(g->cipher_key, key, c->keysize);
-
 	return 0;
 }
 
diff -u -p a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -502,13 +502,13 @@ static void stub_recv_cmd_submit(struct 
 	}
 
 	/* set priv->urb->setup_packet */
-	priv->urb->setup_packet = kzalloc(8, GFP_KERNEL);
+	priv->urb->setup_packet = kmemdup(&pdu->u.cmd_submit.setup, 8,
+					  GFP_KERNEL);
 	if (!priv->urb->setup_packet) {
 		dev_err(&sdev->interface->dev, "allocate setup_packet\n");
 		usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
 		return;
 	}
-	memcpy(priv->urb->setup_packet, &pdu->u.cmd_submit.setup, 8);
 
 	/* set other members from the base header of pdu */
 	priv->urb->context                = (void *) priv;
