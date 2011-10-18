Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab1JRPUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:20:42 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:33411 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754412Ab1JRPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:20:41 -0400
Date: Tue, 18 Oct 2011 11:20:39 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111018152039.GB11530@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
 <20111010233842.GC24583@mgebm.net>
 <1318319095.14400.54.camel@laptop>
 <20111012165154.GB6158@mgebm.net>
 <CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
 <20111018135322.GA11530@mgebm.net>
 <1318949002.21167.20.camel@twins>
 <CABPqkBRxqC5c1JvvpDawkK9PizAfBGNCksR8bpyJ-rWB4LKmrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <CABPqkBRxqC5c1JvvpDawkK9PizAfBGNCksR8bpyJ-rWB4LKmrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Oct 2011, Stephane Eranian wrote:

> Hi,
>=20
> I suspect it's because of this chunk:
>         rcu_read_lock();
>=20
>         list_for_each_entry_rcu(pmu, &pmus, entry) {
> -
>                 cpuctx =3D this_cpu_ptr(pmu->pmu_cpu_context);
>=20
> -               perf_pmu_disable(cpuctx->ctx.pmu);
> -
>                 /*
>                  * perf_cgroup_events says at least one
>                  * context on this CPU has cgroup events.
> @@ -353,6 +366,8 @@ void perf_cgroup_switch(struct task_struct *task, int=
 mode)
>                  * events for a context.
>                  */
>                 if (cpuctx->ctx.nr_cgroups > 0) {
> +                       perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +                       perf_pmu_disable(cpuctx->ctx.pmu);
>=20
>=20
> In other words, you don't call perf_pmu_disable() unless you know
> you have cgroup events.
>=20
> Without that, I think you will touch the PMU on cgroup switch and
> that night conflict with another subsystem using the PMU, e.g. OProfile.

Exactly, the inital bug was being caused by something in perf touching the =
MMCR0
register without reserving the hardware first (or noticing that oprofile had
already done so).  So oprofile runs would show abnormally low event counts =
or
counts that were not there if you were really unlucky.  This patch fixes the
problem because the MMCR0 register will not be touched unless there was the=
re
were cgroup events active.

>=20
>=20
> On Tue, Oct 18, 2011 at 4:43 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> =
wrote:
> > On Tue, 2011-10-18 at 09:53 -0400, Eric B Munson wrote:
> >> On Wed, 12 Oct 2011, Stephane Eranian wrote:
> >>
> >> > Could be:
> >> > =A0 =A0a8d757e perf events: Fix slow and broken cgroup context switc=
h code
> >> >
> >>
> >> Thanks for the pointer, but the fix was in:
> >> =A0 =A0 facc4307 perf: Optimize event scheduling locking
> >>
> >> This might be a candidate for stable given that oprofile is broken wit=
hout it.
> >
> > I might feel much more confident about recommending that if someone
> > could explain why that patches fixes what exact problem.
> >
>=20

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOnZlHAAoJEKhG9nGc1bpJDNwQAKKQfCaKVdNdxAgAyxwT4d5F
UjN7E+ioi5qRya+UwX34n2JAY3nkVr/c7FZ7iCcQQm5TvaFhjTADGmzblhx7FFkk
Gao9+RiChXjCLTR1xeiIklsjHv/c1Xw516rtR38mprjI0fcFvF1gxsQhVC+2Enum
bqemE4Y/yOrT/0NDmXDBKgI7M1nYeJOl+Er7Qn+lkzdkkgcRHv6QEaLeJ015AA2p
bOw1BNxalr/vo8h9sgSZ+5K2o/5cZ+W88E1jlrglZHofVr/p59r+90Q+6uAJlneC
Mxi3pKw5baqb00h2Zeomh6rqnwZYVxJ09aNvH1XfCOZE6wtxjuVnnJKH6epGCEap
49gKLEeIds3NlaIuZV3whNx4/12TMwB8DAZbXCcD9JbsYX0C2Bq1qPAabSTYQsG7
ozI7wH2qDhhCD8Ys5LbNeTgrSDqW7isEudfmmvwNYSxm/bEchXsq4//d0uc4XKQJ
RvOCBB94fEIpvLYKhD0pMv4Y0Bz2si4dKmQgRBaLk7zF3inVL3PQ6M3qGNsYkTfb
TuWr7TOwitHoUR1XHMwSeQOvpGYjKMaq96R025aedJPfPqI+EAzBcMUJfEZh0tBr
OUyhZDFCSMGF4u6L3UdfdsAS/i2xPCZ3GbnQFhj0SD4V2H9/TS3hdgQTG2799g9d
QKifp16y7+c6JRUVBdQO
=AfwQ
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
