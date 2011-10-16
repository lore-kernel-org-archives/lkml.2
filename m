Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1JPXsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 19:48:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1JPXso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 19:48:44 -0400
Date: Mon, 17 Oct 2011 10:48:27 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111017104827.52a90114@notabene.brown>
In-Reply-To: <201110160010.40639.rjw@sisk.pl>
References: <201110132145.42270.rjw@sisk.pl>
	<20111014165212.7929243c@notabene.brown>
	<201110160010.40639.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w_3HfR_5IRQFIw8xcmFPa.g"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/w_3HfR_5IRQFIw8xcmFPa.g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 16 Oct 2011 00:10:40 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
>=20
> On Friday, October 14, 2011, NeilBrown wrote:
> > On Thu, 13 Oct 2011 21:45:42 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wr=
ote:
> ...
> >=20
> > Hi Rafael,
> >=20
> >  What do you mean by "too complicated to use in practice"?  What is you
> >  measure for complexity?
>=20
> I, personally, don't really know what the difficulty is, as I have already
> described this approach for a few times (for example, in Section 5 of the
> article at http://lwn.net/images/pdf/suspend_blockers.pdf).  However, I've
> recently talked to a few people whom I regard as smart and who had tried
> to implement it and it didn't work for them, and they aren't really able
> to say why exactly.  Thus I have concluded it has to be complicated, but
> obviously you're free to draw your own conclusions. :-)
>=20
> [BTW, attempts to defend the approach I have invented against myself are
>  extremely likely to fail, pretty much by definition. ;-)]

:-)   Maybe we can defend it together then.


>=20
> >  Using suspend in a race-free way is certainly less complex than - for
> >  example - configuring bluetooth.
> >  And in what way is it "inadequate for other reasons"? What reasons?
>=20
> Consider the scenario described by John (the wakeup problem).  A process
> has to do something at certain time and the system shouldn't be suspended
> while the process is doing that, although it very well may be suspended
> earlier or later.  The process puts itself to sleep with the assumption
> that a wake alarm is set (presumably by another process) to wake the syst=
em
> up from suspend at the right time (if the suspend happens).  However, the
> process itself doesn't know _exactly_ what time the wake alarm is set to.
>=20
> In the situation in which we only have the existing mechanism and a user =
space
> power manager daemon, this scenario appears to be inherently racy, such t=
hat it
> cannot be handled correctly.

I would suggest that we need a time-management daemon - whether it ends up
being cron or systemd or scripts in pm-utils or some new daemon is just an
implementation detail.

i.e. we need a way for a process to say "I have something to do a X o'clock=
".
Whatever provides this service needs to hook in to the suspend logic and wh=
en
a suspend is about to happen, it programs the RTC alarm to wake up at (or
just before) the earliest requested time.
When the time arrives, the service blocks suspend and replies to the origin=
al
process "OK, do your thing".  The process takes over blocking of suspend,
acknowledges the wakeup, and does the backup or whatever.

So yes: we do need something new, but it is easy enough to do all in
user-space.

One important part of this is that an RTC alarm needs to be treated as a
wakeup_event and have a wakeup_source activated for it.  I suspect you could
avoid the need for that by having the suspend daemon know about programming
the RTC alarm and to simply not suspend at a bad time.
John Stultz posted a patch to add a wakeup_source for the RTC.  What do you
think of that.  Is a wakeup_source sensible here, or should user-space just
be careful about not suspending when a RTC alarm is likely soon ??

.... Actually, the more I think about it, the more sense it makes to include
the wake-up-at-time service with the suspend-daemon.  Then the RTC alarm
doesn't need a wakeup_source.
So my hypothetical suspend-daemon provides 2 services:
 1/ Client can say "Don't suspend after X".  If X is in the past it means
    don't suspend at all. In the future it means "If you suspend before
    this, be sure to wake up by X".  This request must be explicitly
    cancelled (though some mechanism is needed so that if the process dies
    it is automatically cancelled).
 2/ Client can say "check with me before entering suspend".  Client needs to
    respond to any callback promptly, but can register a "don't suspend aft=
er
    now" request first.
    (Client probably gets a callback both on suspend and resume)
=20
>=20
> >  The only sane way to handle suspend is for any (suitably privileged) p=
rocess
> >  to be able to request that suspend doesn't happen, and then for one pr=
ocess
> >  to initiate suspend when no-one is blocking it.
>=20
> As long as you don't specify the exact way by which the request is made a=
nd
> how the suspend is blocked, the above statement is almost meaningless.

The meaning is in the style of request.  Requests should be "don't suspend =
at
them moment", not "do suspend now".  I didn't intend it to carry more meani=
ng
than that.


>=20
> >  This is very different from the way it is currently handled were the G=
UI
> >  says "Hmm.. I'm not doing anything just now, I think I'll suspend".
> >=20
> >  The later simply doesn't scale.  It is broken.  It has to be replaced.
> >  And it is being replaced.
>=20
> Cool, good to hear that! :-)

