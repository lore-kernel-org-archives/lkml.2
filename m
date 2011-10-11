Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1JKCrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 22:47:23 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:49974 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1JKCrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 22:47:21 -0400
Date: Mon, 10 Oct 2011 20:47:20 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Ming Lei <tom.leiming@gmail.com>
cc: "Cousson, Benoit" <b-cousson@ti.com>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <CACVXFVOVv_AeQv_834ca9FM2BK8Hd4jgggLDAGdhbeVyhiaycw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110102021110.5205@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com> <4E7B8C68.7020407@ti.com> <alpine.DEB.2.00.1109221524560.10719@utopia.booyaka.com>
 <CACVXFVOVv_AeQv_834ca9FM2BK8Hd4jgggLDAGdhbeVyhiaycw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-841624508-1318301240=:5205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-841624508-1318301240=:5205
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello Ming,

On Wed, 28 Sep 2011, Ming Lei wrote:

> On Fri, Sep 23, 2011 at 7:31 AM, Paul Walmsley <paul@pwsan.com> wrote:
>=20
> > The idea of the main_clk was not intended to be PRCM or OCP or even
> > OMAP-specific. =A0It's just intended to represent a clock that is used =
to
> > drive the register logic inside the IP block. =A0Therefore it must be
> > enabled before any register access may occur. =A0Even if clock gating i=
s
> > handled by some higher-level interface (e.g., at the IP block level), t=
he
> > main_clk has a rate, so it also implies an upper limit on how quickly
> > register operations can occur. =A0I suppose that all of the IP block's
> > clocks could be "optional clocks," but we know that every IP block with
> > registers requires at least one clock to work, and that should be the
> > main_clk.
>=20
> I am a bit confused about you comment on "main_clk".
>=20
> >From hwmod related source code, main_clk is the function clock
> of one module(hwmod), such as: on omap4, for uart3, main_clk is
> uart3_fck.
>=20
> But from[1] and [2] of omap4 PRM, we can find that interface clock
> is required to provide register access instead of function clock.

As far as I know, the two cases that you cite are basically documentation=
=20
bugs in the TRM.  In my experience, for IP blocks on OMAPs, a functional=20
clock has to be enabled in order for register accesses to succeed.  It's=20
possible there may be a few odd IP blocks that behave differently, but I=20
can't think of any off the top of my head.

There are three cases that I've come across that might be interesting to=20
you.

The first involves IP blocks that use their interface clock as their=20
functional clock, such as the MAILBOXES IP block.  In this case, there is=
=20
no separate functional clock that is needed for register accesses to=20
complete, and therefore the main_clk should be the interface clock.

The second case involves IP blocks that can receive functional clocks from=
=20
an off-chip source (i.e., not via a PRCM-controlled clock), such as the=20
McBSP IP block.  For these IP blocks, it could be that register accesses=20
might still succeed even if the module's PRCM-provided functional clock is=
=20
off.  I haven't tested this personally.

The third case involves IP blocks with multiple functional clocks, such as=
=20
the OMAP3 USBHOST subsystem.  What we found on OMAP3 was that only one of=
=20
these two clocks needs to be enabled for register accesses to succeed. =20
Some functional clocks might control parts of an IP block that have=20
nothing to do with register access.

> This is a bit conflictive with what you description, so could you
> give a further comments about main_clk, function clock and interface
> clock?

I don't know why there are these documentation discrepancies.  I can=20
guess, but probably I'd better not :-)  Hope the above helped.

> [1], 23.3.4.2 Clock Configuration
> =09Each UART uses a 48-MHz functional clock for its logic
> =09and to generate external interface signals. Each UART
> =09uses an interface clock for register accesses.
>=20
> [2], 3.1.1.1.1 Module Interface and Functional Clocks
> =09The interface clocks have the following characteristics:
> =09=95 They ensure proper communication between any module/subsystem
> =09and the interconnect.
> =09=95 In most cases, they supply the system interconnect interface
> =09and registers of the module.

regards,

- Paul
--155748971-841624508-1318301240=:5205--
