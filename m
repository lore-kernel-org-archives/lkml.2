Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1BGHk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:40:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1BGHk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:40:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SdyXDE1qr8dCpZC1il6rWxvalqK/BlXkvFla4evKYxEm6KqZxah/pvwwdVQe4WpYz9
         byRfCrIKuX7IObrkXOHCsY8eFwUjh7JK1qUUaBRuxF4E3m7DOV162t8xz1e/Fbm8P+cJ
         /9g6gZ5ZRnGH2nIClCGhEkEs/Qe+EwOF3Ouio=
Date: Sun, 6 Feb 2011 23:40:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Aristeu Rozanski <aris@cathedrallabs.org>
Cc: David Herrmann <dh.herrmann@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uinput strnlen bugfix
Message-ID: <20110207074017.GA25749@core.coreip.homeip.net>
References: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
 <20110206165524.GG22170@cathedrallabs.org>
 <AANLkTimZq3-zuiA940dK7AmszBW-TEHP0JHz7FGHSmgu@mail.gmail.com>
 <20110206172317.GI22170@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206172317.GI22170@cathedrallabs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 12:23:17PM -0500, Aristeu Rozanski wrote:
> On Sun, Feb 06, 2011 at 05:57:19PM +0100, David Herrmann wrote:
> > On Sun, Feb 6, 2011 at 5:55 PM, Aristeu Rozanski <aris@cathedrallabs.org> wrote:
> > > and where's the patch? :^)
> > >
> > > --
> > > Aristeu
> > >
> > 
> > ah, embarrasing.., sorry.
> > I attached the patchfile.
> > 
> > David
> 
> > --- old/drivers/input/misc/uinput.c	2011-02-06 17:40:24.951454656 +0100
> > +++ new/drivers/input/misc/uinput.c	2011-02-06 17:41:16.747454654 +0100
> > @@ -372,8 +372,8 @@
> >  
> >  	udev->ff_effects_max = user_dev->ff_effects_max;
> >  
> > -	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE) + 1;
> > -	if (!size) {
> > +	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE);
> > +	if (!size++) {
> >  		retval = -EINVAL;
> >  		goto exit;
> >  	}
> Acked-by: Aristeu Rozanski <aris@ruivo.org>
> 

Hmm, not particularly fond with the construct, how about below instead?

Btw, having "Signed-off-by: " from David would be nice.

Thanks.

-- 
Dmitry

Input: uinput - fix setting up device name

From: David Herrmann <dh.herrmann@googlemail.com>

The check for non-empty device name was botched since we tried to account
for extra space for the terminating zero at the same time. Convert to
kstrndup() to avoid this problem.

Acked-by: Aristeu Rozanski <aris@ruivo.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/uinput.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 82542a1..c0888e3 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -347,8 +347,7 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
 {
 	struct uinput_user_dev	*user_dev;
 	struct input_dev	*dev;
-	char			*name;
-	int			i, size;
+	int			i;
 	int			retval;
 
 	if (count != sizeof(struct uinput_user_dev))
@@ -373,19 +372,19 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
 
 	udev->ff_effects_max = user_dev->ff_effects_max;
 
-	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE) + 1;
-	if (!size) {
+	/* Ensure name is filled in */
+	if (!user_dev->name[0]) {
 		retval = -EINVAL;
 		goto exit;
 	}
 
 	kfree(dev->name);
-	dev->name = name = kmalloc(size, GFP_KERNEL);
-	if (!name) {
+	dev->name = kstrndup(user_dev->name, UINPUT_MAX_NAME_SIZE,
+			     GFP_KERNEL);
+	if (!dev->name) {
 		retval = -ENOMEM;
 		goto exit;
 	}
-	strlcpy(name, user_dev->name, size);
 
 	dev->id.bustype	= user_dev->id.bustype;
 	dev->id.vendor	= user_dev->id.vendor;
