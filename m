Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab1F0MI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 08:08:58 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:50458 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab1F0MHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 08:07:53 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jun 2011 08:07:52 EDT
Date: Mon, 27 Jun 2011 15:02:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl
 doesn't exist
Message-ID: <20110627120233.GD12671@valkosipuli.localdomain>
References: <4E0519B7.3000304@redhat.com>
 <201106262020.20432.arnd@arndb.de>
 <4E077FB9.7030600@redhat.com>
 <201106270738.27417.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106270738.27417.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Mon, Jun 27, 2011 at 07:38:27AM +0200, Hans Verkuil wrote:
> On Sunday, June 26, 2011 20:51:37 Mauro Carvalho Chehab wrote:
> > Em 26-06-2011 15:20, Arnd Bergmann escreveu:
> > > On Sunday 26 June 2011 19:30:46 Mauro Carvalho Chehab wrote:
> > >>> There was a lot of debate whether undefined ioctls on non-ttys should
> > >>> return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY to
> > >>> -EINVAL at some point in the pre-git era, IIRC.
> > >>>
> > >>> Inside of v4l2, I believe this is handled by video_usercopy(), which
> > >>> turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you observe
> > >>> where this is not done correctly and we do return ENOIOCTLCMD to
> > >>> vfs_ioctl?
> > >>
> > >> Well, currently, it is returning -EINVAL maybe due to the mass-conversions
> > >> you've mentioned.
> > > 
> > > I mean what do you return *to* vfs_ioctl from v4l? The conversions must
> > > have been long before we introduced compat_ioctl and ENOIOCTLCMD.
> > > 
> > > As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD into
> > > EINVAL, so changing the vfs functions would not have any effect.
> > 
> > Yes.  This discussion was originated by a RFC patch proposing to change 
> > video_ioctl2 to return -ENOIOCTLCMD instead of -EINVAL.
> > 
> > >> The point is that -EINVAL has too many meanings at V4L. It currently can be
> > >> either that an ioctl is not supported, or that one of the parameters had
> > >> an invalid parameter. If the userspace can't distinguish between an unimplemented
> > >> ioctl and an invalid parameter, it can't decide if it needs to fall back to
> > >> some different methods of handling a V4L device.
> > >>
> > >> Maybe the answer would be to return -ENOTTY when an ioctl is not implemented.
> > > 
> > > That is what a lot of subsystems do these days. But wouldn't that change
> > > your ABI?
> > 
> > Yes. The patch in question is also changing the DocBook spec for the ABI. We'll
> > likely need to drop some notes about that at the features-to-be-removed.txt.
> > 
> > I don't think that applications are relying at -EINVAL in order to detect if
> > an ioctl is not supported, but before merging such patch, we need to double-check.
> 
> I really don't think we can change this behavior. It's been part of the spec since
> forever and it is not just open source apps that can rely on this, but also closed
> source. Making an ABI change like this can really mess up applications.
> 
> We should instead review the spec and ensure that applications can discover what
> is and what isn't supported through e.g. capabilities.

As far as I understand, V4L2 wouldn't be the only kernel API to use ENOTTY
to tell that an ioctl doesn't exist; there are others. And many switched
from EINVAL they used in the past. From that point it would be good to do it
on V4L2 as well. Although I have to reckon that the V4L2 API does serve use
cases of quite different natures than these --- I can't think of an
equivalent e.g. to that astronomy application using V4L1 in the scope of
these:

Examples:
- Networking
- KVM
- SCSI/libata-scsi

Currently EINVAL is used to signal from a phletora of conditions in V4L2,
usually bad, in a way or another, parameters to an ioctl. The more low level
APIs we add (for cameras, for example), the less guessing of parameters can
be done in general. I think it would be important to distinguish the two
cases and we don't have enumeration capability (do we?) to tell which IOCTLs
the application should be expect to be able to use.

Interestingly enough, V4L2 core (v4l2_ioctl() in v4l2-dev.c) does return
ENOTTY *right now* when the IOCTL handler is not defined. Have we heard
about this up to now? :-)

As you mention, switching to ENOTTY in general would change the ABI which
would potentially break applications. Can this be handled in a way or
another? My understanding is that not many applications would rely on EINVAL
telling an IOCTL isn't implemented. GStreamer v4l2src might be one in its
attempt to figure out what kind of image sizes the device supports. Fixing
this would be a very small change.

In short, I think it would be beneficial to switch to ENOTTY in the long
run even if it causes some momentary pain.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
