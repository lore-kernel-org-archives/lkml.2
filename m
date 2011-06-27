Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1F0Fjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:39:48 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3838 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab1F0Fiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:38:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
Date: Mon, 27 Jun 2011 07:38:27 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4E0519B7.3000304@redhat.com> <201106262020.20432.arnd@arndb.de> <4E077FB9.7030600@redhat.com>
In-Reply-To: <4E077FB9.7030600@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106270738.27417.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 26, 2011 20:51:37 Mauro Carvalho Chehab wrote:
> Em 26-06-2011 15:20, Arnd Bergmann escreveu:
> > On Sunday 26 June 2011 19:30:46 Mauro Carvalho Chehab wrote:
> >>> There was a lot of debate whether undefined ioctls on non-ttys should
> >>> return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY to
> >>> -EINVAL at some point in the pre-git era, IIRC.
> >>>
> >>> Inside of v4l2, I believe this is handled by video_usercopy(), which
> >>> turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you observe
> >>> where this is not done correctly and we do return ENOIOCTLCMD to
> >>> vfs_ioctl?
> >>
> >> Well, currently, it is returning -EINVAL maybe due to the mass-conversions
> >> you've mentioned.
> > 
> > I mean what do you return *to* vfs_ioctl from v4l? The conversions must
> > have been long before we introduced compat_ioctl and ENOIOCTLCMD.
> > 
> > As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD into
> > EINVAL, so changing the vfs functions would not have any effect.
> 
> Yes.  This discussion was originated by a RFC patch proposing to change 
> video_ioctl2 to return -ENOIOCTLCMD instead of -EINVAL.
> 
> >> The point is that -EINVAL has too many meanings at V4L. It currently can be
> >> either that an ioctl is not supported, or that one of the parameters had
> >> an invalid parameter. If the userspace can't distinguish between an unimplemented
> >> ioctl and an invalid parameter, it can't decide if it needs to fall back to
> >> some different methods of handling a V4L device.
> >>
> >> Maybe the answer would be to return -ENOTTY when an ioctl is not implemented.
> > 
> > That is what a lot of subsystems do these days. But wouldn't that change
> > your ABI?
> 
> Yes. The patch in question is also changing the DocBook spec for the ABI. We'll
> likely need to drop some notes about that at the features-to-be-removed.txt.
> 
> I don't think that applications are relying at -EINVAL in order to detect if
> an ioctl is not supported, but before merging such patch, we need to double-check.

I really don't think we can change this behavior. It's been part of the spec since
forever and it is not just open source apps that can rely on this, but also closed
source. Making an ABI change like this can really mess up applications.

We should instead review the spec and ensure that applications can discover what
is and what isn't supported through e.g. capabilities.

Regards,

	Hans
