Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab2EACSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 22:18:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570Ab2EACSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 22:18:50 -0400
Date: Tue, 1 May 2012 12:18:33 +1000
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
Message-ID: <20120501121833.6c613d33@notabene.brown>
In-Reply-To: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
References: <201202070200.55505.rjw@sisk.pl>
	<201204222322.44278.rjw@sisk.pl>
	<20120426140324.0357b1a3@notabene.brown>
	<201204262240.54135.rjw@sisk.pl>
	<CAMP5XgcmsDzB3eY53tF=+k07WNSnG11M90gPTKfSs4-f78CEtQ@mail.gmail.com>
	<20120430115819.633c2cb6@notabene.brown>
	<CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gV1yydqTrpI.WQ6Fc6MTgmW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gV1yydqTrpI.WQ6Fc6MTgmW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 17:52:08 -0700 Arve Hj=F8nnev=E5g <arve@android.com> wr=
ote:

> On Sun, Apr 29, 2012 at 6:58 PM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 26 Apr 2012 20:49:51 -0700 Arve Hj=F8nnev=E5g <arve@android.com=
> wrote:
> ...
> >> I keep the wakeup-source active whenever the epitem is on a list
> >> (ep->rdllist or the local txlist). The temporary txlist is modified
> >> without holding the lock that protects ep->rdllist. It is easier to
> >> use a separate wakeup source to prevent suspend while this list is
> >> manipulated than trying to maintain the wakeup-source state in a
> >> different way than the existing eventpoll state. I think this only
> >> causes real problems if the same epoll file is used for frequent
> >> non-wakeup events (e.g. a gyro) and wakeup events. You should be able
> >> to work around this by using two epoll files.
> >
> > Thanks for the explanation. =A0I can now see more clearly how your patc=
h works.
> > I can also see why you might need the ep->ws wakeup_source. =A0However =
I don't
> > like it.
> >
> > If it acted purely as a lock and prevented suspend while it was active =
then
> > it would be fine. =A0However it doesn't. =A0It also aborts any current =
suspend
> > attempt - so it is externally visible.
> > The way your code it written, *any* call to epoll_wait will abort the c=
urrent
> > suspend cycle, even if it is called by a completely non-privileged user.
>=20
> With the patch I posted Friday, a non-privileged user will not be able
> to pass EPOLLWAKEUP and have the wakeup-source created.

Ahhh yes.  I hadn't noticed that you only create ep->ws the first time that
an epi->ws is created.  So that aspect is fine, thanks.


>=20
> > That may not obviously be harmful, but it makes the precise semantics o=
f the
> > system call something quite non-obvious, and it is much better to have =
a very
> > clean semantic.
> > As you say, it can probably be worked-around but code is much safer whe=
n you
> > don't need to work-around things.
> >
> > I see two alternatives:
> > 1/ set the 'wakeup' flag on the whole epoll-fd, not on the individual e=
vents
> > =A0 that it is asked to monitor. =A0i.e. add a new flag to epoll_create=
1()
> > =A0 instead of to epoll_ctl events.
> > =A0 Then you just need a single wakeup_source for the fd which is active
> > =A0 whenever any event is ready.
> >
> > =A0 This interface might be generally nicer, I'm not sure.
> >
> > 2/ Find a way to get rid of ep->ws.
> > =A0 Thinking about it more, I again think it isn't needed.
> > =A0 The reason is that suspend is already exclusive with any process ru=
nning in
> > =A0 kernel context.
> > =A0 One of the first things suspend does is to freeze all process and (=
for
> > =A0 regular non-kernel-thread processes) this happens by sending a virt=
ual
> > =A0 signal which is acted up when the process returns from a system cal=
l or
> > =A0 returns from a context switch. =A0So while any given system call is=
 running
> > =A0 (e.g. epoll_wait) suspend is blocked. =A0When epoll_wait sets
> > =A0 TASK_INTERRUPTIBLE the 'freeze' signal will interrupt it of course,=
 but
> > =A0 this is the only point where suspend can interfere with epoll_wait,=
 and you
> > =A0 aren't holding ep->ws then anyway.
> > =A0 Hopefully Rafael will correct me if I got that outline wrong. =A0Bu=
t even if
> > =A0 I did, I think we need to get rid of ep->ws.
> >
>=20
> If ep_scan_ready_list is only called from freezable threads, then
> ep->ws is not strictly needed, but without it another suspend attempt
> will be triggered if there are not other wakeup-sources active. I'm
> also not sure if it could get called from a non-freezable thread since
> other subsystems can call it through the poll hook.

I can see that triggering another suspend cycle that we know will fail is n=
ot
ideal - every thread needs to move from 'idle' to 'frozen' and back again.
I wonder if a lighter-weight mechanism might achieve that better.  It feels
like wakeup_source is being used for two very different purposes here - one
to disable suspend while some event is pending, one to lock-out suspend
during a critical piece of code.  I feel it would be neater and more
transparent if they were two different mechanisms.
If there were a second mechanism, I would like to see it used in
pm_autosleep_set_state in place of autosleep_ws as well - it seems like a
similar situation.

Maybe adding a second locking mechanism can be added later - I don't think
the current code is wrong, it just seems inelegant.


>=20
> A third option is to only activate ep->ws when needed. This may may work:

I think this is an improvement if we stay with using a wakeup_source to
protect the critical code section.  If we come up with a different mechanis=
m,
them it is not necessary.


>=20
> > Also, I think it is important to clearly document how to use this safel=
y.
> > You suggested that if any EPOLLWAKEUP event is ready, then suspend will
> > remain disabled not only until the event is handled, but also until the=
 next
