Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1F0O4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:56:32 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3026 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab1F0O40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:56:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl  doesn't exist
Date: Mon, 27 Jun 2011 16:56:04 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4E0519B7.3000304@redhat.com> <86e5c1f0a0222d3b2cf371f3c9d3b067.squirrel@webmail.xs4all.nl> <4E088B83.2050001@redhat.com>
In-Reply-To: <4E088B83.2050001@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271656.04612.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 27, 2011 15:54:11 Mauro Carvalho Chehab wrote:
> Em 27-06-2011 09:17, Hans Verkuil escreveu:
> >> Hi Hans,
> >>
> >> On Mon, Jun 27, 2011 at 07:38:27AM +0200, Hans Verkuil wrote:
> >>> On Sunday, June 26, 2011 20:51:37 Mauro Carvalho Chehab wrote:
> >>>> Em 26-06-2011 15:20, Arnd Bergmann escreveu:
> >>>>> On Sunday 26 June 2011 19:30:46 Mauro Carvalho Chehab wrote:
> >>>>>>> There was a lot of debate whether undefined ioctls on non-ttys
> >>> should
> >>>>>>> return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY
> >>> to
> >>>>>>> -EINVAL at some point in the pre-git era, IIRC.
> >>>>>>>
> >>>>>>> Inside of v4l2, I believe this is handled by video_usercopy(),
> >>> which
> >>>>>>> turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you
> >>> observe
> >>>>>>> where this is not done correctly and we do return ENOIOCTLCMD to
> >>>>>>> vfs_ioctl?
> >>>>>>
> >>>>>> Well, currently, it is returning -EINVAL maybe due to the
> >>> mass-conversions
> >>>>>> you've mentioned.
> >>>>>
> >>>>> I mean what do you return *to* vfs_ioctl from v4l? The conversions
> >>> must
> >>>>> have been long before we introduced compat_ioctl and ENOIOCTLCMD.
> >>>>>
> >>>>> As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD
> >>> into
> >>>>> EINVAL, so changing the vfs functions would not have any effect.
> >>>>
> >>>> Yes.  This discussion was originated by a RFC patch proposing to
> >>> change
> >>>> video_ioctl2 to return -ENOIOCTLCMD instead of -EINVAL.
> >>>>
> >>>>>> The point is that -EINVAL has too many meanings at V4L. It
> >>> currently can be
> >>>>>> either that an ioctl is not supported, or that one of the
> >>> parameters had
> >>>>>> an invalid parameter. If the userspace can't distinguish between an
> >>> unimplemented
> >>>>>> ioctl and an invalid parameter, it can't decide if it needs to fall
> >>> back to
> >>>>>> some different methods of handling a V4L device.
> >>>>>>
> >>>>>> Maybe the answer would be to return -ENOTTY when an ioctl is not
> >>> implemented.
> >>>>>
> >>>>> That is what a lot of subsystems do these days. But wouldn't that
> >>> change
> >>>>> your ABI?
> >>>>
> >>>> Yes. The patch in question is also changing the DocBook spec for the
> >>> ABI. We'll
> >>>> likely need to drop some notes about that at the
> >>> features-to-be-removed.txt.
> >>>>
> >>>> I don't think that applications are relying at -EINVAL in order to
> >>> detect if
> >>>> an ioctl is not supported, but before merging such patch, we need to
> >>> double-check.
> >>>
> >>> I really don't think we can change this behavior. It's been part of the
> >>> spec since
> >>> forever and it is not just open source apps that can rely on this, but
> >>> also closed
> >>> source. Making an ABI change like this can really mess up applications.
> >>>
> >>> We should instead review the spec and ensure that applications can
> >>> discover what
> >>> is and what isn't supported through e.g. capabilities.
> >>
> >> As far as I understand, V4L2 wouldn't be the only kernel API to use ENOTTY
> >> to tell that an ioctl doesn't exist; there are others. And many switched
> >> from EINVAL they used in the past. From that point it would be good to do
> >> it
> >> on V4L2 as well. Although I have to reckon that the V4L2 API does serve
> >> use
> >> cases of quite different natures than these --- I can't think of an
> >> equivalent e.g. to that astronomy application using V4L1 in the scope of
> >> these:
> >>
> >> Examples:
> >> - Networking
> >> - KVM
> >> - SCSI/libata-scsi
> >>
> >> Currently EINVAL is used to signal from a phletora of conditions in V4L2,
> >> usually bad, in a way or another, parameters to an ioctl. The more low
> >> level
> >> APIs we add (for cameras, for example), the less guessing of parameters
> >> can
> >> be done in general. I think it would be important to distinguish the two
> >> cases and we don't have enumeration capability (do we?) to tell which
> >> IOCTLs
> >> the application should be expect to be able to use.
> > 
> > While we don't have an enum capability, in many cases you can deduce
> > whether a particular ioctl should be supported or not. Usually based on
> > capabilities, sometimes because certain ioctls allow 'NOP' operations that
> > allow you to test for their presence.
> > 
> > Of course, drivers are not always consistent here, but that's a separate
> > problem.
> 
> Any "hint" code that would try to do some NOP operations may fail. One of the
> reasons is that such hint is not documented. Yet, I don't officially support
> such "hint" methods at the API.

The point is that the spec can easily be improved to make such 'NOP' operations
explicit, or to require that if a capability is present, then the corresponding
ioctl(s) must also be present. Things like that are easy to verify as well with
v4l2-compliance.

> >> Interestingly enough, V4L2 core (v4l2_ioctl() in v4l2-dev.c) does return
> >> ENOTTY *right now* when the IOCTL handler is not defined. Have we heard
> >> about this up to now? :-)
> > 
> > No, but that's because all drivers have an ioctl handler :-) So you never
> > see ENOTTY.
> 
> Well, a V4L1 call now returns -ENOTTY, with the current behaviour. 

