Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab0JXBFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:05:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48353 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188Ab0JXBFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:40 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/15] x86, x2apic: Don't map lapic addr for preenabled x2apic
Date: Sat, 23 Oct 2010 18:02:26 -0700
Message-Id: <1287882149-29275-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If x2apic is reenabled, and used in kernel, We don't need to map that lapic
address. That mapping will never be used.

So just skip that in smp_register_lapic_address()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2cfa622..d286db1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1687,9 +1687,11 @@ void __init smp_register_lapic_address(unsigned long address)
 
 	mp_lapic_addr = address;
 
-	set_fixmap_nocache(FIX_APIC_BASE, address);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, mp_lapic_addr);
+	if (!x2apic_mode) {
+		set_fixmap_nocache(FIX_APIC_BASE, address);
+		apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+			    APIC_BASE, mp_lapic_addr);
+	}
 	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = read_apic_id();
 		apic_version[boot_cpu_physical_apicid] =
-- 
1.7.1

