Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1JRWzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 18:55:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1JRWzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 18:55:48 -0400
Date: Wed, 19 Oct 2011 09:55:40 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111019095540.1011993d@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110181135070.1697-100000@iolanthe.rowland.org>
References: <20111018131358.1c964c32@notabene.brown>
	<Pine.LNX.4.44L0.1110181135070.1697-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yUKGVup7eAiVyZS/VyyQWGO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yUKGVup7eAiVyZS/VyyQWGO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Oct 2011 13:11:05 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Tue, 18 Oct 2011, NeilBrown wrote:
>=20
> > On Mon, 17 Oct 2011 16:47:04 -0700 John Stultz <john.stultz@linaro.org>=
 wrote:
> >=20
> > > On Tue, 2011-10-18 at 09:49 +1100, NeilBrown wrote:
> > > > However for the bits that I feel I do understand, this is what I (c=
urrently)
> > > > think it should (or could) look like.
> > > >=20
> > > >=20
> > > > 1/ There is a suspend-management daemon that starts very early and =
is the only
> > > >    process that is allowed to initiate suspend or hibernate.  Any o=
ther
> > > >    process which tries to do this is a BUG.
> > > >=20
> > > > 2/ The daemon has two modes:
> > > >    A/ on-demand.  In this mode it will only enter suspend when requ=
ested to,
> > > >       and then only if there is nothing else blocking the suspend.
> > > >    B/ immediate.  In this mode it will enter suspend whenever nothi=
ng is
> > > >       blocking the suspend.  The daemon is free to add a small delay
> > > >       proportional to the resume latency if so configured.
> > > >    The daemon is in on-demand mode at start up.
>=20
> A minor point...  This distinction may not truly be necessary. =20
> On-demand mode is pretty much the same as immediate mode with an
> implicit client that is almost never ready to suspend.

"pretty much" but not "exactly".   The implicit client would need to be rea=
dy
for suspend when a "please suspend now" request arrived.
So maybe the "please suspend now" would get sent to the implicit client.
And the mode-change would tell the implicit client to stop blocking suspend.
Which makes the implicit client indistinguishable from an internal mode.

The on-demand mode is both for "legacy" situations and for start-up.
The daemon would be in on-demand mode and only enter immediate mode when so=
me
program detected that "boot" had completed and any process that might want =
to
block suspend was doing so.  Then it would allow auto-suspend to start.

>=20
> That business about "only if nothing else is blocking the suspend" in=20
> on-demand mode is troubling.  What happens if something else _is_=20
> blocking the suspend?  Will the GNOME power manager go into a tight=20
> loop, asking over and over for suspends that all fail?

I doubt it.  You can quite easily create situations where suspend will fail.
I think having an NFS mount can do it - certainly an NFS mount to a dead
server. (I think this might be fixed in the near future).
If g-p-m spun on that, someone would have noticed.  I suspect that it resets
the idle timer when it attempts suspend - whether it succeeds or not.

>=20
> > > > 3/ The daemon can handle 5 sorts of interactions with clients.
> > > >=20
> > > >    i/ Change mode - a request to switch between on-demand and immed=
iate mode.
>=20
> May or may not be needed, depending on what we decide about these=20
> modes.
>=20
> > > >   ii/ suspend now - a request to suspend which is only honoured if =
no client
> > > >       has blocked suspend, and if the kernel is not blocking suspen=
d.
> > > >       Thus it is meaningless in immediate mode.
> > > >  iii/ be-awake-after - this request carries a timestamp and is stat=
eful - it
> > > >       must be explicitly cancelled.  It requests that the system be=
 fully
> > > >       active from that time onwards.
> > >=20
> > > This initially wasn't super clear to me why this is necessary. I see
> > > below it is trying to handle the non-fd timer method to keeping the
> > > system awake.
> > >=20
> > > Although does this also duplex as the  suspend-inhibit/suspend-allow
> > > call made by applications? Or was that interaction just skipped here?
> >=20
> > Yes, exactly.  This is primarily allowing an application to stay "inhib=
it
> > suspend" (aka "be awake").  Being able to make the request for a future=
 time
> > seemed a natural and simple extension.
> > If you can do timer wakeups like other wakeups and find it easier that =
way,
> > then we can leave the timestamp out of it.
>=20
> There's another way to implement "inhibit suspend" -- via the notify=20
> mechanism.  If the client doesn't respond to a callback, the server=20
> won't suspend.  Hence if people use the fd-timer approach,=20
> be-awake-after isn't needed.

