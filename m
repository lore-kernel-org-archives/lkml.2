Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0K1UOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:14:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48161 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab0K1UOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:14:44 -0500
From: Ben Hutchings <benh@debian.org>
To: Frede_Feuerstein@gmx.net, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: 603229@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1290920436.4255.1025.camel@localhost>
References: <1290449310.3868.13.camel@localhost>
	 <1290470134.6770.929.camel@localhost>  <1290514638.3892.16.camel@localhost>
	 <1290900814.3292.84.camel@localhost> <1290920436.4255.1025.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JGj6uTsYcji1DQmnSRKG"
Organization: Debian Project
Date: Sun, 28 Nov 2010 20:14:26 +0000
Message-ID: <1290975266.3292.316.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: benh@debian.org
Subject: Scheduler grouping failure; division by zero in select_task_rq_fair
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JGj6uTsYcji1DQmnSRKG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-11-28 at 06:00 +0100, Frede Feuerstein wrote:
[...]
> > The division by zero appears to be a result of getting bad information
> > from the firmware about the groups of processors.
>=20
> Well, technically a division error always is a result of bad data fed to
> that division. I rather meant, that this is the point to backtrace the
> error.
> Though the bios of the w2100z is known for some problems, the cpus are
> reported correctly by the bios and it is the latest version (R01-B5-S1).
>=20
> >   I realise that this
> > same bad information did not previously result in a crash, but I (and
> > the upstream developers) need to know what that information is before w=
e
> > can understand how this can be avoided.
>=20
> Are there any means to gather more information ? Tell me and i shall do
> it.=20

I think this is now enough information.

Ingo, Peter, the output from scheduler domain/group setup was:

[    0.536554] CPU0 attaching sched-domain:
[    0.540004]  domain 0: span 0-1 level MC
[    0.548002]   groups: 0 1
[    0.560003]   domain 1: span 0-3 level NODE
[    0.568002]    groups:
[    0.574179] ERROR: domain->cpu_power not set
[    0.576002]
[    0.580002] ERROR: groups don't span domain->span
[    0.584004] CPU1 attaching sched-domain:
[    0.588007]  domain 0: span 0-1 level MC
[    0.596002]   groups: 1 0 (cpu_power =3D 1023)
[    0.612002] ERROR: parent span is not a superset of domain->span
[    0.616003]   domain 1: span 1-3 level CPU
[    0.624002]    groups: 1 (cpu_power =3D 2048) 2-3 (cpu_power =3D 2048)
[    0.644003]    domain 2: span 0-3 level NODE
[    0.652004]     groups: 1-3 (cpu_power =3D 4096)
[    0.668002] ERROR: domain->cpu_power not set
[    0.672002]
[    0.676002] ERROR: groups don't span domain->span
[    0.680004] CPU2 attaching sched-domain:
[    0.684003]  domain 0: span 2-3 level MC
[    0.692003]   groups: 2 3
[    0.704003]   domain 1: span 1-3 level CPU
[    0.712003]    groups: 2-3 (cpu_power =3D 2048) 1 (cpu_power =3D 2048)
[    0.736003]    domain 2: span 0-3 level NODE
[    0.744003]     groups: 1-3 (cpu_power =3D 4096)
[    0.760003] ERROR: domain->cpu_power not set
[    0.764003]
[    0.768003] ERROR: groups don't span domain->span
[    0.772004] CPU3 attaching sched-domain:
[    0.776003]  domain 0: span 2-3 level MC
[    0.784003]   groups: 3 2
[    0.794183]   domain 1: span 1-3 level CPU
[    0.800003]    groups: 2-3 (cpu_power =3D 2048) 1 (cpu_power =3D 2048)
[    0.822183]    domain 2: span 0-3 level NODE
[    0.828003]     groups: 1-3 (cpu_power =3D 4096)
[    0.842180] ERROR: domain->cpu_power not set
[    0.844003]
[    0.848003] ERROR: groups don't span domain->span

and the oops is:

