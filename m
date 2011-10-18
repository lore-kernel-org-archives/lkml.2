Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1JRCOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:14:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab1JRCOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:14:07 -0400
Date: Tue, 18 Oct 2011 13:13:58 +1100
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111018131358.1c964c32@notabene.brown>
In-Reply-To: <1318895224.3125.158.camel@work-vm>
References: <20111017093401.21cd4461@notabene.brown>
	<Pine.LNX.4.44L0.1110171030440.2430-100000@iolanthe.rowland.org>
	<20111018094950.22d282a3@notabene.brown>
	<1318895224.3125.158.camel@work-vm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/E7sXpCVKQuy9XeVl6YYv/TN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E7sXpCVKQuy9XeVl6YYv/TN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 16:47:04 -0700 John Stultz <john.stultz@linaro.org> wro=
te:

> On Tue, 2011-10-18 at 09:49 +1100, NeilBrown wrote:
> > However for the bits that I feel I do understand, this is what I (curre=
ntly)
> > think it should (or could) look like.
> >=20
> >=20
> > 1/ There is a suspend-management daemon that starts very early and is t=
he only
> >    process that is allowed to initiate suspend or hibernate.  Any other
> >    process which tries to do this is a BUG.
> >=20
> > 2/ The daemon has two modes:
> >    A/ on-demand.  In this mode it will only enter suspend when requeste=
d to,
> >       and then only if there is nothing else blocking the suspend.
> >    B/ immediate.  In this mode it will enter suspend whenever nothing is
> >       blocking the suspend.  The daemon is free to add a small delay
> >       proportional to the resume latency if so configured.
> >    The daemon is in on-demand mode at start up.
> >=20
> > 3/ The daemon can handle 5 sorts of interactions with clients.
> >=20
> >    i/ Change mode - a request to switch between on-demand and immediate=
 mode.
> >   ii/ suspend now - a request to suspend which is only honoured if no c=
lient
> >       has blocked suspend, and if the kernel is not blocking suspend.
> >       Thus it is meaningless in immediate mode.
> >  iii/ be-awake-after - this request carries a timestamp and is stateful=
 - it
> >       must be explicitly cancelled.  It requests that the system be ful=
ly
> >       active from that time onwards.
>=20
> This initially wasn't super clear to me why this is necessary. I see
> below it is trying to handle the non-fd timer method to keeping the
> system awake.
>=20
> Although does this also duplex as the  suspend-inhibit/suspend-allow
> call made by applications? Or was that interaction just skipped here?

Yes, exactly.  This is primarily allowing an application to say "inhibit
suspend" (aka "be awake").  Being able to make the request for a future time
seemed a natural and simple extension.
If you can do timer wakeups like other wakeups and find it easier that way,
then we can leave the timestamp out of it.


>=20
> >   iv/ notify - this establishes a 'session' between client and server.
> >       Server will call-back and await respond before entering suspend a=
nd
> >       again after resuming (no response needed for resume).
> >       The client is explicitly permitted to make a be-awake-after reque=
st
> >       during the suspend call-back.
>=20
> With the notify-fd example included below, I'm curious what specific use
> cases you see as requiring the notify interaction?=20

None specifically.  However while I'm convinced that all events must be
visible to user-space I am not convinced that they will be visible to a
poll.  You might occasionally require a read on a sysfs file, and then parse
the contents to see if the event happened.
We can do poll on sysfs files now so that can probably be avoided.
But I didn't want to close doors before I was sure no-one needed them.

And I think that with notify-fd you still need a hand-shake of some sort, a=
nd
this provides a simple starting point.

>=20
> >    v/ notify-fd.  This is a special form of 'notify' which carries a fi=
le
> >       descriptor.  The server is not required to (and not expected to)
> >       initiate the 'suspend' callback unless the fd is reporting POLL_I=
N or
> >       POLL_ERR while preparing for suspend.
>=20
> I'd think it would be "the server is not allowed to" instead of "not
> required to".

Maybe.  When specifying a protocol I am cautious of excluding things that a=
re
merely inconvenient.  So "should not" but not "shall not" in rfc-speak.
However it might be easier on the client if it knew there would never be a
call-back so it might be best to make it "shall now".

>=20
> > 4/ The daemon manages the RTC alarm.  Any other process programing the =
alarm
> >    is a BUG.  Before entering suspend it will program the RTC to wake t=
he
> >    system at (or slightly before) the time of the earliest active
> >    be-awake-after request.
>=20
> So, this may need to be revised. My RTC virtualization and alarmtimer
> rework gives us a lot more flexibility with RTC events. Given the array
> of existing applications that use the RTC chardev, I think its not
> realistic to consider it a bug if someone else is using it.=20

If multiple applications think they can independently "own" the RTC alarm
then that sounds like it is already a bug quite apart from anything I add.

