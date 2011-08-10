Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1HJLUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:20:19 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:34743 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1HJLUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:20:15 -0400
Date: Wed, 10 Aug 2011 20:53:16 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Brad Boyer <flar@allandria.com>, Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <CAMuHMdXVt5+nCaCSH3+z0fsL+vhOOTgbKsOAses8OudT-1OZGQ@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1108102007430.203@ibook.local>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg> <alpine.OSX.2.00.1106011300550.199@ibook.intranet> <20110605062702.GA2034@cynthia.pants.nu> <CAMuHMdXVt5+nCaCSH3+z0fsL+vhOOTgbKsOAses8OudT-1OZGQ@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1359511638-1312972270=:203"
Content-ID: <alpine.OSX.2.00.1108102048490.203@ibook.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1359511638-1312972270=:203
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.OSX.2.00.1108102048491.203@ibook.local>


On Wed, 10 Aug 2011, Geert Uytterhoeven wrote:
>=20
> While looking into optimizing interrupts using chain handlers (which=20
> cannot be shared), I noticed several of these cascades are hung on the=20
> same interrupt. Hence we cannot use the optimization of chain handlers=20
> for them.
>=20
> Knowing which are mutually exclusive helps a lot, but my Mac knowledge=20
> is very limited.
>=20
> I derived from the code this list of cascade handlers and the interrupts=
=20
> they use:
>=20
> baboon_irq
>     IRQ_NUBUS_C
>=20
> oss_irq
>     OSS_IRQLEV_SCSI =3D IRQ_AUTO_2                conflict: via2_irq
>     OSS_IRQLEV_SOUND =3D IRQ_AUTO_5               conflict: psc_irq

PSC and OSS are mutually exclusive.

VIA2 and OSS are also mutually exlusive.

>=20
> oss_nubus_irq
>     OSS_IRQLEV_NUBUS =3D IRQ_AUTO_3               conflict: psc_irq
>=20
> psc_irq
>     IRQ_AUTO_3                                  conflict: oss_nubus_irq
>     IRQ_AUTO_4
>     IRQ_AUTO_5                                  conflict: oss_irq
>     IRQ_AUTO_6                                  conflict: via1_irq
>=20
> via1_irq
>     OSS_IRQLEV_VIA1 =3D IRQ_AUTO_6 (on oss)       conflict: psc_irq
>=20
>     IRQ_AUTO_1                                  conflict: iop_ism_irq

iop_ism_irq is only used with OSS.

>     IRQ_AUTO_6 (if via_alt_mapping)             conflict: psc_irq

via_alt_mapping is not used with PSC.

>=20
> via2_irq
>     IRQ_AUTO_2                                  conflict: oss_irq
>=20
> via_nubus_irq
>     IRQ_MAC_NUBUS =3D IRQ_VIA2_1
>=20
> These are other interrupts using in the Mac core code, which may use the =
same
> interrupts as some of the cascades above:
>=20
> iop_ism_irq
>     OSS_IRQLEV_IOPISM =3D 1 =3D IRQ_AUTO_1 (on oss) conflict: via1_irq

via1_irq is remapped to IRQ_AUTO_6 on OSS.

>     IRQ_VIA2_0 (on !oss)
>=20
> mac_nmi_handler
>     IRQ_AUTO_7
>=20
> timer handler
>     IRQ_MAC_TIMER_1 =3D IRQ_VIA1_6
>=20
> So baboon and PSC are mutually exclusive? But they don't conflict w.r.t. =
to
> interrupt lines anyway, so they're not an issue.
>=20
> From the code, OSS and VIA are also mutually exclusive (except for via1_i=
rq)?
>=20
> But PSC can coexist with OSS? That's where most of the conflicts are.

Hope this helps...

Finn

>=20
> Gr{oetje,eeting}s,
>=20
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0 =A0=A0 -- Linu=
s Torvalds
>=20
--0-1359511638-1312972270=:203--
