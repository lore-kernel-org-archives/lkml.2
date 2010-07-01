Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0GAIOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:14:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61728 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0GAIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YhtepkdDQyca7mFLe9Pun5tgvTWntrWPkqu6yc4XLDc35g9kUoqhKbIJ0tHeJDDFJh
         kTI+KoYsiy4hI/UNiFXtd6yJiqIY/ZCYinU4Z4tzJgGlN+vnIbXuCo297ESR2r+wokpV
         H+yBIShI4aK6u/EOWxLfrjN7bqmzgzmz1u40k=
Date: Thu, 1 Jul 2010 11:18:25 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: Cure nr_iowait_cpu() users
Message-ID: <20100701081825.GA3982@swordfish.minsk.epam.com>
References: <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
 <20100615061927.GA3312@swordfish>
 <20100615072435.5a47d850@infradead.org>
 <20100615145029.GB3967@swordfish.minsk.epam.com>
 <20100615080808.6286448b@infradead.org>
 <20100617062950.GA3979@swordfish>
 <1277476773.32034.639.camel@twins>
 <20100630125853.245e6b99.akpm@linux-foundation.org>
 <1277968037.1868.120.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <1277968037.1868.120.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com> (??)

	Sergey


On (07/01/10 09:07), Peter Zijlstra wrote:
> Subject: [PATCH] sched: Cure nr_iowait_cpu() users
> X-Mailer: Evolution 2.28.3=20
>=20
> With 0224cf4c5e (sched: Intoduce get_cpu_iowait_time_us()) Arjan broke
> things by not making sure preemption was indeed disabled by the callers
> of nr_iowait_cpu() which took the iowait value of the current cpu.
>=20
> This resulted in a heap of preempt warnings. Cure this by making
> nr_iowait_cpu() take a cpu number and fix up the callers to pass in the
> right number.
>=20
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> Confirmed to work..
>=20
>  drivers/cpuidle/governors/menu.c |    4 ++--
>  include/linux/sched.h            |    2 +-
>  kernel/sched.c                   |    4 ++--
>  kernel/time/tick-sched.c         |   16 ++++++++--------
>  4 files changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors=
/menu.c
> index 52ff8aa..1b12870 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -143,7 +143,7 @@ static inline int which_bucket(unsigned int duration)
>  	 * This allows us to calculate
>  	 * E(duration)|iowait
>  	 */
> -	if (nr_iowait_cpu())
> +	if (nr_iowait_cpu(smp_processor_id()))
>  		bucket =3D BUCKETS/2;
> =20
>  	if (duration < 10)
> @@ -175,7 +175,7 @@ static inline int performance_multiplier(void)
>  	mult +=3D 2 * get_loadavg();
> =20
>  	/* for IO wait tasks (per cpu!) we add 5x each */
> -	mult +=3D 10 * nr_iowait_cpu();
> +	mult +=3D 10 * nr_iowait_cpu(smp_processor_id());
> =20
>  	return mult;
>  }
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a61c08c..1f25798 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -139,7 +139,7 @@ extern int nr_processes(void);
>  extern unsigned long nr_running(void);
>  extern unsigned long nr_uninterruptible(void);
>  extern unsigned long nr_iowait(void);
> -extern unsigned long nr_iowait_cpu(void);
> +extern unsigned long nr_iowait_cpu(int cpu);
>  extern unsigned long this_cpu_load(void);
> =20
> =20
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 71e3dc8..d3c0262 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2946,9 +2946,9 @@ unsigned long nr_iowait(void)
>  	return sum;
>  }
> =20
> -unsigned long nr_iowait_cpu(void)
> +unsigned long nr_iowait_cpu(int cpu)
>  {
> -	struct rq *this =3D this_rq();
> +	struct rq *this =3D cpu_rq(cpu);
>  	return atomic_read(&this->nr_iowait);
>  }
> =20
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index e0707ea..17525ca 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -154,14 +154,14 @@ static void tick_nohz_update_jiffies(ktime_t now)
>   * Updates the per cpu time idle statistics counters
>   */
>  static void
> -update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_updat=
e_time)
> +update_ts_time_stats(int cpu, struct tick_sched *ts, ktime_t now, u64 *l=
ast_update_time)
>  {
>  	ktime_t delta;
> =20
>  	if (ts->idle_active) {
>  		delta =3D ktime_sub(now, ts->idle_entrytime);
>  		ts->idle_sleeptime =3D ktime_add(ts->idle_sleeptime, delta);
> -		if (nr_iowait_cpu() > 0)
> +		if (nr_iowait_cpu(cpu) > 0)
>  			ts->iowait_sleeptime =3D ktime_add(ts->iowait_sleeptime, delta);
>  		ts->idle_entrytime =3D now;
>  	}
> @@ -175,19 +175,19 @@ static void tick_nohz_stop_idle(int cpu, ktime_t no=
w)
>  {
>  	struct tick_sched *ts =3D &per_cpu(tick_cpu_sched, cpu);
> =20
> -	update_ts_time_stats(ts, now, NULL);
> +	update_ts_time_stats(cpu, ts, now, NULL);
>  	ts->idle_active =3D 0;
> =20
>  	sched_clock_idle_wakeup_event(0);
>  }
> =20
> -static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
> +static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
>  {
>  	ktime_t now;
> =20
>  	now =3D ktime_get();
> =20
> -	update_ts_time_stats(ts, now, NULL);
> +	update_ts_time_stats(cpu, ts, now, NULL);
> =20
>  	ts->idle_entrytime =3D now;
>  	ts->idle_active =3D 1;
> @@ -216,7 +216,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_ti=
me)
>  	if (!tick_nohz_enabled)
>  		return -1;
> =20
> -	update_ts_time_stats(ts, ktime_get(), last_update_time);
> +	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
> =20
>  	return ktime_to_us(ts->idle_sleeptime);
>  }
> @@ -242,7 +242,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_=
time)
>  	if (!tick_nohz_enabled)
>  		return -1;
> =20
> -	update_ts_time_stats(ts, ktime_get(), last_update_time);
> +	update_ts_time_stats(cpu, ts, ktime_get(), last_update_time);
> =20
>  	return ktime_to_us(ts->iowait_sleeptime);
>  }
> @@ -284,7 +284,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	 */
>  	ts->inidle =3D 1;
> =20
> -	now =3D tick_nohz_start_idle(ts);
> +	now =3D tick_nohz_start_idle(cpu, ts);
> =20
>  	/*
>  	 * If this cpu is offline and it is the one which updates
>=20

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwsT1EACgkQfKHnntdSXjSLcgQA21C6/L2c7WCeZTAckLMwmKc0
AFy18Er4rqfSKTUy46S6dp7PA7NncmvsEcSGkfN5htkaiXe6EGQUsVqzHZb779GD
uavBk9LdAGZRFFXFjTaqWToXwd5E73JMgHNqPBqh+L/xmen/DnEakzd7ngZD6fY2
fX+UxnTvnulOaKTIN7s=
=bj1R
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
