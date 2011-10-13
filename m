Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1JMFgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:36:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1JMFgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:36:00 -0400
Date: Thu, 13 Oct 2011 16:35:26 +1100
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
Message-ID: <20111013163526.3863be01@notabene.brown>
In-Reply-To: <20111013034805.GC893@mgross-G62>
References: <20111002164456.GC14312@mgross-G62>
	<20111008221439.48f30263@notabene.brown>
	<20111008181638.GA12672@mgross-G62>
	<20111009093100.6c15be50@notabene.brown>
	<20111013034805.GC893@mgross-G62>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1dBbz6seuSfTneIe3PCf4OO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1dBbz6seuSfTneIe3PCf4OO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Oct 2011 20:48:05 -0700 mark gross <markgross@thegnar.org> wrote:

> On Sun, Oct 09, 2011 at 09:31:00AM +1100, NeilBrown wrote:
> > On Sat, 8 Oct 2011 11:16:38 -0700 mark gross <markgross@thegnar.org> wr=
ote:
> >=20
> > > On Sat, Oct 08, 2011 at 10:14:39PM +1100, NeilBrown wrote:
> > > > On Sun, 2 Oct 2011 09:44:56 -0700 mark gross <markgross@thegnar.org=
> wrote:
> > > >=20
> > > > > resending to wider list for discussion
> > > > > ----- Forwarded message from mark gross <markgross@thengar.org> -=
----
> > > > >=20
> > > > > Subject: [RFC] wake up notifications and suspend blocking (aka mo=
re wakelock stuff)
> > > > > Date: Tue, 20 Sep 2011 13:33:05 -0700
> > > > > From: mark gross <markgross@thengar.org>
> > > > > To: linux-pm@lists.linux-foundation.org
> > > > > Reply-To: markgross@thegnar.org
> > > > > Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@ro=
wland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J=
. Wysocki" <rjw@sisk.pl>
> > > > >=20
> > > > > The following patch set implement an (untested) solution to the
> > > > > following problems.
> > > > >=20
> > > > > 1) a method for making a system unable to suspend for critical se=
ctions
> > > > > of time.
> > > >=20
> > > > We already have this.  A properly requested suspend (following wake=
up_count
> > > > protocol) is unable to complete between wakeup_source_activate() and
> > > > wake_source_deactivate() - these delimit the critical sections.
> > > >=20
> > > > What more than this do you need?
> > >=20
> > > sometimes devices that are not wake up sources need critical sections
> > > where suspend is a problem.
> >=20
> > I agree with Alan that an example would help here.
> > My naive perspective is that any device is either acting on behalf of a
> > user-space program, so it should disable suspend, or on behalf of some
> > external event, so that event is ipso-facto a wakeup event.
>=20
> battery changing and usb gadget compilance are the ones I can think of
> at the moment.  I guess the FW / BIOS update may be another (but is a
> bit weak as an example)
>=20
> I'm having a hard time thinking of anything else :(=20

These examples are certainly credible.

In general, I think of the kernel as a service provider.  It doesn't do
things on it's own, it just performs tasks on the request of some user-space
process.  In such cases, the user-space process would act to disable suspend
(by telling the suspend daemon not to).
However I accept that there are some activities that do not have a user-spa=
ce
component.  One that is close to my heart is the NFS server.  The kernel
contains both the support services and the core logic.
In general I think such designs are problematic and best avoided, but I
accept that they are inevitable.
If the monitoring of battery charging and the management of a usb
gadget are being handled entirely in the kernel, then so be it.  The control
logic still has a right to disable suspend, so that has to be in the kernel.

It can do this currently by activating a wakeup_source.  This could be seen=
 as
a slightly ugly interface, because it isn't really a wakeup.  However this =
is
simply a naming issue.  If we rename it to say_awake_request (or
caffeine_source). which can still be activated or deactivated, then the
ugliness goes away and the functionality remains.

In short: if control logic is in the kernel (which should be avoided but
sometimes is required) then it is reasonable for that control logic to be a=
ble
to disable suspend, and can do this today by activating a wakeup_source.


