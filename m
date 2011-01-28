Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1A1AYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:24:55 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:33746 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1A1AYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:24:54 -0500
X-Spam-ASN: 
Date: Fri, 28 Jan 2011 03:24:43 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: uClibc <uclibc@uclibc.org>, linux-kernel@vger.kernel.org
Subject: timerfd incompatibility on mips
Message-ID: <20110128032443.6f8b877e@apollo.gnet>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/.8ayL6L1T_J7gagpYNVW9sH"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.8ayL6L1T_J7gagpYNVW9sH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi!

I've just found a problem with TFD_NONBLOCK flag that can be passed to
timerfd_create.

<uclibc>/libc/sysdeps/linux/common/sys/timerfd.h which is installed
to /usr/include/sys/timerfd.h defines TFD_NONBLOCK as 04000 ie 0x800.
BTW glibc/eglibc headers do the same thing.

<linux>/include/linux/timerfd.h declares it as O_NONBLOCK which is
defined in fcntl.h. Usually O_NONBLOCK is 0x800 too but some
architectures including MIPS it redefine it:

arch/mips/include/asm/fcntl.h:#define O_NONBLOCK	0x0080
arch/alpha/include/asm/fcntl.h:#define O_NONBLOCK	00004
arch/sparc/include/asm/fcntl.h:#define O_NONBLOCK	0x4000
arch/parisc/include/asm/fcntl.h:#define O_NONBLOCK	000200004

My tests show that kernel thinks that TFD_NONBLOCK is 0x80 on MIPS. I
get what I want when I pass 0x80 and EINVAL when I pass 0x800. I don't
know why there are such uncertain things in Linux. Probably the problem
should be fixed in the kernel.

Right now one cannot use timerfd_create(..., TFD_NONBLOCK) on MIPS but
can use timerfd_create(..., O_NONBLOCK) instead.

--=20
  Alexander

--Sig_/.8ayL6L1T_J7gagpYNVW9sH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNQgzMAAoJEElrwznyooJbnVAIAIx6imdpBv6X6Bd+cUtPNWmi
Y/kC1gVXH0MyxjxQG6QtVfLJEh0H1pF3BF7rBBArwTD7ARsnDWlgqEwq+TaIcfbn
Z0xZfp8zW6iWN8lEuO9GxcSWxn2aiN7fylO/tRUFl/6JFrZrkNe039q1e27jEUxw
5H37ZNmKFMWaT2/X+9vaU62KFn4+FEG5zPIdO4wN2x3e1ZjvJ9ahXualiQVOFut4
u7BcUZN/UMEgt9QluorwkVlmbhNttadfU0/jfGPpilTIa1wYrZKQ4zPUjivn28z5
a8haVQy03zCkI13dSPE5wBfNBJUxcKuRQS/tDtpMQMoiqBqo207YKot7qwnkrpg=
=cW0p
-----END PGP SIGNATURE-----

--Sig_/.8ayL6L1T_J7gagpYNVW9sH--
