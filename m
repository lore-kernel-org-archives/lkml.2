Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab0HXXVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:21:16 -0400
Received: from kroah.org ([198.145.64.141]:40914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab0HXXBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:42 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:03 2010
Message-Id: <20100824224503.465084688@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [025/114] x86, apic: Map the local apic when parsing the MP table.
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit 5989cd6a1cbf86587edcc856791f960978087311 upstream.

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

Reported-by: David Hill <hilld@binarystorm.net>
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/apic.c |    2 +-
 arch/x86/kernel/mpparse.c   |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

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
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -274,6 +274,18 @@ static void __init smp_dump_mptable(stru
 
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
@@ -295,6 +307,10 @@ static int __init smp_read_mpc(struct mp
 	if (early)
 		return 1;
 
+	/* Initialize the lapic mapping */
+	if (!acpi_lapic)
+		smp_register_lapic_address(mpc->lapic);
+
 	if (mpc->oemptr)
 		x86_init.mpparse.smp_read_mpc_oem(mpc);
 


