Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab0JXBF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:05:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072Ab0JXBFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/15] x86, apic: Fix lapic mapping with construct ISA and visws mptable path
Date: Sat, 23 Oct 2010 18:02:16 -0700
Message-Id: <1287882149-29275-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do need to set lapic mapping for them

in arch/x86/kernel/visws_quirks.c:
we only have visws_find_smp_config() to set mp_lapic_addr to APIC_DEFAULT_PHYS_BASE
visws_get_smp_config() is nop call.
default_get_smp_config/check_physptr/smp_read_mpc is not called in the path.
So smp_register_lapic_address() is not called, and lapic is not mapped.


in arch/x86/kernel/mpparse.c
if mpf->feature1 != 0, it will go through contruct_default_ISA_mptable instead
of check_phystr path, so smp_register_lapic_address is not called.

Those pathes all have smp_found_config set.

So need to remove !smp_found_config checking

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4638396..193e407 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1677,7 +1677,7 @@ void __init init_apic_mappings(void)
 		 * acpi lapic path already maps that address in
 		 * acpi_register_lapic_address()
 		 */
-		if (!acpi_lapic && !smp_found_config)
+		if (!acpi_lapic)
 			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 
 		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-- 
1.7.1

