Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1JQVT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:19:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab1JQVTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:19:55 -0400
Date: Tue, 18 Oct 2011 08:19:48 +1100
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative
 suspend/hibernate mode
Message-ID: <20111018081948.7f354fc6@notabene.brown>
In-Reply-To: <1318878529.3125.80.camel@work-vm>
References: <Pine.LNX.4.44L0.1110171417070.1749-100000@iolanthe.rowland.org>
	<1318878529.3125.80.camel@work-vm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3Sr=fveWrm45btdNzGE9blQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3Sr=fveWrm45btdNzGE9blQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 12:08:49 -0700 John Stultz <john.stultz@linaro.org> wro=
te:

> On Mon, 2011-10-17 at 14:19 -0400, Alan Stern wrote:
> > On Mon, 17 Oct 2011, John Stultz wrote:
> >=20
> > > So, the alarmtimer code is a bit more simple then what you describe
> > > above (alarmtimers are just like regular posix timers, only enable an
> > > RTC wakeup for the soonest event when the system goes into suspend).
> > >=20
> > > However, such a dual-timer style behavior seems like it could work for
> > > timer driven wakeups (and have been suggested to me by others as well=
).
> > > Just to reiterate my understanding so that we're sure we're on the sa=
me
> > > wavelength:
> > >=20
> > > For any timer-style wakeup event, you set another non-wakeup timer for
> > > some small period of time before the wakeup timer. Then when the
> > > non-wakeup timer fires, the application inhibits suspend and waits for
> > > the wakeup timer. =20
> > >=20
> > > Thus if the system is supended, the system will stay asleep until the
> > > wakeup event, where we'll hold off suspend for a timeout length so the
> > > task can run. If the system is not suspended, the early timer inhibits
> > > suspend to block the possible race.
> > >=20
> > > So yes, while not a very elegant solution in my mind (as its still ra=
cy
> > > like any timeout based solution), it would seem to be workable in
> > > practice, assuming wide error margins are used as the kernel does not
> > > guarantee that timers will fire at a specific time (only after the
> > > requested time).=20
> > >=20
> > > And this again assumes we'll see no timing issues as a result of syst=
em
> > > load or realtime task processing.
>=20
> > It shouldn't have to be this complicated.  If a program wants the
> > system to be awake at a certain target time, it sets a wakeup timer for
> > that time.  Then it vetoes any suspend requests that occur too close to=
=20
> > the target time, and continues to veto them until it has finished its=20
> > job.
>=20
> I agree that the dual-timer approach is not really a good solution, and
> doesn't help with similar races on non-timer based wakeups.
>=20
> Though I also think proposed userland implementations that require
> communication with all wakeup consumers before suspending (which really,
> once you get aggressive about suspending when you can, means
> communicating with all wakeup consumers on every wakeup event) isn't
> really a good solution either.

I would help me a lot if you could be more specific than "good".  Do you me=
an
"efficient" or "simple" or "secure" or ...

>=20
>=20
> Though as I've been thinking about it, there may be a way to do a
> userland solution that uses the wakeup_count that isn't so inefficient.
> Basically, its a varient of Mark's wakeup-device idea, but moved out to
> userland.

Here I see you probably meant "efficient".  Can that be quantified?  Do you
have a target latency for getting into suspend, and measurements that show
you regularly missing this target?
I am reminded of what Donald Knuth reportedly said about premature
optimisation.


>=20
> There is a userland PM daemon. Its responsible for both suspending the
> system, *and* handing all wakeup events.
>=20
> Normal wakeup consumers open wakeup devices with a special library which
> passes the open request through the PM daemon. The PM daemon opens the
> device and provides a pipe fd back to the application, and basically
> acts as a middle-man.

There is certainly merit in the idea but I think the pipes just get in the
way.

How about having both the PM daemon and the application listening on the sa=
me
FD.  The app sends the FD to the PM daemon on the same Unix domain socket
which is used to request suspend/resume handshaking.

The PM daemon never reads from the FD.  It only passes it to
poll/select/whatever.

When poll says  the FD is ready, the daemon initiated the handshake with the
app to make sure that it has consumed the event.  If none of the FDs are
ready for read and no process is blocking suspend, then the daemon is free =
to
enter suspend.


Of course if an App hasn't registered an FD, then it gets the handshake on
every suspend attempt.

NeilBrown


--Sig_/3Sr=fveWrm45btdNzGE9blQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpyb9Dnsnt1WYoG5AQLu0BAAuF8OBRE/2jqE+TnNuMX6mNrO1wYE3fzw
qV8LD5m9Tyh9MZj2E8Vq388hpq5QmqAHauhycxN+TO1GzkHHA0aUu++TRgMfkzze
1ls50157Vzld+n1H/dw2U44IOmNtK7Qywdw9+BPY5IyPyzvWsoXJw5SJ35zEdY1o
bQvJZARQVue0da3fWcKgETT0O4SraTiKxPMgLra9Dd4ZY29KgzRB7hwQ4u24qnDp
AaCGYAYvq0Yo8oQq/f2U63XFp/amx01/KqsUwT4JySxMxTHIjYuTu8S8xR8m+aW2
X8NMTNFKNkouGMePsD09nC49SEr6K2BBc9AmveyzSvuVOPhakXODTrTD5x7lBZUz
oqYKiVPNHjtN8V7JSTX8OFjYRA04MvaKN9V321m42i8sp7mYV70Gy3adzqG9UyYU
BRUmQ9mL4+ZctWwI/XTegXtf3UfFFQGN24AizVqvIuSt8tWLr7XdbtD9s9Wz2ZFH
MtXJMf3wcb/2w6A7Z/MRLd54Y0btRvy5frZMfY9AzB6Udd7jor8PT94mJK97B0ci
tERCvB39Lpn76+FTdLnVzraMMdtrDwZAlhM2n8J+3doPw3isKGkW7TuwaA0AmYpC
UnTWUBsjzuICahkIburF0KKZ8L1nMngssckX+MATSuZ6/fgZgqkFJBuMSz/yOZU9
Q7C9il2yJDg=
=qao5
-----END PGP SIGNATURE-----

--Sig_/3Sr=fveWrm45btdNzGE9blQ--
