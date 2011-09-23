Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1IWCz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 22:55:28 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:48387 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754697Ab1IWCz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 22:55:27 -0400
Date: Fri, 23 Sep 2011 08:25:13 +0530
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 6/9] drm/i915: Make sure eDP power is on
 before using aux channel
Message-ID: <20110923082513.735b64fe@jbarnes-x220>
In-Reply-To: <yunvcsmfqpp.fsf@aiko.keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
	<1316470923-27832-7-git-send-email-keithp@keithp.com>
	<20110921092001.0b65bd3f@jbarnes-x220>
	<yunvcsmfqpp.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 192.55.60.111 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 21:45:54 -0700
Keith Packard <keithp@keithp.com> wrote:

> On Wed, 21 Sep 2011 09:20:01 +0530, Jesse Barnes
> <jbarnes@virtuousgeek.org> wrote:
> 
> > This one mixes up lots of cleanups plus the EDID read with the power
> > changes.
> 
> I think the cleanups are;
> 
>  1) edp checks inside vdd_on and vdd_off to make the other code a bit
>     easier to read.
> 
>  2) Hold VDD on until the end of dp_commit. I think this isn't
> necessary and could be removed -- once the panel is on, we don't need
> to hold vdd up.
> 
>  3) Hold VDD up through the whole dpms sequence. Also probably
>     unnecessary.
> 
>  4) Move intel_dp_i2c_init past the computation of the power
> sequencing delays. Necessary as i2c_init makes an i2c transaction,
> thus powering up the panel.
> 
> I can remove the middle two and split the others out if you like.

Yeah that sounds good.  (2) and (3) are ok cleanups, but it would be
best if they were a separate patch just in case the subtle timing
change breaks the panel power sequencing state machine.

> > I'm worried about the VDD smashing as well; we have lots of
> > bugs in the PPS hardware around VDD vs full PPS.
> 
> Are you worried that we should never have VDD up while running a panel
> power sequence? As far as I can tell from the eDP specs, bringing VDD
> up is part of the normal PPS, and the delay from VDD up to other panel
> sequencing is shorter (T1+T2) than the delay to start using the aux
> channel that I used in the later patch (T1+T2+T3).

No I think:
  1) VDD AUX override on
  2) PPS on
  3) (delay)
  4) VDD AUX override off
is safe, I'm just worried about the timing of step (3).

> One thing I learned for certain -- we don't want a synchronous delay
> between turning the panel off and back on. The required interval
> between these two operations is in units of 100ms; my machine spends
> 600ms doing this; if we end up doing this in the middle of a mode
> set, it's gonna be painful.

Agree, speeding that up would be nice.

> Can we replace any of the current VDD hacks with a full PPS? I can
> easily imagine moving the call to ironlake_edp_panel_on to
> intel_dp_prepare, except that if if the mode_set fails, dp_commit will
> not be called (that looks like a potential source of failure at the
> DRM level to me).

Ah yeah this brings back the memories (or is it PTS?).

To fix both PCH eDP and CPU eDP in the past, I did have a version that
only used full PPS and not VDD AUX override.  So it is possible, but
VDD AUX is a little cleaner since it allows us to keep the registers
locked potentially (theoretically we only actually want to unlock to
handle CPU eDP PLL enable/disable bugs and flicker-free panel fitter
downscaling).

But since we unlock unconditionally now, using full PPS would be ok.

> Getting the panel turned on complete as early as possible seems like a
> good idea, instead of fussing around with the VDD force bits.

Though we will have to shut it down still; PPS on to get AUX data and
EDID, then off while we program the mode and train DP, then PPS on
again.  So I'm not sure it would save much.

> Alternatively, we can eliminate use of the VDD force hack and do a
> full PPS and simply use the delayed work proc to turn that off when
> the screen goes idle.

Yeah, I'm liking your delayed work much better now...  Bring up the
panel early and then just modify the shutdown timeout at various points
to make sure it stays up from module_init all the way through the final
mode set (so an initial timeout of 2s or so would probably be
sufficient).

Another potential optimization is to start trying AUX & i2c
transactions right after we apply VDD AUX override.  The panel will
come up much faster than the T* values imply most of the time (varies
by panel).  And polling the bits can get us into the actual panel
poking code much faster.

But I think the bottom line is to fix the EDID read (make sure the
panel is on) and the i2c stuff.  Everything else is just tasty gravy. :)

Also I think the change to prefer EDID over VBT is correct; afaik eDP
panels are required to have an EDID, so trusting that data over some
potentially untested VBT data is the right way to go.

Thanks,
Jesse

