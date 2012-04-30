Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2D3B6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 21:58:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab2D3B62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 21:58:28 -0400
Date: Mon, 30 Apr 2012 11:58:19 +1000
From: NeilBrown <neilb@suse.de>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 5/8] epoll: Add a flag, EPOLLWAKEUP, to prevent
 suspend while epoll events are ready
Message-ID: <20120430115819.633c2cb6@notabene.brown>
In-Reply-To: <CAMP5XgcmsDzB3eY53tF=+k07WNSnG11M90gPTKfSs4-f78CEtQ@mail.gmail.com>
References: <201202070200.55505.rjw@sisk.pl>
	<201204222322.44278.rjw@sisk.pl>
	<20120426140324.0357b1a3@notabene.brown>
	<201204262240.54135.rjw@sisk.pl>
	<CAMP5XgcmsDzB3eY53tF=+k07WNSnG11M90gPTKfSs4-f78CEtQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FV+Vw=y9wu1=flPNImtIC_M"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FV+Vw=y9wu1=flPNImtIC_M
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Apr 2012 20:49:51 -0700 Arve Hj=F8nnev=E5g <arve@android.com> wr=
ote:

> 2012/4/26 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, April 26, 2012, NeilBrown wrote:
> >> On Sun, 22 Apr 2012 23:22:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> w=
rote:
> >>
> >> > From: Arve Hj=F8nnev=E5g <arve@android.com>
> >> >
> >> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> >> > wakeup_source will be active to prevent suspend. This can be used to
> >> > handle wakeup events from a driver that support poll, e.g. input, if
> >> > that driver wakes up the waitqueue passed to epoll before allowing
> >> > suspend.
> >> >
> >> > The current implementation uses an extra wakeup_source when
> >> > ep_scan_ready_list runs. This can cause problems if a single thread
> >> > is polling on wakeup events and frequent non-wakeup events (events
> >> > usually arrive during thread freezing) using the same epoll file.
> >>
> >> This is quite neat.
> >>
> >> If I understand it correctly, you register file descriptors with epoll=
_ctl()
> >> on an fd created with epoll_create(), and set the new EPOLLWAKEUP flag.
> >> Then when a regular 'poll' or 'select' on the epoll fd reports that it=
 is
> >> readable you:
>=20
> I think it makes more sense to use epoll_wait than mixing this with
> select or poll.
>=20
> >> =A0 - get a wakelock
> This may not be needed, since epoll does not reevaluate its state
> until you call into it again (at least using epoll_wait).
>=20
> >> =A0 - use epoll_wait to collect the events
> >> =A0 - process the events
> >> =A0 - release your wakelock
> >> =A0 - go back to poll() or select() on the epoll fd.
> >> Correct? =A0As long as there are ready events with EPOLLWAKEUP set a
> >> wakeup_source is held active and the system won't go to sleep.
> >>
> >> My concern with this is about permissions. =A0It appears that any proc=
ess could
> >> wait of some fd (maybe a pipe they created themselves) with EPOLLWAKEU=
P, and
> >> then simply never epoll_wait() for the event. =A0Then they would be ke=
eping
> >> the system awake. =A0I don't think that is acceptable.
> >
> > I wonder what Arve has to say to that, but let me say that on systems w=
ithout
> > autosleep every process can go into an infinite busy loop which is goin=
g to
> > drain battery relatively quickly just as well and I don't see why that'=
s so
> > much different.
> >
>=20
> I still think is useful to limit access to this feature. On a phone, a
> process stuck in an infinite loop will increase battery drain, but if
> this process does not have permission to prevent suspend, then this is
> only catastrophic if another process that have that permission is
> preventing suspend. I think we should add a capability for this.
> Assuming you agree, do want me to create a separate patch for that
> adds a capability, or roll it into this one.
>=20
> >> So there needs to be some way to limit who can effectively block suspe=
nd by
> >> using EPOLLWAKEUP.
> >> (This is one of the reasons I like an all-user-space solution. =A0Poli=
cy issues
> >> like this can easily be decided in user-space but are clumsy to put in=
to the
> >> kernel).
> >>
> >> Also, I'm having trouble understanding the ep->ws wakeup_source.
> >> The epi->ws makes lots of sense and I think I understand it all.
> >> However I don't see why you need a wakeup_source for the 'struct event=
poll'.
> >>
> >> Every time that 'poll' decides to call the ->poll fop for the eventpol=
l, this
> >> wakeup_source will be activated and deactivated which will abort any c=
urrent
> >> suspend cycle even if there are no events to report.
> >>
> >> I suspect it can just go away.
> >
> > I'll leave this one entirely to Arve, if you don't mind. :-)
> >
>=20
> I keep the wakeup-source active whenever the epitem is on a list
> (ep->rdllist or the local txlist). The temporary txlist is modified
> without holding the lock that protects ep->rdllist. It is easier to
> use a separate wakeup source to prevent suspend while this list is
> manipulated than trying to maintain the wakeup-source state in a
> different way than the existing eventpoll state. I think this only
> causes real problems if the same epoll file is used for frequent
> non-wakeup events (e.g. a gyro) and wakeup events. You should be able
> to work around this by using two epoll files.

Thanks for the explanation.  I can now see more clearly how your patch work=
s.
I can also see why you might need the ep->ws wakeup_source.  However I don't
like it.

If it acted purely as a lock and prevented suspend while it was active then
it would be fine.  However it doesn't.  It also aborts any current suspend
attempt - so it is externally visible.
The way your code it written, *any* call to epoll_wait will abort the curre=
nt
suspend cycle, even if it is called by a completely non-privileged user.
That may not obviously be harmful, but it makes the precise semantics of the
system call something quite non-obvious, and it is much better to have a ve=
ry
clean semantic.
As you say, it can probably be worked-around but code is much safer when you
don't need to work-around things.