I don't like that approach though.  It leaves the daemon thinking "we are on
the way towards suspend" and that is what it tells other clients.  But real=
ly
we are in state "someone doesn't want us to suspend now".
So some clients are assuming suspend is imminent and are waiting expectantly
for it to be over, but in reality the system is staying awake and only one
client knows about it.

>=20
> On the other hand, the notify-fd mechanism _does_ need a "stay awake"
> call (it could be something as simple as a 'W' message in the
> protocol).  Without it, you run the risk that the client might read the
> fd data before the server sees it.  The server would think the client
> was idle while it was busily processing the data.

Yep.

>=20
> > > >   iv/ notify - this establishes a 'session' between client and serv=
er.
> > > >       Server will call-back and await respond before entering suspe=
nd and
> > > >       again after resuming (no response needed for resume).
> > > >       The client is explicitly permitted to make a be-awake-after r=
equest
> > > >       during the suspend call-back.
> > >=20
> > > With the notify-fd example included below, I'm curious what specific =
use
> > > cases you see as requiring the notify interaction?=20
> >=20
> > None specifically.  However while I'm convinced that all events must be
> > visible to user-space I am not convinced that they will be visible to a
> > poll.  You might occasionally require a read on a sysfs file, and then =
parse
> > the contents to see if the event happened.
> > We can do poll on sysfs files now so that can probably be avoided.
> > But I didn't want to close doors before I was sure no-one needed them.
>=20
> Agreed; a non-poll arrangement should not be ruled out.
>=20
> > And I think that with notify-fd you still need a hand-shake of some sor=
t, and
> > this provides a simple starting point.
> >=20
> > >=20
> > > >    v/ notify-fd.  This is a special form of 'notify' which carries =
a file
> > > >       descriptor.  The server is not required to (and not expected =
to)
> > > >       initiate the 'suspend' callback unless the fd is reporting PO=
LL_IN or
> > > >       POLL_ERR while preparing for suspend.
> > >=20
> > > I'd think it would be "the server is not allowed to" instead of "not
> > > required to".
>=20
> That doesn't make sense.  The fd state could change between the time=20
> the server checks it and the time the suspend callback is sent.
>=20
> > Maybe.  When specifying a protocol I am cautious of excluding things th=
at are
> > merely inconvenient.  So "should not" but not "shall not" in rfc-speak.
> > However it might be easier on the client if it knew there would never b=
e a
> > call-back so it might be best to make it "shall now".
>=20
> I'm not convinced that notify-fd is a good idea.  Compare the messages=20
> needed for notify vs. notify-fd:
>=20
> 	notify: The server queries clients and needs to receive a=20
> 		response before each suspend.
>=20
> 	notify-fd: The server queries clients only when it knows they
> 		are likely to be busy, and the clients must notify the
> 		server every time they get a wakeup event.
>=20
> It's not immediately obvious which involves more back-and-forth
> messaging.  But then consider when those messages occur:
>=20
> 	With notify, clients send and receive messages only when they=20
> 	are idle.
>=20
> 	With notify-fd, clients have to send a message before starting
> 	to process each wakeup event.
>=20
> Sending more messages when you are idle seems better than sending fewer
> when you have work to do.

I hadn't looked at it like that, but I think you have a valid point.
Of course prototyping an measuring is what we really need. :-)

>=20
> > > > 4/ The daemon manages the RTC alarm.  Any other process programing =
the alarm
> > > >    is a BUG.  Before entering suspend it will program the RTC to wa=
ke the
> > > >    system at (or slightly before) the time of the earliest active
> > > >    be-awake-after request.
> > >=20
> > > So, this may need to be revised. My RTC virtualization and alarmtimer
> > > rework gives us a lot more flexibility with RTC events. Given the arr=
ay
> > > of existing applications that use the RTC chardev, I think its not
> > > realistic to consider it a bug if someone else is using it.=20
> >=20
> > If multiple applications think they can independently "own" the RTC ala=
rm
> > then that sounds like it is already a bug quite apart from anything I a=
dd.
> >=20
> > We must have some way to virtualise the rtc-alarm so that any app can b=
e sure
> > there will we be a wakeup at-or-before some time.  I suggested doing th=
at via
> > the suspend daemon.  If there is a strong case for a more general
> > kernel-based virtualisation of the RTC alarm in the kernel - then maybe=
 that
