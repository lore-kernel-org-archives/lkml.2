Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0DOGMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:12:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43868 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab0DOGMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:12:21 -0400
Date: Thu, 15 Apr 2010 16:12:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: boot failure after merge of the final tree (tip
 related)
Message-Id: <20100415161214.04637496.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Apr_2010_16_12_14_+1000_sGdkpenvusvz.qL3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Apr_2010_16_12_14_+1000_sGdkpenvusvz.qL3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Yesterday's (and today's) linux-next boot (PowerPC) failed like this:

------------[ cut here ]------------
Badness at kernel/lockdep.c:2301
NIP: c0000000000a35c8 LR: c0000000000084c4 CTR: 0000000000000000
REGS: c000000000bf77e0 TRAP: 0700   Not tainted  (2.6.34-rc4-autokern1)
MSR: 8000000000021032 <ME,CE,IR,DR>  CR: 24000044  XER: 00000004
TASK =3D c000000000aa3d30[0] 'swapper' THREAD: c000000000bf4000 CPU: 0
GPR00: 0000000000000001 c000000000bf7a60 c000000000bf32f0 c0000000000084c4=
=20
GPR04: 0000000000000000 0000000000000a00 0000000000000000 0000000000000068=
=20
GPR08: 0000000000000008 c000000000c4fabe 0000000000000000 7265677368657265=
=20
GPR12: 8000000000009032 c000000007691000 0000000001c00000 c000000000770bf8=
=20
GPR16: c00000000076f390 0000000000000000 0000000000430000 00000000024876f0=
=20
GPR20: c000000000887480 0000000002487480 c0000000008876f0 0000000001b5f8d0=
=20
GPR24: c000000000770478 0000000003300000 c000000000c1f1c8 c000000000884610=
=20
GPR28: c000000000c1b290 c0000000000084c4 c000000000b45068 c000000000aa3d30=
=20
NIP [c0000000000a35c8] .trace_hardirqs_on_caller+0xb0/0x224
LR [c0000000000084c4] system_call_common+0xc4/0x114
Call Trace:
[c000000000bf7a60] [c000000000bf7ba0] init_thread_union+0x3ba0/0x4000 (unre=
liable)
[c000000000bf7af0] [c0000000000084c4] system_call_common+0xc4/0x114
--- Exception: c01 at .kernel_thread+0x28/0x70
    LR =3D .rest_init+0x34/0xf8
[c000000000bf7de0] [c00000000086916c] .proc_sys_init+0x20/0x64 (unreliable)
[c000000000bf7e50] [c0000000000099c0] .rest_init+0x20/0xf8
[c000000000bf7ee0] [c000000000848af0] .start_kernel+0x484/0x4a8
[c000000000bf7f90] [c0000000000083c0] .start_here_common+0x1c/0x5c
Instruction dump:
409e0188 0fe00000 48000180 801f08d8 2f800000 41be0050 880d01da 2fa00000=20
41be0028 e93e8538 88090000 68000001 <0b000000> 2fa00000 41be0010 e93e8538=20
------------[ cut here ]------------

Caused by commit bd6d29c25bb1a24a4c160ec5de43e0004e01f72b ("lockstat:
Make lockstat counting per cpu").  This added a WARN_ON_ONCE to
debug_atomic_inc() which is called from trace_hardirqs_on_caller() with
irqs enabled.

Line 2301 is:

        if (unlikely(curr->hardirqs_enabled)) {
                debug_atomic_inc(redundant_hardirqs_on);   <--- 2301
                return;
        }

This is especially bad since on PowerPC, WARN_ON is a TRAP and the return
path from the TRAP also calls trace_hardirqs_on_caller(), so the TRAP
recurses ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Apr_2010_16_12_14_+1000_sGdkpenvusvz.qL3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvGrj4ACgkQjjKRsyhoI8yXnACePpLpB19pWKhvfrDB9C3MQCMs
mgQAn1ivijXtG9oDFz389AjZvl2BGLkI
=NxnK
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Apr_2010_16_12_14_+1000_sGdkpenvusvz.qL3--
