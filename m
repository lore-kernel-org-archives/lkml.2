Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2CBGMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:12:03 -0500
Received: from mail.southpole.se ([193.12.106.18]:56120 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab2CBGMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:12:00 -0500
Message-ID: <1330668690.19557.91.camel@satguru>
Subject: Re: OpenRISC: Module loader broken
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 02 Mar 2012 07:11:30 +0100
In-Reply-To: <4F501C7A.30307@nod.at>
References: <4F501C7A.30307@nod.at>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rIP2IqCugb6zpSwx6hKp"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 68717-12373
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-rIP2IqCugb6zpSwx6hKp
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Fri, 2012-03-02 at 02:03 +0100, Richard Weinberger wrote:
> Hi!
>=20
> The OpenRISC module loader is broken.

OK, that's new as we've been using module loading quite a bit on this
platform earlier.  Where did you get your toolchain from?

> It explodes somewhere in apply_relocate_add().
> This function is anyway fishy:
>                 case R_OR32_CONST:
>                         location =3D (uint16_t *)location + 1;
>                         *((uint16_t *)location) =3D (uint16_t) (value);
>                         break;
>                 case R_OR32_CONSTH:
>                         location =3D (uint16_t *)location + 1;
>                         *((uint16_t *)location) =3D (uint16_t) (value >> =
16);
>                         break;
>=20
> Why the cast to (uint16_t *)?

This is for loading a 32 bit const, which is done in two steps:

l.movhi rX,hi(const)
l.ori   rX,rX,lo(const)

The immediate value 'const' here is encoded in the low 16 bits of those
instructions.

Since 'location' points at the 32-bit instruction in question, that cast
is supposed to be saying:  'move 16 bit value into low 16 bits of
instruction'.

/Jonas

>=20
> ---cut---
> # insmod ext2.ko
> KERNEL: Unaligned Access 0xbc13b68e
> CPU #: 0
>    PC: c0007864    SR: 0000827f    SP: c172fe28
> GPR00: 00000000 GPR01: c172fe28 GPR02: bc0dd298 GPR03: c0690000
> GPR04: 00000001 GPR05: bc13b68e GPR06: bc1363fc GPR07: bc13b6e4
> GPR08: bc127f6c GPR09: c00528c4 GPR10: c172e000 GPR11: 00000000
> GPR12: 00000000 GPR13: c0a068c0 GPR14: bc0d9138 GPR15: 00000001
> GPR16: 00000000 GPR17: 00000004 GPR18: bc0d9570 GPR19: fffffffc
> GPR20: bc0d8f30 GPR21: 00000003 GPR22: 0000000c GPR23: 0000000b
> GPR24: bc13b6f0 GPR25: 48151139 GPR26: c172fe6c GPR27: fffffff9
> GPR28: c066538c GPR29: c005194c GPR30: 00000004 GPR31: b496906d
>   RES: 00000000 oGPR11: 00000000 syscallno: 00000000
> Process insmod (pid: 126, stackpage=3Dc16aeae0)
>=20
> Stack: Stack dump [0xc172fd1c]:
> sp + 00: 0xc172fe28
> sp + 04: 0xbc0dd298
> sp + 08: 0xc0690000
> sp + 12: 0x00000001
> sp + 16: 0xbc13b68e
> sp + 20: 0xbc1363fc
> sp + 24: 0xbc13b6e4
> sp + 28: 0xbc127f6c
> sp + 32: 0xc00528c4
> sp + 36: 0xc172e000
> sp + 40: 0x00000000
> sp + 44: 0x00000000
> sp + 48: 0xc0a068c0
> sp + 52: 0xbc0d9138
> sp + 56: 0x00000001
> sp + 60: 0x00000000
> sp + 64: 0x00000004
> sp + 68: 0xbc0d9570
> sp + 72: 0xfffffffc
> sp + 76: 0xbc0d8f30
> sp + 80: 0x00000003
> sp + 84: 0x0000000c
> sp + 88: 0x0000000b
> sp + 92: 0xbc13b6f0
> sp + 96: 0x48151139
> sp + 100: 0xc172fe6c
> sp + 104: 0xfffffff9
> sp + 108: 0xc066538c
> sp + 112: 0xc005194c
> sp + 116: 0x00000004
> sp + 120: 0xb496906d
> sp + 124: 0xc0007864
> sp + 128: 0x00000000
> sp + 132: 0x00000000
> sp + 136: 0xc172fdd4
> sp + 140: 0xc00514c4
> sp + 144: 0x00000000
> sp + 148: 0x00000000
> sp + 152: 0x00000000
> sp + 156: 0xbc129290
> sp + 160: 0xbc12929a
> sp + 164: 0xc0051584
> sp + 168: 0xbc139e00
> sp + 172: 0x00000000
> sp + 176: 0x00000004
> sp + 180: 0xbc13b7c4
> sp + 184: 0x6b65726e
> sp + 188: 0x656c0000
> sp + 192: 0x00000000
> sp + 196: 0x00000000
> sp + 200: 0x00000000
> sp + 204: 0x00000000
> sp + 208: 0x00000000
> sp + 212: 0x00000000
> sp + 216: 0x00000000
> sp + 220: 0x00000000
> sp + 224: 0x00000000
> sp + 228: 0x00000000
> sp + 232: 0x00000000
> sp + 236: 0x00000000
> sp + 240: 0x00000000
> sp + 244: 0x00000088
> sp + 248: 0xbc03b850
> sp + 252: 0x0000002a
> sp + 256: 0x001360cd
> sp + 260: 0x00000690
> sp + 264: 0xc06653b0
> sp + 268: 0x00000000
> sp + 272: 0xbc13b6e4
> sp + 276: 0x00000004
> sp + 280: 0x0000000d
> sp + 284: 0xbc13b6e4
> sp + 288: 0x00000208
> sp + 292: 0x001360cd
> sp + 296: 0x00000000
> sp + 300: 0xbc13b6f0
> sp + 304: 0xc00528c4
> sp + 308: 0x00000000
> sp + 312: 0x00000000
> sp + 316: 0x00000000
> sp + 320: 0x000fc450
> sp + 324: 0x00000003
> sp + 328: 0x0000d7cc
> sp + 332: 0x0000d7cc
> sp + 336: 0xbc02e000
> sp + 340: 0x000fc450
> sp + 344: 0xbc0d8f30
> sp + 348: 0xbc0d8dc1
> sp + 352: 0xbc12929c
> sp + 356: 0x00000000
> sp + 360: 0x00000000
> sp + 364: 0x00000000
> sp + 368: 0x00000000
> sp + 372: 0x00000028
> sp + 376: 0x00000029
> sp + 380: 0x00000011
> sp + 384: 0x00000000
> sp + 388: 0x0000000e
> sp + 392: 0x00000000
> sp + 396: 0xc16c8750
> sp + 400: 0xc16c8750
> sp + 404: 0xc10e1644
> sp + 408: 0xc00b1200
> sp + 412: 0x00000000
> sp + 416: 0xc16c8750
> sp + 420: 0xc1695950
> sp + 424: 0x7fb4bec8
> sp + 428: 0x001360cd
> sp + 432: 0x00000069
> sp + 436: 0x7fb4becc
> sp + 440: 0x00000f2c
> sp + 444: 0x00000000
> sp + 448: 0x7fb4bec4
> sp + 452: 0x7f967b5c
> sp + 456: 0x0013e254
> sp + 460: 0x00000000
> sp + 464: 0xc00055a4
> sp + 468: 0x0000847e
> sp + 472: 0x7fb4bc94
> sp + 476: 0x7fb4bec8
> sp + 480: 0x30000008
> sp + 484: 0x000fc450
> sp + 488: 0x001360cd
> sp + 492: 0x00000022
> sp + 496: 0x00000000
> sp + 500: 0x00000000
> sp + 504: 0x0001b730
> sp + 508: 0x00000000
> sp + 512: 0x00000069
> sp + 516: 0x00000000
> sp + 520: 0x0010b08c
> sp + 524: 0x000fe000
> sp + 528: 0x0000847e
> sp + 532: 0x00000048
> sp + 536: 0xfffffff9
> sp + 540: 0x000fc801
> sp + 544: 0x00008079
> sp + 548: 0x000fc800
> sp + 552: 0x00000003
> sp + 556: 0x00000003
> sp + 560: 0x00000001
> sp + 564: 0x7fb4bec4
> sp + 568: 0x48151139
> sp + 572: 0x00001fff
> sp + 576: 0xfffffff9
> sp + 580: 0x0013e254
> sp + 584: 0x00008079
> sp + 588: 0x00000000
> sp + 592: 0xb496906d
> sp + 596: 0x000eb380
> sp + 600: 0x00000069
> sp + 604: 0x00000069
> sp + 608: 0x00000002
> sp + 612: 0x00000000
> sp + 616: 0x00000000
> sp + 620: 0x00000000
> sp + 624: 0x00000000
> sp + 628: 0x00000000
> sp + 632: 0x00000000
> sp + 636: 0x00000000
> sp + 640: 0x00000000
> sp + 644: 0x00000000
> sp + 648: 0x00000000
> sp + 652: 0x00000000
> sp + 656: 0x00000000
> sp + 660: 0x00000000
> sp + 664: 0x00000000
> sp + 668: 0x00000000
> sp + 672: 0x00000000
> sp + 676: 0x00000000
> sp + 680: 0x00000000
> sp + 684: 0x00000000
> sp + 688: 0x00000000
> sp + 692: 0x00000000
> sp + 696: 0x00000000
> sp + 700: 0x00000000
> sp + 704: 0x00000000
> sp + 708: 0x00000000
> sp + 712: 0x00000000
> sp + 716: 0x00000000
> sp + 720: 0x00000000
> sp + 724: 0x00000000
> sp + 728: 0x00000000
> sp + 732: 0x00000000
> sp + 736: 0x00000000
>=20
>  [<c00528c4>]
>  [<c005194c>]
>  [<c0007864>]
>  [<c00514c4>]
>  [<c0051584>]
>  [<c00528c4>]
>  [<c00b1200>]
>  [<c00055a4>]
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Code: 86 c1 ff f4 44 00 48 00 87 01 ff f8 b8 c6 00 50 03 ff ff c3 dc 05 3=
0 02 (03) ff ff c1 d4 05 30 00 d7 e1 17 dc a8 43 00 00 18 60 bb ff d7 e1 77=
 e0
> ---cut---
>=20
> Thanks,
> //richard
>=20
> P.s: Tested with Jonas Linux tree as of today.
>=20


--=-rIP2IqCugb6zpSwx6hKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9QZJIACgkQ70gcjN2673P4cwCfR+rnCPyXbP5ER0+HBvnvXt37
9W8AnAm4J19fIyinwdYLPDKX4erDoV8N
=tztR
-----END PGP SIGNATURE-----

--=-rIP2IqCugb6zpSwx6hKp--

