Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab1JHWbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 18:31:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab1JHWbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 18:31:21 -0400
Date: Sun, 9 Oct 2011 09:31:00 +1100
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
Message-ID: <20111009093100.6c15be50@notabene.brown>
In-Reply-To: <20111008181638.GA12672@mgross-G62>
References: <20111002164456.GC14312@mgross-G62>
	<20111008221439.48f30263@notabene.brown>
	<20111008181638.GA12672@mgross-G62>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aHtgex6otdEihRbnVvDt62B"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aHtgex6otdEihRbnVvDt62B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Oct 2011 11:16:38 -0700 mark gross <markgross@thegnar.org> wrote:

> On Sat, Oct 08, 2011 at 10:14:39PM +1100, NeilBrown wrote:
> > On Sun, 2 Oct 2011 09:44:56 -0700 mark gross <markgross@thegnar.org> wr=
ote:
> >=20
> > > resending to wider list for discussion
> > > ----- Forwarded message from mark gross <markgross@thengar.org> -----
> > >=20
> > > Subject: [RFC] wake up notifications and suspend blocking (aka more w=
akelock stuff)
> > > Date: Tue, 20 Sep 2011 13:33:05 -0700
> > > From: mark gross <markgross@thengar.org>
> > > To: linux-pm@lists.linux-foundation.org
> > > Reply-To: markgross@thegnar.org
> > > Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@rowlan=
d.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wy=
socki" <rjw@sisk.pl>
> > >=20
> > > The following patch set implement an (untested) solution to the
> > > following problems.
> > >=20
> > > 1) a method for making a system unable to suspend for critical sectio=
ns
> > > of time.
> >=20
> > We already have this.  A properly requested suspend (following wakeup_c=
ount
> > protocol) is unable to complete between wakeup_source_activate() and
> > wake_source_deactivate() - these delimit the critical sections.
> >=20
> > What more than this do you need?
>=20
> sometimes devices that are not wake up sources need critical sections
> where suspend is a problem.

I agree with Alan that an example would help here.
My naive perspective is that any device is either acting on behalf of a
user-space program, so it should disable suspend, or on behalf of some
external event, so that event is ipso-facto a wakeup event.

> >=20
> > >=20
> > > 2) providing a race free method for the acknowledgment of wake event
> > > processing before re-entry into suspend can happen.
> >=20
> > Again, this is a user-space problem.  It is user-space which requests
> > suspend.  It shouldn't request it until it has checked that there are n=
o wake
> > events that need processing - and should use the wakeup_count protocol =
to
> > avoid races with wakeup events happening after it has checked.
>=20
> Here you are wrong, or missing the point.  The kernel needs to be
> notified from user mode that an update event has been consumed by
> whoever cares about it before the next suspend can happen.  The fact
> that there are time outs in the existing wake event code points to this
> shortcoming in the current implementation.

 ... or I have a different perspective.
A write to wakeup_count is a notification to the kernel that all wakeup
events that had commenced prior to that same number being read from
wakeup_count have been consumed.

So we already have a mechanism for the notification that you want.

>=20
> I suppose one could rig up the user mode suspend daemon with
> notification callbacks between event consumers across the user mode
> stack but its really complex to get it right and forces a solution to a
> problem better solved in kernel mode be done with hacky user mode
> gyrations that may ripple wildly across user mode.

I suspect it is in here that the key to our different perspectives lies.
I think than any solution must "ripple wildly across user mode" if by that
you mean that more applications and daemons will need to be power-aware and
make definitive decisions about when they cannot tolerate suspend.
Whether those apps and daemons tell the kernel "don't suspend now" or tell
some user-space daemon "don't suspend now" is fairly irrelevant when
assessing the total impact on user-space.

I think a fairly simple protocol involving file locking can be perfectly
adequate to communicate needs relating to suspend-or-don't-suspend among
user-space processes.


>=20
> Also it is the kernel that is currently deciding when to unblock the
> suspend daemon for the next suspend attempt.  Why not build on that and
> make is so we don't need the time outs?

Suspend is a joint decision by user-space and kernel-space.  Each part shou=
ld
participate according to its expertise.
The kernel can make use of information generated by drivers in the kernel.
User-space can consolidate information generated by user-space processes.


>=20
> > i.e. there is no kernel-space problem to solve here (except for possible
> > bugs).
>=20
> Just a race between the kernel allowing a suspend and the user mode code
> having time to consume the last wake event.
>

Providing that the source of the wake event does not deactivate the
wakeup_source before the event is visible to userspace, this race is easily
avoided in userspace:

   - read wakeup_count
   - check all possible wakeup events.
   - if there were none, write back to wakeup_count and request a suspend.

This is race-free.

If some wakeup_source is deactivated before the event is visible to
user-space, then that is a bug and should be fixed.
If there is some particular case where it is non-trivial to fix that bug,
then that would certainly be worth exploring in detail.

NeilBrown


--Sig_/aHtgex6otdEihRbnVvDt62B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpDPLTnsnt1WYoG5AQLiNw//XNihcz8Y0DFnUF9O2wzg6VvmzYE0mgj6
zU43zX45fTuhJdV3TOxsDYvR5s52YiOERXFNDTODNSFTVMNAhXV8Sp4Exq2Es+ap
LJlAykkph8hwIt3nb/uBRLHT6BCJUrgPpByCuQQO5zfTChriNI+KrcGoqwvYev+O
kWtda+9QjIz7nrvYpuh6Qv841xGTOKuVOcHA2ER6LmOEtl+Ii2EOJ7eP15W1t5TB
64eKrxc/6GBAiuYETsF0v7ixK04S7MIXMQH+15tWwdfbgjYhOPj0IlU9oBB7WBBE
hEQRjWE+KSWyZxHOT/GbOSNUXhHZs0nrkQJ/6oLV+maaAe/WTFxUoqxfQ27PXkT5
bYJ0BhQni2OQzwA2nDQsQ9ZNFYfGyj/oTT5Y9rxTzYwWr7QA0x6uPa3Mh1K7VW0Z
ckG16WRXBprmZH18vbAlEpjvorIN0njsczmabGWjVjxYStGj/JAxn+Fp7dAg/q6v
hBYUDN4tyQxSRkc6bVgTV2j8xp/q7s8o+PvyR0JGMowWGasx6auIjNeMtrEyshYN
Rk/2Mtna6G2QaB8di5xqcFmS4W4cXry4EZzxdJ7xLaTkTidnHQnM9IZFAfkiBoer
mZ3/ZUM7k5COpj4B1kFTclgAWfUA6GxwdvzLi68xQPc1ud9khVTLxo7Foh/xM8D3
POcWFTs6iEU=
=7Xnd
-----END PGP SIGNATURE-----

--Sig_/aHtgex6otdEihRbnVvDt62B--
