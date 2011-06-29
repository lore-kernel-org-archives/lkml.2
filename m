Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1F2MfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab1F2MfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:35:03 -0400
Message-ID: <4E0B1BE8.3020500@redhat.com>
Date: Wed, 29 Jun 2011 09:34:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't
 exist
References: <4E0519B7.3000304@redhat.com> <201106271907.59067.hverkuil@xs4all.nl> <BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com> <201106280804.48742.hverkuil@xs4all.nl> <BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com>
In-Reply-To: <BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-06-2011 13:05, Linus Torvalds escreveu:
> On Mon, Jun 27, 2011 at 11:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

>> It was my understanding that we shouldn't break the userspace API. This breaks
>> the userspace API. If everyone else says it's fine to break the userspace API
>> this time, then who am I to object?
> 
> We are indeed never supposed to break userspace.
> 
> But that does not mean that we cannot fix bugs. It only means exactly
> what it says: we cannot break user space.
> 
> If we fix a bug, and it turns out that user space actually depends on
> that bug, then we need to revert the fix. But it never means "you can
> never make any changes at all to interfaces". It only means "you
> cannot make any changes that break applications".
> 
> There may be applications out there that really break when they get
> ENOTTY instead of EINVAL. But most cases that check for errors from
> ioctl's tend to just say "did this succeed or not" rather than "did
> this return EINVAL". That's *doubly* true since the error code has
> been ambiguous, so checking for the exact error code has always been
> pretty pointless.
> 
> So the common use of the error code tends to be for things like
> strerror(), and then it would be a real improvement to show
> "Inappropriate ioctl for device" when the device doesn't support that
> ioctl, wouldn't it?
> 
> But yes, let's try to fix it, and if it turns out that that breaks
> something, we must simply revert and probably add a comment to the
> source code ("EINVAL is wrong, it should be ENOTTY, but xyzzy only
> works with EINVAL").

I've applied the fix locally, using ENOTTY, and tested with 3 drivers that
have several non-implemented ioctl's: vivi, uvcvideo and gspca (they basically
don't implement tuner ioctl's. The uvcvideo doesn't implement the *STD ioctls,
and the gspca driver doesn't implement the ENUM_FRAME* ioctl's).

I tested with camorama (using libv4l1 conversion code), vlc, qv4l2, xawtv3 and 
mplayer. I also tested two closed source applications (Skype and flash - at twitcam). 
With all drivers, the applications worked as expected.

There is just a minor glitch with xawtv3, as it currently doesn't print an
error log if VIDIOC_G_STD returns -EINVAL when debug is disabled.
Yet, the error is not fatal and happens only once, during device probing.
Xawtv works fine, and suppressing the noise is an easy fix. As we're releasing 
version 1.101 of it with alsa streaming support, I'll latter add a code there
fixing it.

Complex TV applications like mythtv won't work if the devices don't implement
tuner and control ioctl's. I don't believe that it would fail if we change the
return code for unimplemented ioctls, because if an ioctl that mythtv
needs is not implemented, it will fail anyway. Unfortunately, installing
mythtv is a very complex task, and requires hours/days of work. I can't
affort to install it for testing ATM, but I'm sure others have it installed,
and can provide us some feedback.

So, I'll prepare the patches for replacing EINVAL to ENOTTY and add it at
next. This'll give us some time to get feedback about eventual breakages
on other tools that I didn't test.

Thanks,
Mauro
