Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2K3HWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:22:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2K3HWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:22:06 -0500
Date: Fri, 30 Nov 2012 08:22:00 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
Message-ID: <20121130072200.GE26474@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com>
 <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de>
 <50B73B5B.8030008@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Content-Disposition: inline
In-Reply-To: <50B73B5B.8030008@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mjPVCB8Yz49yYrE0XATcKekElN1LsSx6UITmc5iicwP
 feybAPUqZ1mj43Xfbi8F2mmdhTULuzAp07TItsFzzSeHJA0Bgf
 0IKJRyf9YiLBgpiiFlD0yFvFvL/uui2EUlbpyNlQ4GZgbqlI4G
 LCpTzIi4+rUHKoAfOpDTbYVtV9Hp84zwJb4WjE6AU6P9KrLiQs
 hVLkXp5o11P2qAjx16fvx14k4hu4J5FI0ds0+AThHhg11+Ij6e
 UQw8l53fcVnwIy7xgH7X9eQAxnslJ1ce8njJM5oPznHr7V4Wpj
 WUMY6GK78alLhImok+d5Baels5Gk+9Xn0f3kjKS4HLFAHL1rwh
 +jkbsAKMuAwc/o9UdF+EG+J6F6JTJ8q7x7dJ9RFk9UrGTb/idf
 QEi7LGl5Ny8dBOyEA0kL792/fYLtv1ZOHwCeUo6voVn7tE/Zck
 SAjs/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 12:39:23PM +0200, Terje Bergstr=C3=B6m wrote:
> On 29.11.2012 10:44, Thierry Reding wrote:
> >> diff --git a/drivers/video/tegra/host/dev.c b/drivers/video/tegra/host=
/dev.c
> >> index 98c9c9f..025a820 100644
> >> --- a/drivers/video/tegra/host/dev.c
> >> +++ b/drivers/video/tegra/host/dev.c
> >> @@ -43,6 +43,13 @@ u32 host1x_syncpt_read(u32 id)
> >>  }
> >>  EXPORT_SYMBOL(host1x_syncpt_read);
> >>
> >> +int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value)
> >=20
> > The choice of data types is odd here. id refers to a syncpt so a better
> > choice would have been unsigned int because the size of the variable
> > doesn't actually matter. But as I already said in my reply to patch 1,
> > these are resources and should therefore better be abstracted through an
> > opaque pointer anyway.
> >=20
> > timeout is usually signed long, so this function should reflect that. As
> > for the value this is probably fine as it will effectively be set from a
> > register value. Though you also cache them in software using atomics.
>=20
> 32-bits is an architectural limit for the sync point id, so that's why I
> used it here.

But given that there are only 32 syncpoints they look rather costly, so
I don't expect more than a few hundred to ever be used in hardware,
right?

> But you're right - it doesn't really matter and could be changed to
> unsigned long.

I'd still opt for unsigned int. For no other reason than that it is how
other types of resources are enumerated.

> thresh and *value reflects that sync point value is 32-bit, and I'd keep
> that as is.

Yes, that makes sense.

> Timeout should be unsigned long, yes.

It should actually be signed long to match the type used for timeouts in
the various wait_*() functions.

> >> diff --git a/drivers/video/tegra/host/host1x/host1x_intr.c b/drivers/v=
ideo/tegra/host/host1x/host1x_intr.c
> > [...]
> >> +#include <linux/interrupt.h>
> >> +#include <linux/irq.h>
> >> +#include <linux/io.h>
> >> +#include <asm/mach/irq.h>
> >> +
> >> +#include "nvhost_intr.h"
> >> +#include "host1x/host1x.h"
> >> +
> >> +/* Spacing between sync registers */
> >> +#define REGISTER_STRIDE 4
> >=20
> > Erm... no. The usual way you should be doing this is either make the
> > register definitions account for the stride or use accessors that apply
> > the stride. You should be doing the latter anyway to make accesses. For
> > example:
> >=20
> >         static inline void host1x_syncpt_writel(struct host1x *host1x,
> >                                                 unsigned long value,
> >                                                 unsigned long offset)
> >         {
> >                 writel(value, host1x->regs + SYNCPT_BASE + offset);
> >         }
> >=20
> >         static inline unsigned long host1x_syncpt_readl(struct host1x *=
host1x,
> >                                                         unsigned long o=
ffset)
> >         {
> >                 return readl(host1x->regs + SYNCPT_BASE + offset);
> >         }
> >=20
> > Alternatively, if you want to pass the register index instead of the
> > offset, you can use just multiply the offset in that function:
> >
> >         writel(value, host1x->regs + SYNCPT_BASE + (offset << 2));
> >
> > The same can also be done with the non-syncpt registers.
>=20
> The register number has a stride of 4 when doing writes, and 1 when
> adding to command streams. This is why I've kept the register
> definitions as is.

Yes, that's why it makes sense to use such helpers. It allows you to
reuse the register definitions for both direct and indirect access but
doesn't require you to repeat the stride multiplication every time.

> I could add helper functions. Just as a side note, the sync register
> space has other definitions than just the syncpt registers, so the
> naming should be changed a bit.

The TRM refers to them as SYNC registers, so SYNC_BASE should be fine.

