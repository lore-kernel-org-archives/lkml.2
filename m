Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0IYRnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:43:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46043 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab0IYRnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=svdHhtsoPA1MaCRFOjg4g805Q6JxwPBLi2jXTFqHop1d4jMQE0rcfI/eI0F1l8XTr8
         uVTLnYxOM8ilXOTYNCXcruJ8oStsn8SfkWMWjG+Qxzq1oQcY498gDhMRTgjX1NMh+kdP
         9gxqDPffZRqGpanoWW9imUhfhFZOeC2p7t0+0=
Date: Sat, 25 Sep 2010 20:43:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] avoid second smp_processor_id() call in
 __touch_watchdog
Message-ID: <20100925174359.GA5449@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <20100818123346.02028e96.akpm@linux-foundation.org>
 <20100922090012.GA5459@swordfish.minsk.epam.com>
 <20100924193447.GT26290@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20100924193447.GT26290@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (09/24/10 15:34), Don Zickus wrote:
> On Wed, Sep 22, 2010 at 12:00:12PM +0300, Sergey Senozhatsky wrote:
> > Hello,
> >=20
> > Per our previous conversation:
> >=20
> > Andrew Morton wrote:
> > > Fair enough, although strictly speaking this should be done in a
> > > separate and later patch.
> > >=20
> >=20
> >=20
> > Avoid double smp_processor_id() call in __touch_watchdog (smp_processor=
_id()=20
> > itself and later call in __get_cpu_var())
>=20
> Dropping this patch then based on Peter's and Frederic's feedback that the
> compiler probably already optimizes for this, leaving readability as a go=
od
> excuse not to change anything.
>

Hello,

gcc 4.5.1, x86_64

Dump of assembler code for function __touch_watchdog:
   <+0>:	push   %rbp
   <+1>:	mov    %rsp,%rbp
   <+4>:	push   %r12
   <+6>:	push   %rbx
   <+7>:	mov    $0x0,%rbx
   <+14>:	callq  0x43 <__touch_watchdog+19>
   <+19>:	mov    %eax,%r12d
   <+22>:	callq  0x4b <__touch_watchdog+27>
   <+27>:	mov    %eax,%eax
   <+29>:	mov    %r12d,%edi
   <+32>:	add    0x0(,%rax,8),%rbx
   <+40>:	callq  0x5d <__touch_watchdog+45>
   <+45>:	shr    $0x1e,%rax
   <+49>:	mov    %rax,(%rbx)
   <+52>:	pop    %rbx
   <+53>:	pop    %r12
   <+55>:	leaveq=20
   <+56>:	retq  =20


patched __touch_watchdog:
Dump of assembler code for function __touch_watchdog:
   <+0>:	push   %rbp
   <+1>:	mov    %rsp,%rbp
   <+4>:	push   %rbx
   <+5>:	mov    $0x0,%rbx
   <+12>:	sub    $0x8,%rsp
   <+16>:	callq  0x45 <__touch_watchdog+21>
   <+21>:	movslq %eax,%rdx
   <+24>:	mov    %eax,%edi
   <+26>:	add    0x0(,%rdx,8),%rbx
   <+34>:	callq  0x57 <__touch_watchdog+39>
   <+39>:	shr    $0x1e,%rax
   <+43>:	mov    %rax,(%rbx)
   <+46>:	pop    %rax
   <+47>:	pop    %rbx
   <+48>:	leaveq=20
   <+49>:	retq
=20

	Sergey

> >=20
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >=20
> > ---
> >=20
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index 7f9c3c5..03d97c5 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -116,8 +116,7 @@ static unsigned long get_sample_period(void)
> >  static void __touch_watchdog(void)
> >  {
> >  	int this_cpu =3D smp_processor_id();
> > -
> > -	__get_cpu_var(watchdog_touch_ts) =3D get_timestamp(this_cpu);
> > +	per_cpu(watchdog_touch_ts, this_cpu) =3D get_timestamp(this_cpu);
> >  }
> > =20
> >  void touch_softlockup_watchdog(void)
> >=20
>=20

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkyeNN8ACgkQfKHnntdSXjR+QgP8CYzkgtu7zEDBuThL/rZ0fsSy
9iuipWmC4hMiJAOjs+gbdXazZiRp4YdseWZ49K25d5Tk3WZq34RTbFpyq8+WP1mN
A063AiKQPHks01JzmPDmRTtFFJyvhOA96qViN0Qmfl5P8SbM5wut2s5q1aWqiSOT
Wl+JszE1JzNjhZLkiU4=
=awSS
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
