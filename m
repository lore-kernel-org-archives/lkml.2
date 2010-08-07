Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab0HGBIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:08:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41842 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0HGBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:08:14 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tvrtko.ursulin@sophos.com,
        hilld@binarystorm.net, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Map the local apic when parsing the MP table.
References: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
	<tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org>
	<4C5CA3E4.1080908@kernel.org> <4C5CA5AC.3060608@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Aug 2010 18:08:05 -0700
In-Reply-To: <4C5CA5AC.3060608@zytor.com> (H. Peter Anvin's message of "Fri\, 06 Aug 2010 17\:15\:40 -0700")
Message-ID: <m1d3tvtekq.fsf@fess.ebiederm.org>
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

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 08/06/2010 05:08 PM, Yinghai Lu wrote:
>> this change is not needed, it will break:
>> 1. found mptable, but is using default contruct path.
>> 2. visws path, found found mptable, but get_smp_conf is not called.
>> 
>> YH
>
> I'm not sure the above is decipherable.  Please provide an incremental
> patch with a more detailed description.

YH was saying I overoptimized, and it looks like he is right,
although there are only one or two machines in existence that
are likely to be affected.

Untested patch to remove the cleverness below.  It it boots all
is well.

---

From: Eric W. Biederman <ebiederm@xmission.com>
Date: Fri, 6 Aug 2010 18:00:12 -0700
Subject: [PATCH] x86/apic:  Always map the local apic in init_apic_mappings.

In all of the common cases we currently map the local apic before
we get to init_apic_mappings.  Unfortunately there are still a few
weird subarch code paths that require us to map the local apic in
init_apic_mappings, and those subarchitectures set smp_found_config.

So just unconditionally run the fixmap code, and stop being clever.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/apic/apic.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c07e513..ad96090 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1603,11 +1603,16 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 		/*
-		 * acpi lapic path already maps that address in
-		 * acpi_register_lapic_address()
+		 * acpi and mptable paths already fixmap mp_lapic_addr
+		 * at FIX_APIC_BASE but perform the fixmap anyway
+		 * because our initialization code is spaghetti and
+		 * there are weird subarchitectures that do something
+		 * different.  The double fixmap isn't particularly
+		 * expensive and always running the code should prevent
+		 * bitrot.
+		 *
 		 */
-		if (!acpi_lapic && !smp_found_config)
-			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+		set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 
 		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
 					APIC_BASE, apic_phys);
-- 
1.6.5.2.143.g8cc62

