Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2FTCuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:50:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2FTCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:50:05 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=5We8Bx_S-JgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=oyjjO0udLHZJvkyML20A:9 a=QEXdDO2ut3YA:10 a=De6hUGR2fjBMNWfu:21 a=NcPfGWGCNehaXONi:21 a=bJrkcFJteExMI8PXcVUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120620020608.911616775@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Jun 2012 22:06:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: John David Yost <johnyost@ptd.net>
Subject: [PATCH 0/4] localmodconfig: Improve the number of modules removed
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

make localmodconfig was used to make a minimal config but still make
sure that everything you enabled stays enabled. Thus, it took a
conservative approach when it came to disabling configs. If there was a
chance that disabling a config would cause a required module not to be
built, it would keep that config set.

There was a time it was discovered that a config without a prompt
may be required to build a module, but it was only set if another
config option was set, because that config option would select it.
If the second config option was a tristate, but did not directly
enable a module, localmodconfig would deselect it and cause the required
module to be built.

The simple and conservative way to handle this was to also enable all
configs that select a required module config. But this caused those
configs to include the configs that they depend on, as well as all
the configs that select it. This increased the number of modules being
kept much higher than what the minimal set that was needed.

One issue was that it would even include configs that were core and not
even a module.

Another issue is that there was no reason to enable all configs when just
one select would do.

The second and third patches fix this (the other two are clean ups
and added debugging facility). The first of the fix reads the original
.config file and only processes configs that are modules, and ignores
configs that are set as core (localmodconfig will not touch them anyway).

The second of the fixes was a bit of code change that would process
the direct modules first (one to one relationship with configs to their
modules in the Makefiles). Then it will include all the configs that
those modules depend on. After that set is complete, it kept track
of the configs without prompts (needing to enable the selects), it
would look at those configs requiring selects, check to see if one
of their selects is already selected by a set config (do nothing in
that case), and if not, then pick only one config that selects it and
set that.

With these changes, the number of modules my test case had went from
leaving 356 CONFIG_*=3Dm set, to just 67 of them set.

A much smaller and quicker build.

Thanks to John David Yost (AlleyTrotter) for testing his config and
build as well.

If you want this code, I've already sent it to my for-next branch.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig.git
for-next

Head SHA1: 4503379cb811809470ebefb58c943fe605bc3e29


Steven Rostedt (4):
      localmodconfig: Comments and cleanup for streamline_config.pl
      localmodconfig: Read in orig config file to avoid extra processing
      localmodconfig: Check if configs are already set for selects
      localmodconfig: Add debug environment variable LOCALMODCONFIG_DEBUG

----
 scripts/kconfig/streamline_config.pl |  175 ++++++++++++++++++++++++++++++=
----
 1 file changed, 158 insertions(+), 17 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4TpZAAoJEIy3vGnGbaoAVYYP/jONEU/2ffXun7Gbj5tuGOcf
Y+2iPBnVPRZucWTNVLukdxcvfKekCrNL9f3EyWM0nReJCNwlq3rzKuESKUq6qYns
V1iwFoC0yhmtdbyJyly1DyK2jhc0pEhamHPEs81A3jaH8v9C5aIfHtbZjKw5sD4l
O8tzMswDt045QEr16L0oPpqDlAk8SSHAaakJnW1RCTz5ac8LJQNT6vrxlElMdMkT
onUdvObo2q1ea+KyWqy/Jx6UqBwu5cEgMgTvFlRPcNy/kNDrq9b1FGc8X7GahczN
hi5VietWF1OvikC3Ek9MqOuLtW6WbHwjpw2LJIFm9eMcqNOiB1VnPXAzG+5AnIqf
75KMWJkZ/JneRHfMVPa8jCF6/FBToAWgXM54Zg0PfUgPs+dn1vhYgWCD/oTuDPTi
UNS+e1r690K8Vn3YgnRv09xxIp3QZOPEYoF6T6C6BvaExfct0qqraOaf/g10bXIP
mVirYZm31XgXynXHR6S9EoKTJv/IAQjnZQBlnKmXKiq/QhaFL5Nn6EpV6Fb6fHo7
UZdR0Mkeh4WEHdZNtSHM9M/xmeusrtOkMtxq8hWFLOobdSHYLhVADX+iK8lOGHLD
pAOYtoZwS/jpPA+dSKOEqwHO9+X2J2CSccqpVO33Tv9JOYt8UprF8wgwKHOZ0MhN
fUoIBJfEJl96zoES5amb
=90Tp
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