>=20
> >=20
> > > >=20
> > > > >=20
> > > > > 2) providing a race free method for the acknowledgment of wake ev=
ent
> > > > > processing before re-entry into suspend can happen.
> > > >=20
> > > > Again, this is a user-space problem.  It is user-space which reques=
ts
> > > > suspend.  It shouldn't request it until it has checked that there a=
re no wake
> > > > events that need processing - and should use the wakeup_count proto=
col to
> > > > avoid races with wakeup events happening after it has checked.
> > >=20
> > > Here you are wrong, or missing the point.  The kernel needs to be
> > > notified from user mode that an update event has been consumed by
> > > whoever cares about it before the next suspend can happen.  The fact
> > > that there are time outs in the existing wake event code points to th=
is
> > > shortcoming in the current implementation.
> >=20
> >  ... or I have a different perspective.
> > A write to wakeup_count is a notification to the kernel that all wakeup
> > events that had commenced prior to that same number being read from
> > wakeup_count have been consumed.
> >=20
> > So we already have a mechanism for the notification that you want.
>=20
> If I understand you correctly; those processes still need an efficient
> way of notification that the wake event came in.

[[while re-reading my reply, I realise that I might have misunderstood the
above. Are you talking about an efficient notification to the process that
the event has happened, or from the process that the event has been consume=
d?
I assumed the former and it still seems the best way to read that sentence.
But if you mean the later... I think I've covered that too, but it makes the
following paragraph irrelevant.  In that case, ignore it please]]

Is that a big ask?
If the wake event is an RTC alarm, then the process will be using
select/poll/epoll/whatever on an open fd on /dev/rtc and can easily check if
there are any pending events.
If the wake event is a button press, or lid opening, it will probably come =
in
through the input subsystem and again 'poll' will do the trick.
If it is a usb device sending a wakeup, it will probably come through input
too.
A character arriving on a UART is equally detectable with poll.

Are there important wakeup events which will not cause a 'poll' to wake up?
or is poll not "efficient" enough?



>=20
> >=20
> > >=20
> > > I suppose one could rig up the user mode suspend daemon with
> > > notification callbacks between event consumers across the user mode
> > > stack but its really complex to get it right and forces a solution to=
 a
> > > problem better solved in kernel mode be done with hacky user mode
> > > gyrations that may ripple wildly across user mode.
> >=20
> > I suspect it is in here that the key to our different perspectives lies.
> > I think than any solution must "ripple wildly across user mode" if by t=
hat
> > you mean that more applications and daemons will need to be power-aware=
 and
> > make definitive decisions about when they cannot tolerate suspend.
> > Whether those apps and daemons tell the kernel "don't suspend now" or t=
ell
> > some user-space daemon "don't suspend now" is fairly irrelevant when
> > assessing the total impact on user-space.
> >=20
> > I think a fairly simple protocol involving file locking can be perfectly
> > adequate to communicate needs relating to suspend-or-don't-suspend among
> > user-space processes.
>=20
> I'm not sure how the wake event notification would get to the right
> process(es) are that need to get the notification in your concept.  But
> after the processes that need to consume the event are notified (by
> magic???) then some file locking could be done to coordinate between
> those and some suspend daemon.

Not magic.  epoll.
Any process that wants to handle wakeup events just needs to keep an fd open
on the source of the event (and negotiate with the suspend daemon at times).


>=20
>=20
> >=20
> > >=20
> > > Also it is the kernel that is currently deciding when to unblock the
> > > suspend daemon for the next suspend attempt.  Why not build on that a=
nd
> > > make is so we don't need the time outs?
> >=20
> > Suspend is a joint decision by user-space and kernel-space.  Each part =
should
> > participate according to its expertise.
> > The kernel can make use of information generated by drivers in the kern=
el.
> > User-space can consolidate information generated by user-space processe=
s.
> >=20
> >=20
> > >=20
> > > > i.e. there is no kernel-space problem to solve here (except for pos=
sible
> > > > bugs).
> > >=20
> > > Just a race between the kernel allowing a suspend and the user mode c=
ode
> > > having time to consume the last wake event.
> > >
> >=20
> > Providing that the source of the wake event does not deactivate the
> > wakeup_source before the event is visible to userspace, this race is ea=
sily
> > avoided in userspace:
>=20
> Well this is the crux of the issue.  How are you going to ack the wake
> event in a sane way?  Its not quite the same as in interrupt.  knowing
> when to ack it takes both user and kernel mode coordination.  I think.

