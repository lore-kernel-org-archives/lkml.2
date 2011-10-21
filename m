Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1JUWen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 18:34:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1JUWel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 18:34:41 -0400
Date: Sat, 22 Oct 2011 09:34:36 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
Message-ID: <20111022093436.0742176c@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110211139420.2131-100000@iolanthe.rowland.org>
References: <20111021162340.669742c0@notabene.brown>
	<Pine.LNX.4.44L0.1110211139420.2131-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//Qw3NFX4RmdmmXT1E5N7q5A"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//Qw3NFX4RmdmmXT1E5N7q5A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 12:07:07 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Fri, 21 Oct 2011, NeilBrown wrote:
>=20
> > Hi,
> >=20
> > I wasn't going to do this... but then I did.  I think that sometimes co=
ding is
> > a bit like chocolate.
>=20
> Getting started is always a big hurdle, for me anyway.
>=20
> > At:
> >     git://neil.brown.name/lsusd
> > or
> >     http://neil.brown.name/git/lsusd
> >=20
> > you can find a bunch of proof-of-concept sample code that implements a
> > "Linux SUSpend Daemon" with client support library and test programs.
> >=20
> > I haven't actually tested it as root and had it actually suspend and re=
sume
> > and definitely haven't had it even close to a race condition, but the
> > various bits seem to work with each other properly when I run them under
> > strace and watch.
> >=20
> > It didn't turn out quite the way I imagined, but then cold harsh realit=
y has
> > a way of destroying our dreams, doesn't it :-)
> >=20
> >=20
> > Below is the README file.  Comment welcome as always.
> > I'm happy for patches too, but I'm equally happy for someone to re-writ=
e it
> > completely and make something really useful and maintainable.
> >=20
> > NeilBrown
> >=20
> > -----------------------------------------------------------------
> >=20
> > This directory contains a prototype proof-of-concept system
> > for managing suspend in Linux.
> > Thus the Linux SUSpend Daemon.
> >=20
> > It contains:
> >=20
> >  lsusd:
>=20
> This name is no good; it's too much like "lsusb".  In fact, anything=20
> starting with "ls" is going to be confusing.  Not that I have any=20
> better suggestions at the moment...
>=20
> >     The main daemon.  It is written to run a tight loop and blocks as
> >      required.  It obeys the wakeup_count protocol to get race-free
> >      suspend and allows clients to register to find out about
> >      suspend and to block it either briefly or longer term.
> >     It uses files in /var/run/suspend for all communication.
>=20
> I'm not so keen on using files for communication.  At best, they are
> rather awkward for two-way messaging.  If you really want to use them,
> then at least put them on a non-backed filesystem, like something under
> /dev.

Isn't /var/run a tmpfs filesystem?  It should be.
Surely /run is, so in the new world order the files should probably go
there.   But that is just a detail.

I like files...  I particularly like 'flock' to block suspend.   The
rest.... whatever..
With files, you only need a context switch when there is real communication.
With sockets, every message sent must be read so there will be a context
switch.

Maybe we could do something with futexes...

>=20
> >     File are:
> >=20
> >       disabled:  This file always exists.  If any process holds a
> >         shared flock(), suspend will not happen.
> >       immediate:  If this file exists, lsusd will try to suspend whenev=
er
> >         possible.
> >       request:  If this is created, then lsusd will try to suspend
> >         once, and will remove the file when suspend completes or aborts.
> >       watching:  This is normally empty.  Any process wanting to know
> >         about suspend should take a shared flock and check the file is
> >         still empty, and should watch for modification.
> >         When suspend is imminent, lsusd creates 'watching-next', writes
> >          a byte to 'watching' and waits for an exclusive lock on 'watch=
ing'.
> >         Clients should move their lock to 'watching-next' when ready for
> >         suspend.
> >         When suspend completes, another byte (or 2) is written to
> >         'watching', and 'watching-next' is renamed over it.  Clients can
> >         use either of these to know that resume has happened.
> >=20
> >       watching-next: The file that will be 'watching' in the next awake=
 cycle.
> >=20
> >     lsusd does not try to be event-loop based because:
> >       - /sys/power/wakeup_count is not pollable.  This could probably be
> >         'fixed' but I want code to work with today's kernel.  It will p=
robably
>=20
> Why does this matter?

In my mind an event based program should never block.  Every action should =
be
non-blocking and only taken when 'poll' says it can.
Reading /sys/power/wakeup_count can be read non-blocking, but you cannot fi=
nd
out when it is sensible to try to read it again.  So it doesn't fit.

>=20
> >         only block 100msec at most, but that might be too long???
>=20
> Too long for what?

For some other process to connect to some socket and have to wait for the
connection to be accepted.
(When reading from wakeup_count in the current code it will block for a
multiple of 100ms.  The multiplier might be 0 or 1, possibly more, though
that is unlikely).

