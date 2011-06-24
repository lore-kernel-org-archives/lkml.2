Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1FXMoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:44:25 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45910 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1FXMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:44:24 -0400
Date: Fri, 24 Jun 2011 08:44:19 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com
Subject: Re: [PATCH 3/3] events: Ensure that timers are updated without
 requiring read() call
Message-ID: <20110624124419.GA3727@mgebm.net>
References: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
 <1308861279-15216-3-git-send-email-emunson@mgebm.net>
 <1308908656.27849.21.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1308908656.27849.21.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Jun 2011, Peter Zijlstra wrote:

> On Thu, 2011-06-23 at 16:34 -0400, Eric B Munson wrote:
> > The event tracing infrastructure exposes two timers which should be upd=
ated
> > each time the value of the counter is updated.  Currently, these counte=
rs are
> > only updated when userspace calls read() on the fd associated with an e=
vent.
> > This means that counters which are read via the mmap'd page exclusively=
 never
> > have their timers updated.  This patch adds ensures that the timers are=
 updated
> > each time the values in the mmap'd page are updated.
> >=20
> > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > ---
> >  kernel/events/core.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 9e9a7fa..e3be175 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -3382,6 +3382,18 @@ void perf_event_update_userpage(struct perf_even=
t *event)
> >  	struct perf_buffer *buffer;
> > =20
> >  	rcu_read_lock();
> > +	/*
> > +	 * compute total_time_enabled, total_time_running
> > +	 * based on snapshot values taken when the event
> > +	 * was last scheduled in.
> > +	 *
> > +	 * we cannot simply called update_context_time()
> > +	 * because of locking issue as we are called in
>=20
> s/are/can be/
>=20
> > +	 * NMI context
> > +	 */
> > +	calc_timer_values(event,
> > +				&event->total_time_enabled,
> > +				&event->total_time_running);
>=20
> I'm not sure writing those from NMI context is a sane thing to do, best
> is to compute the values into a local variable and use that variable
> below.
>=20
> Took the first two patches.
>=20

Thanks, I will send out an updated patch once I get it tested.

Eric

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOBIajAAoJEH65iIruGRnNu20IAI9HSeDbolPW4AyX4vq9Q05e
vZdLJLUO44k5YXvM0AaWk/AG2HErbTdKIiZ9XgRPXYxHsLIlkW2euSfM7VF2gFpH
lr+N9V5Xi8USG5NOEC0nVxbQFlSKpLKDvNKPsHAjPLgUdodCw7+a5jQxza/YsMKd
AebHowab2rGp63QFJz2mt6xsiHSGZJ22hyd5kba6IVWbBCaqADjJfnzG+2GZXAAl
3dmu1E9FeXmPkNcmxY23iL8VNOWwFwkthTAWPTRiss7pVzMXbDWFD1iFVBGStHQK
3lHY6yhX6kq+W7kO1ovFm0KGrqdir6Je6xSOrhU4KIUciXGIAG0tVvWDdyJDfqU=
=W5/y
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
