Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231Ab0HEMQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:16:54 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:45309 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab0HEMQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:16:52 -0400
X-Spam-ASN: 
Date: Thu, 5 Aug 2010 16:16:37 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCHv3 13/16] pps: capture MONOTONIC_RAW timestamps as well
Message-ID: <20100805161637.373cf63b@desktopvm.lvknet>
In-Reply-To: <1280963037.2678.28.camel@localhost.localdomain>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<7e78eaffb92829465df0237fa7e4d1b183a1a511.1280952801.git.lasaine@lvk.cs.msu.su>
	<1280963037.2678.28.camel@localhost.localdomain>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/lJ/BN=iq/RbHmF+aroT/yDj"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lJ/BN=iq/RbHmF+aroT/yDj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 04 Aug 2010 16:03:57 -0700
john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, 2010-08-05 at 01:06 +0400, Alexander Gordeev wrote:
> > MONOTONIC_RAW clock timestamps are ideally suited for frequency
> > calculation and also fit well into the original NTP hardpps design. Now
> > phase and frequency can be adjusted separately: the former based on
> > REALTIME clock and the latter based on MONOTONIC_RAW clock.
> > A new function getnstime_raw_and_real is added to timekeeping subsystem
> > to capture both timestamps at the same time and atomically.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  include/linux/pps_kernel.h |    3 ++-
> >  include/linux/time.h       |    2 ++
> >  kernel/time/timekeeping.c  |   34 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 38 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> > index 5af0498..39fc712 100644
> > --- a/include/linux/pps_kernel.h
> > +++ b/include/linux/pps_kernel.h
> > @@ -48,6 +48,7 @@ struct pps_source_info {
> >  };
> >=20
> >  struct pps_event_time {
> > +	struct timespec ts_raw;
> >  	struct timespec ts_real;
> >  };
> >=20
> > @@ -111,7 +112,7 @@ static inline void timespec_to_pps_ktime(struct pps=
_ktime *kt,
> >=20
> >  static inline void pps_get_ts(struct pps_event_time *ts)
> >  {
> > -	getnstimeofday(&ts->ts_real);
> > +	getnstime_raw_and_real(&ts->ts_raw, &ts->ts_real);
> >  }
> >=20
> >  #endif /* LINUX_PPS_KERNEL_H */
> > diff --git a/include/linux/time.h b/include/linux/time.h
> > index ea3559f..1da8a7b 100644
> > --- a/include/linux/time.h
> > +++ b/include/linux/time.h
> > @@ -143,6 +143,8 @@ extern unsigned int alarm_setitimer(unsigned int se=
conds);
> >  extern int do_getitimer(int which, struct itimerval *value);
> >  extern void getnstimeofday(struct timespec *tv);
> >  extern void getrawmonotonic(struct timespec *ts);
> > +extern void getnstime_raw_and_real(struct timespec *ts_raw,
> > +		struct timespec *ts_real);
> >  extern void getboottime(struct timespec *ts);
> >  extern void monotonic_to_bootbased(struct timespec *ts);
> >=20
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index caf8d4d..ef37b14 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -286,6 +286,40 @@ void ktime_get_ts(struct timespec *ts)
> >  EXPORT_SYMBOL_GPL(ktime_get_ts);
> >=20
> >  /**
> > + * getnstime_raw_and_real - Returns both the time of day an raw
> > + * monotonic time in a timespec format
> > + * @ts_mono_raw:	pointer to the timespec to be set to raw
> > + *			monotonic time
> > + * @ts_real:		pointer to the timespec to be set to the time
> > + *			of day
> > + */
> > +void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *=
ts_real)
> > +{
> > +	unsigned long seq;
> > +	s64 nsecs_raw, nsecs_real;
> > +
> > +	WARN_ON(timekeeping_suspended);
> > +
> > +	do {
> > +		seq =3D read_seqbegin(&xtime_lock);
> > +
> > +		*ts_raw =3D raw_time;
> > +		*ts_real =3D xtime;
> > +
> > +		nsecs_raw =3D timekeeping_get_ns_raw();
> > +		nsecs_real =3D timekeeping_get_ns();
> > +
> > +		/* If arch requires, add in gettimeoffset() */
> > +		nsecs_real +=3D arch_gettimeoffset();
>=20
> Hmm. So this brings up an interesting point. If the system is an one
> which uses arch_gettimeoffset() (which means it doesn't have
> clocksources), I'm not sure if this function would return what you'd
> expect.
>=20
> The issue is that jiffies is the basic clocksource that is in use on
> these systems, but the arch_gettimeoffset() function returns an
> inter-tick time value (usually by reading the interrupt generating
> decrementer or whatnot). So in this case, you'd get a
> CLOCK_MONOTONIC_RAW time that is based off the raw jiffies value at the
> last tick, and CLOCK_REALTIME time value at the exact time of the call.
>=20
> That offset between the two would then vary depending on when in the
> inter-tick period the call was made.
>=20
>=20
> The two solutions would be:
> 1) Add the arch_gettimeoffset() value to nsecs_raw as well. Should be
> safe, as any freq variance from the raw freq will be limited to 1 tick
> length and won't accumulate.
>=20
> 2) Don't add arch_gettimeoffset to either value, providing the raw and
> real time values at the last tick.
>=20
> I'd probably go with #1.
>=20
> Otherwise, the code looks good.

Ok, thanks for the point! I'll use #1 then.

--=20
  Alexander

--Sig_/lJ/BN=iq/RbHmF+aroT/yDj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJMWqulAAoJEElrwznyooJbLJMIAJNduZx94GWVzVAZaJdll0x9
n6SEWxlKXdJodxwuL3P/lkbFC7HMheRysJjUTpD3+PTn8o84j9FVE1Q+NlSIgngk
+A1Y5UEvrYMS3rESaN6732jLuJgM6pwGya7NZIu/4y3RVUYYaFR3mnpeAuFbWoqN
2jlfjLcLC682EKOzmvnqHtK2TagMS7jvFYELxRDNrsHXPu/Qy5kAmbVZxgxYiJhI
3oOAHonIGYGom/tnX+mzS6pDNShKqlXTth9G55+BHCdN7eVNdbZsgSzr2olFhzOS
+9iPHZOPTBNyvZmFS1E2myDOosBbYHe4Tx+oJjBsS65dciqTo11m/Mkm01Bw1KQ=
=pjYv
-----END PGP SIGNATURE-----

--Sig_/lJ/BN=iq/RbHmF+aroT/yDj--
