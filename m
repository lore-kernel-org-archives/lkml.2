Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2EAFBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:01:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47264 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2EAFBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:01:20 -0400
Date: Tue, 1 May 2012 15:01:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: linux-next: manual merge of the driver-core tree with Linus' tree
Message-Id: <20120501150109.753d67c17e5beead1600c7ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_May_2012_15_01_09_+1000_rLONWEXJF_+mQMWZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_May_2012_15_01_09_+1000_rLONWEXJF_+mQMWZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
init/main.c between commit a99cd1125189 ("init: fix bug where environment
vars can't be passed via boot args") from Linus' tree and commit
9fb48c744ba6 ("params: add 3rd arg to option handler callback signature")
from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc init/main.c
index 44b2433,11bc6f7..0000000
--- a/init/main.c
+++ b/init/main.c
@@@ -225,9 -225,14 +225,10 @@@ static int __init loglevel(char *str
 =20
  early_param("loglevel", loglevel);
 =20
 -/*
 - * Unknown boot options get handed to init, unless they look like
 - * unused parameters (modprobe will find them in /proc/cmdline).
 - */
 -static int __init unknown_bootoption(char *param, char *val,
 +/* Change NUL term back to "=3D", to make "param" the whole string. */
- static int __init repair_env_string(char *param, char *val)
++static int __init repair_env_string(char *param, char *val,
+ 				const char *unused)
  {
 -	/* Change NUL term back to "=3D", to make "param" the whole string. */
  	if (val) {
  		/* param=3Dval or param=3D"val"? */
  		if (val =3D=3D param+strlen(param)+1)
@@@ -239,16 -244,6 +240,17 @@@
  		} else
  			BUG();
  	}
 +	return 0;
 +}
 +
 +/*
 + * Unknown boot options get handed to init, unless they look like
 + * unused parameters (modprobe will find them in /proc/cmdline).
 + */
- static int __init unknown_bootoption(char *param, char *val)
++static int __init unknown_bootoption(char *param, char *val,
++				const char *unused)
 +{
- 	repair_env_string(param, val);
++	repair_env_string(param, val, unused);
 =20
  	/* Handle obsolete-style parameters */
  	if (obsolete_checksetup(param))
@@@ -728,16 -723,22 +730,16 @@@ static initcall_t *initcall_levels[] __
  };
 =20
  static char *initcall_level_names[] __initdata =3D {
- 	"early parameters",
- 	"core parameters",
- 	"postcore parameters",
- 	"arch parameters",
- 	"subsys parameters",
- 	"fs parameters",
- 	"device parameters",
- 	"late parameters",
+ 	"early",
+ 	"core",
+ 	"postcore",
+ 	"arch",
+ 	"subsys",
+ 	"fs",
+ 	"device",
+ 	"late",
  };
 =20
 -static int __init ignore_unknown_bootoption(char *param, char *val,
 -					const char *doing)
 -{
 -	return 0;
 -}
 -
  static void __init do_initcall_level(int level)
  {
  	extern const struct kernel_param __start___param[], __stop___param[];
@@@ -748,7 -749,7 +750,7 @@@
  		   static_command_line, __start___param,
  		   __stop___param - __start___param,
  		   level, level,
- 		   repair_env_string);
 -		   &ignore_unknown_bootoption);
++		   &repair_env_string);
 =20
  	for (fn =3D initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
  		do_one_initcall(*fn);

--Signature=_Tue__1_May_2012_15_01_09_+1000_rLONWEXJF_+mQMWZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPn24VAAoJEECxmPOUX5FE+0MP/1bNsDIen20qqFNDV/DFXuU/
t8VFAQqqJawdGAQdOfgn6D3q8bxdN7sLE+/l73Spm5DBrTvErtKiL23OQNriUUg1
/EaeEY6Zw33NyR6ZKC+15K9p+b/mwRNCr0s+4l7PTiT8/2ehxeEbZIYPVLbpOk63
SYeDlfT2fccv5LR/+zudEWUTMI7nGfr9uxQHPeT1G2+cojoDAa+0eo+KzRphpdas
cPWof5A8iBsz+BvfRvfJP4OsTCbsutMeorXGOtrncDEeri2/a9VRJm3UQtttaGsh
K5oVXSaAA3M3BrdJUdHd/VCuhQmkjCRjR7W9fan9X0csVynlpKa6SZCqQ3OqQgEF
W5h2mkj6TTVVGE9krF4rDFTAE4x07WV4ORY2reYmRuzGsLg+rudCeUevyG2VugSP
P7YsxRatz5pKm8AwKLFCB3NMywNE217ka+Mt858jLqBsBn88mVpJR6XTX9BRg4oV
nNRjOKs9dFjQ79VIWycXuDJh1ow1SA8lRRo+Q12vehQWdsgMsyhV5tsouJ58Iucj
zWdvyI/3EEbY72G7xYq65V0lnO9iGtNu6KoAFOiVyFNEtbD9BeOg1AibxytGoH22
Hkl8m70olENLdrAwWJAoEselVXhaAqOfOjtRV2lK/IpnOQyjojwMXxi3tc3rddbQ
xfMnLfSHL8VStL9zyOv/
=pM6K
-----END PGP SIGNATURE-----

--Signature=_Tue__1_May_2012_15_01_09_+1000_rLONWEXJF_+mQMWZ--
