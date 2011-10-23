Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1JWXEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 19:04:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1JWXEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 19:04:10 -0400
Date: Mon, 24 Oct 2011 10:04:08 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        John Stultz <john.stultz@linaro.org>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
Message-ID: <20111024100408.0627ac02@notabene.brown>
In-Reply-To: <201110231448.23069.rjw@sisk.pl>
References: <20111022093436.0742176c@notabene.brown>
	<Pine.LNX.4.44L0.1110212125020.8657-100000@netrider.rowland.org>
	<20111023192147.49413485@notabene.brown>
	<201110231448.23069.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vKf+coKbl_.x01psco0Bnfk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vKf+coKbl_.x01psco0Bnfk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Oct 2011 14:48:22 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, October 23, 2011, NeilBrown wrote:
> > On Fri, 21 Oct 2011 22:00:13 -0400 (EDT) Alan Stern
> > <stern@rowland.harvard.edu> wrote:
> >=20
> > > On Sat, 22 Oct 2011, NeilBrown wrote:
> > >=20
> > > > > >     It uses files in /var/run/suspend for all communication.
> > > > >=20
> > > > > I'm not so keen on using files for communication.  At best, they =
are
> > > > > rather awkward for two-way messaging.  If you really want to use =
them,
> > > > > then at least put them on a non-backed filesystem, like something=
 under
> > > > > /dev.
> > > >=20
> > > > Isn't /var/run a tmpfs filesystem?  It should be.
> > > > Surely /run is, so in the new world order the files should probably=
 go
> > > > there.   But that is just a detail.
> > >=20
> > > On my Fedora-14 systems there is no /run, and /var/run is a regular=20
> > > directory in a regular filesystem.
> > >=20
> > > > I like files...  I particularly like 'flock' to block suspend.   The
> > > > rest.... whatever..
> > > > With files, you only need a context switch when there is real commu=
nication.
> > > > With sockets, every message sent must be read so there will be a co=
ntext
> > > > switch.
> > > >=20
> > > > Maybe we could do something with futexes...
> > >=20
> > > Not easily -- as far as I can tell, futexes enjoy relatively little=20
> > > support.  In any case, they provide the same service as a mutex, whic=
h=20
> > > means you'd have to build a shared lock on top of them.
> > >=20
> > > > > >     lsusd does not try to be event-loop based because:
> > > > > >       - /sys/power/wakeup_count is not pollable.  This could pr=
obably be
> > > > > >         'fixed' but I want code to work with today's kernel.  I=
t will probably
> > > > >=20
> > > > > Why does this matter?
> > > >=20
> > > > In my mind an event based program should never block.  Every action=
 should be
> > > > non-blocking and only taken when 'poll' says it can.
> > > > Reading /sys/power/wakeup_count can be read non-blocking, but you c=
annot find
> > > > out when it is sensible to try to read it again.  So it doesn't fit.
> > >=20
> > > There shouldn't be any trouble about making wakeup_count pollable.  It
> > > also would need to respect nonblocking reads, which it currently does=
=20
> > > not do.
> >=20
> > Hmm.. you are correct.  I wonder why I thought it did support non-block=
ing
> > reads...
> > I guess it was the code for handling an interrupted system call.
> >=20
> > I feel a bit uncomfortable with the idea of sysfs files that block but I
> > don't think I can convincingly argue against it.
> > A non-blocking flag could be passed in, but it would be a very messy ch=
ange -
> > lots of function call signatures changing needlessly:  we would need a =
flag
> > to the 'show' method ... or add a 'show_nonblock' method which would al=
so be
> > ugly.
> >=20
> >=20
> > But I think there is a need to block - if there is an in-progress event=
 then
> > it must be possible to wait for it to complete as it may not be visible=
 to
> > userspace until then.
> > We could easily enable 'poll' for wakeup_count and then make it always
> > non-blocking, but I'm not really sure I want to require programs to use=
 poll,
