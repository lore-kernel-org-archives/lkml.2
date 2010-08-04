Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab0HDKhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:37:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36726 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0HDKhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:37:50 -0400
To: Gleb Natapov <gleb@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
References: <201008031028.57263.tvrtko.ursulin@sophos.com>
	<201008040918.58318.tvrtko.ursulin@sophos.com>
	<4C592D60.5050309@kernel.org>
	<201008041016.09176.tvrtko.ursulin@sophos.com>
	<20100804093623.GE10499@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 03:37:43 -0700
In-Reply-To: <20100804093623.GE10499@redhat.com> (Gleb Natapov's message of "Wed\, 4 Aug 2010 12\:36\:23 +0300")
Message-ID: <m1fwyuacjs.fsf@fess.ebiederm.org>
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

Gleb Natapov <gleb@redhat.com> writes:

> On Wed, Aug 04, 2010 at 10:16:08AM +0100, Tvrtko Ursulin wrote:
>> 
>> Not the tip but 2.6.35 with earlyprintk=ttyS0,115200:
>> 
>> [    0.000000] Processor #0 (Bootup-CPU)
>> [    0.000000] I/O APIC #1 Version 17 at 0xFEC00000.
>> [    0.000000] BUG: unable to handle kernel paging request at ffffb030
>> [    0.000000] IP: [<c011d136>] native_apic_mem_read+0x16/0x20
>> [    0.000000] *pde = 00832067 *pte = 00000000
> Accessing APIC version register before APIC is mapped.

Yep. I see it now.  We have some of the silliest code.  We only
go down this path for certain revs of Intel cpus, and I double checked
this change on an AMD cpu which explains why I missed hitting this
case.

The call path that is new in they bisected commit is:
MP_ioapic_info()
  mp_register_ioapic()
   io_apic_unique_id()
     io_apic_get_unique_id()
       get_physical_broadcast()
         modern_apic()
           lapic_get_version()
             apic_read(APIC_LVR)
  

Tvrtko can you test this patch and verify it fixes the kvm booting
issue?

This patch just maps the lapic early in the mmparse.c just like we
do in acpi/boot.c when parsing the acpi tables.

Eric


---

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
 