This is the beauty that of the wakeup_count approach - you don't need to ack
the event.  You don't even need to consume the event (though it would be du=
mb
not to).
All a user-space process needs to do is tell the suspend daemon "I've done =
all
that I want to do".  It first checks if there is anything that it wants to =
do
of course.

>=20
> >=20
> >    - read wakeup_count
> suspend daemon blocked here when not ok to suspend.
>=20
> >    - check all possible wakeup events.
> but there is a user mode process that needs to chew on this wake up
> event.  It needs to be notified (somehow) then it needs to coordinate
> with the suspend daemon before the next suspend happens.
>=20

This is "simply" a bit of IPC.
Any program that wants to handle wake events needs to register with the
suspend daemon.  The daemon says "Hey everyone, I'm about to suspend".
Each registered program then needs to say either "OK", or "Wait, don't
suspend now".
If everyone says "OK", it tries to suspend.  If anyone says "No, wait", it
waits until they all say "OK, I'm done" at which point it starts at the top
of the loop again.

This is just a software engineering issue though.

An alternate approach would be for each process to give (via unix domain
sockets) an fd to the suspend daemon.  The suspend daemon just needs to che=
ck
(using e.g. select) that none of the fds are ready.  If they are, it can en=
ter
a more heavy-weight conversation with the process in question.  If not, it
can safely suspend.



> >    - if there were none, write back to wakeup_count and request a suspe=
nd.
> >=20
> > This is race-free.
> I don't agree.

Can you describe a race?
Here is the sequence as I see it.

0: some user-space process is blocking suspend by telling the suspend daemon
   not to suspend.  There are no pending kernel wakeup events.
   All processes that handle wakeup events are registered with the daemon.
1: last blocking user-space  process releases its "don't suspend" lock.
2: suspend-daemon decides to initiate suspend.
3: suspend_daemon reads wakeup_count and remembers number.
4: suspend daemon tells all registered clients that suspend is imminent.
5: each client executes 'poll' or 'select' or whatever and discovers that
   there are no events.
6: each client tells daemon that it is OK to suspend
7: when all votes are in, suspend daemon checks that no process is requesti=
ng
   that suspend be blocked.
8: if that succeeds, suspend daemon writes the number back to wakeup_count
9: if that succeeds, suspend daemon daemon writes 'mem' to 'state'.
10: goto 1

If a wake_event happens after 3 and before 8, the write at 8 will fail.
If a wake_event happens after 8, and before 9, the suspend will abort.
If a wake_event happens after 9, the suspend will resume
If a wake_event happens before 3, one of the processes will get an event
notification from select or poll or whatever, and will ask the suspend
daemon not to suspend just now and this will be noticed at 7, so 8 and 9
will be skipped and we go straight to 10.

No race.
=20
> >=20
> > If some wakeup_source is deactivated before the event is visible to
> > user-space, then that is a bug and should be fixed.
> one way is to set up overlapping critical sections from the wake event
> up to user mode (we can call the patch "wakelock.patch" ...  I kid...
>=20
> The wake source is at the very bottom of the kernel mode stack.
> Basically an interrupt is the wake event.  How can the ISR possible know
> when its ok to deactivate the wake event?  There needs to be a
> formalized hand shake.

Yes.  But the handshake only needs to get as far as being visible to
user-space, the event doesn't need to be consumed by user-space.

See John Stultz's patches to kernel.org
[PATCH 3/6] [RFC] rtc: rtc-cmos: Add pm_stay_awake/pm_relax calls around IRQ
[PATCH 4/6] [RFC] rtc: interface: Add pm_stay_awake/pm_relax chaining rtc w=
orkqueue processing

They add the required handshake to rtc.
The ISR typically activates the wakeup event and queues something to a
kernel thread.  That thread then does whatever is needed, makes sure the
event is visible to user-space, and then deactivates the wakeup event.

(I'm not certain John's patches get it all right in every case, I don't
know the code well enough, but it looks like the right sort of thing).

Once the event is visible to user-space, the handshake with the suspend
daemon ensure that the event gets consumed if anyone is interested in it.


>=20
> > If there is some particular case where it is non-trivial to fix that bu=
g,
> > then that would certainly be worth exploring in detail.
> >
>=20
> I don't think you accept the idea that there is a notification problem.

Nope, but I'm keen for you to convince me.  Identify a wakeup event that
cannot be made visible to poll (or to user-space by some other
mechanism) before the wakeup_source needs to be deactivated.  Or if I've
misunderstood what sort of notification is problematic, help me understand.


> Fine, Do you at least agree that my problem statement is approximately
> what we thing the original wake lock design attempted to address?

If by your "problem statement" you mean this:

> 1) a method for making a system unable to suspend for critical sections
> of time.
>=20
> 2) providing a race free method for the acknowledgment of wake event
> processing before re-entry into suspend can happen.

