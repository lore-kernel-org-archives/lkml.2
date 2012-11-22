Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab2KVWqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:46:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:49010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab2KVSdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 62/83] ALSA: usb-audio: Fix crash at re-preparing the PCM stream
Date: Wed, 21 Nov 2012 16:42:24 -0800
Message-Id: <20121122004219.398927579@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f58161ba1b05a968e5136824b5a16b714b6a5317 upstream.

There are bug reports of a crash with USB-audio devices when PCM
prepare is performed immediately after the stream is stopped via
trigger callback.  It turned out that the problem is that we don't
wait until all URBs are killed.

This patch adds a new function to synchronize the pending stop
operation on an endpoint, and calls in the prepare callback for
avoiding the crash above.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=49181

Reported-and-tested-by: Artem S. Tashkinov <t.artem@lycos.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/endpoint.c |   13 +++++++++++++
 sound/usb/endpoint.h |    1 +
 sound/usb/pcm.c      |    3 +++
 3 files changed, 17 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -35,6 +35,7 @@
 
 #define EP_FLAG_ACTIVATED	0
 #define EP_FLAG_RUNNING		1
+#define EP_FLAG_STOPPING	2
 
 /*
  * snd_usb_endpoint is a model that abstracts everything related to an
@@ -502,10 +503,20 @@ static int wait_clear_urbs(struct snd_us
 	if (alive)
 		snd_printk(KERN_ERR "timeout: still %d active urbs on EP #%x\n",
 					alive, ep->ep_num);
+	clear_bit(EP_FLAG_STOPPING, &ep->flags);
 
 	return 0;
 }
 
+/* sync the pending stop operation;
+ * this function itself doesn't trigger the stop operation
+ */
+void snd_usb_endpoint_sync_pending_stop(struct snd_usb_endpoint *ep)
+{
+	if (ep && test_bit(EP_FLAG_STOPPING, &ep->flags))
+		wait_clear_urbs(ep);
+}
+
 /*
  * unlink active urbs.
  */
@@ -913,6 +924,8 @@ void snd_usb_endpoint_stop(struct snd_us
 
 		if (wait)
 			wait_clear_urbs(ep);
+		else
+			set_bit(EP_FLAG_STOPPING, &ep->flags);
 	}
 }
 
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -16,6 +16,7 @@ int snd_usb_endpoint_set_params(struct s
 int  snd_usb_endpoint_start(struct snd_usb_endpoint *ep, int can_sleep);
 void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep,
 			   int force, int can_sleep, int wait);
+void snd_usb_endpoint_sync_pending_stop(struct snd_usb_endpoint *ep);
 int  snd_usb_endpoint_activate(struct snd_usb_endpoint *ep);
 int  snd_usb_endpoint_deactivate(struct snd_usb_endpoint *ep);
 void snd_usb_endpoint_free(struct list_head *head);
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -563,6 +563,9 @@ static int snd_usb_pcm_prepare(struct sn
 		goto unlock;
 	}
 
+	snd_usb_endpoint_sync_pending_stop(subs->sync_endpoint);
+	snd_usb_endpoint_sync_pending_stop(subs->data_endpoint);
+
 	/* some unit conversions in runtime */
 	subs->data_endpoint->maxframesize =
 		bytes_to_frames(runtime, subs->data_endpoint->maxpacksize);


