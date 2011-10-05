Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab1JEHza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:55:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab1JEHz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:55:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=hfHVoB96Rlx5ISmXkNMdWQVJrKjy7lU0UOummUZamfSCluv20fof5rs+47j40YRXS
	Vc7UVZkhb9dV2huIEq+ug==
MIME-Version: 1.0
In-Reply-To: <20111003090641.GA5615@polaris.bitmath.org>
References: <1317624200-9762-1-git-send-email-djkurtz@chromium.org> <20111003090641.GA5615@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 5 Oct 2011 15:55:05 +0800
X-Google-Sender-Auth: ZedCTloY2gumlAnisOHJVTh1NQg
Message-ID: <CAGS+omAj9z2-Au2HABtDKHQGRBNVxXygF2cz+L8UMeTHRrMjbA@mail.gmail.com>
Subject: Re: [PATCH] Input: evdev - use monotonic clock for event timestamps
To: Henrik Rydberg <rydberg@euromail.se>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Mon, Oct 3, 2011 at 5:06 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> Hi Daniel,
>
> > Using wallclock time for event timestamps subjects inter-event timing to
> > ntp and other clock adjustments.  This complicates userspace drivers
> > that use these timestamps to calculate velocities, or while processing
> > state transitions.
> >
> > Instead, use the kernel monotonic clock for event timestamps, which is
> > at least guaranteed never to go backwards.
> >
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> >  drivers/input/evdev.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> > index 4cf2534..118f936 100644
> > --- a/drivers/input/evdev.c
> > +++ b/drivers/input/evdev.c
> > @@ -94,8 +94,11 @@ static void evdev_event(struct input_handle *handle,
> >       struct evdev *evdev = handle->private;
> >       struct evdev_client *client;
> >       struct input_event event;
> > +     struct timespec now;
> >
> > -     do_gettimeofday(&event.time);
> > +     getrawmonotonic(&now);
> > +     event.time.tv_sec = now.tv_sec;
> > +     event.time.tv_usec = now.tv_nsec/1000;
> >       event.type = type;
> >       event.code = code;
> >       event.value = value;
> > --
> > 1.7.3.1
>
> Good thing per se, but reporting time relative to boot instead of
> using real time, for all input events, may cause regression on some
> obscure systems. Perhaps it is possible to improve on the desired
> monotonicity in most cases, without such a drastic change.
>
> Thanks,
> Henrik

Thanks for responding!  This is the smallest possible patch that I
could think of that illustrates what I'd like to see.  What other
options do we have to achieve the same affect?

I understand your concern about breaking random drivers, and am hoping
that someon on this list could indicate whether this is a real concern
or not.  To get a better feeling for possible regressions, I checked
xf86-input-evdev & -synaptics, and neither uses the evdev timestamp in
their current incarnations.  Any idea what else might be a good place
to check?

One option is to make the evdev timestamp clock source a per-driver
configuration option (controllable from userspace?).  This sounds like
it is doable, but would be significantly more complicated.

Another option would be to timestamp with monotonicraw + boottime +
sleeptime.  This would be approximately wall clock time, but without
ntp and slew adjustments.  But, I fear this would just make the rare
driver issue less obvious, since it would only become obvious when the
two clock sources started drifting apart.

-Dan