>=20
> >       - I cannot get an event notification when a lock is removed from a
> >         file. :-(  And I think locks are an excellent light-weight
> >         mechanism for blocking suspend.
>=20
> Except for this one drawback.  Socket connections are superior in that=20
> regard.

I'm very happy for someone else write an all-socket based daemon.
Or just use my two deamons together.



>=20
> >   lsused:
> >       This is an event-loop based daemon that can therefore easily hand=
le
> >       socket connections and client protocols which need prompt
> >       response.  It communicates with lsusd and provides extra
> >       services to client.
> >=20
> >       lsused (which needs a better name) listens on the socket
> >             /var/run/suspend/registration
> >       A client may connect and send a list of file descriptors.
>=20
> Including an empty list?

With current code an empty list will mean no callback ever so it would be
pointless.
It is probably this interfaces could be improved.  I just wanted something
that worked.

>=20
> >       When a suspend is immanent, if any file descriptor is readable,
>=20
> Or if no file descriptors were sent?

Not with current code, but that does fit the design we discussed previously.

>=20
> >       lsused will send a 'S' message to the client and await an 'R' rep=
ly
> >       (S =3D=3D suspend, R =3D=3D ready).  When all replies are in, lsu=
sed will
> >       allow the suspend to complete.  When it does (or aborts), it will=
 send
> >       'A' (awake) to those clients to which it sent 'S'.
>=20
> But not to the client which failed to send an 'R'?

Every client must send an R before suspend can continue.  I don't currently
have an special handling for clients that misbehave.  I'm not even certain
that I correctly hand the case where the client dies and the socket closes.


>=20
> >       This allows a client to get a chance to handle any wakeup events,
> >       but not to be woken unnecessarily on every suspend.
>=20
> In practice, it may be best for clients that handle a large number of=20
> wakeup events to avoid using the fd mechanism.  Clients that handle=20
> only occasional wakeups may be better off using it.
>=20
> You left out an important element: A client must be allowed to send
> 'A' at any time, indicating that it does not want to suspend now.  Of=20
> course, this will work reliably only if the client uses the fd=20
> mechanism.

I did leave that out because client can always use "suspend_block()" to get=
 a
lock on the lockfile which will block suspend.
But I have no objections to it going in.


>=20
> I'm not sure it's such a good idea to separate this from the main=20
> daemon.  A crucial point of the protocol is that the daemon reads=20
> /sys/power/wakeup_count before sending all the 'S' messages, and waits=20
> for all the 'R' replies before writing wakeup_count.  The two-program=20
> approach would make this difficult.

I think it already works correctly with the two programs so it doesn't seem
that difficult.
The second daemon is a client to the first, and a server to other clients.
It is a multiplexer if you like - talking one (file-based) protocol to the
central server and another (socket-based) protocol to an arbitrary number of
clients.


>=20
> >    wakealarmd:
> >       This allows clients to register on the socket.
> >              /var/run/suspend/wakealarm
> >       They write a timestamp in seconds since epoch, and will receive
> >       a 'Now' message when that time arrives.
> >       Between the time the connection is made and the time a "seconds"
> >       number is written, suspend will be blocked.
> >       Also between the time that "Now" is sent and when the socket is
> >       closed, suspend is also blocked.
>=20
> In theory, this could be integrated with the previous program.

True.  Keeping it separate just reduced my cognitive load during developmen=
t,
and provided more sample code of what a client would look like.

I'm not even sure it is entirely race-free.  It uses a 2-second margin to
ensure there is no race between suspending and the alarm-clock wakeup, but =
it
isn't really close enough to the suspend call to be certain that any
particular amount of time is enough.
Unless we get a counted wakeup_source for the RTC alarm, the RTC handling
will really need to be in the main daemon immediately before the write to
'state'.

Thanks for your review.

My original plan was to have a single daemon with a main loop and a bunch of
loadable modules that provided different protocols to clients: simple-socke=
t,
file-based, dbus, "suspend.d" script directory etc.   That might still be f=
un
but it won't be a priority for a while.

NeilBrown

--Sig_//Qw3NFX4RmdmmXT1E5N7q5A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqHzfDnsnt1WYoG5AQKEkxAAuGnFaYMaqOINjnrKnRgrYhFy5oyZgrFZ
D1c8/cj5DocNLUmtGXT1jHbN9jyxev9EcsRZ/Dj4kYLLnvh2wlUz0FoX/8Y40ejC
M7Kbdc7ogH5/ZKSvh4ZobV60rSUN7sMxpGZ0WA9mVnK9zGUQMbuIefARcQPvpfZS
f5DHlxncD4mSEN3fpxae0rsufsopdtTIzkBwgcDqybs8qlcBLMZ0f6hJtLDU/Rg5
CK9a4WcEbAlvZ8Q7OwQ4tC+hVUYGG/NB0iQqFIQDs27sIOvNa4pDOSb7U01cF4HI
csOMiiZ53ZzqTh053CONvMn2tDLgCyFXFQsv+ym5JoPF/1D8eAQQ6olnSuYeHmIH
mJ5gHcNY0g4OXXwc3NmEUM7vapQA+lfIEG+V/THTO4jprQGvc6971n5XUp20LMzc
yB+Fhn+3Ioe2GSFOvTrEMwOExTP3O/+adTp2Q6sUaS0f/DZV3v1OjLTSms+tWf82
sbuYK8apV/VbvPvRtp7EKjy5bhpMHbD1+fYeEhQjFIBJu6/FnlWCOZc4F0umnfeC
zkYHZQdiPDI1n1SkmFUl/ULm/250N/aaiT8BlDkXVSIUMfwi5oKgOl8ryaMBjSQF
SAj9KPO1xxgm5nhuHu47zx0uLKLoD0DkNrysOPbgncH2R7oBVIqSvyqdhwdmwnXv
VS3aeEEV2Ao=
=CbjX
-----END PGP SIGNATURE-----

--Sig_//Qw3NFX4RmdmmXT1E5N7q5A--