[    0.852154] divide error: 0000 [#1] SMP
[    0.856002] last sysfs file:
[    0.856002] CPU 1
[    0.856002] Modules linked in:
[    0.856002] Pid: 2, comm: kthreadd Not tainted 2.6.32-5-amd64 #1 W1100z/=
2100z
[    0.856002] RIP: 0010:[<ffffffff810416e9>]  [<ffffffff810416e9>] select_=
task_rq_fair+0x665/0 x800
[    0.856002] RSP: 0018:ffff88003fdb7c90  EFLAGS: 00010046
[    0.856002] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000000=
00000
[    0.856002] RDX: 0000000000000000 RSI: 0000000000000200 RDI: 00000000000=
00200
[    0.856002] RBP: ffff88004120fd50 R08: 0000000000000000 R09: ffff88007f9=
8f0b0
[    0.856002] R10: 0000000000000000 R11: 00000000000252d0 R12: ffff88007f9=
8f060
[    0.856002] R13: ffff88007f98f070 R14: ffffffffffffffff R15: 00000000000=
15780
[    0.856002] FS:  0000000000000000(0000) GS:ffff880041200000(0000) knlGS:=
0000000000000000
[    0.856002] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    0.856002] CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000=
006e0
[    0.856002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    0.856002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    0.856002] Process kthreadd (pid: 2, threadinfo ffff88003fdb6000, task =
ffff88003fdc8710)
[    0.856002] Stack:
[    0.856002]  0000000000015780 0000000000015780 0000000000015780 00000000=
00015780
[    0.856002] <0> 0000000000015780 0000000000015788 0000000000015788 fffff=
fff8146c260
[    0.856002] <0> 0000000800000000 ffff88007f9b0000 ffff880041215780 00000=
00081317f88
[    0.856002] Call Trace:
[    0.856002]  [<ffffffff8104d2b2>] ? copy_process+0x1007/0x115f
[    0.856002]  [<ffffffff810475f4>] ? select_task_rq+0xb/0x3e
[    0.856002]  [<ffffffff8104b53b>] ? wake_up_new_task+0x35/0xf6
[    0.856002]  [<ffffffff8104d65e>] ? do_fork+0x254/0x31e
[    0.856002]  [<ffffffff81041aa9>] ? pick_next_task_fair+0xca/0xd6
[    0.856002]  [<ffffffff8104802b>] ? finish_task_switch+0x3a/0xaf
[    0.856002]  [<ffffffff81011b42>] ? kernel_thread+0x82/0xe0
[    0.856002]  [<ffffffff810648c8>] ? kthread+0x0/0x81
[    0.856002]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[    0.856002]  [<ffffffff8106488d>] ? kthreadd+0xb1/0xec
[    0.856002]  [<ffffffff814f3140>] ? early_idt_handler+0x0/0x71
[    0.856002]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
[    0.856002]  [<ffffffff814f3140>] ? early_idt_handler+0x0/0x71
[    0.856002]  [<ffffffff810dfda5>] ? do_set_mempolicy+0x128/0x13a
[    0.856002]  [<ffffffff810647dc>] ? kthreadd+0x0/0xec
[    0.856002]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
[    0.856002] Code: 00 02 00 00 4c 89 ef 48 63 d2 e8 0f c6 14 00 3b 05 ad =
33 49 00 89 c2 0f 8c  6f ff ff ff 41 8b 4c 24 08 48 c1 e3 0a 31 d2 48 89 d8=
 <48> f7 f1 83 bc 24 a8 00 00 00 00 48 89  c1 75 22 4c 39 f0 73 15
[    0.856002] RIP  [<ffffffff810416e9>] select_task_rq_fair+0x665/0x800
[    0.856002]  RSP <ffff88003fdb7c90>
[    0.856002] ---[ end trace a22d306b065d4a66 ]---

There's more information in the bug log at <http://bugs.debian.org/603229>.

If you think this has been fixed since 2.6.32 (I didn't see any relevant
changes) then we have a package of 2.6.36 which Frede can test.

Ben.

--=20
Ben Hutchings, Debian Developer and kernel team member


--=-JGj6uTsYcji1DQmnSRKG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATPK4Hee/yOyVhhEJAQIAYxAAvCY/PxWZCIIYWztNajhXUfTEOcO9nM9o
RmeUQavBJ/f9rZ8c8p8DE2/Bu4fYgzQLGXGFOZHhhfGAi0PYJMPCm3epgjNj/G/m
OrE+Y0xmX3kM7zsJ8xUgiW9xcD/Za46QANiL3zR12HxYmL7YUwBKD/ooTmychiha
VS/ooYeWsAJW6zwe7X1zqwOrHNEniZ5rZnPVO/MQc5+BrFDJMOYRqzO0BRet97IO
+NVDp3EYltl+9DrvfdTAJyKy2JzaNpfvG+mXB6K6PRtU+VZsybeHKVqR3Qcnx0cC
bTLP1Zs7Zh5LT1+y52BYgBQhHllatdUfoV7xDrVDeAMvarV//0Aa5Zklsh5Nsx89
oVZEFAjwlzQFwv3CF3fkAtzzcr9Gegm9N9/No8VYEz8xXKflZcyYcBzMJ6gRFrcb
ZiR6M2RfjjrU2R1jWBZCZm6IcAcamKPE/lzKIC1Xtq2pC09ddaVJV/of9C9yZ8WG
WvZM38eUV4gDHORP3Jq5Np4+STa/niKE5XI6JrCb3+1iqpew0wlKFCtP/RszExwv
Ty3dVyIN+MLSekpeiq+IzC0RSjOVFpbuyaLO5jqYIL3Z0uikEJMeejbIH9pA85Xk
NtUIGqaYxvyjs6pi1Uo/TXXVsMPEVa8Xnts+hsN3BIiekRqCCxsw7/U7q0PVU3Pm
Qfvvf+JjHaM=
=9p/3
-----END PGP SIGNATURE-----

--=-JGj6uTsYcji1DQmnSRKG--
