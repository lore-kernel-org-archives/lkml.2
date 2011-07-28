Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1G1WuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:50:10 -0400
Received: from home.keithp.com ([63.227.221.253]:60621 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab1G1WuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:50:05 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug processing
In-Reply-To: <20110727090331.60e0c5be@jbarnes-desktop>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com> <CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com> <yunsjpt2hi6.fsf@aiko.keithp.com> <20110726121225.3ae7acce@jbarnes-desktop> <yunk4b43wq3.fsf@aiko.keithp.com> <20110727090331.60e0c5be@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 28 Jul 2011 15:50:00 -0700
Message-ID: <yun39hqc95z.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jul 2011 09:03:31 -0700, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:
> On Wed, 27 Jul 2011 02:21:24 -0700
> Keith Packard <keithp@keithp.com> wrote:
>=20
> > On Tue, 26 Jul 2011 12:12:25 -0700, Jesse Barnes <jbarnes@virtuousgeek.=
org> wrote:
> >=20
> > > I'd like to amend my reviewed by and say the lock shouldn't be held
> > > around the call to the drm helper function.  It queues some work that
> > > also takes the mode config lock, which will break.  So you can drop it
> > > before that...  Previously I had only checked our internal driver
> > > callbacks but missed that the lock was held across the helper too.
> >=20
> > So the work may get executed immediately rather than being run later at
> > some point?
>=20
> It sure looks that way... but I don't remember any rule about work
> queue items having inter dependencies like this.

Sounds fine; I've stuck a fixup that moves the mutex_unlock:

 		if (encoder->hot_plug)
 			encoder->hot_plug(encoder);
=20
+	mutex_unlock(&mode_config->mutex);
+
 	/* Just fire off a uevent and let userspace tell us what to do */
 	drm_helper_hpd_irq_event(dev);
=2D
=2D	mutex_unlock(&mode_config->mutex);
 }

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOMeeYQp8BWwlsTdMRArD3AJ9VProGSHXs+9r3a4B1Rzz0z/UuYQCfXfnI
gIdX3ZuxMYw0uy+uRg5NoNg=
=SL4g
-----END PGP SIGNATURE-----
--=-=-=--
