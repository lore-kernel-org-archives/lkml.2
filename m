Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0GFNEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 09:04:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51946 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0GFNEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 09:04:08 -0400
Date: Tue, 6 Jul 2010 15:04:04 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Problem with tty changes in linux-next
Message-ID: <20100706130403.GD3991@pengutronix.de>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Content-Disposition: inline
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:31:18 up  6:09, 12 users,  load average: 0.01, 0.02, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I just tried to get latest linux-next (HEAD=3D288092896e2097eebee7d4bf1df9a=
0c7b550e225)
run on my ARM system (a PXA270 base PCM990 board. The board maps its consol=
e to its
ttyS0. During the tests I experienced two problems with the new shiny bkl-f=
ree
tty stuff:

1. The tty mutex stuff depends on SMP, which I don't have on my target
system. So I still have to use the bkl for tty_lock and tty_unlock. This
leads to a WARN while booting:
------------[ cut here ]------------
WARNING: at include/linux/tty.h:590 tty_open+0x8c/0x60c()
Modules linked in:
Backtrace:
[<c00256c4>] (dump_backtrace+0x0/0x10c) from [<c0287418>] (dump_stack+0x18/=
0x1c)
 r6:c015841c r5:c03133f0 r4:0000024e
[<c0287400>] (dump_stack+0x0/0x1c) from [<c003529c>] (warn_slowpath_common+=
0x58/0x88)
[<c0035244>] (warn_slowpath_common+0x0/0x88) from [<c00352f0>] (warn_slowpa=
th_null+0x24/0x2c)
 r8:c08f8754 r7:c39f2bc0 r6:00500001 r5:00000000 r4:00000000
[<c00352cc>] (warn_slowpath_null+0x0/0x2c) from [<c015841c>] (tty_open+0x8c=
/0x60c)
[<c0158390>] (tty_open+0x0/0x60c) from [<c009ca50>] (chrdev_open+0x110/0x1b=
c)
[<c009c940>] (chrdev_open+0x0/0x1bc) from [<c0097d94>] (__dentry_open+0xf0/=
0x2a0)
 r8:c3401270 r7:c009c940 r6:c3400038 r5:c39f2bc0 r4:00000000
[<c0097ca4>] (__dentry_open+0x0/0x2a0) from [<c009802c>] (nameidata_to_filp=
+0x58/0x60)
[<c0097fd4>] (nameidata_to_filp+0x0/0x60) from [<c00a461c>] (do_last+0x3d0/=
0x658)
 r5:00000000 r4:00000000
[<c00a424c>] (do_last+0x0/0x658) from [<c00a65e8>] (do_filp_open+0x18c/0x51=
8)
[<c00a645c>] (do_filp_open+0x0/0x518) from [<c0097bb0>] (do_sys_open+0x70/0=
x108)
[<c0097b40>] (do_sys_open+0x0/0x108) from [<c0097c80>] (sys_open+0x24/0x28)
[<c0097c5c>] (sys_open+0x0/0x28) from [<c00084b8>] (kernel_init+0xe4/0x188)
[<c00083d4>] (kernel_init+0x0/0x188) from [<c0038c50>] (do_exit+0x0/0x688)
 r6:00000000 r5:00000000 r4:00000000
---[ end trace 7dd0bbd3f54aa46f ]---
tty_port_block_til_ready: flags 0x80000000
------------[ cut here ]------------

Indeed the bkl is held by kernel_init, so we will kind of _always_ run
into this. Seemed that the tty_lock stuff was reworked in
4a179218b78d346e0de37c6d428d5be01fadae9c by Arnd. I'd say that the
check of a holding lock in non-tty_mutex system should be changed here,
probably exclusive check for tty locks.

2. A more serious problem is that printing kernel message no more works
after running into userspace.
=2E...
Freeing init memory: 100K
3sy||_|_|
phyCORE login:
=2E...
The boot message between init and login sheel is printed only
partly. The cursor jumps back and forward. It seems that part the
special characters like new line etc. are cutted away so that the
printout is shown in such a funny manner. After a tty is spawned, every
thing works just well. I can log in onto the system and it seems to work
so far. I bisected the kernel and identified eventually
fb11bee14186af87ee6abb833cf1a2a6be59c65b as the
first bad commit. The actual problem should be, however,
36c621d82b956ff6ff72273f848af53e6c581aba, where tty_port_block_til_ready()
is introduced. Seems to me that there are locking problems. I
unfortunately don't have any insights of tty layer to tell where the
exact problem is.

BTW: We also experienced both the problems above on another board, which
is based on a I.MX27 SOC. So I can tell that this is no trouble with the
PXA itself.

Any hints/ideas?

Thanks

Cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwzKcMACgkQkLuxfMCkDTbg5wCeLpTRuof6FDBzxL4JvE7QNbsp
6sAAn27TmzIQpn7Xh2YEgjkRgKhXiryQ
=bjbQ
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
