Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0K2PyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:54:11 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44693 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0K2PyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:54:09 -0500
Date: Mon, 29 Nov 2010 16:52:54 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        john stultz <johnstul@us.ibm.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, "avi@redhat.com" <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [PATCH -v1.1] HPET: Fix HPET readout for small deltas
Message-ID: <20101129155254.GC1170@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

v1.1 Add comment update from Markus and his S-O-B.

 arch/x86/include/asm/hpet.h |    1 +
 arch/x86/kernel/acpi/boot.c |   10 +++++++---
 arch/x86/kernel/hpet.c      |    9 +++++----
 3 files changed, 13 insertions(+), 7 deletions(-)

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
index ae03cab..cfbbc94 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -40,6 +40,7 @@ u8					hpet_msi_disable;
 static unsigned long			hpet_num_timers;
 #endif
 static void __iomem			*hpet_virt_address;
+u16					hpet_min_tick = 0x80;
 
 struct hpet_dev {
 	struct clock_event_device	evt;
@@ -402,13 +403,13 @@ static int hpet_next_event(unsigned long delta,
 	 * move us behind that point easily. Now instead of reading
 	 * the compare register back several times, we make the ETIME
 	 * decision based on the following: Return ETIME if the
-	 * counter value after the write is less than 8 HPET cycles
-	 * away from the event or if the counter is already ahead of
-	 * the event.
+	 * counter value after the write is less than hpet_min_tick
+	 * HPET cycles away from the event or if the counter is already
+	 * ahead of the event.
 	 */
 	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-	return res < 8 ? -ETIME : 0;
+	return res < hpet_min_tick ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
-- 
1.7.3.1.50.g1e633

