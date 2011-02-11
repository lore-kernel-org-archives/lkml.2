Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab1BKPUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:20:32 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:45869 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757234Ab1BKPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:20:30 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: R93imZ4VM1kL_igoVFkMYw_AoUFvs42mPYyYjjLANt1h2WE
 QFrx9iP2a3tmwSlhE7IT9WkXn1QfUxWyWPXE_YJE_ErXWuobzf07jhZ0wGDg
 dHoBQsFRh0GmQlXYrLralhT33S2fkJRuY1AV1wMQKsrU541XabPH70IPL5GM
 P2SvPMzowA28l8MOcY6ggKims82BrhNK13BwJai69zCXaLbS5LdB_wiNr9Ek
 HhdaTtatcp1hVNFg2VRS2BxfswACNVsuh.7oAZeCEeej29TpHCLmhN2FVP01
 GMMDUYrFJqGUtyykhPIz0CTwCWe6waAXlz2BJIc6cR_mFM_4-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 11 Feb 2011 09:20:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Russell King <rmk@arm.linux.org.uk>
cc: Pekka Enberg <penberg@kernel.org>, Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
In-Reply-To: <20110211091413.GA32687@flint.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1102110920060.12360@router.home>
References: <20110207180606.GB2966@flint.arm.linux.org.uk> <AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com> <20110208125546.GA4286@flint.arm.linux.org.uk> <alpine.DEB.2.00.1102080856020.12521@router.home> <AANLkTimFDZFcO=J6PEOOo5RBdr0m7fjCKzWh1M_NaiLx@mail.gmail.com>
 <20110211091413.GA32687@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-40732457-1297437628=:12360"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-40732457-1297437628=:12360
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 11 Feb 2011, Russell King wrote:

> On Fri, Feb 11, 2011 at 09:02:45AM +0200, Pekka Enberg wrote:
> > On Tue, Feb 8, 2011 at 5:02 PM, Christoph Lameter <cl@linux.com> wrote:
> > > Uhh.. That first hunk in commit 5c5e3b33b7cb959a401f823707bee006caadd=
76e
> > > looks wrong to me. ralign is usually a power of two and greater than
> > > alignof(unsigned long long). The & operation will result in 0 and nev=
er
> > > exempt any caches.
> > >
> > > diff --git a/mm/slab.c b/mm/slab.c
> > > index bac0f4f..525c664 100644
> > > --- a/mm/slab.c
> > > +++ b/mm/slab.c
> > > @@ -2220,8 +2220,8 @@ kmem_cache_create (const char *name, size_t siz=
e,
> > > size_t align,
> > > =A0 =A0 =A0 =A0if (ralign < align) {
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ralign =3D align;
> > > =A0 =A0 =A0 =A0}
> > > - =A0 =A0 =A0 /* disable debug if necessary */
> > > - =A0 =A0 =A0 if (ralign > __alignof__(unsigned long long))
> > > + =A0 =A0 =A0 /* disable debug if not aligning with REDZONE_ALIGN */
> > > + =A0 =A0 =A0 if (ralign & (__alignof__(unsigned long long) - 1))
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags &=3D ~(SLAB_RED_ZONE | SLAB_STOR=
E_USER);
> > > =A0 =A0 =A0 =A0/*
> > > =A0 =A0 =A0 =A0 * 4) Store it.
> > >
> > >
> > > Did you mean
> > >
> > > =A0 =A0 =A0 =A0if (ralign > REDZONE_ALIGN) ...
> > >
> > > ?
> >
> > Ping. Any arm-capable tester out there that can verify this fix? OTOH,
> > since Shiyong Li hasn't showed up, I'm inclined to just revert the
> > commit...
>
> What fix?  The above is a quote of the patch in 5c5e3b33.

He was referring to the change of the if statement.

---1463811839-40732457-1297437628=:12360--
