Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1F0UuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:50:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab1F0UuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <201106271907.59067.hverkuil@xs4all.nl>
References: <4E0519B7.3000304@redhat.com> <201106271656.04612.hverkuil@xs4all.nl>
 <4E08A2E6.6020902@redhat.com> <201106271907.59067.hverkuil@xs4all.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Jun 2011 13:48:48 -0700
Message-ID: <BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com>
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

On Mon, Jun 27, 2011 at 10:07 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> No, what we do is perfectly consistent: i.e. we always return EINVAL when an
> ioctl is not supported. That's what 'consistent' means. Whether that is the
> *right* error code is something else.

You don't even understand the problem.

The problem is two-fold:
 (a) it's the _wrong_ error code (this part you seem to get)
but also
 (b) you ALSO return -EINVAL for ioctl's you support!

How har dis (b) to understand? The fact is, -EINVAL does not mean "I
don't support that ioctl". It _should_ mean "I _do_ support that
ioctl, but you passed me bogus arguments for that ioctl that I cannot
handle".

And right now, for the v4l crowd, -EINVAL means "random error code
that _could_ be because the ioctl doesn't exist, but it could also be
because the ioctl _does_ exist but didn't like it's value".

See the problem?

The correct error code for "I don't understand this ioctl" is ENOTTY.
The naming may be odd, but you should think of that error value as a
"unrecognized ioctl number, you're feeding me random numbers that I
don't understand and I assume for historical reasons that you tried to
do some tty operation on me".

I don't understand why the v4l people have such a hard time getting
this. This has been going on for years.

I would suggest that somebody just switch around the EINVAL in
__video_do_ioctl() to -ENOTTY (and change the ENOIOCTLCMD translation
to also make it ENOTTY instead of EINVAL) and just try to see if
anything breaks.

Maybe things actually break, and we'd have to undo it for
compatibility reasons (and perhaps add a comment about the program
that is so flaky that it needs a EINVAL return from the ioctl), but I
really do not understand people like you who seem to argue against
doing the right thing without even _trying_ it.

Saying that your API is "consistent" is clearly bullshit. Your API is
_wrong_. It's not consistent. Returning EINVAL can mean two different
things, there's no way to tell which case it was - that's not
"consistent" by any stretch of the imagination.

                            Linus
