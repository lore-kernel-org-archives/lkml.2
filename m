Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab2DZEDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 00:03:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab2DZEDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 00:03:35 -0400
Date: Thu, 26 Apr 2012 14:03:24 +1000
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 5/8] epoll: Add a flag, EPOLLWAKEUP, to prevent
 suspend while epoll events are ready
Message-ID: <20120426140324.0357b1a3@notabene.brown>
In-Reply-To: <201204222322.44278.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	<201202220031.46219.rjw@sisk.pl>
	<201204222319.02228.rjw@sisk.pl>
	<201204222322.44278.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GHGmFA=eo.+UCvnAyHh9fzq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GHGmFA=eo.+UCvnAyHh9fzq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Apr 2012 23:22:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
>=20
> When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> wakeup_source will be active to prevent suspend. This can be used to
> handle wakeup events from a driver that support poll, e.g. input, if
> that driver wakes up the waitqueue passed to epoll before allowing
> suspend.
>=20
> The current implementation uses an extra wakeup_source when
> ep_scan_ready_list runs. This can cause problems if a single thread
> is polling on wakeup events and frequent non-wakeup events (events
> usually arrive during thread freezing) using the same epoll file.

This is quite neat.

If I understand it correctly, you register file descriptors with epoll_ctl()
on an fd created with epoll_create(), and set the new EPOLLWAKEUP flag.
Then when a regular 'poll' or 'select' on the epoll fd reports that it is
readable you:
  - get a wakelock
  - use epoll_wait to collect the events
  - process the events
  - release your wakelock
  - go back to poll() or select() on the epoll fd.
Correct?  As long as there are ready events with EPOLLWAKEUP set a
wakeup_source is held active and the system won't go to sleep.

My concern with this is about permissions.  It appears that any process cou=
ld
wait of some fd (maybe a pipe they created themselves) with EPOLLWAKEUP, and
then simply never epoll_wait() for the event.  Then they would be keeping
the system awake.  I don't think that is acceptable.

So there needs to be some way to limit who can effectively block suspend by
using EPOLLWAKEUP.
(This is one of the reasons I like an all-user-space solution.  Policy issu=
es
like this can easily be decided in user-space but are clumsy to put into the
kernel).

Also, I'm having trouble understanding the ep->ws wakeup_source.
The epi->ws makes lots of sense and I think I understand it all.
However I don't see why you need a wakeup_source for the 'struct eventpoll'.

Every time that 'poll' decides to call the ->poll fop for the eventpoll, th=
is
wakeup_source will be activated and deactivated which will abort any current
suspend cycle even if there are no events to report.

I suspect it can just go away.


One last item that doesn't really belong here - but it is in context.

This mechanism is elegant because it provides a single implementation that
provides wakeup_source for almost any sort of device.  I would like to do t=
he
same thing for interrupts.
Most (maybe all) of the wakeup device on my phone have an interrupt where t=
he
body is run in a thread.  When the thread has done it's work the event is
visible to userspace so the EPOLLWAKEUP mechanism is all that is needed to
complete the path to user-space (or for my user-space solution, nothing else
is needed once it is visible to user-space).
So we just need to ensure a clear path from the "top half" interrupt handler
to the threaded handler.
So I imagine attaching a wakeup source to every interrupt for which 'wakeup'
is enabled, activating it when the top-half starts and relaxing it when the
bottom-half completes.  With this in place, almost all drivers would get
wakeup_source handling for free.
Does this seem reasonable to you.  I'm afraid I don't have code yet, but ho=
pe
to find time in a few weeks.

One difficulty with that is that I have noticed a number of drivers that
potentially enable_irq_wake just before suspend and disable_irq_wake
immediately after (e.g. gpio_keys.c).  Allocating a wakeup_source on each
enable_irq_wake would be an unfortunate overhead.  Maybe we just allocate it
the first time enable_irq_wake is called ....


Thanks,
NeilBrown


--Sig_/GHGmFA=eo.+UCvnAyHh9fzq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5jJDDnsnt1WYoG5AQK3/RAAqeUT558XQL+101GBTMEPzZcl5FWSchkb
f5AkOAaoDcLcgfWggY7JYqMVKspLb3CHHLJgRAEXoa8mO6EAeXfs9lZk46phTd24
vT8kPMdElmPTMdSwMdPCvkSGHS3WBO0Li179nWgeCZSibYhPdLAfavTLL7qmWuDY
p0B3n7IbiuIphTNd2C8YP3iXG9kw4YCohpKe6GsohRV12ELXDbvcYIUyCPOIGsvz
o4LK1Ri+SMDw87OD8ZOTIv27O4Jb1UUv3kzrtdgklukkg2Yjm3hfjNE1467wWGXI
Fpn/CtsW0zpDpMePOMkZbvzbdUVlAFN0pUyNQcn32dsJnW3oSu+gTn6NQGZHItFT
TyrS11FHUSQHjWV6rC2QRTZXZOwauFDdXiO8LXr6byZUsUEdvqqyV8BpRiVZUJtX
BP8KWDKZ+OvCQeBR2uMVYIWu4FmxFESVn7sNK0g+757afBZcm+DQNPBQQO2seCYG
wwD/qmuwZmBq7ylpkS7hl7MMPRfk/lIPCMxBV8dqTSBgBDEAKlbxtNTnHsjR/sok
+CeLv9zwOjOksWifqC0zZ6NdBR5PXgs7GHNPxeIQpLnUHyWoZPgLMunm/148kRDg
krXPyebbjNVqR9JIbOil6B6hmMT0QP5jQwzyEsnwgWiXVflNrgYLtLMqo0Doy2md
7lhaG8xrsvM=
=sKh5
-----END PGP SIGNATURE-----

--Sig_/GHGmFA=eo.+UCvnAyHh9fzq--
