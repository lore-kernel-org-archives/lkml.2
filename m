Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1JYCwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:52:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab1JYCww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:52:52 -0400
Date: Tue, 25 Oct 2011 13:52:44 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111025135244.710e43fa@notabene.brown>
In-Reply-To: <201110241223.43362.rjw@sisk.pl>
References: <201110132145.42270.rjw@sisk.pl>
	<201110231516.36787.rjw@sisk.pl>
	<20111024104444.09337fe6@notabene.brown>
	<201110241223.43362.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/S7.pen0ZomkowCGuJ97bKC/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/S7.pen0ZomkowCGuJ97bKC/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Oct 2011 12:23:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, October 24, 2011, NeilBrown wrote:
> > On Sun, 23 Oct 2011 15:16:36 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wr=
ote:

> > Similarly every system need one process to manage suspend.  It can be my
> > daemon or your daemon or Alan's daemon but it cannot be 2 or more of th=
em
> > running at the same time as that doesn't make any more sense than having
> > systemd and init running at the same time.
>=20
> I agree that it doesn't makes sense.  I don't agree that it implies people
> won't try to do that.

Does that matter?  If they complain, tell them it isn't a supported
configuration.


>=20
> > > > > > So I'd respond with "I'm not at all sure that we should throw a=
way an
> > > > > > all-userspace solution just yet".  Particularly because many of=
 us seem to
> > > > > > still be working to understand what all the issues really are.
> > > > >=20
> > > > > OK, so perhaps we should try to implement two concurrent solution=
s, one
> > > > > kernel-based and one purely in user space and decide which one is=
 better
> > > > > afterwards?
> > > >=20
> > > > Absolutely.
> > > >=20
> > > > My primary reason for entering this discussion is eloquently presen=
ted in
> > > >        http://xkcd.com/386/
> > > >=20
> > > > Someone said "We need to change the kernel to get race-free suspend=
" and this
> > > > simply is not true.  I wanted to present a way to use the existing
> > > > functionality to provide race-free suspend - and now even have code=
 to do it.
> > > >=20
> > > > If someone else wants to write a different implementation, either in
> > > > userspace or kernel that is fine.
> > > >=20
> > > > They can then present it as "I know this can be implemented in user=
space, but
> > > > I don't like that solution for reasons X, Y, Z and so here is my be=
tter
> > > > kernel-space implementation" then that is cool.  We can examine X, =
Y, Z and
> > > > the code and see if the argument holds up.  Maybe it will, maybe no=
t.
> > > >=20
> > > > So far the only arguments I've seen for putting the code in the ker=
nel are:
> > > >=20
> > > >  1/ it cannot be done in userspace - demonstrably wrong
> > >=20
> > > I'm not sure if that's correct.  If you meant "it can be done in user=
 space
> > > without _any_ kernel modifications", I probably wouldn't agree.
> >=20
> > I have code to do it correctly today with no kernel modifications.  It =
is
> > called "lsusd".   Proof by example.  Or can you show that lsusd doesn't=
 work
> > correctly?
>=20
> So why do you consider making changes to the kernel (described in the oth=
er
> part of the thread)?  Are they completely cosmetic or are they needed for
> functionality?

Not needed.  Maybe helpful.

I have suggested three kernel changes - with varying levels of seriousness.

1/ Changes to wakeup_count so that it can be read without blocking.
   This is currently just a "general cleanliness" issue.  It could become
   more of an issue if some kernel code activated a wakeup_source for a long
   time.
   It is not a problem at all for my current code, but if we wanted a single
   suspend daemon that didn't need threads or a helper process, then it mig=
ht
   become an issue.

2/ Changes to flock locking so that a process can get notified when a
   lock attempt might succeed.  This is just me grumbling about incomplete
   locking semantics and has nothing to do with power management directly.

3/ Activating a wakeup_source when an RTC alarm fires.  This patch was
   proposed by John Stultz - I just supported it.
   It isn't strict necessary as the suspend daemon can check the RTC
   just before suspending and refuse to suspend in the alarm will fire in t=
he
   next 2 seconds.
   However this assumes that the suspend will then complete within 2 second=
s.
   This seems likely but I don't know that it is guaranteed.  The 2 second
   window could be extended, but that isn't really ideal.
   So this is one kernel change that could be deemed to be "necessary".
   However it isn't really a chance in design at all - it just acknowledges
   that the RTC alarm is a wakeup source, so registers a wakeup_source for
   it, so it is really just a bug fix.
   I'm still interested to know what you think of this patch.  While it isn=
't
   strictly needed I think it would be very helpful.

   (Without this, alarmtimers is racy too ... and  it doesn't even insert a
    2 second window .... I'm not really convinced alarmtimers is a good thi=
ng
    but it isn't clear that it is a bad thing either).

NeilBrown

--Sig_/S7.pen0ZomkowCGuJ97bKC/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqYkfTnsnt1WYoG5AQLTshAAu80li4EPRlAJVteifZVIUYFt+gAcEJlI
pgSz2c+8a+oZJBF8C3GVJAiABLfRlICGm5XIfwftzomVJbTJt7+HVNNG7wUNlPGg
ukvt9G7V30FcRWFumZXMuaI85IiCUvmPCxHYcGEnTcEaQzT5DzkkDPHGtXWsdKpY
JTn7eSaYVg0JJEH7jCXLz9Nnxf5MFGy+NYzI2xVUQj+WegVfLcA6szv1cetj+Vqu
cxRgZycIUKvIqOnd/cNJvHSZNPB2SzvS7DF1BMl3X4q74zCauwlP6INkFgaAQat0
T08Xb9m91sOkZl+h+YWkZFyYSXC2TPUG8BEtElmWdD0G+vUkgtMKyIY38dzfCghi
n101QNLVlgySSuw3xEqVPmjm0K64vUy3t1NKMEURhwNrMUFVW5bCd1XsLxfKmLCL
E0JuFIA1b8oEp8FXQjRT6wFpjXKIliiMVr1VB7eu+R8qPQHfhabplZGOE2A51xpb
e0odMVsY2V0yFkAXlaVjxn5qsUib3pldxQgm10LCLHtg3JfSfQQ7x3z6Z9xD7QWK
ETsePmJzN5ca0HFXq+Yg8L03ohG1f7QFPWpiKQALTFTno8kjKQsbX3pdy1qSVJiK
4e1lJCD57NwMKYO+Uvw+uSvG2LO5whXrkTokvmeCutHW4PTzHMKRPHS4D2JhDbvx
lnSyLeEdDbU=
=OBPx
-----END PGP SIGNATURE-----

--Sig_/S7.pen0ZomkowCGuJ97bKC/--