Then yes I agree, though I would state it with a slightly different emphasi=
s:

1) a method for ensuring a system does not suspend during critical sections
   of time=20
2) providing a race free method for the handling of wake events before
   re-entry into suspend happens.

Your text sounds the like the kernel is forcing user-space to do the requir=
ed
thing.  My text is meant to only say that the kernel allows user-space to do
the required thing.
Maybe not an important difference.


>=20
> If we can converge on something then maybe we can move forward.  (a bit)
>=20
>=20
> Clearly the use case I'm talking about with out talking about it is the
> Android wake lock problem.  I think my problem statement comes pretty
> close to what it is trying to address.
>=20
> I think my implementation concept is semantically close enough that I
> think I could hack an android implementation to work with it without
> having to change the framework API's and only minor tweaks to a few
> services (that consume wake events).  And I think my idea provides a
> more correct solution to the basic problem than the original wake lock
> design.  i.e.  no over lapping critical sections up and down the stack
> or the need for wake_locks with (racy) timeouts.

Your code essentially creates functionality in the kernel to match the IPC
that I suggest doing in user-space  ... and we really don't need the kernel=
 to
provide yet another IPC mechanism.

I'm quite sure you or I could write code in user-space to work with today's
kernel design to implement Android's wake-lock API.
(there are bugs that need to be fixed of course, like the fact that the RTC
wakeup doesn't activate a wake_source ... unless John's patch has gone in).

( I would doing using lock files and change notifications:=20
  https://lwn.net/Articles/460902/  )


NeilBrown

--Sig_/1dBbz6seuSfTneIe3PCf4OO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpZ4qjnsnt1WYoG5AQKXDg//X+gc1fUAYKJ2s/isJLrM2ewJxQZIOQEQ
0OW75C2K5e5jsKHC+oGsCJIUY6Z4kYuYrJ/j858lI0UUZBH8CMpoNOYVmktVxxZq
ZlpHdNn4liQ4oVj8CQLX1WPudbS89XvzNPTvwuhExGBHpmk4rGWfbAkWR2pBJrWL
/ho5xAj6KII823E9R7PrgRu09smEamDjcxYWgBBHfArlu3OTrD0q9dKsnriIWFuw
CATFkTWONiNuP32WkJkeHE5cuOINa6AaPpQeVhu75mBBVl+sYTu6Gss/KziZN6JY
/3CZo6oT/3oIwwaPMylpMRAviUDb5IcK4emx0XjMtTMSumJzMMvuDFwjULztuzdJ
KAMaRVt3077719qpWb4RdRLx1vAZ/G3LwdSNs829mVnjcxgpbrD/YMk6TSVvcK67
+SOxRR89xJIRw5Mfvf7Op1peWDeRB+54PLMlgcG/bZp4i4+KqzGeOy+XIFSdvajc
mknQsQqdqKoiC49+PBRt+fJX7vdiZk+QvQe0xwIdB8Chw4N3Zor7R0dHkSbuit9P
x/c1UojF3R/tHAN9ys88hEiWBJZCLgXVbr6o6azq0z4m9XoxInt5GKDrmfyMtuWo
ZfscIgnGEVUrhJDRyFT4dWvUqQQkO8deZ6JlRcBw8eC1JcQsGuqdTIQlV3j56oBU
7T0wilVKVdI=
=wCgP
-----END PGP SIGNATURE-----

--Sig_/1dBbz6seuSfTneIe3PCf4OO--
