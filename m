Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317Ab0HGAw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:52:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40052 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0HGAwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:52:53 -0400
Message-ID: <4C5CAE28.6020704@kernel.org>
Date: Fri, 06 Aug 2010 17:51:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        tvrtko.ursulin@sophos.com, hilld@binarystorm.net, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Map the local apic when parsing the
 MP table.
References: <m1eiee86jg.fsf_-_@fess.ebiederm.org> <tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org> <4C5CA3E4.1080908@kernel.org> <4C5CA5AC.3060608@zytor.com>
In-Reply-To: <4C5CA5AC.3060608@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 05:15 PM, H. Peter Anvin wrote:
> On 08/06/2010 05:08 PM, Yinghai Lu wrote:
>> this change is not needed, it will break:
>> 1. found mptable, but is using default contruct path.
>> 2. visws path, found found mptable, but get_smp_conf is not called.
>>
>> YH
> 
> I'm not sure the above is decipherable.  Please provide an incremental
> patch with a more detailed description.
> 
please check

[PATCH] x86: Fix lapic mapping with construct ISA and visws mptable path

do need to set lapic mapping for them

in arch/x86/kernel/visws_quirks.c:
we only have visws_find_smp_config() to set mp_lapic_addr to APIC_DEFAULT_PHYS_BASE
visws_get_smp_config() is nop call.
default_get_smp_config/check_physptr/smp_read_mpc is not called in the path.
So smp_register_lapic_address() is not called, and lapic is not mapped.


in arch/x86/kernel/mpparse.c
if mpf->feature1 != 0, it will go through contruct_default_ISA_mptable instead
of check_phystr path, so smp_register_lapic_address is not called.

those two path all have smp_found_config set.

So let remove !smp_found_config checking

Actually set fixmap two times does not hurt.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1606,7 +1606,7 @@ void __init init_apic_mappings(void)
 		 * acpi lapic path already maps that address in
 		 * acpi_register_lapic_address()
 		 */
-		if (!acpi_lapic && !smp_found_config)
+		if (!acpi_lapic)
 			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 
 		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
