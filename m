Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1KCWbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:31:16 -0400
Received: from home.keithp.com ([63.227.221.253]:33818 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab1KCWbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:31:15 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 5/7] drm/i915: Make DP prepare/commit consistent with DP dpms
In-Reply-To: <20111103130011.7946090a@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-6-git-send-email-keithp@keithp.com> <20111103130011.7946090a@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 03 Nov 2011 15:30:57 -0700
Message-ID: <yunipn0rg7y.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 13:00:11 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> A few comments on this one (also, is it strictly required to fix your
> bug)?

I think so; the panel definitely was not happy when I turned the link
off while the panel power was on. Having the mode setting and DPMS paths
doing things in different orders definitely doesn't seem reasonable
though. I nearly managed to share code between the two paths, but there
are subtle differences in requirements and so I didn't bother.

> Ok so you're making sure the panel has power to down the link, I think
> that's fine.

No, I'm turning the panel off *before* turning off the link.  The panel
goes nuts if you down the link before turning its power off; lots of
technicolor.

Downing the link doesn't require any communication with the panel, so
there's no issue with losing connectivity at this point:

	ironlake_edp_backlight_off(intel_dp);
	ironlake_edp_panel_off(intel_dp);               <=3D panel off

	/* Wake up the sink first */
	ironlake_edp_panel_vdd_on(intel_dp);
	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
	intel_dp_link_down(intel_dp);                   <=3D link down
	ironlake_edp_panel_vdd_off(intel_dp, false);

> But here it looks like you're shutting it off, then downing the link?
> Should this be reordered?

Nope, it's in the same order:

	ironlake_edp_backlight_off(intel_dp);
	ironlake_edp_panel_off(intel_dp);               <=3D panel off

	ironlake_edp_panel_vdd_on(intel_dp);
	intel_dp_sink_dpms(intel_dp, mode);
	intel_dp_link_down(intel_dp);                   <=3D link down
	ironlake_edp_panel_vdd_off(intel_dp, false);

The only difference in these two code paths is that dp_prepare turns the
sink to DPMS_ON, while dp_dpms turns the sink to DPMS_OFF.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrMWIjYtFsjWk68qAQhh/Q//T4H0cVzfOqQnxAzhwjEar22vwKGRlX4W
DbzocM7gfd0Qoc7cH630Me+Dnzn2PEdHDoRRFiw2HVGIapQ4P2gOHFHbo8bq9W+y
Acdpg2hwBqOYG28NBfQkypFGtxw0VGtNIjnSlMcT9Q6GCIPfSbHxEmxuG1j+XTrk
WE5in+gSQZzbcblPmkkVl7BJcfVJr1/iZnaMEpr1WjqdlRtHFXV8bVNLIditnI1H
G8ErInTgM/etdqgaoa8oWa83govv6/Hp8S1xrPhuCmxw0ZzV1G6kr5NNx87RZNfo
14VSfSUJXekYMAyh5slY9IQSBdb+xI1jh2HNPJZhKNJ9G8pV5To0/MUTM20OEWFQ
9OBlEeC1ujWAzpaRdKGU+Q69QURYaiNqcf6COloYIiarhMsW3p1OHV2UGkq99GC/
LsMkiRRsEjHzVRHhcYxTspEyBniIKHCD27t1vEhJnWZE88c8YLtjmBCjBVx390Gt
iyDbx/gKFDyozgwTpGaLfeMfnrWA+iXjY3LozOYuYgJEfBFaF/YbKzufeFw+4AQo
2+zjJuncJI3Gz41RVTLMihQpHRQa/WMMZkV3NpV+aAxU/8YyIXvfK5+ucTlp5DCu
iz/JpAv+dDA6lK/PXXw/vH/z02CEVzMPdwdLGX/BvOrK4rV3uYpry6ZgimTldcgI
MqzMQIohrk4=
=ixv5
-----END PGP SIGNATURE-----
--=-=-=--
