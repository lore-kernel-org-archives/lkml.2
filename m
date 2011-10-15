Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1JOWM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:12:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab1JOWM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:12:27 -0400
Date: Sun, 16 Oct 2011 09:12:10 +1100
From: NeilBrown <neilb@suse.de>
To: markgross@thegnar.org
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111016091210.5fea2bab@notabene.brown>
In-Reply-To: <20111015140537.GA19162@mgross-G62>
References: <20111002164456.GC14312@mgross-G62>
	<20111008221439.48f30263@notabene.brown>
	<20111008181638.GA12672@mgross-G62>
	<20111009093100.6c15be50@notabene.brown>
	<20111013034805.GC893@mgross-G62>
	<20111013163526.3863be01@notabene.brown>
	<20111014140116.GC27295@mgross-G62>
	<20111015140537.GA19162@mgross-G62>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PCUZ2DZsLvLcwSe1_uHmUES"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PCUZ2DZsLvLcwSe1_uHmUES
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 15 Oct 2011 07:05:37 -0700 mark gross <markgross@thegnar.org> wrote:

> On Fri, Oct 14, 2011 at 07:01:16AM -0700, mark gross wrote:
> > On Thu, Oct 13, 2011 at 04:35:26PM +1100, NeilBrown wrote:
> > > On Wed, 12 Oct 2011 20:48:05 -0700 mark gross <markgross@thegnar.org>=
 wrote:
> > >
>=20
> snip
>=20
> > > Can you describe a race?
> > > Here is the sequence as I see it.
> > >=20
> > > 0: some user-space process is blocking suspend by telling the suspend=
 daemon
> > >    not to suspend.  There are no pending kernel wakeup events.
> > >    All processes that handle wakeup events are registered with the da=
emon.
> > > 1: last blocking user-space  process releases its "don't suspend" loc=
k.
> > > 2: suspend-daemon decides to initiate suspend.
> > > 3: suspend_daemon reads wakeup_count and remembers number.
> > > 4: suspend daemon tells all registered clients that suspend is immine=
nt.
> > > 5: each client executes 'poll' or 'select' or whatever and discovers =
that
> > >    there are no events.
> > > 6: each client tells daemon that it is OK to suspend
> > > 7: when all votes are in, suspend daemon checks that no process is re=
questing
> > >    that suspend be blocked.
> > > 8: if that succeeds, suspend daemon writes the number back to wakeup_=
count
> > > 9: if that succeeds, suspend daemon daemon writes 'mem' to 'state'.
> > > 10: goto 1
> > >=20
> > > If a wake_event happens after 3 and before 8, the write at 8 will fai=
l.
> > > If a wake_event happens after 8, and before 9, the suspend will abort.
> > > If a wake_event happens after 9, the suspend will resume
> > > If a wake_event happens before 3, one of the processes will get an ev=
ent
> > > notification from select or poll or whatever, and will ask the suspend
> > > daemon not to suspend just now and this will be noticed at 7, so 8 an=
d 9
> > > will be skipped and we go straight to 10.
> > >=20
> > > No race.
> >=20
> > With the suspend daemon designed as above I see no race either.  I was
> > thinking of a more trivial suspend daemon design and trying to fix it up
> > in the kernel.
> >
>=20
> After responding to this yesterday I still feel I'm missing something
> with respect to wake event acknowledgment.  After a wake source becomes
> active how does it know its ok to become deactivate at the driver level?
>=20
> The race I'm now worried about is say a button press going up through
> the event layers.  The event manager process, or X, (registered with the
> suspend daemon) is in a race to get the event and the socket based
> notification handshake described above.
>=20
> i.e. how is the key event delivery vrs unblocking of the suspend-daemon
> read of wakeup_count in step 3 race dealt with?
>=20
> Sorry for getting confused and flip flopping on you.  This is pretty
> subtle stuff for me.
>

Not a problem.   I'll see if I can help.

For button presses, the wakeup_source needs to remain active only until
input_event() has been called on the event and the EV_SYN/SYN_REPORT event.
Then it can relax.

input_event will have called input_handle_event -> input_pass_event.
Depending on exactly which fds are open, this might have called
  evdev_event -> evdev_pass_event
which actually places the event in client->buffer.
Then evdev_event will wake up evdev->wait which will alert 'poll' etc.

So if the button press starts before the read request, then by the time the
read completes, the input event will have been queued and any process with =
an
appropriate file descriptor open will be able to see the event (e.g select
will return, read on a non-blocking fd will return an event rather than
EAGAIN).   The process will actually do a select or a read or
whatever because at step 4 the daemon will tell it to.   When it sees the
event it will probably request that suspend be blocked for the moment, so
when the daemon gets to step 7 it will decide to skip the rest of the suspe=
nd
sequence and go back to 0.

If the button press starts after the read of wakeup_count, the process might
not see the event, but the wakeup_count protocol will ensure we go around t=
he
loop again.

NeilBrown

--Sig_/PCUZ2DZsLvLcwSe1_uHmUES
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpoFOjnsnt1WYoG5AQJRWRAAlAil3cZcFK5Cs7LlBZedJdHDtaRy1MyM
dQXsAXMXpEW9Hk/ZiwnUnRTYupCmHDoM2pqkau8B0q1vpdjh3uqiCJ0wIRNDqW4D
3n4W7f5vDnXT+Ab/ydUBOH5ZFniwgkd0EfoxQumLc5/s0NHI7nvru6utHPoWsRg7
gXPJEAxpOG3exEaLeO673Yx5UsEcFyeVavTTm72aLy5UPx5JfZHHQ06/4VGypK1H
rbvXtX1oeUdfBurRQm4H/bLykUuWMTRYN44dUEDGKQQ4XV3X7vbCrrGzusFcXEuT
3J4/hebSeXlsXP+wj1ut8aEztZU3GNXV+80N+8CUcVrtDSESrSqPtZ12eAkRdV5R
TZtCYUZQccwgOgzVY6ybQQKBXXqBJT1UTyeKok/Snhv6kDpTEoUaIiFw72HHbK1g
xSijjwMoCazsr3gvszSLkZ6g6Y/Lim6Z8Tbqr+Oka/YvUTS/RAMM+osGMrWs0i5D
QbrNftVhva4tFayVAqsCyhvxUeHpKaDbbaPt3sYXnk4pJt/HX90wV/jA0UJsufNw
JsnXtHFCtyGbqByZiy+K7T81R+GDc4tbmzAIwuEjO26t+zQbUSUgckMFiLyKL4i7
Qu8AA3HEah20p+YM0soa365aoJVIKw860DMkkK3RC/g4gjUqwTuRBcCevGSuGRrn
3aB2Sp0ixN8=
=SuGm
-----END PGP SIGNATURE-----

--Sig_/PCUZ2DZsLvLcwSe1_uHmUES--
