Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1ALIwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:52:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22596 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1ALIwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:52:35 -0500
Message-ID: <4D2D6B5D.4080208@kernel.org>
Date: Wed, 12 Jan 2011 00:50:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
References: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com> <4d2654c410489a1b90@agluck-desktop.sc.intel.com> <AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com> <AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com> <AANLkTim6Qn5Ttc9w673c1jrT0dObm8x_Osvbf9Vhjfys@mail.gmail.com> <20110112082820.GC9868@elte.hu>
In-Reply-To: <20110112082820.GC9868@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 12:28 AM, Ingo Molnar wrote:
> 
> * Tony Luck <tony.luck@intel.com> wrote:
> 
>> On Thu, Jan 6, 2011 at 4:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Assume Tony will have another patch for IA64 to check that before
>>> apply this patch.
>>
>> Ingo,
>>
>> Ok, I sent (a slightly modified version of) this patch up to Linus
>> as part of the ia64 merge window pull ... so it is safe to update
>> drivers/acpi/numa.c with a patch that will parse all the SRAT cpu
>> entries down to ia64 now.
> 
> Thanks Tony!
> 
> Since the original commit d3bd058 is already upstream i suspect we should be fine 
> all around, right?

he mean this one:

Untested on X86.  Builds and boots on ia64 (both normally and with
maxcpus=8 to limit the number of cpus).

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

I left the comment ... though it might need some tweaking as it is
kind of tenuously connected to the '0' argument passed to acpi_table_parse_srat.

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index d9926af..5eb25eb 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -275,23 +275,19 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 int __init acpi_numa_init(void)
 {
 	int ret = 0;
-	int nr_cpu_entries = nr_cpu_ids;
 
-#ifdef CONFIG_X86
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
 	 * SRAT cpu entries could have different order with that in MADT.
 	 * So go over all cpu entries in SRAT to get apicid to node mapping.
 	 */
-	nr_cpu_entries = MAX_LOCAL_APIC;
-#endif
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, nr_cpu_entries);
+				     acpi_parse_x2apic_affinity, 0);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, nr_cpu_entries);
+				     acpi_parse_processor_affinity, 0);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);

