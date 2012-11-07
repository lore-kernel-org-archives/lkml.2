Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2KGUhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:37:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51076 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751149Ab2KGUhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:37:19 -0500
Date: Wed, 7 Nov 2012 15:37:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Takashi Iwai <tiwai@suse.de>
cc: Christof Meerwald <cmeerw@cmeerw.org>, Daniel Mack <zonque@gmail.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
In-Reply-To: <s5hzk2tfcg8.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.44L0.1211071530560.1188-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Takashi Iwai wrote:

> > What is the right solution for this problem?
> 
> How about the patch below?  (It's for 3.6, and won't be applied cleanly
> to 3.7, but easy to adapt.)

I simplified your patch a little.  This is for 3.7, not 3.6.  I 
verified that it does fix the problem raised by the test program.

If you think this is okay, I'll submit it officially.

Alan Stern



Index: usb-3.7/sound/usb/endpoint.h
===================================================================
--- usb-3.7.orig/sound/usb/endpoint.h
+++ usb-3.7/sound/usb/endpoint.h
@@ -19,6 +19,7 @@ int snd_usb_endpoint_set_params(struct s
 int  snd_usb_endpoint_start(struct snd_usb_endpoint *ep, int can_sleep);
 void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep,
 			   int force, int can_sleep, int wait);
+void snd_usb_endpoint_sync_stop(struct snd_usb_endpoint *ep);
 int  snd_usb_endpoint_activate(struct snd_usb_endpoint *ep);
 int  snd_usb_endpoint_deactivate(struct snd_usb_endpoint *ep);
 void snd_usb_endpoint_free(struct list_head *head);
Index: usb-3.7/sound/usb/pcm.c
===================================================================
--- usb-3.7.orig/sound/usb/pcm.c
+++ usb-3.7/sound/usb/pcm.c
@@ -576,6 +576,11 @@ static int snd_usb_pcm_prepare(struct sn
 		subs->need_setup_ep = false;
 	}
 
+	if (subs->sync_endpoint)
+		snd_usb_endpoint_sync_stop(subs->sync_endpoint);
+	if (subs->data_endpoint)
+		snd_usb_endpoint_sync_stop(subs->data_endpoint);
+
 	/* some unit conversions in runtime */
 	subs->data_endpoint->maxframesize =
 		bytes_to_frames(runtime, subs->data_endpoint->maxpacksize);
Index: usb-3.7/sound/usb/endpoint.c
===================================================================
--- usb-3.7.orig/sound/usb/endpoint.c
+++ usb-3.7/sound/usb/endpoint.c
@@ -481,7 +481,7 @@ __exit_unlock:
 /*
  *  wait until all urbs are processed.
  */
-static int wait_clear_urbs(struct snd_usb_endpoint *ep)
+void snd_usb_endpoint_sync_stop(struct snd_usb_endpoint *ep)
 {
 	unsigned long end_time = jiffies + msecs_to_jiffies(1000);
 	unsigned int i;
@@ -502,8 +502,6 @@ static int wait_clear_urbs(struct snd_us
 	if (alive)
 		snd_printk(KERN_ERR "timeout: still %d active urbs on EP #%x\n",
 					alive, ep->ep_num);
-
-	return 0;
 }
 
 /*
@@ -556,7 +554,7 @@ static void release_urbs(struct snd_usb_
 
 	/* stop urbs */
 	deactivate_urbs(ep, force, 1);
-	wait_clear_urbs(ep);
+	snd_usb_endpoint_sync_stop(ep);
 
 	for (i = 0; i < ep->nurbs; i++)
 		release_urb_ctx(&ep->urb[i]);
@@ -833,7 +831,7 @@ int snd_usb_endpoint_start(struct snd_us
 	/* just to be sure */
 	deactivate_urbs(ep, 0, can_sleep);
 	if (can_sleep)
-		wait_clear_urbs(ep);
+		snd_usb_endpoint_sync_stop(ep);
 
 	ep->active_mask = 0;
 	ep->unlink_mask = 0;
@@ -917,7 +915,7 @@ void snd_usb_endpoint_stop(struct snd_us
 		ep->prepare_data_urb = NULL;
 
 		if (wait)
-			wait_clear_urbs(ep);
+			snd_usb_endpoint_sync_stop(ep);
 	}
 }
 
@@ -940,7 +938,7 @@ int snd_usb_endpoint_deactivate(struct s
 		return -EINVAL;
 
 	deactivate_urbs(ep, 1, 1);
-	wait_clear_urbs(ep);
+	snd_usb_endpoint_sync_stop(ep);
 
 	if (ep->use_count != 0)
 		return 0;

