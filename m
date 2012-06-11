Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2FKD75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:59:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49468 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2FKD7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:59:55 -0400
Date: Mon, 11 Jun 2012 11:59:21 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philip Rakity <philipspatches@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Philip Rakity <prakity@marvell.com>
Message-ID: <20120611035918.GH4218@opensource.wolfsonmicro.com>
References: <1339270755-2503-1-git-send-email-prakity@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pfTAc8Cvt8L6I27a"
Content-Disposition: inline
In-Reply-To: <1339270755-2503-1-git-send-email-prakity@marvell.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: pass voltage when calling notifier for change
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pfTAc8Cvt8L6I27a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 09, 2012 at 12:39:15PM -0700, Philip Rakity wrote:

> -	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
> +		voltage =3D _regulator_get_voltage(rdev);
> +		if (voltage >=3D 0)
> +			_notifier_call_chain(rdev,
> +					REGULATOR_EVENT_VOLTAGE_CHANGE,
> +					(void *)voltage);
> +	}
> +	trace_regulator_set_voltage_complete(rdev_get_name(rdev), ret);

Hrm, I know we discussed this offline but now that I see the actual code
for the full change here I'm a bit worried about the performance impact
=66rom calling get_voltage() again with devices that don't cache the
register map (it'll be negligable for those that do).  Looking a bit at
the context I think probably what we want to do here is directly call
list_voltage() for the selector we've just set so that the driver
doesn't end up going back to the hardware to read the register value.

Another option is to look at the notifier chain to see if there's any
actual users but that seems more complicated and less abstracted.

We definitely do want to pass the voltage out, now that I see this I
seem to remember that the reason we don't is exactly the performance
concern above but that all predates the use of selectors here which
means we should be able to avoid the I/O costs.

--pfTAc8Cvt8L6I27a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1W0PAAoJEBus8iNuMP3dnuoP/jt4EHxRQg5857ThJdJltyiu
btZKDBT7Tsqo0tCXm/zzpotcIJkEp8adC6J/+E4Sq08nFSvTbLPj2ISTYgc9lpKF
pt/Zq/TUE6CS849n7btJ0c6YUMNu1wkJw5un03/kiwh5XSUNRT1Mj6sANOJYclZ8
28aS9JfxA2fZ4KICOmbei80NcZLjSKkDNkZm7/x2TCH2Lz8UPTQ1HCaamMCNgBny
NijzXJ6V7YANTF9bn5iywryAwXWUrHmAJFeEjQI8fDSIbQr1F9AbZ7UFhK5DwRNs
ByZj/TWrwmOpmCEAQgkcPLtNMiOKeJuur4acpkmsOUqJsSnEbzJVPkOAvuV8mtqu
rzy1oTV+PIZMAlmWRI6yC52CGqYd1vK3kItMRELC5T9lbaCE4jXKrbc+xLyAJ3l8
rM49XhQHW3vwAM/oSz2riGpFFIbCCG0CZe8KuvPUuYQrKl0GmaVNXsVDinOi8fUf
UlAoFTe/aLQbjQCfI1Daj8e1K511z2yrLnvtdIB9SYAKmBphYAIR3nvhqHFCJEV9
GQjijCMz8XTQMSPpUge4OnlrYkd+W6zfJ+0dnQLoIaVy/Ns/hvXeuMUHFUgPwulf
0232udQ1Ts4qJJkM/JdVu55+lQAx3+aK8enFwHNS3D8ajEDbUkVJapNr5AwGW58f
yiW+Kr8eoiWH8wfZtdyA
=X4yC
-----END PGP SIGNATURE-----

--pfTAc8Cvt8L6I27a--
