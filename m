Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1DSAPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:15:12 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:41740 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab1DSAPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:15:10 -0400
Date: Mon, 18 Apr 2011 17:15:05 -0700
From: Andres Salomon <dilinger@queued.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cliff.cai@analog.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        lrg@slimlogic.co.uk, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
Message-ID: <20110418171505.4b1699f3@queued.net>
In-Reply-To: <20110307145931.GK13471@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
	<20110307114142.GB13471@opensource.wolfsonmicro.com>
	<AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
	<20110307121502.GG13471@opensource.wolfsonmicro.com>
	<AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
	<20110307145931.GK13471@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011 14:59:31 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Mar 07, 2011 at 07:29:12AM -0500, Mike Frysinger wrote:
> > On Mon, Mar 7, 2011 at 07:15, Mark Brown wrote:
> 
[...]
> 
> > > Right, and this isn't a particularly unusual requirement
> > > especially if the driver isn't going to have any ability to
> > > interact with the DSP (at which point it's just coefficient data,
> > > the fact that it's a DSP program is uninteresting).  The problem
> > > is that this isn't a great interface for doing that.
> 
> > i dont see suggestions of a better interface anywhere ...
> 
> It currently isn't and I'd encourage you to contribute to the
> discussion that's been going on on this, or even better help out with
> code.  There was some discussion on the list recently (in the past
> month IIRC).
> 
> Whatever we do is going to require some additional APIs in alsa-lib,
> I'd expect.  The key requirements I'm aware of are that we be able to
> support:
> 
>  - Discoverable userspace interface.
>  - Very large data sizes (megabytes have been mentioned).
>  - Adding and removing parameter sets at runtime (for in system
>    callibration).
> 
> Given the number of people looking at this from various angles I'd
> expect to see some sort of progress this year (probably in the next
> quater or so), but obviously no guarantees.

Out of curiosity, has any progress been made on this?

> 
> > wrt pm, that's a trivial programming issue that would be resolved in
> > the driver.  userspace need not care.
> 
> That's the ideal, I mentioned this as several of my other review
> comments concerned issues with power management in the driver -
> addressing those will probably require that the integration occur.
> 
> > wrt stream flows, all the customers we've talked to are fine with
> > this -- having stream control be an application issue.  their
> > application is driving the codec directly and knows when it needs
> > to change the firmware, so it pauses its alsa flow, loads the new
> > firmware, and moves on.

What would actually cause the firmware to change?  Would the userspace
application that's currently driving the codec know that it needs to
load a new firmware, or will there be multiple applications potentially
interacting with the codec (with only one driving it, and another
deciding that the firmware should change)?

One can imagine two different types of APIs depending upon the answers
to those questions.  If the application driving the codec is also
changing the firmware, a simple 'echo new_firmware_name.bin >
/sys/.../filter_coeff' (or equivalent ALSA function)
to cause something in alsa core to stop/pause/mute playback or capture
and restart everything after the firmware has been loaded is all that's
necessary.  That is, userspace triggers the firmware loading.
However, if multiple applications are going to be interacting with
the codec, I'd imagine we'd need something more complex; perhaps a hook
in snd_soc_dai_ops that's called anytime stream state changes?  That
would leave userspace no longer able to explicitly trigger a reload, but
leave the driver smart enough to ensure that when a new firmware is
available, it will be loaded once it is safe to do so (a break in
userspace codec usage).
