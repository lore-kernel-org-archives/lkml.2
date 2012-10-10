Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab2JJWxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57988 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757335Ab2JJWxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:11 -0400
X-Sasl-enc: zYM4n73h7d+xF74pRedRw+wDgxPcy0biDF45sHy2F0l9 1349909590
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 008/133] em28xx: Make all em28xx extensions to be initialized asynchronously
Date: Thu, 11 Oct 2012 07:50:34 +0900
Message-Id: <20121010224855.941567291@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 6ae5e060840589f567c1837613e8a9d34fc9188a upstream.

em28xx-dvb, em28xx-alsa and em28xx-ir are typically initialized
asyncrhronously. The exception for it is when those modules
are loaded before em28xx (or before an em28xx card insertion) or
when they're built in.

Make the extentions to always load asynchronously. That allows
having all DVB firmwares loaded synchronously with udev-182.

Antti tested it with the following hardware:
	Hauppauge WinTV HVR 930C
	MaxMedia UB425-TC
	PCTV QuatroStick nano (520e)

Tested-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/em28xx/em28xx-cards.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2880,12 +2880,20 @@ static void em28xx_card_setup(struct em2
 }
 
 
-#if defined(CONFIG_MODULES) && defined(MODULE)
 static void request_module_async(struct work_struct *work)
 {
 	struct em28xx *dev = container_of(work,
 			     struct em28xx, request_module_wk);
 
+	/*
+	 * The em28xx extensions can be modules or builtin. If the
+	 * modules are already loaded or are built in, those extensions
+	 * can be initialised right now. Otherwise, the module init
+	 * code will do it.
+	 */
+	em28xx_init_extension(dev);
+
+#if defined(CONFIG_MODULES) && defined(MODULE)
 	if (dev->has_audio_class)
 		request_module("snd-usb-audio");
 	else if (dev->has_alsa_audio)
@@ -2895,6 +2903,7 @@ static void request_module_async(struct
 		request_module("em28xx-dvb");
 	if (dev->board.ir_codes && !disable_ir)
 		request_module("em28xx-rc");
+#endif /* CONFIG_MODULES */
 }
 
 static void request_modules(struct em28xx *dev)
@@ -2907,10 +2916,6 @@ static void flush_request_modules(struct
 {
 	flush_work_sync(&dev->request_module_wk);
 }
-#else
-#define request_modules(dev)
-#define flush_request_modules(dev)
-#endif /* CONFIG_MODULES */
 
 /*
  * em28xx_release_resources()
@@ -3329,13 +3334,6 @@ static int em28xx_usb_probe(struct usb_i
 	 */
 	mutex_unlock(&dev->lock);
 
-	/*
-	 * These extensions can be modules. If the modules are already
-	 * loaded then we can initialise the device now, otherwise we
-	 * will initialise it when the modules load instead.
-	 */
-	em28xx_init_extension(dev);
-
 	return 0;
 
 unlock_and_free:


