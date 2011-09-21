Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1IUEqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:46:04 -0400
Received: from home.keithp.com ([63.227.221.253]:43180 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1IUEqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:46:03 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 6/9] drm/i915: Make sure eDP power is on before using aux channel
In-Reply-To: <20110921092001.0b65bd3f@jbarnes-x220>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com> <1316470923-27832-7-git-send-email-keithp@keithp.com> <20110921092001.0b65bd3f@jbarnes-x220>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 20 Sep 2011 21:45:54 -0700
Message-ID: <yunvcsmfqpp.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Sep 2011 09:20:01 +0530, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:

> This one mixes up lots of cleanups plus the EDID read with the power
> changes.

I think the cleanups are;

 1) edp checks inside vdd_on and vdd_off to make the other code a bit
    easier to read.

 2) Hold VDD on until the end of dp_commit. I think this isn't necessary
    and could be removed -- once the panel is on, we don't need to hold
    vdd up.

 3) Hold VDD up through the whole dpms sequence. Also probably
    unnecessary.

 4) Move intel_dp_i2c_init past the computation of the power sequencing
    delays. Necessary as i2c_init makes an i2c transaction, thus
    powering up the panel.

I can remove the middle two and split the others out if you like.

> I'm worried about the VDD smashing as well; we have lots of
> bugs in the PPS hardware around VDD vs full PPS.

Are you worried that we should never have VDD up while running a panel
power sequence? As far as I can tell from the eDP specs, bringing VDD up
is part of the normal PPS, and the delay from VDD up to other panel
sequencing is shorter (T1+T2) than the delay to start using the aux channel
that I used in the later patch (T1+T2+T3).

One thing I learned for certain -- we don't want a synchronous delay
between turning the panel off and back on. The required interval between
these two operations is in units of 100ms; my machine spends 600ms doing
this; if we end up doing this in the middle of a mode set, it's gonna be
painful.

Can we replace any of the current VDD hacks with a full PPS? I can
easily imagine moving the call to ironlake_edp_panel_on to
intel_dp_prepare, except that if if the mode_set fails, dp_commit will
not be called (that looks like a potential source of failure at the DRM
level to me).

Getting the panel turned on complete as early as possible seems like a
good idea, instead of fussing around with the VDD force bits.

Alternatively, we can eliminate use of the VDD force hack and do a full
PPS and simply use the delayed work proc to turn that off when the
screen goes idle.

> We need to make sure appropriate delays are in place when
> transitioning from one to another.

As you can see, I stuck 1000ms delays in the vdd_on and vdd_off
functions to ensure that there was 'sufficient' delay in these cases. I
didn't touch the existing delays for regular panel_on/panel_off. I think
that the later patch, which computes 'correct' delays and applies those
uniformly should ensure that we're always waiting long enough.

The later patches track the jiffies value when the panel was turned off
and then wait the appropriate amount of time before turning it back
on.

> In what paths are we trying to do accesses without power applied?
> Looks like mainly edid?

(the previously broken cases are marked with '*')

* intel_dp_i2c_init

        This probes the i2c bus to see if there's someone home. Failing
        to have VDD up at this point causes a timeout, but no other
        obvious problem.

        As you can see, I moved the call to this function after the
        computation of the power sequencing delay values.

* intel_dp_prepare

        This wakes up the eDP panel out of a low power DPMS state. I
        think I'd actually like to leave VDD high starting at this point
        and ending after the panel is running.

intel_dp_commit

        Calls intel_dp_start_link_train. before ironlake_edp_panel_on.
        I think the call to ironlake_edp_panel_vdd_off could move back
        where it was, right after ironlake_edp_panel_on.

intel_dp_dpms

*       In the DPMS_ON case, this calls intel_dp_sink_dpms and
        intel_dp_start_link_train before calling
        ironlake_edp_panel_on. I wonder if we shouldn't just turn the
        panel on instead?

        In the DPMS_OFF case, I don't think we need to mess with vdd at
        all; the panel is definitely running until
        ironlake_edp_panel_off is called, at which point we're done
        using the aux channel.

* intel_dp_get_edid,
* intel_dp_get_edid_modes

        These are called while the display is off (sometimes).

> I see the next patch handles the timing stuff, I assume it's ok.

I hope so; the actual timing values required by the eDP spec aren't
available, so I fudged by choosing ones that were at least as long.

Thanks for taking a look at the code.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOeWwCQp8BWwlsTdMRAtVBAKDF20xOvv8LQ+87gEIWJHPpN6h8OwCgtmfI
FKXRi2tKAa25YBsYsX4IFMw=
=DaCh
-----END PGP SIGNATURE-----
--=-=-=--
