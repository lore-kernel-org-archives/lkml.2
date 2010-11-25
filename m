Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0KYNmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:42:47 -0500
Received: from ozlabs.org ([203.10.76.45]:60469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0KYNmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:42:45 -0500
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1290667950.2072.545.camel@laptop>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com>
	 <1290611478.2072.482.camel@laptop> <20101124151936.GB2815@redhat.com>
	 <1290612245.2072.486.camel@laptop>  <20101124154200.GD2815@redhat.com>
	 <1290613997.30543.529.camel@gandalf.stny.rr.com>
	 <1290652762.18088.4.camel@concordia>  <1290667950.2072.545.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8iHrSdqN2BMIr9QjW6jH"
Date: Fri, 26 Nov 2010 00:42:44 +1100
Message-ID: <1290692564.689.28.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8iHrSdqN2BMIr9QjW6jH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-25 at 07:52 +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-25 at 13:39 +1100, Michael Ellerman wrote:
> > > > arch/powerpc/lib/code-patching.c:
> > > >=20
> > > > void patch_instruction(unsigned int *addr, unsigned int instr)
> > > > {
> > > >         *addr =3D instr;
> > > >         asm ("dcbst 0, %0; sync; icbi 0,%0; sync; isync" : : "r"
> > > > (addr));
> > > > }
> > >=20
> > > Is this ever called outside of boot up? After SMP is enabled? (beside=
s
> > > for creating trampolines, before they are used).
> >=20
> > It is now :)
> >=20
> > AFAIK it works fine, the icbi invalidates across all processors. The
> > only issue is that it's not precise, ie. another CPU might not see the
> > update immediately, but as soon as it takes an interrupt or something i=
t
> > will.
>=20
> Ooh, nice, so the CPUs won't get all confused because you change code
> from under their ifetch cache?

Apparently not, at least according to the architecture.

> How expensive is this icbi ins?

Well apparently it's free :)  But it has the effect of causing the
subsequent isync to do the real work, so that is probably expensive.
Benh can tell you all the gory details.

> > What would suit us would be to have an arch callback that is called
> > after all the transforms for a particular jump label key have been made=
.
> > That way we could optimise the individual patches, and do a sync step a=
t
> > the end, ie. when we want the effect of the patching to be globally
> > visible.=20
>=20
> I think such a sync-barrier is desired (possibly only on the enable
> path) so we can actually say the tracepoints are on.

It might be nice on disable too, presumably the tracepoint code is happy
with them firing more or less any time, but other users of jump labels
might want a firmer guarantee that they are disabled.

> Which would mean sending IPIs to all CPUs and waiting for them to
> acknowledge them. Which, while not quite as expensive as stop_machine,
> its not really cheap either.

True, and presumably the sync point is once per jump label, ie. once per
tracepoint. For tracepoints you'd actually be happy with eg. perf
enabling a whole bunch, and then syncing just at the end, but that's
probably premature optimisation.

cheers



--=-8iHrSdqN2BMIr9QjW6jH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzuZ9QACgkQdSjSd0sB4dKHrACeK0clkdM7JEFAziz1bXgOk+4S
v0AAn32XAJlBJ30AOmgD6y0xu16LlBjZ
=xKYK
-----END PGP SIGNATURE-----

--=-8iHrSdqN2BMIr9QjW6jH--

