Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161376Ab2JXWWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:22:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:15367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161227Ab2JXWWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:22:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,642,1344236400"; 
   d="scan'208";a="210339361"
Subject: Re: [RFC/PATCH 2.6.32.y 0/3] Re: [stable 2.6.32..2.6.34] x86,
 ioapic: initialize nr_ioapic_registers early in mp_register_ioapic()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 24 Oct 2012 15:24:30 -0700
In-Reply-To: <20121024194114.GC3120@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
	 <20121024182546.GB3338@elie.Belkin>
	 <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
	 <20121024194114.GC3120@elie.Belkin>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1351117470.6017.91.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 12:41 -0700, Jonathan Nieder wrote:
> Suresh Siddha wrote:
> > On Wed, 2012-10-24 at 11:25 -0700, Jonathan Nieder wrote:
> 
> >> Why not cherry-pick 7716a5c4ff5 in full?
> >
> > As that depends on the other commits like:
> > commit 4b6b19a1c7302477653d799a53d48063dd53d555
> 
> More importantly, if I understand correctly it might depend on
> 
>  commit cf7500c0ea13
>  Author: Eric W. Biederman <ebiederm@xmission.com>
>  Date:   Tue Mar 30 01:07:11 2010 -0700
> 
>      x86, ioapic: In mpparse use mp_register_ioapic
> 
> Here's a series, completely untested, that is closer to what I
> expected.  But the approach you took seems reasonable, too, as long
> as the commit message is tweaked to explain it.
> 
> Thanks again,
> Jonathan
> 
> Eric W. Biederman (3):
>   x86, ioapic: Teach mp_register_ioapic to compute a global gsi_end
>   x86, ioapic: In mpparse use mp_register_ioapic
>   x86, ioapic: Move nr_ioapic_registers calculation to
>     mp_register_ioapic.
> 
>  arch/x86/include/asm/io_apic.h |  1 +
>  arch/x86/kernel/apic/io_apic.c | 28 ++++++++++++++--------------
>  arch/x86/kernel/mpparse.c      | 25 +------------------------
>  arch/x86/kernel/sfi.c          |  4 +---
>  4 files changed, 17 insertions(+), 41 deletions(-)

hmm, NO.

I am not sure if it is worth spending time validating all these changes
for the stable series and I can't do it on my own, as I don't have all
the relevant HW.

For example, another commit a4384df3e24579d6292a1b3b41d500349948f30b
(which you haven't picked up in your series) fixes some of these issues
introduced by the commits you have picked.

commit a4384df3e24579d6292a1b3b41d500349948f30b
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Jun 8 11:44:32 2010 -0700

    x86, irq: Rename gsi_end gsi_top, and fix off by one errors

So I did think about all these things and wanted to really pursue the
smallest and simplest change. Here is the updated patch with just some
more text added to the changelog. Greg, does this look ok to you?

Thanks.
-- 8< --

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, ioapic: initialize nr_ioapic_registers early in mp_register_ioapic()

Lin Bao reported that one of the HP platforms failed to boot
2.6.32 kernel, when the BIOS enabled interrupt-remapping and
x2apic before handing over the control to the Linux kernel.

During boot, Linux kernel masks all the interrupt sources
(8259, IO-APIC RTE's), setup the interrupt-remapping hardware
with the OS controlled table and unmasks the 8259 interrupts
but not the IO-APIC RTE's (as the newly setup interrupt-remapping
table and the IO-APIC RTE's are not yet programmed by the kernel).

Shortly after this, IO-APIC RTE's and the interrupt-remapping table
entries are programmed based on the ACPI tables etc. So the
expectation is that any interrupt during this window will be dropped
and not see the intermediate configuration.

In the reported problematic case, BIOS has configured the IO-APIC
in virtual wire-B mode. Between the window of the kernel setting up
new interrupt-remapping table  and the IO-APIC RTE's are properly
configured, an interrupt gets routed by the IO-APIC RTE (setup
by the virtual wire-B configuration) and sees the empty
interrupt-remapping table entry, resulting in vt-d fault causing
the platform to generate NMI. And the OS panics on this unexpected NMI.

This problem doesn't happen with more recent kernels and closer
look at the 2.6.32 kernel shows that the code which masks
the IO-APIC RTE's is not working as expected as the nr_ioapic_registers
for each IO-APIC is not yet initialized at this point. In the later
kernels we initialize nr_ioapic_registers much before and
everything works as expected.

For 2.6.[32..34] kernels, fix this issue by initializing
nr_ioapic_registers early in mp_register_ioapic()

[ Relevant upstream commit info:
  commit 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
  Author: Eric W. Biederman <ebiederm@xmission.com>
  Date:   Tue Mar 30 01:07:12 2010 -0700

    x86, ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.

  As the upstream commit depends on quite a few prior commits
  and some followup fixes in the mainline, we just picked
  the smallest relevant hunk for fixing the issue at hand.
  Problematic platform uses ACPI for IO-APIC, VT-d enumeration etc
  and this hunk only touches the ACPI based platforms.

  nr_ioapic_reigsters initialization in enable_IO_APIC() is still
  retained, so that other configurations like legacy MPS table based
  enumeration etc works with no change.
]

Reported-and-tested-by: Zhang, Lin-Bao <linbao.zhang@hp.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@vger.kernel.org [v2.6.32..v2.6.34]
---
 arch/x86/kernel/apic/io_apic.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8928d97..d256bc3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4262,6 +4262,7 @@ static int bad_ioapic(unsigned long address)
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
+	int entries;
 
 	if (bad_ioapic(address))
 		return;
@@ -4280,10 +4281,14 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
+	entries = io_apic_get_redir_entries(idx);
 	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx);
+	mp_gsi_routing[idx].gsi_end = gsi_base + entries;
 
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	nr_ioapic_registers[idx] = entries + 1;
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
 	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,


