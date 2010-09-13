Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0IMRK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:10:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46084 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab0IMRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PtVewX12kUBDiMG/Bz0OgCMEqJ7rCWWvN0LDguFme6Kt2Lm2YGOHe0UYKPB+/xtkeX
         SfEY3Lc74YGJgsHFwrfSlYXEAHHTV5y9qmziyEbcD/WFGB/DT9yYjZ3I4yfxsfRwEXno
         mKhjijSWuoj4Fh6/1UmowFDyc4ZQ1sE4R2XFU=
Date: Mon, 13 Sep 2010 10:10:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, pingc@wacom.com, linux-input@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: wacom + runtime PM = AA deadlock
Message-ID: <20100913171046.GA23116@core.coreip.homeip.net>
References: <4C8E180D.4020309@suse.cz>
 <201009131656.18199.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009131656.18199.oneukum@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 04:56:17PM +0200, Oliver Neukum wrote:
> Am Montag, 13. September 2010, 14:24:45 schrieb Jiri Slaby:
> > Hi,
> > 
> > by mistake when runtime PM is enabled by default for input devices, X
> > hangs on wacom open:
> > [<ffffffff814a00ea>] mutex_lock+0x1a/0x40
> > [<ffffffffa02bc94b>] wacom_resume+0x3b/0x90 [wacom]
> > [<ffffffff81327a32>] usb_resume_interface+0xd2/0x190
> > [<ffffffff81327b5d>] usb_resume_both+0x6d/0x110
> > [<ffffffff81327c24>] usb_runtime_resume+0x24/0x40
> > [<ffffffff8130a2cf>] __pm_runtime_resume+0x26f/0x450
> > [<ffffffff8130a23a>] __pm_runtime_resume+0x1da/0x450
> > [<ffffffff8130a53a>] pm_runtime_resume+0x2a/0x50
> > [<ffffffff81328176>] usb_autopm_get_interface+0x26/0x60
> > [<ffffffffa02bc626>] wacom_open+0x36/0x90 [wacom]
> > 
> > wacom_open took wacom->lock and calls usb_autopm_get_interface which in
> > turn calls wacom_resume which tries to aquire the lock again.
> > 
> > More details (dmesg including) at:
> > https://bugzilla.novell.com/show_bug.cgi?id=638506
> > 
> > Any ideas how to fix that properly?
> 
> PM in this driver looks broken. Please try this.
> 
> In short you want to drop the PM reference and depend on remote
> wakeup and busy marking for this driver. Currently it gets a reference
> on every open() but never drops it.
> 
> For locking you depend on the PM core's internal lock. You simply
> make sure you have a PM reference during open() and close()
> 
> 	Regards
> 		Oliver
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index 42ba369..e399a8a 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -121,6 +121,7 @@ static int wacom_open(struct input_dev *dev)
>  
>  	wacom->open = true;
>  	wacom->intf->needs_remote_wakeup = 1;
> +	usb_autopm_put_interface(wacom->intf);
>  
>  	mutex_unlock(&wacom->lock);
>  	return 0;
> @@ -129,11 +130,15 @@ static int wacom_open(struct input_dev *dev)
>  static void wacom_close(struct input_dev *dev)
>  {
>  	struct wacom *wacom = input_get_drvdata(dev);
> +	int r;
>  
>  	mutex_lock(&wacom->lock);
> -	usb_kill_urb(wacom->irq);
> +	r = usb_autopm_get_interface(wacom->intf);
>  	wacom->open = false;
>  	wacom->intf->needs_remote_wakeup = 0;
> +	usb_kill_urb(wacom->irq);
> +	if (!r)
> +		usb_autopm_put_interface(wacom->intf);
>  	mutex_unlock(&wacom->lock);
>  }
>  
> @@ -573,7 +578,10 @@ static int wacom_resume(struct usb_interface *intf)
>  	struct wacom_features *features = &wacom->wacom_wac.features;
>  	int rv;
>  
> -	mutex_lock(&wacom->lock);
> +	/*
> +	 * no locking against open needed
> +	 * as open holds a power reference
> +	 */

Hmm, wacom_open may hold power reference, but what about close? Anyways,
isn't below enough?

I think this introduces significant change in behavior though - before
we did not do usb_autopm_put_interface() on successful open, basically
disabling autopm facilities, right?

-- 
Dmitry


Input: wacom - fix pm locking

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/tablet/wacom_sys.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 1e3af29..2806b2d 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -103,27 +103,26 @@ static void wacom_sys_irq(struct urb *urb)
 static int wacom_open(struct input_dev *dev)
 {
 	struct wacom *wacom = input_get_drvdata(dev);
+	int retval;
 
-	mutex_lock(&wacom->lock);
-
-	wacom->irq->dev = wacom->usbdev;
-
-	if (usb_autopm_get_interface(wacom->intf) < 0) {
-		mutex_unlock(&wacom->lock);
+	if (usb_autopm_get_interface(wacom->intf) < 0)
 		return -EIO;
-	}
+
+	mutex_lock(&wacom->lock);
 
 	if (usb_submit_urb(wacom->irq, GFP_KERNEL)) {
-		usb_autopm_put_interface(wacom->intf);
-		mutex_unlock(&wacom->lock);
-		return -EIO;
+		retval = -EIO;
+		goto out;
 	}
 
 	wacom->open = true;
 	wacom->intf->needs_remote_wakeup = 1;
 
+out:
 	mutex_unlock(&wacom->lock);
-	return 0;
+	usb_autopm_put_interface(wacom->intf);
+
+	return retval;
 }
 
 static void wacom_close(struct input_dev *dev)
