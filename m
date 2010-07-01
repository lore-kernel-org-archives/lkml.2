Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0GAGNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 02:13:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64822 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0GAGNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 02:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sAU4spWU+HtzFHa0vUlY2fJX/rc32Y0+dVjrwjQz2B5830mxsCR6xG3+GApkeZBOkw
         m8A4nzaSCXOwjtcEk6IvjZZeNeJ/x6Cg16PGbJQ3a1HFrfgMFDiYKlm9O8FUXpKYrIgw
         hHT97qmTJbzuM4KqoPRpwF1RcdePH8Okpz66c=
Date: Thu, 1 Jul 2010 09:17:09 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] cpuidle: avoid using smp_processor_id() in preemptible
 code (nr_iowait_cpu) v4
Message-ID: <20100701061709.GA7380@swordfish>
References: <20100614080154.7d6a71fc@infradead.org>
 <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
 <20100615061927.GA3312@swordfish>
 <20100615072435.5a47d850@infradead.org>
 <20100615145029.GB3967@swordfish.minsk.epam.com>
 <20100615080808.6286448b@infradead.org>
 <20100617062950.GA3979@swordfish>
 <1277476773.32034.639.camel@twins>
 <20100630125853.245e6b99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20100630125853.245e6b99.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/30/10 12:58), Andrew Morton wrote:
> Subject: Re: [PATCH] cpuidle: avoid using smp_processor_id() in
>  preemptible
>  code (nr_iowait_cpu) v4
> X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
>=20
> On Fri, 25 Jun 2010 16:39:33 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > On Thu, 2010-06-17 at 09:29 +0300, Sergey Senozhatsky wrote:
> > > Fix
> > >   =20
> > >  BUG: using smp_processor_id() in preemptible [00000000] code: s2disk=
/3392
> >=20
> > > The initial fix was to use get_cpu/put_cpu in nr_iowait_cpu.  However,
> > > Arjan stated that "the bug is that it needs to be nr_iowait_cpu(int c=
pu)".
> > >=20
> > > This patch introduces nr_iowait_cpu(int cpu) and changes to its calle=
rs.
> > >=20
> > > Arjan also pointed out that we can't use get_cpu/put_cpu in update_ts=
_time_stats
> > > since we "pick the current cpu, rather than the one denoted by ts" in=
 that case.
> > > To match given *ts and cpu denoted by *ts we use new field in the str=
uct tick_sched: int cpu.
> >=20
> >=20
> > > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > > index b232ccc..db14691 100644
> > > --- a/include/linux/tick.h
> > > +++ b/include/linux/tick.h
> > > @@ -51,6 +51,7 @@ struct tick_sched {
> > >  	unsigned long			check_clocks;
> > >  	enum tick_nohz_mode		nohz_mode;
> > >  	ktime_t				idle_tick;
> > > +	int				cpu;
> > >  	int				inidle;
> > >  	int				tick_stopped;
> > >  	unsigned long			idle_jiffies;
> >=20
> > > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > > index 1d7b9bc..1907037 100644
> > > --- a/kernel/time/tick-sched.c
> > > +++ b/kernel/time/tick-sched.c
> > > @@ -38,6 +38,9 @@ static ktime_t last_jiffies_update;
> > > =20
> > >  struct tick_sched *tick_get_tick_sched(int cpu)
> > >  {
> > > +	/*FIXME: Arjan van de Ven:
> > > +	 can we do this bit once, when the ts structure gets initialized?*/
> > > +	per_cpu(tick_cpu_sched, cpu).cpu =3D cpu;
> > >  	return &per_cpu(tick_cpu_sched, cpu);
> > >  }
> >=20
> > > @@ -161,7 +164,7 @@ update_ts_time_stats(struct tick_sched *ts, ktime=
_t now, u64 *last_update_time)
> > >  	if (ts->idle_active) {
> > >  		delta =3D ktime_sub(now, ts->idle_entrytime);
> > >  		ts->idle_sleeptime =3D ktime_add(ts->idle_sleeptime, delta);
> > > -		if (nr_iowait_cpu() > 0)
> > > +		if (nr_iowait_cpu(ts->cpu) > 0)
> > >  			ts->iowait_sleeptime =3D ktime_add(ts->iowait_sleeptime, delta);
> > >  		ts->idle_entrytime =3D now;
> > >  	}
> >=20
> >=20
> > This all seems extremely silly, why not something like:
>=20
> Does it work?
>=20
> c'mon guys, it's taking us weeks and weeks to fix one simple bug.  It's
> a regression!  We should be in panic mode.
>=20

Hello,

Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:                   =
                                                                           =
                                   =20
>> Well, there is something I'm missing. How can I match given *ts and
>> cpu in update_ts_time_stats (except for introducing
>> update_ts_time_stats(..., int cpu)) ?

Arjan van de Ven <arjan@linux.intel.com> wrote:
>that'd be option one
>option two is to add a "cpu" member to struct tick_sched.....

So, it's been discussed. I chose option #2 however and made a mistake.
Personally I prefer Peter's patch. I need some time to test it.


	Sergey

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwsMuUACgkQfKHnntdSXjThmgP/QoX4HFosXpzrHHfQWe6/4XTf
lrpvWv6WnOWRAQz6d3jC5/b/mitwSnBKSEKKg0r0n5OrAZmNMPUl+CEdPg/u73mH
6dk/umngbSy6PjhdWlbvThO3z/KlMX6MOGjkZ0gC2j1pEQ50QpdzgoN4ZDvY/xVu
E8/DZjCfWha4svG5dQM=
=u7FW
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
