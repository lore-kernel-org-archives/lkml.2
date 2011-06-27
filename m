Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab1F0MTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 08:19:35 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1927 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598Ab1F0MRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 08:17:35 -0400
Message-ID: <86e5c1f0a0222d3b2cf371f3c9d3b067.squirrel@webmail.xs4all.nl>
In-Reply-To: <20110627120233.GD12671@valkosipuli.localdomain>
References: <4E0519B7.3000304@redhat.com> <201106262020.20432.arnd@arndb.de>
    <4E077FB9.7030600@redhat.com> <201106270738.27417.hverkuil@xs4all.nl>
    <20110627120233.GD12671@valkosipuli.localdomain>
Date: Mon, 27 Jun 2011 14:17:25 +0200
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl 
 doesn't exist
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@iki.fi>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
User-Agent: SquirrelMail/1.4.18
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Hans,
>
> On Mon, Jun 27, 2011 at 07:38:27AM +0200, Hans Verkuil wrote:
>> On Sunday, June 26, 2011 20:51:37 Mauro Carvalho Chehab wrote:
>> > Em 26-06-2011 15:20, Arnd Bergmann escreveu:
>> > > On Sunday 26 June 2011 19:30:46 Mauro Carvalho Chehab wrote:
>> > >>> There was a lot of debate whether undefined ioctls on non-ttys
>> should
>> > >>> return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY
>> to
>> > >>> -EINVAL at some point in the pre-git era, IIRC.
>> > >>>
>> > >>> Inside of v4l2, I believe this is handled by video_usercopy(),
>> which
>> > >>> turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you
>> observe
>> > >>> where this is not done correctly and we do return ENOIOCTLCMD to
>> > >>> vfs_ioctl?
>> > >>
>> > >> Well, currently, it is returning -EINVAL maybe due to the
>> mass-conversions
>> > >> you've mentioned.
>> > >
>> > > I mean what do you return *to* vfs_ioctl from v4l? The conversions
>> must
>> > > have been long before we introduced compat_ioctl and ENOIOCTLCMD.
>> > >
>> > > As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD
>> into
>> > > EINVAL, so changing the vfs functions would not have any effect.
>> >
>> > Yes.  This discussion was originated by a RFC patch proposing to
>> change
>> > video_ioctl2 to return -ENOIOCTLCMD instead of -EINVAL.
>> >
>> > >> The point is that -EINVAL has too many meanings at V4L. It
>> currently can be
>> > >> either that an ioctl is not supported, or that one of the
>> parameters had
>> > >> an invalid parameter. If the userspace can't distinguish between an
>> unimplemented
>> > >> ioctl and an invalid parameter, it can't decide if it needs to fall
>> back to
>> > >> some different methods of handling a V4L device.
>> > >>
>> > >> Maybe the answer would be to return -ENOTTY when an ioctl is not
>> implemented.
>> > >
>> > > That is what a lot of subsystems do these days. But wouldn't that
>> change
>> > > your ABI?
>> >
>> > Yes. The patch in question is also changing the DocBook spec for the
>> ABI. We'll
>> > likely need to drop some notes about that at the
>> features-to-be-removed.txt.
>> >
>> > I don't think that applications are relying at -EINVAL in order to
>> detect if
>> > an ioctl is not supported, but before merging such patch, we need to
>> double-check.
>>
>> I really don't think we can change this behavior. It's been part of the
>> spec since
>> forever and it is not just open source apps that can rely on this, but
>> also closed
>> source. Making an ABI change like this can really mess up applications.
>>
>> We should instead review the spec and ensure that applications can
>> discover what
>> is and what isn't supported through e.g. capabilities.
>
> As far as I understand, V4L2 wouldn't be the only kernel API to use ENOTTY
> to tell that an ioctl doesn't exist; there are others. And many switched
> from EINVAL they used in the past. From that point it would be good to do
> it
> on V4L2 as well. Although I have to reckon that the V4L2 API does serve
> use
> cases of quite different natures than these --- I can't think of an
> equivalent e.g. to that astronomy application using V4L1 in the scope of
> these:
>
> Examples:
> - Networking
> - KVM
> - SCSI/libata-scsi
>
> Currently EINVAL is used to signal from a phletora of conditions in V4L2,
> usually bad, in a way or another, parameters to an ioctl. The more low
> level
> APIs we add (for cameras, for example), the less guessing of parameters
> can
> be done in general. I think it would be important to distinguish the two
> cases and we don't have enumeration capability (do we?) to tell which
> IOCTLs
> the application should be expect to be able to use.

While we don't have an enum capability, in many cases you can deduce
whether a particular ioctl should be supported or not. Usually based on
capabilities, sometimes because certain ioctls allow 'NOP' operations that
allow you to test for their presence.

Of course, drivers are not always consistent here, but that's a separate
problem.

> Interestingly enough, V4L2 core (v4l2_ioctl() in v4l2-dev.c) does return
> ENOTTY *right now* when the IOCTL handler is not defined. Have we heard
> about this up to now? :-)

No, but that's because all drivers have an ioctl handler :-) So you never
see ENOTTY.

> As you mention, switching to ENOTTY in general would change the ABI which
> would potentially break applications. Can this be handled in a way or
> another? My understanding is that not many applications would rely on
> EINVAL
> telling an IOCTL isn't implemented. GStreamer v4l2src might be one in its
> attempt to figure out what kind of image sizes the device supports. Fixing
> this would be a very small change.
>
> In short, I think it would be beneficial to switch to ENOTTY in the long
> run even if it causes some momentary pain.

I would like that as well, but the V4L2 Specification explicitly mentions
EINVAL as the error code if an ioctl is not supported. It has done so
since it was created. You cannot just change that. And closed source
programs may  very well rely on this.

I don't think changing such an important return value is acceptable.

A better approach would be to allow applications to deduce whether ioctls
are (should be) present or not based on capabilities, etc. And document
that in the spec and ensure that drivers do this right.

The v4l2-compliance tool is already checking that where possible.

Regards,

      Hans