We must have some way to virtualise the rtc-alarm so that any app can be su=
re
there will we be a wakeup at-or-before some time.  I suggested doing that v=
ia
the suspend daemon.  If there is a strong case for a more general
kernel-based virtualisation of the RTC alarm in the kernel - then maybe that
is OK.

>=20
> That said, the posix alarmtimer interface allows us to trigger wakeup
> events in the future, without disrupting the legacy chardev programming
> (this is possible because the kernel now virtualizes the chardev).
>=20
> I'd probably rather add alarmtimer functionality to the timerfd, in
> order to allow the notify-fd method to work with timers. But its not a
> huge deal. I'd just like to avoid reimplementing a timer dispatch system
> in userland.

Yep.  Exactly which solution gets implemented isn't important as long as it
is clean and well defined.

>=20
>=20
> > 5/ Possible implementation approaches for the client interactions:
> >    I/ A SOCK_STREAM unix domain socket which takes commands.
> >      On connect, server says "+READY".
> >      Client writes "MODE ON-DEMAND" or "MODE IMMEDIATE"
> >      Server replies "+MODE $MODE"
> >=20
> >   II/ The same unix domain socket as I.=20
> >      Client writes "SUSPEND"
> >      Server replies "+RESUMED" if the suspend happened, or
> >                     "-BUSY"  if it didn't.
> >      +RESUMED is no guarantee that an measurable time was in suspend, so
> >      maybe it isn't needed.
> >=20
> >  III/ A separate Unix domain socket.
> >      On connect, server says "Awake" meaning that this connection is en=
suring
> >      the system will be awake now.
> >      Client can write a seconds-since-epoch number, which the server wi=
ll echo
> >      back when confirmed.  When that time arrives - which might be imme=
diately
> >      - the server will write "Awake" again.
> >      When the client closes the connection, the suspend-block is remove=
d.
>=20
> What is the seconds-since-epoch bit for?=20

That is the time when the server will ensure the system is awake from.  i.e.
the wakeup timer.  If it is in the past, it means "be awake now".


>=20
> >   IV/ A third Unix domain socket.
> >      On connect, server writes a single character 'A' meaning 'system is
> >      awake'.
> >      When initiating suspend, server writes 'S' meaning 'suspend soon'.
> >      Client must reply to each 'S' with 'R' meaning 'ready'.  Server do=
es not
> >      enter resume until the 'R' is received.
> >      On resume, server will write 'A' meaning 'awake' again.  Many clie=
nts
> >      might ignore this.
>=20
> Again, still not sure about this bit, but how do you handle aborted
> suspends? If you have one blocked task that takes a really long time to
> respond, what happens if you've had multiple attempts to suspend that
> have aborted? Just want to make sure you don't end up getting an late
> ack for an old suspend attempt (although I'm not really sure if that
> matters).

The server just needs to ensure that on every connection that it sends an '=
S',
it waits for an 'R', and subsequently sends an 'A'.
Whether a suspend actually happens between the R and the A, or whether it w=
as
aborted, is irrelevant.
After a suspend, whether aborted or not, the server must send 'A' to all
clients that it sent 'S' to.  Then it must sent S and wait for R before
trying to suspend again.

So a client that has been blocked for a while might see an 'A' and an 'S' b=
ut
that is all.  If it blocked for too long and the server was allowed to reje=
ct
it, it might see a closed connection.
There should be no confusion.


>=20
> >    V/ Same socket as IV, with extra message from client to server.
> >      Client writes 'M' (monitor) in a message with SCM_RIGHTS containin=
g one
> >      or more fds.  Server will now only send 'S' when one or more of th=
ose fds
> >      are readable, but the client cannot rely on that and must (as alwa=
ys)
> >      not assume that a read will succeed, or will not block.
>=20
> Err. Not following this. If this is the notify-fd bit, I'd expect the
> client to provide the fds, and then that's it. Then the server will
> check those fds before trying to suspend, and if any have data, it will
> wait until that data is read. Why does the server send an S in this one?
> Doesn't the task also see that there is data there?

As I said in another email "wait until data has been read" is not an
operation that Linux supports directly.
The server sends the S so that it can then wait for the R.

But maybe it can wait for a separate "stay awake" request - that can be in
v0.2 of the protocol.


>=20
>=20
> > 6/ The daemon may impose access control on be-awake messages.  In the a=
bove
> >    protocol it could be based on SCM_CREDENTIAL messages which might be
> >    required.
> >    It may also impose timeout on the 'R' reply from the 'S' request, or=
 at
> >    least log clients which do not reply promptly.
>=20
> This again feels more complex then necessary, but I'll leave it be for
> now.
>=20
> > 7/ A client should not delay at all in replying to 'suspend
> >    soon' (S) with 'ready' (R).  It should only check if there is anythi=
ng to
> >    do and should make a stay_awake request if there is something.  Then=
 it
