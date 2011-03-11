Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1CKO3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:29:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60718 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1CKO3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xK+Uub5uhV/6lMndlPUSeaLpR90CSvslpudpBs1VkMxrlz6dwfPB1KLguE0HHu+uCO
         p4bTrwFKWgyiNTufx/6rNMa2itsvr55N7pM/Vp4iLqrtnn55NTzylwMeLMX8lgnz8S09
         gKX3bUsN8WQe0VmU8HOnRktXyhVBliaPSKg5M=
Date: Fri, 11 Mar 2011 15:28:54 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Wang Lei <f3d27b@gmail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Message-ID: <20110311142854.GB4717@alberich.amd.com>
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
 <201103092125.43950.rjw@sisk.pl>
 <4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
 <201103100106.36678.rjw@sisk.pl>
 <4d796b47.20f98e0a.2695.fffff615@mx.google.com>
 <20110311074156.GD13156@alberich.amd.com>
 <4d79fdbd.43392b0a.0aae.0712@mx.google.com>
 <20110311113839.GA4717@alberich.amd.com>
 <4d7a19c2.29788e0a.231c.1837@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d7a19c2.29788e0a.231c.1837@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 08:47:01PM +0800, Wang Lei wrote:
> 
> On 2011-03-11 19:38:39 +0800, Andreas wrote:
> >
> > Can you please try to boot -rc7 with kernel parameter acpi_skip_timer_override
> > and send the same output (dmesg again also with apic=debug and lspci -nnxxxx)
> >
> >
> > Thanks,
> >
> > Andreas
> >
> > PS: My assumption is that the patch in -rc7 leads to usage of IO-APIC
> >     pin2 for timer interrupt (potentially I have broken chipset
> >     revision determination for some SB600.)

> Hi Andreas,
> 
> I did what you said, appended acpi_skip_timer_override when boot -rc7.
> Now the fans work OK. I don't know why and I don't think this is the
> final solution. If not, I'll wait.

Ok, the problem is that all SB[6-8]00 chipsets use the same PCI device ID.
To differntiate the versions I need to check the revision ID.

With my patch I removed some special treatment for SB600.
(See http://support.amd.com/us/Embedded_TechDocs/46155_sb600_rrg_pub_3.03.pdf)

           Revision ID/Class Code- R - 32 bits - [PCI_Reg: 08h]
Field Name   Bits      Default                             Description
RevisionID    7:0     11h /      This field reflects the ASIC revision.
                      12h /      11h : For ASIC revision A11
                      13h        12h : For ASIC revision A12
                                 13h : For ASIC revision A13
                                 For ASIC revisions after A13, by default this field will read 13h
                                 still. However, if SMBUS PCI config 70h bit 8 is set to 1, a
                                 hidden revision ID can be read from this field.

The old code temporarily cleared bit 8 in PCI config 70h and received
13h as revision for device 14.0 on your system (the "hidden revision
ID" shown in your lspci output is 0x14 and that is what the new code
is using). For SB700/SB800 PCI config 70h is reserved ("software
should not write to it") and that is why I wanted to avoid accesses to
that register. (See SB700 documentation
http://support.amd.com/us/Embedded_TechDocs/43009_sb7xx_rrg_pub_1.00.pdf)

So the right thing to do is to correct the check for SB600 to cover
all SB600 revisions w/o depending on the setting of bit 8 in PCI
config 70h.

Attached patch should achieve this.
Can you please test this patch on top of -rc7?


Thanks a lot,

Andreas
---
>From 8453f3aef2e2b89ba30877998dcbfc06f475e253 Mon Sep 17 00:00:00 2001
From: Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Fri, 11 Mar 2011 15:16:47 +0100
Subject: [PATCH] x86, quirk: Fix SB600 revision check

Commit 7f74f8f28a2bd9db9404f7d364e2097a0c42cc12
(x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems)
introduced a regression. It removed some SB600 specific code
to determine the revision ID without adapting a corresponding
revision ID check for SB600.

See this mail thread
http://marc.info/?l=linux-kernel&m=129980296006380&w=2

This patch adapts the corresponding check to cover all SB600
revisions.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/early-quirks.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 9efbdcc..3755ef4 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -159,7 +159,12 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 	if (rev >= 0x40)
 		acpi_fix_pin2_polarity = 1;
 
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	if (acpi_use_timer_override)
-- 
1.7.4.1