How? I don't see that. All drivers have an ioctl handler, so all ioctls will
go through that handler, which returns -EINVAL for V4L1 ioctls.

> Btw, there are two drivers returning -ENOTTY, when the device got disconnected
> (or firmware were not uploaded).
> 
> The truth is that the current API specs for return code is bogus.

Bogus in what way? It's been documented very clearly for years. We may not like
that design decision (I certainly don't like it), but someone clearly thought
about it at the time.

You know that I am usually more than willing to make/accept ABI changes, especially
in ambiguous circumstances (and we have a lot of those). But this particular one
is actually for once consistently implemented in all drivers and apps can (and
probably do) rely on them. And that includes also closed source applications,
and there is no way we can change those. Neither is this something that only
affects some niche products, this is subsystem-wide.

> 
> > 
> >> As you mention, switching to ENOTTY in general would change the ABI which
> >> would potentially break applications. Can this be handled in a way or
> >> another? My understanding is that not many applications would rely on
> >> EINVAL
> >> telling an IOCTL isn't implemented. GStreamer v4l2src might be one in its
> >> attempt to figure out what kind of image sizes the device supports. Fixing
> >> this would be a very small change.
> >>
> >> In short, I think it would be beneficial to switch to ENOTTY in the long
> >> run even if it causes some momentary pain.
> > 
> > I would like that as well, but the V4L2 Specification explicitly mentions
> > EINVAL as the error code if an ioctl is not supported. It has done so
> > since it was created. You cannot just change that. And closed source
> > programs may  very well rely on this.
> 
> The V4L2 spec needs to be fixed with respect to error codes. Driver authors
> are much more creative than DocBook authors ;) There are a lot of return
> codes used by the drivers whose API spec doesn't mention (and, on this subject, 
> the same applies to the DVB API). What I've seen is that:
> - Sometimes, a core return code is returned. One of the important examples is
>   the ENOSPC error returned when the usb core refuses to stream when the USB
>   bus reached 80% of the available bandwidth. There's a patch floating around that
>   would allow to override the 80% hard limit, via sysfs. So, if properly documented,
>   an userspace application could give a hint that the user needs to either use a
>   different bus or try to change the hard limit;
> - For every ioctl, it presents its own "private" list of error codes. If someone wants
>   to add a new code (for example, standardizing ENOTTY or ENOSPC), all affected
>   ioctl's will need to be touched. This is hard to maintain;
> - Drivers are not compliant with error codes.
> 
> The right thing to do is to create a separate chapter for error codes, based on errno(3)
> man page, where we document all error codes that should be used by the drivers. Then,
> at the ioctl pages, link to the common chapter and, only when needed, document special
> cases where an error code for that specific ioctl has some special meaning.

Great, I've no problem with that. But this particular error code you want to change
is actually implemented *consistently* in all drivers. There is no confusion, no
ambiguity, and it is according to the spec.

> I ran a script here to check how many different error codes are used inside drivers/media:
> 
> $ find drivers/media -type f -name '*.[ch]'  >files
> $ grep define `find . -name errno*.h`|perl -ne 'print "$1\n" if (/\#define\s+(E[^\s]+)/)'|sort|uniq >errors
> $ for i in `cat errors`; do COUNT=$(git grep -c $i `cat files`|wc -l); if [ "$COUNT" != "0" ]; then echo $i $COUNT; fi; done
> 
> The result is that we're using 53 different types of errors, but the API specs documents
> only 17 of them. Those are the currently used errors at drivers/media:
> 
> ERROR CODE     |NUMBER OF *.c/*.h FILES USING IT
> ---------------|--------------------------------
> E2BIG           1
> EACCES          8
> EAGAIN          66
> EBADF           1
> EBADFD          1
> EBADR           2
> EBADRQC         2
> EBUSY           149
> ECHILD          1
> ECONNRESET      25
> EDEADLK         1
> EDOM            1
> EEXIST          3
> EFAULT          230
> EFBIG           1
> EILSEQ          8
> EINIT           2
> EINPROGRESS     6
> EINTR           21
> EINVAL          501
> EIO             305
> EMFILE          1
> ENFILE          7
> ENOBUFS         7
> ENODATA         4
> ENODEV          270
> ENOENT          46
> ENOIOCTLCMD     31
> ENOMEM          359
> ENOSPC          13
> ENOSR           7
> ENOSYS          15
> ENOTSUP         3
> ENOTSUPP        3
> ENOTTY          5
> ENXIO           26
> EOPNOTSUPP      19
> EOVERFLOW       14
> EPERM           47
> EPIPE           12
> EPROTO          11
> ERANGE          25
> EREMOTE         80
> EREMOTEIO       80
> ERESTART        32
> ERESTARTSYS     32
> ESHUTDOWN       27
> ESPIPE          3
> ETIME           53
> ETIMEDOUT       37
> EUSERS          2
> EWOULDBLOCK     14
> EXDEV           1
> 
> I suspect that we'll need to both fix some drivers, and the API, as I bet that
> the same error conditions are reported differently on different drivers.
> 
> > I don't think changing such an important return value is acceptable.
> 
> As I said, the current API is bogus with respect to error codes. Of course,
> we need to do take care to avoid userspace applications breakage, but we can't
> use the excuse that it is there for a long time as a reason for not fixing it.

The fact that many drivers use error codes creatively doesn't give us an excuse
to just change the one error code that is actually used everywhere according to
the spec! That's faulty logic.

Regards,

	Hans
