Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1F1GHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:07:36 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2127 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1F1GGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:06:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
Date: Tue, 28 Jun 2011 08:04:48 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4E0519B7.3000304@redhat.com> <201106271907.59067.hverkuil@xs4all.nl> <BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com>
In-Reply-To: <BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106280804.48742.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 27, 2011 22:48:48 Linus Torvalds wrote:
> On Mon, Jun 27, 2011 at 10:07 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > No, what we do is perfectly consistent: i.e. we always return EINVAL when an
> > ioctl is not supported. That's what 'consistent' means. Whether that is the
> > *right* error code is something else.
> 
> You don't even understand the problem.
> 
> The problem is two-fold:
>  (a) it's the _wrong_ error code (this part you seem to get)
> but also
>  (b) you ALSO return -EINVAL for ioctl's you support!
> 
> How har dis (b) to understand? The fact is, -EINVAL does not mean "I
> don't support that ioctl". It _should_ mean "I _do_ support that
> ioctl, but you passed me bogus arguments for that ioctl that I cannot
> handle".
> 
> And right now, for the v4l crowd, -EINVAL means "random error code
> that _could_ be because the ioctl doesn't exist, but it could also be
> because the ioctl _does_ exist but didn't like it's value".
> 
> See the problem?

Duh. Of course I see the problem. I've seen the problem ever since I started
working on V4L back in 2004.

Of course, since vfs_ioctl does the same thing this is clearly isn't some
isolated V4L thing. Pot. Kettle.
 
> The correct error code for "I don't understand this ioctl" is ENOTTY.
> The naming may be odd, but you should think of that error value as a
> "unrecognized ioctl number, you're feeding me random numbers that I
> don't understand and I assume for historical reasons that you tried to
> do some tty operation on me".
> 
> I don't understand why the v4l people have such a hard time getting
> this. This has been going on for years.
> 
> I would suggest that somebody just switch around the EINVAL in
> __video_do_ioctl() to -ENOTTY (and change the ENOIOCTLCMD translation
> to also make it ENOTTY instead of EINVAL) and just try to see if
> anything breaks.
> 
> Maybe things actually break, and we'd have to undo it for
> compatibility reasons (and perhaps add a comment about the program
> that is so flaky that it needs a EINVAL return from the ioctl), but I
> really do not understand people like you who seem to argue against
> doing the right thing without even _trying_ it.
> 
> Saying that your API is "consistent" is clearly bullshit. Your API is
> _wrong_. It's not consistent. Returning EINVAL can mean two different
> things, there's no way to tell which case it was - that's not
> "consistent" by any stretch of the imagination.

I call it consistently wrong :-)

Listen, this error code is wrong. But it unfortunately has been documented
like that for years. It's part of the V4L userspace API. I have no clue who
may rely on this. I have no clue what might break if we change it. And the
only way to know that is by actually releasing a kernel with that change.

It was my understanding that we shouldn't break the userspace API. This breaks
the userspace API. If everyone else says it's fine to break the userspace API
this time, then who am I to object?

Regards,

	Hans

> 
>                             Linus
> 
