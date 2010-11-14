Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0KNIy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 03:54:28 -0500
Received: from ms01.sssup.it ([193.205.80.99]:57508 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754077Ab0KNIy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 03:54:27 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333814.8661.146.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1G7SeJT01wfgJf96bCdU"
Date: Sun, 14 Nov 2010 09:54:07 +0100
Message-ID: <1289724847.6632.33.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1G7SeJT01wfgJf96bCdU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> +static void task_fork_dl(struct task_struct *p)
> +{
> +	/*
> +	 * The child of a -deadline task will be SCHED_DEADLINE, but
> +	 * as a throttled task. This means the parent (or someone else)
> +	 * must call sched_setscheduler_ex() on it, or it won't even
> +	 * start.
> +	 */
> +	p->dl.dl_throttled =3D 1;
> +	p->dl.dl_new =3D 0;
> +}
> +
So, this is also something we only discussed once without reaching a
conclusive statement... Are we ok with this behaviour?

I'm not, actually, but I'm not sure how to do better, considering:
 - resetting task to SCHED_OTHER on fork is useless and confusing, since
   RESET_ON_FORK already exists and allows for this.
 - cloning the parent's bandwidth and try to see if it fits might be
   nice, but what if the check fails? fork fails as well? If yes, what
   should the parent do, lower its own bandwidth (since it's being
   cloned) and try forking again? If yes, lowering it by how much?=20
   Mmm... Not sure it would fly... :-(
 - splitting the bandwidth of the parent in two would make sense
   to me, but then it has to be returned at some point, or a poor
   -deadline shell will reach zero bandwidth after a few `ls'! So, when
   are we giving the bandwidth back to the parent? When the child dies?
   What if the child is sched_setscheduled_ex()-ed (either to -deadline=20
   or to something else), we return the bw back (if the call succeeds)
   as well?

I was thinking wither to force RESET_ON_FORK for SCHED_DEADLINE or to
try to pursue the 3rd solution (provided I figure out what to do on
detaching, parent dying, and such things... :-P).

Comments very very welcome!

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-1G7SeJT01wfgJf96bCdU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzfo6cACgkQk4XaBE3IOsQuUwCeIu12vMpZ5kOa1Tzm8KI7MqFZ
n5cAmgOAq9mhh/Y0NE69d/JBu51IN3KL
=iSGM
-----END PGP SIGNATURE-----

--=-1G7SeJT01wfgJf96bCdU--

