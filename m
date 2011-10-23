Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1JWC57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 22:57:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab1JWC56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 22:57:58 -0400
Date: Sun, 23 Oct 2011 13:57:45 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111023135745.2bfe1d80@notabene.brown>
In-Reply-To: <201110230007.33683.rjw@sisk.pl>
References: <201110132145.42270.rjw@sisk.pl>
	<201110180002.30932.rjw@sisk.pl>
	<20111018103631.6943a97a@notabene.brown>
	<201110230007.33683.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZC/LVpSigskvVeI/a/Z6xgZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZC/LVpSigskvVeI/a/Z6xgZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Oct 2011 00:07:33 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, October 18, 2011, NeilBrown wrote:
> > On Tue, 18 Oct 2011 00:02:30 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wr=
ote:
> >=20
> > > On Monday, October 17, 2011, NeilBrown wrote:
> > > > On Sun, 16 Oct 2011 00:10:40 +0200 "Rafael J. Wysocki" <rjw@sisk.pl=
> wrote:
> > > ...
> > > > >=20
> > > > > >  But I think it is very wrong to put some hack in the kernel li=
ke your
> > > > > >    suspend_mode =3D disabled
> > > > >=20
> > > > > Why is it wrong and why do you think it is a "hack"?
> > > >=20
> > > > I think it is a "hack" because it is addressing a specific complain=
t rather
> > > > than fixing a real problem.
> > >=20
> > > I wonder why you think that there's no real problem here.
> > >=20
> > > The problem I see is that multiple processes can use the suspend/hibe=
rnate
> > > interfaces pretty much at the same time (not exactly in parallel, bec=
uase
> > > there's some locking in there, but very well there may be two differe=
nt
> > > processes operating /sys/power/state independently of each other), wh=
ile
> > > the /sys/power/wakeup_count interface was designed with the assumptio=
n that
> > > there will be only one such process in mind.
> >=20
> > Multiple process can write to your mail box at the same time.  But some=
 how
> > they don't.  This isn't because the kernel enforces anything, but becau=
se all
> > the relevant programs have an agreed protocol by which they arbitrate a=
ccess.
> > One upon a time this involved creating a lock file with O_CREAT|O_EXCL.
> > These days it is fcntl locking.  But it is still advisory.
> >=20
> > In the same way - we stop multiple processes from suspending/hibernatin=
g at
> > the same time by having an agreed protocol by which they share access t=
o the
> > resource.  The kernel does not need to be explicitly involved in this.
>=20
> Not really.  The main difference is that such a protocol doesn't exist for
> processes that may want to suspend/hibernate the system.
>=20
> Moreover, the race is real, because if you have two processes trying to u=
se
> /sys/power/wakeup_count at the same time, you can get:
>=20
> Process A		Process B
> read from wakeup_count
> talk to apps
> write to wakeup_count
> --------- wakeup event ----------
> 			read from wakeup_count
> 			talk to apps
> 			write to wakeup_count
> try to suspend -> success (should be failure, because the wakeup event
> may still be processed by applications at this point and Process A hasn't
> checked that).
>=20
> Now, there are systems running two (or more) desktop environments each of
> which has a power manager that may want to suspend on it's own.  They both
> will probably use pm-utils, but then I somehow doubt that pm-utils is well
> prepared to handle such concurrency.

I think that "upowerd" is the current "solution" to this problem.  Different
desktops can communicate with it to negotiate when suspend will happen.

When upowerd decides to suspend, it calls the relevant pm_utils command.

So with modern desktops we would never expect two different processes to be
requesting pm_utils to suspend at the same time.  If we did that would be a
problem  but we don't.  There is no race here to fix.

I'm not certain that upowerd provides good interfaces.  But its existence
shows that this sort of problem that you see is not that hard to solve.

Sure: people could still design systems  which exhibited racy access to
suspend, but people have always being able to write buggy code - making up
new interfaces isn't going to stop them.