> >    must reply with 'R'.
> >    I should *not* use the fact that suspend is waiting for its reply to
> >    respond to an event as this misleads other clients as to the true st=
ate of
> >    the system.
>=20
> Again, while I'm not sure about the notify method, this interleaving
> seems right to me.=20
>=20
> > 8/ I haven't treated hibernate here.  My feeling is that it would be a
> >    different configuration for the daemon.
> >    If hibernate were possible and the soonest stay-awake time were long=
er
> >    than X in the future, then the daemon might configure the RTCalarm f=
or X,
> >    and when that arrives, it pops out of suspend and goes into hibernat=
e.
> >    But the details can wait for revision 2 of the spec..
>=20
> I'm not sure if hibernate is different in my mind, other then it taking
> much longer. It just seems like it would be a subtlety of the type of
> "suspend-now" request made to the PM daemon.
>=20
>=20
> So while I'm excited to be making some headway on the userland approach,
> I'm also concerned about how this approach might mesh with other dynamic
> run-time power-saving methods that might be used in the future. For
> instance, if some future scheduler does some form of rate limiting, and
> avoids scheduling applications to keep the cpu in deep idle for longer,
> would this keep the kernel from knowing enough to not freeze tasks that
> might need to do something so that suspend can occur?   This in effect
> would cause one power-saving strategy to block a potentially more
> power-saving method from occurring.=20

It is hard to guard against unknown future possibilities :-)

However I suspect that such a scheduler would make decisions based on policy
specified by the application.  An application that handled wakeup events
would need to request prompt scheduling, and would need to behave nicely and
only wake up when actually required.

=20
>=20
> This is in part what I was trying to address with my original
> SCHED_STAYAWAKE proposal, trying to find a mechanism that provides
> adequate information for the kernel to make appropriate decisions. I
> worry a little bit about having too narrow a view on these solutions.=20

If suspend was just like another C-state and only shuts-down the CPU then I
would agree that a SCHED related approach was appropriate.  But then it wou=
ld
be called a C-state and not an S-state.

When you suspend it shuts down the CPU and also some devices - at least that
is how I understand the distinction.

I think if you are shutting down an essentially arbitrary set of devices,
then you need to have user-space making the decision.
If you are only shutting down the processor and all interrupts will still
wake it up, then don't call it "suspend" aka S3 - call it C9 or something.

>=20
> That of course won't keep me from trying to start work on this user-land
> approach, but it is something I think we should keep in mind. It seems
> with too many things (Dave Hansens' virtualization talk at Plumbers
> covered some examples), we end up with 4-5 small solutions to smaller
> problems that don't really work well together instead of stepping back
> and seeing the broader picture.

I emphatically agree with that last comment.  It is one of the reasons that=
 I
advocate a user-space solution were possible.
Once something goes into the kernel it can be difficult to refine or replace
because of the no-regressions rule.  It is much better where possible to
prototype new ideas with as much control logic as possible in user-space,
where it is flexible and it is possible to re-architect it to address the
broader picture as that becomes clear.
Once you actually know what you are doing and see the big picture, then you
can make informed decisions about adding functionality to the kernel.

Thanks,
NeilBrown


--Sig_/E7sXpCVKQuy9XeVl6YYv/TN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpzg5jnsnt1WYoG5AQIXyQ//QSHhrAq2GoX+vVMp51qW7Paama9ulYvm
1s2726Cqcq9snMMSnJxbPxcOUfJyaIgqAJV1XpqtZ/3IsWRFIPMgzUj16CRnE/hU
Qp0w8VIHmoXn4qM3ZcTY3M/twbeH0pBq/eH3CNiyqXZLLwBirqAAQFVd2iwn6CXW
lgRiPDHnfktuOZ5s0zZX6y+JcgYuFpa4+oj1Ztyl/9rkTNn2N2oGkFqfoTZmJvGU
A/wAyYKBiph+nHnzfYHnxYUvEkEfDkxvQ8DNGXgjA/K7JC6ua+YSk5+6StYSvC9x
+/k+qjTyKWr099lZVIAr1X3Esrawx334U13jSqRAWPjfpANVRXrKsYinEEJ9olN6
Wzkoq2KN5FNw4/HAoqJFGUsnlOoDqzNjSjyKtjul5OjzZiTjxZbqpmNNjrrLE5kL
NFmIk1OLFZBvE2FILpYBMRxSq0BHHwmK/cDfK3z+d/7I5VALZf++7Zs32+sDPnW4
tNTm/0Qw5wyxVzWu43H+UzAeRp8v8jcMUxh+9/MGb4tRuCY3rIqWvz/otykM/agh
2Go0eViTa0DJ2qMwTqouAHJ7b402M/VBqNUuOPeJrwIYtWZWToBtjpk9XR9kKOG/
dCP8cbJByf4sTFgdSUCtJtFNT82MBAEkYyMA+dLXHRWbJCyY8av/jVBS/3bhq0IU
O4Sz+PlS4tE=
=E/Na
-----END PGP SIGNATURE-----

--Sig_/E7sXpCVKQuy9XeVl6YYv/TN--
