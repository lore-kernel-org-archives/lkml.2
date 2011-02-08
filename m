Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1BHHi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 02:38:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62798 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1BHHi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 02:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nytOgBHqPlwT3zZN455YxO2lZkUAoX161RGRfJQfDJks3NvHbobZgPi56PmNTOg+K4
         qd70Nj0fJm8aFLuGTOQO1TtF3lNReKFY8i342vPQJdiBS43J+V/GZZfvOc05Byu38sPo
         j8+FIe6E4CGXUBcY1uUSu0SiCmtEtG5OdeDCc=
Date: Mon, 7 Feb 2011 23:38:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Aristeu Rozanski <aris@cathedrallabs.org>
Cc: David Herrmann <dh.herrmann@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uinput strnlen bugfix
Message-ID: <20110208073848.GA865@core.coreip.homeip.net>
References: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
 <20110206165524.GG22170@cathedrallabs.org>
 <AANLkTimZq3-zuiA940dK7AmszBW-TEHP0JHz7FGHSmgu@mail.gmail.com>
 <20110206172317.GI22170@cathedrallabs.org>
 <20110207074017.GA25749@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207074017.GA25749@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 11:40:17PM -0800, Dmitry Torokhov wrote:
> On Sun, Feb 06, 2011 at 12:23:17PM -0500, Aristeu Rozanski wrote:
> > On Sun, Feb 06, 2011 at 05:57:19PM +0100, David Herrmann wrote:
> > > On Sun, Feb 6, 2011 at 5:55 PM, Aristeu Rozanski <aris@cathedrallabs.org> wrote:
> > > > and where's the patch? :^)
> > > >
> > > > --
> > > > Aristeu
> > > >
> > > 
> > > ah, embarrasing.., sorry.
> > > I attached the patchfile.
> > > 
> > > David
> > 
> > > --- old/drivers/input/misc/uinput.c	2011-02-06 17:40:24.951454656 +0100
> > > +++ new/drivers/input/misc/uinput.c	2011-02-06 17:41:16.747454654 +0100
> > > @@ -372,8 +372,8 @@
> > >  
> > >  	udev->ff_effects_max = user_dev->ff_effects_max;
> > >  
> > > -	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE) + 1;
> > > -	if (!size) {
> > > +	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE);
> > > +	if (!size++) {
> > >  		retval = -EINVAL;
> > >  		goto exit;
> > >  	}
> > Acked-by: Aristeu Rozanski <aris@ruivo.org>
> > 
> 
> Hmm, not particularly fond with the construct, how about below instead?
> 

And while we are at it...

-- 
Dmitry


Input: uinput - use memdup_user() and friends

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Instead of open-coding copying of data structures from userspace use
memdup_user() and strndup_user(). Note that this introduces change in
behavior because driver used to truncate 'phys' longer than 1024 bytes,
but now it will refuse to set 'phys' that long. Arguably trying to set
such 'phys' is suspect anyways.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/uinput.c |   35 ++++++++++-------------------------
 1 files changed, 10 insertions(+), 25 deletions(-)


diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index c0888e3..7f8331f 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -361,14 +361,9 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
 
 	dev = udev->dev;
 
-	user_dev = kmalloc(sizeof(struct uinput_user_dev), GFP_KERNEL);
-	if (!user_dev)
-		return -ENOMEM;
-
-	if (copy_from_user(user_dev, buffer, sizeof(struct uinput_user_dev))) {
-		retval = -EFAULT;
-		goto exit;
-	}
+	user_dev = memdup_user(buffer, sizeof(struct uinput_user_dev));
+	if (!IS_ERR(user_dev))
+		return PTR_ERR(user_dev);
 
 	udev->ff_effects_max = user_dev->ff_effects_max;
 
@@ -621,7 +616,6 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
 	struct uinput_ff_upload ff_up;
 	struct uinput_ff_erase  ff_erase;
 	struct uinput_request   *req;
-	int                     length;
 	char			*phys;
 
 	retval = mutex_lock_interruptible(&udev->mutex);
@@ -688,24 +682,15 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
 				retval = -EINVAL;
 				goto out;
 			}
-			length = strnlen_user(p, 1024);
-			if (length <= 0) {
-				retval = -EFAULT;
-				break;
+
+			phys = strndup_user(p, 1024);
+			if (IS_ERR(phys)) {
+				retval = PTR_ERR(phys);
+				goto out;
 			}
+
 			kfree(udev->dev->phys);
-			udev->dev->phys = phys = kmalloc(length, GFP_KERNEL);
-			if (!phys) {
-				retval = -ENOMEM;
-				break;
-			}
-			if (copy_from_user(phys, p, length)) {
-				udev->dev->phys = NULL;
-				kfree(phys);
-				retval = -EFAULT;
-				break;
-			}
-			phys[length - 1] = '\0';
+			udev->dev->phys = phys;
 			break;
 
 		case UI_BEGIN_FF_UPLOAD:
