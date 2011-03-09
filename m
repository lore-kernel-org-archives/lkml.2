Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1CIGI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:08:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59321 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1CIGIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:08:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=trY0wU0Airc7M+bAWzKGuRnoLeAMuGOd8wgAe3MReEtpZM3u963igblS42a76rZe3V
         ieQ5Bl3Jk0NF/ksZcRWrsBGNnmIc/Ld6ZZIkmMSo0LBNuiEpPMg/VvuiktJm+FllbV7c
         cUQ65WSi91VecTsmyGefDz/mRQPf0rR6AhEpI=
MIME-Version: 1.0
In-Reply-To: <20110307155508.GM13471@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com> <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com> <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <20110307145931.GK13471@opensource.wolfsonmicro.com> <AANLkTi=e1xDz6fhBU7NL32DXL1J9Y1CDD2bHQVL6oASw@mail.gmail.com>
 <20110307155508.GM13471@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 9 Mar 2011 01:08:03 -0500
Message-ID: <AANLkTim6bQGKCuzAgxNS93LQkq2iqxjcCW49NBArafK1@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cliff.cai@analog.com, device-drivers-devel@blackfin.uclinux.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 10:55, Mark Brown wrote:
> On Mon, Mar 07, 2011 at 10:33:25AM -0500, Mike Frysinger wrote:
>> On Mon, Mar 7, 2011 at 09:59, Mark Brown wrote:
>> > I'd expect that the driver would at least error out if the user tried to
>> > do the wrong thing here, like I say currently the firmware code is just
>> > not joined up with anything else at all.
>
>> i dont see how the driver can detect a "wrong" thing.  the driver has
>> no idea what arbitrary code the user is going to load and what that
>> code is going to do, or validate the code in any way.  this is why the
>> firmware has a small crc header on it -- we only make sure that what
>> the user compiled at build time matches what is loaded into the
>> hardware.
>
> At a bare minimum suddenly stopping and starting the firmware while
> audio is going through it is unlikely to work well (you'd most likely
> get a hard stop of the audio followed by a sudden hard start which sound
> very unpleasant to listeners) and so should be prevented.  There's a
> bunch of options for doing this (including refusing to change, ensuring
> the DSP output is muted during the change or routing around the DSP
> while doing the change).

you would probably get the "normal" clicks and pops, but i guess your
view of "wrong" is much more strict than mine ;).  i'm not sure our
parts allow routing around the DSP (Cliff would have to comment).  as
for the rest, i think it'd be best to let the user space app dictate
how they want to handle things.  perhaps clicks/pops are fine with
them.  or they arent, and so the userspace app would make sure to
pause/mute/whatever the stream.  either way, this sounds like a policy
that shouldnt be hard coded in the codec driver.

>> > systems) there's no reason they shouldn't be able to rely on standard
>> > tools for managing their audio configurations.
>
>> if the standard tools existed today, i'd of course agree.  but as you
>> indicated there's nothing right now for us to bug off of.  so how
>> userspace "probes" for existing data would be however the end user
>> chooses to manage things.  it's not like the standard tools could
>> really provide anything other than a simple string that indicates
>> "some blob exists with name xxx".  the meaning/metadata that surrounds
>> xxx isnt really relevant from the kernel's pov.
>
> The standard tools should also be able to manage the mechanics of
> actually getting the new data into the kernel at appropriate moments.
> This includes both offering control via UIs such as alsamixer and being
> able to include configuration of the data in UCM configurations.

exposing this via alsamixer and friends would be a useful debugging
tool so people can toy around with known working configurations.  and
have code examples to see how to do it.

>> > At present userspace can enumerate and change the runtime configuration
>> > the system offers via the ALSA APIs (and this will get even better once
>> > the media controller API starts being used).  This means that you can
>> > fairly easily write a userspace that'll run on pretty much any Linux
>> > audio hardware, adapting with pure configuration for which you can
>> > provide point and click tuning (realistically by allowing the user to
>> > configure via standard ALSA tools and offering a "save as use case" type
>> > interface).  If we start adding backdoors to drivers we're taking a step
>> > back from where we are currently by requiring that the application layer
>> > know magic stuff about individual systems in order to work with them.
>
>> from how we've seen people using these codecs, this scenario doesnt
>> make much sense.  the different algorithms would be loaded on the fly
>> by the application and its current operating needs, not a single
>> algorithm selected by the ender user that wouldnt change for the life
>> of the app.  not saying the scenario would never come up, just that it
>> isnt the one we'd be focused on.
>
> I'm not sure you're following what's being said here.  The above control
> discussed above full system configuration of all the control offered by
> the system, not tuning the parameters of an individual algorithm.  This
> includes volume controls, routing controls, algorithms, coefficients and
> anything else that can be changed.  A scenario where you want to change
> the set of algorithms the hardware can support is certainly included in
> that.

i just meant that the use cases we've been dealing with involve the
people developing the application taking care of picking which
firmwares to load at any particular time.  having the end user (the
guy who buys the actual device) select firmwares doesnt make much
sense.  but this particular qualification probably is irrelevant to
the framework you're proposing in the end.
-mike
