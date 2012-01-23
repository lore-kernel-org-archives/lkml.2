Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2AWEAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 23:00:43 -0500
Received: from home.keithp.com ([63.227.221.253]:53187 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2AWEAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 23:00:40 -0500
From: Keith Packard <keithp@keithp.com>
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
In-Reply-To: <20120122102912.GA2123@nbgentoo>
References: <jfe47e$5dn$1@dough.gmane.org> <86mx9gkjlv.fsf@sumi.keithp.com> <20120121184453.GA2698@nbgentoo> <86hazokcb7.fsf@sumi.keithp.com> <20120122102912.GA2123@nbgentoo>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 22 Jan 2012 20:00:18 -0800
Message-ID: <867h0j83vx.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jan 2012 11:29:12 +0100, Lubos Kolouch <lubos.kolouch@gmail.com>=
 wrote:

> Thanks, here you go:
> dmesg after boot - http://paste.pocoo.org/show/538625/
> dmesg after failed resume - http://paste.pocoo.org/show/538626/

Ok, looks like my theory is correct. We're fitting a 24bpp mode to an
18bpp data rate, which doesn't work.

I'm in the middle of bisecting a bluetooth failure in 3.3-rc1, so I
don't have a working kernel at present, but here's a section of
intel_dp.c in the intel_dp_mode_fixup function:

  	int max_clock =3D intel_dp_max_link_bw(intel_dp) =3D=3D DP_LINK_BW_2_7 ?=
 1 : 0;
=2D	int bpp =3D mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 0;
+	int bpp =3D mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 24;
 	static int bws[2] =3D { DP_LINK_BW_1_62, DP_LINK_BW_2_7 };

(this is completely hand-generated, so 'patch' will almost certainly not wo=
rk)

This will force it to use the correct bpp when computing the bandwidth
used by the new mode. This should fix your problem. If so, I'll have a
larger patch which stops the underlying function from (almost always
incorrectly) using the current bpp when computing bandwidth.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxzbUjYtFsjWk68qAQizOA//UhwueA5sufzhBHkAn+yGRHgCMXG+hOl5
1K41+/6CIBuvSaDdi4Xzo0HJVwOMpVyuPQWKE3Ir9QwMPcole2PNLSFsQ4+AdN2n
8AzsZM6UGdoe7KZozxnE3CQ0pY+ZCB2VCzfsvB5jQIBajR/TbMQaIL12cDiJRB2+
JO+6iYfmXfGdcFWwzqza+UgmZjttA/zsq4qATBy8PIj5eC5S2GMdMvwW+eBVsGoZ
GshKr1Oa9n1vbCSCose/yKGDrQmCk1T7dwJyrVVhpgAStYdspJYFv2F0U+PwHFCk
JT6d9KRf02Uvb8NwaeiDn3f+X7y8WSEmj6IwK72bphPn/IlaGTNedUUWvZw3mUB5
Jkg0JOC0/oIGxA9SxkMWFntRQEbCbz8INY78BXH0ZZTqjzmWyo+OJVPTzPEVLgK3
3MFUytCABQPvRDBZ5YCOwoiO2UecijaAbd2uVK7eoNBiA5yMOS4E9/5JNsWbDScY
9EV+NHP24M5RySExvLZrcG1qi3C2uLdmG/tt7tgoBvt8F0ja91cmweDTSMB4sJIt
J4hCZ5RAtANS2XKf8tzHwHfr/SjWWAghXvtN/Ho4+Gbj3PB2ZShtfyl6DcyeSxVV
DFir2a1kwnKqnJ6a305HYhBWVn/3aDMveRbOYvRptS0lMiCcOO51VUTZA9ljPV5O
wtdrsLnGc3w=
=M8Te
-----END PGP SIGNATURE-----
--=-=-=--
