Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0IMOzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:55:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab0IMOzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:55:49 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: wacom + runtime PM = AA deadlock
Date: Mon, 13 Sep 2010 16:56:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: pingc@wacom.com, Dmitry Torokhov <dtor@mail.ru>,
        linux-input@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>
References: <4C8E180D.4020309@suse.cz>
In-Reply-To: <4C8E180D.4020309@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131656.18199.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. September 2010, 14:24:45 schrieb Jiri Slaby:
> Hi,
> 
> by mistake when runtime PM is enabled by default for input devices, X
> hangs on wacom open:
> [<ffffffff814a00ea>] mutex_lock+0x1a/0x40
> [<ffffffffa02bc94b>] wacom_resume+0x3b/0x90 [wacom]
> [<ffffffff81327a32>] usb_resume_interface+0xd2/0x190
> [<ffffffff81327b5d>] usb_resume_both+0x6d/0x110
> [<ffffffff81327c24>] usb_runtime_resume+0x24/0x40
> [<ffffffff8130a2cf>] __pm_runtime_resume+0x26f/0x450
> [<ffffffff8130a23a>] __pm_runtime_resume+0x1da/0x450
> [<ffffffff8130a53a>] pm_runtime_resume+0x2a/0x50
> [<ffffffff81328176>] usb_autopm_get_interface+0x26/0x60
> [<ffffffffa02bc626>] wacom_open+0x36/0x90 [wacom]
> 
> wacom_open took wacom->lock and calls usb_autopm_get_interface which in
> turn calls wacom_resume which tries to aquire the lock again.
> 
> More details (dmesg including) at:
> https://bugzilla.novell.com/show_bug.cgi?id=638506
> 
> Any ideas how to fix that properly?

PM in this driver looks broken. Please try this.

In short you want to drop the PM reference and depend on remote
wakeup and busy marking for this driver. Currently it gets a reference
on every open() but never drops it.

For locking you depend on the PM core's internal lock. You simply
make sure you have a PM reference during open() and close()

	Regards
		Oliver
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 42ba369..e399a8a 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -121,6 +121,7 @@ static int wacom_open(struct input_dev *dev)
 
 	wacom->open = true;
 	wacom->intf->needs_remote_wakeup = 1;
+	usb_autopm_put_interface(wacom->intf);
 
 	mutex_unlock(&wacom->lock);
 	return 0;
@@ -129,11 +130,15 @@ static int wacom_open(struct input_dev *dev)
 static void wacom_close(struct input_dev *dev)
 {
 	struct wacom *wacom = input_get_drvdata(dev);
+	int r;
 
 	mutex_lock(&wacom->lock);
-	usb_kill_urb(wacom->irq);
+	r = usb_autopm_get_interface(wacom->intf);
 	wacom->open = false;
 	wacom->intf->needs_remote_wakeup = 0;
+	usb_kill_urb(wacom->irq);
+	if (!r)
+		usb_autopm_put_interface(wacom->intf);
 	mutex_unlock(&wacom->lock);
 }
 
@@ -573,7 +578,10 @@ static int wacom_resume(struct usb_interface *intf)
 	struct wacom_features *features = &wacom->wacom_wac.features;
 	int rv;
 
-	mutex_lock(&wacom->lock);
+	/*
+	 * no locking against open needed
+	 * as open holds a power reference
+	 */
 
 	/* switch to wacom mode first */
 	wacom_query_tablet_data(intf, features);
@@ -583,8 +591,6 @@ static int wacom_resume(struct usb_interface *intf)
 	else
 		rv = 0;
 
-	mutex_unlock(&wacom->lock);
-
 	return rv;
 }
 
