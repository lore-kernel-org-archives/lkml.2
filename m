Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab1CIJzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:55:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58760 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756933Ab1CIJzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:55:10 -0500
Date: Wed, 9 Mar 2011 09:55:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: cliff.cai@analog.com, device-drivers-devel@blackfin.uclinux.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
Message-ID: <20110309095506.GA6923@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <20110307145931.GK13471@opensource.wolfsonmicro.com>
 <AANLkTi=e1xDz6fhBU7NL32DXL1J9Y1CDD2bHQVL6oASw@mail.gmail.com>
 <20110307155508.GM13471@opensource.wolfsonmicro.com>
 <AANLkTim6bQGKCuzAgxNS93LQkq2iqxjcCW49NBArafK1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim6bQGKCuzAgxNS93LQkq2iqxjcCW49NBArafK1@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 01:08:03AM -0500, Mike Frysinger wrote:
> On Mon, Mar 7, 2011 at 10:55, Mark Brown wrote:

> > At a bare minimum suddenly stopping and starting the firmware while
> > audio is going through it is unlikely to work well (you'd most likely
> > get a hard stop of the audio followed by a sudden hard start which sound
> > very unpleasant to listeners) and so should be prevented.  There's a
> > bunch of options for doing this (including refusing to change, ensuring
> > the DSP output is muted during the change or routing around the DSP
> > while doing the change).

> you would probably get the "normal" clicks and pops, but i guess your
> view of "wrong" is much more strict than mine ;).  i'm not sure our
> parts allow routing around the DSP (Cliff would have to comment).  as
> for the rest, i think it'd be best to let the user space app dictate
> how they want to handle things.  perhaps clicks/pops are fine with
> them.  or they arent, and so the userspace app would make sure to
> pause/mute/whatever the stream.  either way, this sounds like a policy
> that shouldnt be hard coded in the codec driver.

Muting the DSP output during firmware reboots seems like an entirely
reasonable way of doing this if there's no ability to route round the
DSP or otherwise deal with the issue, and given how cheap the
mute/unmute is it's hard to see where a user would find that a problem.
Either they'll want to deal with the issue or they won't care.

Bear in mind that people are trying to do things like run off the shelf
PulseAudio as their system audio manager in embedded systems - the
kernel should make some effort to behave sanely.

> > The standard tools should also be able to manage the mechanics of
> > actually getting the new data into the kernel at appropriate moments.
> > This includes both offering control via UIs such as alsamixer and being
> > able to include configuration of the data in UCM configurations.

> exposing this via alsamixer and friends would be a useful debugging
> tool so people can toy around with known working configurations.  and
> have code examples to see how to do it.

The ALSA APIs are also the userspace interface to the audio subsystem,
any userspace application interacting with the audio hardware is
expected to use them.

> > I'm not sure you're following what's being said here.  The above control
> > discussed above full system configuration of all the control offered by
> > the system, not tuning the parameters of an individual algorithm.  This
> > includes volume controls, routing controls, algorithms, coefficients and
> > anything else that can be changed.  A scenario where you want to change
> > the set of algorithms the hardware can support is certainly included in
> > that.

> i just meant that the use cases we've been dealing with involve the
> people developing the application taking care of picking which
> firmwares to load at any particular time.  having the end user (the
> guy who buys the actual device) select firmwares doesnt make much
> sense.  but this particular qualification probably is irrelevant to
> the framework you're proposing in the end.

In a modern Linux system the user will rarely see an application that
exposes ALSA directly unless they go looking (in an embedded system they
may not be able to go looking due to the limits of the UI), they'll see
a higher level abstraction.  In the desktop case the primary interface
the user has is with GUIs that control PulseAudio which abstract away
the actual control offered by the drivers.  Embedded systems tend to
either use Pulse or brew their own equivalent.