> > is OK.
> >=20
> > >=20
> > > That said, the posix alarmtimer interface allows us to trigger wakeup
> > > events in the future, without disrupting the legacy chardev programmi=
ng
> > > (this is possible because the kernel now virtualizes the chardev).
> > >=20
> > > I'd probably rather add alarmtimer functionality to the timerfd, in
> > > order to allow the notify-fd method to work with timers. But its not a
> > > huge deal. I'd just like to avoid reimplementing a timer dispatch sys=
tem
> > > in userland.
> >=20
> > Yep.  Exactly which solution gets implemented isn't important as long a=
s it
> > is clean and well defined.
>=20
> Agreed.
>=20
> > > > 5/ Possible implementation approaches for the client interactions:
> > > >    I/ A SOCK_STREAM unix domain socket which takes commands.
> > > >      On connect, server says "+READY".
> > > >      Client writes "MODE ON-DEMAND" or "MODE IMMEDIATE"
> > > >      Server replies "+MODE $MODE"
> > > >=20
> > > >   II/ The same unix domain socket as I.=20
> > > >      Client writes "SUSPEND"
> > > >      Server replies "+RESUMED" if the suspend happened, or
> > > >                     "-BUSY"  if it didn't.
> > > >      +RESUMED is no guarantee that an measurable time was in suspen=
d, so
> > > >      maybe it isn't needed.
>=20
> I like the single-letter messages better than complete words.  Not a=20
> big deal either way...
>=20
> > > >  III/ A separate Unix domain socket.
> > > >      On connect, server says "Awake" meaning that this connection i=
s ensuring
> > > >      the system will be awake now.
> > > >      Client can write a seconds-since-epoch number, which the serve=
r will echo
> > > >      back when confirmed.  When that time arrives - which might be =
immediately
> > > >      - the server will write "Awake" again.
> > > >      When the client closes the connection, the suspend-block is re=
moved.
> > >=20
> > > What is the seconds-since-epoch bit for?=20
> >=20
> > That is the time when the server will ensure the system is awake from. =
 i.e.
> > the wakeup timer.  If it is in the past, it means "be awake now".
> >=20
> >=20
> > >=20
> > > >   IV/ A third Unix domain socket.
> > > >      On connect, server writes a single character 'A' meaning 'syst=
em is
> > > >      awake'.
> > > >      When initiating suspend, server writes 'S' meaning 'suspend so=
on'.
> > > >      Client must reply to each 'S' with 'R' meaning 'ready'.  Serve=
r does not
> > > >      enter resume until the 'R' is received.
> > > >      On resume, server will write 'A' meaning 'awake' again.  Many =
clients
> > > >      might ignore this.
> > >=20
> > > Again, still not sure about this bit, but how do you handle aborted
> > > suspends? If you have one blocked task that takes a really long time =
to
> > > respond, what happens if you've had multiple attempts to suspend that
> > > have aborted? Just want to make sure you don't end up getting an late
> > > ack for an old suspend attempt (although I'm not really sure if that
> > > matters).
> >=20
> > The server just needs to ensure that on every connection that it sends =
an 'S',
> > it waits for an 'R', and subsequently sends an 'A'.
>=20
> It shouldn't send the 'A' unless the client asked it to.
>=20

That sounds like a valid optimisation.


> > Whether a suspend actually happens between the R and the A, or whether =
it was
> > aborted, is irrelevant.
> > After a suspend, whether aborted or not, the server must send 'A' to all
> > clients that it sent 'S' to.
>=20
> No -- only to clients that responded with 'R' and that asked for the
> 'A'.  If 'S' was sent to a client, the server must not send anything
> more to that client until an 'R' is received.
>=20
> >  Then it must sent S and wait for R before
> > trying to suspend again.
> >=20
> > So a client that has been blocked for a while might see an 'A' and an '=
S' but
> > that is all.  If it blocked for too long and the server was allowed to =
reject
> > it, it might see a closed connection.
> > There should be no confusion.
>=20
> Is there any reason for the server ever to close a connection, other
> than perhaps insufficient access rights?

I was wondering if the server might want to impose a (largeish) maximum del=
ay
that it will wait for an 'R'.  If it didn't get one in time it would respond
by closing the connection.
That probably isn't really necessary - hard to know without experience.


