Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0KIOkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:40:37 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46255 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab0KIOkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:40:35 -0500
Date: Tue, 9 Nov 2010 15:39:41 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@alien8.de>, john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101109143941.GA31121@aftab>
References: <20101029170040.GJ21125@aftab>
 <20101029172631.GA23546@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6>
 <20101101184512.GA1589@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6>
 <20101105160919.GC25704@aftab>
 <20101105164225.GA1594@arch.trippelsdorf.de>
 <20101105212749.GA1559@arch.trippelsdorf.de>
 <20101105213248.GB28493@aftab>
 <alpine.LFD.2.00.1011091500220.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011091500220.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:02:13AM -0500, Thomas Gleixner wrote:
> > actually your board is not what concerns me, 20 ticks is still ok, more
> > or less, but there are other machines which contain absurd values in
> > there like 0x37ee or 0x1000 (a Broadcom chipset). We'll need to give a
> > change like that a good run before we can be absolutely sure it doesn't
> > break any machines.
> 
> If the ACPI entry is known to be flaky, shouldn't we simply err out on
> the safe side and use 128 ticks in any case, which is not a really big
> deal.

Yep, this is what my proposed fix does. I set it by default to 0x80 and
the hpet detection code in acpi_parse_hpet() overrides it if it is less
than that (and obviously a sensible value written by the BIOS).

Otherwise it issues a warning. Come to think of it, we shouldn't be
issuing a warning because this'll scream on a very high number of
systems, IMHO, especially older boards. Instead, we should issue it in
dmesg during boot just in case.

The other concern I have is whether min tick of 128 would work for _all_
possible HPET implementations - I don't know whether there are some very
b0rked incarnations which delay HPET accesses to more than 128 cycles.
Kinda hard to say.

So, to be more specific, here's what I have in mind:

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 4 Nov 2010 00:01:49 +0100
Subject: [PATCH] HPET: Fix HPET readout for small deltas

Some HPET implementations might require longer delay when accessing the
HPET than what 995bd3bb5c78f3ff71339803c0b8337ed36d64fb established (8
cycles). Generally, the proper value should be programmed by BIOS and
written into the ACPI HPET table as the main counter minimum tick in
periodic mode (offset 53).

We assume that value as the minimum value a delta can be in order to
reprogram the HPET successfully. For BIOSen which contain crap, we fall
back to a default value of 128 cycles which should be sensible on all
more or less sane HPET implementations.

LKML-Reference: <20101026112052.GA1672@arch.trippelsdorf.de>
Not-Yet-Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/acpi/boot.c |   10 +++++++---
 arch/x86/kernel/hpet.c      |    3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 2c392d6..01d9480 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -68,6 +68,7 @@ extern unsigned long force_hpet_address;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
 extern u8 hpet_msi_disable;
+extern u16 hpet_min_tick;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 extern void hpet_disable(void);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 71232b9..91a46bc 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -772,9 +772,6 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 		hpet_address >>= 32;
 	}
 #endif
-	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx\n",
-	       hpet_tbl->id, hpet_address);
-
 	/*
 	 * Allocate and initialize the HPET firmware resource for adding into
 	 * the resource tree during the lateinit timeframe.
@@ -790,6 +787,13 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 	hpet_res->start = hpet_address;
 	hpet_res->end = hpet_address + (1 * 1024) - 1;
 
+	/* Accept only sensible values written by BIOS */
+	if (hpet_tbl->minimum_tick < hpet_min_tick)
+		hpet_min_tick = hpet_tbl->minimum_tick;
+
+	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx min tick: %d\n",
+		hpet_tbl->id, hpet_address, hpet_min_tick);
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ae03cab..a0b790a 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -40,6 +40,7 @@ u8					hpet_msi_disable;
 static unsigned long			hpet_num_timers;
 #endif
 static void __iomem			*hpet_virt_address;
+u16					hpet_min_tick = 0x80;
 
 struct hpet_dev {
 	struct clock_event_device	evt;
@@ -408,7 +409,7 @@ static int hpet_next_event(unsigned long delta,
 	 */
 	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-	return res < 8 ? -ETIME : 0;
+	return res < hpet_min_tick ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
-- 
1.7.3.1.50.g1e633




-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
