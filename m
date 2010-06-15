Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0FOOq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:46:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35404 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab0FOOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:46:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xnSzPpWcV6mDhfPsrGRZq/PeRjGhVdM9mC8edzccksXPdIpH5p9GtJrL5wYYV51zdc
         E5M0KUX8sCNZXxWHGa5eYuoA+M5Va72DLqHtDZXgjdWJojs86XdX63pmZjmh9RvWNEtG
         5zshGwuQkoixM/xVNXTMDkn102Ovl7Xw75Q0Y=
Date: Tue, 15 Jun 2010 17:50:29 +0300
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
Message-ID: <20100615145029.GB3967@swordfish.minsk.epam.com>
References: <1276461183.2659.4.camel@maxim-laptop>
 <201006140136.18652.rjw@sisk.pl>
 <20100614140941.GA3581@swordfish.minsk.epam.com>
 <20100614073853.6fa2f91f@infradead.org>
 <20100614145439.GA3448@swordfish.minsk.epam.com>
 <20100614080154.7d6a71fc@infradead.org>
 <20100614151735.GB3448@swordfish.minsk.epam.com>
 <20100614204021.52c50cdc@infradead.org>
 <20100615061927.GA3312@swordfish>
 <20100615072435.5a47d850@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20100615072435.5a47d850@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/15/10 07:24), Arjan van de Ven wrote:
> On Tue, 15 Jun 2010 09:19:27 +0300
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 1d7b9bc..101e8aa 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -159,10 +159,12 @@ update_ts_time_stats(struct tick_sched *ts,
> > ktime_t now, u64 *last_update_time) ktime_t delta;
> > =20
> >  	if (ts->idle_active) {
> > +		int cpu =3D get_cpu();
> >  		delta =3D ktime_sub(now, ts->idle_entrytime);
> >  		ts->idle_sleeptime =3D ktime_add(ts->idle_sleeptime,
> > delta);
> > -		if (nr_iowait_cpu() > 0)
> > +		if (nr_iowait_cpu(cpu) > 0)
> >  			ts->iowait_sleeptime =3D
> > ktime_add(ts->iowait_sleeptime, delta);
> > +		put_cpu();
> >  		ts->idle_entrytime =3D now;
> >  	}
>=20
>=20
> hmm this part is wrong
> you pick the current cpu, rather than the one denoted by ts.....
>=20

Hmm. Thanks, good catch.=20
Well, there is something I'm missing. How can I match given *ts and cpu=20
in update_ts_time_stats (except for introducing update_ts_time_stats(..., i=
nt cpu)) ?

> they will normally be the same, except for the case where you get your
> warning...
> (and this is also why you can't move the get_cpu() inside
> nr_iowait_cpu() ... )
>=20


	Sergey
--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwXkzUACgkQfKHnntdSXjTVXgQAp7RIxXQyxMYXjTf3FvDBCNkH
UuviNKWJxG5syb/+eXcTi5xE+jpvDcPpaH+Xea3YoammpSAV7OQXa/3cJRr3nzE8
+8APeBfIx5myqQeXXXVdNQ7pWwtT7c0PDJ+5Bx9AO9VT1/vktFhPjbGN9NjWtL8Y
SzZITuAL1RLg4UfHh/g=
=d5Vx
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