>=20
> > > >    V/ Same socket as IV, with extra message from client to server.
> > > >      Client writes 'M' (monitor) in a message with SCM_RIGHTS conta=
ining one
> > > >      or more fds.  Server will now only send 'S' when one or more o=
f those fds
> > > >      are readable, but the client cannot rely on that and must (as =
always)
> > > >      not assume that a read will succeed, or will not block.
> > >=20
> > > Err. Not following this. If this is the notify-fd bit, I'd expect the
> > > client to provide the fds, and then that's it. Then the server will
> > > check those fds before trying to suspend, and if any have data, it wi=
ll
> > > wait until that data is read. Why does the server send an S in this o=
ne?
> > > Doesn't the task also see that there is data there?
> >=20
> > As I said in another email "wait until data has been read" is not an
> > operation that Linux supports directly.
> > The server sends the S so that it can then wait for the R.
>=20
> Right.  Besides, "wait until data has been read" is the wrong thing to=20
> do.  The client needs time to process the data after reading it.
>=20
> > But maybe it can wait for a separate "stay awake" request - that can be=
 in
> > v0.2 of the protocol.
>=20
> The client has to send a "stay awake" request to avoid races.  It=20
> should be sufficient for the server to wait until it gets either that=20
> or the 'R'.
>=20
> > > > 6/ The daemon may impose access control on be-awake messages.  In t=
he above
> > > >    protocol it could be based on SCM_CREDENTIAL messages which migh=
t be
> > > >    required.
> > > >    It may also impose timeout on the 'R' reply from the 'S' request=
, or at
> > > >    least log clients which do not reply promptly.
> > >=20
> > > This again feels more complex then necessary, but I'll leave it be for
> > > now.
>=20
> We would be better off requiring proper access control at the start of
> each connection.  Random processes should not be able to prevent the=20
> system from suspending.
>=20
> > > > 7/ A client should not delay at all in replying to 'suspend
> > > >    soon' (S) with 'ready' (R).  It should only check if there is an=
ything to
> > > >    do and should make a stay_awake request if there is something.  =
Then it
> > > >    must reply with 'R'.
> > > >    I should *not* use the fact that suspend is waiting for its repl=
y to
> > > >    respond to an event as this misleads other clients as to the tru=
e state of
> > > >    the system.
> > >=20
> > > Again, while I'm not sure about the notify method, this interleaving
> > > seems right to me.=20
> > >=20
> > > > 8/ I haven't treated hibernate here.  My feeling is that it would b=
e a
> > > >    different configuration for the daemon.
> > > >    If hibernate were possible and the soonest stay-awake time were =
longer
> > > >    than X in the future, then the daemon might configure the RTCala=
rm for X,
> > > >    and when that arrives, it pops out of suspend and goes into hibe=
rnate.
> > > >    But the details can wait for revision 2 of the spec..
> > >=20
> > > I'm not sure if hibernate is different in my mind, other then it taki=
ng
> > > much longer. It just seems like it would be a subtlety of the type of
> > > "suspend-now" request made to the PM daemon.
>=20
> That's my feeling too.
>=20
> Alan Stern

Thanks,
NeilBrown


--Sig_/yUKGVup7eAiVyZS/VyyQWGO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp4D7Dnsnt1WYoG5AQID8g//fZI3arf88Q1xeKJ4vU4RNlpZItBw/XN6
WPK8iwdu2clcuBDrAm2GEd5t7l2veHI5TyNnCPrw/9xHNW5e2qojg8E3oCPikYEQ
zmsvVQ2xsx5xDOL/29RmGpG3XtlTYJV38PQbkTBtFOTPHEa0hwpp2TNKhj6kohB7
r+X9rK8j3ogIgAfqosOTF3p2FPxtx21wizfpf/aCrEv8HmKbtKruHxV54DHrwpA0
6Wfrzbdwax4wjsKrG1nriu6pUUIC8JXQq7IrgrPXfanHJHGvJXEHR0K/23BCyQcc
wRksAcj8CI/fVQmybVwEh5RE3rW7YVm6DRCcPYArDLwwTxzbrag1JGmiVShDSex0
cvX/YpoeGvqr6wu0XRL/NXH/xqgyYrRNIGdD2j/h3M5n7FwUoxW9rYxF4z7ofDqm
lDbyOhCSRu7VWhD0j5JXE+h+DyeMOnaAlTpLm3iPtsfuuP2fLJ3b0ZL8aCkJiQaM
uGpi1Roks6O63PGzEI9zrtWi2IDukEiU2qeG+7LPc2zBmlQocsetIGr8fPMWA50h
ymxofuG9rPL6nY9YKqL5G+VezEED6QxeJEeVw/9S737lqq3+r7sKZaPnCJYUBzgu
XAQPwSX+0aIIqwpZwzq3JPeuTA89D27QINo1/dRQnzVC7ZOe9bcqZlaqgFwlXkEC
QCYCcjUw9QY=
=UUc5
-----END PGP SIGNATURE-----

--Sig_/yUKGVup7eAiVyZS/VyyQWGO--