I might have spoken too soon there :-(
I looked more deeply at how gnome power management works and it is deeply
structures around request to go to sleep, not requests to stay awake.


>=20
> >  gnome-power-manage has a dbus interface on which you can request
> >  "InhibitInactiveSleep".  Call that will stop gnome-power-manager from
> >  sleeping (I assume - haven't looked at the code).
> >  It might not inhibit an explicit request for sleep - in that case it is
> >  probably broken and needs to be fixed.  But is can be fixed.  Or repla=
ced.
>=20
> Perhaps.
>=20
> Is KDE going to use the same mechanism, for one example?  And what about =
other
> user space variants?  MeeGo anyone?  Tizen?  Android??
>=20
> >  So if someone is running gnome-power-manager and wants to perform a fi=
rmware
> >  update, the correct thing to do is to use dbus to disable the inactive=
 sleep.
> >  If someone is using some other power manager they might need to use so=
me
> >  other mechanism.  Presumably these things will be standardised at some=
 stage.
>=20
> Unless you have a specific idea about how to make this standardization ha=
ppen,
> I call it wishful thinking to put it lightly.  Sorry about the harsh word=
s, but
> that's how it goes IMNSHO.=20

Standardisation will happen when enough people see a problem.  As yet it
seems that they don't.
Once there are enough Linux devices running open desktops and needing good
power management (i.e. suspend often) that people start seeing problems,
there will be more motivation to create solutions.

Currently, we just need to be sure that the kernel *can* provide the needed
functionality and, if we like, experiment with user-space code to make use =
of
that functionality in an effective way.

If enough people experiment, learn, and publish their results - then the mo=
re
successful implementations will eventually spread...

>=20
> >  But I think it is very wrong to put some hack in the kernel like your
> >    suspend_mode =3D disabled
>=20
> Why is it wrong and why do you think it is a "hack"?

I think it is a "hack" because it is addressing a specific complaint rather
than fixing a real problem.

Contrast that with your wakeup_events which are a carefully designed approa=
ch
addressing a real problem and taking into account the big picture.

i.e. it seems to be addressing a symptom rather addressing the cause.

(and it is wrong because "hacks" are almost always wrong - short-term gain,
long term cost).


>=20
> >  just because the user-space community hasn't got its act together yet.
>=20
> Is there any guarantee that it will get its act together in any foreseeab=
le
> time frame?
>=20
> >  And if you really need a hammer to stop processes from suspending the =
system:
> >=20
> >    cat /sys/power/state > /tmp/state
> >    mount --bind /tmp/state /sys/power/state
> >=20
> >  should to it.
>=20
> Except that (1) it appears to be racy (what if system suspend happens bet=
ween
> the first and second line in your example - can you safely start to upgra=
de
> your firmware in that case?) and (2) it won't prevent the hibernate inter=
face
> based on /dev/snapshot from being used.
>=20
> Do you honestly think I'd propose something like patch [1/2] if I didn't
> see any other _working_ approach?

I think there are other workable approaches  (maybe not actually _working_,
but only because no-one has written the code).

I'm not saying we should definitely not add more functionality to the kerne=
l,
but I am saying we should not do it at all hastily.

If someone has tried to use the current functionality, has really understood
it, has made an appropriate attempt to make use of it, and has found that
something cannot be make to work reliably, or efficiently, or securely or
whatever, then certainly consider ways to address the problems.

But I don't think we are there yet.  We are only just getting to the
"understanding" stage (and I have found these conversations very helpful in
refining my understanding).

When I get my GTA04 (phone motherboard) I hope to write some code that
actually realises these idea properly (I have code on my GTA02, but it is
broken in various ways, and the kernel is too old to
have /sys/power/wakeup_count anyway).


>=20
> >  You second patch has little to recommend it either.
> >  In the first place it seems to be entrenching the notion that timeouts=
 are a
> >  good and valid way to think about suspend.
>=20
> That's because I think they are unavoidable.  Even if we are able to elim=
inate
> all timeouts in the handling of wakeup events by the kernel and passing t=
hem
> to user space, which I don't think is a realistic expectation, the user w=
ill
> still have only so much time to wait for things to happen.  For example, =
if
> a phone user doesn't see the screen turn on 0.5 sec after the button was
> pressed, the button is pretty much guaranteed to be pressed again.  This
> observation applies to other wakeup events, more or less.  They are very =
much
> like items with "suitability for consumption" timestamps: it they are not
> consumed quickly enough, we can simply forget about them.

I hadn't thought of it like that - I do see your point I think.
However things are usually consumed long before they expire - expiry times
are longer than expected shelf life.
I think it is important to think carefully about the correct expiry time for
each event type as they aren't all the same.
So I would probably go for a larger default which is always safe, but
possibly wasteful.  But that is a small point.

>=20
> >  I certainly agree that there are plenty of cases where timeouts are
> >  important and necessary.  But there are also plenty of cases where you=
 will
> >  know exactly when you can allow suspend again, and having a timeout th=
ere is
> >  just confusing.
>=20
> Please note that with patch [2/2] the timeout can always be overriden.
>=20
> >  But worse - the mechanism you provide can be trivially implemented usi=
ng
> >  unix-domain sockets talking to a suspend-daemon.
> >=20
> >  Instead of opening /dev/sleepctl, you connect to /var/run/suspend-daem=
on/sock
> >  Instead of ioctl(SLEEPCTL_STAY_AWAKE), you write a number to the socke=
t.
> >  Instead of ioctl(SLEEPCTL_RELAX), you write zero to the socket.
> >=20
> >  All the extra handling you do in the kernel, can easily be done by
> >  user-space suspend-daemon.
>=20
> I'm not exactly sure why it is "worse".  Doing it through sockets may req=
uire
> the kernel to do more work and it won't be possible to implement the
> SLEEPCTL_WAIT_EVENT ioctl I've just described to John this way.

"worse" because it appears to me that you are adding functionality to the
kernel which is effectively already present.  When people do that to meet a
specific need it is usually not as usable as the original.  i.e. "You have
re-invented XXX - badly".  In this case XXX is IPC.

Yes - more CPU cycles may be expended in the user-space solution than a
kernel space solution, but that is a trade-off we often make.  I don't think
that suspend is a time-critical operation - is it?

And I think SLEEPCTL_WAIT_EVENT would work fine over sockets, particularly
instead of a signal being sense, a simple short message were sent back over
the socket.




>=20
> >  I really wish I could work out why people find the current mechanism
> >  "difficult to use".  What exactly is it that is difficult?
> >  I have describe previously how to build a race-free suspend system.  W=
hich
> >  bit of that is complicated or hard to achieve?  Or which bit of that c=
annot
> >  work the way I claim?  Or which need is not met by my proposals?
> >=20
> >  Isn't it much preferable to do this in userspace where people can
> >  experiment and refine and improve without having to upgrade the kernel?
>=20
> Well, I used to think that it's better to do things in user space.  Hence,
> the hibernate user space interface that's used by many people.  And my
> experience with that particular thing made me think that doing things in
> the kernel may actually work better, even if they _can_ be done in user s=
pace.
>=20
> Obviously, that doesn't apply to everything, but sometimes it simply is w=
orth
> discussing (if not trying).  If it doesn't work out, then fine, let's do =
it
> differently, but I'm really not taking the "this should be done in user s=
pace"
> argument at face value any more.  Sorry about that.

:-)  I have had similar mixed experiences.   Sometimes it can be a lot easi=
er
to get things working if it is all in the kernel.
But I think that doing things in user-space leads to a lot more flexibility.
Once you have the interfaces and designs worked out you can then start doing
more interesting things and experimenting with ideas more easily.

In this case, I think the *only* barrier to a simple solution in user-space
is the pre-existing software that uses the 'old' kernel interface.  It seems
that interfacing with that is as easy as adding a script or two to pm-utils.

With that problem solved, experimenting is much easier in user-space than in
the kernel.

Thanks,
NeilBrown




>=20
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/w_3HfR_5IRQFIw8xcmFPa.g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpttUjnsnt1WYoG5AQLmbA/+NL+55/NnxTy3DZbq48INrIJAnz8fkEF1
G/9BuyvfwDy/h7BZ0MmjEtr2qej5AAn5BD5UsCqIl8M4gTfXU47Tcs8dkfXWQ4a0
J9WSdnARzi0jr18hswoCDU5+sBrwMoKyCVr6JXEtpmuw1+KM2VGahA62VpgcVCE3
D4wCDpRdUzwbcCMDXQlE+8gdEQQX3vh4wj6/RSGamaqO/MjiiTrOK8o4W3311zfp
+WB8S2zNu9AbjOPAWntwWDdKK0lI1VhlQeRANSjOTviho0pc6qMpjmRP4VlsugbS
hdVxzYrZ0SnhzOeE35aqeIzGL00twpSfsZZo6fRoZSFWon12/U0848mdXhIWLo/g
zcuSVf44xe9MJxZ8ACp1JxG2vETMAu5ECbNmgzHQtwp1hu8t8ZRGQT5xFyvoZy/y
wLloaOz5n7l6nsYKtbUsE/kwv8C0k3zQZFqZhuI0mP3fsLHny/+JJll3TKP9+iH4
X8tSGB0XseBOBF4MklHlljhzuho7cMzjcjMpQOw6RvyMDlwjeMMLRfcqRWIgM62h
bmiS32wqQxQnqldpwmm1N2J6j/nFMy01vQG6v/t/7QIrH/yCyvADbBPBo3e5Ggag
55w2dXRWVJs81fRTNRtkdWjkiYjZVqJqqNzQ7X5IiJHwM4IN9a6EnimlvV264bLC
4m5yyTHSW24=
=a8Oi
-----END PGP SIGNATURE-----

--Sig_/w_3HfR_5IRQFIw8xcmFPa.g--
