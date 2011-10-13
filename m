Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1JMQki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:40:38 -0400
Received: from home.keithp.com ([63.227.221.253]:58748 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab1JMQkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:40:37 -0400
From: Keith Packard <keithp@keithp.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915/panel: Alwyas record the backlight level again (but cleverly)
In-Reply-To: <s5h7h492rr4.wl%tiwai@suse.de>
References: <s5h7h492rr4.wl%tiwai@suse.de>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 13 Oct 2011 09:40:29 -0700
Message-ID: <yunsjmw26bm.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 10:57:35 +0200, Takashi Iwai <tiwai@suse.de> wrote:

> This patch fixes the bug by recording the backlight level always
> when changed but only when dev_priv->backlight_enabled is set.
> In this way, the bogus value for disabling backlight can be skipped.

I think this is better than what we have, but I'm not sure it's quite
what we want -- the backlight level will only be remembered when it is
enabled, so requested changes that happen while the backlight is off
will have no effect. And, requested changes while the panel is disabled
will still go through to the hardware, which can cause problems with
panel power sequencing.

I think intel_panel_set_backlight should always record the level passed
in, but that intel_panel_disable_backlight and
intel_panel_enable_backlight should use a lower-level function, shared
with intel_panel_set_backlight that doesn't record the value:

intel_panel_actually_set_backlight(dev, level) {
        <internals of current intel_panel_set_backlight>
}

intel_panel_set_backlight(dev, level) {
        dev_priv->backlight_level =3D level;
        if (dev_priv->backlight_enabled)
                intel_panel_actually_set_backlight(dev, level);
}

intel_panel_enable_backlight(dev) {
        dev_priv->backlight_enabled =3D true;
        intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
}

intel_panel_disable_backlight(dev) {
        dev_priv->backlight_enabled =3D false;
        intel_panel_actually_set_backlight(dev, 0);
}

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTpcUfTYtFsjWk68qAQhr+hAAz/TtEDUQTpOQrugOhM8nT5rRolRZ3FzW
7dXTBcJv3zRkY7LF+HvpVe3hEkKaeqp48ZRSEEu99ISopIaHObDsUA6jxx895nJY
khzrnG6E8ut2UmDxcyIN2HgrB3Bgxpo8getkW1/aVQkBSOEU4mEQIOcMcyVxQlbg
ctYvym6e9zmKk1rsLYjWav+HpoE7NvpFR4JrHrcXwv3k6QM3X2T6UHohKx78D2V3
LJLvw8hFxwmhJ8PW8d4TrlT1ic14I33Gct92CKUm4ARcNLK8gvKVxQhormLOSqsb
LJRMdsciOeOCnIlj87FjlKvjqgvkOEfrHXuhpjUHy1XUf47CkvfTCZ+yiVehrO2g
ksYH+gUL2KeYxpPuinjEW0jbq8yLK0UM0x2GAzaYGGFhKMc+96Afwu2HLllt7q4k
XkTw59wz5sFiScM934YBNNlVJjDqNGMiBuM7or+t6W4g54/hoFWJkG0PvlroVVrg
zFWx05ipksVFnX4yzkQB7xLl22CAVjD6WMMgTOe0cXgqzkSLliDpUzpE0KgnPhJ0
neLRYsWwVFRrmdkrOd1W/vqIzvhPycQEJZBJ+dEw8mY+rJHGay1D6ITgZnUk8mzV
GGeHCO/z8sK8n1k/FAQIMuOtL8ijkCtiR5Qwq5TJ0l+kz3c/QrEYC55WT6SXrJNX
p6Ml5ln5VMg=
=UMwf
-----END PGP SIGNATURE-----
--=-=-=--
