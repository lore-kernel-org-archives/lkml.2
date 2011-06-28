Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab1F1QIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:08:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129Ab1F1QGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <201106280804.48742.hverkuil@xs4all.nl>
References: <4E0519B7.3000304@redhat.com> <201106271907.59067.hverkuil@xs4all.nl>
 <BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com> <201106280804.48742.hverkuil@xs4all.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Jun 2011 09:05:53 -0700
Message-ID: <BANLkTi=6W0quy1M71UapwKDe97E67b4EiA@mail.gmail.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl
 doesn't exist
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 11:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Of course, since vfs_ioctl does the same thing this is clearly isn't some
> isolated V4L thing. Pot. Kettle.

Oh, absolutely. V4L is not at all the only confused user around.

The EINVAL thing goes way back, and is a disaster. It predates Linux
itself, as far as I can tell. You'll fin dlots of man-pages that have
this line in it:

  EINVAL Request or argp is not valid.

and it shows up in POSIX etc. And sadly, it generally shows up
_before_ the line that says

  ENOTTY The specified request does not apply to the kind of object
that the descriptor d references.

so a lot of people get to the EINVAL, and never even notice the ENOTTY.

And the above is from the current Linux man-pages - they are better
than most. Googling for posix and ioctl, the first hit is some
streams-specific man-page that is much worse, and makes you really
think that EINVAL would be the right error for a bad ioctl.

The reason is probably that ENOTTY has always been a "wft?" kind of
error code. It doesn't make sense as a name for some filesystem or
driver writer. Any sane person goes "Of _course_ it's not a tty, why
would I say that?"

At least glibc (and hopefully other C libraries) use a _string_ that
makes much more sense: strerror(ENOTTY) is "Inappropriate ioctl for
device"

The particular translation of ENOIOCTLCMD to EINVAL was always a
mistake. I'll happily try to change it for 3.1, but I'll need to do it
early in the merge window to check for any issues.

(In fact, the _correct_ thing to do would probably be to just do

   #define ENOIOCTLCMD ENOTTY

and get rid of any translation - just giving ENOTTY a more appropriate
name and less chance for confusion)

> It was my understanding that we shouldn't break the userspace API. This breaks
> the userspace API. If everyone else says it's fine to break the userspace API
> this time, then who am I to object?

We are indeed never supposed to break userspace.

But that does not mean that we cannot fix bugs. It only means exactly
what it says: we cannot break user space.

If we fix a bug, and it turns out that user space actually depends on
that bug, then we need to revert the fix. But it never means "you can
never make any changes at all to interfaces". It only means "you
cannot make any changes that break applications".

There may be applications out there that really break when they get
ENOTTY instead of EINVAL. But most cases that check for errors from
ioctl's tend to just say "did this succeed or not" rather than "did
this return EINVAL". That's *doubly* true since the error code has
been ambiguous, so checking for the exact error code has always been
pretty pointless.

So the common use of the error code tends to be for things like
strerror(), and then it would be a real improvement to show
"Inappropriate ioctl for device" when the device doesn't support that
ioctl, wouldn't it?

But yes, let's try to fix it, and if it turns out that that breaks
something, we must simply revert and probably add a comment to the
source code ("EINVAL is wrong, it should be ENOTTY, but xyzzy only
works with EINVAL").

                                       Linus
