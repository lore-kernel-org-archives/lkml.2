Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1BKAl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:41:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:12617 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1BKAly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:41:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eFQInVjWWnnscaJkKLhYTjJVlO2o0JugYI164TXvw+z+g7Gq0bpZ+zvrYOigBvu6Q6
         lgACI32Vu6g4rKz0Asnw==
MIME-Version: 1.0
In-Reply-To: <20110210235447.GA12313@core.coreip.homeip.net>
References: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
	<20110210235447.GA12313@core.coreip.homeip.net>
Date: Thu, 10 Feb 2011 16:41:52 -0800
X-Google-Sender-Auth: O4qGdyeeG3at5navp3R4BNo9CIQ
Message-ID: <AANLkTinjPG-KY-ee3ya7bca8F5QechRhE88+uO6odgjE@mail.gmail.com>
Subject: Re: [PATCH] Input: fixed EVIOCGRAB iterative grab/release.
From: Terry Lambert <tlambert@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure.  First patch to linux in 16 years and all, I didn't want to be
too noisy...

Problem:

If you use EVIOCGRAB, such as when you are using a Cr-48 with the
Synaptics trackpad driver, the grab on the input device has to be
dropped before you zero out the grab on the evdev, or you can't grab
it again without rebooting.  The X Server does this; it's usually not
an issue for Chromium OS because it tends to just reboot, but everyone
else gets a locked up pointer.

I found this when copying the evdev_grab/input_device_grab() &
input_release_device()/evdev_ungrab() design pattern into some new
code to use for automated testing (record & playback of arbitrary
event streams) and for training software for gesture recognition.
When doing this sort of thing, you tend to repeat operations to obtain
large training sets, or string together a series of test gestures with
scripts, and the problem became obvious.

This is pretty easy to reproduce with a modified evtest program that
does an EVIOCGRAB, if you don't have a Synaptics touchpad to use for
testing (but you won't get whatever you grab back unless you use the
same fd or reboot).

I have some patches to a number of bugs in the Synaptics driver, and
some additional code cleanup vs. checkpatch.pl for
drivers/input/evdev.c too, but I thought I'd start small.

-- Terry

On Thu, Feb 10, 2011 at 3:54 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Thu, Feb 10, 2011 at 03:42:50PM -0800, tlambert@chromium.org wrote:
> > From: Terry Lambert <tlambert@chromium.org>
> >
> > Fixed order of calls in evdev_ungrab to allow iterative use of
> > code which grabs and releases input event devices.
> >
>
> Sorry, could you  please be more verbose?
>
> > Signed-off-by: Terry Lambert <tlambert@chromium.org>
> > ---
> >  drivers/input/evdev.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> > index c8471a2..0bac8da 100644
> > --- a/drivers/input/evdev.c
> > +++ b/drivers/input/evdev.c
> > @@ -160,9 +160,9 @@ static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
> >       if (evdev->grab != client)
> >               return  -EINVAL;
> >
> > +     input_release_device(&evdev->handle);
> >       rcu_assign_pointer(evdev->grab, NULL);
> >       synchronize_rcu();
> > -     input_release_device(&evdev->handle);
> >
> >       return 0;
> >  }
> > --
> > 1.7.3.1
> >
>
> --
> Dmitry
