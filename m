Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0JXBGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:06:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48244 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab0JXBFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:05:08 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/15] x86, apic: Don't write io_apic ID if it is not changed
Date: Sat, 23 Oct 2010 18:02:15 -0700
Message-Id: <1287882149-29275-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 32bit mptable path, setup_ids_from_mpc() always write io apic id
register, even there is no change needed.

So try to do that when they are different bewteen reading out and mptable

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ce3c6fb..0579b3b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2006,7 +2006,6 @@ void __init setup_ioapic_ids_from_mpc(void)
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
-
 		/*
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
@@ -2018,9 +2017,12 @@ void __init setup_ioapic_ids_from_mpc(void)
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
-- 
1.7.1

