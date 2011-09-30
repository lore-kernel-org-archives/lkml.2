Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1I3U4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:56:15 -0400
Received: from home.keithp.com ([63.227.221.253]:52396 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab1I3U4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:56:14 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 18/21] drm/i915: Disable eDP VDD in a delayed work proc instead of synchronously
In-Reply-To: <20110930184700.GV2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-19-git-send-email-keithp@keithp.com> <20110930184700.GV2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 13:56:09 -0700
Message-ID: <yun4nzt7nrq.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 20:47:00 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> A cancel_work might be good here, not point in waking up the cpu for no
> reason. And can you add "panel off timer: " to the deboug output?

No, that's not correct, this is run before turning the panel back on and
must check that enough time has elapsed since it was turned off, which
may have happened in the work proc.

However, you are right in saying that I could call the cancel work
function when the panel is forced off synchronously. I'll add that.

> Like Chris already mentioned, s/struct_mutex/mode_config.mutex/ Maybe also
> move the intel_dp->want_panel_vdd check in here - we need it only here to
> avoid a race with vdd_on. I've almost overlooked it and already started to
> write the complaint about the race ;-)

With the right mutex held, there won't be a race, we just need to check the
value somewhere. Do you still see a race condition that needs to be avoided?

> > @@ -1111,10 +1175,10 @@ intel_dp_dpms(struct drm_encoder *encoder, int =
mode)
> >  			intel_dp_start_link_train(intel_dp);
> >  			if (is_edp(intel_dp))
> >  				ironlake_edp_panel_on(intel_dp);
> > -			ironlake_edp_panel_vdd_off(intel_dp);
> > +			ironlake_edp_panel_vdd_off(intel_dp, true);
> >  			intel_dp_complete_link_train(intel_dp);
> >  		} else
> > -			ironlake_edp_panel_vdd_off(intel_dp);
> > +			ironlake_edp_panel_vdd_off(intel_dp, false);
>=20
> Any reason why one vdd_off is sync while the other isn't?

After the panel is turned on, I want to synchronously turn off the VDD
AUX bits, as that's what the driver did before. That's 'free' because
the panel is on. In the other (failure) path, I don't want to impose a
delay if the application wants to try the mode set again.



=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhizqQp8BWwlsTdMRAuFcAKDDtjsC8s3FwRzjwk/mlkb9RBR50wCgnJQ3
KT79r5C1V6wu2GzMWG6ViZY=
=uFy5
-----END PGP SIGNATURE-----
--=-=-=--