>=20
> >=20
> > ...
> >=20
> > > > > Well, I used to think that it's better to do things in user space=
.  Hence,
> > > > > the hibernate user space interface that's used by many people.  A=
nd my
> > > > > experience with that particular thing made me think that doing th=
ings in
> > > > > the kernel may actually work better, even if they _can_ be done i=
n user space.
> > > > >=20
> > > > > Obviously, that doesn't apply to everything, but sometimes it sim=
ply is worth
> > > > > discussing (if not trying).  If it doesn't work out, then fine, l=
et's do it
> > > > > differently, but I'm really not taking the "this should be done i=
n user space"
> > > > > argument at face value any more.  Sorry about that.
> > > >=20
> > > > :-)  I have had similar mixed experiences.   Sometimes it can be a =
lot easier
> > > > to get things working if it is all in the kernel.
> > > > But I think that doing things in user-space leads to a lot more fle=
xibility.
> > > > Once you have the interfaces and designs worked out you can then st=
art doing
> > > > more interesting things and experimenting with ideas more easily.
> > > >=20
> > > > In this case, I think the *only* barrier to a simple solution in us=
er-space
> > > > is the pre-existing software that uses the 'old' kernel interface. =
 It seems
> > > > that interfacing with that is as easy as adding a script or two to =
pm-utils.
> > >=20
> > > Well, assuming that we're only going to address the systems that use =
PM utils.
> >=20
> > I suspect (and claim without proof :-) that any system will have some s=
ingle
> > user-space thing that is responsible for initiating suspend.
>=20
> Well, see above.

See also upowerd.


>=20
> > Every time I look at one I see a whole host of things that need to be d=
one
> > just before suspend, and other things just after resume.
> > They used to be in /etc/apm/event.d.  Now there are
> > in /usr/lib/pm-utils/sleep.d.
>=20
> I know of systems that don't need those hooks, however.
>=20
> > I think they were in /etc/acpid once.
> > I've seen one thing that uses shared-library modules instead of shell s=
cripts
> > on the basis that it avoids forking and goes fast (and it probably does=
).
> > But I doubt there is any interesting system where writing to /sys/power=
/state
> > is the *only* thing you need to do for a clean suspend.
>=20
> I have such a system on my desk. :-)

:-)
I guess I would have to conclude that it is therefore not interesting :-)

Would you accept that is more of an exception than the rule?

The real point though is that lots of system do want pre/post scripts, so we
can expect that avoiding races between such scripts is a solved problem - a=
nd
this is what we find in e.g. upowerd.


>=20
> > So all systems will have some user-space infrastructure to support susp=
end,
> > and we just need to hook in to that.
> >=20
> >=20
> > >=20
> > > > With that problem solved, experimenting is much easier in user-spac=
e than in
> > > > the kernel.
> > >=20
> > > Somehow, I'm not exactly sure if we should throw all kernel-based sol=
utions away
> > > just yet.
> >=20
> > My rule-of-thumb is that we should reserve kernel space for when
> >   a/ it cannot be done in user space
> >   b/ it cannot be done efficient in user space
> >   c/ it cannot be done securely in user space
> >=20
> > I don't think any of those have been demonstrated yet.  If/when they ar=
e it
> > would be good to get those kernel-based solutions out of the draw (so y=
es:
> > keep them out of the rubbish bin).
>=20
> I have one more rule.  If my would-be user space solution has the followi=
ng
> properties:
>=20
> * It is supposed to be used by all of the existing variants of user space
>   (i.e. all existing variants of user space are expected to use the very =
same
>   thing).
>=20
> * It requires all of those user space variants to be modified to work wit=
h it
>   correctly.
>=20
> * It includes a daemon process having to be started on boot and run perma=
nently.
>=20
> then it likely is better to handle the problem in the kernel.

