Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2BHX5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:57:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab2BHX5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:57:51 -0500
Date: Thu, 9 Feb 2012 10:57:36 +1100
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks"
Message-ID: <20120209105736.027b1e0a@notabene.brown>
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cgsBaSz_YWyaUquX7TZlKi3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cgsBaSz_YWyaUquX7TZlKi3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 02:00:55 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:


> All in all, it's not as much code as I thought it would be and it seems t=
o be
> relatively simple (which rises the question why the Android people didn't
> even _try_ to do something like this instead of slapping the "real" wakel=
ocks
> onto the kernel FWIW).  IMHO it doesn't add anything really new to the ke=
rnel,
> except for the user space interfaces that should be maintainable.  At lea=
st I
> think I should be able to maintain them. :-)
>=20
> All of the above has been tested very briefly on my test-bed Mackerel boa=
rd
> and it quite obviously requires more thorough testing, but first I need t=
o know
> if it makes sense to spend any more time on it.
>=20
> IOW, I need to know your opinions!

I've got opinions!!!

I'll try to avoid the obvious bike-shedding about interface design...

The key point I want to make is that doing this in the kernel has one very
import difference to doing it in userspace (which, as you know, I prefer)
which may not be obvious to everyone at first sight.  So I will try to make=
 it
apparent.

In the user-space solution that we have previously discussed, it is only
necessary for the kernel to hold a wakeup_source active until the event is
*visible* to user-space.  So a low level driver can queue e.g. an input eve=
nt
and then deactivate their wakeup_source.  The event can remain in the input
queue without any wakeup_source being active and there is no risk of going =
to
sleep inappropriately.
This is because - in the user-space approach - user-space must effectively
poll every source of interesting wakeup events between the last wakeup_sour=
ce
being deactivate and the next attempt to suspend.  This poll will notice the
event sitting in a queue so that a well-written user-space will not go to
sleep but will read the event.
(Note that this 'poll-of-every-device' need not be expensive.  It can be a
single 'poll' or 'select' or even 'read' on a pollfd).

In the kernel based approach that you have presented this is not the case.
As the kernel will initiate suspend the moment the last wakeup_source is
released (with no polling of other queues), there must be an unbroken chain=
 of
wakeup_sources from the initial interrupt all the way up to the user.
In particular, any subsystem (such as 'input') must hold a wakeup_source
active as long as any designated 'wakeup event' is in any of its queues.
This means that the subsystem must be able to differentiate wakeup events
from non-wakeup events.
This might be easy (maybe "all events are wakeup events" or "all events on
this queue are wakeup events") but it is not obvious to me that that is the
case.

To summarise: for this solution to be effective it also requires that
 1/ every subsystem that carries wakeup events must know about wakeup_sourc=
es
    and must activate/deactivate them as events are queued/dequeued.
 2/ these subsystems must be able to differentiate between wakeup events and
    non-wakeup events, and this must be a configurable decision.

Currently, understanding wakeup events is restricted to:
 - drivers that are capable of configuring wakeup
 - user-space which cares about wakeup
The proposed solution adds:
 - intermediate subsystems which might queue wakeup events

I think that is a significant addition to make and not one to be made
lightly.  It might end up adding more code than you thought it would be :-)

Thanks for the opportunity to comment,
NeilBrown

--Sig_/cgsBaSz_YWyaUquX7TZlKi3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzML8Dnsnt1WYoG5AQIP8BAAucjwS8cZCEp5k/Cm8OrDuRwhu3570c4E
M/xpMXp5Mpav8GX4HFsEL46A8pHFlc78JGjFwS0bEGzLMbRwd1ggC5Y996Y2rNWx
wGntXM4X6K4Gdp//pyYRJboEjAWy36UQf0nFeJ8jttCJTNacrwlS1DIfQc9K/DVa
hazjXSzS3FNthnLcW9/4R0xFFBC8zVmhjWzHuyAiih2v2Q2h3Ygy5ThCKvIroQe7
gBEkZx0ZYj/8ftD3lwNBpoGcO8aaLTGCBmTqZ1ZGdr5LGPSEvMYgpVCSIJbCPiTH
ZMx48WhVNdvFHW6FiUzoblPK+I6m3MNn93Qlmq0l5TUwWDvTooGDaNNi770yqYIY
X5KjZdj7tk8Tx5gH59H0Jr14xmgatgnSNRsC+NzeUDne/pQoF9eRlRu+QLZva8yk
LQb68loNFSCSPHoYaMuVg79u0MKSmT2hz5zV841/zXAoOLpmskORFvulotOPg2My
H++SuaHBPCzg2So/F1+8q77a44sqVKrTZzlUNc9+C3bz0KRqQnKHIppshGVM8rbp
WzjHpsSmdN1GgG4dC+LDkMgb7x7pDyfuUmv4dO6/HH7+JYNjJzkBgBVnSWBV7p+D
Z8idRJkZsQXHwjxtZnKeQ1X3KJecDHR4yKU3UqdMw6wzDjoEDpk8k+AcjnqNmEEn
a6FEmzWNcOA=
=yR4L
-----END PGP SIGNATURE-----

--Sig_/cgsBaSz_YWyaUquX7TZlKi3--
