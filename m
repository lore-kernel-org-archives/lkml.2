Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0HNUkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 16:40:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26490 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab0HNUkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 16:40:21 -0400
Message-ID: <4C66FEA9.3040303@kernel.org>
Date: Sat, 14 Aug 2010 13:38:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] x86: Don't write io_apic ID if it is not changed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For 32bit mptable path, setup_ids_from_mpc() always write io apic id
register, even there is no change needed.

So try to do that when they are different bewteen reading out and mptable

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2125,7 +2125,6 @@ void __init setup_ioapic_ids_from_mpc(vo
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
-
 		/*
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
@@ -2137,9 +2136,12 @@ void __init setup_ioapic_ids_from_mpc(vo
 						= mp_ioapics[apic_id].apicid;
 
 		/*
-		 * Read the right value from the MPC table and
-		 * write it into the ID register.
+		 * Update the ID register according to the right value from
+		 *  the MPC table if they are different.
 		 */
+		if (mp_ioapics[apic_id].apicid == reg_00.bits.ID)
+			continue;
+
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
 			mp_ioapics[apic_id].apicid);
