Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1KGV10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:27:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42969 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1KGV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:27:25 -0500
Date: Mon, 7 Nov 2011 21:27:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107212707.GH15294@n2100.arm.linux.org.uk>
References: <1320688617-4543-1-git-send-email-balbi@ti.com> <20111107183208.GG15294@n2100.arm.linux.org.uk> <20111107193908.GA5059@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107193908.GA5059@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 09:39:09PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Nov 07, 2011 at 06:32:08PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Nov 07, 2011 at 07:56:57PM +0200, Felipe Balbi wrote:
> > > commit d6504acd (OMAP2+: hwmod: remove OMAP_CHIP*) has
> > > mistakenly added MUSB as a hwmod available only on ES2.0
> > > of OMAP3430.
> > > 
> > > MUSB hwmod has always be available on all OMAP revisions
> > > since OMAP2430.
> > 
> > This doesn't seem to solve it:
> 
> then i can't help. From all I know the LDP is based on OMAP3430 so that
> should work. If it doesn't, it's something deeper on hwmod, maybe ?

Nothing here is specific to the LDP.

> Paul, it's your call.

I think I've found it.

Okay, so.  Clearly, *no* one has even tested this stuff on *any* OMAP3
platform:

        /* Register hwmods common to all OMAP3 */
        r = omap_hwmod_register(omap3xxx_hwmods);
        if (!r)
                return r;

Hint: it returns ZERO on success.  What follows is:

        rev = omap_rev();

        /*
         * Register hwmods common to individual OMAP3 families, all
         * silicon revisions (e.g., 34xx, or AM3505/3517, or 36xx)
         * All possible revisions should be included in this conditional.
         */
        if (rev == OMAP3430_REV_ES1_0 || rev == OMAP3430_REV_ES2_0 ||
            rev == OMAP3430_REV_ES2_1 || rev == OMAP3430_REV_ES3_0 ||
            rev == OMAP3430_REV_ES3_1 || rev == OMAP3430_REV_ES3_1_2) {
...
which can only ever be reached _iff_ registering omap3xxx_hwmods _fails_.
Not succeeds, but _fails_.

Not surprisingly, the same error is repeated below this group of if
statements:

        r = omap_hwmod_register(h);
        if (!r)
                return r;

So, multiple instances of the same brokenness.

With those both fixed, we come to the next pile of BROKENNESS:

WARNING: at /home/rmk/git/linux-rmk/arch/arm/mach-omap2/omap_hwmod.c:1963 omap_hwmod_register+0x130/0x168()
omap_hwmod: sr1_hwmod: _register returned -22
Modules linked in:
Backtrace:
[<c0017920>] (dump_backtrace+0x0/0x10c) from [<c02d9918>] (dump_stack+0x18/0x1c) r7:c03f3ef0 r6:c03cc318 r5:c0370c9f r4:000007ab
[<c02d9900>] (dump_stack+0x0/0x1c) from [<c003ae88>] (warn_slowpath_common+0x58/0x70)
[<c003ae30>] (warn_slowpath_common+0x0/0x70) from [<c003af44>] (warn_slowpath_fmt+0x38/0x40)
 r8:c0433e84 r7:00000001 r6:c03f9550 r5:c03eb41c r4:c0402f4c
[<c003af0c>] (warn_slowpath_fmt+0x0/0x40) from [<c03cc318>] (omap_hwmod_register+0x130/0x168)
 r3:c0374aba r2:c037127b
[<c03cc1e8>] (omap_hwmod_register+0x0/0x168) from [<c03cdc70>] (omap3xxx_hwmod_init+0xd8/0x170)
 r8:c0818fb4 r7:c03f7968 r6:00000000 r5:00000000 r4:34300234
[<c03cdb98>] (omap3xxx_hwmod_init+0x0/0x170) from [<c03c9c70>] (omap3_init_early+0x24/0x30)
 r6:c03e6484 r5:c0818fe4 r4:c0932980
[<c03c9c4c>] (omap3_init_early+0x0/0x30) from [<c03c9cc8>] (omap3430_init_early+0x10/0x14)
[<c03c6a24>] (setup_arch+0x0/0x818) from [<c03c3638>] (start_kernel+0x80/0x308)
[<c03c35b8>] (start_kernel+0x0/0x308) from [<80008040>] (0x80008040)
 r8:80004059 r7:c03f789c r6:c03e79c8 r5:c03f4098 r4:10c53c7d
---[ end trace 1b75b31a2719ed1c ]---
------------[ cut here ]------------
WARNING: at /home/rmk/git/linux-rmk/arch/arm/mach-omap2/omap_hwmod.c:1963 omap_hwmod_register+0x130/0x168()
omap_hwmod: sr2_hwmod: _register returned -22
Modules linked in:
Backtrace:
[<c0017920>] (dump_backtrace+0x0/0x10c) from [<c02d9918>] (dump_stack+0x18/0x1c) r7:c03f3ef0 r6:c03cc318 r5:c0370c9f r4:000007ab
[<c02d9900>] (dump_stack+0x0/0x1c) from [<c003ae88>] (warn_slowpath_common+0x58/0x70)
[<c003ae30>] (warn_slowpath_common+0x0/0x70) from [<c003af44>] (warn_slowpath_fmt+0x38/0x40)
 r8:c0433e84 r7:00000001 r6:c03f9550 r5:c03eb420 r4:c0402fd0
[<c003af0c>] (warn_slowpath_fmt+0x0/0x40) from [<c03cc318>] (omap_hwmod_register+0x130/0x168)
 r3:c0374ac4 r2:c037127b
[<c03cc1e8>] (omap_hwmod_register+0x0/0x168) from [<c03cdc70>] (omap3xxx_hwmod_init+0xd8/0x170)
 r8:c0818fb4 r7:c03f7968 r6:00000000 r5:00000000 r4:34300234
[<c03cdb98>] (omap3xxx_hwmod_init+0x0/0x170) from [<c03c9c70>] (omap3_init_early+0x24/0x30)
 r6:c03e6484 r5:c0818fe4 r4:c0932980
[<c03c9c4c>] (omap3_init_early+0x0/0x30) from [<c03c9cc8>] (omap3430_init_early+0x10/0x14)
[<c03c9cb8>] (omap3430_init_early+0x0/0x14) from [<c03c7120>] (setup_arch+0x6fc/0x818)
[<c03c6a24>] (setup_arch+0x0/0x818) from [<c03c3638>] (start_kernel+0x80/0x308)
[<c03c35b8>] (start_kernel+0x0/0x308) from [<80008040>] (0x80008040)
 r8:80004059 r7:c03f789c r6:c03e79c8 r5:c03f4098 r4:10c53c7d
---[ end trace 1b75b31a2719ed1d ]---

Again, this is not specific to the LDP.  It's whinging about:

static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {

btw, this should be:

static struct omap_hwmod *omap3xxx_hwmods[] __initdata = {

...
        &omap34xx_sr1_hwmod,		<<== XXX
        &omap34xx_sr2_hwmod,		<<== XXX
...
};

static __initdata struct omap_hwmod *omap34xx_hwmods[] = {
        &omap34xx_sr1_hwmod,		<<== XXX
        &omap34xx_sr2_hwmod,		<<== XXX
        &omap3xxx_usbhsotg_hwmod,
        NULL
};

Again, can never have been tested on OMAP3.

Does anyone apart from me bother doing any testing what so ever on OMAP3
platforms?  Am I the only one?