I see two alternatives:
1/ set the 'wakeup' flag on the whole epoll-fd, not on the individual events
   that it is asked to monitor.  i.e. add a new flag to epoll_create1()
   instead of to epoll_ctl events.
   Then you just need a single wakeup_source for the fd which is active
   whenever any event is ready.

   This interface might be generally nicer, I'm not sure.

2/ Find a way to get rid of ep->ws.
   Thinking about it more, I again think it isn't needed.
   The reason is that suspend is already exclusive with any process running=
 in
   kernel context.
   One of the first things suspend does is to freeze all process and (for
   regular non-kernel-thread processes) this happens by sending a virtual
   signal which is acted up when the process returns from a system call or
   returns from a context switch.  So while any given system call is running
   (e.g. epoll_wait) suspend is blocked.  When epoll_wait sets
   TASK_INTERRUPTIBLE the 'freeze' signal will interrupt it of course, but
   this is the only point where suspend can interfere with epoll_wait, and =
you
   aren't holding ep->ws then anyway.
   Hopefully Rafael will correct me if I got that outline wrong.  But even =
if=20
   I did, I think we need to get rid of ep->ws.

Also, I think it is important to clearly document how to use this safely.
You suggested that if any EPOLLWAKEUP event is ready, then suspend will
remain disabled not only until the event is handled, but also until the next
call to epoll_wait.  That sounds like very useful semantics, but it isn't at
all explicit in the patch.  I think it should be made very clear in
eventpoll.h how the flag can be used. (and then eventually get this into a
man page of course).

>=20
> >> One last item that doesn't really belong here - but it is in context.
> >>
> >> This mechanism is elegant because it provides a single implementation =
that
> >> provides wakeup_source for almost any sort of device. =A0I would like =
to do the
> >> same thing for interrupts.
> >> Most (maybe all) of the wakeup device on my phone have an interrupt wh=
ere the
> >> body is run in a thread. =A0When the thread has done it's work the eve=
nt is
> >> visible to userspace so the EPOLLWAKEUP mechanism is all that is neede=
d to
> >> complete the path to user-space (or for my user-space solution, nothin=
g else
> >> is needed once it is visible to user-space).
> >> So we just need to ensure a clear path from the "top half" interrupt h=
andler
> >> to the threaded handler.
> >> So I imagine attaching a wakeup source to every interrupt for which 'w=
akeup'
> >> is enabled, activating it when the top-half starts and relaxing it whe=
n the
> >> bottom-half completes. =A0With this in place, almost all drivers would=
 get
> >> wakeup_source handling for free.
> >> Does this seem reasonable to you.
> >
> > Yes, it does.
> >
>=20
> How useful is that? Suspend already synchronizes with interrupt
> handlers and will not proceed until they have returned. Are threaded
> interrupts handlers not always run at that stage? For drivers that use
> work-queues instead of a threaded interrupt handler, I think the
> suspend-blocking work-queue patch I wrote a while back is convenient.
>=20

Maybe it isn't useful at all - I'm still working this stuff out.

Yes, threaded interrupts are run "straight away", but what exactly does that
mean?  And in particular, is there any interlocking to ensure they run
before suspend gets stop the CPU?  Maybe the scheduling priority of the
different threads is enough to make sure this works, as irq_threads are
SCHED_FIFO and  the suspending thread almost certainly isn't.  But is that
still a guarantee on an SMP machine?  irq_threads aren't freezable so suspe=
nd
won't block on them for that reason..

I really just want to be sure that some interlock is in place to ensure that
the threaded interrupt handler runs before suspend absolutely commits to
suspending.  If that is already the case, when what I suggest isn't needed =
as
you suggest.  Do you know of such an interlock?

Thanks,
NeilBrown



--Sig_/FV+Vw=y9wu1=flPNImtIC_M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT53xuznsnt1WYoG5AQLJtBAAwJSDWTlo1SIkIgS5tfJYnSTXl5xLxHnv
I3HkjAsOXVDf/rihJo0hxAHX1aR+MjGfC62lxEQDjAcd019ouRN/2IwwoVk3Q+ej
GVf+q9ZDv2MJlNbPwOGgRPcpK+6hkT/yy5LKpH7My4cgmGJZtGdaMafxBnEz3IL9
N+YB0eV/upKWASuQXeRiQR1n9ASaBI6dEqkRiitZ4TsYhrJjp3bcCjRCwxjI1CuQ
SuQu2YUQiunLuL/eAJ620U8D4THxRWDAbnAJGVpBLNc0g0wzGgekemaZ7WTMwIe8
1mjQiNfmjf+Ya7U5Ufljw0xs7y3ywtxhExiFfY3DqCoBJD1D6B8cVD7NgGmDdVql
/R5UoR7zYtGlw6JqTzGTcmAHycVADohCZOubOZ6bHww88FhGkEsGG5d6AlDGdiJR
Gm4+FNhUr9iQOoYxwXVu5jPSz0NrD0cBl7GGgP8gC6GNJHIEnz4FtFcjdhDEiSE+
tc9yF1xSW7quWbtRAWgS3h1jywu05xbR/SjCk9LaOfEz/HBtnujxApSaC0v8+9+6
r5Cu73kaphAgzT+LW9B8hWsywpHDCTdnvoANVnTB3KWATdt8CbGXUr912IYU9ynj
YapD2YdHSwWieWA5jtZeRZE9+GQBXcttv7TDUGWUZ5Zv64KsT+aXJvmexlDg6Sos
mGdbLQVL6NI=
=PIp5
-----END PGP SIGNATURE-----

--Sig_/FV+Vw=y9wu1=flPNImtIC_M--