> > call to epoll_wait. =A0That sounds like very useful semantics, but it i=
sn't at
> > all explicit in the patch. =A0I think it should be made very clear in
> > eventpoll.h how the flag can be used. (and then eventually get this int=
o a
> > man page of course).
> >
>=20
> OK
>=20
> >>
> >> >> One last item that doesn't really belong here - but it is in contex=
t.
> >> >>
> >> >> This mechanism is elegant because it provides a single implementati=
on that
> >> >> provides wakeup_source for almost any sort of device. =A0I would li=
ke to do the
> >> >> same thing for interrupts.
> >> >> Most (maybe all) of the wakeup device on my phone have an interrupt=
 where the
> >> >> body is run in a thread. =A0When the thread has done it's work the =
event is
> >> >> visible to userspace so the EPOLLWAKEUP mechanism is all that is ne=
eded to
> >> >> complete the path to user-space (or for my user-space solution, not=
hing else
> >> >> is needed once it is visible to user-space).
> >> >> So we just need to ensure a clear path from the "top half" interrup=
t handler
> >> >> to the threaded handler.
> >> >> So I imagine attaching a wakeup source to every interrupt for which=
 'wakeup'
> >> >> is enabled, activating it when the top-half starts and relaxing it =
when the
> >> >> bottom-half completes. =A0With this in place, almost all drivers wo=
uld get
> >> >> wakeup_source handling for free.
> >> >> Does this seem reasonable to you.
> >> >
> >> > Yes, it does.
> >> >
> >>
> >> How useful is that? Suspend already synchronizes with interrupt
> >> handlers and will not proceed until they have returned. Are threaded
> >> interrupts handlers not always run at that stage? For drivers that use
> >> work-queues instead of a threaded interrupt handler, I think the
> >> suspend-blocking work-queue patch I wrote a while back is convenient.
> >>
> >
> > Maybe it isn't useful at all - I'm still working this stuff out.
> >
> > Yes, threaded interrupts are run "straight away", but what exactly does=
 that
> > mean? =A0And in particular, is there any interlocking to ensure they run
> > before suspend gets stop the CPU? =A0Maybe the scheduling priority of t=
he
> > different threads is enough to make sure this works, as irq_threads are
> > SCHED_FIFO and =A0the suspending thread almost certainly isn't. =A0But =
is that
> > still a guarantee on an SMP machine? =A0irq_threads aren't freezable so=
 suspend
> > won't block on them for that reason..
> >
> > I really just want to be sure that some interlock is in place to ensure=
 that
> > the threaded interrupt handler runs before suspend absolutely commits to
> > suspending. =A0If that is already the case, when what I suggest isn't n=
eeded as
> > you suggest. =A0Do you know of such an interlock?
> >
>=20
> Normal interrupts are disabled during suspend. This synchronizes with
> the interrupt handler, and pending wakeup interrupts abort suspend. I
> have not looked at this code since threaded interrupt handlers were
> added, so there could be bugs there.
>=20

If disabling an interrupt ensured that the interrupt thread was idle, and
thus synchronised with both interrupt handlers, that would be good...

And it does.  suspend_device_irqs() calls synchronize_irq() on each suspend=
ed
irq which waits for any irq thread to be idle.  So it's all good.

i.e. in an interrupt is marked for WAKEUP, and its handler (whether threaded
or not)  calls wake_up on a wait_queue_head that is used by 'poll' to detect
activity, then using EPOLLWAKEUP is sufficient to collect those events
without racing with suspend.  So we don't need to teach multiple subsystems
about wakeup_sources - eventpoll and the interrupt handling can do it all.
Excellent.

Thanks,
NeilBrown



--Sig_/gV1yydqTrpI.WQ6Fc6MTgmW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT59H+Tnsnt1WYoG5AQIf6w//Q3F/Px4PMMiokqTo8OJGorxcRgjznnaS
OR8qlBi6mWO4r/89Q8fLWcZuC5+T7k0C1Ea50oWx/9iNjqRHkL2ToxSw9Atdt6Vq
e2zDbqs6wE19SKGDyyB7XoJ6VlJZdA+7gbVs12WV0t/bRVuTHaxzbHhQt4ttE/pt
iCur11K4drrUsU6gGeSNOeljJ6urWMqYeNhzYlmsstymg1lXpMfUWt4/qeN6jFwW
39kPR+FqwPPzx1HPnjDB6u8KUJ8K7x2l77x/UuolrvdhceXz8y9qWSCgVTI9/lv0
6QnLzAHl8DNsBb8ycqfwKq0btIqBDNokwe03dofLuZlCWm4SvptDtIDIkWCF2ajX
4aLUsSC9rNB69X+nzApB98w/6ipxfTsprZlIVmrGvllLRHW9kK0LOuL9MpXUfzbQ
1wdQTY2sj6kuWhLZLfUh6jry7MYXDnyXbd7GomuWZlHedLn2G8QXrOEXicLoybNA
V8D0LzQPPeCWbjpq0gXLECDydF4yXLyKoXAplSMpC5w+KSjeXFzyQpgh0+D4amWC
vhFZ3uhxcl/O0EwdFK6eaWPPnltMRQ28asqnjJ1FoM5OQQqcBEjjOOf0oOjokTzv
aiIutMVtaEhlIaZRiXknGkXr2x1dY/L4MOPVz0Znl91AObhYZk7aSM2D/+A4on2X
jRAOuiB0gno=
=0/aj
-----END PGP SIGNATURE-----

--Sig_/gV1yydqTrpI.WQ6Fc6MTgmW--
