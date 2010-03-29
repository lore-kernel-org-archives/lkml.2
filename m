Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0C2Wef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:34:35 -0400
Received: from ppa03.Princeton.EDU ([128.112.128.214]:35663 "EHLO
	ppa03.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0C2Wee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:34:34 -0400
Date: Mon, 29 Mar 2010 18:34:14 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: john stultz <johnstul@us.ibm.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100329183414.2f9e3966@penta.localdomain>
In-Reply-To: <1269899024.3968.27.camel@localhost.localdomain>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	<20100326214648.GF9984@mail.oracle.com>
	<1269824436.1880.2.camel@work-vm>
	<20100329101106.3678a312@penta.localdomain>
	<1269881007.1857.18.camel@work-vm>
	<20100329130418.2b5c068c@penta.localdomain>
	<1269888291.3968.5.camel@localhost.localdomain>
	<ea182b21003291408t5a4fe8a8l47c0041df043a3a9@mail.gmail.com>
	<1269899024.3968.27.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HCuTc8nwAg1FKyZjPdU=k//"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HCuTc8nwAg1FKyZjPdU=k//
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Mar 2010 14:43:44 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Mon, 2010-03-29 at 17:08 -0400, Yury Polyanskiy wrote:
> > >> > What I'm saying is that if you're using getrawmonotonic() to detect
> > >> > hangs, you might miss them, as getrawmonotonic may wrap (and thus =
stop
> > >> > continually increasing) if the timer interrupt is delayed. This do=
es not
> > >> > apply to systems using the TSC clocksource, but does apply to syst=
ems
> > >> > using the acpi_pm.
> And something else I thought of, while the TSC won't wrap, the
> multiplication done to convert to nanoseconds will overflow when you hit
> a large enough cycle delta. So even TSC systems are not guaranteed to
> have timekeeping (and thus getrawmonotonic) work over infinite time
> without accumulation.

Agreed (large clock->shift, right?), but for hangcheck-timer this
would hardly be a problem, since such a large overflow very unlikely to
land inside allowed interval around the pre-planned timer fire instant.

>=20
> You might also have some trouble with small intervals. Since things like
> tickless systems or other advanced power-savings systems might try to
> collate or push timers together to save battery. So ticks may be delayed
> a small amount (timers are only guaranteed to fire AFTER the time
> specified, there really is no promised bound on how late they may be).
>=20
> Additionally, on -rt systems, you might have higher priority FIFO tasks
> blocking the hangcheck timer from executing for a smallish amount of
> time.

Yes, these are the events I want to see logged. Essentially I use
hangcheck timer to check stability of kernel's heartbeat.

> > Also, hooking to ntp update code complicates an otherwise simple
> > driver. I propose to simply check on non-S390 if the clock source
> > resolves to something other than TSC and dump a warning message on
> > driver load (something like "Hangcheck: kernel using clocksource %s,
> > which is not reliable for hang detection").
>=20
> That requires the hangcheck code to parse the current clocksource, which
> might change as the system runs, so it also has to track the clocksource
> over time. So I'm not sure its that much easier of a solution.

Oh, shoot, you are right. So if compiled-in it would always complain.

> Something to also consider might also be to look at the softlockup
> watchdog, which is fairly similar but somewhat more deeply integrated
> into the kernel. Maybe some of this could be merged?

Yeah, for softlockup detection, I don't understand why one would
prefer hangcheck-timer to watchdog. I am sure Joel has some reasons
though. For me read_persistent_clock() is not a solution, and others
perhaps are indeed would be using softlockup watchdog, which leaves the
decision to Joel.

Best,
Y

--Sig_/HCuTc8nwAg1FKyZjPdU=k//
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuxKuYACgkQemuRe3zuqOSBlgCdEZ50TdJPVLG/CVfOyZvoA5Ob
MuoAn3CMK/vb1TUy6NlwlZSs0+qe+eKG
=2bkw
-----END PGP SIGNATURE-----

--Sig_/HCuTc8nwAg1FKyZjPdU=k//--
