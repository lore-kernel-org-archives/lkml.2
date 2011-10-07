Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1JGGgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:36:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39451 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1JGGgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:36:23 -0400
Date: Thu, 6 Oct 2011 23:36:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Chase Douglas <chasedouglas@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - use monotonic clock for event timestamps
Message-ID: <20111007063617.GA6167@core.coreip.homeip.net>
References: <1317624200-9762-1-git-send-email-djkurtz@chromium.org>
 <20111003090641.GA5615@polaris.bitmath.org>
 <CAGS+omAj9z2-Au2HABtDKHQGRBNVxXygF2cz+L8UMeTHRrMjbA@mail.gmail.com>
 <20111005092341.GB6840@polaris.bitmath.org>
 <4E8C6B1F.4090904@gmail.com>
 <20111006034202.GC20217@core.coreip.homeip.net>
 <CAGS+omDF3mi_tXXxHR2XOyjJMfuc=j2rWBMctJRGr7GeeE+yRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omDF3mi_tXXxHR2XOyjJMfuc=j2rWBMctJRGr7GeeE+yRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 02:25:39PM +0800, Daniel Kurtz wrote:
> On Thu, Oct 6, 2011 at 11:42 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Oct 05, 2011 at 03:35:11PM +0100, Chase Douglas wrote:
> >> On 10/05/2011 10:23 AM, Henrik Rydberg wrote:
> >> >> I understand your concern about breaking random drivers, and am hoping
> >> >> that someon on this list could indicate whether this is a real concern
> >> >> or not.  To get a better feeling for possible regressions, I checked
> >> >> xf86-input-evdev & -synaptics, and neither uses the evdev timestamp in
> >> >> their current incarnations.  Any idea what else might be a good place
> >> >> to check?
> >> >
> >> > The input system is used for all sorts of events - switches, for
> >> > instance. The point is that it is nearly impossible to know if
> >> > something will break or not, hence the reluctance to modify interfaces.
> >> >
> >> >> One option is to make the evdev timestamp clock source a per-driver
> >> >> configuration option (controllable from userspace?).  This sounds like
> >> >> it is doable, but would be significantly more complicated.
> >> >>
> >> >> Another option would be to timestamp with monotonicraw + boottime +
> >> >> sleeptime.  This would be approximately wall clock time, but without
> >> >> ntp and slew adjustments.  But, I fear this would just make the rare
> >> >> driver issue less obvious, since it would only become obvious when the
> >> >> two clock sources started drifting apart.
> >> >
> >> > I agree, the problem is not really solvable. Dmitry?
> >>
> >> We could put it into the -next tree early on in the cycle, and then it
> >> will be in -next for a cycle and in Linus' tree for the real dev cycle.
> >> By that time we would hope any issues would have emerged.
> >
> > No, I do not think so - as we already descovered users of that field (if
> > they are exist) are pretty obscure and I doubt that they actively track
> > development kernels.
> >
> >>
> >> I'm not sure if that is a responsible approach. I agree that the change
> >> would be good, but how sure would we be that nothing would break based
> >> only on testing in development trees?
> >>
> >> My personal thoughts are that I doubt it would cause issues. Based on
> >> that gut feel, I would say that this approach is reasonable. However,
> >> I'm just one voice in all this :).
> >
> > I can see key loggers wanting to see real time of captured events
> > instead of monotonic time...
> 
> Such a userspace key logger or driver that uses the timestamp field
> today is probably comparing it to userspace time queried by
> gettimeofday().  To work with a monotonic timestamp, they could use
> clock_gettime(CLOCK_MONOTONIC, &ts) instead.

They sure can adopt. Still, this constitutes ABI breakage and thus is
not allowed.

> 
> > If we really need this I think we'll have to go per-file descriptor time
> > source selection and ioctl way. However can we get the use case
> > explained again? Why is wall clock jumps so much in middle of the
> > motion? Can userspace detect negative time jumps and simply abort
> > gestures in such cases?
> 
> Userspace can detect 'time going backwards' easily enough, but
> detecting 'time slowing down' or 'time speeding up' is harder.

Realistically how much of slowdown/speeding up are we talking about?

> 
> > Thanks.
> >
> > --
> > Dmitry
> 
> Userspace (touch/mouse) input drivers that want to do ballistics
> calculations would benefit from a good, accurate, monotonic timestamp
> as low down in the stack as possible to reduce jitter.  In particular,
> the timestamp deltas are used to determine contact velocity, and can also
> be used to better understand and compensate for response latency and jitter
> throughout the entire stack.
> 
> Another approach could be:
>   Treat the "evdev-layer-assigned" timestamp as purely informational -
> it is applied per-event anyway, which isn't really what userspace
> needs.  Instead, have touch kernel drivers use another "timestamp"
> axis/valuator (ABS_TIMESTAMP?), based off of a monotonic time source,
> (preferably get_monotonic_boottime()) taken somewhere early in irq processing.

That means that we should go through all the drivers and adjust...

> 
>    My concern about this approach was that it would make drivers
> significantly more chatty.  evdev currently squashes events, or even
> entire reports (I don't know the proper term for collection of events
> terminated by EV_SYN), 

I call it event packet.

> if the values don't change.  The timestamp axis
> would always change, hence it would always be sent, even if no other
> axes change.  Of course, we can mitigate this with special-case
> handling of the ABS_TIMESTAMP in the evdev layer.
> 

I'd prefer if we go this route then:

1. Have input core emit this event. Then we could decide if we should
suppress it when suppressing entire packet.
2. Make it MSC_ event.
3. Turn it on and off via ioctl since not all users are interested in
this facility.

OTOH if we do ioctl why don't we simply allow usres select monotnic vs
wall time in event structure.

Still, why does your clock fluctuate so much that it matters?

Thanks.

-- 
Dmitry