By that set or rules, upowerd, dbus, pulse audio, bluez, and probably syste=
md
all need to go in the kernel.  My guess is that you might not find wide
acceptance for these rules.


>=20
> > So I'd respond with "I'm not at all sure that we should throw away an
> > all-userspace solution just yet".  Particularly because many of us seem=
 to
> > still be working to understand what all the issues really are.
>=20
> OK, so perhaps we should try to implement two concurrent solutions, one
> kernel-based and one purely in user space and decide which one is better
> afterwards?

Absolutely.

My primary reason for entering this discussion is eloquently presented in
       http://xkcd.com/386/

Someone said "We need to change the kernel to get race-free suspend" and th=
is
simply is not true.  I wanted to present a way to use the existing
functionality to provide race-free suspend - and now even have code to do i=
t.

If someone else wants to write a different implementation, either in
userspace or kernel that is fine.

They can then present it as "I know this can be implemented in userspace, b=
ut
I don't like that solution for reasons X, Y, Z and so here is my better
kernel-space implementation" then that is cool.  We can examine X, Y, Z and
the code and see if the argument holds up.  Maybe it will, maybe not.

So far the only arguments I've seen for putting the code in the kernel are:

 1/ it cannot be done in userspace - demonstrably wrong
 2/ it is more efficient in the kernel - not demonstrated or even
    convincingly argued
 3/ doing it in user-space is too confusing - we would need a clear
    demonstration that a kernel interface is less confusing - and still
    correct.  Also the best way to remove confusion is with clear
    documentation and sample code, not by making up new interfaces.
 4/ doing it in the kernel makes it more accessible to multiple desktops.
    The success of freedesktop.org seems to contradict that.

So if you can do it a "better" way, please do.  But also please make sure
you can quantify "better".   I claim that user-space solutions are "better"
because they are more flexible and easier to experiment with.  The "no
regressions" rule actively discourages experimentation in the kernel so
people should only do it if there is a clear benefit.  User-space solutions
are much easier to introduce and then deprecate.

Thanks,
NeilBrown


--Sig_/ZC/LVpSigskvVeI/a/Z6xgZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqOCrznsnt1WYoG5AQJjcw/9FTeRI4Nce8PQo05MLE2FgIzjB3vtzLTS
OwBCipYHL8PLwWiP56LMRV04K7OHGv3ziN1eQgP/kPq/BsIJ9spnJHbsspkve4j5
EN3+I6GQ80HAfEpu1i03swO6BS3BZizHNuHKcMyGXRc9sdGdb0ZDpkGEpS8i/+9g
PwKvrCgKabkN0ySVr5zbOKFdr1Fd3umBjTtvSvI/5G1Pz98+t6yxkIpo1q7VV2H9
ujoLbSANKYpTEZbpYCCGYF600KBhw3BSSoXHpEQ4cF/8sbCjG6bXeDXjwg4T2Dml
nIK2jqbAHryhISyDhHrMPj6NzQpBwSJiipCMMVuvtG2kCQiditXVKsTOe3FL2eSV
2aNe2sRIVk0n3bsDyKn16HzCwBYKmQ6KV4VT/FR8Ll+LXFFRpCvzWg3EZuVeRBYe
sf3gv+0iKvrRlc/6x928v9K2sUVc6rV30juOgQtcZuPBhYjndrXhQdouH6f3Pqh4
7owvmOHcAWUfY1VL2UwZwa78vopDj/zGaWU7jhOUkjpj3bGSHzIy5YDhzT519MHh
NKWw2tMkttt8Fy8fhMDVpDqsXo0IvwM4uIyXk1ht/U7NoJu3bB+19QnlygzvB4jn
RV1hiAHH+ucJ91C0epQM8JG4IrphzRKhlOXz/9GPs5WUB6RZWN236dyGk2aqtOp6
zqRxkhsVB58=
=/Oti
-----END PGP SIGNATURE-----

--Sig_/ZC/LVpSigskvVeI/a/Z6xgZ--
