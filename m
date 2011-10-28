Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1J1ACW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:02:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1J1ACV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:02:21 -0400
Date: Fri, 28 Oct 2011 11:02:15 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111028110215.0cc5175f@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110231122430.4497-100000@netrider.rowland.org>
References: <201110230007.33683.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1110231122430.4497-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NVz7az+G73ia89f/noBX3+2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NVz7az+G73ia89f/noBX3+2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Oct 2011 11:50:40 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Sun, 23 Oct 2011, Rafael J. Wysocki wrote:
>=20
> > Moreover, the race is real, because if you have two processes trying to=
 use
> > /sys/power/wakeup_count at the same time, you can get:
> >=20
> > Process A		Process B
> > read from wakeup_count
> > talk to apps
> > write to wakeup_count
> > --------- wakeup event ----------
> > 			read from wakeup_count
> > 			talk to apps
> > 			write to wakeup_count
> > try to suspend -> success (should be failure, because the wakeup event
> > may still be processed by applications at this point and Process A hasn=
't
> > checked that).
> >=20
> > Now, there are systems running two (or more) desktop environments each =
of
> > which has a power manager that may want to suspend on it's own.  They b=
oth
> > will probably use pm-utils, but then I somehow doubt that pm-utils is w=
ell
> > prepared to handle such concurrency.
>=20
> I have no objection to adding a kernel-based mechanism for restricting
> the suspend interface to one process at a time.  However, that's just
> part of your most recent proposal.  The other part involves
> coordinating the requirements of all the processes that may want to
> prevent the system from suspending, which is a harder job.
>=20
>=20
> > I have one more rule.  If my would-be user space solution has the follo=
wing
> > properties:
> >=20
> > * It is supposed to be used by all of the existing variants of user spa=
ce
> >   (i.e. all existing variants of user space are expected to use the ver=
y same
> >   thing).
> >=20
> > * It requires all of those user space variants to be modified to work w=
ith it
> >   correctly.
> >=20
> > * It includes a daemon process having to be started on boot and run per=
manently.
> >=20
> > then it likely is better to handle the problem in the kernel.
>=20
> This reasoning doesn't apply to the second problem of allowing
> processes to block suspend.  Whether the solution is implemented in the
> kernel or as a daemon, other programs will have to be modified to
> accomodate it.
>=20
> In fact, if it's done properly then these other programs should each
> need only a single set of modifications; the differences involved in=20
> communicating with the kernel vs. a daemon could be encapsulated in a=20
> shared library.
>=20
>=20
> Overall, I think the discussion is getting a little muddled because of
> a significant problem that has not yet been addressed sufficiently.
>=20
> There is a big difference between Android's kernel wakelocks and the
> currently proposed use of wakeup_sources.  In Android, a kernel
> wakelock associated with an input device isn't released until the
> device's queue becomes empty, whereas we have been talking about
> releasing the corresponding wakeup_source as soon as data added to
> the queue becomes visible to userspace.
>=20
> This is quite a significant difference.  It means there's a window of
> time (from when the data is added to the queue to when it is removed) =20
> during which userspace is forced to cope with suspend races, instead of
> letting the kernel handle things.  This is what leads to our problems
> about sending fd's to the daemon process and sending a request to each
> client before the daemon starts a suspend.
>=20
> (Other aspects of this problem that haven't been mentioned before: What
> happens when a client program using the notify-fd API wants to close
> one of the wakeup-capable fd's?  It would have to tell the daemon to
> close its copy of the fd as well.  And likewise, a client would have to=20
> inform the daemon whenever it opened a new wakeup-capable device file.)

In my current code the client only associates a single event fd with each
socket to the server, and when the client closes that socket, the fd gets
closed (though there are rough edges I think).
Teaching the client to use multiple fds per socket would not be difficult.
The biggest challenge would be choosing labels to use to identify the fds so
it can ask the server to close them - and that isn't hard.
But I certainly agree that this needs to be properly thought through and
resolved.

>=20
> Now, in the end, I think our approach makes more sense in a general=20
> setting.  The Android approach is okay for a restricted environment=20
> where you know beforehand exactly which devices will be wakeup-capable=20
> and which wakeup events will be monitored by userspace programs.  But=20
> for the whole range of Linux-based systems, the kernel can't rely on=20
> such information.

