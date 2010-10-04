Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0JDQNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:13:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60183 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0JDQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QcodzvhhoMVTxGXVu9jXNrt0ZrSFX+FMmk+SQZ4XSC2VMOGCBXvRAtiJLwAYko3AOV
         Tjqedt1hvxOw2jkvONRg+aXxjmOknUIXksASMGldqbOTJB8lmd9HryvfqxhbowyEg+du
         0XyrcZ/8gyIaSqG50WCszy7hOYWfD86mba0/Y=
Date: Mon, 4 Oct 2010 09:13:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, pingc@wacom.com,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Message-ID: <20101004161320.GA14180@core.coreip.homeip.net>
References: <4C8E180D.4020309@suse.cz>
 <201009132120.23372.oliver@neukum.org>
 <20100914005209.GB27540@core.coreip.homeip.net>
 <201009140807.39977.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009140807.39977.oliver@neukum.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 08:07:39AM +0200, Oliver Neukum wrote:
> Am Dienstag, 14. September 2010, 02:52:10 schrieb Dmitry Torokhov:
> > On Mon, Sep 13, 2010 at 09:20:23PM +0200, Oliver Neukum wrote:
> > > Am Montag, 13. September 2010, 19:10:47 schrieb Dmitry Torokhov:
> > > 
> > > > I think this introduces significant change in behavior though - before
> > > > we did not do usb_autopm_put_interface() on successful open, basically
> > > > disabling autopm facilities, right?
> > > 
> > > Right. Which makes no sense at all. You'd better remove anything related
> > > to runtime PM and not set supports_autosuspend for that.
> > > 
> > 
> > That not what I meant, I do not want to remove autopm, it's just it was
> > effectively disabled and if we fix it we might start getting some
> > regression reports ;)
> 
> True. So currently we have
> 
> - a deadlock
> - disabled runtime power management
> 
> We need to fix the deadlock. We can fix it retaining a disabled
> runtime power management. Or we can fix it fixing the runtime
> power management at the same time. However this opens
> the door to regressions. So for now I really suggest removing
> it from the driver and reintroduce it properly for the next merge
> window.
> 

Lost track of this issue for a while. So I think we still need to fix
the deadlock for .36 and I think that the following will do that. Then
we'll adjust the driver to actually enable runtime PM for .37.

Thanks.

-- 
Dmitry

Input: wacom - fix runtime PM related deadlock

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

When runtime PM is enabled by default for input devices, X hangs in
wacom open:
[<ffffffff814a00ea>] mutex_lock+0x1a/0x40
[<ffffffffa02bc94b>] wacom_resume+0x3b/0x90 [wacom]
[<ffffffff81327a32>] usb_resume_interface+0xd2/0x190
[<ffffffff81327b5d>] usb_resume_both+0x6d/0x110
[<ffffffff81327c24>] usb_runtime_resume+0x24/0x40
[<ffffffff8130a2cf>] __pm_runtime_resume+0x26f/0x450
[<ffffffff8130a23a>] __pm_runtime_resume+0x1da/0x450
[<ffffffff8130a53a>] pm_runtime_resume+0x2a/0x50
[<ffffffff81328176>] usb_autopm_get_interface+0x26/0x60
[<ffffffffa02bc626>] wacom_open+0x36/0x90 [wacom]

wacom_open() takes wacom->lock and calls usb_autopm_get_interface(),
which in turn calls wacom_resume() which tries to acquire the lock
again.

The fix is to call usb_autopm_get_interface() first, before we take
the lock.

Since we do not do usb_autopm_put_interface() until wacom_close()
is called runtime PM is effectively disabled for the driver, however
changing it now would risk regressions so the complete fix will
have to wait till the next merge window.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/tablet/wacom_sys.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)


diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 1e3af29..02de653 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -103,27 +103,26 @@ static void wacom_sys_irq(struct urb *urb)
 static int wacom_open(struct input_dev *dev)
 {
 	struct wacom *wacom = input_get_drvdata(dev);
+	int retval = 0;
 
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
+	if (retval)
+		usb_autopm_put_interface(wacom->intf);
+	return retval;
 }
 
 static void wacom_close(struct input_dev *dev)
@@ -135,6 +134,8 @@ static void wacom_close(struct input_dev *dev)
 	wacom->open = false;
 	wacom->intf->needs_remote_wakeup = 0;
 	mutex_unlock(&wacom->lock);
+
+	usb_autopm_put_interface(wacom->intf);
 }
 
 static int wacom_parse_hid(struct usb_interface *intf, struct hid_descriptor *hid_desc,
