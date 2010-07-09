Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab0GIOio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:38:44 -0400
Received: from ms01.sssup.it ([193.205.80.99]:33172 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754957Ab0GIOin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:38:43 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2010 10:38:43 EDT
Subject: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FWQt0KtWZgDWo11QSmb7"
Date: Fri, 09 Jul 2010 15:38:27 +0200
Message-ID: <1278682707.6083.227.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FWQt0KtWZgDWo11QSmb7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

So, talking to Peter and Thomas at the OSPERT workshop in Brussels [1],
the so called "sporaidic task model" came out many many times! Such
model comprises three parameters: wcet (or better budget or better
runtime :-D), deadline and period, where obviously deadline and period
could be different. However, SCHED_DEADLINE, since now, is using just
deadline, assuming that period is always equal to it.

Now, Peter said something about starting using period as well, but we
didn't have the time to discuss about that. Ironically, I got just a
couple of days before _the_same_ feature request by Harald from Ericsson
(in Cc), asking the very same thing.
So, this mail is to try to find a consensus (or just to gather your
opinions) on how to include this feature in the scheduler.

Since I'm about to release a new version, I would like, if possible, to
take these requests into account...

Here's the issue:
 - using periods for calculating the tasks' bandwidth and then using  =20
   deadlines for scheduling the tasks is going to work, but the
   admission control test that you would need for ensuring anybody
   will make its deadline is waaay more complex than Sum_i(BW_i)<1, even
   for uniprocessors/partitionig. That one instead would gives you just
   a very basic guarantee that the design in not completely broken
   (formally, I think I should say it is only a necessary
   condition :-)).

Therefore, here it is my proposal:
 - if the programmer specify both period and deadline, I act as above,
   running the _only_necessary_ test in the kernel, assuming that
   userspace performed some other kind of (correct!) admission test by
   its own, or that it is cool with missing some deadlines... What do
   you think?
 - do you think it could be useful to have a different syscall to deal
   with the period parameter (if it's different from deadline), e.g.,
   something useful to make the task periodic as you have (if I remember
   well) in Xenomai or RTAI?
   If you think it's worth doing that, do you think the
   task_wait_interval() syscall that we already added could/should do
   the job?

Basically, from the scheduling point of view, what it could happen is
that I'm still _NOT_ going to allow a task with runtime Q_i, deadline
D_i and period P_i to use more bandwidth than Q_i/P_i, I'm still using D
for scheduling but the passing of the simple in-kernel admission test
Sum_i(Q_i/P_i)<1 won't guarantee that the task will always finish its
jobs before D.

Please, if you find this interesting provide me with your comments,
otherwise, excuse me for bothering. :-)

Thanks and regards,
Dario

[1] http://www.artist-embedded.org/artist/Overview,1909.html

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-FWQt0KtWZgDWo11QSmb7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw3JlMACgkQk4XaBE3IOsSi3ACdHTqLACS+hlzVG7c6/AczWPn8
IYsAoKXyrDpQmQRJxA1qcx9Y+5XSaQSc
=lq6i
-----END PGP SIGNATURE-----

--=-FWQt0KtWZgDWo11QSmb7--

