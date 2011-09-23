Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1IWFHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 01:07:08 -0400
Received: from home.keithp.com ([63.227.221.253]:33270 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1IWFHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 01:07:06 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 6/9] drm/i915: Make sure eDP power is on before using aux channel
In-Reply-To: <20110923082513.735b64fe@jbarnes-x220>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com> <1316470923-27832-7-git-send-email-keithp@keithp.com> <20110921092001.0b65bd3f@jbarnes-x220> <yunvcsmfqpp.fsf@aiko.keithp.com> <20110923082513.735b64fe@jbarnes-x220>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 22 Sep 2011 22:07:00 -0700
Message-ID: <yunaa9v26ff.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Sep 2011 08:25:13 +0530, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:

> Yeah that sounds good.  (2) and (3) are ok cleanups, but it would be
> best if they were a separate patch just in case the subtle timing
> change breaks the panel power sequencing state machine.

Ok, I'll split things up into tiny patches then; easier to review, and
easier to try different combinations.

> No I think:
>   1) VDD AUX override on
>   2) PPS on
>   3) (delay)
>   4) VDD AUX override off
> is safe, I'm just worried about the timing of step (3).

Ok, that seems like a nice plan to me -- just doing the PPS on sequence,
and then setting VDD AUX off after PPS completes. That seems easy, and
avoids leaving VDD AUX once the panel is completely running.

> To fix both PCH eDP and CPU eDP in the past, I did have a version that
> only used full PPS and not VDD AUX override.  So it is possible, but
> VDD AUX is a little cleaner since it allows us to keep the registers
> locked potentially (theoretically we only actually want to unlock to
> handle CPU eDP PLL enable/disable bugs and flicker-free panel fitter
> downscaling).

I really don't care about leaving registers locked; we're not running
DOS anymore. Just doesn't make any sense to me.

> But since we unlock unconditionally now, using full PPS would be ok.

> Though we will have to shut it down still; PPS on to get AUX data and
> EDID, then off while we program the mode and train DP, then PPS on
> again.  So I'm not sure it would save much.

VDD AUX on or PPS has to be done to run the training anyways.

> Yeah, I'm liking your delayed work much better now...  Bring up the
> panel early and then just modify the shutdown timeout at various points
> to make sure it stays up from module_init all the way through the final
> mode set (so an initial timeout of 2s or so would probably be
> sufficient).

The question is whether to do PPS or use VDD AUX on to start
with.

> Another potential optimization is to start trying AUX & i2c
> transactions right after we apply VDD AUX override.  The panel will
> come up much faster than the T* values imply most of the time (varies
> by panel).  And polling the bits can get us into the actual panel
> poking code much faster.

While that's possible, it wasn't true on the MBA; it took almost the
full T3 interval after VDD AUX was on before the EDID came back.

> But I think the bottom line is to fix the EDID read (make sure the
> panel is on) and the i2c stuff.  Everything else is just tasty
> gravy. :)

Right, that is what fixed the MBA for me.

> Also I think the change to prefer EDID over VBT is correct; afaik eDP
> panels are required to have an EDID, so trusting that data over some
> potentially untested VBT data is the right way to go.

Especially when VBT comes from a BIOS emulation mess which just lies.

I'll try to get a new sequence done tomorrow with these
suggestions. Hope your Indian adventures are going well.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOfBP0Qp8BWwlsTdMRAqJ8AJ9CuMSwnGfX9evnDcklJ1JnwCJmfgCffh4Q
5x6qBNjubCmMgmAQQA3Cbb8=
=BVx/
-----END PGP SIGNATURE-----
--=-=-=--