> > only to allow them.  And without using poll there is no way to wait.
> >=20
> > As wakeup_count really has to be single-access we could possibly fudge
> > something by remembering the last value read (like we remember the last=
 value
> > written).
> >=20
> > - if the current count is different from the last value read, then retu=
rn
> >   it even if there are in-progress events.
> > - if the current count is the same as the last value read, then block u=
ntil
> >   there are no in-progress events and return the new value.
> > - enable sysfs_poll on wakeup_count by calling sysfs_notify_dirent at t=
he
> >   end of wakeup_source_deactivated .... or calling something in
> >   kernel/power/main.c which calls that.  However we would need to make
> >   sysfs_notify_dirent a lot lighter weight first.  Maybe I should do th=
at.
> >=20
> > Then a process that uses 'poll' could avoid reading wakeup_count except=
 when
> > it has changed, and then it won't block.  And a process that doesn't us=
e poll
> > can block by simply reading twice - either explicitly or by going aroun=
d a=20
> >    read then write and it fails
> > loop a second time.
> >=20
> > I'm not sure I'm completely comfortable with that, but it is the best I=
 could
> > come up with.
>=20
> Well, you're now considering doing more and more changes to the kernel
> just to be able to implement something in user space to avoid making
> some _other_ changes to the kernel.  That doesn't sound right to me.

:-)   I thought I might get challenged on something like that.

I think the cases are different though.

I'm not presenting this code as a new feature.  I don't need new features -
I have user-space code which works correctly with the current kernel featur=
es.

However the precise usage of wakeup_count is a little unusual in that it
blocks when you read.  That doesn't mean that it cannot be used correctly,
but it might limit the options available to a user-space program which wants
to use it.   I was just looking at ways to generalise the existing interface
so that it matches the rest of the kernel better.  I see it much more as a
bug fix than as a new feature.

I'm not saying we need this patch, and I'm not even sure I like it.  I just
presented it as part of exploring exactly how the wakeup_count interface
really works.  It is an interface that I like and that does allow the
original suspend-race problem to be solved, but that does not mean it is
necessarily perfect.

Thanks,
NeilBrown


--Sig_/vKf+coKbl_.x01psco0Bnfk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqSdaDnsnt1WYoG5AQI4GQ/8Ct+cuuG+vvjDru4Lw9JeXoHfYt3krhjS
KpiQ0SS0xTD21QzYOU1ikGSodW3MlSbBz3YOzLDLyj/DoDS51Y50mrksfcOSO1FK
ffSzfv0DbRoyqAvygwjygNe6IfmABdXl7HA23W1BjOisDY/4AkkSHi4bAyVdEa8u
5nXi6TwhFTrP9EfLMXmHjcgGKIoFREUlxsWNpTD4JWdNrT1QAf4T66t3Lpe47acG
fNV/z5qslptRPYK2ilX25i/3zBioSXQXycAIMZ0uLbdg0Y1FsRnHTl2HIVj9exFK
SWqjwQPGQBs8XFoKg7910wVPbmExj7Oa1IYOn+SRZrwbuEJrYkjojgl0142n6lwQ
HzkMlzqO5iXJd1AUlD7oZ5K0fGx7w9tqfZyKmW+1xH3YdcoF+If+n5DZtfU5vsFr
E8BjA2Wcg05h3dKe4K9CGMv1vEJGKsNy380XA8bTNnxSupNOXWuP1EcqWLsYyRPf
KEXMQwp/k22Ab3Toa8oVozFA8TmwmuHaZZJhimM7+nyJoX6o+2Y5r2npUheDRQg/
VJYrFyAUg0bygn2zHxhoRoP7Lt7u+vtAZIwxEdWYgp9c5F8tmwU7rzCg6BLf3mla
uggeGVxrynPwFKwRcx3tp91hUMd8nkoX5hnXtDaqhWh6qWp9JAckfaQbGjIAi7T8
FksmaKYUl7M=
=aBKR
-----END PGP SIGNATURE-----

--Sig_/vKf+coKbl_.x01psco0Bnfk--
