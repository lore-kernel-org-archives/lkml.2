Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2K2X4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 18:56:15 -0500
Received: from mail.vapor.com ([83.220.149.2]:45842 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2K2X4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 18:56:14 -0500
Message-ID: <1354233368.5396.6.camel@pi>
Subject: Re: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 Nov 2012 00:56:08 +0100
In-Reply-To: <20121129192500.GG30789@liondog.tnic>
References: <1354144802.5396.3.camel@pi>
	 <20121129092621.GA21100@liondog.tnic>
	 <20121129122708.GA6365@pomac.netswarm.net>
	 <20121129142220.GC30789@liondog.tnic>
	 <20121129162403.GC6365@pomac.netswarm.net>
	 <20121129192500.GG30789@liondog.tnic>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BBCoDYazlLh305zwSIvt"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BBCoDYazlLh305zwSIvt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On tor, 2012-11-29 at 20:25 +0100, Borislav Petkov wrote:
> On Thu, Nov 29, 2012 at 05:24:03PM +0100, Ian Kumlien wrote:
> > > Can you do:
> > >=20
> > > make arch/x86/kernel/ptrace.lst
> > >=20
> > > and send me that file, privately is fine too.
> >=20
> > Done, =3D)
>=20
> Ok, thanks. Here it is:
>=20
> ffffffff8100b627:       83 3f 00                cmpl   $0x0,(%rdi)
> ffffffff8100b62a:       75 24                   jne    ffffffff8100b650 <=
syscall_trace_enter+0x163>
> ffffffff8100b62c:       eb 37                   jmp    ffffffff8100b665 <=
syscall_trace_enter+0x178>
> ffffffff8100b62e:       65 48 8b 0c 25 00 00    mov    %gs:0x0,%rcx
> ffffffff8100b635:       00 00=20
>                         ffffffff8100b633: R_X86_64_32S  current_task
> extern void __audit_seccomp(unsigned long syscall, long signr, int code);
> extern void __audit_ptrace(struct task_struct *t);
>=20
> static inline int audit_dummy_context(void)
> {
>         void *p =3D current->audit_context;
> ffffffff8100b637:       48 8b 89 c0 04 00 00    mov    0x4c0(%rcx),%rcx
>                                     regs->orig_ax,
>                                     regs->bx, regs->cx,
>                                     regs->dx, regs->si);
> #ifdef CONFIG_X86_64
>         else
>                 audit_syscall_entry(AUDIT_ARCH_X86_64,
> ffffffff8100b63e:       4c 8b 4b 38             mov    0x38(%rbx),%r9
> ffffffff8100b642:       48 8b 53 70             mov    0x70(%rbx),%rdx
>         return !p || *(int *)p;
> ffffffff8100b646:       48 85 c9                test   %rcx,%rcx
> ffffffff8100b649:       74 05                   je     ffffffff8100b650 <=
syscall_trace_enter+0x163>
> ffffffff8100b64b:       83 39 00                cmpl   $0x0,(%rcx)
> ffffffff8100b64e:       74 1f                   je     ffffffff8100b66f <=
syscall_trace_enter+0x182>
>                                     regs->di, regs->si,
>                                     regs->dx, regs->r10);
> #endif
>=20
> out:
>         return ret ?: regs->orig_ax;
> ffffffff8100b650:       48 83 ca ff             or     $0xfffffffffffffff=
f,%rdx
> ffffffff8100b654:       48 85 ed                test   %rbp,%rbp
> ffffffff8100b657:       75 04                   jne    ffffffff8100b65d <=
syscall_trace_enter+0x170>
> ffffffff8100b659:       48 8b 53 78             mov    0x78(%rbx),%rdx
> }
> ffffffff8100b65d:       5b                      pop    %rbx
> ffffffff8100b65e:       5d                      pop    %rbp
> ffffffff8100b65f:       48 89 d0                mov    %rdx,%rax
> ffffffff8100b662:       41 5c                   pop    %r12
> ffffffff8100b664:       c3                      retq
>=20
> We're calling audit_syscall_entry() for a 64-bit task (chrome) and we
> check whether the audit context of the task is not a dummy one.
>=20
> We fail at the second check in
>=20
>         return !p || *(int *)p;
>=20
> when we're trying to deref the ->audit_context pointer of current and
> then check it for being 0 in audit_syscall_entry. It turns out it is
> some random crap, as we saw already: RCX=3D0000000000000063.

Yep, actually gathered that from the disassembly =3D)

> From looking at the code, task audit contexts get normally allocated
> at fork time and dealloc'd at task exit time so your process should
> actually have a valid task context.

Weird, and this should be allocated automatically?

> The only explanation I have is that it could be some random corruption
> which f*cked up the ->audit_context pointer but I might be wrong. Btw,
> do you have CONFIG_AUDITSYSCALL enabled in your kernel?

grep CONFIG_AUDITSYSCALL .config
CONFIG_AUDITSYSCALL=3Dy

> I'd say right now we could watch this and if it is reproducible, then
> we can involve some more brain power and skills into it. If it has been
> only a single occurrence, then we'll write it on the random corruption's
> tab.

Uhmmm oki

> Thanks.
>=20

--=20
Ian Kumlien  -- http://demius.net || http://pomac.netswarm.net

--=-BBCoDYazlLh305zwSIvt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlC39hkACgkQ7F3Euyc51N8wGACeJEsxLbxJj8JOmsCc6Ue/iX7p
fAwAn3LdgUSSB1zCO9lQtWMfRBpZJw1a
=orOq
-----END PGP SIGNATURE-----

--=-BBCoDYazlLh305zwSIvt--

