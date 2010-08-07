Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463Ab0HGCSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:18:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37863 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762458Ab0HGCSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:18:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/10] x86: Fix lapic mapping with construct ISA and visws mptable path
Date: Fri,  6 Aug 2010 19:15:34 -0700
Message-Id: <1281147343-18389-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
References: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e3b534c..980508c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1606,7 +1606,7 @@ void __init init_apic_mappings(void)
 		 * acpi lapic path already maps that address in
 		 * acpi_register_lapic_address()
 		 */
-		if (!acpi_lapic && !smp_found_config)
+		if (!acpi_lapic)
 			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 
 		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-- 
1.6.4.2

