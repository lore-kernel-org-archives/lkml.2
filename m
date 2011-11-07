Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1KGWwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:52:07 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39687 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1KGWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:52:05 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19N7OussFwj1e4oZ8qtDXJN
Date: Mon, 7 Nov 2011 14:51:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107225157.GB31337@atomide.com>
References: <1320688617-4543-1-git-send-email-balbi@ti.com>
 <20111107183208.GG15294@n2100.arm.linux.org.uk>
 <20111107193908.GA5059@legolas.emea.dhcp.ti.com>
 <20111107212707.GH15294@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1111071428001.12394@utopia.booyaka.com>
 <20111107224129.GJ15294@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107224129.GJ15294@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [111107 14:06]:
> On Mon, Nov 07, 2011 at 02:29:35PM -0700, Paul Walmsley wrote:
> > On Mon, 7 Nov 2011, Russell King - ARM Linux wrote:
> > 
> > > Again, can never have been tested on OMAP3.
> > > 
> > > Does anyone apart from me bother doing any testing what so ever on OMAP3
> > > platforms?  Am I the only one?
> > 
> > This was fixed by 
> > 
> > http://www.spinics.net/lists/arm-kernel/msg143549.html
> > 
> > which didn't go upstream as part of the v3.2 merge window.
> 
> Ah, that patch.
> 
> Which version of the patch does Tony have?  The one you point at which
> uses IS_ERR_VALUE() and I complained about, or the version that has that
> fixed?

Here's what I got. Looks like the removal of the sr[12]_hwmod
part is no longer needed, so only the r value check part is needed.

From: Paul Walmsley <paul@pwsan.com>
Date: Thu, 6 Oct 2011 14:39:28 -0600
Subject: [PATCH] ARM: OMAP3: hwmod: fix variant registration and remove SmartReflex from common list

Commit d6504acd2125984c61dce24727dd3842d0144015 ("OMAP2+: hwmod:
remove OMAP_CHIP*") tests the inverse condition of what it should be
testing for the return value from omap_hwmod_register().  This causes
several IP blocks to not be registered on several OMAP3 family devices.

Fixing that bug also unmasked another bug, originally reported by
Chase Maupin <chase.maupin@ti.com> and then subsequently by Abhilash K
V <abhilash.kv@ti.com>, which caused SmartReflex IP blocks to be
registered on SoCs that don't support them.

Thanks to Russell King - ARM Linux <linux@arm.linux.org.uk> for comments
on a previous version of the patch.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Chase Maupin <chase.maupin@ti.com>
Cc: Abhilash K V <abhilash.kv@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3270,7 +3270,7 @@ int __init omap3xxx_hwmod_init(void)
 
 	/* Register hwmods common to all OMAP3 */
 	r = omap_hwmod_register(omap3xxx_hwmods);
-	if (!r)
+	if (r < 0)
 		return r;
 
 	rev = omap_rev();
@@ -3295,7 +3295,7 @@ int __init omap3xxx_hwmod_init(void)
 	};
 
 	r = omap_hwmod_register(h);
-	if (!r)
+	if (r < 0)
 		return r;
 
 	/*
