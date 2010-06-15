Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0FOPTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:19:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60684 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab0FOPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TNRUlD+70NSwi0CsFm20WC1E5kiUrnFDNsv6w5HatuFn/MAFE8UiIyiqjO8aeqil5+
         EiROVBLdV19SpagtQk0lTU4bQGs2fQ4/MlcpRPqDeIBjsZZlKPDnbs8LGt9sit4oNPCs
         /M/UM6jTSi9E/3raOUlUeNJikHJMpD7n+YJ+w=
Date: Tue, 15 Jun 2010 18:23:15 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid using smp_processor_id() in preemptible code
 (nr_iowait_cpu)
Message-ID: <20100615152315.GC3967@swordfish.minsk.epam.com>
References: <20100614140941.GA3581@swordfish.minsk.epam.com>
 <20100614073853.6fa2f91f@infradead.org>
 <20100614145439.GA3448@swordfish.minsk.epam.com>
 <20100614080154.7d6a71fc@infradead.org>
 <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
 <20100615061927.GA3312@swordfish>
 <20100615072435.5a47d850@infradead.org>
 <20100615145029.GB3967@swordfish.minsk.epam.com>
 <20100615080808.6286448b@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <20100615080808.6286448b@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/15/10 08:08), Arjan van de Ven wrote:
> On Tue, 15 Jun 2010 17:50:29 +0300
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> > >=20
> > > hmm this part is wrong
> > > you pick the current cpu, rather than the one denoted by ts.....
> > >=20
> >=20
> > Hmm. Thanks, good catch.=20
> > Well, there is something I'm missing. How can I match given *ts and
> > cpu in update_ts_time_stats (except for introducing
> > update_ts_time_stats(..., int cpu)) ?
>=20
>=20
> that'd be option one

We'll have problem in tick_nohz_start_idle(struct tick_sched *ts)
{
	ktime_t now;
	now =3D ktime_get();
	update_ts_time_stats(ts, now, NULL);

=2E..
So, we also will have to expand it to tick_nohz_start_idle(struct tick_sche=
d *ts, int cpu)

That's why I prefer option #2.

> option two is to add a "cpu" member to struct tick_sched.....
>=20
Thought about that. Seems ok to me.


> if you go for option one, I'd replace the ts argument with the cpu
> argument.....
>=20
>=20

Hmm, I missed this one (replacing *ts to int cpu). And I like it.=20
Something like:

-update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_=
time)
+update_ts_time_stats(int cpu, ktime_t now, u64 *last_update_time)
{
	ktime_t delta;
+	struct tick_sched *ts =3D &per_cpu(tick_cpu_sched, cpu);

	if (ts->idle_active) {
		int cpu =3D get_cpu();
		delta =3D ktime_sub(now, ts->idle_entrytime);
		ts->idle_sleeptime =3D ktime_add(ts->idle_sleeptime, delta);
		if (nr_iowait_cpu(cpu) > 0)
			ts->iowait_sleeptime =3D ktime_add(ts->iowait_sleeptime, delta);
		put_cpu();
		ts->idle_entrytime =3D now;
+		ts->idle_active =3D 0;
	}

	if (last_update_time)
		*last_update_time =3D ktime_to_us(now);

}


static void tick_nohz_stop_idle(int cpu, ktime_t now)
{
-	struct tick_sched *ts =3D &per_cpu(tick_cpu_sched, cpu);

	update_ts_time_stats(cpu, now, NULL);
-	ts->idle_active =3D 0;

	sched_clock_idle_wakeup_event(0);
}

and so on.


	Sergey

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwXmuMACgkQfKHnntdSXjRoqAP+LF/PUWkI6TtptWLhLNSz1PdC
YXAVd0zpz/IbOOf/OGHeRLeqMnEOfAyk3Y1KtIU4nI9YLBUzMrEyH1qtcYata5dx
EP9Tm4ozmOSkTVjcTMfI7VgRXAIHTN+ZKAto/Y70A6ySSxs5kJMZLjyD4VORGr5U
kl89Yk9TfAG0c6rp+X4=
=2w6o
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
