Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1JADb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 23:31:26 -0400
Received: from home.keithp.com ([63.227.221.253]:57876 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1JADbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 23:31:21 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay computations
In-Reply-To: <20110930181644.GR2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-15-git-send-email-keithp@keithp.com> <20110930181644.GR2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 20:31:13 -0700
Message-ID: <yunoby15qwu.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 20:16:44 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Awesome patch description and the code agrees with what I've cross-checked
> on bspec. The only fear I have is that we currently ignore the backlight
> on/off timings and some panel probably relies on use waiting for backlight
> on/off + panel on/off in total. But that's material for another patch.

Ok, I've just read through the VBIOS source code to figure out how it
converts the edp_power_seq table into the panel delay register settings.

intel_bios.h says:

        struct edp_power_seq {
        	u16 t3;
        	u16 t7;
        	u16 t9;
        	u16 t10;
        	u16 t12;
        } __attribute__ ((packed));

The VBIOS source code says that these five words are:
                            Data        Code=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20
        DW      xxxx        T1+T2       T1_T2   (Power Up Delay)
        DW      yyyy        T3          T5      (Power-On to backlight On)
        DW      zzzz        T4          T6      (Backlight off to power off)
        DW      wwww        T5          T3      (power down delay)
        DW      tttt        T7          T4      (power cycle delay)

('Data' is how the initialized data is labeled, 'Code' is how the
struct is defined and used. Yes, they appear to be different).

And, reading the code that programs the eDP registers

        PP_ON_DELAYS =3D (T1_T2 << 16) | T5
        PP_OFF_DELAYS =3D (T3 << 16) | T6
        PP_DIVISOR =3D T4 / 1000 + 1

The BSPEC/BIOS names don't agree with the eDP spec. Here's my plan:

Data    Code            eDP spec        intel_dp name           What I'm us=
ing this for:

T1+T2   T1_T2           T1+T3           panel_power_up_delay    VCC on to A=
UX channel
T3      T5              T6+T8           backlight_on_delay      Link traini=
ng to backlight on
T4      T6              T9              backlight_off_delay     Backlight o=
ff to video off
T5      T3              T10             panel_power_down_delay  Video off t=
o VCC off
T7      T4              T11+T12         panel_power_cycle_delay VCC off to =
VCC on

It's trivial to pull the values back out of the PP registers, so I'll do
that and use the maximum of the two instead of preferring one or the
other. Waiting too long shouldn't ever hurt.

As far as the edp_power_seq register goes, I'd love to know where those
names came from. They don't quite match my interpretation, in
particular, the 't7' is almost certainly not the eDP T7 value, which is
the delay from valid video data on the link to a correct display,
which isn't a useful value as it doesn't impact the source at all.

Ok, so a bit more whacking of code and I'll post an updated patch that
uses all of these values as above.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhomBQp8BWwlsTdMRAnDVAJ449T/luyScdzQZgRdl5QWcjJJNpwCfYByx
2gV39y/PZuG36ECUWzDMpyA=
=sDX5
-----END PGP SIGNATURE-----
--=-=-=--