> >> +static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
> >> +{
> >> +     struct nvhost_master *dev =3D dev_id;
> >> +     void __iomem *sync_regs =3D dev->sync_aperture;
> >> +     struct nvhost_intr *intr =3D &dev->intr;
> >> +     unsigned long reg;
> >> +     int i, id;
> >> +
> >> +     for (i =3D 0; i < dev->info.nb_pts / BITS_PER_LONG; i++) {
> >> +             reg =3D readl(sync_regs +
> >> +                             host1x_sync_syncpt_thresh_cpu0_int_statu=
s_r() +
> >> +                             i * REGISTER_STRIDE);
> >> +             for_each_set_bit(id, &reg, BITS_PER_LONG) {
> >> +                     struct nvhost_intr_syncpt *sp =3D
> >> +                             intr->syncpt + (i * BITS_PER_LONG + id);
> >> +                     host1x_intr_syncpt_thresh_isr(sp);
> >> +                     queue_work(intr->wq, &sp->work);
> >> +             }
> >> +     }
> >> +
> >> +     return IRQ_HANDLED;
> >> +}
> >=20
> > Maybe it would be better to call the syncpt handlers in interrupt
> > context and let them schedule work if they want to. I'm thinking about
> > the display controllers which may want to use syncpoints for VBLANK
> > support.
>=20
> Display controller can use the APIs to read, increment and wait for sync
> point.

Actually for the display controller we want just a notification when the
VBLANK happens. I'm not sure if we want to do that with syncpoints at
all since it works quite well using regular interrupts.

> We could do more in isr, but then again, we've noticed that the current
> design already gives pretty good latency, so we haven't seen the need to
> move code from thread to isr.

What I'm proposing is to leave it up to each host1x client how they want
to handle this. For display controllers it may be enough to have their
callback run in interrupt context but other clients may need to do more
work so they can queue it themselves.

I know that this looks like it might be more work, but if it turns out
that many drivers need to do the exact same thing, that functionality
can be factored out into a helper. But it may just as well turn out that
the requirements for each module are slightly different that forcing a
workqueue on them could result in ugly workarounds because it doesn't
quite work for them.

> >> +/**
> >> + * Sync point threshold interrupt service function
> >> + * Handles sync point threshold triggers, in interrupt context
> >> + */
> >> +static void host1x_intr_syncpt_thresh_isr(struct nvhost_intr_syncpt *=
syncpt)
> >> +{
> >> +     unsigned int id =3D syncpt->id;
> >> +     struct nvhost_intr *intr =3D intr_syncpt_to_intr(syncpt);
> >> +
> >> +     void __iomem *sync_regs =3D intr_to_dev(intr)->sync_aperture;
> >> +
> >> +     u32 reg =3D BIT_WORD(id) * REGISTER_STRIDE;
> >> +
> >> +     writel(BIT_MASK(id), sync_regs +
> >> +             host1x_sync_syncpt_thresh_int_disable_r() + reg);
> >> +     writel(BIT_MASK(id), sync_regs +
> >> +             host1x_sync_syncpt_thresh_cpu0_int_status_r() + reg);
> >> +}
> >=20
> > So this disables all interrupts and is called from the syncpt interrupt
> > handler. Where are the interrupts reenabled? Do host1x clients have to
> > do that manually?
>=20
> The thread re-enables once it's done. It checks the next value we're
> interested in, and programs that to host1x syncpt threshold.

Okay, that does make sense now. I think I'm indeed beginning to
understand how the hardware works...

> > Okay, so this is where syncpoint interrupts are reenabled. The rest of
> > this whole wait queue code looks overly complex. I'll need to go through
> > that separately and more thoroughly.
>=20
> Thanks.

If we move responsibility of managing the workqueue out of host1x as I
proposed above, maybe a lot of this code can be removed. Maybe you can
explain a bit what they are used for exactly in your write-up.

Thierry

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuF6YAAoJEN0jrNd/PrOhrSgP/RKniZzy3ITfVn1AHca5QN+U
Nv4RvNu00oeiX2fHdLIjMQAc14dg+1JXNr9PZ3kSrW0yzUk632tz9kHdRy2IqnR6
3ou/6hNjlqEznHTNsYE5fSxRxFlYP/q4JtlxFCqAr4tgNukSRvWlEZgG3CIJvgCJ
3xAjldmSVZtXRgWPUcylxgUBsze+3237A8v5Ktngp461X3Sxe1ujqn89nlkwr6Fx
bvef+owGBniJEU+9+InSd1f8Sq/2QpLG84HDjrRce2PsFfcl2K4dtlKJsj0/LvNZ
G6mLXxY33OwSB0ZhvitYz7JiMtkbAXVidnQfXGJBY9zpLrX9BrIsiJ7hjpIbra3i
WGMFrNCkZmMHSGdH/wIy+N8URDdmHSu9kMjC+3WTFZQsffxFr9aRfGzydViPK2/V
eFlOdsggo2Bi/x4xsd41d+n4cE29x1S5ZYVDPq2oVhjlT6hu+6GOgstYp6j60dU6
Fhk9iUAYP0QpiUKx7/EfRYXcR3bvZPk1w29ZlSYML+k39LK7712NFhXcwlyo2OsU
kG68DfsDcxQhA7lfqzQeAG8qy09wgaBbiVMJ/JT/rT58MLY7iXDARPaYlbpvjJPS
a1e5HMcF0uRgn4kN00LTZw8RCymQB0iD07CUivLf+45EjADBOKyWZaYBKq/Fw8LO
n9g2JRnQE1ukZplPeLt/
=JKJu
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--