I think that is exactly right.  The Android code is understandable written
to particularly suit the Android context and may not be generally applicabl=
e.
I think the Android folk understand this and don't insist on having exactly
that code merged.  They just want the same functionality with the same
efficiency without unnecessary change to user-space.


>=20
> (If you think back to the original wakelock patches, for example,
> you'll remember that the patch descriptions were expressed in terms of
> what happens as the screen is turned on and off.  Obviously this is
> meaningless for systems that, unlike an Android phone, don't have a
> built-in screen.  I complained about this at the time, and the Android
> people seemed to have a hard time understanding what I was objecting
> to.)
>=20
> So this is really our biggest problem.  If we can figure out a really
> good way to solve it, I predict we'll find that the kernel-based and
> daemon-based suspend solutions are extremely similar.

Actually I think our biggest problem is - and has always been - communicati=
on
and understanding :-)

There are probably a dozen or more ways to solve this problem, each of which
has some impact on the kernel and some impact on the Android user-space.

We need an effective dialogue (we have had plenty of ineffective dialogue)
between people who know and care about Android and people who know and care
about the kernel.

I think we are having a useful discussion, but I think it would be much more
useful if we had some inside perspective and engagement with Android.

So I have added a Cc to Brian Swetland, hoping - Brian - that you might be
able to provide some insight - or maybe tell us where this discussion is
already happening and already progressing (maybe I missed something).

I'm particularly interested in:
 - is it fair to say that all wakeup events are - or could be - available to
   user-space though an 'fd' which reports POLLIN when an event is pending?
   If not - could you list some of those other wakeup events?
 - does a process that is handling wakeup events always "know" they are (or
   could be) wakeup events and so could take some extra action?  (assume for
   the moment that the action is free, it just has to be done for fds
   receiving wakeup events, and not for other fds).
 - How performance-sensitive is the opportunistic suspend event?  i.e. I'm
   assuming there are a collection of user-space and kernel-space things th=
at
   block and unblock suspend from time to time.  At some point the last blo=
ck
   is removed and the system should then enter suspend.  What sort of laten=
cy
   is acceptable at that point (microseconds? milliseconds?) and what sort =
of
   frequency would we expect that to happen (100HZ? 10HZ? 1HZ?  0.01HZ??)

I think answers to those would help a lot to parameterise the problem space.

Thanks,
NeilBrown

--Sig_/NVz7az+G73ia89f/noBX3+2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqnxDTnsnt1WYoG5AQJGKhAArp2nKQ9Y11SObZWZWA3V3a9O3i1XqUC2
+N6R1FYqme4E7+DgAmLp20jmDecgFCt1zExS3U8RC29Wd25KjkGoRfEBzeNNFqKq
cekp9EJ4+a1tKu8YITWGBxn89WWCdmZ5hB7FhQla0c/WTxcmYG6fRsFHNaa4rdax
JbrnZ6M0DMmTHHC0xg3NJaEoKV/pNIfqpxHs4TWh6KjmKaTsW9nxLp9EvoxVNBTO
drA8qM5eZAhHasX2iJMHnx0UFDi1l/kF6VidCiOfbLIg/OOX1rLFONIvj3FrBvXW
IbgtD84+jwMeWPtAg6LCMm3ecBRzG0YxcrDCLUdIlkwxpMogBZynlOCJUHUTQwQb
ykTJmS3ukhxar3JKkcOuqwN8Oo1pfMNh+PHXIFGYuA16UNUpI6ZWkapV6UAaJSGJ
5lbJg+OAGsQHSgoN260e1NJftpZFDksYhMcxEoygWZxa5DZP5WdB87hfHmm6X1E+
UJEZAD1vC2oDPmsCZz7RtyX3Bc//gbARc7JbZYziSiBaQ8Y3hScWjEd9LOBgiBs8
OpxKwopYNFxFIKagf8dG4Op46TIZZwkx+apf6Bv7n+cKnaEmeIO+Xcga+rseXeIE
5jde1J2xbQ3WCG15g8M16xb/SN7iqSI8X2B+H6ZCCnESn+va2YPo7W9q1K1Led2A
TR5j1NC0ONg=
=xByw
-----END PGP SIGNATURE-----

--Sig_/NVz7az+G73ia89f/noBX3+2--
