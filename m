Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765Ab0HDUap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:30:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60762 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934605Ab0HDUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:30:38 -0400
To: Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, Gleb Natapov <gleb@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        David Hill <hilld@binarystorm.net>
Subject: [PATCH] x86/apic: Map the local apic when parsing the MP table.
References: <201008031028.57263.tvrtko.ursulin@sophos.com>
	<20100804093623.GE10499@redhat.com> <m1fwyuacjs.fsf@fess.ebiederm.org>
	<201008041146.56406.tvrtko.ursulin@sophos.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 13:30:27 -0700
In-Reply-To: <201008041146.56406.tvrtko.ursulin@sophos.com> (Tvrtko Ursulin's message of "Wed\, 4 Aug 2010 11\:46\:55 +0100")
Message-ID: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a regression in 2.6.35 from 2.6.34, that is
present for select models of Intel cpus when people are
using an MP table.

The commit cf7500c0ea133d66f8449d86392d83f840102632
"x86, ioapic: In mpparse use mp_register_ioapic" started
calling mp_register_ioapic from MP_ioapic_info.  An extremely
simple change that was obviously correct.  Unfortunately
mp_register_ioapic did just a little more than the previous
hand crafted code and so we gained this call path.

The problem call path is:
MP_ioapic_info()
  mp_register_ioapic()
   io_apic_unique_id()
     io_apic_get_unique_id()
       get_physical_broadcast()
         modern_apic()
           lapic_get_version()
             apic_read(APIC_LVR)

Which turned out to be a problem because the local apic
was not mapped, at that point, unlike the similar point
in the ACPI parsing code.

This problem is fixed by mapping the local apic when
parsing the mptable as soon as we reasonably can.

Looking at the number of places we setup the fixmap for
the local apic, I see some serious simplification opportunities.
For the moment except for not duplicating the setting up of the
fixmap in init_apic_mappings, I have not acted on them.

The regression from 2.6.34 is tracked in bug
https://bugzilla.kernel.org/show_bug.cgi?id=16173

Cc: stable@kernel.org
Reported-by: David Hill <hilld@binarystorm.net>
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 arch/x86/kernel/mpparse.c   |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a96489e..c07e513 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1606,7 +1606,7 @@ void __init init_apic_mappings(void)
 		 * acpi lapic path already maps that address in
 		 * acpi_register_lapic_address()
 		 */
-		if (!acpi_lapic)
+		if (!acpi_lapic && !smp_found_config)
 			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 
 		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d86dbf7..d7b6f7f 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -274,6 +274,18 @@ static void __init smp_dump_mptable(struct mpc_table *mpc, unsigned char *mpt)
 
 void __init default_smp_read_mpc_oem(struct mpc_table *mpc) { }
 
+static void __init smp_register_lapic_address(unsigned long address)
+{
+	mp_lapic_addr = address;
+
+	set_fixmap_nocache(FIX_APIC_BASE, address);
+	if (boot_cpu_physical_apicid == -1U) {
+		boot_cpu_physical_apicid  = read_apic_id();
+		apic_version[boot_cpu_physical_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
+	}
+}
+
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
@@ -295,6 +307,10 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	if (early)
 		return 1;
 
+	/* Initialize the lapic mapping */
+	if (!acpi_lapic)
+		smp_register_lapic_address(mpc->lapic);
+
 	if (mpc->oemptr)
 		x86_init.mpparse.smp_read_mpc_oem(mpc);
 
-- 
1.6.5.2.143.g8cc62

