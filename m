Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab0EEIuX convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Wed, 5 May 2010 04:50:23 -0400
Received: from smtp.nokia.com ([192.100.122.233]:38525 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0EEIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:50:21 -0400
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Takashi Iwai <tiwai@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
In-Reply-To: <s5hmxwevlm4.wl%tiwai@suse.de>
References: <200910290902.13724.rusty@rustcorp.com.au>
	 <201005041154.24658.rusty@rustcorp.com.au>
	 <1272996439.2458.0.camel@localhost.localdomain>
	 <201005051503.42289.rusty@rustcorp.com.au>
	 <1273044314.3702.98.camel@localhost>  <s5hmxwevlm4.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 May 2010 11:49:29 +0300
Message-ID: <1273049369.3702.127.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: QUOTED-PRINTABLE
X-OriginalArrivalTime: 05 May 2010 08:49:54.0385 (UTC) FILETIME=[EE952410:01CAEC2F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 09:44 +0200, Takashi Iwai wrote:
> At Wed, 05 May 2010 10:25:14 +0300,
> Artem Bityutskiy wrote:
> >=20
> > On Wed, 2010-05-05 at 15:03 +0930, Rusty Russell wrote:
> > > On Wed, 5 May 2010 03:37:19 am Artem Bityutskiy wrote:
> > > > On Tue, 2010-05-04 at 11:53 +0930, Rusty Russell wrote:
> > > > > On Tue, 27 Apr 2010 08:23:24 pm Artem Bityutskiy wrote:
> > > > > > Rusty, correct me if I'm wrong, but it looks like the above=
 memleak was
> > > > > > introduced by e180a6b7759a99a28cbcce3547c4c80822cb6c2a, whe=
re you added
> > > > > > the kstrdup(). So you kinda fixed the sysfs case (it still =
memleaks
> > > > > > though), but at the cost of additional insmod/rmmod leak, r=
ight?
> > > > >=20
> > > > > Yep!
> > > >=20
> > > > Are you working/planning to work on fixing this regression?
> > >=20
> > > I'm still ambivalent on it; I have patches but it's a lot of chur=
n for not
> > > much gain.
> > >=20
> > > To fix this, we need a way to lock parameters against changing by=
 sysfs, and
> > > we need to use it everywhere.  Past experience has demonstrated t=
hat this will
> > > never be maintained. =20
> > >=20
> > > On the other hand, the leak is trivial.
> >=20
> > Well, I am not very concerned with the "changing by sysfs" leak. Th=
is is
> > not a big deal, IMHO. I am concerned with the "rmmod" leak, which d=
id
> > not exist before your patches, but exists now. People may do a lot =
of
> > insmod/rmmod, and on each rmmod they will loose this kstrdup-ed str=
ing.=20
>=20
> I don't think there are so many real cases that actually do leaking.

I am sorry, but let me disagree. Did you count these cases? Why are you
so sure?

We are one live case. We use drivers/usb/gadget/nokia.c. And this is
also used in production, in the Nokia N900 phone.=20

IOW, I officially confirm that we are affected by this regression.

And there are many other potential charp users in drivers/usb/gadget.
Take a look at drivers/usb/gadget/composite.c:

static char *iManufacturer;
module_param(iManufacturer, charp, 0);
MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");

static char *iProduct;
module_param(iProduct, charp, 0);
MODULE_PARM_DESC(iProduct, "USB Product string");

static char *iSerialNumber;
module_param(iSerialNumber, charp, 0);
MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");

This file is included from many other files:

[dedekind@eru gadget]$ pwd
/home/dedekind/git/linux-2.6-param-fixes/drivers/usb/gadget
[dedekind@eru gadget]$ grep 'composite.c' *
audio.c:#include "composite.c"
cdc2.c:#include "composite.c"
composite.c: * composite.c - infrastructure for Composite USB Gadgets
ether.c:#include "composite.c"
mass_storage.c:#include "composite.c"
multi.c:#include "composite.c"
nokia.c:#include "composite.c"
serial.c:#include "composite.c"
zero.c:#include "composite.c"

They are potentially affected too.

> This is only for charp type parameters (not string), and no leak
> happens unless user gives the value explicitly via a module option.

We do use these options. Surely, if they exist, people probably use at
least some of them, right? Otherwise why would they exist?

And I officially confirm that we load/unload the g_nokia gadget
(corresponds to nokia.c) many times, and we are not very interested in
having (even though small) memory leak.

> Fixing in the way of the later upstream is a bit too intrusive as a
> stable patch.  So, I'm also not sure whether we should take it,
> too...

To be frank I do not really understand what you mean.

Anyway, I just humbly suggest not to have the "no one uses that, let's
have a leak" attitude. I do understand that this is a 'it's a lot of
churn for not much gain'. However, I think the rmmod leak is large
enough issue.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
