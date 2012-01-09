Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2AIGUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:20:37 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52064 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2AIGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 01:20:36 -0500
Date: Mon, 9 Jan 2012 17:20:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120109172016.2496b94ce207c5f7f750a1ea@canb.auug.org.au>
In-Reply-To: <20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
	<20120105160448.dc482ef6.akpm@linux-foundation.org>
	<20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_17_20_16_+1100_WBH+HBD==Q.ikkTY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_17_20_16_+1100_WBH+HBD==Q.ikkTY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jan 2012 16:59:50 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Thu, 5 Jan 2012 16:04:48 -0800 Andrew Morton <akpm@linux-foundation.or=
g> wrote:
> >
> > On Thu, 5 Jan 2012 19:04:05 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > > After merging the final tree, today's linux-next build (sparc64 defco=
nfig)
> > > failed like this:
> > >=20
> > > In file included from include/trace/ftrace.h:567:0,
> > >                  from include/trace/define_trace.h:86,
> > >                  from include/trace/events/power.h:240,
> > >                  from kernel/trace/power-traces.c:14:
> > > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmalloc':
> > > include/trace/events/kmem.h:45:1: error: implicit declaration of func=
tion 'check_trace_callback_type_kmalloc' [-Werror=3Dimplicit-function-decla=
ration]
> > > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_cach=
e_alloc':
> > >
> > > ...
> > >
> > > include/trace/events/kmem.h:267:1: error: implicit declaration of fun=
ction 'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=3Dimplicit=
-function-declaration]
> > > In file included from include/trace/ftrace.h:774:0,
> > >                  from include/trace/define_trace.h:86,
> > >                  from include/trace/events/power.h:240,
> > >                  from kernel/trace/power-traces.c:14:
> > > include/trace/events/kmem.h: In function 'perf_test_probe_mm_page_pcp=
u_drain':
> > > include/trace/events/kmem.h:256:1: error: implicit declaration of fun=
ction 'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=3Dimplicit-fu=
nction-declaration]
> > >=20
> > > I have no idea what has gone wrong here, but I did not get this error
> > > yesterday.  The only thing that touched include/trace/events/kmem.h is
> > > patch "mm-tracepoint: rename page-free events" from the akpm tree, but
> > > that was there yesterday as well and doesn't look suspicious.
> >=20
> > Yes, it's not due to anything in the akpm tree.  Tracing stuff blew up.
> >=20
> > > I just have to leave things broken for today in the hope that someone
> > > figures something out.  This does not affect my X86_64 allmodconfig b=
uild
> > > or my PowerPC builds (including an allyesconfig build).
> >=20
> > It fails with sparc64 defconfig but succeeds with sparc64 allmodconfig.
> > Some config-dependent thing.  3.2 is OK, so it's something in -next.
> >=20
> > It could be that some far-off sparc64 Kconfig change is newly
> > triggering this. =20
> >=20
> > I suppose I could get off my ass and actually work out why it broke,
> > but the tracing code is too icky.
>=20
> This failure is now in Linus' tree.  I am not sure when it got there.

Bisected down to:

8a25a2fd126c621f44f3aeaef80d51f00fc11639 is the first bad commit
commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Wed Dec 21 14:29:42 2011 -0800

    cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular subsyst=
em
   =20
    This moves the 'cpu sysdev_class' over to a regular 'cpu' subsystem
    and converts the devices to regular devices. The sysdev drivers are
    implemented as subsystem interfaces now.
   =20
    After all sysdev classes are ported to regular driver core entities, the
    sysdev implementation will be entirely removed from the kernel.
   =20
    Userspace relies on events and generic sysfs subsystem infrastructure
    from sysdev devices, which are made available with this conversion.
   =20
    Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
    Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Fenghua Yu <fenghua.yu@intel.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
    Cc: Paul Mundt <lethal@linux-sh.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: Chris Metcalf <cmetcalf@tilera.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Borislav Petkov <bp@amd64.org>
    Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
    Cc: Len Brown <lenb@kernel.org>
    Cc: Zhang Rui <rui.zhang@intel.com>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Russell King <rmk+kernel@arm.linux.org.uk>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Arjan van de Ven <arjan@linux.intel.com>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 9f2bf9fd8c5aded0a2ee73e897384dcf751c7be3 e0a42f67ed44979aa64=
b2be4c6de265832e940ca M	arch
:040000 040000 f910621f42e19d9d023350ef0dc29e82d1dc9087 513187817d23d20eccb=
d12fae6d54ab46f6224a3 M	drivers
:040000 040000 1e4d8217d84d59840615679ff4c28b04bb6ff635 296baef04fc04321aba=
25b5bdbc8e7210765e7b8 M	include
:040000 040000 65e9478a4ef764542a61132c53378ef89d8677ba 671ac443ad56c84707d=
80c84eee9e3902fc5edea M	kernel

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jan_2012_17_20_16_+1100_WBH+HBD==Q.ikkTY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCocgAAoJEECxmPOUX5FEH1MQAKDVkDqvrtj3rWX4J0QwWobO
huL4ScBFAFhEzGdmkn21LzJAgKlyD/ZOkOgb+PwbvKEQt/3i/fKKc4FZwmZd3e8j
65XI5AF/rP8EVeZ5v+AkaAzmk0PWSyOji+Da4oKgQa/pqEmHGoEPNzhgEyzHAzKW
JTwDgiZNawpOpB3mGZna+BgifLRV8NQP/paGlvE+PTuwu9MxRMh4tbeQcAbKGfca
uktM3za/e8S7EPDYN4SlIk+M4/7woMJIieIxqYmOjE/ipD35NJIwd9ma3LR82S41
6Y6ha0XVkc2rR2BEg4vEE0dUPMSpfT2G53A8LH83XIUwYPj9BqD66u4HcPpYDlIG
F16GXk174rTLqHVu7jhrJ4imE8Yu5A6WGkw2pkKZUnHv20qPstTMqqM5hMIPuFMt
8ZxMhXHqZKmj8TJebDmPXKkhUVC6ME9fb5XJQR5OEBWqfOZOL2QJfK/y+VhpFi5n
tGSRfx1MJX+imhtcKNp19/o2avStFLI1OUizxLDDg+3lh27VjnxABTvuNiO2SETO
rl6LEyzq6UYOWs9UQYWTGRAeU8bGHNeWqWK4zDZG5+ufrm+mPbgZEVktfwRPO9Ks
KJ+StrrgfoRci9pRG7BO5PtD5wtqkMi+ML+SB86JkLAysVmKp8hVC5DjWmb4MlUa
mPcjib7OxrG6DIXPbHmr
=dEh+
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_17_20_16_+1100_WBH+HBD==Q.ikkTY--
