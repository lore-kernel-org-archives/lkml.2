Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab0HFARj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:17:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:50114 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab0HFARe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:17:34 -0400
Date: Fri, 6 Aug 2010 00:15:57 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        hilld@binarystorm.net, tglx@linutronix.de, hpa@linux.intel.com,
        tvrtko.ursulin@sophos.com, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, tvrtko.ursulin@sophos.com,
        hilld@binarystorm.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
References: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Map the local apic when parsing the MP table.
Message-ID: <tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org>
Git-Commit-ID: 5989cd6a1cbf86587edcc856791f960978087311
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 00:16:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5989cd6a1cbf86587edcc856791f960978087311
Gitweb:     http://git.kernel.org/tip/5989cd6a1cbf86587edcc856791f960978087311
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Wed, 4 Aug 2010 13:30:27 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 5 Aug 2010 16:26:42 -0700

x86, apic: Map the local apic when parsing the MP table.

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

Cc: <stable@kernel.org> 2.6.35
Reported-by: David Hill <hilld@binarystorm.net>
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
